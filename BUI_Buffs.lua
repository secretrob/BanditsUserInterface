local VampireStage={[135397]=1,[135399]=2,[135400]=3,[135402]=4}
local Passives={
--	[35771]=true,[35776]=true,[35783]=true,[35792]=true,	--Vampirism stage
	[91449]=true,[86075]=true,--Breda's Magnificent Mead
	[40359]=true,--Fed on ally
	[40525]=true,--Bit an ally
	[43752]=true,--Soul Summons
	[89683]=true,[66776]=true,[64210]=true,[77123]=true,[84364]=true,[84365]=true,[99463]=true,[99462]=true,[85502]=true,[85503]=true,[91369]=true,[118985]=true,[136348]=true,[152514]=true,[167846]=true,[181478]=true,--EXP Buff
	[96118]=true,--Witchmother's Boon
	[21676]=true,--Recall cooldown
	[147687]=true,--Alliance Skill Gain Boost
	[21798]=true,--Bounty timer
	}
local buffFood={
	[72822]={Health=true},[17407]={Health=true},[66551]={Health=true},[61259]={Health=true},[66124]={Health=true},[66125]={Health=true},[72816]={Health=true},[72824]={Health=true},[72957]={Health=true},[72960]={Health=true},[72962]={Health=true},[72819]={Health=true},[89971]={Health=true},
--	[17565]=true,[17567]=true,[17569]=true,[47049]=true,[47051]=true,[66576]=true,[17573]=true,[47050]=true,
	[17577]={Magicka=true,Stamina=true},[61294]={Magicka=true,Stamina=true},[72961]={Magicka=true,Stamina=true},[84681]={Magicka=true,Stamina=true},[89955]={Magicka=true,Stamina=true},
	[61257]={Health=true,Magicka=true},[72959]={Health=true,Magicka=true},[84731]={Health=true,Magicka=true},[84735]={Health=true,Magicka=true},[100498]={Health=true,Magicka=true},[107748]={Health=true,Magicka=true},[127531]={Health=true,Magicka=true},
	[61261]={Stamina=true},[66129]={Stamina=true},[66130]={Stamina=true},[68412]={Stamina=true},[86673]={Stamina=true},
	[66127]={Magicka=true},[66128]={Magicka=true},[68413]={Magicka=true},[66568]={Magicka=true},[61260]={Magicka=true},[84678]={Magicka=true},[84709]={Magicka=true},[84725]={Magicka=true},[84720]={Magicka=true},
	[61341]=true,[61344]=true,[61340]=true,[61335]=true,[61345]=true,[66131]=true,[66132]=true,[66136]=true,[66137]=true,[66140]=true,[66141]=true,[17614]=true,[61350]=true,[84700]=true,[84704]=true,[100502]=true,[68416]=true,[86746]=true,[86559]=true,--Recovery
	[68411]={Health=true,Magicka=true,Stamina=true},[17581]={Health=true,Magicka=true,Stamina=true},[61218]={Health=true,Magicka=true,Stamina=true},[85484]={Health=true,Magicka=true,Stamina=true},[100488]={Health=true,Magicka=true,Stamina=true},[127596]={Health=true,Magicka=true,Stamina=true},
	[72956]={Health=true,Stamina=true},[61255]={Health=true,Stamina=true},[89957]={Health=true,Stamina=true},[107789]={Health=true,Stamina=true},[127572]={Health=true,Stamina=true},
	}
local oakensoul={
	[61665]="Major Brutality",
	[61667]="Major Savagery",
	[61687]="Major Sorcery",
	[61689]="Major Prophecy",
	[61694]="Major Resolve",
	[61697]="Minor Fortitude",
	[61704]="Minor Endurance",
	[61706]="Minor Intellect",
	[61708]="Minor Heroism",
	[61710]="Minor Mending",
	[61721]="Minor Protection",
	[61737]="Empower",
	[61744]="Minor Berserk",
	[61746]="Minor Force",
	[76617]="Minor Slayer",
	[76618]="Minor Aegis",
	[147417]="Minor Courage",
	}	
for id in pairs(buffFood) do Passives[id]=true end
for id in pairs(VampireStage) do Passives[id]=true end
local Active={
	[93648]=true,--Fetcher Infection
	}
--[[
local Reflection={
	[21007]=true,[33741]=true,[33742]=true,[33743]=true,[21014]=true,[33745]=true,[33747]=true,[33749]=true,[21017]=true,[33753]=true,[33757]=true,[33759]=true,	--Reflective Scale (DK)
	[86135]=true,[86136]=true,[86137]=true,[86138]=true,[86139]=true,[86140]=true,[86141]=true,[86142]=true,[86143]=true,[86144]=true,[86145]=true,[86146]=true,	--Crystallized Shield (Warden)
--	[79094]="Hindrance",	--Calefactor
--	[93981]="Static Overcharge",	--Calefactor
--	[93918]=true,--Optimize Automata (Calefactor)
	[96007]=true,--Kinetic Shield (The Imperfect)
	[87480]=true,--Nature's Preservation (Caillaoife)
	[3349]=true,--Reflective Shadows (Hag)
	[64824]=true,--Hardened Plates (Nyzchaleft)
	}
local OffBalance,CcImmunity,ObImmunity
function BUI.ReticleIcons_Init(size)
--	/script d(zo_iconFormat(GetAbilityIcon(29552),28,28))
	OffBalance={[62988]=zo_iconFormat(GetAbilityIcon(62988),size,size)}
	local icon=zo_iconFormat(GetAbilityIcon(29552),size,size)
	CcImmunity={
	[38797]=zo_iconFormat(GetAbilityIcon(38797),size,size),	--Forward Momentum
	[38117]=zo_iconFormat(GetAbilityIcon(38117),size,size),
	[29552]=icon,[41078]=icon,[41080]=icon,[41082]=icon,[39205]=icon,[41085]=icon,[41088]=icon,[41091]=icon,[39197]=icon,[41097]=icon,[41100]=icon,[41103]=icon,	--Immovable
	[45239]=zo_iconFormat("/esoui/art/icons/consumable_potion_008_type_005.dds",size,size),
	}
	ObImmunity={[102771]=zo_iconFormat(GetAbilityIcon(102771),size,size)}
end
--]]
local OWN_PENETR,TMP_PENETR,ICON_PENETR=0,0,nil
--local CD_ENCHANT,TIMER_ENCHANT,ICON_ENCHANT=9000,0
local WeaponSlot={EQUIP_SLOT_MAIN_HAND,EQUIP_SLOT_BACKUP_MAIN}
--local RoundedReticle={left={},right={},bottom={}}
local StacksTotal={
[51176]=5,--Twice-Fanged Serpent
[50978]=5,--Berserking Warrior
[110118]=20,--Siroria's Boon
[110504]=20,--Arms of Relequen
}
local ProcEffects={
[126924]={n=0,cd=10,name=GetAbilityName(126924),icon="esoui/art/icons/ability_mage_010.dds"},	--Hollowfang Thirst
[136098]={n=-1,cd=10,name=GetAbilityName(136098),icon="esoui/art/icons/ability_mage_010.dds"},[137995]={n=-1,cd=10,name=GetAbilityName(137995),icon="esoui/art/icons/ability_mage_010.dds"},	--Kyne's Blessing
[107141]={n=-2,cd=10,name=GetAbilityName(107141),icon="esoui/art/icons/ability_templar_rune_focus.dds"},[109084]={n=-2,cd=10,name=GetAbilityName(109084),icon="esoui/art/icons/ability_templar_rune_focus.dds"},	--Vestment of Olorime
[110067]={n=-3,cd=10,name=GetAbilityName(110067),icon="esoui/art/icons/ability_mage_010.dds"},[110143]={n=-3,cd=10,name=GetAbilityName(110143),icon="esoui/art/icons/ability_mage_010.dds"},	--Siroria's Boon
[99204]={n=-4,cd=18,name=GetAbilityName(99204),icon="esoui/art/icons/gear_clockwork_medium_head_a.dds"},	--Mechanical Acuity
[126941]={n=-5,cd=7,name=GetAbilityName(126941),icon="esoui/art/icons/death_recap_disease_melee.dds"},	--Maarselok
[21676]={n=-6,cd=600,name="Recall cooldown",icon="esoui/art/icons/ability_mage_025.dds",negative=true},	--Recall
[81036]={n=-7,cd=15,name=GetAbilityName(81036),icon="esoui/art/icons/pet_200_dwarven-ebonyyellow.dds"},	--Sentinel of Rkugamz
[21798]={n=-8,cd=0,name="Bounty timer",icon=GetAbilityIcon(29702),negative=true},	--Bounty timer
}
local UpdateCooldown=false
local Synergy_id={
[108799]=1,[108802]=1,[108821]=1,[108924]=1,--Shard, Orb
[48052]=1, -- Trial dummy / Blessed Shards
[95926]=1, -- Holy Shards (Luminous Shards)
[85434]=1, -- Combustion (Mystic or Unmorphed)
[63512]=1, -- Healing Combustion (Energy)
[108607]=2,--Conduit (Sorc)
[108824]=3,--Ritual (Templar)
[108826]=4,--Healing Seed (Warden)
[108794]=5,[108797]=5,--Bone Shield (Undaunted)
[108782]=6,[108787]=6,--Blood Altar (Undaunted)
[108788]=7,[108791]=7,[108792]=7,--Trapping Webs (Undaunted)
[108793]=8,--Radiate (Undaunted)
[48085]=9,--Charged Lightning (Sorc)
[108805]=10,--Shackle (DK)
[108807]=11,--Ignite (DK)
[108822]=12,[108823]=12,--Gravity Crush (Templar)
[108808]=13,--Hidden Refresh (NB)
[108814]=14,--Soul Leech (NB)
[125219]=15,--Unnerving Boneyard (Necr)
[125220]=16,--Agony Totem (Necr)
[58775]=17,--Feeding Frenzy
[142318]=18,--Sanguine Burst (Lady Thorn)

[94973]=1,[95926]=1,[95040]=1,[95042]=1,--Shard, Orb
[43769]=2,--Conduit (Sorc)
[22270]=3,--Ritual (Templar)
[85576]=4,--Healing Seed (Warden)
[39424]=5,[42196]=5,--Bone Shield (Undaunted)
[39519]=6,[41965]=6,--Blood Altar (Undaunted)
[39451]=7,[41997]=7,[42019]=7,--Trapping Webs (Undaunted)
[41840]=8,--Radiate (Undaunted)
[48085]=9,--Charged Lightning (Sorc)
[67717]=10,--Shackle (DK)
[48040]=11,--Ignite (DK)
[48938]=12,[48939]=12,--Gravity Crush (Templar)
[37729]=13,--Hidden Refresh (NB)
[25172]=14,--Soul Leech (NB)
[115567]=15,--Unnerving Boneyard (Necr)
[118610]=16,--Agony Totem (Necr)
[58813]=17,--Feeding Frenzy
[141971]=18,--Sanguine Burst (Lady Thorn)
[191080]=19, -- Runebreak (Arcanist)
[190646]=20, -- Passage Between Worlds (Arcanist)
}
local Synergy_Name={
[1]="Resource",
[2]="Conduit",
[3]="Ritual",
[4]="Healing Seed",
[5]="Bone Shield",
[6]="Blood Altar",
[7]="Trapping Webs",
[8]="Radiate",
[9]="Charged Lightning",
[10]="Shackle",
[11]="Ignite",
[12]="Gravity Crush",
[13]="Hidden Refresh",
[14]="Soul Leech",
[15]="Unnerving Boneyard",
[16]="Agony Totem",
[17]="Feeding Frenzy",
[18]="Sanguine Burst",
[19]="Runebreak",
[20]="Passage Between Worlds",
}
local Synergy_Texture={
[1]="/esoui/art/icons/ability_undaunted_004.dds",
[2]="/esoui/art/icons/ability_sorcerer_liquid_lightning.dds",
[3]="/esoui/art/icons/ability_templar_extended_ritual.dds",
[4]="/esoui/art/icons/ability_warden_007.dds",
[5]="/esoui/art/icons/ability_undaunted_005b.dds",
[6]="/esoui/art/icons/ability_undaunted_001_b.dds",
[7]="/esoui/art/icons/ability_undaunted_003_b.dds",
[8]="/esoui/art/icons/ability_undaunted_002_b.dds",
[9]="/esoui/art/icons/ability_sorcerer_storm_atronach.dds",
[10]="/esoui/art/icons/ability_dragonknight_006.dds",
[11]="/esoui/art/icons/ability_dragonknight_010.dds",
[12]="/esoui/art/icons/ability_templar_solar_disturbance.dds",
[13]="/esoui/art/icons/ability_nightblade_015.dds",
[14]="/esoui/art/icons/ability_nightblade_018.dds",
[15]="/esoui/art/icons/ability_necromancer_004.dds",
[16]="/esoui/art/icons/ability_necromancer_010_b.dds",
[17]="/esoui/art/icons/ability_werewolf_005_b.dds",
[18]="/esoui/art/icons/ability_u23_bloodball_chokeonit.dds",
[19]="/esoui/art/icons/ability_arcanist_004.dds",
[20]="/esoui/art/icons/ability_arcanist_016_b.dds",
}
for id,i in pairs(Synergy_id) do BUI.SynergyTexture[id]=Synergy_Texture[i] end
local prog_color,theme_color={.2,.5,.6,1}
local source_color={
	[1]={.9,.2,.2,.6},	--Negative
	[2]={.4,.4,.4,.6},	--Cast by player
	[3]={.3,.8,.3,.6},	--Positive
	}
