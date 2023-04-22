local action_result={
--Effects
[ACTION_RESULT_BEGIN]="(|cCCCC00start|r)",
[ACTION_RESULT_EFFECT_GAINED]="(|cCC8800gain|r) ",
[ACTION_RESULT_EFFECT_GAINED_DURATION]="(|cCC4400durat|r)",
[ACTION_RESULT_EFFECT_FADED]="(|c888888faded|r)",
[ACTION_RESULT_INTERRUPT]="(|cCCCC00stop|r) ",
[ACTION_RESULT_DIED]="(|cCC0000dead|r) ",
[ACTION_RESULT_DIED_XP]="(|cCC0000dead|r) ",
[ACTION_RESULT_STUNNED]="(|cCC0000stun|r) ",
--Damage
[ACTION_RESULT_DAMAGE]="(|cCC0000hit|r)    ",
[ACTION_RESULT_DOT_TICK]="(|cCC0000dot|r)    ",
[ACTION_RESULT_BLOCKED_DAMAGE]="(|cCC0000block|r)",
[ACTION_RESULT_DAMAGE_SHIELDED]="(|c4444CCward|r) ",
[ACTION_RESULT_CRITICAL_DAMAGE]="(|cEE0000hit|r)    ",
[ACTION_RESULT_DOT_TICK_CRITICAL]="(|cEE0000dot|r)    ",
		--Healing
[ACTION_RESULT_HOT_TICK]="(|cCCCC00hot|r)    ",
[ACTION_RESULT_HEAL]="(|cCCCC00heal|r) ",
[ACTION_RESULT_CRITICAL_HEAL]="(|cEEEE00heal|r) ",
[ACTION_RESULT_HOT_TICK_CRITICAL]="(|cEEEE00hot|r)    ",
}
local isDamage={
[ACTION_RESULT_DAMAGE]=true,
[ACTION_RESULT_DOT_TICK]=true,
[ACTION_RESULT_BLOCKED_DAMAGE]=true,
[ACTION_RESULT_DAMAGE_SHIELDED]=true,
[ACTION_RESULT_CRITICAL_DAMAGE]=true,
[ACTION_RESULT_DOT_TICK_CRITICAL]=true,
[100]=true,
}
local isEffect={
[ACTION_RESULT_BEGIN]=true,
[ACTION_RESULT_EFFECT_GAINED]=true,
[ACTION_RESULT_EFFECT_GAINED_DURATION]=true,
[100]=true,
}
local action_color={
[0]="|cCCCCCC",--None
[1]="|c00CCCC",--Notification
[2]="|c5555CC",--On self
[3]="|cEEEE22",--Heal
[4]="|cFF8888",--Crit
[5]="|cCC8888",--Hit
}
local last_logged,target_count=0,0
local filter_player,filter_group,filter_event,filter_damage=true,false,true,true
local ROWS=15

local function GoBack(back)
	if back then
		if target_count+ROWS<#BUI.Log then
			target_count=target_count+ROWS
		end
	else
		if target_count>0 then
			target_count=target_count-ROWS if target_count<0 then target_count=0 end
		end
	end
	BUI.ShowLog(true)
end

