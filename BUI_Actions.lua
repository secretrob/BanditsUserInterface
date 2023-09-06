BUI.Actions	={
--	TargetGround	=GetString(SI_ABILITY_TOOLTIP_TARGET_TYPE_GROUND),
--	TargetSelf		=GetString(SI_TARGETTYPE2),
--	TargetEnemy		=GetString(SI_TARGETTYPE0),
--	TargetArea		=GetString(SI_ABILITY_TOOLTIP_TARGET_TYPE_AREA),
--	TargetCone		=GetString(SI_ABILITY_TOOLTIP_TARGET_TYPE_CONE),
	AbilityBar	={},
	AbilitySlots={[1]={},[2]={}},
	Defaults		={
		Actions		=true,
		ActionsPrecise	=false,
		ProcAnimation	=true,
		UseSwapPanel	=true,
		HideSwapPanel	=true,
		ExpiresAnimation	=true,
		ActionsFontSize	=16,
		ProcSound		=SOUNDS.ABILITY_ULTIMATE_READY,
		},
	}
BUI:JoinTables(BUI.Defaults,BUI.Actions.Defaults)
local IgnoreTimer={
	[114860]=true,	--Blastbones
	[117749]=true,	--Stalking Blastbones
	[117690]=true,	--Blighted Blastbones
	[46324]=true,	--Crystal Fragments
--	[34851]=true,	--Impale
--	[33291]=true,[34838]=true,[34835]=true,--Swallow Soul
	}
local IgnoreId={
	[0]=true,
	[46327]=true,	--Crystal Fragments proc
	[61932]=true,	--Assassin's Scourge
	[114716]=true,	--Crystal Fragments
	--[203447]=true,	--Bound Armaments
	[85922]=true,--Budding Seeds
	}
local ProcEffectId={
	[46327]=46324,	--Crystal Fragments proc
	[61920]=61919,	--Assasins will
	[114863]=114860,	--Blastbones
	[117750]=117749,	--Stalking Blastbones
	[117691]=117690,	--Blighted Blastbones
	[69143]=true,	--Dodge Fatigue
	[31816]=31816,	--Stone Giant
--light/heavy attack counters
	[203447]=24165,	--Bound Armaments
	[122585]=61902, -- Grim Focus
	[122586]=61919, --Merciless Resolve
	[122587]=61927, --Relentless Focus
	}
local ProcAbilityId={
	[43714]=46327,[46331]=46327,[46324]=46327,	--Crystal Fragments	
	[114860]=114863,	--Blastbones
	[117749]=117750,	--Stalking Blastbones
	[117690]=117691,	--Blighted Blastbones	
	[31816]=31816,--Stone Giant
--light/heavy attack counters
	[24165]=203447,	--Bound Armaments	
	[61902]=122585, --Grim Focus
	[61919]=122586,	--Merciless Resolve
	[61927]=122587, --Relentless Focus
	}
local UpdateCooldown=false
local RapidManeuver,AdditionalCastTime,AbilityName,QueueAbility={},{},{},nil
local AbilityEffect={
	[22265]=31759,[22262]=31759,[22259]=31759,	--Ritual
	}
local theme_color
local last_ability,last_weapon,last_swap,last_effect=0,0,0,{}
local ability_log

function BUI.Actions.Log()	--Log switch
	ability_log=not ability_log
	return ability_log
end

local function ProcEffectPrepare(control,edge,parent)
	control.procLoop=WINDOW_MANAGER:CreateControl("$(parent)LoopAnim", parent or control, CT_TEXTURE)
	control.procLoop:SetAnchor(TOPLEFT,parent or control,TOPLEFT,edge,edge)
	control.procLoop:SetAnchor(BOTTOMRIGHT,parent or control,BOTTOMRIGHT,-edge,-edge)
	control.procLoop:SetTexture("EsoUI/Art/ActionBar/abilityHighlight_mage_med.dds")
	control.procLoop:SetDrawTier(DT_HIGH)
	control.procLoopTimeline=ANIMATION_MANAGER:CreateTimelineFromVirtual("BUI_ProcReadyLoop", control.procLoop)
end