local PotionIcon={
	magicka="/esoui/art/icons/consumable_potion_002_type_005.dds",
	stamina="/esoui/art/icons/consumable_potion_003_type_005.dds"
}
BUI.SynergyCd={}
BUI.Buffs	={
	UpdateTime		=200,
	Effects		={},
	Defaults		={
		PlayerBuffs		=true,
		PlayerBuffSize	=44,
		BuffsImportant	=true,
		MinimumDuration	=3,
		CastbyPlayer	=true,
		PlayerBuffsAlign	=CENTER,
		BUI_BuffsP		={CENTER,CENTER,0,345},
		--Passives
		BuffsPassives	="On additional panel",
		PassiveBuffSize	=36,
		PassiveProgress	=false,
		PassivePWidth	=100,
		PassivePSide	="left",
		PassiveOakFilter=true,
		BUI_BuffsPas	={BOTTOMRIGHT,BOTTOMRIGHT,0,0},
		--TargetBuffs
		TargetBuffs		=true,
		TargetBuffSize	=44,
		BuffsOtherHide	=true,
		TargetBuffsAlign	=CENTER,
		BUI_BuffsT		={CENTER,CENTER,0,-350},
		--CustomBuffs
		EnableCustomBuffs	=false,
		CustomBuffSize	=44,
		CustomBuffsDirection	="vertical",
		CustomBuffsProgress	=true,
		CustomBuffsPWidth	=120,
		CustomBuffsPSide	="right",
		BUI_BuffsC		={CENTER,CENTER,0,300},
		CustomBuffs		={},
		--SynergyCd
		EnableSynergyCd	=false,
		SynergyCdSize	=44,
		SynergyCdDirection="vertical",
		SynergyCdProgress	=true,
		SynergyCdPWidth	=120,
		SynergyCdPSide	="right",
		BUI_BuffsS		={CENTER,CENTER,-300,200},
		--Widgets
		EnableWidgets	=false,
		WidgetsSize		=44,
--		WidgetsProgress	=false,
		WidgetsPWidth	=120,
		WidgetPotion	=true,
		WidgetSound1	="CrownCrates_Manifest_Chosen",
		WidgetSound2	="CrownCrates_Manifest_Selected",
		Widgets		={
		["Immovable"]=true,
		["Major Resolve"]=true,
		["Major Sorcery"]=true,
		["Major Brutality"]=true,
		["Major Courage"]=true,
--		["Major Expedition"]=true,
		[61919]=true,--Merciless Resolve
		[61927]=true,--Relentless Focus
		[46327]=true,--Crystal Fragment Proc
		[110118]=true,[110142]=true,--Siroria's Boon
		[110067]=true,[110143]=true,--Siroria cd
		[107141]=true,[109084]=true,--Olirime cd
		[104538]=true,--Dark Drain
--		[116742]=true,--Precision
		[126941]=true,--Maarselok
		},
		--BlackList
		EnableBlackList	=true,
		BuffsBlackList	={
		[63601]=true,--ESO Plus Member
		[76667]=true,--Roar of Alkosh
		[14890]=true,--Block
		}
	},
	HornAvailable={},
	ColossusAvailable={},
	BarrierAvailable={},
	Horn={[40223]=true,[40224]=true},
	Colossus={[122174]=true,[122395]=true,[122388]=true},
	Barrier={[38573]=true,[40237]=true,[40239]=true},
	MajorVulnerability={[122389]=true,[122177]=true},
	Negate={[50108]=true},
	AlertDoT={
	[95230]=true,--Venom Injection (HoF)
	[90409]=true,--Melting Point (HoF)
	[101101]=true,--Trial by Fire (AS)
	[84221]=true,--Sickening Poison (Velidreth)
--	[73244]=true,--Ruthless Salvo Bleed
	[73807]=true,--Lunar Flare (Rage of S'Kinrai)
	[75738]=true,--Lunar Flare (S'kinrai)
	[112057]=true,--Fire Gauntlet (BRP)
--	[113164]=true,--Venomous Spit (BRP)
	},
	Important={
	--Buff
	[109976]=true,--Empower
	[109966]=true,--Major Courage (SPC)
	[109994]=true,[110020]=true,--Major Courage (Olorime)
	[61459]=true,--Burning Spellweave
	[75801]=true,[75804]=true,--Lunar, Shadow Blessing (Moondancer)
	[67288]=true,--Scathing Mage
	[40224]=true,--Horn
	[34872]=true,--The Ravager
	[46539]=true,--Major Force
	[93120]=true,[93442]=true,--Major Slayer
	[75770]=true,--Twilight Remedy
	[75746]=true,--Clever Alchemist
	[73024]=true,--Cruel Flurry (MSA)
	[61771]=true,--Powerful Assault
	[99204]=true,--Mechanical Acuity
	[110118]=true,[110142]=true,--Siroria's Boon
	[107141]=true,[109084]=true,--Vestment of Olirime
	[116742]=true,--Precision
	[122658]=true,--Seething Fury (DK)
	--Debuff
	[28301]=true,--CCImmunity
	[62787]=true,--Major Breach
	[81519]=true,--Infallible Aether
	[75753]=true,--Line-Breaker(Alkosh)
	[17906]=true,--Crusher
	[38541]=true,[38254]=true,--Taunt
	[95230]=true,--Venom Injection (HoF)
	[90409]=true,--Melting Point (HoF)
	[68871]=true,[68909]=true,[68910]=true,[69855]=true,	--Volatile Poison (MSA Stage 7)
	[90916]=true,--Scalded (HoF)
	[84221]=true,--Sickening Poison (Velidreth)
	[73244]=true,--Ruthless Salvo Bleed
	[73807]=true,--Lunar Flare (Rage of S'Kinrai)
	[75738]=true,--Lunar Flare (S'kinrai)
--	[110504]=true,--Arms of Relequen
	[107082]=true,--Baneful Mark
	[134599]=true,--Offbalance Immune
	}
}
--Defaults
BUI:JoinTables(BUI.Defaults,BUI.Buffs.Defaults)
--BUI.Defaults.CustomBuffs=BUI.Buffs.Important
--	/script local _,progressionIndex=GetAbilityProgressionXPInfoFromAbilityId(40223) id=GetAbilityProgressionAbilityId(progressionIndex, 1, 4) d(GetAbilityName(id)..id)
function BUI.GetFoodBuff()
	for i=1, GetNumBuffs("player") do
		local _,_,_,_,_,_,_,_,_,_,id=GetUnitBuffInfo("player",i)
		if buffFood[id] and type(buffFood[id])=="table" then
			return buffFood[id],id
		end
	end
	return {}
end
--Pets
local CombatPet={
--Familiars and Clannfears
[23304]=true,[30631]=true,[30636]=true,[30641]=true,[23319]=true,[30647]=true,[30652]=true,[30657]=true,[23316]=true,[30664]=true,[30669]=true,[30674]=true,
--Twilights
[24613]=true,[30581]=true,[30584]=true,[30587]=true,[24636]=true,[30592]=true,[30595]=true,[30598]=true,[24639]=true,[30618]=true,[30622]=true,[30626]=true,
--Bears
[85982]=true,[85983]=true,[85984]=true,[85985]=true,[85986]=true,[85987]=true,[85988]=true,[85989]=true,[85990]=true,[85991]=true,[85992]=true,[85993]=true,
}
function BUI.DismissPets()
	for i=1, GetNumBuffs("player") do
		local _,_,_,buffSlot,_,_,_,_,_,_,abilityId=GetUnitBuffInfo("player",i)
		if CombatPet[abilityId] then CancelBuff(buffSlot) end
	end
end

local function OakensoulEquipped()
	if GetItemLinkItemId(GetItemLink(BAG_WORN, 11))==187658 or 
	   GetItemLinkItemId(GetItemLink(BAG_WORN, 12))==187658 then return true end
	return false
end

local function IsOakensoul(buffId)
	if OakensoulEquipped() then 
		for id in pairs(oakensoul) do
			if buffId==id then return true end
		end		
	end
	return false
end

local function OnPairChanged()
	BUI.CurrentPair,_=GetActiveWeaponPairInfo()
	if BUI.Vars.EnchantTimer~=3 then
		CD_ENCHANT=9000/(GetItemTrait(BAG_WORN,WeaponSlot[BUI.CurrentPair])==4 and 2 or 1)
	end
	--ReticleResist
	if BUI.Vars.ReticleResist~=3 or (BUI.Vars.EnableStats and BUI.Vars.StatsBuffs) then
		OWN_PENETR=BUI.MainPower=="magicka" and GetPlayerStat(STAT_SPELL_PENETRATION) or GetPlayerStat(STAT_PHYSICAL_PENETRATION)
	end
	if BUI.Vars.NotificationsGroup then
		local ult=GetSlotBoundId(8)
		BUI.Buffs.HornAvailable[BUI.CurrentPair]=BUI.Buffs.Horn[ult]
		BUI.Buffs.ColossusAvailable[BUI.CurrentPair]=BUI.Buffs.Colossus[ult]
		BUI.Buffs.BarrierAvailable[BUI.CurrentPair]=BUI.Buffs.Barrier[ult]
--[[
		if BUI.Buffs.HornAvailable[BUI.CurrentPair]==nil then
			if BUI.Buffs.Horn[GetSlotBoundId(8)] then BUI.Buffs.HornAvailable[BUI.CurrentPair]=true
			else BUI.Buffs.HornAvailable[BUI.CurrentPair]="No" end
		end
--]]
	end
end

local function OnPlayerActivated()
--	BUI.Buffs.HornAvailable={}
--	BUI.Buffs.ColossusAvailable={}
--	BUI.Buffs.BarrierAvailable={}
	BUI.CallLater("Buffs_Activated",2000,OnPairChanged)
	EVENT_MANAGER:UnregisterForEvent("BUI_Buffs", EVENT_PLAYER_ACTIVATED)
end

local function OnAbilitySlotted()
	if not UpdateCooldown then
		UpdateCooldown=true
		BUI.CallLater("Buffs_AbilitySlotted",500,function()
			if BUI.Vars.NotificationsGroup then
				local ult=GetSlotBoundId(8)
				BUI.Buffs.HornAvailable[BUI.CurrentPair]=BUI.Buffs.Horn[ult]
				BUI.Buffs.ColossusAvailable[BUI.CurrentPair]=BUI.Buffs.Colossus[ult]
				BUI.Buffs.BarrierAvailable[BUI.CurrentPair]=BUI.Buffs.Barrier[ult]
			end
			UpdateCooldown=false
		end)
	end
end

function BUI.Frames.PlayerBuffs_Init()
	if BUI_BuffsP_Panel then BUI_BuffsP_Panel:SetHidden(true) end
	if not BUI.Vars.PlayerBuffs then return end
	local number	=16
	local fs		=BUI.Vars.PlayerBuffSize/2.5	--16
	local border	=4
	local space		=3
	local size		=BUI.Vars.PlayerBuffSize
	--Create the Self Buffs frame container
	local ui		=BUI.UI.Control(	"BUI_BuffsP",			BanditsUI,	{(size+space)*number-space,size},	BUI.Vars.BUI_BuffsP,		false)
	ui.backdrop		=BUI.UI.Backdrop(	"BUI_BuffsP_BG",			ui,		"inherit",					{CENTER,CENTER,0,0},		{0,0,0,0.4}, {0,0,0,1}, nil, true) --ui.backdrop:SetEdgeTexture("",16,4,4)
	ui.label		=BUI.UI.Label(	"BUI_BuffsP_Label",		ui.backdrop,	"inherit",				{CENTER,CENTER,0,0},		BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("PBuffsLabel"))
	ui:SetAlpha(BUI.Vars.FrameOpacityOut/100)
	ui:SetDrawLayer(DT_HIGH)
	ui:SetMovable(true)
	ui:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	ui.base		=BUI.UI.Control(	"BUI_BuffsP_Panel",		ui,		{size,size},				{BUI.Vars.PlayerBuffsAlign,BUI.Vars.PlayerBuffsAlign,0,0},		false)
	local anchor	={LEFT,LEFT,0,0,ui.base}
	--Iterate over Buffs
	for i=1, number do
	local ability	=BUI.UI.Backdrop(	"BUI_BuffsP"..i,			ui.base,	{size,size},				anchor,				theme_color, theme_color, BUI.abilityframe, true)
	ability:SetDrawLayer(0) ability:SetEdgeTexture("",8,4,4)
--	local ability	=BUI.UI.Statusbar("BUI_BuffsP"..i,			ui.base,	{size,size},				anchor,				{1,1,1,1},texture, false)
	ability.icon	=BUI.UI.Statusbar("BUI_BuffsP"..i.."_Icon",	ability,	{size-border,size-border},		{CENTER,CENTER,0,0},		{1,1,1,1},'', false)
	ability.icon:SetDrawLayer(0)
	ability.label	=BUI.UI.Label(	"BUI_BuffsP"..i.."_Label",	ability,	{size,size},				{TOP,TOP,0,0},			BUI.UI.Font(BUI.Vars.FrameFont1,fs-2,true), nil, {1,2}, '', false)
	ability.label:SetDrawLayer(1)
	ability.timer	=BUI.UI.Label(	"BUI_BuffsP"..i.."_Timer",	ability,	{fs*4,fs},					{BOTTOM,BOTTOM,0,-5},		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true,true), nil, {1,2}, '', false)
	ability.timer:SetDrawLayer(1)
	ability.count	=BUI.UI.Label(	"BUI_BuffsP"..i.."_Count",	ability,	{fs*2,fs},					{TOPRIGHT,TOPRIGHT,0,0},	BUI.UI.Font(BUI.Vars.FrameFont1,fs,true,true), nil, {2,2}, '', false)
	ability.count:SetDrawLayer(2)
	--Extra settings
	ability.index=i
	ability:SetMouseEnabled(true)
	ability:SetHandler("OnMouseDown", function(self,button) BUI.Buffs.ButtonHandler(self,button) end)
	ability:SetHandler("OnMouseEnter", BUI.Buffs.ShowTooltip)
	ability:SetHandler("OnMouseExit", function()ClearTooltip(InformationTooltip)end)
	anchor={LEFT,RIGHT,space,0,ability}
	end
end
function BUI.Frames.CustomBuffs_Init()
	local number	=12
	for i=1, number do control=_G["BUI_BuffsC"..i] if control~=nil then control:SetHidden(true) end end
	if not BUI.Vars.EnableCustomBuffs then return end
	local fs		=BUI.Vars.CustomBuffSize/2.5	--16
	local border	=4
	local space		=3
	local w		=BUI.Vars.CustomBuffsPWidth
	local size		=BUI.Vars.CustomBuffSize
	local ph		=size<=36 and 8 or math.floor(size/4)
	local dimensions	=BUI.Vars.CustomBuffsDirection=="horisontal" and {(size+space)*number-space,size} or {size+space+w,(size+space)*number-space}
	local side		=BUI.Vars.CustomBuffsPSide=="right"
	--Create the Self Buffs frame container
	local ui	=BUI.UI.Control(	"BUI_BuffsC",			BanditsUI,	dimensions,				BUI.Vars.BUI_BuffsC,		false)
	ui.backdrop	=BUI.UI.Backdrop(	"BUI_BuffsC_BG",			ui,	"inherit",				{CENTER,CENTER,0,0},		{0,0,0,0.4}, {0,0,0,1}, nil, true) --ui.backdrop:SetEdgeTexture("",16,4,4)
	ui.label	=BUI.UI.Label(	"BUI_BuffsC_Label",		ui.backdrop,	"inherit",				{CENTER,CENTER,0,0},		BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("CBuffsLabel"))
	ui:SetAlpha(BUI.Vars.FrameOpacityOut/100)
	ui:SetDrawLayer(DT_HIGH)
	ui:SetMovable(true)
	ui:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	ui.base		=BUI.UI.Control("BUI_BuffsC_Base",		ui,	dimensions,	{TOPLEFT,TOPLEFT,0,0})
	--Iterate over Buffs
	local anchor	={BOTTOMLEFT,BOTTOMLEFT,0,0,ui.base}
	local bar_texture=side and "/BanditsUserInterface/textures/theme/progressbar_right_2.dds" or "/BanditsUserInterface/textures/theme/progressbar_left_2.dds"
	for i=1, number do
	local ability	=BUI.UI.Control(	"BUI_BuffsC"..i,			ui.base,	{size,size},			anchor,				true)
	ability.bg		=BUI.UI.Backdrop(	"BUI_BuffsC"..i.."_BG",		ability,	{size,size},			{CENTER,CENTER,0,0},		theme_color, theme_color, BUI.abilityframe, false)
	ability.bg:SetDrawLayer(0) ability.bg:SetEdgeTexture("",8,4,4)
	ability.icon	=BUI.UI.Statusbar("BUI_BuffsC"..i.."_Icon",	ability.bg,	{size-border,size-border},	{CENTER,CENTER,0,0},		{1,1,1,1},'', false)
	ability.icon:SetDrawLayer(0)
	ability.label	=BUI.UI.Label(	"BUI_BuffsC"..i.."_Label",	ability,	{size,size},			{TOPLEFT,TOPLEFT,0,0},		BUI.UI.Font(BUI.Vars.FrameFont1,fs-2,true), nil, {1,2}, '', false)
	ability.label:SetDrawLayer(1)
	ability.timer	=BUI.UI.Label(	"BUI_BuffsC"..i.."_Timer",	ability,	{fs*4,fs},				{BOTTOM,BOTTOM,0,-5},		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true,true), nil, {1,2}, '', false)
	ability.timer:SetDrawLayer(1)
	ability.count	=BUI.UI.Label(	"BUI_BuffsC"..i.."_Count",	ability,	{fs*2,fs},				{TOPRIGHT,TOPRIGHT,0,0},	BUI.UI.Font(BUI.Vars.FrameFont1,fs,true,true), nil, {2,2}, '', false)
	ability.count:SetDrawLayer(2)
	anchor=side and {LEFT,RIGHT,space,0} or {RIGHT,LEFT,-space,0}
	ability.progress	=BUI.UI.Backdrop("BUI_BuffsC"..i.."_Progress",	ability,	{w,ph},				anchor,	{0,0,0,0}, {1,1,1,1}, nil, (not BUI.Vars.CustomBuffsProgress or BUI.Vars.CustomBuffsDirection=="horisontal"))
	ability.progress:SetEdgeTexture(bar_texture,32,4,4) ability.progress:SetEdgeColor(unpack(theme_color))
	if ph>8 then
		ability.pbg	=BUI.UI.Backdrop("BUI_BuffsC"..i.."_pBg",		ability.progress,	{w-4,ph-4},			{TOPLEFT,TOPLEFT,2,2},	{0,0,0,1}, {0,0,0,0}, nil, false)
	else
		if ability.pbg then ability.pbg:SetHidden(true) end
	end
	ability.name	=BUI.UI.Label(	"BUI_BuffsC"..i.."_Name",	ability.progress,	{w,fs-2},			{BOTTOMLEFT,TOPLEFT,0,-space},	BUI.UI.Font("standard",fs-2,true), nil, {side and 0 or 2,2}, '', false)
	anchor=side and {LEFT,LEFT,2,0} or {RIGHT,RIGHT,-2,0}
	ability.bar		=BUI.UI.Statusbar("BUI_BuffsC"..i.."_Bar",	ability.progress,	{w-4,ph-4},			anchor,	prog_color, BUI.Textures[BUI.Vars.FramesTexture], false)
	--Extra settings
	ability.index=i
	ability.custom=true
	ability:SetMouseEnabled(true)
	ability:SetHandler("OnMouseDown", function(self,button) BUI.Buffs.ButtonHandler(self,button) end)
	ability:SetHandler("OnMouseEnter", BUI.Buffs.ShowTooltip)
	ability:SetHandler("OnMouseExit", function()ClearTooltip(InformationTooltip)end)
	anchor=BUI.Vars.CustomBuffsDirection=="horisontal" and {LEFT,RIGHT,space,0,ability} or {BOTTOM,TOP,0,-space,ability}
	end
end
function BUI.Frames.SynergyCd_Init()
	local number	=4
	for i=1, number do control=_G["BUI_BuffsS"..i] if control~=nil then control:SetHidden(true) end end
	if not BUI.Vars.EnableSynergyCd then return end
	local fs		=BUI.Vars.SynergyCdSize/2.5	--16
	local border	=6
	local space		=3
	local w		=BUI.Vars.SynergyCdPWidth
	local size		=BUI.Vars.SynergyCdSize
	local dimensions	=BUI.Vars.SynergyCdDirection=="horisontal" and {(size+space)*number-space,size} or {size+space+w,(size+space)*number-space}
	local side		=BUI.Vars.SynergyCdPSide=="right"
	--Create the Self Buffs frame container
	local ui	=BUI.UI.Control(	"BUI_BuffsS",			BanditsUI,	dimensions,				BUI.Vars.BUI_BuffsS,		false)
	ui.backdrop	=BUI.UI.Backdrop(	"BUI_BuffsS_BG",			ui,	"inherit",				{CENTER,CENTER,0,0},		{0,0,0,0.4}, {0,0,0,1}, nil, true) --ui.backdrop:SetEdgeTexture("",16,4,4)
	ui.label	=BUI.UI.Label(	"BUI_BuffsS_Label",		ui.backdrop,	"inherit",				{CENTER,CENTER,0,0},		BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("SBuffsLabel"))
	ui:SetAlpha(BUI.Vars.FrameOpacityOut/100)
	ui:SetDrawLayer(DT_HIGH)
	ui:SetMovable(true)
	ui:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	ui.base		=BUI.UI.Control("BUI_BuffsS_Base",		ui,	dimensions,	{TOPLEFT,TOPLEFT,0,0})
	--Iterate over Buffs
	local anchor	={BOTTOMLEFT,BOTTOMLEFT,0,0,ui.base}
	local bar_texture=side and "/BanditsUserInterface/textures/theme/progressbar_right_2.dds" or "/BanditsUserInterface/textures/theme/progressbar_left_2.dds"
	for i=1, number do
	local ability	=BUI.UI.Control(	"BUI_BuffsS"..i,			ui.base,	{size,size},			anchor,				true)
	ability.bg		=BUI.UI.Backdrop(	"BUI_BuffsS"..i.."_BG",		ability,	{size,size},			{CENTER,CENTER,0,0},		{0,0,0,0}, theme_color, nil, false)
	ability.bg:SetDrawLayer(0) ability.bg:SetEdgeTexture("",8,2,4)
	ability.icon	=BUI.UI.Statusbar("BUI_BuffsS"..i.."_Icon",	ability.bg,	{size-border,size-border},	{CENTER,CENTER,0,0},		{1,1,1,1},'', false)
	ability.icon:SetDrawLayer(0)
--	ability.label	=BUI.UI.Label(	"BUI_BuffsS"..i.."_Label",	ability,	{size,size},			{TOPLEFT,TOPLEFT,0,0},		BUI.UI.Font(BUI.Vars.FrameFont1,fs-2,true), nil, {1,2}, '', false)
--	ability.label:SetDrawLayer(1)
	ability.timer	=BUI.UI.Label(	"BUI_BuffsS"..i.."_Timer",	ability,	{fs*4,fs},				{BOTTOM,BOTTOM,0,-5},		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true,true), nil, {1,2}, '', false)
	ability.timer:SetDrawLayer(1)
	anchor=side and {LEFT,RIGHT,space,0} or {RIGHT,LEFT,-space,0}
	ability.progress	=BUI.UI.Backdrop("BUI_BuffsS"..i.."_Progress",	ability,	{w,8},				anchor,	{0,0,0,0}, {1,1,1,1}, nil, not BUI.Vars.SynergyCdProgress)
	ability.progress:SetEdgeTexture(bar_texture,32,4,4) ability.progress:SetEdgeColor(unpack(theme_color))
	ability.progress:SetAlpha(.8)
	ability.name	=BUI.UI.Label(	"BUI_BuffsS"..i.."_Name",	ability.progress,	{w,fs-2},		{BOTTOMLEFT,TOPLEFT,0,-space},	BUI.UI.Font("standard",fs-2,true), nil, {side and 0 or 2,2}, '', false)
	anchor=side and {LEFT,LEFT,2,0} or {RIGHT,RIGHT,-2,0}
	ability.bar		=BUI.UI.Statusbar("BUI_BuffsS"..i.."_Bar",	ability.progress,	{w-2,8-4},		anchor,	prog_color, BUI.Textures[BUI.Vars.FramesTexture], false)
	--Extra settings
	ability.index=i
	ability.custom=true
	ability:SetMouseEnabled(true)
	ability:SetHandler("OnMouseEnter", BUI.Buffs.ShowTooltip)
	ability:SetHandler("OnMouseExit", function()ClearTooltip(InformationTooltip)end)
	anchor=BUI.Vars.SynergyCdDirection=="horisontal" and {LEFT,RIGHT,space,0,ability} or {BOTTOM,TOP,0,-space,ability}
	end
end
function BUI.Frames.Widgets_Init(widget,dup)
	local cm		=BUI.Vars.FrameMagickaColor
	local fs		=BUI.Vars.WidgetsSize/2.5	--16
	local border	=4
	local space		=3
	local w		=BUI.Vars.WidgetsPWidth
	local size		=BUI.Vars.WidgetsSize
	local ph		=size<=36 and 8 or math.floor(size/4)
	local anchor	={CENTER,CENTER,400,350}
	local widgets
	if widget then
		widgets={[string.gsub(widget,"BUI_Widget_","")]=true}
	else
		widgets=BUI.Vars.Widgets
		widgets["Potion"]=BUI.Vars.WidgetPotion
	end
	for _id,enable in pairs(widgets) do
	if enable then
	local icon,name,side
	local id=string.gsub(_id," ","_")
	local data=BUI.Vars["BUI_Widget_"..id]
	if data then anchor=data or anchor side=anchor[6] else data={} end
	if data[11]~=true then
	anchor=dup and {TOP,BOTTOM,0,space+(size+space)*(dup-1),_G["BUI_Widget_"..id]} or anchor
	local bar_texture=side and "/BanditsUserInterface/textures/theme/progressbar_left_2.dds" or "/BanditsUserInterface/textures/theme/progressbar_right_2.dds"
	local fname		="BUI_Widget_"..id..(dup and "_"..dup or "")
	local ability	=BUI.UI.Control(	fname,	BanditsUI,	{size,size},	anchor,	not widget and not data[12])
	local id_check=tonumber(id)
	if id_check then
		icon=GetAbilityIcon(id_check)
		name=GetAbilityName(id_check)
		ability.duration=BUI.GetAbilityDuration(id_check)
	else
		icon=_id=="Potion" and PotionIcon[BUI.MainPower] or "/esoui/art/icons/icon_missing.dds"
		name=_id
	end
	ability.init=false
	ability.bg		=BUI.UI.Backdrop(	fname.."_BG",	ability,	{size,size},			{CENTER,CENTER,0,0},		theme_color, theme_color, BUI.abilityframe, false)
	ability.bg:SetDrawLayer(0) ability.bg:SetEdgeTexture("",8,4,4)
	ability.icon	=BUI.UI.Statusbar(fname.."_Icon",	ability.bg,	{size-border,size-border},	{CENTER,CENTER,0,0},		{1,1,1,1}, icon, false)
	ability.icon:SetDrawLayer(0)
--[[
	if BUI.Vars.DeveloperMode then
	ability.label	=BUI.UI.Label(	fname.."_Label",	ability,	{size,size},			{TOPLEFT,TOPLEFT,0,0},		BUI.UI.Font(BUI.Vars.FrameFont1,fs-2,true), nil, {1,0}, id_check or '', false)
	ability.label:SetDrawLayer(1)
	end
--]]
	ability.timer	=BUI.UI.Label(	fname.."_Timer",	ability,	{fs*4,fs},				{BOTTOM,BOTTOM,0,-5},		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true,true), nil, {1,2}, '', false)
	ability.timer:SetDrawLayer(1)
	ability.count	=BUI.UI.Label(	fname.."_Count",	ability,	{size,size},			{TOP,TOP,0,0},			BUI.UI.Font(BUI.Vars.FrameFont1,size/2,true,true), nil, {2,0}, '', false)
	ability.count:SetDrawLayer(2)
	anchor=side and {RIGHT,LEFT,-space,0} or {LEFT,RIGHT,space,0}
	ability.progress	=BUI.UI.Backdrop(fname.."_Progress",	ability,	{w,ph},			anchor,	{0,0,0,0}, {1,1,1,1}, nil, true)	--not data[8])
	ability.progress:SetEdgeTexture(bar_texture,32,4,4) ability.progress:SetEdgeColor(unpack(theme_color))
	if ph>8 then
		ability.pbg	=BUI.UI.Backdrop(fname.."_pBg",	ability.progress,	{w-4,ph-4},			{TOPLEFT,TOPLEFT,2,2},	{0,0,0,1}, {0,0,0,0}, nil, false)
	else
		local frame=_G[fname.."_pBg"] if frame then frame:SetHidden(true) end
	end
