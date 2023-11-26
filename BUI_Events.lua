local IgnoreAbility={
	[50011]=true,--Dummy
	[51487]=true,--Shehai Shockwave
	[20546]=true,--Prioritize Hit
	[69168]=true,--Purifying Light Heal FX
	[20667]=true,--Heal Cast Test
	[27278]=true,--Clensing Ritual Dummy
	[52515]=true,--Grand Healing Fx
	[20663]=true,--Range Cast Test
	[41189]=true,--Combat Prayer
	[31221]=true,--Skyshard Collect
	[36010]=true,--Mount Up
	[41467]=true,--Regeneration Dummy
	[57466]=true,--Rapid Regeneration Dummy
	[57468]=true,--Mutagen Dummy
	[61898]=true,--Minor Savagery
	[95806]=true,--Static Charge (Dark Anchor)
	[87876]=true,--Betty Netch Restore Magicka
	[37360]=true,--No Light Attacks
	[74347]=true,--Lunar Bastion
	[77154]=true,--Hist Dart
	}
local BuffIcon={
	[1]="|t16:16:esoui/art/icons/ability_ava_003_a.dds|t",
	[2]="",
	[3]="|t16:16:esoui/art/icons/ability_restorationstaff_002b.dds|t",
	[4]="|t16:16:esoui/art/icons/ability_debuff_fear.dds|t",
	[5]="",
	[6]="",
	[7]="|t16:16:esoui/art/icons/ability_nightblade_005_b.dds|t",
	[8]="",
	[9]=""
	}
local messages={}
local GroupBuffsLoopActive,CallBackVanityPet
local Enchants={
	[28919]=true,[28921]=true,--Life Drain
	[46743]=true,[46744]=true,--Absorb Magicka
	[46746]=true,[46747]=true,--Absorb Stamina
	[46749]=true,--Damage Health
	[17895]=true,--Fiery Weapon
	[17904]=true,--Befouled Weapon
	[17897]=true,--Frozen Weapon
	[17902]=true,--Poisoned Weapon
	[40337]=true,--Prismatic Weapon
	[17899]=true,--Charged Weapon
	}
local LastWipe,LastPowerValue=0,0
local ResultDamage={[ACTION_RESULT_DAMAGE]=true,[ACTION_RESULT_CRITICAL_DAMAGE]=true,[ACTION_RESULT_BLOCKED_DAMAGE]=true,[ACTION_RESULT_DOT_TICK]=true,[ACTION_RESULT_DOT_TICK_CRITICAL]=true,[ACTION_RESULT_DAMAGE_SHIELDED]=true}
local TrialLobby={u30_rg=true,sunspirehall001_base=true,cloudresttrial_base=true,hofabriccaves_base=true,maw_of=true,mawlorkajsevenriddles_base=true,arenaslobbyexterior_base=true,trl_so=true,helracitadelentry_base=true,aetherianarchivebottom_base=true,gladiatorsassembly_base=true,blackroseprison01_base=true,kynesaegismap001_0=true,vateshransrites01_0=true,dsr_beach=true,sanitysedgesection0_map=true}
local TrialZones,TrialNames={
636,	--Hel Ra Citadel
638,	--Aetheran Archive
639,	--Sanctum Ophidia
635,	--Dragonstar Arena
725,	--Maw of Lorkhaj
677,	--Maelstrom Arena
975,	--Halls of Fabrication
1000,	--Asylum Sanctorium
1051,	--Cloudrest
1082,	--Blackrose Prison
1121,	--Sunspire
1196,	--Kyne's Aegis
1227,	--Vateshran Hollows
1263,	--Rockgrove
1344,   --DSR
1427,   --Sanitys Edge
},{}
for _,id in pairs(TrialZones) do TrialNames[GetZoneNameById(id)]=id end

--USER INTERFACE
local function OnScreenResize()
	BUI.UI.TopLevelWindow("BanditsUI", GuiRoot, {GuiRoot:GetWidth(),GuiRoot:GetHeight()}, {CENTER,CENTER,0,0}, false)
end

--TARGET EVENTS
local function OnTargetChanged()
	--Hide default frame
	if BUI.init.Frames and not BUI.Vars.DefaultTargetFrame then ZO_TargetUnitFramereticleover:SetHidden(true) end
	--Update valid targets
	local isTarget=(DoesUnitExist('reticleover') and not BUI:IsCritter('reticleover') and not BUI.move)
	BUI.Target:Update(isTarget)
end

local function OnBossesChanged(eventCode)
--	if BUI.Vars.DeveloperMode and BUI.BossFight then d(BUI.TimeStamp().."|cEE2222Boss event|r") end
	BUI.Frames.Bosses_Init()
end

