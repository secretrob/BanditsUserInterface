local theme_color,s={1,.8,.9,1},100
local Meters={}
BUI.Meters={
	Default={
		Meter_Scale=120,
		BUI_Meter_Speed={BOTTOMRIGHT,BOTTOMLEFT,-10,0,ZO_ActionBar1},
		BUI_Meter_Power={CENTER,CENTER,-100,300},
		BUI_Meter_Crit={CENTER,CENTER,-300,300},
		BUI_Meter_Exp={BOTTOMLEFT,BOTTOMRIGHT,10,0,function() return (BUI_CustomBar or ZO_ActionBar1) end},
		BUI_Meter_DPS={CENTER,CENTER,100,300},
		BUI_Meter_Criminal={BOTTOMLEFT,BOTTOMRIGHT,250,0,ZO_ActionBar1},
		},
	List={"Speed","Power","Crit","Exp","DPS","Criminal"}
}

local function MeterMove(name,i)
	local frame=_G["BUI_Meter_"..name]
	if frame.state[i][1]>frame.state[i][2] then
		frame.state[i][1]=frame.state[i][1]-1
		BUI.CallLater("BUI_Meter_"..name..i,30,MeterMove,name,i)
	elseif frame.state[i][1]<frame.state[i][2] then
		frame.state[i][1]=frame.state[i][1]+1
		BUI.CallLater("BUI_Meter_"..name..i,30,MeterMove,name,i)
	end
	local a=frame.state[i][1]
	frame.line[i]:ClearAnchors()
	local x=math.sin(math.pi*a/180)*118*s
	local y=math.cos(math.pi*a/180)*118*s
	frame.line[i]:SetAnchor(TOPLEFT,frame.base,TOP,x,128*s+y)
	local x=math.sin(math.pi*a/180)*126*s
	local y=math.cos(math.pi*a/180)*126*s
	frame.line[i]:SetAnchor(BOTTOMRIGHT,frame.base,TOP,x,128*s+y)
end

local function MeterSet(name,value1,value2)
	local frame=_G["BUI_Meter_"..name]
	for i,val in pairs({value1,value2}) do
		if val then
			if val>Meters[name].max then Meters[name].max=val Meters[name].delta=val-Meters[name].min end
			frame.state[i][2]=209-math.floor((math.max(val,Meters[name].min)-Meters[name].min)/Meters[name].delta*58)
			frame.line[i]:SetHidden(false)
			MeterMove(name,i)
		else
			frame.line[i]:SetHidden(true)
		end
	end