--	ability.progress:SetAlpha(.8)
	anchor=side and {BOTTOMRIGHT,TOPRIGHT,0,-space} or {BOTTOMLEFT,TOPLEFT,0,-space}
	ability.name	=BUI.UI.Label(	fname.."_Name",	ability.progress,	{w,fs-2},			anchor,	BUI.UI.Font("standard",fs-2,true), nil, {(side and 2 or 0),0}, name, false)
	anchor=side and {TOPRIGHT,BOTTOMRIGHT,0,-space} or {TOPLEFT,BOTTOMLEFT,0,-space}
--	ability.tName	=BUI.UI.Label(	fname.."_Target",	ability.progress,	{w,fs-2},			anchor,	BUI.UI.Font("standard",fs-2,true), nil, {(side and 2 or 0),0}, "", false)
	anchor=side and {RIGHT,RIGHT,-2,0} or {LEFT,LEFT,2,0}
	ability.bar		=BUI.UI.Statusbar(fname.."_Bar",	ability.progress,	{w-4,ph-4},			anchor,	prog_color, BUI.Textures[BUI.Vars.FramesTexture], false)
	ability.bar1	=BUI.UI.Statusbar(fname.."_Bar1",	ability.progress,	{w-4,ph-4},			anchor,	cm, BUI.Textures[BUI.Vars.FramesTexture], true)
	ability.bar1:SetAlpha(.75)
	--Extra settings
	ability.index=_id
	ability.widget=true
	if dup then return ability end
	ability:SetMouseEnabled(true)
	ability:SetHandler("OnMouseDown", function(self,button) BUI.Buffs.ButtonHandler(self,button) end)
	ability:SetHandler("OnMoveStop", function(self) BUI.Menu:SaveAnchor(self,nil,nil,nil,side,data[7],data[8],data[9],data[10],data[11],data[12],data[13]) end)
	ability:SetHandler("OnMouseEnter", BUI.Buffs.ShowTooltip)
	ability:SetHandler("OnMouseExit", function()ClearTooltip(InformationTooltip)end)
