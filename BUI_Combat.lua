--DAMAGE MANAGEMENT COMPONENT
local Element={
	[0]="None",
	[1]="Generic",
	[2]="Physical",
	[3]="Fire",
	[4]="Shock",
	[5]="Oblivion",
	[6]="Cold",
	[7]="Earth",
	[8]="Magic",
	[9]="Drown",
	[10]="Diesease",
	[11]="Poison"
	}
local AdditionalAbilityName={
	[16688]=" (Bow)",[17173]=" (Bow)",
	[16499]=" (Dual)",[17169]=" (Dual Right))",
	[16037]=" (Two hand)",[17162]=" (Two Hand)",[17163]=" (Two Hand)",
	[15435]=" (One hand)",[15829]=" (One Hand)",
	}
local Multy_element={}
--[[
local function Targets_Init()	--TARGETS REPORT
	local Targets	=BUI.UI.Control(	"BUI_Targets",					BanditsUI,	{390,200},				BUI.Vars.BUI_Targets,			true)
	Targets.backdrop	=BUI.UI.Backdrop(	"BUI_Targets_BG",					Targets,	"inherit",				{CENTER,CENTER,0,0},			{0,0,0,0.25}, {0,0,0,0}, nil, false)
--	Targets:SetAlpha(1)
	Targets:SetMouseEnabled(true)
	Targets:SetMovable(true)
	Targets:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)

	--Headers
	Targets.namesH	=BUI.UI.Label(	"BUI_Targets_NamesHeader",			Targets,	{190,25},				{TOPLEFT,TOPLEFT,10,5},			BUI.UI.Font("standard",16,true), {1,1,1,1}, {0,1}, "Target"	, false)
	Targets.timeH	=BUI.UI.Label(	"BUI_Targets_TimeHeader",			Targets,	{45,25},				{LEFT,RIGHT,0,0,Targets.namesH},	BUI.UI.Font("standard",16,true), {1,1,1,1}, {0,1}, "Time"	, false)
	Targets.damageH	=BUI.UI.Label(	"BUI_Targets_DamageHeader",			Targets,	{90,25},				{LEFT,RIGHT,0,0,Targets.timeH},	BUI.UI.Font("standard",16,true), {1,1,1,1}, {0,1}, "Damage"	, false)
	Targets.dpsH	=BUI.UI.Label(	"BUI_Targets_DPSHeader",			Targets,	{75,25},				{LEFT,RIGHT,0,0,Targets.damageH},	BUI.UI.Font("standard",16,true), {1,1,1,1}, {0,1}, "DPS"	, false)

	--Divider
	Targets.divider	=BUI.UI.Texture(	"BUI_Targets_Divider",				Targets,	{360,8},				{TOPLEFT,TOPLEFT,20,32},		'EsoUI/Art/Miscellaneous/horizontalDivider.dds', false)
	Targets.divider:SetTextureCoords(0.181640625, 0.818359375, 0, 1) Targets:SetDrawLayer(DL_OVERLAY)

	--List
	Targets.names	=BUI.UI.Label(	"BUI_Targets_Names",				Targets,	{190,600},				{TOPLEFT,TOPLEFT,10,40},		BUI.UI.Font("standard",16,true), {1,1,1,1}, {0,0}, "names"	, false)
	Targets.time	=BUI.UI.Label(	"BUI_Targets_Time",				Targets,	{45,600},				{LEFT,RIGHT,0,0,Targets.names},	BUI.UI.Font("standard",16,true), {1,1,1,1}, {0,0}, "time"	, false)
	Targets.damage	=BUI.UI.Label(	"BUI_Targets_Damage",				Targets,	{90,600},				{LEFT,RIGHT,0,0,Targets.time},	BUI.UI.Font("standard",16,true), {1,1,1,1}, {0,0}, "damage"	, false)
	Targets.dps		=BUI.UI.Label(	"BUI_Targets_DPS",				Targets,	{75,600},				{LEFT,RIGHT,0,0,Targets.damage},	BUI.UI.Font("standard",16,true), {1,1,1,1}, {0,0}, "dps"	, false)
end

local TargetsWindowUpdated
local function TargetsDeveloperWindowUpdate()
	if not BUI.Vars.DeveloperMode then return end
	if GetGameTimeMilliseconds()-TargetsWindowUpdated<500 then return end
	TargetsWindowUpdated=GetGameTimeMilliseconds()
	local parent=BUI_Targets
	local data=BUI.Stats.GroupLog
	--Setup labels
	local fighttime=(BUI.Stats.Current[BUI.ReportN].endTime-BUI.Stats.Current[BUI.ReportN].startTime)/1000
	local names		=""
	local time		=""
	local damage	=""
	local dps		=""
	local targets	=0
	local color="|cFEFEFE"
	--Print to the targets window
	for i in pairs(data) do
		if BUI.GroupMembers[i] then color="|cEEEE33" data[i].name=BUI.GroupMembers[i]
		elseif BUI.Player.id==i then color="|cEE3333" data[i].name=BUI.Player.name
		else
			targets=targets+1
			names		=names..color..string.sub(zo_strformat("<<!aC:1>>",data[i].name),0,26).."|r\n"
			time		=time..ZO_FormatTime(fighttime ,SI_TIME_FORMAT_TIMESTAMP).."\n"
			damage	=damage..BUI.DisplayNumber(data[i].dmg).."\n"
			dps		=dps..BUI.DisplayNumber(data[i].dmg/fighttime).."\n"
		end
	end
	--Apply labels
	parent.names:SetText(names)
	parent.time:SetText(time)
	parent.damage:SetText(damage)
	parent.dps:SetText(dps)
	--Update height
	local height=50
	if targets<28 then height=50+(targets * 21) else height=50+(28*21) end
	parent:SetHeight(height) parent.backdrop:SetHeight(height) parent:SetHidden(targets==0)
	if not BUI.TargetsWinowLoop then BUI.TargetsWinowLoop=true BUI.CallLater("TargetsWinow",8000,function() BUI.TargetsWinowLoop=false parent:SetHidden(true) end) end
end
--]]
function BUI.Damage.Attackers_UI()	--UI init
	local ch,ch1=BUI.Vars.FrameHealthColor,BUI.Vars.FrameHealthColor1
	local w,h=BUI.Vars.AttackersWidth,BUI.Vars.AttackersHeight
	local fs=math.min(BUI.Vars.RaidFontSize,h*.8)
	local theme_color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.CustomEdgeColor
	local function CrateHitAnimation(control)
		local animation, timeline=CreateSimpleAnimation(ANIMATION_COLOR,control,0)
		animation:SetColorValues(1,.8,.8,1,unpack(ch))
		animation:SetDuration(750)
		timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
		return timeline
	end

	local ui	=BUI.UI.Control(	"BUI_Attackers",				BanditsUI,	{w,h*3+8},		BUI.Vars.BUI_Attackers or {TOPLEFT,TOP,710/2,5,ZO_CompassFrame},	not (BUI.Vars.Attackers and BUI.inMenu))
	ui.backdrop	=BUI.UI.Backdrop(	"BUI_Attackers_BG",			ui,		"inherit",		{CENTER,CENTER,0,0},	{0,0,0,0.4}, {0,0,0,1}, nil, true)
	ui.label	=BUI.UI.Label(	"BUI_Attackers_Label",			ui.backdrop,	"inherit",	{CENTER,CENTER,0,0},	BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("Attackers"))
	ui:SetDrawTier(DT_HIGH)
	ui:SetMovable(true)
	ui:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)

	local anchor	={TOPLEFT,TOPLEFT,0,0,ui}
	for i=1, 10 do
		ui[i]		=BUI.UI.Backdrop("BUI_Attackers"..i.."_Health",		ui,		{w,h},		anchor,			{0,0,0,1}, theme_color, nil, not (i==1 and BUI.inMenu)) ui[i]:SetDrawTier(0)
		ui[i].bar	=BUI.UI.Statusbar("BUI_Attackers"..i.."_Bar",		ui[i],	{w-4,h-4},		{LEFT,LEFT,2,0},		ch, BUI.Textures[BUI.Vars.FramesTexture])