--ATTRIBUTE EVENTS
local function OnPowerUpdate(eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax)
	--Player Updates
	if unitTag=='player' then
		--Health, Magicka, and Stamina
		if powerType==POWERTYPE_HEALTH or powerType==POWERTYPE_MAGICKA or powerType==POWERTYPE_STAMINA or powerType==POWERTYPE_ULTIMATE then
			if powerType==BUI.MainPowerType and BUI.Vars.WidgetPotion then	--Potion
				local delta=powerValue-LastPowerValue
				if delta>=0 then
					local remain,duration,global=GetSlotCooldownInfo(BUI.CurrentQuickslot)
					if duration~=0 and remain==duration and not global and duration<50000 then
						BUI.PotionEndTime=GetGameTimeMilliseconds()+45000
					end
				end
				LastPowerValue=powerValue
			end
			BUI.Player:UpdateAttribute(unitTag, powerType, powerValue, powerMax, powerEffectiveMax)
		--Mount Stamina
		elseif powerType==POWERTYPE_MOUNT_STAMINA then
			if BUI.init.Frames then BUI.Frames:UpdateAltBar(powerValue, powerMax, powerEffectiveMax, "mount") end
		--Werewolf
		elseif powerType==POWERTYPE_WEREWOLF then
			if BUI.init.Frames then BUI.Frames:UpdateAltBar(powerValue, powerMax, powerEffectiveMax, "werewolf") end
		end
	--Target Updates
	elseif unitTag=='reticleover' then
		--Health
		if powerType==POWERTYPE_HEALTH then
			BUI.Player:UpdateAttribute(unitTag, powerType, powerValue, powerMax, powerEffectiveMax)
		end
	--Siege Updates
	elseif unitTag=='controlledsiege' then
		--Health
		if powerType==POWERTYPE_HEALTH then
			if BUI.init.Frames then BUI.Frames:UpdateAltBar(powerValue, powerMax, powerEffectiveMax, "siege") end
		end
	--Group Updates
	elseif BUI.InGroup and string.sub(unitTag, 0, 5)=="group" then
		--Health		
		if (powerType==POWERTYPE_HEALTH) then
			if BUI.init.Frames then
				BUI.Player:UpdateAttribute(unitTag, powerType, powerValue, powerMax, powerEffectiveMax)
			end
		end
--[[
	elseif string.sub(unitTag, 0, 4)=="boss" then
	--Bosses
	elseif BUI.Vars.DeveloperMode then
		local power=(powerType==POWERTYPE_HEALTH) and "health" or (powerType==POWERTYPE_MAGICKA) and "magicka" or (powerType==POWERTYPE_STAMINA) and "stamina" or (powerType==POWERTYPE_ULTIMATE) and "ultimate" or "unknown"
		local name=GetUnitName(unitTag) name=(name~="") and name or unitTag
		d(AR.TimeStamp()..name.." "..power.." changed to "..math.floor(powerValue/powerMax)*100 .."%")
--]]
	end
end

local function GroupBuffsLoop()
	if not (BUI.Vars.GroupBuffs and BUI.init.Group) then return end
	local NoBuffs=true
	for i=1, BUI.Group.members do
		local buffs=""
		local unitTag="group"..i
		local frame=BUI.Group[unitTag].frame
		if frame then
			for j=1, 7 do
				if GetFormattedTime()-BUI.Group[unitTag].BuffTime[j]>29 then BUI.Group[unitTag].Buff[j]="" end
				buffs=buffs..BUI.Group[unitTag].Buff[j]
			end
			frame.buffs:SetText(buffs)
			if buffs~="" then NoBuffs=false end
		end
	end
	if not GroupBuffsLoopActive and not NoBuffs then
		GroupBuffsLoopActive=true
		BUI.CallLater("GroupBuffsLoop",1000,function() GroupBuffsLoopActive=false GroupBuffsLoop() end)
	end
end

local function OnVisualAdded(eventCode, unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue, sequenceId)
--	d(GetUnitName(unitTag)..": Event="..unitAttributeVisual.." Stat="..statType.." Attribute="..attributeType.." Power="..powerType.." Sequence="..sequenceId)
	if not BUI.init.Frames then return end
	if unitTag=="player" then
		if unitAttributeVisual==ATTRIBUTE_VISUAL_INCREASED_MAX_POWER and (powerType==POWERTYPE_HEALTH or powerType==POWERTYPE_MAGICKA or powerType==POWERTYPE_STAMINA) then
			if BUI.Vars.PlayerFrame and BUI.Vars.FrameHorisontal and BUI.Vars.FoodBuff then BUI.Frames:PlayerAttributeResize(powerType,sequenceId==0) end
			if BUI.OnScreen.Message[0] then BUI.OnScreen.Message[0]={["message"]="",["time"]=0} BUI.OnScreen.Update() end
		elseif powerType==POWERTYPE_HEALTH then
			if unitAttributeVisual==ATTRIBUTE_VISUAL_POWER_SHIELDING then
				BUI.Player:UpdateShield(unitTag, (sequenceId==0 and value or 0), maxValue)
				if sequenceId==0 and value>20000 then BUI.Buffs.BarrierActive=GetGameTimeSeconds()+30 end
			elseif unitAttributeVisual==ATTRIBUTE_VISUAL_TRAUMA then
				BUI.Player:UpdateTrauma(unitTag, (sequenceId==0 and value or 0), maxValue)				
			elseif statType==3 and unitAttributeVisual==ATTRIBUTE_VISUAL_DECREASED_STAT and value>1000 then	--unitAttributeVisual==ATTRIBUTE_VISUAL_INCREASED_STAT
				if BUI.Vars.PlayerFrame then BUI.Frames:AttributeVisual(unitTag,unitAttributeVisual,sequenceId==0) end
			elseif unitAttributeVisual==ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER or unitAttributeVisual==ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER then
				if BUI.Vars.PlayerFrame then BUI.Frames.Regen(unitTag,unitAttributeVisual,powerType,(sequenceId==0 and 2000 or 0)) end
				if BUI.Vars.CurvedFrame~=0 then BUI.Curved.Regen(unitTag,unitAttributeVisual,powerType,(sequenceId==0 and 2000 or 0)) end
			end
		end
	elseif unitTag=="reticleover" and powerType==POWERTYPE_HEALTH then
		if unitAttributeVisual==ATTRIBUTE_VISUAL_POWER_SHIELDING then
			if BUI_TargetFrame then BUI.Player:UpdateShield(unitTag, (sequenceId==0 and value or 0), maxValue) end
		elseif unitAttributeVisual==ATTRIBUTE_VISUAL_TRAUMA then
			if BUI_TargetFrame then BUI.Player:UpdateTrauma(unitTag, (sequenceId==0 and value or 0), maxValue) end
		elseif unitAttributeVisual==ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER or unitAttributeVisual==ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER then
			if BUI_TargetFrame then BUI.Frames.Regen(unitTag,unitAttributeVisual,powerType,(sequenceId==0 and 2000 or 0)) end
			if BUI.Vars.CurvedFrame~=0 then BUI.Curved.Regen(unitTag,unitAttributeVisual,powerType,(sequenceId==0 and 2000 or 0)) end
		elseif unitAttributeVisual==ATTRIBUTE_VISUAL_UNWAVERING_POWER then
			BUI.Target.Invul=sequenceId==0
			BUI.Frames.TargetReactionUpdate()
			BUI.Reticle.Invul()
		end
	elseif BUI.init.Group and BUI.Group[unitTag] then
		if powerType==POWERTYPE_HEALTH then
			if unitAttributeVisual==ATTRIBUTE_VISUAL_POWER_SHIELDING then
				BUI.Player:UpdateShield(unitTag, (sequenceId==0 and value or 0), maxValue)
			elseif unitAttributeVisual==ATTRIBUTE_VISUAL_TRAUMA then
				BUI.Player:UpdateTrauma(unitTag, (sequenceId==0 and value or 0), maxValue)
			elseif unitAttributeVisual==ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER or unitAttributeVisual==ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER then
				BUI.Frames:GroupRegen(unitTag,unitAttributeVisual,powerType,(sequenceId==0 and 2000 or 0))
				if unitAttributeVisual==ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER then
					BUI.Frames:AttributeVisual(unitTag,unitAttributeVisual,sequenceId==0)
				end
			elseif statType==3 and unitAttributeVisual==ATTRIBUTE_VISUAL_DECREASED_STAT then
				BUI.Frames:AttributeVisual(unitTag,unitAttributeVisual,sequenceId==0)
			end
		end
		if BUI.Vars.GroupBuffs then
			if sequenceId==0 then
				BUI.Group[unitTag].Buff[unitAttributeVisual]=BuffIcon[unitAttributeVisual]
				BUI.Group[unitTag].BuffTime[unitAttributeVisual]=GetFormattedTime()
				GroupBuffsLoop()
			else
				BUI.Group[unitTag].Buff[unitAttributeVisual]=""
			end
		end
	end