--	ability:SetDrawTier(DT_HIGH)
	anchor={BOTTOM,TOP,0,-space,ability}
	end
	end
	end
end
function BUI.Frames.PassiveBuffs_Init()
	local number	=16
	for i=1, number do control=_G["BUI_BuffsPas"..i] if control~=nil then control:SetHidden(true) end end
	if not BUI.Vars.PlayerBuffs or BUI.Vars.BuffsPassives~="On additional panel" then return end
	local fs		=BUI.Vars.PassiveBuffSize/2.5	--16
	local border	=4
	local space		=3
	local w		=BUI.Vars.PassivePWidth
	local size		=BUI.Vars.PassiveBuffSize
	local side		=BUI.Vars.PassivePSide=="right"
	--Create the Self Buffs frame container
	local ui	=BUI.UI.Control(	"BUI_BuffsPas",			BanditsUI,	{size,(size+space)*number-space},	BUI.Vars.BUI_BuffsPas,		false)
	ui.backdrop	=BUI.UI.Backdrop(	"BUI_BuffsPas_BG",		ui,	"inherit",					{BOTTOM,BOTTOM,0,0},		{0,0,0,0.4}, {0,0,0,1}, nil, true) --ui.backdrop:SetEdgeTexture("",16,4,4)
	ui.label	=BUI.UI.Label(	"BUI_BuffsPas_Label",		ui.backdrop,	"inherit",					{CENTER,CENTER,0,0},		BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("PasBuffsLabel"))
	ui:SetAlpha(BUI.Vars.FrameOpacityOut/100)
	ui:SetDrawLayer(DT_HIGH)
	ui:SetMovable(true)
	ui:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	ui.base		=BUI.UI.Control("BUI_BuffsPas_Base",		ui,	"inherit",	{BOTTOMLEFT,BOTTOMLEFT,0,0})
	--Iterate over Buffs
	local anchor	={BOTTOM,BOTTOM,0,0,ui.base}
	local bar_texture	=side and "/BanditsUserInterface/textures/theme/progressbar_right_2.dds" or "/BanditsUserInterface/textures/theme/progressbar_left_2.dds"
	for i=1, number do
	local color={.4,.4,.4,.6}
	local ability	=BUI.UI.Backdrop(	"BUI_BuffsPas"..i,		ui.base,	{size,size},			anchor,				theme_color, color, BUI.abilityframe, true)
	ability:SetDrawLayer(0) ability:SetEdgeTexture("",8,4,4)
	ability.icon	=BUI.UI.Statusbar("BUI_BuffsPas"..i.."_Icon",	ability,	{size-border,size-border},	{CENTER,CENTER,0,0},		{1,1,1,1},'', false)
	ability.icon:SetDrawLayer(0)
	ability.label	=BUI.UI.Label(	"BUI_BuffsPas"..i.."_Label",	ability,	{size,size},			{TOPLEFT,TOPLEFT,0,0},		BUI.UI.Font(BUI.Vars.FrameFont1,fs-2,true), nil, {1,2}, '', false)
	ability.label:SetDrawLayer(1)
	ability.timer	=BUI.UI.Label(	"BUI_BuffsPas"..i.."_Timer",	ability,	{fs*4,fs},				{BOTTOM,BOTTOM,0,-5},		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true,true), nil, {1,2}, '', false)
	ability.timer:SetDrawLayer(1)
	ability.count	=BUI.UI.Label(	"BUI_BuffsPas"..i.."_Count",	ability,	{fs*2,fs},				{TOPRIGHT,TOPRIGHT,0,0},	BUI.UI.Font(BUI.Vars.FrameFont1,fs,true,true), nil, {2,2}, '', false)
	ability.count:SetDrawLayer(2)
	anchor=side and {LEFT,RIGHT,space,0} or {RIGHT,LEFT,-space,0}
	ability.progress	=BUI.UI.Backdrop(	"BUI_BuffsPas"..i.."_Progress",	ability,	{w,8},			anchor,	{0,0,0,0}, {1,1,1,1}, nil, not BUI.Vars.PassiveProgress)
	ability.progress:SetEdgeTexture(bar_texture,32,4,4) ability.progress:SetEdgeColor(unpack(theme_color))
	ability.name	=BUI.UI.Label(	"BUI_BuffsPas"..i.."_Name",	ability.progress,	{w,fs-2},			{BOTTOMRIGHT,TOPRIGHT,0,-space},	BUI.UI.Font("standard",fs-2,true), nil, {side and 0 or 2,2}, '', false)
	anchor=side and {LEFT,LEFT,2,0} or {RIGHT,RIGHT,-2,0}
	ability.bar		=BUI.UI.Statusbar("BUI_BuffsPas"..i.."_Bar",	ability.progress,	{w-4,8-4},			anchor,	prog_color, BUI.Textures[BUI.Vars.FramesTexture], false)	
	--Extra settings
	ability.index=i
	ability.passives=true
	ability:SetMouseEnabled(true)
	ability:SetHandler("OnMouseDown", function(self,button) BUI.Buffs.ButtonHandler(self,button) end)
	ability:SetHandler("OnMouseEnter", BUI.Buffs.ShowTooltip)
	ability:SetHandler("OnMouseExit", function()ClearTooltip(InformationTooltip)end)
	anchor={BOTTOM,TOP,0,-space,ability}
	end
end
function BUI.Frames.TargetBuffs_Init()
	if BUI_BuffsT_Panel then BUI_BuffsT_Panel:SetHidden(true) end
	if not BUI.Vars.TargetBuffs then return end
	local fs		=BUI.Vars.TargetBuffSize/2.5	--16
	local k		=1.16
	local space		=3
	local size		=BUI.Vars.TargetBuffSize
	local number	=15
	--Create the target buffs frame container
	local ui		=BUI.UI.Control(	"BUI_BuffsT",			BanditsUI,	{(size+space)*number-space,size},	BUI.Vars.BUI_BuffsT,		false)
	ui.backdrop	=BUI.UI.Backdrop(	"BUI_BuffsT_BG",				ui,	"inherit",					{CENTER,CENTER,0,0},		{0,0,0,0.4}, {0,0,0,1}, nil, true) --ui.backdrop:SetEdgeTexture("",16,4,4)
	ui.label		=BUI.UI.Label(	"BUI_BuffsT_Label",		ui.backdrop,	"inherit",			{CENTER,CENTER,0,0},		BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("TBuffsLabel"))
	ui:SetAlpha(BUI.Vars.FrameOpacityOut/100)
	ui:SetDrawLayer(DT_HIGH)
	ui:SetMovable(true)
	ui:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	ui.base		=BUI.UI.Control(	"BUI_BuffsT_Panel",		ui,	{size,size},				{BUI.Vars.TargetBuffsAlign,BUI.Vars.TargetBuffsAlign,0,0})
	local anchor	={LEFT,LEFT,0,0,ui.base}
	--Iterate over Buffs
	for i=1, number do
	local ability	=BUI.UI.Backdrop(	"BUI_BuffsT"..i,			ui.base,	{size,size},			anchor,				theme_color, theme_color, BUI.abilityframe, true)