local function UI_Init()
	local fs,s=17,1
	local w,h=800,ROWS*fs*1.36+fs*1.5
	local w1=85+55
	local w5=60
	local w2=(w-10-w1-w5)*2/10
	local w3=(w-10-w1-w5)*2/10
	local w4=(w-10-w1-w5)*6/10
	local h1=ROWS*fs*1.36
	local ui	=BUI.UI.TopLevelWindow("BUI_Log",		GuiRoot,	{w,h+30+fs*1.5},		{TOPLEFT,TOPLEFT,220,30}, false)
	ui:SetMouseEnabled(true) ui:SetMovable(true)
	ui.bg		=BUI.UI.Backdrop(	"BUI_Log_Backdrop",	ui,		{w,h+30+fs*1.5},		{CENTER,CENTER,0,0},		{0,0,0,0.7}, {0,0,0,0.9}, nil, false)
	ui.top	=BUI.UI.Statusbar("BUI_Log_Top",		ui,		{w,30},		{TOPLEFT,TOPLEFT,0,0},		{.5,.5,.5,.7}, nil, false)
	ui.top:SetGradientColors(0.4,0.4,0.4,0.7,0,0,0,0)
	ui.close	=BUI.UI.Button(	"BUI_Log_Close",		ui,		{34,34},		{TOPRIGHT,TOPRIGHT,5*s,5*s},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.close:SetNormalTexture('/esoui/art/buttons/closebutton_up.dds')
	ui.close:SetMouseOverTexture('/esoui/art/buttons/closebutton_mouseover.dds')
	ui.close:SetHandler("OnClicked", function() PlaySound("Click") BUI_Log:SetHidden(true) end)
--	ui.box	=BUI.UI.Backdrop(	"BUI_Log_Box",		ui.top,	{20,20},		{LEFT,LEFT,5*s,0},		{0,0,0,0}, {.7,.7,.5,1}, nil, false)
	ui.box	=BUI.UI.Button(	"BUI_Log_Box",		ui,		{30,30},		{TOPLEFT,TOPLEFT,5*s,0},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.box:SetNormalTexture('/esoui/art/tradinghouse/tradinghouse_listings_tabicon_up.dds')
	ui.box:SetMouseOverTexture('/esoui/art/tradinghouse/tradinghouse_listings_tabicon_over.dds')
	ui.title	=BUI.UI.Label(	"BUI_Log_Title",		ui.top,	{w,30},		{LEFT,LEFT,40*s,0},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, "Incoming events", false)
	--Content
	ui.body	=BUI.UI.Backdrop(	"BUI_Log_Bg",		ui.top,	{w,h+2},		{TOPLEFT,BOTTOMLEFT,0,-2},	{0,0,0,0}, {.7,.7,.5,.3}, nil, false)
	ui.header	=BUI.UI.Backdrop(	"BUI_Log_Header",		ui.top,	{w-10,fs*1.2},	{TOPLEFT,BOTTOMLEFT,5,3},{.4,.4,.4,.3}, {0,0,0,0}, nil, false)
	ui.l1		=BUI.UI.Label(	"BUI_Log_L1",		ui.header,	{w1,fs},		{LEFT,LEFT,0,-fs*.2},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, "Time"	, false)
	ui.l2		=BUI.UI.Label(	"BUI_Log_L2",		ui.header,	{w2,fs},		{LEFT,LEFT,w1,-fs*.2},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, "From"	, false)
	ui.l3		=BUI.UI.Label(	"BUI_Log_L3",		ui.header,	{w3,fs},		{LEFT,LEFT,w1+w2,-fs*.2},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, "Target"	, false)
	ui.l4		=BUI.UI.Label(	"BUI_Log_L4",		ui.header,	{w4,fs},		{LEFT,LEFT,w1+w2+w3,-fs*.2},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, "Info"	, false)
	ui.l5		=BUI.UI.Label(	"BUI_Log_L5",		ui.header,	{w5,fs},		{RIGHT,RIGHT,0,-fs*.2},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, "Hit"	, false)

	ui.cont	=BUI.UI.Control(	"BUI_Log_Content",	ui.top,	{w-10,h1},		{TOPLEFT,BOTTOMLEFT,5,fs*1.5},	false)
	BUI.UI.Backdrop(	"BUI_Log_Bg1",	ui.cont,	{w1-2,h1-4},	{TOPLEFT,TOPLEFT,0,0},		{.4,.4,.4,.2}, {0,0,0,0}, nil, false)
	BUI.UI.Backdrop(	"BUI_Log_Bg2",	ui.cont,	{w2-2,h1-4},	{TOPLEFT,TOPLEFT,w1,0},		{.4,.4,.4,.2}, {0,0,0,0}, nil, false)
	BUI.UI.Backdrop(	"BUI_Log_Bg3",	ui.cont,	{w3-2,h1-4},	{TOPLEFT,TOPLEFT,w1+w2,0},	{.4,.4,.4,.2}, {0,0,0,0}, nil, false)
	BUI.UI.Backdrop(	"BUI_Log_Bg4",	ui.cont,	{w4-2,h1-4},	{TOPLEFT,TOPLEFT,w1+w2+w3,0},	{.4,.4,.4,.2}, {0,0,0,0}, nil, false)
	BUI.UI.Backdrop(	"BUI_Log_Bg5",	ui.cont,	{w5,h1-4},		{TOPRIGHT,TOPRIGHT,0,0},	{.4,.4,.4,.2}, {0,0,0,0}, nil, false)

	local scroll=ui.cont	--BUI.UI.Scroll(ui.cont)
	ui.c={
		BUI.UI.Label(	"BUI_Log_C1",	scroll,	{w1,h1},	{TOPLEFT,TOPLEFT,0,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false),
		BUI.UI.Label(	"BUI_Log_C2",	scroll,	{w2,h1},	{TOPLEFT,TOPLEFT,w1,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false),
		BUI.UI.Label(	"BUI_Log_C3",	scroll,	{w3,h1},	{TOPLEFT,TOPLEFT,w1+w2,0},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false),
		BUI.UI.Label(	"BUI_Log_C4",	scroll,	{w4,h1},	{TOPLEFT,TOPLEFT,w1+w2+w3,0},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false),
		BUI.UI.Label(	"BUI_Log_C5",	scroll,	{w5,h1},	{TOPRIGHT,TOPRIGHT,0,0},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false),
		}

	--Bottom
	ui.bot	=BUI.UI.Statusbar("BUI_Log_Bottom",		ui,		{w,fs*1.5},	{BOTTOMLEFT,BOTTOMLEFT,0,0},	{.65,.65,.5,.2}, nil, false)
	--Buttons
	ui.prev		=BUI.UI.Button(	"BUI_Log_Prev",			ui.bot,	{16,22},			{LEFT,LEFT,10,0},		BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.prev:SetNormalTexture('/esoui/art/charactercreate/charactercreate_leftarrow_up.dds')
	ui.prev:SetMouseOverTexture('/esoui/art/charactercreate/charactercreate_leftarrow_over.dds')
	ui.prev:SetDisabledTexture('/esoui/art/charactercreate/charactercreate_leftarrow_down.dds')
	ui.prev:SetHandler("OnClicked", function() PlaySound("Click") GoBack(true) end)
	ui.next		=BUI.UI.Button(	"BUI_Log_Next",			ui.bot,	{16,22},			{LEFT,LEFT,30,0},		BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.next:SetNormalTexture('/esoui/art/charactercreate/charactercreate_rightarrow_up.dds')
	ui.next:SetMouseOverTexture('/esoui/art/charactercreate/charactercreate_rightarrow_over.dds')
	ui.next:SetDisabledTexture('/esoui/art/charactercreate/charactercreate_rightarrow_down.dds')
	ui.next:SetHandler("OnClicked", function() PlaySound("Click") GoBack(false) end)

	ui.total	=BUI.UI.Label(	"BUI_Log_Total",		ui.bot,	{w1,fs*1.5},	{LEFT,LEFT,60,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "", false)
	--filter_player
	ui.o1		=BUI.UI.Button(	"BUI_Log_Player",		ui.bot,	{fs*1.5,fs*1.5},	{LEFT,LEFT,10+w1,0},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.o1_l	=BUI.UI.Label(	"BUI_Log_Player_L",	ui.o1,	{w2,fs*1.5},	{LEFT,RIGHT,0,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "Player",	false)
	ui.o1:SetNormalTexture(filter_player and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds")
	ui.o1:SetHandler("OnClicked", function() target_count=0 filter_player=(not filter_player) BUI_Log_Player:SetNormalTexture(filter_player and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds") BUI.ShowLog(true) end)
	--filter_group
	ui.o2		=BUI.UI.Button(	"BUI_Log_Group",		ui.bot,	{fs*1.5,fs*1.5},	{LEFT,LEFT,10+w1+w2,0},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.o2_l	=BUI.UI.Label(	"BUI_Log_Group_L",	ui.o2,	{w2,fs*1.5},	{LEFT,RIGHT,0,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "Group",	false)
	ui.o2:SetNormalTexture(filter_group and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds")
	ui.o2:SetHandler("OnClicked", function() target_count=0 filter_group=(not filter_group) BUI_Log_Group:SetNormalTexture(filter_group and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds") BUI.ShowLog(true) end)
	--filter_event
	ui.o3		=BUI.UI.Button(	"BUI_Log_Event",		ui.bot,	{fs*1.5,fs*1.5},	{LEFT,LEFT,10+w1+w2+w3,0},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.o3_l	=BUI.UI.Label(	"BUI_Log_Event_L",	ui.o3,	{w2,fs*1.5},	{LEFT,RIGHT,0,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "Event",	false)
	ui.o3:SetNormalTexture(filter_event and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds")
	ui.o3:SetHandler("OnClicked", function() target_count=0 filter_event=(not filter_event) BUI_Log_Event:SetNormalTexture(filter_event and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds") BUI.ShowLog(true) end)
	--filter_damage
	ui.o4		=BUI.UI.Button(	"BUI_Log_Damage",		ui.bot,	{fs*1.5,fs*1.5},	{LEFT,LEFT,10+w1+w2+w3+w2,0},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.o4_l	=BUI.UI.Label(	"BUI_Log_Damage_L",	ui.o4,	{w2,fs*1.5},	{LEFT,RIGHT,0,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "Damage",	false)
	ui.o4:SetNormalTexture(filter_damage and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds")
	ui.o4:SetHandler("OnClicked", function() target_count=0 filter_damage=(not filter_damage) BUI_Log_Damage:SetNormalTexture(filter_damage and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds") BUI.ShowLog(true) end)
	--filter_detailed
	ui.o5		=BUI.UI.Button(	"BUI_Log_Detailed",	ui.bot,	{fs*1.5,fs*1.5},	{LEFT,LEFT,10+w1+w2+w3+w2+w2,0},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.o5_l	=BUI.UI.Label(	"BUI_Log_Detailed_L",	ui.o5,	{w2,fs*1.5},	{LEFT,RIGHT,0,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "Detailed",	false)
	ui.o5:SetNormalTexture(BUI.DetailedLog and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds")
	ui.o5:SetHandler("OnClicked", function() BUI.DetailedLog=not BUI.DetailedLog BUI_Log_Detailed:SetNormalTexture(BUI.DetailedLog and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds") end)
end

function BUI.ShowLog(update)
	if BUI_Log and BUI_Log:IsHidden()==false then
		if not update then BUI_Log:SetHidden(true) SCENE_MANAGER:SetInUIMode() return end	--last_logged==#BUI.Log
	else
		if not BUI_Log then UI_Init() else BUI_Log:SetHidden(false) end
		target_count=0
	end

	local fs,s=17,1
	local c={"","","","",""}
	local internal_count,count,total=0,0,#BUI.Log
	for i=total,1,-1 do
		local data=BUI.Log[i]
		--Filters
		local isPlayer=(data[3]==BUI.Player.name or data[3]==BUI.Player.accname)
		if ((filter_player and isPlayer) or (filter_group and not isPlayer))
		and ((filter_event and isEffect[data[5]]) or (filter_damage and isDamage[data[5]])) then
			if count>=target_count then
				local name=BUI.Group[data[3]] and BUI.Group[data[3]].accname or data[3]
				name=isPlayer and "|cCC8888"..string.sub(name,0,12).."|r" or string.sub(name,0,12)
				c[1]=BUI.TimeStamp(data[1])..((isEffect[data[5]] and (data[6] and data[6]>=100)) and " |cCCCC00"..BUI.TimeStamp(data[6]) or "").."|r"..(internal_count>0 and "\n"..c[1] or "")
				c[2]=string.sub(data[2],0,13)..(internal_count>0 and "\n"..c[2] or "")
				c[3]=name..(internal_count>0 and "\n"..c[3] or "")
				c[4]=(
					type(data[4])=="string" and data[4]
					or (action_result[data[5]] or "").." ["..data[4].."] "..(action_color[data[7]] or "")..GetAbilityName(data[4]).."|r"
					)..(internal_count>0 and "\n"..c[4] or "")
				c[5]=(isDamage[data[5]] and (data[7]==4 and action_color[data[7]]..data[6].."|r" or data[6]) or "")..(internal_count>0 and "\n"..c[5] or "")
				internal_count=internal_count+1 if internal_count>=ROWS then break end
			end
			count=count+1
		end
	end
	last_logged=#BUI.Log
	for i=1,5 do
		BUI_Log.c[i]:SetText(c[i])
--		BUI_Log.c[i]:SetHeight((internal_count+1)*fs*1.34)
	end
	BUI_Log_Total:SetText(math.ceil((last_logged-target_count)/ROWS).."/"..math.ceil(last_logged/ROWS))
end