end

local function OnVisualUpdate(eventCode, unitTag, unitAttributeVisual, statType, attributeType, powerType, oldValue, newValue, oldMaxValue, newMaxValue)
	if not BUI.init.Frames then return end
	--Group buffs
	if BUI.init.Group and BUI.Group[unitTag] and BUI.Vars.GroupBuffs then
		if BUI.Group[unitTag] and BUI.Group[unitTag].Buff and BUI.Group[unitTag].Buff[unitAttributeVisual] then
			BUI.Group[unitTag].Buff[unitAttributeVisual]=BuffIcon[unitAttributeVisual]
			BUI.Group[unitTag].BuffTime[unitAttributeVisual]=GetFormattedTime()
			GroupBuffsLoop()
		end
	end
	--Damage Shields
	if powerType==POWERTYPE_HEALTH and unitAttributeVisual==ATTRIBUTE_VISUAL_POWER_SHIELDING then
		BUI.Player:UpdateShield(unitTag, newValue, newMaxValue)
	end
	if powerType==POWERTYPE_HEALTH and unitAttributeVisual==ATTRIBUTE_VISUAL_TRAUMA then
		BUI.Player:UpdateTrauma(unitTag, newValue, newMaxValue)
	end
end

local function OnEffectChanged(_, changeType, _, effectName, unitTag, startTimeSec, endTimeSec, _, iconName, _, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
	if unitId==0 or changeType>2 or not BUI.inCombat or unitName=="Offline" then return end
--	d(BUI.TimeStamp().."["..abilityId.."] |t16:16:"..iconName.."|t "..effectName.."|| "..unitTag.."|| duration: "..math.floor((endTimeSec-startTimeSec)*100)/100)
--	unitName=string.gsub(unitName,"%^%w+","")	--zo_strformat(SI_UNIT_NAME,unitName)
--	if unitName~=BUI.Player.name and string.sub(unitTag or "", 1, 5)=="group" and sourceType~=COMBAT_UNIT_TYPE_PLAYER then return end
--	if unitTag and string.sub(unitTag, 1, 5)=="group" and AreUnitsEqual(unitTag, "player") then return end
--	if unitTag and string.sub(unitTag, 1, 11)~="reticleover" and (AreUnitsEqual(unitTag, "reticleover") or AreUnitsEqual(unitTag, "reticleoverplayer") or AreUnitsEqual(unitTag, "reticleovertarget")) then return end

	if sourceType==COMBAT_UNIT_TYPE_PLAYER then
		if BUI.Player.id==nil and string.gsub(unitName,"%^%w+","")==BUI.Player.name then BUI.Player.id=unitId end
	elseif sourceType==COMBAT_UNIT_TYPE_GROUP then
		if BUI.GroupMembers[unitId]==nil then
			unitName=string.gsub(unitName,"%^%w+","")
			BUI.GroupMembers[unitId]=unitName
			BUI.GroupMembers[unitName]=unitId
		end
	else
		BUI.Enemy[unitId]=string.gsub(unitName,"%^%w+","")
--		if BUI.Attacker[unitId] and not BUI.Attacker[unitId].name then d("Name added: "..unitName) BUI.Attacker[unitId].name=string.gsub(unitName,"%^%w+","") end
	end
end
--	/script d(EFFECT_RESULT_GAINED,EFFECT_RESULT_FADED,EFFECT_RESULT_UPDATED,EFFECT_RESULT_FULL_REFRESH,EFFECT_RESULT_TRANSFER)
--STATE EVENTS
local function OnCombatState(eventCode, inCombat)
--	d("["..tostring(eventCode).."] "..tostring(inCombat))
	BUI.inCombat=inCombat
	--Control frame visibility
	if BUI.init.Frames then
		local alpha=inCombat and BUI.Vars.FrameOpacityIn/100 or BUI.Vars.FrameOpacityOut/100
		if BUI.Vars.PlayerFrame then BUI_PlayerFrame_Base:SetAlpha(alpha) end
		if BUI.Vars.RaidFrames and IsUnitGrouped('player') then BUI_RaidFrame:SetAlpha(alpha) end
		if BUI.Vars.TargetFrame then BUI_TargetFrame_Base:SetAlpha(alpha) end
		if BUI.Vars.CurvedFrame~=0 then BUI.Curved.OnCombatState(inCombat) BUI_Curved:SetAlpha(alpha) BUI_CurvedTarget:SetAlpha(alpha) end
		if BUI_BuffsP then BUI_BuffsP:SetAlpha(alpha) end
		if BUI_BuffsT then BUI_BuffsT:SetAlpha(alpha) end
		if BUI_BuffsC then BUI_BuffsC:SetAlpha(alpha) end
		if BUI_BuffsS then BUI_BuffsS:SetAlpha(alpha) end
		if BUI_BuffsPas then BUI_BuffsPas:SetAlpha(alpha) end
	end
	--Statistics
	if BUI.init.Stats then
		if inCombat then
			if BUI.Stats.CombatEnd then BUI.Stats.groupDPS={} end
		else
			BUI.CallLater("CombatState",550,function()
			if not BUI.BossFight then
				if BUI.InGroup then
					BUI.Stats.SendPing()
					BUI.CallLater("DisplayGroupDPS",250,BUI.Stats.DisplayGroupDPS)
				end
				BUI.Stats.CombatEnd=true
--				BUI.Stats.SaveBuffs()
			end
			end)
		end
	end
	--Bosses phase
	if inCombat and BUI.BossFight and BUI.Stats.CombatEnd then
		local _phase=BUI.Phase_Timers[BUI.BossName]
		if _phase and _phase.atStart and _phase.timer==0 then _phase.timer=GetGameTimeMilliseconds()+_phase.initial end
	end
	--Combat Reticle
	if BUI.Vars.InCombatReticle then
		BUI.Reticle.InCombat(inCombat)
	end
end

local function OnDeath(eventCode,unitTag,isDead)
--	if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."["..tostring(eventCode).."]"..tostring(unitTag).." || "..tostring(isDead).." || "..tostring(state)) end
	if unitTag=="reticleover" then return end