--	ability.debuff	=BUI.UI.Statusbar("BUI_BuffsT"..i.."_Debuff",	ability,	{size,size/2},			{BOTTOM,TOP,0,0},			{1,1,1,1},'/BanditsUserInterface/textures/debuff.dds', true)
	ability:SetDrawLayer(0) ability:SetEdgeTexture("",8,2,4)
	ability.icon	=BUI.UI.Statusbar("BUI_BuffsT"..i.."_Icon",	ability,	{size/k,size/k},			{CENTER,CENTER,0,0},		{1,1,1,1},'', false)
	ability.icon:SetDrawLayer(1)
	ability.label	=BUI.UI.Label(	"BUI_BuffsT"..i.."_Label",	ability,	{size,size},			{TOP,TOP,0,0},			BUI.UI.Font(BUI.Vars.FrameFont1,fs-2,true), nil, {1,2}, '', false)
	ability.label:SetDrawLayer(2)
	ability.timer	=BUI.UI.Label(	"BUI_BuffsT"..i.."_Timer",	ability,	{fs*4,fs},				{BOTTOM,BOTTOM,0,-5},		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true,true), nil, {1,2}, '', false)
	ability.timer:SetDrawLayer(2)
	ability.count	=BUI.UI.Label(	"BUI_BuffsT"..i.."_Count",	ability,	{fs*2,fs},				{TOPRIGHT,TOPRIGHT,0,0},	BUI.UI.Font(BUI.Vars.FrameFont1,fs,true,true), nil, {2,2}, '', false)
	ability.count:SetDrawLayer(2)
	--Extra settings
	anchor={LEFT,RIGHT,space,0,ability}
	end
end

local function PlayerBuffs_Update()
	local border	=6
	local space		=5
	local size		=BUI.Vars.PlayerBuffSize
	local number=(not BUI.PlayerBuffs) and 0 or #BUI.PlayerBuffs
	BUI_BuffsP_Panel:SetWidth((size+space)*math.min(number,16)-space)
	--Main Buffs
	for i=1, math.min(number,16) do
		local ability=_G["BUI_BuffsP"..i]
		if BUI.PlayerBuffs[i].Blank then
			ability:SetHidden(true)
		else
			local color=(not BUI.PlayerBuffs[i].Positive) and source_color[1] or ((BUI.PlayerBuffs[i].Player and BUI.Vars.CastbyPlayer) and theme_color or source_color[3])
			local scale=BUI.PlayerBuffs[i].Scale
			ability:SetHidden(false)
			ability:SetEdgeColor(unpack(color))
--			ability.icon:SetColor(unpack(BUI.PlayerBuffs[i].Color))
			ability.icon:SetTexture(BUI.PlayerBuffs[i].Texture)
			if BUI.Vars.DeveloperMode then ability.label:SetText(BUI.PlayerBuffs[i].Plate) end
			ability.timer:SetText(BUI.FormatTime(BUI.PlayerBuffs[i].Timer/1000))
			ability.count:SetText((BUI.PlayerBuffs[i].Count>0) and BUI.PlayerBuffs[i].Count or "")
			ability:SetDimensions(size*scale,size*scale)
			ability.icon:SetDimensions(size*scale-border,size*scale-border)
		end
	end
	for i=math.min(number+1,16), 16 do _G["BUI_BuffsP"..i]:SetHidden(true) end
	--Passives
	if BUI.Vars.BuffsPassives=="On additional panel" then
		number=#BUI.PassiveBuffs
		for i=1, math.min(number,16) do
			local ability=_G["BUI_BuffsPas"..i]
			if ability then
				local color=(not BUI.PassiveBuffs[i].Positive) and source_color[1] or ((BUI.PassiveBuffs[i].Player and BUI.Vars.CastbyPlayer) and theme_color or source_color[3])
				ability:SetHidden(false)
				ability:SetEdgeColor(unpack(color))
--				ability.icon:SetColor(unpack(BUI.PassiveBuffs[i].Color))
				ability.icon:SetTexture(BUI.PassiveBuffs[i].Texture)
				if BUI.Vars.DeveloperMode then ability.label:SetText(BUI.PassiveBuffs[i].Plate) end
				ability.timer:SetText(BUI.FormatTime(BUI.PassiveBuffs[i].Timer/1000))
				ability.count:SetText((BUI.PassiveBuffs[i].Count>0) and BUI.PassiveBuffs[i].Count or "")
				if BUI.Vars.PassiveProgress then
					ability.name:SetText(BUI.PassiveBuffs[i].Name)
					local pct=BUI.PassiveBuffs[i].Timer/BUI.PassiveBuffs[i].Duration
					ability.bar:SetWidth(pct*(ability.progress:GetWidth()-4))
				end
			end
		end
		for i=math.min(number+1,16), 16 do _G["BUI_BuffsPas"..i]:SetHidden(true) end
		BUI_BuffsPas_Base:SetHeight((BUI.Vars.PassiveBuffSize+space)*number-space)
	end
end
local function Widgets_Update()
	local now=GetGameTimeMilliseconds()
	--Potion
	if BUI.Vars.WidgetPotion and now>=BUI.PotionEndTime-5000 and BUI.Player[BUI.MainPower].max-BUI.Player[BUI.MainPower].current>=6000 then
		BUI.Widgets["Potion"]={
			id		=0,
			Name		="Potion",
			Count		=0,
			Texture	=PotionIcon[BUI.MainPower],
			Duration	=math.max(BUI.PotionEndTime-now,0),
			Started	=now,
			Confirm	=true,
			Expires	=BUI.Widgets.Potion and BUI.Widgets.Potion.Expires,
		}
	end

	for _id in pairs(BUI.Widgets) do
		local id=string.gsub(_id," ","_")
		local ability=_G["BUI_Widget_"..id]
		if ability then
			local widget=BUI.Vars["BUI_Widget_"..id] or {}
			local function Update(data,targetName)
				if not data.Confirm and not data.Hold then
					if widget[12] then	--Always show
						ability.progress:SetHidden(true)
						ability.timer:SetText("")
						ability.count:SetText("")
					else
						ability:SetHidden(true)
					end
					ability.Target=nil
					return true
				end
				if not ability.init then
					ability.icon:SetTexture(data.Texture)
					ability.init=true
				end
				--Activation
				if not data.Expires then
					if (widget[13]==1 or widget[13]==3) then PlaySound(BUI.Vars.WidgetSound1) end
					data.Expires=1
				end
				--Update
				data.Confirm=nil
				local color=(not data.Positive) and source_color[1] or ((data.Player and BUI.Vars.CastbyPlayer) and theme_color or source_color[3])
				ability.bg:SetEdgeColor(unpack(color))
				local duration=widget[7] or data.Duration
				local timer=(data.Started or 0)+duration-now
				if duration>data.Duration then data.Hold=true end
				ability:SetHidden(false)
				ability.timer:SetText(timer>0 and BUI.FormatTime(timer/1000) or "")
				ability.count:SetText(data.Count and data.Count>0 and data.Count or "")
				if widget[8] then
					ability.progress:SetHidden(false)
					ability.name:SetText(targetName or data.Name)
					local pct=duration>0 and timer/duration or 1
					ability.bar:SetWidth(pct*(BUI.Vars.WidgetsPWidth-4))
					if data.Combine and BUI.Widgets[data.Combine] then
						local comb=BUI.Widgets[data.Combine]
						local pct=comb.Duration>0 and ((comb.Started or 0)+comb.Duration-now)/comb.Duration or 1
						ability.bar1:SetWidth(pct*(BUI.Vars.WidgetsPWidth-4))
						ability.bar1:SetHidden(false)
						BUI.Widgets[data.Combine]=nil
					else
						ability.bar1:SetHidden(true)
					end
				end
				if timer<=0 then
					data.Hold=nil
				elseif timer<1000 and timer>0 and data.Expires~=2 then
					--Deactivation
					if (widget[13]==2 or widget[13]==3) then PlaySound(BUI.Vars.WidgetSound2) end
					BUI.UI.Expires(ability.bg)
					data.Expires=2
				end
			end
			--Multytarget
			if BUI.Widgets[_id].Target then
				local dup=0
				for targetName,data in pairs(BUI.Widgets[_id]) do
					if targetName~="Target" then
						if dup>0 and dup<10 then
							ability=_G["BUI_Widget_"..id.."_"..dup] or BUI.Frames.Widgets_Init(id,dup)
						end
						if Update(data,targetName) then BUI.Widgets[_id][targetName]=nil end
--						ability.tName:SetText(targetName)
						dup=dup+1
					end
				end
				if dup==0 then
					BUI.Widgets[_id]=nil
				else
					for i=dup,9 do frame=_G["BUI_Widget_"..id.."_"..i] if frame then frame:SetHidden(true) end end
				end
			else
				if Update(BUI.Widgets[_id]) then BUI.Widgets[_id]=nil end
			end
		end
	end
end
local function CustomBuffs_Update()
	--Custom Buffs
	number=#BUI.CustomBuffs
	for i=1, math.min(number,12) do
		local ability=_G["BUI_BuffsC"..i]
		if ability then
			local color=(not BUI.CustomBuffs[i].Positive) and source_color[1] or ((BUI.CustomBuffs[i].Player and BUI.Vars.CastbyPlayer) and theme_color or source_color[3])
			ability:SetHidden(false)
			ability.bg:SetEdgeColor(unpack(color))
--			ability.icon:SetColor(unpack(BUI.CustomBuffs[i].Color))
			ability.icon:SetTexture(BUI.CustomBuffs[i].Texture)
			if BUI.Vars.DeveloperMode then ability.label:SetText(BUI.CustomBuffs[i].Plate) end
			ability.timer:SetText(BUI.FormatTime(BUI.CustomBuffs[i].Timer/1000))
			ability.count:SetText((BUI.CustomBuffs[i].Count>0) and BUI.CustomBuffs[i].Count or "")
			if BUI.CustomBuffs[i].Timer<1000 and BUI.CustomBuffs[i].Timer>0 then BUI.UI.Expires(ability.bg) end
			if BUI.Vars.CustomBuffsProgress then
				ability.name:SetText(BUI.CustomBuffs[i].Name)
				local pct=BUI.CustomBuffs[i].Timer/BUI.CustomBuffs[i].Duration
				ability.bar:SetWidth(pct*(ability.progress:GetWidth()-4))
			end
		end
	end
	for i=math.min(number+1,12), 12 do _G["BUI_BuffsC"..i]:SetHidden(true) end
end
local function SynergyCd_Update()
	--Custom Buffs
	local now=GetGameTimeMilliseconds()
	for i=1,4 do
		local ability=_G["BUI_BuffsS"..i]
		if ability then
			if BUI.SynergyCd[i] then
				local timer=BUI.SynergyCd[i].StartTime+20000-now
				ability:SetHidden(false)
				ability.icon:SetTexture(BUI.SynergyCd[i].Texture)
				ability.timer:SetText(BUI.FormatTime(timer/1000))
	--			ability.label:SetText(BUI.SynergyCd[i].id)
				if timer<1000 and timer>0 then BUI.UI.Expires(ability.bg) end
				if BUI.Vars.SynergyCdProgress then
					ability.name:SetText(BUI.SynergyCd[i].Name)
					local pct=timer/20000
					ability.bar:SetWidth(pct*(ability.progress:GetWidth()-4))
				end
				if timer<=BUI.Buffs.UpdateTime then BUI.SynergyCd[i]=nil end
			else
				ability:SetHidden(true)
			end
		end
	end
end
local function TargetBuffs_Update()
	local k		=1.16
	local space		=5
	local size		=BUI.Vars.TargetBuffSize
	local number=(BUI.TargetBuffs==nil) and 0 or #BUI.TargetBuffs
	BUI_BuffsT_Panel:SetWidth((size+space)*number-space)
	--Iterate over Buffs
	for i=1, math.min(number,15) do
		local ability=_G[	"BUI_BuffsT"..i]
		if BUI.TargetBuffs[i].Blank then
			ability:SetHidden(true)
		else
			local color=(BUI.TargetBuffs[i].Player and BUI.Vars.CastbyPlayer) and theme_color or source_color[3]
			local set=BUI.TargetBuffs[i].Set
			ability:SetHidden(false)
			ability:SetEdgeColor(unpack(color))