end
--	/script BUI_Meter_Power_Line1:SetColor(.6,.6,.6,1)
Meters={
	Speed	={
		min=0,max=2000,delta=2000,color={{.6,.6,.6,1},{.9,.9,.9,1}},
		startfunc=function()
			BUI.Meters.UI_Init("Speed")
			local index,data=0,{}
			local _,lx,ly,lz=GetUnitRawWorldPosition('player')
			EVENT_MANAGER:RegisterForUpdate("BUI_Meter_Speed", 1000, function()
				local zone,x,y,z=GetUnitRawWorldPosition('player')
				local delta=math.floor(math.sqrt((lx-x)^2+(lz-z)^2))
				if delta>5000 then delta=0 end
				lx=x
				lz=z
				index=(index+1)%10
				data[index]=delta
				local avg=0
				for _,val in pairs(data) do avg=avg+val end avg=avg/#data
				BUI_Meter_Speed.value:SetText(delta)
				MeterSet("Speed",delta,avg)
			end)
		end,
		stopfunc=function()
			if BUI_Meter_Speed then BUI_Meter_Speed:SetHidden(true) end
			EVENT_MANAGER:UnregisterForUpdate("BUI_Meter_Speed")
		end
		},

	Power	={
		min=0,max=5000,delta=5000,color={{.6,.6,.6,1},{.9,.9,.9,1}},
		startfunc=function()
			local minValue=BUI.MainPower=="magicka" and GetPlayerStat(STAT_SPELL_POWER) or GetPlayerStat(STAT_POWER)
			Meters.Power.color[2]=BUI.MainPower=="magicka" and {0,.2,.96,1} or {0,.55,.12,1}
			BUI.Meters.UI_Init("Power")
			local function PowerUpdate()
				local value=BUI.MainPower=="magicka" and GetPlayerStat(STAT_SPELL_POWER) or GetPlayerStat(STAT_POWER)
				if value<minValue then minValue=value end
				BUI_Meter_Power.value:SetText(value)	--(BUI.MainPower=="magicka" and "|c5555ff" or "|c33bb33")..value.."|r")
				MeterSet("Power",minValue,value)
			end
			EVENT_MANAGER:RegisterForUpdate("BUI_Meter_Power", 2000, PowerUpdate)
		end,
		stopfunc=function()
			if BUI_Meter_Power then BUI_Meter_Power:SetHidden(true) end
			EVENT_MANAGER:UnregisterForUpdate("BUI_Meter_Power")
		end
		},

	Crit	={
		min=0,max=100,delta=100,color={{.6,.6,.6,1},{.9,.9,.9,1}},
		startfunc=function()
			local minValue=BUI.MainPower=="magicka" and GetPlayerStat(STAT_SPELL_POWER) or GetPlayerStat(STAT_POWER)
			Meters.Crit.color[2]=BUI.MainPower=="magicka" and {0,.2,.96,1} or {0,.55,.12,1}
			BUI.Meters.UI_Init("Crit")
			local function PowerUpdate()
				local value=BUI.MainPower=="magicka" and math.floor(GetPlayerStat(STAT_SPELL_CRITICAL)/219*10)/10 or math.floor(GetPlayerStat(STAT_CRITICAL_STRIKE)/219*10)/10
				if value<minValue then minValue=value end
				BUI_Meter_Crit.value:SetText(value.."%")
				MeterSet("Crit",minValue,value)
			end
			EVENT_MANAGER:RegisterForUpdate("BUI_Meter_Crit", 2000, PowerUpdate)
		end,
		stopfunc=function()
			if BUI_Meter_Crit then BUI_Meter_Crit:SetHidden(true) end
			EVENT_MANAGER:UnregisterForUpdate("BUI_Meter_Crit")
		end
		},

	Exp	={
		min=0,max=1,delta=1,
		startfunc=function()
			BUI.Meters.UI_Init("Exp")
			local function ExpUpdate()
				if (BUI.Player.level>=50) then
					local pct=math.min(BUI.Player.cxp/(GetNumChampionXPInChampionPoint(BUI.Player.clevel) or 1),1)
					BUI_Meter_Exp.value:SetText(BUI.Player.cxp)
					MeterSet("Exp",pct)
				else
					pct=math.min(BUI.Player.exp/GetUnitXPMax('player'),1)
					BUI_Meter_Exp.value:SetText(BUI.Player.exp)
					MeterSet("Exp",pct)
				end
			end
			EVENT_MANAGER:RegisterForEvent("BUI_Meter_Event", EVENT_EXPERIENCE_UPDATE, ExpUpdate)
			ExpUpdate()
		end,
		stopfunc=function()
			if BUI_Meter_Exp then BUI_Meter_Exp:SetHidden(true) end
			EVENT_MANAGER:UnregisterForEvent("BUI_Meter_Event", EVENT_EXPERIENCE_UPDATE)
		end
		},

	DPS	={
		min=0,max=10000,delta=10000,
		startfunc=function()
			BUI.Meters.UI_Init("DPS")
			EVENT_MANAGER:RegisterForUpdate("BUI_Meter_DPS", 1000, function()
				local fighttime=math.max((BUI.Stats.Current[BUI.ReportN].endTime-BUI.Stats.Current[BUI.ReportN].startTime)/1000,1)
				local dps=BUI.Stats.Current[BUI.ReportN].damage/fighttime
				BUI_Meter_DPS.value:SetText(BUI.DisplayNumber(dps))
				MeterSet("DPS",dps)
			end)
		end,
		stopfunc=function()
			if BUI_Meter_DPS then BUI_Meter_DPS:SetHidden(true) end
			EVENT_MANAGER:UnregisterForUpdate("BUI_Meter_DPS")
		end
		},

	Criminal	={
		min=0,max=1,delta=1,color={{1,.1,.1,1}},
		startfunc=function()
			BUI.Meters.UI_Init("Criminal")
			BUI_Meter_Criminal:SetHidden(true)
			local Bounty,Heat,Start=0,0,0
			local function BountyUpdate()
				local delta=GetGameTimeSeconds()-Start
				local _bounty=Bounty-delta
				local _heat=math.max(Heat-delta,0)
				if (_bounty>0) then
					BUI_Meter_Criminal.value:SetText(ZO_FormatTime(_bounty,SI_TIME_FORMAT_TIMESTAMP))
					MeterSet("Criminal",_bounty,_heat)
				else
					EVENT_MANAGER:UnregisterForUpdate("BUI_Meter_Criminal")
					BUI_Meter_Criminal:SetHidden(true)
				end
			end
			local function BountyAdded()
				Start=GetGameTimeSeconds()
				Bounty=GetSecondsUntilBountyDecaysToZero()
				Heat=GetSecondsUntilHeatDecaysToZero()
				if Bounty>0 then
					EVENT_MANAGER:RegisterForUpdate("BUI_Meter_Criminal", 1000, BountyUpdate)
					BUI_Meter_Criminal:SetHidden(false)
				end
			end
			EVENT_MANAGER:RegisterForEvent("BUI_Meter_Event", EVENT_JUSTICE_BOUNTY_PAYOFF_AMOUNT_UPDATED, BountyAdded)
			BountyAdded()
		end,
		stopfunc=function()
			if BUI_Meter_Criminal then BUI_Meter_Criminal:SetHidden(true) end
			EVENT_MANAGER:UnregisterForEvent("BUI_Meter_Event", EVENT_JUSTICE_BOUNTY_PAYOFF_AMOUNT_UPDATED)
		end
		},
