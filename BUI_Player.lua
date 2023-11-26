local TargetResistance={
	[MONSTER_DIFFICULTY_NONE]=0,
	[MONSTER_DIFFICULTY_EASY]=6100,
	[MONSTER_DIFFICULTY_NORMAL]=9200,
	[MONSTER_DIFFICULTY_HARD]=12100,
	[MONSTER_DIFFICULTY_DEADLY]=18200
	}
local CPcap
local Attributes={[POWERTYPE_HEALTH]="health", [POWERTYPE_MAGICKA]="magicka", [POWERTYPE_STAMINA]="stamina",[POWERTYPE_ULTIMATE]="ultimate"}
local PreferredTargetValid,rotation_value,rotation_step,rotation_dir=false,math.pi*.05,0,1
--local STAT_CRIT_DMG_MAG,STAT_CRIT_DMG_PHIS,STAT_BLOCK_COST,STAT_BLOCK_MITIGATION=1140,1141,1142,1143

function BUI.Player:Initialize()
	--Setup initial character information
	BUI.Player.name	=string.gsub(GetUnitName('player'),"%^%w+","")
	BUI.Player.accname=GetUnitDisplayName('player')
	BUI.Player.race	=GetUnitRace('player')
	BUI.Player.class	=BUI.Player:GetClass(GetUnitClassId('player'))
	CPcap=GetMaxSpendableChampionPointsInAttribute()
	BUI.Player:GetLevel()
	--Load starting attributes
	local stats={
		{["name"]="health",	["id"]=POWERTYPE_HEALTH},
		{["name"]="magicka",	["id"]=POWERTYPE_MAGICKA},
		{["name"]="stamina",	["id"]=POWERTYPE_STAMINA},
		{["name"]="ultimate",	["id"]=POWERTYPE_ULTIMATE}
		}
	for i=1, #stats, 1 do
		local current, maximum=GetUnitPower("player", stats[i].id)
		BUI.Player[stats[i].name]={["current"]=current, ["max"]=maximum, ["pct"]=zo_roundToNearest(current/maximum,0.01)}
	end
	if BUI.Player.magicka.max>=BUI.Player.stamina.max then
		BUI.MainPower="magicka"
		BUI.SecondaryPower="stamina"
		BUI.MainPowerType=POWERTYPE_MAGICKA
	else
		BUI.MainPower="stamina"
		BUI.SecondaryPower="magicka"
		BUI.MainPowerType=POWERTYPE_STAMINA
	end
	--Load starting shield
	local value, maxValue	=GetUnitAttributeVisualizerEffectInfo('player',ATTRIBUTE_VISUAL_POWER_SHIELDING,STAT_MITIGATION,ATTRIBUTE_HEALTH,POWERTYPE_HEALTH)
	BUI.Player.shield		={["current"]=value or 0, ["max"]=maxValue or 0, ["pct"]=zo_roundToNearest((value or 0)/(maxValue or 0),0.01)}
	--Load starting trauma
	local value, maxValue	=GetUnitAttributeVisualizerEffectInfo('player',ATTRIBUTE_VISUAL_TRAUMA,STAT_MITIGATION,ATTRIBUTE_HEALTH,COMBAT_MECHANIC_FLAGS_HEALTH)
	BUI.Player.trauma		={["current"]=value or 0, ["max"]=maxValue or 0, ["pct"]=zo_roundToNearest((value or 0)/(maxValue or 0),0.01)}

	--Initialize group
	for i=1, 24 do
		BUI.Group['group'..i]={
			["health"]	={current=0,max=0,pct=100},
			["magicka"]	={current=0,max=0,pct=100},
			["stamina"]	={current=0,max=0,pct=100},
			["shield"]	={current=0,max=0,pct=100},
			["trauma"]  ={current=0,max=0,pct=100},
		}
	end
	BUI.Group.members=0
end