--			ability.debuff:SetHidden(BUI.TargetBuffs[i].Positive)
--			ability.icon:SetColor(unpack(BUI.TargetBuffs[i].Color))
			ability.icon:SetTexture(BUI.TargetBuffs[i].Texture)
			if BUI.Vars.DeveloperMode then ability.label:SetText(BUI.TargetBuffs[i].Plate) end
			ability.timer:SetText(BUI.FormatTime(BUI.TargetBuffs[i].Timer/1000))
			ability.count:SetText((BUI.TargetBuffs[i].Count>0) and BUI.TargetBuffs[i].Count or "")
			ability:SetDimensions(size*set,size*set)
--			ability.debuff:SetDimensions(size*set,size*set/2)
			ability.icon:SetDimensions(size*set/k,size*set/k)
		end
	end
	for i=math.min(number+1,15), 15 do control=_G["BUI_BuffsT"..i] if control~=nil then control:SetHidden(true) end end
end

local function BuffsPlayer()		--PlayerBuffs
	local now=GetGameTimeMilliseconds()
	local numBuffs=GetNumBuffs("player")
	local index=(BUI.Vars.BuffsPassives=="On one panel") and 2 or 1
	local index,p_index,c_index,num_buffs,num_debuff,num_passive=0,0,0,0,0,0
	local Purge=false
	local have_food=false
	BUI.Buffs.HornActive=nil
	local buffName,timeStarted,timeEnding,buffSlot,stackCount,iconFilename,buffType,effectType,abilityType,statusEffectType,abilityId,canClickOff,castByPlayer
	BUI.PlayerBuffs={}
	BUI.PassiveBuffs={}
	BUI.CustomBuffs={}
--	BUI.Widgets={}
	TMP_PENETR=0
	BUI.Expedition=0
	BUI.Gallop=0
	BUI_ReticleBoost:SetHidden(true)
	for i=-8, numBuffs do
		buffName=nil
		local effect=BUI.Buffs.Effects[i]
		if effect and effect.timeEnding>now/1000 then
			buffName		=ProcEffects[effect.id].name
			timeStarted		=effect.timeStarted
			timeEnding		=effect.timeEnding
			effectType		=ProcEffects[effect.id].negative and -1 or 1
			abilityId		=effect.id
			iconFilename	=ProcEffects[effect.id].icon
			castByPlayer	=not ProcEffects[effect.id].negative
			stackCount		=0
		elseif i>0 then
			buffName,timeStarted,timeEnding,buffSlot,stackCount,iconFilename,buffType,effectType,abilityType,statusEffectType,abilityId,canClickOff,castByPlayer=GetUnitBuffInfo("player",i)
			buffName=string.gsub(buffName,"%^%w+","")
		end
--		if i>0 and effectType~=1 then d("["..tostring(abilityId).."("..i..")] Type: ("..tostring(effectType)..") "..tostring(buffName)) end
		if buffName then
			--Horn
			if BUI.Buffs.Horn[abilityId] then BUI.Buffs.HornActive=timeEnding-now/1000 end
			--Notifications module
			if BUI.Vars.NotificationsTrial then
--				if BUI.Buffs.Horn[abilityId] then BUI.Buffs.HornActive=true if BUI.OnScreen.Message[3] then BUI.OnScreen.Message[3]={["message"]="",["time"]=0} BUI.OnScreen.Update() end end
				if BUI.Buffs.AlertDoT[abilityId] then
					Purge=true
					BUI.OnScreen.Notification(7,"Purge!",BUI.Vars.NotificationSound_1)
					CALLBACK_MANAGER:FireCallbacks("BUI_Purge")
				end
			end
			if i>=0 and abilityId~=63601 then
				--Reticle Boost
				if buffName=="Major Expedition" then
					BUI.Expedition=timeEnding*1000 BUI.Reticle.SpeedBoost()
				end
				if buffName=="Major Gallop" then
					BUI.Gallop=timeEnding*1000 BUI.Reticle.SpeedBoost()
				end
				--Statistics module
				if BUI.Vars.EnableStats and BUI.Vars.StatsBuffs then
					if timeStarted~=timeEnding and timeStarted<BUI.Stats.Current[BUI.ReportN].startTime/1000 then timeStarted=BUI.Stats.Current[BUI.ReportN].startTime/1000 end
					if BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName]==nil then
						BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName]={
							icon		=iconFilename,
							id		=abilityId,
							player	=castByPlayer,
							Duration	=0,
							effectType	=effectType,
							timeStarted	=timeStarted,
							timeEnding	=timeEnding,
							Positive	=(effectType==1),
						}
					elseif timeEnding==0 then
						BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName].Duration=BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName].Duration+BUI.Buffs.UpdateTime
					elseif BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName].timeEnding>=timeStarted then
							BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName].timeEnding=timeEnding
					else
						local stacks=StacksTotal[abilityId] and stackCount/StacksTotal[abilityId] or 1
						BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName].Duration	=BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName].Duration+(BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName].timeEnding-BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName].timeStarted)*stacks
						BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName].timeStarted	=timeStarted
						BUI.Stats.Current[BUI.ReportN].PlayerBuffs[buffName].timeEnding	=timeEnding
					end
				end
			end
			--Buffs module -------------------------
			if BUI.Vars.PlayerBuffs and not (BUI.Vars.EnableBlackList and (BUI.Vars.BuffsBlackList[abilityId] or BUI.Vars.BuffsBlackList[buffName])) then
				--Vampirism stage
				if VampireStage[abilityId] then stackCount=VampireStage[abilityId] end
				local passive=((timeStarted==timeEnding or Passives[abilityId]) and not Active[abilityId]) and 1 or 0
				--Passive Buffs
				if (BUI.Vars.BuffsPassives=="On additional panel" and passive==1) then
					p_index=p_index+1
					BUI.PassiveBuffs[p_index]={
						id		=abilityId,
						Name		=buffName,
						Count		=stackCount,
						Texture	=iconFilename,
						Duration	=(timeEnding-timeStarted)*1000,
--						timeStarted	=timeStarted+1000*(effectType-1)-1000*passive,
						Timer		=timeEnding*1000-now,
						Positive	=(effectType==1),
--						Color		={1,1,1,1},
						Player	=castByPlayer,
						Plate		=abilityId,
					}
				--Main Buffs
				elseif (	(BUI.Vars.BuffsPassives=="On one panel" and passive) or
					(timeEnding*1000-now>0 and timeEnding-timeStarted>=BUI.Vars.MinimumDuration) or stackCount>0) then
						index=index+1
						if effectType==1 then if passive==1 then num_passive=num_passive+1 else num_buffs=num_buffs+1 end else num_debuff=num_debuff+1 end
						BUI.PlayerBuffs[index]={
							id		=abilityId,
							Name		=buffName,
							Count		=stackCount,
							Texture	=iconFilename,
							filter	=(timeEnding-timeStarted)-900000*(effectType-1)+900000*passive,
							Timer		=timeEnding*1000-now,
							Positive	=(effectType==1),
							Scale		=((BUI.Vars.BuffsImportant and BUI.Buffs.Important[abilityId]) and 1.4 or 1),
--							Color		={1,1,1,1},
							Player	=castByPlayer,
							Plate		=abilityId,
--							Plate=zo_strformat("[<<1>>]\n<<2>>-<<3>>-<<4>>-<<5>>",abilityId,buffType,effectType,abilityType,statusEffectType),
--							Plate=zo_strformat("[<<1>>]\n<<2>>(<<3>>)",abilityId,tostring((effectType==1)),tostring(effectType)),
						}
				end
			end
			--Widgets
			if BUI.Vars.EnableWidgets then
				local widgetId=BUI.Vars.Widgets[abilityId] and abilityId or (BUI.Vars.Widgets[buffName] and buffName or false)
				if widgetId then
					local data=BUI.Vars["BUI_Widget_"..string.gsub(widgetId," ","_")] or {}
					if stackCount==0 and BUI.Widgets[widgetId] then
						stackCount=BUI.Widgets[widgetId].Count or 0
					end
					BUI.Widgets[widgetId]={
						id		=abilityId,
						Name		=buffName,
						Count		=stackCount,
						Texture	=iconFilename,
						Duration	=(timeEnding-timeStarted)*1000,
						Started	=timeStarted*1000,
						Positive	=(effectType==1),
						Player	=castByPlayer,
						Confirm	=true,
						Combine	=data[11],
						Expires	=BUI.Widgets[widgetId] and BUI.Widgets[widgetId].Expires,
					}
				end
			end
			--Custom Buffs
			if BUI.Vars.EnableCustomBuffs and (BUI.Vars.CustomBuffs[abilityId] or BUI.Vars.CustomBuffs[buffName]) then
				c_index=c_index+1
				BUI.CustomBuffs[c_index]={
					id		=abilityId,
					Name		=buffName,
					Count		=stackCount,
					Texture	=iconFilename,
					Duration	=(timeEnding-timeStarted)*1000,
					timeStarted	=timeStarted+1000,
					Timer		=timeEnding*1000-now,
					Positive	=(effectType==1),
					Player	=castByPlayer,
					Plate		=abilityId,
				}
			end
			--Penetration
			if BUI.Vars.EnableStats or BUI.Vars.ReticleResist~=3 then
				if BUI.Penetration.Self[abilityId] then TMP_PENETR=TMP_PENETR+BUI.Penetration.Self[abilityId]*(stackCount or 1) end
			end
			--Food
			if buffFood[abilityId] then have_food=timeEnding*1000-now end
		end
	end
	--Oakensoul Filter
	if BUI.Vars.PassiveOakFilter and OakensoulEquipped() and BUI.PassiveBuffs then
		local oakbuff = {
				id		=9999999,
				Name	="Oakensoul",
				Count	=0,
				Texture	="/esoui/art/icons/u34_mythic_oakensoul_ring.dds",
				Duration	=0,
				Timer		=-1,
				filter 		=1,
				Scale 		=1,
				Positive	=true,
				Player	=true,		
			}
		if (BUI.Vars.BuffsPassives=="On additional panel") then
			local filteredPassives={}
			--remove passives provided by oakensoul
			for id,value in pairs(BUI.PassiveBuffs) do
				if not IsOakensoul(BUI.PassiveBuffs[id].id) then table.insert(filteredPassives,BUI.PassiveBuffs[id]) end
			end			
			--add fake oakensoul entry
			table.insert(filteredPassives,oakbuff)
			BUI.PassiveBuffs=filteredPassives
		elseif (BUI.Vars.BuffsPassives=="On one panel") then
			local filteredBuffs={}			
			--remove passives provided by oakensoul
			for id,value in pairs(BUI.PlayerBuffs) do
				if not IsOakensoul(BUI.PlayerBuffs[id].id) then table.insert(filteredBuffs,BUI.PlayerBuffs[id]) end
			end
			--add fake oakensoul entry
			table.insert(filteredBuffs,oakbuff)
			BUI.PlayerBuffs=filteredBuffs
		end		
	end
	--Sort
	if BUI.Vars.PlayerBuffs then
		if num_debuff>0 and (num_buffs>0 or num_passive>0) then
			index=index+1
			BUI.PlayerBuffs[index]={filter=-800000, Positive=true, Blank=true}
		end
		if num_buffs>0 and num_passive>0 then
			index=index+1
			BUI.PlayerBuffs[index]={filter=800000, Positive=true, Blank=true}
		end
		table.sort(BUI.PlayerBuffs, function(x,y) return (x.filter<y.filter) end)
		table.sort(BUI.PassiveBuffs, function(x,y) return (x.Timer<y.Timer) end)
	end
	--Notifications module
	if not Purge and BUI.OnScreen.Message[7] then BUI.OnScreen.Message[7]["time"]=0 BUI.OnScreen.Update() end
	--Food
	if have_food then
		if have_food<10000 and have_food>10000-BUI.Buffs.UpdateTime then
			if BUI.Vars.NotificationFood then
				BUI.OnScreen.Notification(0,BUI.Loc("Food"),nil,have_food)
			end
		end
		if BUI.NeedToEat then
			CALLBACK_MANAGER:FireCallbacks("BUI_Food",false)
			BUI.NeedToEat=false
		end
	elseif not BUI.NeedToEat then
		BUI.NeedToEat=true
		CALLBACK_MANAGER:FireCallbacks("BUI_Food",true)
	end
