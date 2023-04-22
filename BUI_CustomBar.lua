local UltimateSlot=ZO_ActionBar_GetButton(8)
local LeaderCommands={
	{enable=false,mess="Come to the crown",text="",icon="/esoui/art/icons/ability_warrior_021.dds"},
	{enable=false,mess="Start fight",	text="",icon="/esoui/art/icons/ability_warrior_018.dds"},
	{enable=false,mess="Wipe",		text="",icon="/esoui/art/icons/ability_mage_019.dds"},
	{enable=false,mess="Break 2 min",	text="2",icon="/esoui/art/icons/ability_mage_044.dds"},
	{enable=false,mess="Break 5 min",	text="5",icon="/esoui/art/icons/ability_mage_044.dds"},
	{enable=false,mess="Break 10 min",	text="10",icon="/esoui/art/icons/ability_mage_044.dds"},
--	{enable=false,mess="Place marker 1",	text="1",icon="/esoui/art/icons/housing_gen_inc_soulgemdoormarkerssmall002.dds"},
--	{enable=false,mess="Place marker 2",	text="2",icon="/esoui/art/icons/housing_gen_inc_soulgemdoormarkerssmall002.dds"},
}
local SlashCommands={
	--ReloadUI
	{enable=true,command="/reloadui",icon="/esoui/art/mounts/ridingskill_ready.dds"},
	--Recruit
	{enable=false,command="/script StartChatInput('/z Guild [name] recruits new members!')",icon="/esoui/art/icons/ability_warrior_010.dds"},
	--Dance
	{enable=false,command="/dancedunmer",icon="/esoui/art/icons/ability_mage_066.dds"},
	--CompassFrame
	{enable=true,command="/script ZO_CompassFrame:SetHidden(not ZO_CompassFrame:IsHidden())",icon="/esoui/art/icons/ability_rogue_062.dds"},
	--Mimewall
	{enable=false,command="/mimewall",icon="/esoui/art/icons/emote_mimewall.dds"},
	--GemStone
	{enable=true,command="/script UseCollectible(336)",icon="/esoui/art/icons/quest_gemstone_tear_0002.dds"},
	--Jumptoleader
	{enable=false,command="/jumptoleader",icon="/esoui/art/tutorial/gamepad/gp_playermenu_icon_store.dds"},
	--Whisper target
	{enable=false,command="/script zo_callLater(function() local name=GetUnitDisplayName('reticleover') if name then StartChatInput('/w '..name..' ') else a('No target') end end,100)",icon="esoui/art/tutorial/chat-notifications_up.dds"},
	--Stolen items
	{enable=false,command="/script d(AreAnyItemsStolen(BAG_BACKPACK) and 'Have stolen items' or 'Have no stolen items')",icon="/esoui/art/inventory/gamepad/gp_inventory_icon_stolenitem.dds"},
	--Purge
	{enable=false,command="/script local _,i=GetAbilityProgressionXPInfoFromAbilityId(40232) local _,m,r=GetAbilityProgressionInfo(i) local _,_,index=GetAbilityProgressionAbilityInfo(i,m,r) CallSecureProtected('SelectSlotAbility', index, 3)",icon="/esoui/art/icons/ability_ava_005_a.dds"},
	--Widgets
	{enable=false,command="/script BUI.Vars.EnableWidgets=not BUI.Vars.EnableWidgets BUI.Frames.Widgets_Init() d('Widgets are now '..(BUI.Vars.EnableWidgets and '|c33EE33enabled|r' or '|EE3333disabled|r'))",icon="/esoui/art/progression/morph_up.dds"},
	--Text sample
	{enable=false,command="/script local text='Another sample'd(text) a(text)",icon="Text"},
--	/script BUI.Vars.CustomBar.Enable=true BUI.Vars.CustomBar.Slash[12]={enable=true,icon="/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_ava.dds",command="/script BUI.OnScreen.Notification(11,'Traveling to Guild Hall',nil,8000) JumpToHouse('@SiameseCat')"} BUI.CustomBarUpdate()
}
local BarContent={}