local function ProcEffectAdd(slot,id)
	if not BUI.Vars.ProcAnimation then return end
	--Ability bar
	local AbilitySlot=ZO_ActionBar_GetButton(slot)
	if AbilitySlot then
		if not AbilitySlot.procLoop then ProcEffectPrepare(AbilitySlot,3,AbilitySlot.slot) end
		AbilitySlot.procLoopTimeline:PlayFromStart() AbilitySlot.procLoop:SetHidden(false)
	end
	--Widgets
	if BUI.Vars.EnableWidgets and BUI.Vars.Widgets[id] then
		local control=_G["BUI_Widget_"..id]
		if control then
			if not control.procLoop then ProcEffectPrepare(control,2) end
			control.procLoopTimeline:PlayFromStart() control.procLoop:SetHidden(false)
		end
	end
end

local function ProcEffectRemove(slot,id)
	if not BUI.Vars.ProcAnimation then return end
	--Ability bar
	local AbilitySlot=ZO_ActionBar_GetButton(slot)
	if AbilitySlot and AbilitySlot.procLoop then
		AbilitySlot.procLoopTimeline:Stop() AbilitySlot.procLoop:SetHidden(true)
	end
	--Widgets
	if BUI.Vars.EnableWidgets and BUI.Vars.Widgets[id] then
		local control=_G["BUI_Widget_"..id]
		if control and control.procLoop then
			control.procLoopTimeline:Stop() control.procLoop:SetHidden(true)
		end
	end
end

local function ProcAbility(changeType, duration, stackCount, abilityId)
	--Dodge fatigue
	local id=ProcEffectId[abilityId]
	if abilityId==69143 and BUI.Vars.DodgeFatigue and (changeType==EFFECT_RESULT_GAINED or changeType==EFFECT_RESULT_UPDATED) then
		BUI.Frames.DodgeFatigue(duration)
	elseif (abilityId==117750 or abilityId==114863 or abilityId==117691) and BUI.Vars.ProcAnimation and BUI.Proc[id] then	--Stalking Blastbones
		if changeType==EFFECT_RESULT_FADED then
			ProcEffectAdd(BUI.Proc[id].Slot,id)
			BUI.Proc[id].Active=true
			CALLBACK_MANAGER:FireCallbacks("BUI_Proc",id,5)
			if BUI.Vars.ProcSound then PlaySound(BUI.Vars.ProcSound) end
		elseif changeType==EFFECT_RESULT_GAINED then
			ProcEffectRemove(BUI.Proc[id].Slot,id)
			BUI.Proc[id].Active=false
			CALLBACK_MANAGER:FireCallbacks("BUI_Proc",id,0)
		end
	elseif abilityId==46327 then	--Dark crystal
		if BUI.Vars.Actions and BUI.Actions.AbilityBar[id] then
			if changeType==EFFECT_RESULT_GAINED then
				stackCount=5
				BUI.Actions.AbilityBar[id].Duration=duration
				BUI.Actions.AbilityBar[id].StartTime=GetGameTimeMilliseconds()
			elseif changeType==EFFECT_RESULT_FADED then
				stackCount=0
				BUI.Actions.AbilityBar[id].StartTime=0
			end
		end
		CALLBACK_MANAGER:FireCallbacks("BUI_Proc",id,stackCount)