end
local function BuffsTarget()		--TargetBuffs
	BUI.TargetBuffs={}
	local TauntTimer,CrusherTimer=0,0
	if DoesUnitExist('reticleover') then
	local fs		=BUI.Vars.StatsFontSize
	local now		=GetGameTimeMilliseconds()
	local numBuffs	=GetNumBuffs("reticleover")
	local name		=BUI.Target.name
	if BUI.Vars.EnableStats and BUI.Stats.Current[BUI.ReportN].TargetBuffs[name]==nil then BUI.Stats.Current[BUI.ReportN].TargetBuffs[name]={} end
	local j=0
	local buffName,timeStarted,timeEnding,buffSlot,stackCount,iconFilename,buffType,effectType,abilityType,statusEffectType,abilityId,canClickOff,castByPlayer
--	local status_effect
	local penetr=0
--	BUI.TargetBuffs={[1]={timeStarted=now/1000, Positive=true, Blank=true,}}
	for i=1, numBuffs do
		buffName,timeStarted,timeEnding,buffSlot,stackCount,iconFilename,buffType,effectType,abilityType,statusEffectType,abilityId,canClickOff,castByPlayer=GetUnitBuffInfo("reticleover",i)
		buffName=string.gsub(buffName,"%^%w+","")
--[[		--Combat Reticle
		if BUI.Vars.InCombatReticle then
			if BUI.Vars.ReticleReflection and Reflection[abilityId] then status_effect="|cBB22BBReflection "..math.floor((timeEnding*1000-now+500)/1000).."|r"
			elseif BUI.Vars.ReticleOffBalance and BUI.Vars.ReticleOffBalance~=3 and OffBalance[abilityId] then
				status_effect=(BUI.Vars.ReticleOffBalance==1 and "  "..OffBalance[abilityId] or "|c22BB22Off Balance|r ").." "..math.floor((timeEnding*1000-now+500)/1000)
			elseif BUI.Vars.ReticleCcImmunity and BUI.Vars.ReticleCcImmunity~=3 and CcImmunity[abilityId] then
				status_effect=(BUI.Vars.ReticleCcImmunity==1 and "  "..CcImmunity[abilityId] or "CC Immunity").." "..math.floor((timeEnding*1000-now+500)/1000)
			elseif BUI.Vars.ReticleObImmunity and BUI.Vars.ReticleObImmunity~=3 and ObImmunity[abilityId] then
				status_effect=(BUI.Vars.ReticleObImmunity==1 and "  "..ObImmunity[abilityId] or "OB Immunity").." "..math.floor((timeEnding*1000-now+500)/1000)
			end
		end
--]]
		--Statistics module
		if BUI.Vars.EnableStats and BUI.Vars.StatsBuffs and not BUI.Group[name] then
			local timeStarted_in=(timeStarted~=timeEnding and timeStarted<BUI.Stats.Current[BUI.ReportN].startTime/1000) and BUI.Stats.Current[BUI.ReportN].startTime/1000 or timeStarted
--			local _player=(castByPlayer) and "v" or "x"
--			local _id=(BUI.Vars.DeveloperMode) and zo_strformat("[<<1>>] ",abilityId) or ""
--			local _buff=zo_strformat("<<1>><<!aC:2>>",_player,buffName)
			if BUI.Stats.Current[BUI.ReportN].TargetBuffs[name][buffName]==nil then
				BUI.Stats.Current[BUI.ReportN].TargetBuffs[name][buffName]={
					icon		=iconFilename,
					id		=abilityId,
					player	=castByPlayer,
					Duration	=0,
					effectType	=effectType,
					timeStarted	=timeStarted_in,
					timeEnding	=timeEnding,
				}
			elseif BUI.Stats.Current[BUI.ReportN].TargetBuffs[name][buffName].timeEnding>=timeStarted_in then
				BUI.Stats.Current[BUI.ReportN].TargetBuffs[name][buffName].timeEnding=timeEnding
			else
				local stacks=StacksTotal[abilityId] and stackCount/StacksTotal[abilityId] or 1
				BUI.Stats.Current[BUI.ReportN].TargetBuffs[name][buffName].Duration=BUI.Stats.Current[BUI.ReportN].TargetBuffs[name][buffName].Duration+(BUI.Stats.Current[BUI.ReportN].TargetBuffs[name][buffName].timeEnding-BUI.Stats.Current[BUI.ReportN].TargetBuffs[name][buffName].timeStarted)*stacks
				BUI.Stats.Current[BUI.ReportN].TargetBuffs[name][buffName].timeStarted=timeStarted_in
				BUI.Stats.Current[BUI.ReportN].TargetBuffs[name][buffName].timeEnding=timeEnding
			end
		end
		--Widgets
		if BUI.Vars.EnableWidgets and not BUI.Group[name] then
			local widgetId=BUI.Vars.Widgets[abilityId] and abilityId or BUI.Vars.Widgets[buffName] and buffName or false
			if widgetId then
				local data=BUI.Vars["BUI_Widget_"..string.gsub(widgetId," ","_")]
				if castByPlayer or (data and data[10]) then	--or effectType~=1
					if data and data[9] then
						if not BUI.Widgets[widgetId] then BUI.Widgets[widgetId]={Target=true} end
						BUI.Widgets[widgetId][name]={
							id		=abilityId,
							Name		=buffName,
							Count		=stackCount,
							Texture	=iconFilename,
							Duration	=(timeEnding-timeStarted)*1000,
							Started	=timeStarted*1000,
	--						Timer		=timeEnding>0 and timeEnding*1000-now or 0,
							Positive	=(effectType==1),
							Player	=castByPlayer,
							Hold		=true,
							Expires	=BUI.Widgets[widgetId][name] and BUI.Widgets[widgetId][name].Expires,
						}
					else
						BUI.Widgets[widgetId]={
							id		=abilityId,
							Name		=buffName,
							Count		=stackCount,
							Texture	=iconFilename,
							Duration	=(timeEnding-timeStarted)*1000,
							Started	=timeStarted*1000,
							Positive	=(effectType==1),
							Player	=castByPlayer,
							Hold		=true,
							Expires	=BUI.Widgets[widgetId] and BUI.Widgets[widgetId].Expires,
						}
					end
				end
			end
		end
		--Buff module
		if BUI.Vars.TargetBuffs and
			((BUI.Vars.BuffsPassives and timeStarted==timeEnding) or (timeEnding*1000-now>0 and timeEnding-timeStarted>=BUI.Vars.MinimumDuration) or stackCount>0) and
			not (BUI.Vars.EnableBlackList and (BUI.Vars.BuffsBlackList[abilityId] or BUI.Vars.BuffsBlackList[buffName])) then
			if not (BUI.Vars.BuffsOtherHide and not castByPlayer) or BUI.Buffs.Important[abilityId] then
				local _set=1
				if BUI.Vars.BuffsImportant and BUI.Buffs.Important[abilityId] then _set=1.4 end
				j=j+1
				BUI.TargetBuffs[j]={
					id		=abilityId,
					Count		=stackCount,
					Texture	=iconFilename,
					timeStarted	=timeStarted+1000*(effectType-1),
					Timer		=timeEnding*1000-now,
					Positive	=(effectType==1),
					Set		=_set,
					Player	=castByPlayer,
					Plate=zo_strformat("[<<1>>]",abilityId),
--					Plate=zo_strformat("[<<1>>]\n<<2>>-<<3>>-<<4>>-<<5>>",abilityId,buffType,effectType,abilityType,statusEffectType),
				}
			end
		end
		--Major Vulnerability
		if BUI.Buffs.MajorVulnerability[abilityId] then BUI.Buffs.MajorVulnerabilityActive=timeStarted+20 end
		--TauntTimer
		if abilityId==38254 and (castByPlayer or not BUI.Vars.TauntTimerSource) then TauntTimer=math.floor(timeEnding-now/1000+.5)
		--Crusher
		elseif abilityId==17906 then CrusherTimer=math.floor(timeEnding-now/1000+.5) end
		--ReticleResist
		if BUI.Vars.ReticleResist~=3 and BUI.Target.resist>0 then
			if BUI.Penetration.Target[buffName] then penetr=penetr+BUI.Penetration.Target[buffName] end
		end
	end
	--Sort
	if BUI.Vars.TargetBuffs then
--		table.sort(BUI.TargetBuffs, function(x,y) return (x and x.timeStarted<y.timeStarted) end)
		table.sort(BUI.TargetBuffs, function(x,y) return (x and x.Timer<y.Timer) end)
	end
--[[	--Combat Reticle
	if BUI.Vars.InCombatReticle then
		if status_effect then
			ZO_ReticleContainerStealthIconStealthText:SetAlpha(.7)
			ZO_ReticleContainerStealthIconStealthText:SetText(status_effect)
			BUI.Target.status=true
		else
			ZO_ReticleContainerStealthIconStealthText:SetAlpha(0)
			BUI.Target.status=false
		end
	end
--]]
	--ReticleResist
	if BUI.Vars.ReticleResist~=3 then
		if BUI.Target.resist>0 then
			local delta=BUI.Target.resist-OWN_PENETR-TMP_PENETR-penetr	-- if delta<0 then delta=0 end
			local text
			if BUI.Vars.ReticleResist==2 then	--and delta>0
				text="|cCCCCAA"..BUI.Target.resist.."\n-"..(OWN_PENETR+TMP_PENETR).."\n-"..penetr.."|r\n"..delta
			end
			BUI.Reticle.TargetResist(BUI.Target.difficulty,OWN_PENETR+TMP_PENETR,penetr,text)
		end
	end
	--TauntTimer
	if BUI.Vars.TauntTimer~=4 then BUI.Reticle.TauntTimer(TauntTimer) end
	if BUI.Vars.CrusherTimer then BUI.Reticle.CrusherTimer(CrusherTimer) end
	end
end
local function TimersUpdate()
	if BUI.Vars.PlayerBuffs or BUI.Vars.EnableCustomBuffs or BUI.Vars.EnableWidgets or (BUI.Vars.EnableStats and BUI.Vars.StatsBuffs) then BuffsPlayer() end
	if BUI.Vars.TargetBuffs or BUI.Vars.StatsBuffs or BUI.Vars.EnableWidgets or (BUI.Vars.EnableStats and BUI.Vars.StatsBuffs) then BuffsTarget() end

	if not BUI.move then
		if BUI.Vars.TargetBuffs then TargetBuffs_Update() end
		if BUI.Vars.PlayerBuffs then PlayerBuffs_Update() end
		if BUI.Vars.EnableWidgets then Widgets_Update() end
		if BUI.Vars.EnableCustomBuffs then CustomBuffs_Update() end
		if BUI.Vars.EnableSynergyCd then SynergyCd_Update() end
	end
end

function BUI.Buffs.ShowTooltip(control)
	local data=control.passives and BUI.PassiveBuffs[control.index] or (control.custom and BUI.CustomBuffs[control.index] or (control.widget and BUI.Widgets[control.index] or BUI.PlayerBuffs[control.index]))
	if not data or data.Blank then return end
	if data.Target then for name in pairs(data) do if name~="Target" then data=data[name] break end end end
	InitializeTooltip(InformationTooltip, control, BOTTOM, 0, -16)
	InformationTooltip:AddLine(zo_strformat("<<C:1>>",data.Name),'$(BOLD_FONT)'..'|22',1,1,1)
	local desc=type(data.id)=="number" and GetAbilityDescription(data.id) or ""
	local text=	'|t300:8:/EsoUI/Art/Miscellaneous/horizontalDivider.dds|t\n'
		..	'ID: |cFFFFFF'..data.id..'|r\n'
		..	'Duration: |cFFFFFF'..(data.Duration and math.floor(data.Duration) or GetAbilityDuration(data.id)/1000)..' seconds|r\n'
		..	'Type: |cFFFFFF'..(data.Positive and "Buff" or "Debuff")..'|r\n'
		..	(data.Player and 'Cast by: |cFFFFFFPlayer|r\n' or '')
		..	'|t300:8:/EsoUI/Art/Miscellaneous/horizontalDivider.dds|t\n'
		..	(desc~='' and desc..'\n|t300:8:/EsoUI/Art/Miscellaneous/horizontalDivider.dds|t\n' or '')
		..	((not control.custom and not control.widget) and '|t16:16:/BanditsUserInterface/textures/lmb.dds|t'	.." Add to custom " or "")
		..	'|t16:16:/BanditsUserInterface/textures/rmb.dds|t'	..((control.custom or control.widget) and " Remove" or " Blacklist")
		..	(not control.widget and '\n|t16:16:/BanditsUserInterface/textures/mmb.dds|t'	.." Make widget" or "")
	SetTooltipText(InformationTooltip, text)
end

local function UpdateChoices(target,id,clear)
	if target=="Black List" then
		BUI.Menu.Black_List,BUI.Menu.Black_List_Values=BUI.Menu.MakeList(BUI.Vars.BuffsBlackList)
		if BUI_Black_List_Dropdown then
			BUI_Black_List_Dropdown:UpdateValues(BUI.Menu.Black_List)
		end
	elseif target=="Custom buffs" then
		BUI.Menu.Custom_List,BUI.Menu.Custom_List_Values=BUI.Menu.MakeList(BUI.Vars.CustomBuffs)
		if BUI_Custom_Buffs_Dropdown then
			BUI_Custom_Buffs_Dropdown:UpdateValues(BUI.Menu.Custom_List)
		end
		BUI.Frames.CustomBuffs_Init()
	elseif target=="Widgets" then