function BUI.Target:Initialize()
	--Setup initial target information
	local target		={
		name		="",
		level		=0,
		class		="",
		vlevel	=0,
		difficulty	=0,
		resist	=0,
		health	={["current"]=0, ["max"]=0, ["pct"]=1},
		shield	={["current"]=0, ["max"]=0, ["pct"]=1},
		trauma	={["current"]=0, ["max"]=0, ["pct"]=1},
		color		={.6,.1,.2,1},
	}
	--Populate the target object
	for attr, value in pairs(target) do BUI.Target[attr]=value end
	--Get target data
	BUI.Target:Update()
	--PreferredTarget
	if BUI.Vars.PreferredTarget then
		EVENT_MANAGER:RegisterForUpdate("BUI_PreferredTargetSwitch",250,function()
			local value=IsGameCameraPreferredTargetValid()
			if value~=PreferredTargetValid then
				if value then
					if not BUI.Target.preferred then BUI.Target.preferred=BUI.Target.attackable end
				else
					BUI.Target.preferred=nil
				end
				BUI.Reticle.TargetFocus(value and 1 or -1)
			end
			PreferredTargetValid=value
		end)
	end
end

function BUI.Target:Update(isTarget)
	if isTarget then
		--Update the target data object
		BUI.Target.name	=string.gsub(GetUnitName('reticleover'),"%^%w+","")
		BUI.Target.class	=BUI.Player:GetClass(GetUnitClassId('reticleover'))
		BUI.Target.level	=GetUnitLevel('reticleover')
		BUI.Target.vlevel	=GetUnitChampionPoints('reticleover')
		BUI.Target.difficulty=GetUnitDifficulty('reticleover')
		if BUI.Target.difficulty==0 then
			if string.sub(BUI.Target.name, 0, 6)=="Target" then BUI.Target.difficulty=MONSTER_DIFFICULTY_DEADLY
			elseif BUI.Vars.ReticleResist~=3 then BUI.Reticle.TargetResist(0)
			end
		end
		BUI.Target.resist	=TargetResistance[BUI.Target.difficulty]
		BUI.Target.shield.current,BUI.Target.shield.max=GetUnitAttributeVisualizerEffectInfo('reticleover',ATTRIBUTE_VISUAL_POWER_SHIELDING,STAT_MITIGATION,ATTRIBUTE_HEALTH,POWERTYPE_HEALTH) or 0
		BUI.Target.trauma.current,BUI.Target.trauma.max=GetUnitAttributeVisualizerEffectInfo('reticleover',ATTRIBUTE_VISUAL_TRAUMA,STAT_MITIGATION,ATTRIBUTE_HEALTH,COMBAT_MECHANIC_FLAGS_HEALTH) or 0
		BUI.Target.Invul	=GetUnitAttributeVisualizerEffectInfo('reticleover',ATTRIBUTE_VISUAL_UNWAVERING_POWER,STAT_MITIGATION,ATTRIBUTE_HEALTH,POWERTYPE_HEALTH)
		if IsUnitAttackable("reticleover") then BUI.Target.attackable=BUI.Target.name end
		BUI.Reticle.Invul()
		BUI.Reticle.Controlled()
		--Update target frame
		if BUI.init.Frames then
			BUI.Frames:SetupTarget()
			if BUI.Vars.CurvedFrame~=0 and BUI.inCombat then BUI.Curved.Target(true) end
		end
	else	--Otherwise ensure target frame stays hidden
		if BUI.init.Frames and not BUI.move then
			if BUI.Vars.TargetFrame then BUI_TargetFrame:SetHidden(true) end
--			if BUI.Target.status then ZO_ReticleContainerStealthIconStealthText:SetAlpha(0) end
			if BUI.Vars.CurvedFrame~=0 then BUI.Curved.Target(false) end
		end
		--Reticle timers
		if BUI.Vars.TauntTimer~=4 then BUI.Reticle.TauntTimer(0) end
		if BUI.Vars.CrusherTimer then BUI.Reticle.CrusherTimer(0) end
		--Reticle resist
		if BUI.Vars.ReticleResist~=3 then BUI.Reticle.TargetResist(0) end
		--Reticle invul
		if BUI.Vars.ReticleInvul then BUI_InvulTarget:SetHidden(true) end
		if BUI.Vars.Controlled then BUI.Reticle.Controlled(false) end
	end
	--Preferred target
	if BUI.Vars.PreferredTarget and PreferredTargetValid then
		BUI.Reticle.TargetFocus((isTarget and BUI.Target.preferred==BUI.Target.name) and 1 or -1)
	end