--	Attributes
}

function BUI.Meters.UI_Init(name)
--	if _G["BUI_Meter_"..name.."_Panel"] then _G["BUI_Meter_"..name.."_Panel"]:SetHidden(true) end
	local fs	=14*s
	local w	=128*s
	local h	=32*s
	local color	=Meters[name].color or {}
	local ui	=BUI.UI.Control(	"BUI_Meter_"..name,		BanditsUI,	{w,h},		BUI.Vars["BUI_Meter_"..name] or BUI.Meters.Default["BUI_Meter_"..name],		false)
	ui.backdrop	=BUI.UI.Backdrop(	"BUI_Meter_"..name.."_BG",	ui,		"inherit",		{CENTER,CENTER,0,0},		{0,0,0,0.4}, {0,0,0,1}, nil, true) --ui.backdrop:SetEdgeTexture("",16,4,4)
	ui.label	=BUI.UI.Label(	"BUI_Meter_"..name.."_Label",	ui.backdrop,	"inherit",	{CENTER,CENTER,0,0},		BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("Meter_"..name))
	ui:SetAlpha(BUI.Vars.FrameOpacityOut/100)
	ui:SetDrawLayer(DT_HIGH)
	ui:SetMovable(true)
	ui:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	ui.base	=BUI.UI.Control(	"BUI_Meter_"..name.."_Panel",		ui,		{w,h},	{TOPLEFT,TOPLEFT,0,0},		false)
	ui.bg		=BUI.UI.Texture(	"BUI_Meter_"..name.."_Bg",	ui.base,	{w,h},	{TOPLEFT,TOPLEFT,0,0},		"/BanditsUserInterface/textures/meter.dds",	false,0,{0,1,.5,1})
	ui.bg:SetColor(unpack(theme_color))
	ui.border	=BUI.UI.Texture(	"BUI_Meter_"..name.."_Bord",	ui.base,	{w,h},	{TOPLEFT,TOPLEFT,0,0},		"/BanditsUserInterface/textures/meter.dds",	false,2,{0,1,0,.5})
	ui.border:SetColor(unpack(theme_color))
	ui.name	=BUI.UI.Label(	"BUI_Meter_"..name.."_Name",		ui.base,	{w,fs*1.2},	{BOTTOMLEFT,TOPLEFT,0,0},	BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {1,1}, BUI.Loc("Meter_"..name))
	ui.value	=BUI.UI.Label(	"BUI_Meter_"..name.."_Value",		ui.base,	{w,fs*1.5},	{BOTTOMLEFT,BOTTOMLEFT,0,0},	BUI.UI.Font(BUI.Vars.FrameFont1,fs*1.3,true), nil, {1,1}, "0")
	ui.line	={
			BUI.UI.Line(	"BUI_Meter_"..name.."_Line1",		ui.base,	{0,0},	{TOPLEFT,TOP,0,0}, color[1], 5*s, true),
			BUI.UI.Line(	"BUI_Meter_"..name.."_Line2",		ui.base,	{0,0},	{TOPLEFT,TOP,0,0}, color[2], 5*s, true)
		}
	for i=1,2 do ui.line[i]:SetDrawLayer(1) end
	ui.state	={{209,209},{209,209}}
end

function BUI.Meters.Initialize()
	theme_color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.CustomEdgeColor
	s=(BUI.Vars.Meter_Scale or BUI.Meters.Default.Meter_Scale)/100

	for name,data in pairs(Meters) do
		if BUI.Vars["Meter_"..name] then
			data.startfunc()
		else
			data.stopfunc()
		end
	end
end