--[[
		if changeType==EFFECT_RESULT_GAINED and not BUI.Proc[abilityId].Active then
			ProcEffectAdd(BUI.Proc[abilityId].Slot,abilityId)
			BUI.Proc[abilityId].Active=true
			if BUI.Vars.ProcSound then PlaySound(BUI.Vars.ProcSound) end
		elseif changeType==EFFECT_RESULT_FADED and BUI.Proc[abilityId].Active then
			BUI.Proc[abilityId].Active=false
			ProcEffectRemove(BUI.Proc[abilityId].Slot,id)
		end
--]]
	elseif BUI.Proc[id] then	--Assasins will
		local total=id==24165 and 4 or 5	--Bound Armaments/Grim Focus
		if changeType==EFFECT_RESULT_UPDATED then
			if stackCount>=total and not BUI.Proc[id].Active then
				if BUI.Vars.ProcAnimation and BUI.Proc[id].Pair==BUI.CurrentPair then ProcEffectAdd(BUI.Proc[id].Slot) end
				BUI.Proc[id].Active=true
				if BUI.Vars.ProcSound then PlaySound(BUI.Vars.ProcSound) end
			end
		elseif changeType==EFFECT_RESULT_FADED then
			if BUI.Proc[id].Active then
				BUI.Proc[id].Active=false
				if BUI.Vars.ProcAnimation then ProcEffectRemove(BUI.Proc[id].Slot,id)end
			end
			stackCount=0
		end
		if BUI.Vars.Actions then BUI.Actions.AbilityBar[id].Stack=stackCount end
		BUI.Frames.ShowDots(stackCount,total)
		CALLBACK_MANAGER:FireCallbacks("BUI_Proc",id,stackCount)
		--Widgets
		if BUI.Vars.EnableWidgets then
			local name=BUI.Actions.AbilityBar[id] and BUI.Actions.AbilityBar[id].Name or false
			local widgetId=BUI.Vars.Widgets[id] and id or (BUI.Vars.Widgets[name] and name or false)
			if widgetId and BUI.Widgets[widgetId] then
				BUI.Widgets[widgetId].Count=stackCount
			end
		end
	end
end

local function RegisterUptimes(id,duration,now)
	if now>BUI.Stats.Current[BUI.ReportN].startTime then
		if not BUI.Stats.Current[BUI.ReportN].Uptimes[id] then
			if last_effect[id] and last_effect[id][1]+last_effect[id][2]>BUI.Stats.Current[BUI.ReportN].startTime then
				BUI.Stats.Current[BUI.ReportN].Uptimes[id]={[1]={BUI.Stats.Current[BUI.ReportN].startTime,last_effect[id][1]+last_effect[id][2]-BUI.Stats.Current[BUI.ReportN].startTime}}
			else
				BUI.Stats.Current[BUI.ReportN].Uptimes[id]={}
			end
		end
		local weapon,swap
		if last_weapon+900>now then last_weapon=0 weapon=true end
		if last_swap+1500>now then last_swap=0 swap=true end
		table.insert(BUI.Stats.Current[BUI.ReportN].Uptimes[id],{now,duration,weapon,swap})
		last_effect[id]={now,duration}
	end
end

local function StartTimer(id,duration,stackCount,effectType)
	local now=GetGameTimeMilliseconds()
	duration=math.max(duration,BUI.Actions.AbilityBar[id].DurationBase)
	BUI.Actions.AbilityBar[id].StartTime=now
	BUI.Actions.AbilityBar[id].Duration=duration
	BUI.Actions.AbilityBar[id].Stack=0
	QueueAbility=nil
	EVENT_MANAGER:UnregisterForEvent("BUI_Actions2", EVENT_EFFECT_CHANGED)
	--Widgets
	if BUI.Vars.EnableWidgets then
		local name=BUI.Actions.AbilityBar[id] and BUI.Actions.AbilityBar[id].Name or nil
		local widgetId=BUI.Vars.Widgets[id] and id or (BUI.Vars.Widgets[name] and name or nil)
		if widgetId then
			BUI.Widgets[widgetId]={
				id		=id,
				Name		=name,
				Count		=stackCount,
				Texture	=BUI.Actions.AbilityBar[id] and BUI.Actions.AbilityBar[id].Texture or nil,
				Duration	=duration,
				Started	=now,
				Positive	=effectType==BUFF_EFFECT_TYPE_BUFF,
				Player	=true,
				Hold		=true,
--				Expires	=BUI.Widgets[widgetId] and BUI.Widgets[widgetId].Expires,
			}
		end
	end
	--Statistics
	if BUI.Vars.EnableStats then
		RegisterUptimes(id,duration,now)
	end
end

local EffectResults={
[EFFECT_RESULT_FADED]="FADED",
[EFFECT_RESULT_FULL_REFRESH]="REFRESH",
[EFFECT_RESULT_GAINED]="GAINED",
[EFFECT_RESULT_TRANSFER]="TRANSFER",
[EFFECT_RESULT_UPDATED]="UPDATED",
}