end

function BUI.Player:UpdateAttribute(unitTag, powerType, powerValue, powerMax, powerEffectiveMax)
	--Translate the attribute
	local power=Attributes[powerType]
	local isGroup=false
	--Player
	local data
	if unitTag=='player' then
		data=BUI.Player
		if BUI.Vars.EnableStats and powerMax then
			if not BUI.Stats.Current[BUI.ReportN][power] then
				BUI.Stats.Current[BUI.ReportN][power]=powerMax
			else
				BUI.Stats.Current[BUI.ReportN][power]=(BUI.Stats.Current[BUI.ReportN][power]+powerMax)/2
			end
		end
	--Target
	elseif unitTag=='reticleover' then data=BUI.Target
	--Group
	elseif (string.sub(unitTag, 0, 5)=="group") then
		data=BUI.Group[unitTag]
		isGroup=true
	end
	if not data then return end
	--If no value was passed, get new data
	if powerValue==nil then
		powerValue, powerMax, powerEffectiveMax=GetUnitPower(unitTag, powerType)
	end
	--Get the percentage
	local pct=math.max(math.floor((powerValue or 0)*100/powerMax+.5)/100,0)
	--Update the database object
	if unitTag~='reticleover' then data[power]={current=powerValue,max=powerMax,pct=pct} end
	--Update frames
	local shield=data.shield.current or 0
	local trauma=data.trauma.current or 0
	if BUI.init.Frames and powerType~=POWERTYPE_ULTIMATE then
		BUI.Frames.Attribute(unitTag, power, powerValue, powerMax, pct, shield, trauma)
		if BUI.Vars.CurvedFrame~=0 and not isGroup then BUI.Curved.Attribute(unitTag, power, powerValue, powerMax, pct, shield, trauma) end
	end
end

function BUI.Player:UpdateShield(unitTag, value, maxValue)
	local data,isGroup
	if unitTag=='player' then
		data=BUI.Player
	elseif unitTag=='reticleover' then
		data=BUI.Target
		BUI.Target.shield.current=value or 0
		BUI.Reticle.Invul()
	elseif BUI.init.Group and BUI.Group[unitTag] then
		data=BUI.Group[unitTag]
		isGroup=true
	else return end
	if not data or not data["health"] then return end
	if not value then
		value,maxValue=GetUnitAttributeVisualizerEffectInfo(unitTag,ATTRIBUTE_VISUAL_POWER_SHIELDING,STAT_MITIGATION,ATTRIBUTE_HEALTH,POWERTYPE_HEALTH) or 0
	end
	if value==data.shield.current then return end
	local pct=value/data.health.max
	data.shield={["current"]=value, ["max"]=maxValue, ["pct"]=pct}
	--Update frames
	if BUI.init.Frames then
		if BUI.Vars.PlayerFrame or BUI.Vars.RaidFrames then BUI.Frames:Shield(unitTag,value,pct,data.health.current,data.health.max,data.trauma.current) end
		if BUI.Vars.CurvedFrame~=0 and not isGroup then BUI.Curved.Shield(unitTag,value,pct,data.health.current,data.trauma.current,data.trauma.current) end
	end
end