do	--Default
	local t={Enable=false,Leader={},Slash={}}
	for i,data in pairs(LeaderCommands) do t.Leader[i]=data.enable end
	for i,data in pairs(SlashCommands) do t.Slash[i]=data end
	BUI:JoinTables(BUI.Defaults.CustomBar,t)
end

local function UpdateContent()
	BarContent={}
	if BUI.Player.isLeader or BUI.inMenu then
		for i,data in pairs(LeaderCommands) do
			if BUI.Vars.CustomBar.Leader[i] then table.insert(BarContent,{leader=true,command=i,text=data.text,icon=data.icon}) end
		end
	end
	for i in pairs(SlashCommands) do
		if BUI.Vars.CustomBar.Slash[i].enable then
			local icon=tostring(BUI.Vars.CustomBar.Slash[i].icon)
			table.insert(BarContent,{
			command=BUI.Vars.CustomBar.Slash[i].command,
			text=string.len(icon)<5 and icon or "",
			icon=string.len(icon)>10 and icon or nil
			})
		end
	end
end

local function GetKeyBind(i)
	if i>6 then return i end
	local keyname="BUI_CUSTOMSLOT_"..i
	local modifier=""
	local l,c,a=GetActionIndicesFromName(keyname)
	if l~=nil then
		local key,m1,m2,m3,m4=GetActionBindingInfo(l,c,a,1)
		if key~=KEY_INVALID then
			local mod={
			ZO_Keybindings_DoesKeyMatchAnyModifiers(KEY_SHIFT,m1,m2,m3,m4),
			ZO_Keybindings_DoesKeyMatchAnyModifiers(KEY_CTRL,m1,m2,m3,m4),
			ZO_Keybindings_DoesKeyMatchAnyModifiers(KEY_ALT,m1,m2,m3,m4),
			}
			if mod[1] then modifier=modifier.."Shift+" end
			if mod[2] then modifier=modifier.."CTRL+" end
			if mod[3] then modifier=modifier.."ALT+" end
			return modifier..GetKeyName(key)
		end
	end
	return i
end

function BUI.CustomBarUpdate(theme,slots,parent)
	local theme_color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.Theme>3 and BUI.Vars.CustomEdgeColor or {1,1,1,1}
	if theme then
		for i=1,20 do
			if BUI_CustomBar[i] then
				BUI_CustomBar[i].edge:SetTexture(BUI.abilityframe)
				BUI_CustomBar[i].edge:SetColor(unpack(theme_color))
			end
		end
		return
	end
	UpdateContent()
	slots=slots or #BarContent
	local half		=slots>5 or (slots%2==0 and slots>2)
	local space		=2
	local h		=UltimateSlot.slot:GetHeight()*(half and .5 or 1)-(half and space/2 or 0)
	local height	=h*(half and .5 or 1)+(half and space or 0)
	local width		=(h+space)*math.ceil(slots*(half and .5 or 1))
	local anchor	=parent and {TOP,parent,BOTTOM,0,10} or {TOPLEFT,parent,TOPRIGHT,20,0}
	local ui		=BUI_CustomBar
	parent=parent or ZO_ActionBar1
	if ui then ui:SetParent(parent) else ui=WINDOW_MANAGER:CreateControl("BUI_CustomBar", parent, CT_CONTROL) end
	ui:SetDimensions(width,height)
	ui:ClearAnchors()
	ui:SetAnchor(unpack(anchor))
	ui:SetHidden(not BUI.Vars.CustomBar.Enable)
	if BUI.Vars.CustomBar.Enable then
		for i=1,slots do
			local leader=BarContent[i].leader
			local icon=BarContent[i].icon
			local command=leader and LeaderCommands[BarContent[i].command].mess or BarContent[i].command
			local row=(not half or i<=math.ceil(slots/2)) and 0 or h+space
			local col=(not half or i<=math.ceil(slots/2)) and (i-1)*(h+space) or (i-1-math.ceil(slots/2))*(h+space)
			ui[i]=BUI.UI.Control("BUI_CustomSlot"..i, ui, {h,h}, {TOPLEFT,TOPLEFT,col,row})
			ui[i].bg	=BUI.UI.Texture("BUI_CustomSlot"..i.."Bg", ui[i], {h,h}, {TOPLEFT,TOPLEFT,0,0}, "/EsoUI/Art/ActionBar/abilityInset.dds", false, 0)
			ui[i].edge	=BUI.UI.Texture("BUI_CustomSlot"..i.."Edge", ui[i], {h,h}, {TOPLEFT,TOPLEFT,0,0}, BUI.abilityframe, false, 2)
			ui[i].edge:SetColor(unpack(theme_color))
			ui[i].icon		=BUI.UI.Texture("BUI_CustomSlot"..i.."Icon", ui[i], {h-space,h-space}, {TOPLEFT,TOPLEFT,space/2,space/2}, icon, not icon, 1)