local function OnEffectChanged(_, changeType, effectSlot, effectName, unitTag, startTimeSec, endTimeSec, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId)
	--d(BUI.TimeStamp().."["..abilityId.."] |t16:16:"..iconName.."|t "..effectName.."|| "..unitTag.."|| "..stackCount.."|| duration: "..math.floor((endTimeSec-startTimeSec)*100)/100 .."|| "..EffectResults[changeType])	--.."|| "..EffectResults[changeType].."|| "..BuffTypes[buffType].."|| "..BuffEffectTypes[effectType]..", AbType:  "..AbilityTypes[abilityType].."|| "..", StatusEff: "..StatusEffectTypes[statusEffectType]	
	if QueueAbility and changeType~=EFFECT_RESULT_FADED then
		local duration=math.floor((endTimeSec-startTimeSec)*1000)
		if ability_log then
			d(BUI.TimeStamp().."["..abilityId.." ("..QueueAbility.id..")] |cE0E0E0 |t16:16:"..iconName.."|t "
			..effectName.."|r start: "
			..math.floor(QueueAbility.start/100)/10 .."="..math.floor(startTimeSec*10)/10
			.." duration: "..duration.."("..BUI.Actions.AbilityBar[QueueAbility.id].DurationBase..")")
		end
		if QueueAbility.id==abilityId or AbilityEffect[QueueAbility.id]==abilityId then
			StartTimer(QueueAbility.id,duration,stackCount,effectType)
		elseif QueueAbility.id==AbilityName[QueueAbility.id]==effectName then
			AbilityEffect[QueueAbility.id]=abilityId
			StartTimer(QueueAbility.id,duration,stackCount,effectType)
		elseif QueueAbility.start-1000<=startTimeSec*1000 and QueueAbility.start+1000>=startTimeSec*1000 and BUI.Actions.AbilityBar[QueueAbility.id].DurationBase==duration then
			AbilityEffect[QueueAbility.id]=abilityId
			StartTimer(QueueAbility.id,duration,stackCount,effectType)
		end
	end
	--Proc
	if unitTag=='player' and ProcEffectId[abilityId] then
		ProcAbility(changeType, (endTimeSec-startTimeSec)*1000, stackCount, abilityId)
	end
end

local function ActionsUpdate()
	if BUI.CurrentPair~=1 and BUI.CurrentPair~=2 then
		if BUI.Vars.DeveloperMode then d("CurrentPair error: "..tostring(BUI.CurrentPair)) end
		return
	end
	for i=3, 8 do
		local _update=false
		local id=GetSlotBoundId(i)
		--Proc animation
		if BUI.Vars.ProcAnimation and i<8 and ProcAbilityId[id] and BUI.Proc[id]==nil then
			BUI.Proc[id]={["id"]=id,["Slot"]=i,["Pair"]=BUI.CurrentPair,["Active"]=false}
		end
		--Ability timers
		if not IgnoreId[id] then
			if BUI.Vars.Actions then
				if BUI.Actions.AbilityBar[id]==nil then
					_update=true
--					if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."|cdddddd |t16:16:"..GetSlotTexture(i).."|t ["..id.."] Action in slot "..i.." was unknown|r") end
				elseif BUI.Actions.AbilitySlots[BUI.CurrentPair][i]~=id then
					_update=true
--					if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."|cdddddd |t16:16:"..GetSlotTexture(i).."|t ["..id.."] Action in slot "..i.." was in different slot|r") end
--				elseif BUI.Actions.AbilityBar[id].Pair~=BUI.CurrentPair then
--					BUI.Actions.AbilityBar[id].Pair=0
				end
				if _update then
					local diration,castTime=BUI.GetAbilityDuration(id)
					local addCastTime=AdditionalCastTime[id] and AdditionalCastTime[id] or 0
					local name=GetSlotName(i)
					BUI.Actions.AbilityBar[id]={
--						id		=id,
						Name		=name,
						Texture	=GetSlotTexture(i),
						DurationBase=diration,
						Duration	=diration+addCastTime,
						castTime	=castTime+addCastTime,
						StartTime	=0,
--						Target	=GetAbilityTargetDescription(id),
						Pair		=BUI.CurrentPair,
						Slot		=i,
						Stack		=0,
						}
					AbilityName[name]=id
					BUI.Actions.AbilitySlots[BUI.CurrentPair][i]=id
				end
			else
				BUI.Actions.AbilitySlots[BUI.CurrentPair][i]=id
			end
		end
	end