function BUI.Player:UpdateTrauma(unitTag, value, maxValue)
	local data,isGroup
	if unitTag=='player' then
		data=BUI.Player
	elseif unitTag=='reticleover' then
		data=BUI.Target
		BUI.Target.trauma.current=value or 0
		BUI.Reticle.Invul()
	elseif BUI.init.Group and BUI.Group[unitTag] then
		data=BUI.Group[unitTag]
		isGroup=true
	else return end
	if not data or not data["health"] then return end
	if not value then
		value,maxValue=GetUnitAttributeVisualizerEffectInfo(unitTag,ATTRIBUTE_VISUAL_TRAUMA,STAT_MITIGATION,ATTRIBUTE_HEALTH,COMBAT_MECHANIC_FLAGS_HEALTH) or 0
	end
	if value==data.trauma.current then return end
	local pct=value/data.health.max
	data.trauma={["current"]=value, ["max"]=maxValue, ["pct"]=pct}
	--Update frames
	if BUI.init.Frames then
		if BUI.Vars.PlayerFrame or BUI.Vars.RaidFrames then BUI.Frames:Trauma(unitTag,value,pct,data.health.current,data.health.max,data.shield.current) end
		if BUI.Vars.CurvedFrame~=0 and not isGroup then BUI.Curved.Trauma(unitTag,value,pct,data.health.current,data.shield.current,data.shield.current) end
	end