--		if BUI_Widgets_Dropdown then BUI_Widgets_Dropdown:UpdateValues(BUI.Menu.MakeList(BUI.Vars.Widgets)) end
		if id then
			if BUI_Menu_Context then BUI_Menu_Context:SetHidden(true) end
			local control=_G["BUI_Widget_"..string.gsub(id," ","_")] if control then control:SetHidden(true) end
			if clear then BUI.Vars["BUI_Widget_"..string.gsub(id," ","_")]=nil end
		end
	end
end

ZO_Dialogs_RegisterCustomDialog("BUI_BUFFS_CONFIRMATION", {
	gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC, allowShowOnNextScene=true},
	title={text=SI_CUSTOMER_SERVICE_SUBMIT_CONFIRMATION},
	mainText=function(dialog) return {text=dialog.data.prompt} end,
	buttons=
		{
			{text=SI_OK,callback=function(dialog)
					dialog.data.var[dialog.data.id]=dialog.data.value
					UpdateChoices(dialog.data.target,dialog.data.id,true)
				end,keybind="DIALOG_PRIMARY",clickSound=SOUNDS.DIALOG_ACCEPT},
			{text=SI_DIALOG_CANCEL,keybind="DIALOG_NEGATIVE",clickSound=SOUNDS.DIALOG_ACCEPT}
		}
	}
)
--[[
local ErrorDialog={
	gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC, allowShowOnNextScene=true},
	title={text=SI_PROMPT_TITLE_ERROR},
	mainText={text="Attempt to add buff:\nwrong buff name or id."},
	buttons=
		{
			{text=SI_DIALOG_CANCEL,keybind="DIALOG_NEGATIVE",clickSound=SOUNDS.DIALOG_ACCEPT,}
		},
}
ZO_Dialogs_RegisterCustomDialog("BUI_BUFFS_ERROR", ErrorDialog)
--]]

function BUI.Buffs.ButtonHandler(control,button)
	if BUI.move then return end
	local data=(control.passives) and BUI.PassiveBuffs[control.index] or BUI.PlayerBuffs[control.index]
	local target
	if button==1 then
		if not control.custom and not control.widget then
			target="Custom buffs"
			BUI.Buffs.AddTo(BUI.Vars.CustomBuffs,data.id,target)
		end
	elseif button==2 then
		if control.custom then
			target="Custom buffs"
			BUI.Buffs.RemoveFrom(BUI.Vars.CustomBuffs,BUI.CustomBuffs[control.index].id,target)
		elseif control.widget then
			target="Widgets"
			BUI.Buffs.RemoveFrom(BUI.Vars.Widgets,control.index,target)
		else
			target="Black List"
			BUI.Buffs.AddTo(BUI.Vars.BuffsBlackList,data.id,target)
		end
	elseif button==3 then
		if not control.widget then
			target="Widgets"
			if control.custom then
				BUI.Buffs.AddTo(BUI.Vars.Widgets,BUI.CustomBuffs[control.index].id,target)
			else
				BUI.Buffs.AddTo(BUI.Vars.Widgets,data.id,target)
			end
		end
	end
end

function BUI.Buffs.AddTo(var,value,target)
	local id=tonumber(value)
	local prompt
	local success=false
	local fs=18
	if id and id>100 and id<900000 then
		local fs=18
		local name=GetAbilityName(id)
		if name~="" then
			success=true
			prompt=zo_strformat(BUI.Loc("BuffsAdded"),zo_iconFormat(GetAbilityIcon(id),fs,fs).."["..id.."] "..name,target)
			if target=="Widgets" then BUI.Frames.Widgets_Init(id) end
		end
	elseif string.len(value)>3 then
		success=true
		id=value
		prompt=zo_strformat(BUI.Loc("BuffsAdded"),value,target)
		if target=="Widgets" then BUI.Frames.Widgets_Init(id) end
	end
--	CHAT_SYSTEM:Maximize() CHAT_SYSTEM.primaryContainer:FadeIn()
	if success then
--		ZO_Dialogs_ShowDialog ("BUI_BUFFS_CONFIRMATION", {var=var,id=id,value=true,prompt=prompt,widget=(target=="Widgets")})
		ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, prompt)	--d(prompt)
		var[id]=true
		UpdateChoices(target)
	else
		ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, BUI.Loc("BuffsAddFail"))	-- d(BUI.Loc("BuffsAddFail"))
	end
end

function BUI.Buffs.RemoveFrom(var,value,target)
	local id=tonumber(value)
	local prompt=BUI.Loc("BuffsRemove")
	if id then
		local fs=18
		local name=GetAbilityName(id)
		prompt=zo_strformat(prompt,zo_iconFormat(GetAbilityIcon(id),fs,fs).."["..id.."] "..name,target)
		if not var[id] then id=name end
	else
		id=value
		prompt=zo_strformat(prompt,value,target)
	end
	ZO_Dialogs_ShowDialog ("BUI_BUFFS_CONFIRMATION", {var=var,id=id,value=false,prompt=prompt,target=target})
end

function BUI.FormatTime(t)
	if t<0 then return ""
	elseif t<60 then
		return BUI.Vars.DecimalValues and string.format('%.1f',t) or math.floor(t+.5)
	elseif t<3600 then
--		return ZO_FormatTime(t,SI_TIME_FORMAT_TIMESTAMP)
		return BUI.Vars.DecimalValues and string.format('%d:%.2d',math.floor(t/60),t%60) or math.floor(t/60+.5)
	elseif t>172800 then
		return string.format('%dd', t/86400)
	else
--		return string.sub(ZO_FormatTime(t,SI_TIME_FORMAT_TIMESTAMP),1,4)
		return string.format('%d:%.2d',math.floor(t/3600),t%3600/60)
	end
end

local function GroupSynergy(name,abilityId)
	if name and BUI.Group[name] then
--		d("["..abilityId.."] "..name..(BUI.Group[name] and " ("..BUI.Group[name].accname..")" or "").." used "..Synergy_Name[Synergy_id[abilityId]])
		local index=BUI.Group[name].index
		if index then
			local now=GetGameTimeMilliseconds()
			if not BUI.GroupSynergy[index] then BUI.GroupSynergy[index]={} end
			BUI.GroupSynergy[index][abilityId]={t=now+20000}
			if not BUI.GroupSynergyActive then
				BUI.GroupSynergyActive=true
				EVENT_MANAGER:RegisterForUpdate("BUI_GroupSynergy",1000,BUI.Frames.GroupSynergy)
				BUI.Frames.GroupSynergy()
			end
		end
	end
end

local function OnCombatEvent(_,result,isError,_,_,_,sourceName,_,_,_,hitValue,_,_,_,sourceUnitId,targetUnitId,abilityId)
	if isError then return end
	if string.gsub(sourceName,"%^%w+","")==BUI.Player.name then
		local now=GetGameTimeMilliseconds()
		--SynergyCd
		if Synergy_id[abilityId] then
			if BUI.Vars.EnableSynergyCd then
				for i=1,4 do
					if not(BUI.SynergyCd[i] and BUI.SynergyCd[i].id~=abilityId) then
						BUI.SynergyCd[i]={
							id		=abilityId,
							Name		=Synergy_Name[ Synergy_id[abilityId] ],
							Texture	=Synergy_Texture[ Synergy_id[abilityId] ],
							StartTime	=now,
						}
						break
					end
				end
			elseif BUI.Vars.GroupSynergy~=3 then
				GroupSynergy(BUI.Player.name,abilityId)
			end
			return
		end
		--Buffs
		if ProcEffects[abilityId] then
			BUI.Buffs.Effects[ProcEffects[abilityId].n]={id=abilityId,timeStarted=now/1000,timeEnding=now/1000+ProcEffects[abilityId].cd}
		end
		--Ability timers
		if BUI.Vars.Actions then
			if abilityId==40375 and BUI.Actions.AbilityBar[40372] then BUI.Actions.AbilityBar[40372].StartTime=now  BUI.Actions.AbilityBar[40372].Duration=BUI.GetAbilityDuration(40372)	--Trap
			elseif abilityId==40385 and BUI.Actions.AbilityBar[40382] then BUI.Actions.AbilityBar[40382].StartTime=now BUI.Actions.AbilityBar[40382].Duration=BUI.GetAbilityDuration(40382)	--Trap
			elseif abilityId==40468 and BUI.Actions.AbilityBar[40465] then BUI.Actions.AbilityBar[40465].StartTime=now BUI.Actions.AbilityBar[40465].Duration=BUI.GetAbilityDuration(40465)	--Scalding Rune
			end
		end
	elseif Synergy_id[abilityId] and BUI.Vars.GroupSynergy~=3 then
		GroupSynergy(BUI.GroupMembers[targetUnitId],abilityId)
	end
end

function BUI.Buffs.Initialize()
	theme_color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.CustomEdgeColor
	if BUI.Vars.PlayerBuffs then BUI.Frames.PlayerBuffs_Init() end
	if BUI.Vars.TargetBuffs then BUI.Frames.TargetBuffs_Init() end
	if BUI.Vars.EnableCustomBuffs then BUI.Frames.CustomBuffs_Init() end
	if BUI.Vars.EnableSynergyCd then BUI.Frames.SynergyCd_Init() end
	if BUI.Vars.PlayerBuffs and BUI.Vars.BuffsPassives=="On additional panel" then BUI.Frames.PassiveBuffs_Init() end
	if BUI.Vars.EnableWidgets then BUI.Frames.Widgets_Init() end

	if BUI.Vars.PlayerBuffs or BUI.Vars.TargetBuffs or BUI.Vars.EnableCustomBuffs or BUI.Vars.EnableWidgets or (BUI.Vars.EnableStats and BUI.Vars.StatsBuffs) then
		EVENT_MANAGER:RegisterForUpdate("BUI_TimersUpdate", BUI.Buffs.UpdateTime, TimersUpdate)
	else
		EVENT_MANAGER:UnregisterForUpdate("BUI_TimersUpdate")
	end

	if BUI.Vars.ReticleResist~=3 or BUI.Vars.EnchantTimer~=3 or BUI.Vars.NotificationsGroup or (BUI.Vars.EnableStats and BUI.Vars.StatsBuffs) then
		EVENT_MANAGER:RegisterForEvent("BUI_Buffs", EVENT_ACTIVE_WEAPON_PAIR_CHANGED,	OnPairChanged)
		EVENT_MANAGER:RegisterForEvent("BUI_Buffs", EVENT_PLAYER_ACTIVATED,	OnPlayerActivated)
	else
		EVENT_MANAGER:UnregisterForEvent("BUI_Buffs", EVENT_ACTIVE_WEAPON_PAIR_CHANGED)
		EVENT_MANAGER:UnregisterForEvent("BUI_Buffs", EVENT_PLAYER_ACTIVATED)
	end

	if BUI.Vars.NotificationsGroup or BUI.Vars.StatShare then
		EVENT_MANAGER:RegisterForEvent("BUI_Buffs", EVENT_ACTION_SLOT_ABILITY_SLOTTED,	OnAbilitySlotted)
	else
		EVENT_MANAGER:UnregisterForEvent("BUI_Buffs", EVENT_ACTION_SLOT_ABILITY_SLOTTED)
	end

	local filters={
--		21230,		--Berserk
--		17906,		--Crusher
		107141,109084,	--Vestment of Olorime
		110067,110143,	--Siroria's Boon
		99204,		--Mechanical Acuity
		40375,40385,	--Trap
		40468,		--Scalding Rune
		126941,		--Maarselok
		126924,		--Hollowfang Thirst
		136098,137995,	--Kyne's Blessing
		81036,		--Sentinel of Rkugamz
		}
	for id in pairs(Synergy_id) do table.insert(filters,id) end
	if BUI.Vars.PlayerBuffs or BUI.Vars.EnableWidgets or BUI.Vars.EnableCustomBuffs or BUI.Vars.EnableSynergyCd then
		for _,id in pairs(filters) do
			EVENT_MANAGER:RegisterForEvent("BUI_Buffs"..id, EVENT_COMBAT_EVENT, OnCombatEvent)
			EVENT_MANAGER:AddFilterForEvent("BUI_Buffs"..id, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED, REGISTER_FILTER_IS_ERROR, false)
			EVENT_MANAGER:AddFilterForEvent("BUI_Buffs"..id, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, id)
		end
	else
		for _,id in pairs(filters) do
			EVENT_MANAGER:UnregisterForEvent("BUI_Buffs"..id, EVENT_COMBAT_EVENT)
		end
	end
end