end
BUI.ActionsUpdate=ActionsUpdate

local function OnAbilitySlotted()
	if not UpdateCooldown then
		UpdateCooldown=true
		BUI.CallLater("Actions_AbilitySlotted",500,function()
			if BUI.Vars.ProcAnimation or BUI.Vars.Actions then ActionsUpdate() end
			UpdateCooldown=false
		end)
	end
end

local function OnSlotAbilityUsed(_,slot)
	if slot<1 or slot>8 then return end
	local id=GetSlotBoundId(slot)
	local now=GetGameTimeMilliseconds()
	--if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."["..id.."] "..GetAbilityName(id)) end

	--Statistics
	if BUI.Vars.EnableStats then
		if BUI.inCombat then
			--Slot uses
			if slot==1 and last_weapon+500<now then
				last_weapon=now
				BUI.Stats.Current[BUI.ReportN].Ability.w=BUI.Stats.Current[BUI.ReportN].Ability.w+1
			elseif slot>2 and last_ability+500<now then
				last_ability=now
				BUI.Stats.Current[BUI.ReportN].Ability.a=BUI.Stats.Current[BUI.ReportN].Ability.a+1
			end
		end
		BUI.Stats.LastSlot=slot
	end

	if IgnoreTimer[id] then return end
	--Actions
	if BUI.Vars.Actions and slot>2 then
		if BUI.Actions.AbilityBar[id] then
			local castTime=BUI.Actions.AbilityBar[id].castTime+(AdditionalCastTime[id] and AdditionalCastTime[id] or 0)
			if BUI.Vars.ActionsPrecise then
				QueueAbility={id=id,start=now+castTime}
				EVENT_MANAGER:RegisterForEvent("BUI_Actions2", EVENT_EFFECT_CHANGED, OnEffectChanged)
			else
				StartTimer(
					id,
					BUI.Actions.AbilityBar[id].DurationBase+castTime,	--Duration
					BUI.Actions.AbilityBar[id].Stack,	--stackCount
					BUFF_EFFECT_TYPE_BUFF	--effectType
					)
			end
			if BUI.Vars.CastBar~=3 then BUI.Reticle.CastBar(math.max(BUI.Actions.AbilityBar[id].castTime,1000)) end
		--Statistics
		elseif BUI.Vars.EnableStats then
			RegisterUptimes(id,BUI.GetAbilityDuration(id),now)
		end
	end
end

local function UpdateTimers()
	if BUI.CurrentPair~=1 and BUI.CurrentPair~=2 then
--		if BUI.Vars.DeveloperMode then d("CurrentPair error: "..tostring(BUI.CurrentPair)) end
		return
	end
	local _now=GetGameTimeMilliseconds()
	local SwapPair=BUI.CurrentPair==1 and 2 or 1
	for i=3,7 do
		local AbilitySlot=ZO_ActionBar_GetButton(i)
		if AbilitySlot then