end
--[[ API<100034
local STAT_CRIT_DMG_MAG,STAT_CRIT_DMG_PHIS,STAT_BLOCK_COST,STAT_BLOCK_MITIGATION=1140,1141,1142,1143

local function GetProtectBonus()
	local protect={["Minor Protection"]=8,["Minor Aegis"]=5,["Major Protection"]=30}
	local protect_bonus=0
	for i=1, GetNumBuffs("player") do
		local name=GetUnitBuffInfo("player",i)
		if protect[name] then protect_bonus=protect_bonus+protect[name] end
	end
	return protect_bonus
end

local function GetDivinesBonus()
	local worn={0,2,3,6,8,9,16}
	local bonus=0
	for _,i in pairs(worn) do
		local x, y=GetItemLinkTraitInfo(GetItemLink(BAG_WORN,i) )
		if x==ITEM_TRAIT_TYPE_ARMOR_DIVINES then bonus=bonus+(tonumber(string.sub(y,string.find(y, "%d.%d"))) or 0) end
	end
	return bonus
end

local function GetCritDamage()
	--buff_bonus
	local forces={["Major Force"]=15,["Minor Force"]=10}
	local buff_bonus=0
	for i=1, GetNumBuffs("player") do
		local name,_,_,_,_,_,_,_,_,_,id=GetUnitBuffInfo("player",i)
		if forces[name] then buff_bonus=buff_bonus+forces[name] end
		if id==13984 then buff_bonus=buff_bonus+math.floor(9*(1+GetDivinesBonus()/100)) end
	end

	--class_bonus
	local class=GetUnitClassId("player")
	local class_bonus=0
	local ability_slotted=0
	local ability={}
	if class==3 or class==6 then	--NB or Templar
		for i=1, 6 do
			local id=GetSkillAbilityId(1,1,i)
			ability[id]=true	--nb assasination abilities or templar aedric spear abilities
		end
		for i=3, 8 do
			if ability[GetSlotBoundId(i)] then ability_slotted=1 end
		end
		local passive_level=GetSkillAbilityUpgradeInfo(1,1,(class==3 and 10 or 7))
		class_bonus=5*passive_level*ability_slotted
	end
	local race_bonus=0
	if GetUnitRaceId("player")==9 then	--Khajiit
		local passive_level=GetSkillAbilityUpgradeInfo(7,1,4)
		race_bonus=math.floor(passive_level*3.4)
	end

	local points_s=GetNumPointsSpentOnChampionSkill(5, 2)*0.01	--Points in precise strikes
	local points_m=GetNumPointsSpentOnChampionSkill(7, 3)*0.01	--Points in elfborn
	return 50+race_bonus+class_bonus+buff_bonus+math.floor(0.25*points_s*(2-points_s)*100),50+race_bonus+class_bonus+buff_bonus+math.floor(0.25*points_m*(2-points_m)*100)
end

local function GetBlockCost()
--	if BUI.language~="en" then return false end
	local passive=0
	local ability=0
	local mitigation=0
	local pair=GetActiveWeaponPairInfo()
	local function Get_sturdy_bonus()
		local worn={(pair==1 and EQUIP_SLOT_OFF_HAND or EQUIP_SLOT_BACKUP_OFF),EQUIP_SLOT_HEAD,EQUIP_SLOT_SHOULDERS,EQUIP_SLOT_CHEST,EQUIP_SLOT_WAIST,EQUIP_SLOT_LEGS,EQUIP_SLOT_HAND,EQUIP_SLOT_FEET}
		local bonus=0
		local footman=false
		for _,i in pairs(worn) do
			local link=GetItemLink(BAG_WORN,i)
			local x, y=GetItemLinkTraitInfo(link)
			if x==ITEM_TRAIT_TYPE_ARMOR_STURDY then
				local s1,s2=string.find(y, "%d.%d")
				local value=tonumber(s1 and string.sub(y,s1,s2) or string.sub(y,string.find(y, "[0-9]+")))
				if value then bonus=bonus+value end
			end
			local hasSet,setName,_,numEquipped,maxEquipped=GetItemLinkSetInfo(link)
			if hasSet and setName=="Footman's Fortune" and maxEquipped==numEquipped then footman=true end
		end
		if footman then mitigation=mitigation+8 end
		return 1-bonus/100
	end

	local function Get_jewelry_bonus()
		local worn={EQUIP_SLOT_NECK,EQUIP_SLOT_RING1,EQUIP_SLOT_RING2}
		local bonus=0
		for _,i in pairs(worn) do
			local itemLink=GetItemLink(BAG_WORN,i)
			if GetEnchantSearchCategoryType(GetItemLinkAppliedEnchantId(itemLink))==ENCHANTMENT_SEARCH_CATEGORY_REDUCE_BLOCK_AND_BASH then
				local enchant=select(3,GetItemLinkEnchantInfo(itemLink))
				local s1,s2=string.find(enchant, "[0-9]+")
				if s1 then
					local value=tonumber(string.sub(enchant,s1,s2))
					if value then bonus=bonus+value end
				end
			end
		end
		return bonus
	end

	local class=GetUnitClassId("player")
	if class==1 then		--DK
		mitigation=mitigation+GetSkillAbilityUpgradeInfo(1,2,7)*5
	elseif class==6 then	--Templar
		local ability_slotted=false
		local ability={}
		for i=1, 6 do
			local id=GetSkillAbilityId(1,1,i)
			ability[id]=true	--templar aedric spear abilities
		end
		for i=3, 8 do
			if ability[GetSlotBoundId(i)] then ability_slotted=true end
		end
		if ability_slotted then mitigation=mitigation+math.floor(GetSkillAbilityUpgradeInfo(1,1,8)*7.5) end
	end

	if GetItemWeaponType(BAG_WORN,(pair==1 and EQUIP_SLOT_MAIN_HAND or EQUIP_SLOT_BACKUP_MAIN))==WEAPONTYPE_FROST_STAFF then
		passive=GetSkillAbilityUpgradeInfo(2,5,10)*18
		mitigation=mitigation+GetSkillAbilityUpgradeInfo(2,5,10)*10
	elseif GetItemWeaponType(BAG_WORN,(pair==1 and EQUIP_SLOT_OFF_HAND or EQUIP_SLOT_BACKUP_OFF))==WEAPONTYPE_SHIELD then
		passive=GetSkillAbilityUpgradeInfo(2,2,7)*18
		mitigation=mitigation+GetSkillAbilityUpgradeInfo(2,2,8)*10
		local id=GetSkillAbilityId(2,2,4)
		for i=3, 7 do
			if id==GetSlotBoundId(i) then
				ability=ability+8
				mitigation=mitigation+8
			end
		end
	end
	passive,ability=1-passive/100,1-ability/100

	local points=GetNumPointsSpentOnChampionSkill(8, 3)*0.01 points=1-math.floor(0.25*points*(2-points)*100)/100
	local cost=math.floor((1730*points-Get_jewelry_bonus())*Get_sturdy_bonus()*passive*ability)
--	d("Mitigation: "..mitigation,"Champ: "..points,"Sturdy: "..Get_sturdy_bonus(),"Jevelry: "..Get_jewelry_bonus(),"Passive: "..passive,"Ability: "..ability)
	return cost,(100-.5*(100-mitigation))
end
--	/script local name=GetSkillAbilityInfo(8,6,7) d(name)
--	/script local name=GetSkillLineName(8,2,4) d(name)
--	/script d(GetSkillAbilityUpgradeInfo(8,6,7))
local function GetProcSetPenetration()
	local pair=GetActiveWeaponPairInfo()
	local worn={(pair==1 and EQUIP_SLOT_MAIN_HAND or EQUIP_SLOT_BACKUP_MAIN),(pair==1 and EQUIP_SLOT_OFF_HAND or EQUIP_SLOT_BACKUP_OFF),EQUIP_SLOT_BACKUP_OFF,EQUIP_SLOT_HEAD,EQUIP_SLOT_SHOULDERS,EQUIP_SLOT_CHEST,EQUIP_SLOT_WAIST,EQUIP_SLOT_LEGS,EQUIP_SLOT_HAND,EQUIP_SLOT_FEET}
	local set={["Twice-Fanged Serpent"]=true,}	--["Night Mother's Gaze"]=true,["Sunderflame"]=true}
	local penetr=0
	for _,i in pairs(worn) do
		local link=GetItemLink(BAG_WORN,i)
		local hasSet,setName,_,numEquipped,maxEquipped=GetItemLinkSetInfo(link)
		if hasSet and set[setName] and maxEquipped==numEquipped then
			local _,desc=GetItemLinkSetBonusInfo(link, false, 4)
			local a1,a2=string.find(desc, "%d%d%d+")
			if a1 then
				local s1,s2=string.find(desc, "%d%d%d+",a2+1)
				local value=tonumber(s1 and string.sub(desc,s1,s2) or string.sub(desc,a1,a2))
				if value then penetr=value end
			end
			if setName=="Twice-Fanged Serpent" then penetr=penetr*5 end
--			d(setName..": "..penetr)
			break
		end
	end
	return penetr
end

function BUI.Player.StatSection()
	local function format_number(n)
		local k=1 while k~=0 do n,k=string.gsub(n,"^(-?%d+)(%d%d%d)", '%1 %2') end return n
	end
	--Player attributes section
	if BUI.Vars.PlayerStatSection and BUI.API<100034 then
		local AddStatRowOrg=ZO_Stats.AddStatRow
		local missingParameter
		local function GetStat(stat)
			if stat==STAT_CRIT_DMG_PHIS or stat==STAT_CRIT_DMG_MAG then
				local bonus_p,bonus_m=GetCritDamage()
				return stat==STAT_CRIT_DMG_PHIS and bonus_p or bonus_m
			elseif stat==STAT_BLOCK_COST or stat==STAT_BLOCK_MITIGATION then
				local cost,mitigation=GetBlockCost()
				return stat==STAT_BLOCK_COST and cost or mitigation
			elseif stat==STAT_SPELL_RESIST or stat==STAT_PHYSICAL_RESIST or stat==STAT_SPELL_PENETRATION or stat==STAT_PHYSICAL_PENETRATION then
				local value=GetPlayerStat(stat)
				local perc=math.floor(value/66.2)/10
				if stat==STAT_PHYSICAL_PENETRATION then
					value=value+GetProcSetPenetration()
					perc=math.floor(value/66.2)/10
				elseif stat==STAT_SPELL_RESIST or stat==STAT_PHYSICAL_RESIST then
					local bonus=GetProtectBonus()
					perc=math.min(50,math.floor(value/66.2)/10)..(bonus>0 and "+"..bonus or "")
				end
				return format_number(value).." |cBBBBBB("..perc.."%)|r"
			elseif stat==STAT_HEALTH_MAX or stat==STAT_MAGICKA_MAX or stat==STAT_STAMINA_MAX then
				return format_number(GetPlayerStat(stat))
			else
				return GetPlayerStat(stat)
			end
		end
		ZO_Stats.AddStatRow=function(...)
			missingParameter=(select(1,...))
			local ret=AddStatRowOrg(...)
			ZO_Stats.AddStatRow=AddStatRowOrg
			return ret
		end
		ZO_StatEntry_Keyboard.GetDisplayValue=function(self,targetValue)
			local value=targetValue or GetStat(self.statType)
			if self.statType==STAT_CRITICAL_STRIKE or self.statType==STAT_SPELL_CRITICAL then
				return zo_strformat(SI_STAT_VALUE_PERCENT, GetCriticalStrikeChance(value))
			elseif self.statType==STAT_CRIT_DMG_PHIS or self.statType==STAT_CRIT_DMG_MAG or self.statType==STAT_BLOCK_MITIGATION then
				return zo_strformat(SI_STAT_VALUE_PERCENT, value)
			else
				return tostring(value)
			end
		end
		local CreateAttributesSectionOrg=ZO_Stats.CreateAttributesSection
		ZO_Stats.CreateAttributesSection=function(...)
			local ret=CreateAttributesSectionOrg(...)
			ZO_Stats.SetNextControlPadding(missingParameter,20)
			ZO_Stats.AddStatRow(missingParameter,STAT_SPELL_PENETRATION,STAT_PHYSICAL_PENETRATION)
			ZO_Stats.SetNextControlPadding(missingParameter,0)
			ZO_Stats.AddStatRow(missingParameter,STAT_CRIT_DMG_MAG,STAT_CRIT_DMG_PHIS)
--			if not RuESO_init then
				ZO_Stats.SetNextControlPadding(missingParameter,20)
				ZO_Stats.AddStatRow(missingParameter,STAT_BLOCK_COST,STAT_BLOCK_MITIGATION)
--			end
			return ret
		end
--		ZO_Stats.CreateAttributesSection=CreateAttributesSectionOrg
	end
end

BUI.GetCritDamage=GetCritDamage
BUI.GetBlockCost=GetBlockCost
--]]
	--HELPER FUNCTIONS