--	if not isDead and unitTag=='player' then
--		BUI.Stats.RevivedTime=GetGameTimeMilliseconds()
--		if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."Player revived") end
--	end
	if string.sub(unitTag, 0, 5)~="group" then return end
	local accname=GetUnitDisplayName(unitTag) or "Unknown"
	local now=GetGameTimeMilliseconds()
	--Log
	if BUI.Vars.Log and (unitTag~='player' or not IsUnitGrouped('player')) then
		table.insert(BUI.Log,{now,"",accname,(isDead and "|cEE2222Dead|r" or "|cEEEE22Revived|r"),100})
	end
	if isDead then
		--Death count
		if BUI.Group[accname] then
			if BUI.Group[accname].deathtime and BUI.Group[accname].deathtime+2000>now then return end
			if not BUI.Group[accname].death then BUI.Group[accname].death=0 end
			BUI.Group[accname].death=BUI.Group[accname].death+1
			BUI.Group[accname].deathtime=now
			--Remember for report
			if BUI.init.Stats then
				if not BUI.Stats.Current[BUI.ReportN].GroupDPS[accname] then BUI.Stats.Current[BUI.ReportN].GroupDPS[accname]={} end
				BUI.Stats.Current[BUI.ReportN].GroupDPS[accname].death=BUI.Group[accname].death
			end
			--Group wipe
			local DeadMembers=0
			for i=1,BUI.Group.members do
				if IsUnitDead(GetGroupUnitTagByIndex(i)) then DeadMembers=DeadMembers+1 end
			end
			--Notifications
			if BUI.OnScreen.Message[79] then BUI.OnScreen.Message[79].units=BUI.Group.members-DeadMembers end
--			if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."Death "..accname..": "..BUI.Group[accname].death..(DeadMembers==1 and " (First death)" or "")) end
			if DeadMembers==BUI.Group.members and LastWipe+1000<now then	--Group wipe
				LastWipe=now
				if BUI.init.Stats then
					BUI.Stats.CombatEnd=true
--					BUI.Stats.SaveBuffs()
					BUI.Stats.DisplayGroupDPS()
				end
				if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."|cFF2222Group wipe|r") end
				for i=1,BUI.Group.members do
					local accname=GetUnitDisplayName(GetGroupUnitTagByIndex(i))
					if BUI.Group[accname] and BUI.Group[accname].death and BUI.Group[accname].death>0 then
						BUI.Group[accname].death=BUI.Group[accname].death-1
					end
				end
				--Bosses phase
				local _phase=BUI.Phase_Timers[BUI.BossName]
				if _phase and _phase.atStart then _phase.timer=0 end
				--Log
				if BUI.Vars.Log then
					table.insert(BUI.Log,{now,"","","|cEE2222Group wipe|r",100})
				end
				--Notifications
				BUI.OnScreen.Message={}
			end
		end
		--Notifications Group
		if BUI.Vars.NotificationsGroup and not BUI.PvPzone then
			if not BUI.Vars.OnScreenPriorDeath or (BUI.Group[unitTag] and (BUI.Group[unitTag].role=="Tank" or BUI.Group[unitTag].role=="Healer")) then
				BUI.OnScreen.NotificationSecondary(accname,accname.." "..BUI.Loc("GroupMemberDead"))	--Group member death
			end
		end
	end
end