--			ui[i].status	=BUI.UI.Texture("BUI_CustomSlot"..i.."Status", ui[i], {h-space,h-space}, {TOPLEFT,TOPLEFT,space/2,space/2}, "/EsoUI/Art/ActionBar/ActionSlot_toggledon.dds", true, 2)
			ui[i].over		=BUI.UI.Texture("BUI_CustomSlot"..i.."DropCallout", ui[i], {h-space,h-space}, {TOPLEFT,TOPLEFT,space/2,space/2}, "/EsoUI/Art/ActionBar/actionBar_mouseOver.dds", true, 2)
			ui[i].text		=BUI.UI.Label("BUI_CustomSlot"..i.."Text", ui[i], {h-space*2,h-space*2}, {TOPLEFT,TOPLEFT,space,space}, BUI.UI.Font("esobold",h*.4,true), nil, {1,1}, BarContent[i].text)
			ui[i].key		=BUI.UI.Label("BUI_CustomSlot"..i.."Key", ui[i], {h,13}, {TOPLEFT,BOTTOMLEFT,0,0}, "ZoFontGameSmall", nil, {1,1}, GetKeyBind(i),half)
			ui[i].slot=i
			ui[i]:SetMouseEnabled(true)
			ui[i]:SetHandler("OnMouseDown", function(self,button)
				if button==1 then
					SCENE_MANAGER:SetInUIMode()
					BUI.UseCustomSlot(i)
--				elseif button==2 then PlaySound('Tablet_PageTurn') ClearSlot() SlotsUpdate()
				end
			end)
			ui[i]:SetHandler("OnMouseEnter", function(self)
				self.over:SetHidden(false)
				ZO_Tooltips_ShowTextTooltip(self, TOP, command)
			end)
			ui[i]:SetHandler("OnMouseExit", function(self)
				self.over:SetHidden(true)
				ZO_Tooltips_HideTextTooltip()
			end)
--			ui[i]:SetHandler('OnReceiveDrag',OnReceiveDrag)
		end
		for i=slots+1,20 do
			if ui[i] then ui[i]:SetHidden(true) end
		end
	end
end

function BUI.UseCustomSlot(i)
	if BarContent[i].leader then
		PingMap(MAP_PIN_TYPE_PING,MAP_TYPE_LOCATION_CENTERED,.765+BarContent[i].command/100,.75)
	else
		BUI.CallLater("DoCommand",200,DoCommand,BarContent[i].command)
	end
end