--[[
			if not AbilitySlot.IconControl then
				local icon=_G["ActionButton"..i.."Icon"]
				AbilitySlot.IconControl=WINDOW_MANAGER:CreateControl("$(parent)IconControl", AbilitySlot.slot, CT_BACKDROP)
				AbilitySlot.IconControl:SetAnchor(CENTER,AbilitySlot.slot,CENTER,0,0)
				AbilitySlot.IconControl:SetDimensions(icon:GetDimensions())
				AbilitySlot.IconControl:SetCenterColor(0,0,0,0)
				AbilitySlot.IconControl:SetEdgeColor(0,0,0,0)
				AbilitySlot.IconControl:SetDrawTier(DT_HIGH)
				icon:ClearAnchors()
				icon:SetAnchor(3,AbilitySlot.IconControl,3,0,0)
			end
			if timer>100 and timer<=1000 then BUI.UI.Expires(AbilitySlot.IconControl) end
--]]
			if not AbilitySlot.AbTimer then
				AbilitySlot.AbTimer=WINDOW_MANAGER:CreateControl("$(parent)Timer", AbilitySlot.slot, CT_LABEL)
				AbilitySlot.AbTimer:SetAnchor(BOTTOM,AbilitySlot.slot,BOTTOM,0,0)
				AbilitySlot.AbTimer:SetFont(BUI.UI.Font(BUI.Vars.FrameFont1,BUI.Vars.ActionsFontSize,true,true))
				AbilitySlot.AbTimer:SetHorizontalAlignment(1)
				AbilitySlot.AbTimer:SetVerticalAlignment(2)
				AbilitySlot.AbTimer:SetDrawTier(DT_HIGH)
			end
			if not AbilitySlot.AbStack then
				AbilitySlot.AbStack=WINDOW_MANAGER:CreateControl("$(parent)Stack", AbilitySlot.slot, CT_LABEL)
				AbilitySlot.AbStack:SetAnchor(TOPRIGHT,AbilitySlot.slot,TOPRIGHT,0,0)
				AbilitySlot.AbStack:SetFont(BUI.UI.Font(BUI.Vars.FrameFont1,BUI.Vars.ActionsFontSize,true,true))
				AbilitySlot.AbStack:SetHorizontalAlignment(2)
				AbilitySlot.AbStack:SetVerticalAlignment(2)
				AbilitySlot.AbStack:SetDrawTier(DT_HIGH)
			end
		end

		local id=BUI.Actions.AbilitySlots[BUI.CurrentPair][i]
		local _act=BUI.Actions.AbilityBar[id]
		if _act then
			if RapidManeuver[id] and _act.StartTime<BUI.Damage.last then _act.StartTime=0 end
			local timer=_act.StartTime+_act.Duration-_now			
			AbilitySlot.AbTimer:SetText(timer>0 and BUI.FormatTime(timer/1000) or "")
			if id==61902 or id==61919 or id==61927 and timer<=0 then timer=1 end --Grim Focus and morphs have no timer so force show the stack
			AbilitySlot.AbStack:SetText((timer>0 and _act.Stack>0) and _act.Stack or "")
		else
			AbilitySlot.AbTimer:SetText("")
			AbilitySlot.AbStack:SetText("")
		end

		if BUI.Vars.UseSwapPanel then
			local slot=_G["BUI_ActionButton"..i]
			if slot then
				local id=BUI.Actions.AbilitySlots[SwapPair][i]
				local _act=BUI.Actions.AbilityBar[id]
				if _act then
					local timer=_act.StartTime+_act.Duration-_now
					slot.label:SetText(timer>0 and BUI.FormatTime(timer/1000) or "")
					if timer<=0 then
						if BUI.Vars.HideSwapPanel then slot:SetHidden(true) end
					elseif timer>100 and timer<=1000 then
						if BUI.Vars.ExpiresAnimation then BUI.UI.Expires(slot) end
					else
						slot:SetHidden(false)
					end
				else
					slot:SetHidden(true)
				end
			end
		end
	end
end

local function MakeAbilitySlot(i)
	local AbilitySlot=ZO_ActionBar_GetButton(i)
	local w,h=AbilitySlot.icon:GetDimensions()
	slot=_G["BUI_ActionButton"..i] or WINDOW_MANAGER:CreateControl("BUI_ActionButton"..i, AbilitySlot.slot, CT_BACKDROP)
	slot:ClearAnchors()
	slot:SetAnchor(CENTER,AbilitySlot.slot,TOPRIGHT,-w/3,0)
	slot:SetDimensions(w+4,h+4)
	slot:SetCenterColor(0,0,0,0)
	slot:SetEdgeColor(unpack(theme_color))
	slot:SetDrawLevel(0)
	slot:SetHidden(BUI.Vars.HideSwapPanel)

	slot.icon=_G["BUI_ActionButton"..i.."Icon"] or WINDOW_MANAGER:CreateControl("BUI_ActionButton"..i.."Icon", slot, CT_TEXTURE)
	slot.icon:ClearAnchors()
	slot.icon:SetAnchor(CENTER,slot,CENTER,0,0)
	slot.icon:SetDimensions(w,h)

	slot.label=_G["BUI_ActionButton"..i.."Label"] or WINDOW_MANAGER:CreateControl("BUI_ActionButton"..i.."Label", slot, CT_LABEL)
	slot.label:ClearAnchors()
	slot.label:SetAnchor(TOP,slot,TOP,0,0)
	slot.label:SetFont(BUI.UI.Font(BUI.Vars.FrameFont1,BUI.Vars.ActionsFontSize,true,true))
	slot.label:SetHorizontalAlignment(1)
	slot.label:SetVerticalAlignment(2)