local function OnMount(eventCode,mounted)
	BUI.Mounted=mounted
	BUI.Reticle.SpeedBoost()
	if BUI.init.Frames then
		if not mounted then BUI.CallLater("SetupAltBar",1500,BUI.Frames.SetupAltBar)
		else
			BUI.Frames:SetupAltBar()
		end
	end
--	d("eventCode "..tostring(eventCode).." mounted "..tostring(mounted))
end

local function OnSiege(eventCode,inSiege)
	if BUI.init.Frames then
		if inSiege then BUI.CallLater("SetupAltBar",1000,BUI.Frames.SetupAltBar)
		else
			if BUI.Vars.EnableXPBar then
				BUI.CallLater("SetupAltBar",1000,BUI.Frames.SetupAltBar)
			else
				if BUI.Vars.PlayerFrame then BUI_PlayerFrame_Alt:SetHidden(true) end
			end
		end
	end
end

local function OnWerewolf(eventCode,werewolf)
	if BUI.init.Frames then
		if werewolf then BUI.CallLater("SetupAltBar",1000,BUI.Frames.SetupAltBar)
		else
			if BUI.Vars.EnableXPBar then
				BUI.CallLater("SetupAltBar",1000,BUI.Frames.SetupAltBar)
			else
				if BUI.Vars.PlayerFrame then BUI_PlayerFrame_Alt:SetHidden(true) end
			end
		end
	end
--	if BUI.Vars.Actions then BUI.CallLater("Actions_PairChanged",3000,BUI.Actions.OnPairChanged) end 
end

--Group Events
local function OnGroupChanged()
	BUI.InGroup=IsUnitGrouped('player')
	if BUI.init.Frames and BUI.Vars.RaidFrames then
		BUI.Frames:SetupGroup()
		--Clear group info
		BUI.StatShare.ClearStats()
		for i=1, 24 do
			local frame=BUI_RaidFrame["group"..i]
			frame.health.dps:SetText("")
			frame.debuff:SetHidden(true)
			frame.resist:SetHidden(true)
			frame.horn:SetHidden(true)
		end
	elseif BUI.InGroup then
		BUI.Frames.GetGroupData()
	end
	--Leader arrow
	if BUI.Vars.LeaderArrow then BUI.Reticle.LeaderArrow() end
	--Leader bar
	if GetUnitDisplayName(BUI.GroupLeader)==BUI.Player.accname then BUI.CustomBarUpdate() end
end

local function OnGroupLeaderChanged(eventCode,unitTag)
	local wasLeader=GetUnitDisplayName(BUI.GroupLeader)==BUI.Player.accname
	BUI.GroupLeader=unitTag
	local accname=GetUnitDisplayName(unitTag)
	BUI.Player.isLeader=BUI.Player.accname==accname
	--Leader bar
	if wasLeader and not BUI.Player.isLeader then BUI.CustomBarUpdate() end
	--Crown
	if BUI.Compass and BUI_Crown then
		BUI_Crown:SetHidden(not (BUI.GroupLeader and not BUI.Player.isLeader))
	end
	--Notifications
	if BUI.Vars.NotificationsGroup and not BUI.PvPzone then
		if accname and accname~="" then
			BUI.OnScreen.Notification(6,zo_strformat(SI_GROUP_NOTIFICATION_GROUP_LEADER_CHANGED,accname))	--New group leader
		end
	end
	OnGroupChanged()
end

local function OnGroupRoleChanged(eventCode, unitTag, isDps, isHealer, isTank)
--	if BUI.Vars.DeveloperMode then local role="Damage" if isTank then role="Tank" elseif isHealer then role="Healer" end d(GetUnitDisplayName(unitTag).." is now "..role) end
--	if BUI.Vars.DeveloperMode and GetUnitName(unitTag)==BUI.Player.name then d("Players role is changed") end
	if BUI.InGroup and BUI.init.Frames and BUI.Vars.RaidFrames then
		BUI.Frames:SetupGroup()
	end
end

local function OnGroupLeave(_,characterName)
	local name=string.gsub(characterName,"%^%w+","")	--zo_strformat(SI_UNIT_NAME, characterName)
	local wasLeader=GetUnitDisplayName(BUI.GroupLeader)==BUI.Player.accname
	BUI.InGroup=IsUnitGrouped('player')
	if name==BUI.Player.name then
		BUI.GroupMembers={}
		BUI.GroupLeader=nil
--		BUI.OnScreen.Update(true)	--Hide Notifications
		BUI.Player.role=nil
		--Clear death count
		for accname in pairs(BUI.Group) do if accname~="members" then BUI.Group[accname].death=nil end end
		--Notifications
		if BUI.Vars.NotificationsGroup and not BUI.PvPzone then
			BUI.OnScreen.Notification(5,BUI.Loc("You")..BUI.Loc("GroupMemberLeave"))	--Group leave
		end
		--Clear group info
		if BUI.Vars.RaidFrames then
			BUI.StatShare.ClearStats()
			for i=1, 24 do
				local frame=BUI_RaidFrame["group"..i]
				frame.health.dps:SetText("")
				frame.debuff:SetHidden(not gain)
				frame.resist:SetHidden(not gain)
			end
		end
	else
		if BUI.GroupMembers[name] then
			local id=BUI.GroupMembers[name]
			BUI.GroupMembers[id]=nil
			BUI.GroupMembers[name]=nil
		end
		if BUI.Vars.NotificationsGroup and not BUI.PvPzone then
			BUI.OnScreen.Notification(5,zo_strformat(SI_GROUPLEAVEREASON0,(BUI.Group[name] and BUI.Group[name].accname or name),characterName))	--Group member leave
		end
	end
	--Group frame
	if BUI.init.Frames and BUI.Vars.RaidFrames then BUI.Frames:SetupGroup() end
	--Leader arrow
	if BUI.Vars.LeaderArrow then BUI.Reticle.LeaderArrow() end
	--Leader bar
	if wasLeader then BUI.CustomBarUpdate() end