local function Menu_Init()
	local Panel={
		type="panel",
		name="20. |t32:32:/esoui/art/icons/achievements_indexicon_collections_up.dds|t"..BUI.Loc("CustomBarHeader"),
		displayName="20. "..BUI.Loc("CustomBarHeader"),
		}
	BUI.Menu.RegisterPanel("BUI_MenuCustomBar",Panel)

	local theme_color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.Theme>3 and BUI.Vars.CustomEdgeColor or {1,1,1,1}
	local container=WINDOW_MANAGER:CreateControlFromVirtual("BUI_MenuCustomBarContainer", BUI_MenuCustomBar, "ZO_ScrollContainer")
	container:SetAnchor(TOPLEFT, BUI_MenuCustomBar, TOPLEFT, 0, 50)
	container:SetAnchor(BOTTOMRIGHT, BUI_MenuCustomBar, BOTTOMRIGHT, 0, 0)
	BUI_MenuCustomBar.scroll=GetControl(container, "ScrollChild")
	BUI_MenuCustomBar.scroll:SetResizeToFitPadding(0, 0)
	local scroll=BUI_MenuCustomBar.scroll
	local w,h=BUI_MenuCustomBar:GetWidth(),26
	--Base settings
	local label=BUI.UI.Label(nil, scroll, {w/2-h-20,h}, {TOPLEFT,TOPLEFT,0,0}, "ZoFontWinH4", nil, {0,1}, BUI.Loc("CustomBar"))
	BUI.UI.CheckBox(nil, label, {h,h}, {LEFT,RIGHT,0,0}, BUI.Vars.CustomBar.Enable, function(value)BUI.Vars.CustomBar.Enable=value BUI.CustomBarUpdate(nil,nil,BUI_MenuCustomBar) end)
	--Leader header
	local h1,space,index=38,2,0
	local header=BUI.UI.Backdrop(nil, scroll, {w,h}, {TOPLEFT,TOPLEFT,0,h}, {.4,.4,.4,.3}, {0,0,0,0}, nil)
	BUI.UI.Label(nil, header, {w,h}, {LEFT,LEFT,10,0}, "ZoFontWinH4", nil, {1,1}, BUI.Loc("LeaderCommands"))
	local frame	=BUI.UI.Control(nil, scroll, {w,0}, {TOPLEFT,TOPLEFT,0,h*2+5},true)
	BUI.UI.SlideBox(nil, header, {22,22}, {RIGHT,RIGHT,-20,0}, true, function(self,value)
		frame:SetHeight(value and 0 or (h1+5)*3)
		frame:SetHidden(value)
	end)
	--Leader buttons
	for i,data in pairs(LeaderCommands) do
		index=index+1
		local bg	=BUI.UI.Texture(nil, frame, {h1,h1}, {TOPLEFT,TOPLEFT,math.abs(index%2-1)*w/2,math.floor((index-1)/2)*(h1+5)}, "/EsoUI/Art/ActionBar/abilityInset.dds", false, 0)
		local edge	=BUI.UI.Texture(nil, bg, {h1,h1}, {TOPLEFT,TOPLEFT,0,0}, BUI.abilityframe, false, 2) edge:SetColor(unpack(theme_color))
		BUI.UI.Texture(nil, bg, {h1-space,h1-space}, {TOPLEFT,TOPLEFT,space/2,space/2}, data.icon, (data.icon==nil or data.icon==""), 1)
		BUI.UI.Label(nil, bg, {h1-space*2,h1-space*2}, {TOPLEFT,TOPLEFT,space,space}, BUI.UI.Font("esobold",h1*.4,true), nil, {1,1}, data.text)
		local label	=BUI.UI.Label(nil, bg, {w/2-h1-30-h,h}, {LEFT,RIGHT,10,0}, "ZoFontWinH4", nil, {0,1}, data.mess)
		BUI.UI.CheckBox(nil, label, {h,h}, {LEFT,RIGHT,0,0}, BUI.Vars.CustomBar.Leader[i], function(value)BUI.Vars.CustomBar.Leader[i]=value BUI.CustomBarUpdate(nil,nil,BUI_MenuCustomBar) end)
	end
	--Custom header
	local header=BUI.UI.Backdrop(nil, scroll, {w,h}, {TOPLEFT,BOTTOMLEFT,0,0,frame}, {.4,.4,.4,.3}, {0,0,0,0}, nil)
	BUI.UI.Label(nil, header, {w,h}, {LEFT,LEFT,10,0}, "ZoFontWinH4", nil, {1,1}, BUI.Loc("CustomCommands"))
	--Custom buttons
	local h2,w2,top=h*2+10,w-h1-40-h-130,h*3+10+(h1+5)*math.ceil(index/2)
	local index=0
	local anchor={TOPLEFT,BOTTOMLEFT,0,5,header}
	for i in pairs(SlashCommands) do
		local texture=BUI.Vars.CustomBar.Slash[i].icon
		local frame	=BUI.UI.Control(nil, scroll, {w,h*2}, anchor) anchor={TOPLEFT,BOTTOMLEFT,0,5,frame}
		local bg	=BUI.UI.Texture(nil, frame, {h1,h1}, {LEFT,LEFT,0,0}, "/EsoUI/Art/ActionBar/abilityInset.dds", false, 0)
		local edge	=BUI.UI.Texture(nil, bg, {h1,h1}, {TOPLEFT,TOPLEFT,0,0}, BUI.abilityframe, false, 2) edge:SetColor(unpack(theme_color))
		local icon	=BUI.UI.Texture(nil, bg, {h1-space,h1-space}, {TOPLEFT,TOPLEFT,space/2,space/2}, texture, (texture==nil or string.len(tostring(texture))<5), 1)
		local text	=BUI.UI.Label(nil, bg, {h1-space*2,h1-space*2}, {TOPLEFT,TOPLEFT,space,space}, BUI.UI.Font("esobold",h1*.4,true), nil, {1,1}, tostring(texture),string.len(tostring(texture))>10)
		BUI.UI.CheckBox(nil, frame, {h,h}, {RIGHT,RIGHT,-20,0}, BUI.Vars.CustomBar.Slash[i].enable, function(value) BUI.Vars.CustomBar.Slash[i].enable=value BUI.CustomBarUpdate(nil,nil,BUI_MenuCustomBar) end)
		local label	=BUI.UI.Label(nil, frame, {130,h}, {TOPLEFT,TOPLEFT,h1+10,0}, "ZoFontGame", nil, {0,0}, BUI.Loc("TextureFilename"))
		BUI.UI.TextBox(nil, label, {w2,22}, {TOPLEFT,TOPLEFT,130,0}, 100, texture, function(value)
			local noIcon=string.len(value)<5
			text:SetText(value) text:SetHidden(not noIcon)
			icon:SetTexture(value) icon:SetHidden(noIcon)
			BUI.Vars.CustomBar.Slash[i].icon=value
			if BUI.Vars.CustomBar.Slash[i].enable then BUI.CustomBarUpdate(nil,nil,BUI_MenuCustomBar) end
		end)
		local label	=BUI.UI.Label(nil, frame, {130,h}, {TOPLEFT,TOPLEFT,h1+10,h}, "ZoFontGame", nil, {0,0}, BUI.Loc("SlashCommand"))
		local sbox	=BUI.UI.TextBox(nil, label, {w2-h,22}, {TOPLEFT,TOPLEFT,130,0}, 300, BUI.Vars.CustomBar.Slash[i].command, function(value)BUI.Vars.CustomBar.Slash[i].command=value end)
		BUI.UI.SlideBox(nil, label, {22,22}, {TOPLEFT,TOPLEFT,w-h1-h-62,0}, true, function(self,value)
			sbox:ClearAnchors()
			sbox:SetAnchor(TOPLEFT,label,TOPLEFT,130,0)
			sbox:SetAnchor(BOTTOMRIGHT,label,TOPLEFT,130+w2-h,value and 22 or 18*5*1.335)
			sbox.eb:SetMultiLine(not value)
			sbox.eb:SetNewLineEnabled(not value)
			if value then sbox.eb:SetHandler("OnEnter", function(self)self:LoseFocus()end)
			else sbox.eb:SetHandler("OnEnter", function()end) end
			frame:SetHeight(value and h*2 or h*2+18*4*1.335)
		end)
		index=index+1
	end

	BUI_MenuCustomBar:SetHandler("OnEffectivelyShown",function()BUI.inMenu=true BUI.CustomBarUpdate(nil,nil,BUI_MenuCustomBar) end)
	BUI_MenuCustomBar:SetHandler("OnEffectivelyHidden",function()BUI.inMenu=false BUI.CustomBarUpdate() end)
end

function BUI.CustomBar_Init()
	Menu_Init()
	BUI.CustomBarUpdate()
end

--[[
/script StartChatInput(GetCollectibleIcon(336))
--]]