--	slot.label:SetDrawTier(DT_HIGH)

	AbilitySlot.bg:SetDrawLevel(1)
	AbilitySlot.icon:SetDrawLevel(2)
	AbilitySlot.cooldownIcon:SetDrawLevel(2)
	return slot
end

function BUI.Actions.OnPairChanged()
	BUI.CurrentPair=math.max(GetActiveWeaponPairInfo(),1)
--	d("Pair: "..BUI.CurrentPair)
	if BUI.Vars.ProcAnimation or BUI.Vars.Actions then
		ActionsUpdate()
		if BUI.Vars.ProcAnimation then
			for id in pairs(BUI.Proc) do
				if BUI.Proc[id].Active then
					if BUI.Proc[id].Pair~=BUI.CurrentPair then ProcEffectRemove(BUI.Proc[id].Slot)
					else ProcEffectAdd(BUI.Proc[id].Slot) end
				end
			end
		end
	end

	if BUI.Vars.Actions and BUI.Vars.UseSwapPanel then
		local SwapPair=BUI.CurrentPair==1 and 2 or 1
		for i=3,7 do
			local id=BUI.Actions.AbilitySlots[SwapPair][i]
			if id and BUI.Actions.AbilityBar[id] then
				local slot=_G["BUI_ActionButton"..i]
				if not slot then
					slot=MakeAbilitySlot(i)
				end
				slot.icon:SetTexture(BUI.Actions.AbilityBar[id].Texture)
			end
		end
	end
	--Statistics
	if BUI.Vars.EnableStats then
		local now=GetGameTimeMilliseconds()
		if last_swap>BUI.Stats.Current[BUI.ReportN].startTime then
			if not BUI.Stats.Current[BUI.ReportN].Uptimes[103] then
				BUI.Stats.Current[BUI.ReportN].Uptimes[103]={}
			end
			table.insert(BUI.Stats.Current[BUI.ReportN].Uptimes[103],{last_swap,500})
		end
		last_swap=now
	end

	if BUI.Vars.SwapIndicator then BUI.Reticle.CastBar(500) end
end

function BUI.Actions.ChangeTheme()
	theme_color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.Theme>3 and BUI.Vars.CustomEdgeColor or {147/256,123/256,82/256,1}
	for i=3,7 do
		local slot=_G["BUI_ActionButton"..i]
		if slot then
			slot:SetEdgeColor(unpack(theme_color))
		end
	end
end

function BUI.Actions.Initialize()
	theme_color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.CustomEdgeColor
	if BUI.Vars.Actions or BUI.Vars.ProcAnimation or BUI.Vars.NotificationsGroup or BUI.Vars.EnableWidgets then
		EVENT_MANAGER:RegisterForEvent("BUI_Actions", EVENT_ACTIVE_WEAPON_PAIR_CHANGED,	BUI.Actions.OnPairChanged)
		EVENT_MANAGER:RegisterForEvent("BUI_Actions", EVENT_ACTION_SLOT_ABILITY_SLOTTED,	OnAbilitySlotted)
		EVENT_MANAGER:RegisterForEvent("BUI_Actions", EVENT_PLAYER_ACTIVATED,			function()BUI.CallLater("Actions_Activated",3000,BUI.Actions.OnPairChanged)end)
	else
		EVENT_MANAGER:UnregisterForEvent("BUI_Actions", EVENT_ACTIVE_WEAPON_PAIR_CHANGED)
		EVENT_MANAGER:UnregisterForEvent("BUI_Actions", EVENT_ACTION_SLOT_ABILITY_SLOTTED)
		EVENT_MANAGER:UnregisterForEvent("BUI_Actions", EVENT_PLAYER_ACTIVATED)
	end