end

local function OnGroupRange(eventCode, unitTag, inRange)
	if BUI.init.Group then BUI.Frames:GroupRange(unitTag, inRange) end
end

local function OnXPUpdate(eventCode, unitTag, currentExp, maxExp, reason)
	if unitTag~='player' then return end
	--Update the data table
	BUI.Player:GetLevel()
	--Update the experience bar
	if BUI.init.Frames and BUI.Vars.EnableXPBar then BUI.Frames:SetupAltBar() end
end

local function OnLevel()
	--Update character level on unit frames
	if BUI.init.Frames then
		BUI.Frames:SetupPlayer()
		if BUI.Vars.RaidFrames then BUI.Frames:SetupGroup() end
	end
end

local function OnPing(eventCode, pingEventType, pingType, pingTag, offsetX, offsetY, isOwner)
	if offsetX+offsetY==0 or pingEventType~=PING_EVENT_ADDED or pingType~=MAP_PIN_TYPE_PING then return end
	--Register DPS posts
	if BUI.init.Stats then
		if BUI.Stats.AddPing(offsetX, offsetY, pingTag, isOwner) then return end
	end
	BUI.StatShare.OnPing(eventCode, pingEventType, pingType, pingTag, offsetX, offsetY, isOwner)
end

--COMBAT EVENT
local function OnCombatEvent(eventCode,result,isError,abilityName,abilityGraphic,abilityActionSlotType,sourceName,sourceType,targetName,targetType,hitValue,powerType,damageType,_,sourceUnitId,targetUnitId,abilityId)
	--Ignore errors
	if isError
--	or not BUI.inCombat
	or hitValue<5
	or hitValue>200000
	or abilityId==nil
	or IgnoreAbility[abilityId]
	or targetUnitId==nil
	or targetType==COMBAT_UNIT_TYPE_PLAYER_PET
	then return end
	local isDamage=ResultDamage[result]
	if isDamage
	and (sourceType==COMBAT_UNIT_TYPE_PLAYER or sourceType==COMBAT_UNIT_TYPE_PLAYER_PET)
--	and targetUnitId~=sourceUnitId
	then BUI.inCombat=true end
	if not BUI.inCombat then return end
	--Enchant Timer
--	if BUI.Vars.EnchantTimer==1 and Enchants[abilityId] and BUI.Player.name==zo_strformat("<<!aC:1>>",sourceName) then BUI.Frames.EnchantTimerStart(2) end
	--Statistics
	targetName=targetName=="" and ((BUI.GroupMembers[targetUnitId]) and BUI.GroupMembers[targetUnitId] or targetName) or string.gsub(targetName,"%^%w+","")	--zo_strformat(SI_UNIT_NAME,targetName)
--	sourceName=sourceName=="" and ((BUI.GroupMembers[sourceUnitId]) and BUI.GroupMembers[sourceUnitId] or sourceName) or zo_strformat(SI_UNIT_NAME,sourceName)
	--Pass damage event to handler
	if BUI.init.Stats then BUI.Damage.New(result,abilityName,sourceName,sourceType,targetName,hitValue,powerType,damageType,sourceUnitId,targetUnitId,abilityId,isDamage) end
end

--Events initialization
local function CombatEvents(disable)
	local filters={
			--Damage
			ACTION_RESULT_DAMAGE,
			ACTION_RESULT_DOT_TICK,
			ACTION_RESULT_BLOCKED_DAMAGE,
			ACTION_RESULT_DAMAGE_SHIELDED,
			ACTION_RESULT_CRITICAL_DAMAGE,
			ACTION_RESULT_DOT_TICK_CRITICAL,
			--Healing
			ACTION_RESULT_HOT_TICK,
			ACTION_RESULT_HEAL,
			ACTION_RESULT_CRITICAL_HEAL,
			ACTION_RESULT_HOT_TICK_CRITICAL,
			--Resource Change
			ACTION_RESULT_POWER_ENERGIZE,
			ACTION_RESULT_POWER_DRAIN,
			--Effects
--			ACTION_RESULT_BEGIN,
--			ACTION_RESULT_EFFECT_GAINED,
--			ACTION_RESULT_EFFECT_GAINED_DURATION,
--			ACTION_RESULT_EFFECT_FADED,
			}
	if not disable then
		--Stats Events
		EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_MAP_PING,				OnPing)
		--Combat Events
--		EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_COMBAT_EVENT,			OnCombatEvent)
		for i in pairs(filters) do
			EVENT_MANAGER:RegisterForEvent("BUI_Event"..i, EVENT_COMBAT_EVENT,	OnCombatEvent)
			EVENT_MANAGER:AddFilterForEvent("BUI_Event"..i, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, filters[i], REGISTER_FILTER_IS_ERROR, false)
		end
	else
		EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_MAP_PING)
		for i in pairs(filters) do
			EVENT_MANAGER:UnregisterForEvent("BUI_Event"..i, EVENT_COMBAT_EVENT)
		end
	end
end

local function SwitchCombatEvents(PvPzone)
	local on,off="|c33FE33enabled|r","|cFE3333disabled|r"
	d(BUI.DisplayName..": You have entered the "..(PvPzone and "PvP" or "PvE").." location")
	d("Combat statistics: "..(BUI.Stats.Initialize(PvPzone) and on or off))
	d("Notifications: "..(BUI.OnScreen.Initialize(PvPzone) and on or off))
	d("Stats share: "..(BUI.StatShare.Initialize(PvPzone) and on or off))
	CombatEvents(PvPzone)
end