--		ui[i].bar:SetGradientColors(ch[1],ch[2],ch[3],ch[4],ch1[1],ch1[2],ch1[3],ch1[4])
		ui[i].name	=BUI.UI.Label(	"BUI_Attackers"..i.."_Name",		ui[i],	{w,h},		{LEFT,LEFT,8,0},		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,1}, 'Name')
		ui[i].pct	=BUI.UI.Label(	"BUI_Attackers"..i.."_Pct",		ui[i],	{w,h},		{RIGHT,RIGHT,-8,0},	BUI.UI.Font(BUI.Vars.FrameFont2,fs,true), nil, {2,1}, 'Damage')
		ui[i].hit	=CrateHitAnimation(ui[i].bar)
		anchor={TOP,BOTTOM,0,4,ui[i]}
	end
end

local function AttackersUpdate(now,unitId)
	if not BUI.Vars.Attackers then return end
	now=now or GetGameTimeMilliseconds()
	local w=BUI.Vars.AttackersWidth-4
	local t={}
	for id,data in pairs(BUI.Attacker) do
		if data.ms+10000<now then
			BUI.Attacker[id]=nil
		else
			table.insert(t,{id=id,name=data.name,ms=data.ms,value=data.value})
		end
	end
	if #t==0 then
		EVENT_MANAGER:UnregisterForUpdate("BUI_Attackers")
		BUI_Attackers:SetHidden(true)
		return
	elseif #t>3 then
		if BUI.Vars.DeveloperMode then
			if BUI.OnScreen.Message[78] then
				BUI.OnScreen.Message[78].units=#t
			else
				BUI.OnScreen.Notification(78,"Focused",nil,nil,nil,nil,#t)
			end
		end
	else
		BUI.OnScreen.Message[78]=nil
	end
	table.sort(t,function(a,b) return a.value>b.value end)
	local maxValue=t[1].value

	BUI_Attackers:SetHidden(false)
	for i=1,10 do
		if t[i] then
			BUI_Attackers[i].name:SetText(t[i].name or "Unknown")
			BUI_Attackers[i].pct:SetText(t[i].value)
			BUI_Attackers[i].bar:SetWidth(w*t[i].value/maxValue)
			BUI_Attackers[i]:SetAlpha(t[i].ms+5000>now and 1 or .5)
			BUI_Attackers[i]:SetHidden(false)
			if t[i].id==unitId then
				BUI_Attackers[i].hit:PlayFromStart()
			end
		else
			BUI_Attackers[i]:SetHidden(true)
		end
	end
	EVENT_MANAGER:RegisterForUpdate("BUI_Attackers", 1000, AttackersUpdate)
end

function BUI.Damage.New(result,abilityName,sourceName,sourceType,targetName,hitValue,powerType,damageType,sourceUnitId,targetUnitId,abilityId,isDamage)
	local now=GetGameTimeMilliseconds()
--	d(targetName.." ("..targetUnitId..") hit for "..hitValue.." by "..zo_strformat("<<!aC:1>>",sourceName).." ("..sourceUnitId..")")
	if abilityId==76325 then BUI.BladeOfWoe=now return end --Blade of Woe
	--Compute some flags
	local Outgoing=(sourceType==COMBAT_UNIT_TYPE_PLAYER or sourceType==COMBAT_UNIT_TYPE_PLAYER_PET) and targetName~=BUI.Player.name
	local isCrit=(result==ACTION_RESULT_CRITICAL_DAMAGE or result==ACTION_RESULT_CRITICAL_HEAL or result==ACTION_RESULT_DOT_TICK_CRITICAL or result==ACTION_RESULT_HOT_TICK_CRITICAL)
	local isHeal=(result==ACTION_RESULT_HEAL or result==ACTION_RESULT_CRITICAL_HEAL or result==ACTION_RESULT_HOT_TICK or result==ACTION_RESULT_HOT_TICK_CRITICAL)
	local isPower=(result==ACTION_RESULT_POWER_ENERGIZE or result==ACTION_RESULT_POWER_DRAIN)

	--Register Group Damage
	if not isPower then
		if not isHeal then
			if targetName==BUI.Player.name then	--Incoming damage
				if sourceName=="" then sourceName=BUI.Enemy[sourceUnitId] else sourceName=string.gsub(sourceName,"%^%w+","") end
				if BUI.Vars.Log then
--					if BUI.GroupMembers[targetUnitId] then targetName=BUI.GroupMembers[targetUnitId] end
					local color=isHeal and 3 or isCrit and 4 or 5
					table.insert(BUI.Log,{now,zo_strformat("<<!aC:1>>",sourceName),targetName,abilityId,result,hitValue,color})
				end
				if not BUI.Attacker[sourceUnitId] then
					BUI.Attacker[sourceUnitId]={name=sourceName,ms=now,value=hitValue}
				else
					BUI.Attacker[sourceUnitId].value=BUI.Attacker[sourceUnitId].value+hitValue
					BUI.Attacker[sourceUnitId].ms=now
				end
				AttackersUpdate(now,(result==ACTION_RESULT_CRITICAL_DAMAGE or result==ACTION_RESULT_DAMAGE) and sourceUnitId or nil)
			elseif BUI.GroupMembers[targetUnitId]==nil then
				BUI.Stats.GroupLog.Damage.Total=BUI.Stats.GroupLog.Damage.Total+hitValue
--[[				--Targets developer dindow
				if (BUI.Stats.GroupLog.Damage[targetUnitId]==nil) then
					BUI.Stats.GroupLog.Damage[targetUnitId]={["name"]=targetName,["dmg"]=hitValue}
					--d(targetName.." ("..targetUnitId..") hit for "..hitValue.." by '"..zo_strformat("<<!aC:1>>",sourceName).."'")
				else
					BUI.Stats.GroupLog.Damage[targetUnitId].name=(targetName~="") and targetName or BUI.Stats.GroupLog.Damage[targetUnitId].name
					BUI.Stats.GroupLog.Damage[targetUnitId].dmg=BUI.Stats.GroupLog.Damage[targetUnitId].dmg+hitValue
					--d(targetName.." ("..targetUnitId..") hit for "..hitValue.." by '"..zo_strformat("<<!aC:1>>",sourceName).."' total "..BUI.Stats.GroupLog.Damage[targetUnitId].dmg)
				end
				BUI.Damage:TargetsDeveloperWindowUpdate()
--]]
			end
		elseif (targetName==BUI.Player.name or BUI.GroupMembers[targetUnitId]) then
			BUI.Stats.GroupLog.Healing.Total=BUI.Stats.GroupLog.Healing.Total+hitValue
--			d(targetName.." ("..targetUnitId..") heal for "..hitValue.." by '"..zo_strformat("<<!aC:1>>",sourceName).."' total "..BUI.Stats.GroupLog.Healing.Total)
		end
	end

	--Debugging
--	d(result .. " || " .. sourceType .. " || " .. sourceName .. " || " .. targetName .. " || " .. abilityName .. " || " .. hitValue)
--[[
	--Misses and Dodges
	if (result==ACTION_RESULT_DODGED or result==ACTION_RESULT_MISS) then
	--Crowd Controls
	elseif (result==ACTION_RESULT_INTERRUPT or result==ACTION_RESULT_STUNNED or result==ACTION_RESULT_OFFBALANCE or result==ACTION_RESULT_DISORIENTED or result==ACTION_RESULT_STAGGERED or result==ACTION_RESULT_FEARED or result==ACTION_RESULT_SILENCED or result==ACTION_RESULT_ROOTED) then
	--Target Death
	elseif (result==ACTION_RESULT_DIED or result==ACTION_RESULT_DIED_XP) then
	--DEBUG NEW EVENTS
	elseif (result==ACTION_RESULT_EFFECT_FADED and BUI.Vars.DeveloperMode) then
		local _name=" ["..abilityId.."]"..abilityName local direction=damageIn and "Incoming" or "Outgoing"
		d(direction .. " effect faded: " .. targetName .. " Value: " .. hitValue.._name)
	elseif (result==ACTION_RESULT_EFFECT_GAINED and BUI.Vars.DeveloperMode) then
		local _name=" ["..abilityId.."]"..abilityName local direction=damageIn and "Incoming" or "Outgoing"
		d(direction .. " effect gained: " .. targetName .. " Value: " .. hitValue.._name)
	elseif (result==ACTION_RESULT_EFFECT_GAINED_DURATION and BUI.Vars.DeveloperMode) then
		local _name=" ["..abilityId.."]"..abilityName local direction=damageIn and "Incoming" or "Outgoing"
		d(direction .. " effect duration: " .. targetName .. " Value: " .. hitValue.._name)
		if abilityId==21230 then BUI.Actions.EnchantmentBerserk=true end
	elseif (hitValue>4 and BUI.Vars.DeveloperMode) then
		--Prompt other unrecognized
		local direction=Outgoing and "Outgoing" or "Incoming"
		d(direction .. " result " .. result .. " not recognized! Target: " .. targetName .. " Value: " .. hitValue)
	end
--]]
	--Statistics
	if	(isDamage and Outgoing) or	--Damage dealt
		(isDamage and targetName==BUI.Player.name) or	--Damage received
		(isPower and targetName==BUI.Player.name) or	--Power gain
		(isHeal and (sourceType==COMBAT_UNIT_TYPE_PLAYER or sourceType==COMBAT_UNIT_TYPE_PLAYER_PET)) then	--Healing dealt
		--InCombatReticle
		if isDamage then	--BUI.Vars.InCombatReticle and
			BUI.Damage.last=now
--			if (now-BUI.Damage.last-10000)>0 then
--				d("["..abilityId.."] "..abilityName.."||"..tostring(sourceName).."||"..tostring(targetName).."||"..tostring(sourceType))
--				BUI.Damage.last=now BUI.InCombatReticle(true) else BUI.Damage.last=now end
		end
		--Flag timestamps
--		if Outgoing then BUI.Damage.lastOut=now else BUI.Damage.lastIn=now end
		--Split elements
		if BUI.Vars.StatsSplitElements then if damageType~=2 and Multy_element[abilityName] then abilityName=abilityName.." ("..Element[damageType]..")" end
		else if Multy_element[abilityName] then damageType=DAMAGE_TYPE_MAGIC end end
		if AdditionalAbilityName[abilityId] then abilityName=abilityName..AdditionalAbilityName[abilityId] end
		--Statistics
		BUI.Stats.RegisterDamage({
			out		=Outgoing,
			target	=targetName,
			source	=sourceName,
			ability	=abilityName,
			value		=hitValue,
			powerType	=powerType,
			ms		=now,
			crit		=isCrit,
			heal		=isHeal,
			power		=isPower,
			damageType	=damageType,
			id		=abilityId,
		})
	end
end

function BUI.Damage.Initialize()
	--Set up initial timestamps
--	BUI.Damage.lastIn	=0
--	BUI.Damage.lastOut=0
	BUI.Damage.last=0
	local attacks={
		--Multy element attacks
		7880,				--Light Attack
		7095,				--Heavy Attack
		48991,46340,48971,	--Force Shock
		80526,			--Ilambris
		}
	for i=1, #attacks do Multy_element[GetAbilityName(attacks[i])]=true end
	BUI.Damage.Attackers_UI()
end