--	EVENT_MANAGER:RegisterForEvent("BUI_Actions2", EVENT_EFFECT_CHANGED,	OnEffectChanged)

	if BUI.Vars.Actions or BUI.Vars.ProcAnimation then
		for id in pairs(ProcEffectId) do
			EVENT_MANAGER:RegisterForEvent("BUI_Actions"..id, EVENT_EFFECT_CHANGED, OnEffectChanged)
			EVENT_MANAGER:AddFilterForEvent("BUI_Actions"..id, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, id)
			EVENT_MANAGER:AddFilterForEvent("BUI_Actions"..id, EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "player")
		end
	else
		EVENT_MANAGER:UnregisterForEvent("BUI_Actions2", EVENT_EFFECT_CHANGED)
		for id in pairs(ProcEffectId) do
			EVENT_MANAGER:UnregisterForEvent("BUI_Actions"..id, EVENT_EFFECT_CHANGED)
		end
	end

	if BUI.Vars.Actions or BUI.Vars.EnableWidgets or (BUI.Vars.EnableStats and BUI.Vars.StatsBuffs) then
		EVENT_MANAGER:RegisterForEvent("BUI_Actions", EVENT_ACTION_SLOT_ABILITY_USED,		OnSlotAbilityUsed)
	else
		EVENT_MANAGER:UnregisterForEvent("BUI_Actions", EVENT_ACTION_SLOT_ABILITY_USED)
	end

	if BUI.Vars.Actions then
		if BUI.Vars.UseSwapPanel then
			for i=3,7 do MakeAbilitySlot(i) end
		end
		EVENT_MANAGER:RegisterForUpdate("BUI_Actions", 200, UpdateTimers)
		--Rapid Maneuver
		local _,progressionIndex=GetAbilityProgressionXPInfoFromAbilityId(40211)
		for rank=0,2 do
			for morph=1,4 do
				RapidManeuver[GetAbilityProgressionAbilityId(progressionIndex, rank, morph)]=true
			end
		end
--[[		--AdditionalCastTime
		local _,progressionIndex=GetAbilityProgressionXPInfoFromAbilityId(38689)	--Endless Hail
		for rank=0,2 do
			for morph=1,4 do
				AdditionalCastTime[GetAbilityProgressionAbilityId(progressionIndex, rank, morph)]=2000
			end
		end
		local _,progressionIndex=GetAbilityProgressionXPInfoFromAbilityId(40255)	--Caltrops
		for rank=0,2 do
			for morph=1,4 do
				AdditionalCastTime[GetAbilityProgressionAbilityId(progressionIndex, rank, morph)]=1000
			end
		end
--]]
	else
		EVENT_MANAGER:UnregisterForUpdate("BUI_Actions")
	end
	if BUI.init.Actions then
		for i=3,8 do
			local slot=_G["BUI_ActionButton"..i]
			if slot then
				slot:SetHidden(not BUI.Vars.UseSwapPanel or not BUI.Vars.Actions)
				slot.label:SetFont(BUI.UI.Font(BUI.Vars.FrameFont1,BUI.Vars.ActionsFontSize,true,true))
			end
			local AbilitySlot=ZO_ActionBar_GetButton(i)
			if AbilitySlot and AbilitySlot.AbTimer then
				AbilitySlot.AbTimer:SetFont(BUI.UI.Font(BUI.Vars.FrameFont1,BUI.Vars.ActionsFontSize,true,true))
			end
		end
	end
	BUI.init.Actions=true
end

--[[
/script ActionButton4IconControl:SetEdgeColor(0,0,0,1)
/script BUI.UI.Expires(ActionButton4IconControl)
/script BUI.UI.Expires(ZO_ActionBar_GetButton(4).slot)
/script ScanObj(ZO_ActionBar_GetButton(4).slot)
/script ActionButton4Icon:ClearAnchors() ActionButton4Icon:SetAnchor(CENTER,BanditsUI,CENTER,0,0)
--]]