local function OnActivated()
	BUI.MapId=string.match(string.gsub(GetMapTileTexture():lower(),"ui_map_",""),"maps/[%w%-]+/([%w%-]+_[%w%-]+)")
	--Recall cooldown
	local remain=GetRecallCooldown()
	if remain>0 then
		local now=GetGameTimeSeconds()
		BUI.Buffs.Effects[-6]={id=21676,timeStarted=now-600+remain/1000,timeEnding=now+remain/1000}
	end
	--Bounty cooldown
	local remain=GetSecondsUntilBountyDecaysToZero()
	if remain>0 then
		local now=GetGameTimeSeconds()
		BUI.Buffs.Effects[-8]={id=21798,timeStarted=now,timeEnding=now+remain}
	end
	--Food Notification
	if BUI.NeedToEat then CALLBACK_MANAGER:FireCallbacks("BUI_Food") end

	if BUI.init.Frames then
		BUI.Frames:SetupPlayer()
		BUI.Frames:SetupTarget()
		if BUI.Vars.RaidFrames then BUI.Frames:SetupGroup() end
	end
	--Group DPS frame
	if BUI_GroupDPS then BUI_GroupDPS:SetHidden(true) end
	--Combat Reticle
	if BUI.Vars.InCombatReticle and BUI.inCombat then
--		if BUI.Vars.DeveloperMode then d("Player still in combat...") end
		BUI.CallLater("Events_Activated",2000,function()
			if IsUnitInCombat('player') then
--				if BUI.Vars.DeveloperMode then d("Combat state: true (all is right)") end
			else
--				if BUI.Vars.DeveloperMode then d("Combat state: false (changing reticle back)") end
				BUI.inCombat=false
				BUI.Reticle.InCombat(false)
			end
		end)
	end
	--PvP zone
--	local MapContentType=GetMapContentType()
	local PvPzone=IsPlayerInAvAWorld() or IsActiveWorldBattleground()	--(MapContentType==MAP_CONTENT_AVA or MapContentType==MAP_CONTENT_BATTLEGROUND)
	if BUI.Vars.PvPmode and BUI.PvPzone~=PvPzone then
		SwitchCombatEvents(PvPzone)
	end
	BUI.PvPzone=PvPzone
	--Vanity Pet
	if not PvPzone then	--and not (RaidNotifier and RaidNotifier.Vars.general.last_pet) then
		if TrialLobby[BUI.MapId] then
			local id=GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_VANITY_PET)
			if id~=0 and BUI.Vars.AutoDismissPet then
				ZO_Alert(UI_ALERT_CATEGORY_ALERT,nil,"Dismissing: "..string.gsub(tostring(GetCollectibleName(id)),"%^%w+",""))
				UseCollectible(id)
				CallBackVanityPet=id
			end
		elseif CallBackVanityPet and not TrialNames[GetUnitZone('player')] and not IsCollectibleBlocked(CallBackVanityPet) then
			ZO_Alert(UI_ALERT_CATEGORY_ALERT,nil,"Activating: "..string.gsub(tostring(GetCollectibleName(CallBackVanityPet)),"%^%w+",""))
			UseCollectible(CallBackVanityPet) CallBackVanityPet=false
		end
	end
	--Leader arrow
	if BUI.Vars.LeaderArrow then BUI.Reticle.LeaderArrow() end
	--Leader bar
	BUI.Player.isLeader=IsUnitGroupLeader('player')
	if BUI.Player.isLeader then BUI.CustomBarUpdate() end
	--Leader marker
	BUI.Menu.MarkerLeader(true)
	--ParticleUI
	ParticleUI:Destroy3DRenderSpace() ParticleUI:Create3DRenderSpace()
end

local function OnLoad()
	OnBossesChanged()
	OnGroupChanged()
	--Flush messages
	for i=1, #messages do d(messages[i]) end messages={}

	BUI.CurrentQuickslot=GetCurrentQuickslot()
	BUI.InGroup=IsUnitGrouped('player')
	OnActivated()
	--Switch to recurring event
	EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_PLAYER_ACTIVATED)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_PLAYER_ACTIVATED, OnActivated)
end

function BUI.SwitchUnitFramesEvents()
	local Events={
		target={EVENT_TARGET_CHANGED,EVENT_UNIT_CHARACTER_NAME_CHANGED,EVENT_DISPOSITION_UPDATE,EVENT_RETICLE_TARGET_CHANGED},
		group={EVENT_UNIT_CREATED,EVENT_UNIT_DESTROYED,EVENT_LEVEL_UPDATE,EVENT_LEADER_UPDATE,EVENT_GROUP_SUPPORT_RANGE_UPDATE,EVENT_GROUP_UPDATE,EVENT_GROUP_MEMBER_LEFT,EVENT_GROUP_MEMBER_CONNECTED_STATUS,EVENT_GROUP_MEMBER_ROLE_CHANGED,EVENT_UNIT_DEATH_STATE_CHANGED,EVENT_RANK_POINT_UPDATE,EVENT_CHAMPION_POINT_UPDATE,EVENT_TITLE_UPDATE,EVENT_PLAYER_ACTIVATED,EVENT_INTERFACE_SETTING_CHANGED,EVENT_GUILD_NAME_AVAILABLE,EVENT_GUILD_ID_CHANGED},
		}

	if not BUI.Vars.DefaultTargetFrame then
		for _,event in pairs(Events.target) do
			ZO_UnitFrames:UnregisterForEvent(event)
		end
		CALLBACK_MANAGER:UnregisterCallback("TargetOfTargetEnabledChanged")
		if BUI.Vars.RaidFrames then
--			ZO_MostRecentEventHandler.OnEvent=function()end
			ZO_MostRecentEventHandler:AddFilterForEvent(REGISTER_FILTER_UNIT_TAG, "boss")
		end
	end

	if BUI.Vars.RaidFrames then