function BUI:IsCritter(unitTag)
	--Critters meet all the following criteria: Level 1, Difficulty=NONE, and Neutral or Friendly reaction
	return false	--(GetUnitLevel(unitTag)==1 and GetUnitDifficulty(unitTag)==MONSTER_DIFFICULTY_NONE and (GetUnitReaction(unitTag)==UNIT_REACTION_NEUTRAL or GetUnitReaction(unitTag)==UNIT_REACTION_FRIENDLY))
end

function BUI.Player:GetLevel()
	BUI.Player.level	=GetUnitLevel('player')
	BUI.Player.alevel	=GetUnitAvARank('player')
	BUI.Player.clevel	=GetPlayerChampionPointsEarned()
	BUI.Player.exp	=GetUnitXP('player')
	BUI.Player.cxp	=GetPlayerChampionXP() or 0
end

function BUI.Player:GetColoredLevel(unitTag)
	local cplevel=unitTag=='reticleover' and BUI.Target.vlevel or GetUnitChampionPoints(unitTag)
	if cplevel>0 then
		if cplevel>=CPcap then level="|cffff33"..cplevel.."|r"
		elseif cplevel>159 then level="|cff33ff"..cplevel.."|r"
		else level="|c7f7fff"..cplevel.."|r"
		end
	else level="|c33ff33"..(unitTag=='reticleover' and BUI.Target.level or GetUnitLevel(unitTag)).."|r"
	end
	return level
end

function BUI.Player:GetClass(classId)
	local arr={"Dragonknight", "Scorcerer", "Nightblade", "Warden", "Necromancer", "Templar"}
	arr[117]="Arcanist"
	return arr[classId]
end