--[[		Hate gamepad lovers! Stupid and unstable hook (prevents changing default group frames style)
		local index=0
		function ZO_PlatformStyle:Apply()
			if not self.keyboardStyle then
				index=index+1
				if index==10 then return	--Disable local "OnGamepadPreferredModeChanged" function
				elseif index==12 then index=0 end
			end
			local style
			if BUI.GamepadMode then style=self.gamepadStyle else style=self.keyboardStyle end
			self.applyFunction(style)
		end
--]]
		for _,event in pairs(Events.group) do
			ZO_UnitFrames:UnregisterForEvent(event)
		end
		if not BUI.Vars.DefaultTargetFrame then
--			ZO_MostRecentEventHandler.OnEvent=function()end
			ZO_MostRecentEventHandler:AddFilterForEvent(REGISTER_FILTER_UNIT_TAG, "boss")
		end
	end
end
--[[
/script
for id=1, 40000 do
local name=GetAbilityName(id)
if string.find(name,"nare") then
local icon=GetAbilityIcon(id)
d("["..id.."] |t28:28:"..icon.."|t "..name)
end
end
--]]
function BUI.RegisterEvents()
		--Dafault frames events
	BUI.SwitchUnitFramesEvents()
		--User Interface Events
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_PLAYER_ACTIVATED,			OnLoad)
--	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_ACTION_LAYER_POPPED,			OnLayerChange)
--	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_ACTION_LAYER_PUSHED,			OnLayerChange)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_SCREEN_RESIZED,				OnScreenResize)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_GAMEPAD_PREFERRED_MODE_CHANGED,	function(_,gamepadPreferred)
		BUI.GamepadMode=gamepadPreferred
		BUI.Actions.Initialize()
		BUI.MiniMap.Initialize()
		BUI.Frames.ZO_Frame_reposition()
		BUI.Themes_Setup()
		if BUI.Vars.QuickSlots then BUI.QuickSlots.Update() end
		BUI.CustomBarUpdate()
	end)
		--Target Events
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_RETICLE_TARGET_CHANGED,		OnTargetChanged)
	EVENT_MANAGER:AddFilterForEvent("BUI_Event", EVENT_RETICLE_TARGET_CHANGED, REGISTER_FILTER_UNIT_TAG, "reticleover")
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_DISPOSITION_UPDATE,			BUI.Frames.TargetReactionUpdate)
	EVENT_MANAGER:AddFilterForEvent("BUI_Event", EVENT_DISPOSITION_UPDATE, REGISTER_FILTER_UNIT_TAG, "reticleover")
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_BOSSES_CHANGED,				OnBossesChanged)
		--Attribute Events
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_POWER_UPDATE,				OnPowerUpdate)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED,	OnVisualAdded)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED,	OnVisualUpdate)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED,	OnVisualAdded)
		--Player State Events
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_JUSTICE_BOUNTY_PAYOFF_AMOUNT_UPDATED, function()
		local now=GetGameTimeSeconds()
		local remain=GetSecondsUntilBountyDecaysToZero()
		BUI.Buffs.Effects[-8]={id=21798,timeStarted=now,timeEnding=now+remain}
	end)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_PLAYER_COMBAT_STATE,			OnCombatState)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_UNIT_DEATH_STATE_CHANGED,		OnDeath)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_PLAYER_ALIVE,				function() BUI.CallLater("SetupAltBar",14100,BUI.Frames.SetupAltBar) end)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_WEREWOLF_STATE_CHANGED,		OnWerewolf)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_BEGIN_SIEGE_CONTROL,			function()OnSiege(true)end)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_END_SIEGE_CONTROL,			function()OnSiege(false)end)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_MOUNTED_STATE_CHANGED,		OnMount)
--	EVENT_MANAGER:RegisterForEvent('BUI_Event', EVENT_NEW_MOVEMENT_IN_UI_MODE,		function()d(BUI.TimeStamp().." Player mooves")end)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_ACTIVE_QUICKSLOT_CHANGED,		function(_,Slot)
		if Slot>=9 and Slot<=16 then BUI.CurrentQuickslot=GetCurrentQuickslot() end
	end)
		--Group Events
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_GROUP_MEMBER_JOINED,			OnGroupChanged)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_GROUP_MEMBER_LEFT,			OnGroupLeave)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_LEADER_UPDATE,				OnGroupLeaderChanged)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_GROUP_MEMBER_CONNECTED_STATUS,	OnGroupChanged)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_GROUP_MEMBER_ROLES_CHANGED,		OnGroupRoleChanged)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_GROUP_SUPPORT_RANGE_UPDATE,		OnGroupRange)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_EFFECT_CHANGED,				OnEffectChanged)
	EVENT_MANAGER:AddFilterForEvent("BUI_Event", EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
--	EVENT_MANAGER:AddFilterForEvent("BUI_Event", EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "player")
--	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_VETERAN_DIFFICULTY_CHANGED,	function(_,unitTag, isDifficult) if BUI.Vars.DeveloperMode then d("Difficult mode: "..unitTag.."-"..tostring(isDifficult)) end end)
		--Experience Events
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_EXPERIENCE_UPDATE,			OnXPUpdate)
--	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_ALLIANCE_POINT_UPDATE,		OnAPUpdate)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_LEVEL_UPDATE,				OnLevel)
	EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_CHAMPION_POINT_UPDATE,		OnLevel)
		--Combat Events
	CombatEvents()
end

--Message functions
function dt(strings)
	local _t=""
	local _s=""
	for _,s in pairs(strings) do
		if t~="" then _s=string.rep(" ",4-math.fmod(string.len(_t),4)) end
		s=(s=="") and string.rep(" ",4) or s
		_t=_t.._s..s
	end
	d(_t)
end
function pl(msg)
	if CHAT_SYSTEM.primaryContainer then d(msg) else messages[#messages+1]=msg end
end
function a(text,sound)
	ZO_Alert(UI_ALERT_CATEGORY_ALERT, sound, text)
end
