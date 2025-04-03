local Defaults={
	DeleteMail=false,
	ConfirmLocked=false,
	JumpToLeader=false,
	GroupLeave=false,
	Books=false,
	FriendStatus=false,
	LargeGroupInvite=true,
	LargeGroupAnnoucement=true,
	FastTravel=false,
	InitialDialog=false,
	RepeatableQuests=false,
--	CovetousCountess=false,
	DarkBrotherhoodSpree=false,
--	FeedSynergy=false,
	AdvancedSynergy=false,
	BlockAnnouncement=false,
	ContainerHandler=false,
	AutoQueue=false,
	UndauntedPledges=false,
	DungeonQuests=false,
	CollapseNormalDungeon=false,
	PlayerToPlayer=false,
	BuiltInGlobalCooldown=false,
	AutoDismissPet=true,
	HousePins=4,
	}
BUI:JoinTables(BUI.Defaults,Defaults)
local lastInteractableName
local ContainerHandlerRunning,LootStolen=false,false
local Button_Fish,Button_Container
local ItemsTotal={[ITEMTYPE_FISH]=0,[ITEMTYPE_CONTAINER]=0}
local GeodeContainer={
	[134583]=1,[134623]=4,[134622]=4,[134590]=4,[134588]=5,[134591]=10,[134618]=50,	--Geode
	[87703]=5,[139665]=5,[139669]=5,	--Warriors Coffer
	[139664]=5,[87702]=5,[139668]=5,	--Mages Coffer
	[87705]=5,[87706]=5,[139666]=5,[139667]=5,	--Serpent Coffer
	[94089]=5,[139670]=5,	--Dro-m'Athra Coffer
	[138711]=5,[138712]=5,[141739]=5,[141738]=5,	--Welkynar Coffer
	[139674]=5,	--Saint's Coffer
	[139673]=5,	--Fabricant Coffer
	[151970]=5,	--Sunspire Coffer
}
local WhiteList={
	[ITEMTYPE_CONTAINER]={
	[147434]=true,	--Jubilee Gift
	[194428]=true,	--Jubilee Gift
	},
	[ITEMTYPE_FISH]={}
}
local IgnoreItemId={
[135004]=true,[135006]=true,	--Cyrodiil Assault, Defence Crates
}
local ItemTypes={
	[ITEMTYPE_CONTAINER]={
		[ITEMTYPE_CONTAINER]=true,
		[ITEMTYPE_CONTAINER_CURRENCY]=true
	},
	[ITEMTYPE_FISH]={
		[ITEMTYPE_FISH]=true
	}
}
local ConfirmationDialog={
	["CONFIRM_RETRAIT_LOCKED_ITEM"]=true,
	["CONFIRM_ENCHANT_LOCKED_ITEM"]=true,
	["CONFIRM_IMPROVE_LOCKED_ITEM"]=true,
	}

--  Useful Scripts for obtaining the information in this table
--  /script d(GetZoneNameById(272))
--  /script d(GetAchievementIdFromLink(""))
--	/script d(ZO_DungeonFinder_KeyboardListSectionScrollChildContainer3:GetChild(34).node.data)
--	/script d(GetCompletedQuestInfo(5288))
--	"normal", "vet", "hm", "tt", and "nd" are AchievmentId's
--	"pledge" is a QuestId
local DungeonIndex={
[148]	={normal=272,	quest=4202,	vet=1604,	hm=1609,	tt=1607,	nd=1608,	npc="Glirion",	pledge=5288,	index=9},	--Arx Corinium
[1389]	={normal=3468,	quest=6896,	vet=3469,	hm=3470,	tt=3471,	nd=3472,	npc="Urgarlag",	pledge=6897,	index=27},	--Bal Sunnar
[1471]	={normal=3851,	quest=7155,	vet=3852,	hm=3853,	tt=3854,	nd=3855,	npc="Urgarlag",	pledge=7156,	index=30},	--Bedlam Veil
[1228]	={normal=2831,	quest=6576,	vet=2832,	hm=2833,	tt=2834,	nd=2835,	npc="Urgarlag",	pledge=6577,	index=19},	--Black Drake Villa
[38]	={normal=410,	quest=4589,	vet=1647,	hm=1652,	tt=1650,	nd=1651,	npc="Glirion",	pledge=5305,	index=8},	--Blackheart Haven
[64]	={normal=393,	quest=4469,	vet=1641,	hm=1646,	tt=1644,	nd=1645,	npc="Glirion",	pledge=5306,	index=2},	--Blessed Crucible
[973]	={normal=1690,	quest=5889,	vet=1691,	hm=1696,	tt=1694,	nd=1695,	npc="Urgarlag",	pledge=6053,	index=5},	--Bloodroot Forge
[1201]	={normal=2704,	quest=6507,	vet=2705,	hm=2706,	tt=2707,	nd=2708,	npc="Urgarlag",	pledge=6508,	index=18},	--Castle Thorn
[176]	={normal=551,	quest=4778,	vet=1597,	hm=1602,	tt=1600,	nd=1601,	npc="Glirion",	pledge=5290,	index=6},	--City of Ash I
[681]	={normal=1603,	quest=5120,	vet=878,	hm=1114,	tt=1108,	nd=1107,	npc="Glirion",	pledge=5381,	index=11},	--City of Ash II
[1301]	={normal=3104,	quest=6740,	vet=3105,	hm=3153,	tt=3107,	nd=3108,	npc="Urgarlag",	pledge=6741,	index=23},	--Coral Aerie
[848]	={normal=1522,	quest=5702,	vet=1523,	hm=1524,	tt=1525,	nd=1526,	npc="Urgarlag",	pledge=5780,	index=4},	--Cradle of Shadows
[130]	={normal=80,	quest=4379,	vet=1610,	hm=1615,	tt=1613,	nd=1614,	npc="Glirion",	pledge=5283,	index=12},	--Crypt of Hearts I
[932]	={normal=1616,	quest=5113,	vet=876,	hm=1084,	tt=941,	nd=942,	npc="Glirion",	pledge=5284,	index=5},	--Crypt of Hearts II
[63]	={normal=78,	quest=4145,	vet=1581,	hm=1586,	tt=1584,	nd=1585,	npc="Maj",	pledge=5274,	index=12},	--Darkshade Caverns I
[930]	={normal=1587,	quest=4641,	vet=464,	hm=467,	tt=465,	nd=1588,	npc="Maj",	pledge=5275,	index=7},	--Darkshade Caverns II
[1081]	={normal=2270,	quest=6251,	vet=2271,	hm=2272,	tt=2273,	nd=2274,	npc="Urgarlag",	pledge=6252,	index=11},	--Depths of Malatar
[449]	={normal=357,	quest=4346,	vet=1623,	hm=1628,	tt=1626,	nd=1627,	npc="Glirion",	pledge=5291,	index=3},	--Direfrost Keep
[1360]	={normal=3375,	quest=6835,	vet=3376,	hm=3377,	tt=3378,	nd=3379,	npc="Urgarlag",	pledge=6836,	index=25},	--Earthen Root Enclave
[126]	={normal=11,	quest=4336,	vet=1573,	hm=1578,	tt=1576,	nd=1577,	npc="Maj",	pledge=5276,	index=8},	--Elden Hollow I
[931]	={normal=1579,	quest=4675,	vet=459,	hm=463,	tt=461,	nd=1580,	npc="Maj",	pledge=5277,	index=1},	--Elden Hollow II
[1496]	={normal=4109,	quest=7235,	vet=4110,	hm=4111,	tt=4112,	nd=4113,	npc="Urgarlag",	pledge=7236,	index=31},	--Exiled Redoubt
[974]	={normal=1698,	quest=5891,	vet=1699,	hm=1704,	tt=1702,	nd=1703,	npc="Urgarlag",	pledge=6054,	index=6},	--Falkreath Hold
[1009]	={normal=1959,	quest=6064,	vet=1960,	hm=1965,	tt=1963,	nd=1964,	npc="Urgarlag",	pledge=6155,	index=7},	--Fang Lair
[1080]	={normal=2260,	quest=6249,	vet=2261,	hm=2262,	tt=2263,	nd=2264,	npc="Urgarlag",	pledge=6250,	index=12},	--Frostvault
[283]	={normal=294,	quest=3993,	vet=1556,	hm=1561,	tt=1559,	nd=1560,	npc="Maj",	pledge=5247,	index=10},	--Fungal Grotto I
[934]	={normal=1562,	quest=4303,	vet=343,	hm=342,	tt=340,	nd=1563,	npc="Maj",	pledge=5248,	index=5},	--Fungal Grotto II
[1361]	={normal=3394,	quest=6837,	vet=3395,	hm=3396,	tt=3397,	nd=3398,	npc="Urgarlag",	pledge=6838,	index=26},	--Graven Deep
[1152]	={normal=2539,	quest=6414,	vet=2540,	hm=2541,	tt=2542,	nd=2543,	npc="Urgarlag",	pledge=6415,	index=15},	--Icereach
[678]	={normal=1345,	quest=5136,	vet=880,	hm=1303,	tt=1128,	nd=1129,	npc="Urgarlag",	pledge=5382,	index=1},	--Imperial City Prison
[1123]	={normal=2425,	quest=6351,	vet=2426,	hm=2427,	tt=2428,	nd=2429,	npc="Urgarlag",	pledge=6352,	index=14},	--Lair of Maarselok
[1497]	={normal=4128,	quest=7237,	vet=4129,	hm=4130,	tt=4131,	nd=4132,	npc="Urgarlag",	pledge=7238,	index=32},	--Lep Seclusa
[1055]	={normal=2162,	quest=6188,	vet=2163,	hm=2164,	tt=2165,	nd=2166,	npc="Urgarlag",	pledge=6189,	index=10},	--March of Sacrifices
[1052]	={normal=2152,	quest=6186,	vet=2153,	hm=2154,	tt=2155,	nd=2156,	npc="Urgarlag",	pledge=6187,	index=9},	--Moon Hunter Keep
[1122]	={normal=2415,	quest=6349,	vet=2416,	hm=2417,	tt=2418,	nd=2419,	npc="Urgarlag",	pledge=6350,	index=13},	--Moongrave Fane
[1470]	={normal=3810,	quest=7105,	vet=3811,	hm=3812,	tt=3813,	nd=3814,	npc="Urgarlag",	pledge=7106,	index=29},	--Oathsworn Pit
[1267]	={normal=3016,	quest=6683,	vet=3017,	hm=3018,	tt=3019,	nd=3020,	npc="Urgarlag",	pledge=6684,	index=21},	--Red Petal Bastion
[843]	={normal=1504,	quest=5403,	vet=1505,	hm=1506,	tt=1507,	nd=1508,	npc="Urgarlag",	pledge=5636,	index=2},	--Ruins of Mazzatun
[1010]	={normal=1975,	quest=6065,	vet=1976,	hm=1981,	tt=1979,	nd=1980,	npc="Urgarlag",	pledge=6154,	index=8},	--Scalecaller Peak
[1390]	={normal=3529,	quest=7027,	vet=3530,	hm=3531,	tt=3532,	nd=3533,	npc="Urgarlag",	pledge=7028,	index=28},	--Scrivener's Hall
[31]	={normal=417,	quest=4733,	vet=1635,	hm=1640,	tt=1638,	nd=1639,	npc="Glirion",	pledge=5307,	index=10},	--Selene's Web
[1302]	={normal=3114,	quest=6742,	vet=3115,	hm=3154,	tt=3117,	nd=3118,	npc="Urgarlag",	pledge=6743,	index=24},	--Shipwright's Regret
[144]	={normal=301,	quest=4054,	vet=1565,	hm=1570,	tt=1568,	nd=1569,	npc="Maj",	pledge=5260,	index=6},	--Spindleclutch I
[936]	={normal=1571,	quest=4555,	vet=421,	hm=448,	tt=446,	nd=1572,	npc="Maj",	pledge=5273,	index=3},	--Spindleclutch II
[1197]	={normal=2694,	quest=6505,	vet=2695,	hm=2755,	tt=2697,	nd=2698,	npc="Urgarlag",	pledge=6506,	index=17},	--Stone Garden
[131]	={normal=81,	quest=4538,	vet=1617,	hm=1622,	tt=1620,	nd=1621,	npc="Glirion",	pledge=5301,	index=7},	--Tempest Island
[380]	={normal=325,	quest=4107,	vet=1549,	hm=1554,	tt=1552,	nd=1553,	npc="Maj",	pledge=5244,	index=4},	--The Banished Cells I
[935]	={normal=1555,	quest=4597,	vet=545,	hm=451,	tt=449,	nd=1564,	npc="Maj",	pledge=5246,	index=11},	--The Banished Cells II
[1229]	={normal=2841,	quest=6578,	vet=2842,	hm=2843,	tt=2844,	nd=2845,	npc="Urgarlag",	pledge=6579,	index=20},	--The Cauldron
[1268]	={normal=3026,	quest=6685,	vet=3027,	hm=3028,	tt=3029,	nd=3030,	npc="Urgarlag",	pledge=6686,	index=22},	--The Dread Cellar
[1153]	={normal=2549,	quest=6416,	vet=2550,	hm=2551,	tt=2552,	nd=2553,	npc="Urgarlag",	pledge=6417,	index=16},	--Unhallowed Grave
[11]	={normal=570,	quest=4822,	vet=1653,	hm=1658,	tt=1656,	nd=1657,	npc="Glirion",	pledge=5309,	index=4},	--Vaults of Madness
[22]	={normal=391,	quest=4432,	vet=1629,	hm=1634,	tt=1632,	nd=1633,	npc="Glirion",	pledge=5303,	index=1},	--Volenfell
[146]	={normal=79,	quest=4246,	vet=1589,	hm=1594,	tt=1592,	nd=1593,	npc="Maj",	pledge=5278,	index=2},	--Wayrest Sewers I
[933]	={normal=1595,	quest=4813,	vet=678,	hm=681,	tt=679,	nd=1596,	npc="Maj",	pledge=5282,	index=9},	--Wayrest Sewers II
[688]	={normal=1346,	quest=5342,	vet=1120,	hm=1279,	tt=1275,	nd=1276,	npc="Urgarlag",	pledge=5431,	index=3},	--White-Gold Tower
}

function SiegeCameraToggle()
	local setting=GetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_THIRD_PERSON_SIEGE_WEAPONRY)
	if setting=="1" then setting="0" else setting="1" end
	SetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_THIRD_PERSON_SIEGE_WEAPONRY, setting, 1)
end

local function IsItemType(slotIndex, Type)
	local itemType=GetItemType(BAG_BACKPACK, slotIndex)
	local id=GetItemId(BAG_BACKPACK, slotIndex)
--	if GeodeContainer[id] then return false end
	if ItemTypes[Type][itemType] and not IgnoreItemId[id] then
		local usable, onlyFromActionSlot=IsItemUsable(BAG_BACKPACK, slotIndex)
		return usable and not onlyFromActionSlot
			and CanInteractWithItem(BAG_BACKPACK, slotIndex)
			and (
				WhiteList[Type][id]
				or (
					GetItemQuality(BAG_BACKPACK, slotIndex)<ITEM_QUALITY_LEGENDARY
					and (
						not GeodeContainer[id]
						or GetMaxPossibleCurrency(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)-GetCurrencyAmount(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)>GeodeContainer[id])
				)
			)
	end
	return false
end

local function HaveItems(Type)
	--d("Checking inventory")
	if not(CheckInventorySpaceSilently(2) and (IsInGamepadPreferredMode() and GAMEPAD_INVENTORY_FRAGMENT or BACKPACK_MENU_BAR_LAYOUT_FRAGMENT):GetState()==SCENE_SHOWN) then return false end
	local total=0
	for i=0, GetBagSize(BAG_BACKPACK)-1 do
		if IsItemType(i, Type) then
			local _, count=GetItemInfo(BAG_BACKPACK, i)
			--d(GetItemInfo(BAG_BACKPACK, i))
			total=total+count
		end
	end
	ItemsTotal[Type]=total
	return total>0
end

local function ChangeLabel(Type)
	local name=Type==ITEMTYPE_FISH and "UI_SHORTCUT_PRIMARY" or "UI_SHORTCUT_SECONDARY"
	local control=KEYBIND_STRIP.keybinds[name]
	if control then
		control=control:GetChild(1)
		if control:GetType()==CT_LABEL then
			local text=ContainerHandlerRunning and BUI.Loc("GENERIC_Stop").." ("..BUI.Loc("GENERIC_Left")..": " or GetString(Type==ITEMTYPE_FISH and SI_KEYBIND_STRIP_FILLET_FISH or SI_KEYBIND_STRIP_OPEN_CONTAINERS).." ("
			control:SetText(text..ItemsTotal[Type]..")")
		end
	end
end

local function HandleAll(Type)
	local result=not CheckInventorySpaceSilently(2) and SI_INVENTORY_ERROR_INVENTORY_FULL or (IsInGamepadPreferredMode() and GAMEPAD_INVENTORY_FRAGMENT or BACKPACK_MENU_BAR_LAYOUT_FRAGMENT):GetState()~=SCENE_SHOWN and SI_TRADESKILLRESULT18 or false
	if result then
		ContainerHandlerRunning=false
		ZO_Alert(UI_ALERT_CATEGORY_ERROR, SOUNDS.NEGATIVE_CLICK, result)
	elseif ContainerHandlerRunning then
		local slotIndex=nil
		for i=0, GetBagSize(BAG_BACKPACK)-1 do
			if IsItemType(i, Type) then slotIndex=i break end
		end
		if slotIndex then
			local _, count=GetItemInfo(BAG_BACKPACK, slotIndex)
			if count>0 then
				EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_LOOT_ITEM_FAILED, function(eventCode, reason)
--					d("Loot reason: "..(LotResults[reason] and LotResults[reason] or ""))
					EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_LOOT_ITEM_FAILED)
					local id=GetItemId(BAG_BACKPACK, slotIndex)
					IgnoreItemId[id]=true
					if ItemsTotal[Type]<=1 then ContainerHandlerRunning=false end
				end)
				local remaining=GetItemCooldownInfo(BAG_BACKPACK, slotIndex)
				if remaining>0 then BUI.CallLater("HandleAll",remaining+50,HandleAll,Type) return end
				ContainerHandlerRunning=Type
--				KEYBIND_STRIP:UpdateKeybindButtonGroup(Type==ITEMTYPE_FISH and Button_Fish or Button_Container)

				if IsProtectedFunction("UseItem") then
					if not CallSecureProtected("UseItem", BAG_BACKPACK, slotIndex) then
						PlaySound(SOUNDS.NEGATIVE_CLICK)
						ContainerHandlerRunning=false
					end
				else
					UseItem(BAG_BACKPACK, slotIndex)
				end

				ItemsTotal[Type]=ItemsTotal[Type]-1
				ChangeLabel(Type)
				BUI.CallLater("HandleAll",(Type==ITEMTYPE_FISH and 2300 or 1300),HandleAll,Type)
			end
		else
			KEYBIND_STRIP:UpdateKeybindButtonGroup(Type==ITEMTYPE_FISH and Button_Fish or Button_Container)
			ContainerHandlerRunning=false
		end
	end
	if not ContainerHandlerRunning then
		EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_LOOT_ITEM_FAILED)
		ChangeLabel(Type)
	end
	return ContainerHandlerRunning
end

local function ContainerHandler_Init(enable)
	if enable then
		Button_Fish={
			alignment=KEYBIND_STRIP_ALIGN_LEFT,
			{
				name=GetString(SI_KEYBIND_STRIP_FILLET_FISH),
				keybind="UI_SHORTCUT_PRIMARY",
				enabled=function()return true end,	--not ContainerHandlerRunning end,
				visible=function()return HaveItems(ITEMTYPE_FISH) end,
				order=100,
				callback=function()
					if ContainerHandlerRunning then
						ContainerHandlerRunning=false
						ChangeLabel(ITEMTYPE_FISH)
					else
						ContainerHandlerRunning=true
						HandleAll(ITEMTYPE_FISH)
					end
				end,
			},
		}

		Button_Container={
			alignment=KEYBIND_STRIP_ALIGN_LEFT,
			{
				name=GetString(SI_KEYBIND_STRIP_OPEN_CONTAINERS),
				keybind="UI_SHORTCUT_SECONDARY",
				enabled=function()return true end,	-- not ContainerHandlerRunning end,
				visible=function()return HaveItems(ITEMTYPE_CONTAINER) end,
				order=100,
				callback=function()
					if ContainerHandlerRunning then
						ContainerHandlerRunning=false
						ChangeLabel(ITEMTYPE_CONTAINER)
					else
						ContainerHandlerRunning=true
						HandleAll(ITEMTYPE_CONTAINER)
					end
				end,
			},
		}
		BACKPACK_MENU_BAR_LAYOUT_FRAGMENT:RegisterCallback("StateChange", function(oldState, newState)
			if newState==SCENE_SHOWN then
				KEYBIND_STRIP:AddKeybindButtonGroup(Button_Fish)
				KEYBIND_STRIP:AddKeybindButtonGroup(Button_Container)
				ChangeLabel(ITEMTYPE_FISH)
				ChangeLabel(ITEMTYPE_CONTAINER)
			elseif newState==SCENE_HIDING then
				KEYBIND_STRIP:RemoveKeybindButtonGroup(Button_Fish)
				KEYBIND_STRIP:RemoveKeybindButtonGroup(Button_Container)
			elseif newState==SCENE_HIDDEN then
				if ContainerHandlerRunning==ITEMTYPE_CONTAINER then LootAll() SCENE_MANAGER:Show("inventory") end
			end
		end )
	else
		BACKPACK_MENU_BAR_LAYOUT_FRAGMENT:UnregisterCallback("StateChange")
	end
end

local function GetGoalPledges()
	local Pledges,haveQuest={},false
	for i=1,MAX_JOURNAL_QUESTS do
		local name,_,_,stepType,_,completed,_,_,_,questType,instanceType=GetJournalQuestInfo(i)
		if name and name~="" and not completed and questType==QUEST_TYPE_UNDAUNTED_PLEDGE and instanceType==INSTANCE_TYPE_GROUP then --and name:match(".*:%s*(.*)")
--			d("GetGoalPledges => " .. name)
			Pledges[name]=stepType~=QUEST_STEP_TYPE_AND
			if stepType==QUEST_STEP_TYPE_AND then haveQuest=true end
--			if BUI.Vars.DeveloperMode then d(zo_strformat("QuestName: \"<<1>>\" Step: <<2>>",name,stepType)) end
		end
	end
	return Pledges,haveQuest
end

local function UndauntedPledges()
	local Pledges,haveQuest={},false
	local offset=1517479200
	if GetCVar("LastRealm")~="NA Megaserver" then offset=1517454000 end
	local day=math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(),offset)/86400)

	local function ToggleDungeonQuest()
		local parent=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildContainer"..2]
		if parent then
			for i=1,parent:GetNumChildren() do
				local obj=parent:GetChild(i)

				if obj and obj.needDungeonQuest and obj.check:GetState()==0 then
					obj.check:SetState(BSTATE_PRESSED, true)
					ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
				end
			end

		end
	end

	local function CheckPledges(c)
		local parent=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildContainer"..c]
		if parent then
			for i=1,parent:GetNumChildren() do
				local obj=parent:GetChild(i)
				if obj and obj.pledge and obj.check:GetState()==0 then
					obj.check:SetState(BSTATE_PRESSED, true)
					ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
				end
			end
		end
	end
--	/script d(ZO_DungeonFinder_KeyboardListSectionScrollChildContainer2:GetChild(1).node.data)
	local function MarkPledges()
		local isVeteran=GetUnitEffectiveChampionPoints('player')>=160 and 3 or 2
		for c=2,3 do
			local parent=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildContainer"..c]
			if parent then
				for i=1,parent:GetNumChildren() do
					local obj=parent:GetChild(i)
					if obj and obj.node.data.isLocked == false then
						local id=obj.node.data.zoneId
						if DungeonIndex[id] then

							--Achievement
							local completion = DungeonIndex[id].normal
							if c == 3 then
								completion = DungeonIndex[id].vet
							end
							local text=IsAchievementComplete(completion) and "|t16:16:/esoui/art/cadwell/check.dds|t" or ""

							if BUI.Vars.DungeonQuests then
								if c == 2 then
									text=text..((DungeonIndex[id].quest and GetCompletedQuestInfo(DungeonIndex[id].quest) == "" and obj.node.data.isLocked == false) and "|t20:20:/esoui/art/compass/quest_available_icon.dds|t" or "") --/esoui/art/compass/quest_available_icon.dds /esoui/art/icons/poi/poi_dungeon_complete.dds
									if GetCompletedQuestInfo(DungeonIndex[id].quest) == "" then
										obj.needDungeonQuest = true
									end
								end
							end

							if BUI.Vars.UndauntedPledges then
								if c == 3 then
									text=text..((DungeonIndex[id].hm and IsAchievementComplete(DungeonIndex[id].hm)) and "|t20:20:/esoui/art/unitframes/target_veteranrank_icon.dds|t" or "")
									text=text..((DungeonIndex[id].tt and IsAchievementComplete(DungeonIndex[id].tt)) and "|t20:20:/esoui/art/ava/overview_icon_underdog_score.dds|t" or "")
									text=text..((DungeonIndex[id].nd and IsAchievementComplete(DungeonIndex[id].nd)) and "|t20:20:/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds|t" or "")
								end
							end

							_=BUI.UI.Label("BUI_DungeonInfo"..c..i, obj, {80,20}, {LEFT,LEFT,465,0}, "ZoFontGameLarge", nil, {0,1}, text)


							if BUI.Vars.UndauntedPledges and GetUnitLevel("player") >= 45 then
								--Quest
								local orig=obj.text:GetText()

								--Daily pledges
								local daily=""
								local length = 12
								local shift = 0
								if DungeonIndex[id].npc == "Urgarlag" then -- Override Length if Urg - NEEDS TO BE UPDATED EACH DUNGEON ADDITON
									length = 32 -- Increment When New Dungeons Added - This is a count of how many quests Urgarlag gives out for daily pledges
									shift = 27  -- Adjust as necessary with Dungeon Additions - This is an offset that needs to be set manually to make Urgarlag quests show in the correct order. The value can be from 1 through the max number of pledge quests Urgarlag gives
								end
								if 1+(day+shift)%length == DungeonIndex[id].index then
									daily=" ("..BUI.Loc("UndauntedDaily")..")"
									obj.text:SetText(orig.." |c3388EE"..daily.."|r")
								end

								--Current pledges
								local questname = GetQuestName(DungeonIndex[id].pledge)
								local completed=Pledges[questname]
								obj.pledge=false

								if Pledges[questname]==true then
									obj.text:SetText(orig.." |c33EE33- "..BUI.Loc("UndauntedDone")..daily.."|r")
								elseif Pledges[questname]==false then
									obj.text:SetText(orig.." |c3388EE- "..BUI.Loc("UndauntedQuest")..daily.."|r")
									obj.pledge=true
								end
							end

--							d(obj.text:GetText())
						else
--							d("["..id.."] "..obj.text:GetText())
						end
					end
				end
			end
			local parent=_G["ZO_DungeonFinder_GamepadMaskContainerEntriesList"]
			if IsInGamepadPreferredMode() and parent then
				for i=1,parent:GetNumChildren() do
					local obj=parent:GetChild(i)
					if obj then
						local id=obj.node.data.zoneId
						if DungeonIndex[id] then

							--Quest
							local orig=obj.text:GetText()

							--Daily pledges
							local daily=""
							local length = 12
							local shift = 0
							if DungeonIndex[id].npc == "Urgarlag" then -- Override Length if Urg - NEEDS TO BE UPDATED EACH DUNGEON ADDITON
								length = 32 -- Increment When New Dungeons Added - This is a count of how many quests Urgarlag gives out for daily pledges
								shift = 27  -- Adjust as necessary with Dungeon Additions - This is an offset that needs to be set manually to make Urgarlag quests show in the correct order. The value can be from 1 through the max number of pledge quests Urgarlag gives
							end
							if 1+(day+shift)%length == DungeonIndex[id].index then
								daily=" ("..BUI.Loc("UndauntedDaily")..")"
								obj.text:SetText(orig.." |c3388EE"..daily.."|r")
							end

							--Current pledges
							local questname = GetQuestName(DungeonIndex[id].pledge)
							local completed=Pledges[questname]
							obj.pledge=false

							if Pledges[questname]==true then
								obj.text:SetText(orig.." |c33EE33- "..BUI.Loc("UndauntedDone")..daily.."|r")
							elseif Pledges[questname]==false then
								obj.text:SetText(orig.." |c3388EE- "..BUI.Loc("UndauntedQuest")..daily.."|r")
								obj.pledge=true
							end
						end
					end
				end
			end
			local parent=ZO_DungeonFinder_Keyboard	--ZO_DungeonFinder_KeyboardActionButtonContainer
			if parent then

				-- Dungeon Quest Button
				if BUI.Vars.DungeonQuests then
					DungeonQuestButton=BUI_DungeonQuestCheck or WINDOW_MANAGER:CreateControlFromVirtual("BUI_DungeonQuestCheck", parent, "ZO_DefaultButton")
					DungeonQuestButton:SetWidth(220, 28)
					DungeonQuestButton:SetText("Dungeon Quests")
					DungeonQuestButton:ClearAnchors()
					DungeonQuestButton:SetAnchor(BOTTOMLEFT,parent,BOTTOMLEFT,0,0)
					DungeonQuestButton:SetClickSound("Click")
					DungeonQuestButton:SetHandler("OnClicked", function()ToggleDungeonQuest()end)
					DungeonQuestButton:SetDrawTier(2)
				end

--				local w=parent:GetWidth()
				if isVeteran==c then
					if BUI.Vars.UndauntedPledges then
						button=BUI_PledgesCheck or WINDOW_MANAGER:CreateControlFromVirtual("BUI_PledgesCheck", parent, "ZO_DefaultButton")
						button:SetWidth(220, 28)
						button:SetText(BUI.Loc("ActFinderButton"))
						button:ClearAnchors()
						button:SetAnchor(BOTTOMRIGHT,parent,BOTTOMRIGHT,0,0)
						button:SetClickSound("Click")
						button:SetHandler("OnClicked", function()CheckPledges(c)end)
						button:SetState(haveQuest and BSTATE_NORMAL or BSTATE_DISABLED)
						button:SetDrawTier(2)
					end
				end
				if ZO_DungeonFinder_KeyboardQueueButton then
					ZO_DungeonFinder_KeyboardQueueButton:ClearAnchors()
					ZO_DungeonFinder_KeyboardQueueButton:SetAnchor(BOTTOM,parent,BOTTOM,-w/5,0)
					ZO_DungeonFinder_KeyboardQueueButton:SetDrawTier(2)
				end

				if BUI.Vars.CollapseNormalDungeon then
					local header=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildZO_ActivityFinderTemplateNavigationHeader_Keyboard"..c-1]
					if header then
						local state=header.text:GetColor()
						if (isVeteran==c)~=(state==1) then header:OnMouseUp(true) end
					end
				end
			end
		end
	end

	ZO_PreHookHandler(ZO_DungeonFinder_KeyboardListSection,'OnEffectivelyShown',function() Pledges,haveQuest=GetGoalPledges() BUI.CallLater("MarkPledges",200,MarkPledges) end)
	ZO_PreHookHandler(ZO_DungeonFinder_KeyboardListSection,'OnEffectivelyHidden',function() Pledges={} end)
end

function BUI.DailyPledges()
	local Pledges=GetGoalPledges()
	local offset=1517479200
	if GetCVar("LastRealm")~="NA Megaserver" then offset=1517454000 end
	local day=math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(),offset)/86400)
	d(BUI.Loc("ACTIVITYFINDER_DailyPledges")..":")
	for zoneId, v in pairs(DungeonIndex) do
		local length = 12
		local shift = 0
		if v.npc == "Urgarlag" then -- Override Length if Urg - NEEDS TO BE UPDATED EACH DUNGEON ADDITON
			length = 32 -- Increment When New Dungeons Added - This is a count of how many quests Urgarlag gives out for daily pledges
			shift = 27  -- Adjust as necessary with Dungeon Additions - This is an offset that needs to be set manually to make Urgarlag quests show in the correct order. The value can be from 1 through the max number of pledge quests Urgarlag gives
		end
		local n=1+(day+shift)%length
		local pledge=GetZoneNameById(zoneId)

		if (BUI.language == "es" or BUI.language == "de" or BUI.language == "fr" or BUI.language == "br" ) then
			pledge = pledge:gsub('%^.*', '')
		end

		local npcName = BUI.Loc("Daily_NPC_" .. v.npc)
		if n == v.index then
			d("["..npcName.."] "..pledge)
		end
		--/script d(GetZoneNameById(272))
	end
end

local function SynergyHandler()
	local hooked=ZO_Synergy.OnSynergyAbilityChanged
	ZO_Synergy.OnSynergyAbilityChanged=function()
		local synergyName,iconFilename=GetSynergyInfo()
		if synergyName then
--			if synergyName=="Feed" and BUI.Vars.FeedSynergy and not IsUnitPlayer('reticleover') then return
			if BUI.Vars.AdvancedSynergy then
				if synergyName~="Welkynar's Light" and (SYNERGY.lastSynergyName=="Shed Hoarfrost" or GetGameTimeMilliseconds()-BUI.Cloudrest.Hoarfrost<2000) then return
				elseif SYNERGY.lastSynergyName=="Gateway" or SYNERGY.lastSynergyName=="Wind of the Welkynar" then return
				elseif synergyName=="Gateway" and BUI.Player.role=="Healer" then return
				elseif synergyName=="Charged Lightning" and (BUI.Player.role=="Tank" or BUI.Player.role=="Healer") then return
				end
			end
		end
		hooked(SYNERGY)
	end
end

local function Menu_Init()
	local warning=BUI.Loc("ReloadUiWarn1")
	local MenuOptions={
		{type="header",	param="AutomationHeader"},
		{type="checkbox",	param="DeleteMail",		warning=true},
		{type="checkbox",	param="GroupLeave",		warning=true},
		{type="checkbox",	param="Books",			warning=true},
		{type="checkbox",	param="LargeGroupInvite",	warning=true},
		{type="checkbox",	param="FastTravel",		warning=true},
		{type="checkbox",	param="InitialDialog",		warning=true},
		{type="checkbox",	param="RepeatableQuests",	warning=true},
--		{type="checkbox",	param="CovetousCountess",	warning=true},
		{type="checkbox",	param="DarkBrotherhoodSpree",	warning=true},
		{type="checkbox",	param="ContainerHandler",	warning=true},
		{type="checkbox",	param="StealthWield",		warning=true},
		{type="checkbox",	param="LootStolen",		warning=true},
		{type="checkbox",	param="ConfirmLocked"},

		{type="header",	param="BlockingsHeader"},
--		{type="checkbox",	param="FeedSynergy"},
		{type="checkbox",	param="AdvancedSynergy"},
		{type="checkbox",	param="JumpToLeader",		warning=true},
		{type="checkbox",	param="LargeGroupAnnoucement",warning=true},
		{type="checkbox",	param="FriendStatus",		warning=true},
		{type="checkbox",	param="BlockAnnouncement",	warning=true},
		{type="dropdown",	param="HousePins",		warning="ReloadUiWarn3", choices={BUI.Loc("AUTOMATION_SETTINGS_MAP_PIN_All"),BUI.Loc("AUTOMATION_SETTINGS_MAP_PIN_Owned"),BUI.Loc("AUTOMATION_SETTINGS_MAP_PIN_Unowned"),BUI.Loc("AUTOMATION_SETTINGS_MAP_PIN_Disabled")}},

		{type="header",	param="ImprovementsHeader"},
		{type="checkbox",	param="UndauntedPledges",	warning=true},
		{type="checkbox",	param="DungeonQuests",	warning=true},
		{type="checkbox",	param="CollapseNormalDungeon",	warning=true, disabled=function() return not BUI.Vars.UndauntedPledges end},
		{type="checkbox",	param="PlayerToPlayer",		warning=true},
		{type="checkbox",   param="BuiltInGlobalCooldown", warning=true},
		{type="checkbox",   param="AutoDismissPet", warning=true},
		{type="button",	name="Reload UI",func=function() SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8, BUI.Loc("SETTINGS_ReloadingUI")) BUI.CallLater("ReloadUI",1000,ReloadUI) end},
		}
	local Options,i,var={},0,0
	for _,option in pairs(MenuOptions) do
		if not option.condition or BUI.Vars[option.condition] then
		for _,dup in pairs(option.dup and option.dup or {1}) do
			if not option.dup or (option.dup and (type(option.param)~="table" or (type(option.param)=="table" and option.param[dup]))) then
			i=i+1;Options[i]={}
			Options[i].type			=option.type
			if option.name then
				Options[i].name		=(option.icon and "|t32:32:"..option.icon.."|t " or "")..
								(option.dup and (type(option.name)=="table" and dup.." "..option.name[dup] or dup.." "..option.name) or option.name)
			else
				Options[i].name		=BUI.Loc(option.param)
			end
			if option.tooltip then
				Options[i].tooltip	=option.tooltip
			elseif option.param then
				Options[i].tooltip		=BUI.Loc(option.param.."Desc")
			end
			if option.text then
				Options[i].text		=option.text
			end
			if option.warning then
				Options[i].warning	=warning
			end
			if option.type=="slider" then
				Options[i].min		=1
				Options[i].max		=10
				Options[i].step		=1
			end
			if option.choices then
				Options[i].choices	=option.choices
			end
			if option.func then
				Options[i].func		=option.func
			end
			if option.width then
				Options[i].width		=option.width
			end
			if option.disabled then
				Options[i].disabled	=option.disabled
			end
			if option.param then
				Options[i].getFunc	=function()
					local var
					if option.dup then
						if type(option.param)=="table" then var=BUI.Vars[ option.param[dup] ]
						else var=BUI.Vars[option.param][dup] end
					else var=BUI.Vars[option.param] end
					return var
					end
				Options[i].setFunc	=function(value)
					if option.dup then
						if type(option.param)=="table" then BUI.Vars[ option.param[dup] ]=value
						else BUI.Vars[option.param][dup]=value end
					else BUI.Vars[option.param]=value end
					if option.func then local function func(value) option.func(value) end func(value) end
					end
				if option.dup then
					if type(option.param)=="table" then var=Defaults[ option.param[dup] ]
					else var=Defaults[option.param][dup] end
				else var=Defaults[option.param] end
				Options[i].default	=var
			end
			end
		end
		end
	end
	BUI.Menu.RegisterPanel("BUI_MenuAutomation",{
			type="panel",
			name="18. |t32:32:/esoui/art/treeicons/store_indexicon_bundle_up.dds|t"..BUI.Loc("AutomationHeader"),
			})
	BUI.Menu.RegisterOptions("BUI_MenuAutomation", Options)
end

function BUI.Automation_Init()
	Menu_Init()
	SynergyHandler()

--	EVENT_MANAGER:UnregisterForEvent("KeyboardNotifications",EVENT_GUILD_DESCRIPTION_CHANGED)

	if BUI.Vars.UndauntedPledges or BUI.Vars.DungeonQuests then UndauntedPledges() end

	if BUI.Vars.HousePins~=4 then
		RedirectTexture("/esoui/art/icons/poi/poi_group_house_glow.dds","/BanditsUserInterface/textures/theme/blank.dds")
		if BUI.Vars.HousePins==3 or BUI.Vars.HousePins==1 then
			RedirectTexture("/esoui/art/icons/poi/poi_group_house_unowned.dds","/BanditsUserInterface/textures/theme/blank.dds")
		end
		if BUI.Vars.HousePins<=2 then
			RedirectTexture("/esoui/art/icons/poi/poi_group_house_owned.dds","/BanditsUserInterface/textures/theme/blank.dds")
		end
	end

	ZO_PreHook("ZO_Dialogs_ShowDialog",function(dialog)
		if BUI.Vars.ConfirmLocked then
			BUI.CallLater("ConfirmationDialog",10,function()
				if ConfirmationDialog[dialog] then
					ZO_Dialog1EditBox:SetText(GetString(SI_PERFORM_ACTION_CONFIRMATION))
					ZO_Dialog1EditBox:LoseFocus()
				end
			end)
		end
	end)

	if BUI.Vars.PlayerToPlayer then	--Provided by @zelenin
		local hooked=PLAYER_TO_PLAYER.AddMenuEntry
		PLAYER_TO_PLAYER.AddMenuEntry=function(self, text, ...)
			if text==GetString(SI_PLAYER_TO_PLAYER_REMOVE_GROUP) then return end
			hooked(self, text, ...)
		end
	end

	--DELETE MAIL
	ZO_Dialogs_RegisterCustomDialog("BUI_DELETE_CONFIRMATION", {
		gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC, allowShowOnNextScene=true},
		title={text=SI_PROMPT_TITLE_DELETE_MAIL_ATTACHMENTS},
		mainText=function(dialog) return {text=dialog.data.body} end,
		buttons=
			{
				{text=SI_OK,callback=function(dialog)dialog.data.confirmationCallback()end,keybind="DIALOG_PRIMARY",clickSound=SOUNDS.MAIL_ITEM_DELETED},
				{text=SI_DIALOG_CANCEL,keybind="DIALOG_NEGATIVE",clickSound=SOUNDS.DIALOG_ACCEPT}
			}
		}
	)
	if BUI.Vars.DeleteMail then
		MAIL_INBOX.Delete=function(self)
			if self.mailId then
				local dialogTextParams = { mainTextParams = { GetString(SI_DELETE_MAIL_CONFIRMATION_TEXT), }, }
				local numAttachments,attachedMoney=GetMailAttachmentInfo(self.mailId)
				if numAttachments>0 or attachedMoney>0 then
					ZO_Dialogs_ShowDialog("BUI_DELETE_CONFIRMATION", { confirmationCallback = function(...) DeleteMail(self.mailId) PlaySound(SOUNDS.MAIL_ITEM_DELETED) end, title = SI_PROMPT_TITLE_DELETE_MAIL_ATTACHMENTS, body = BUI.Loc("DeleteMailConfirm"), })
				else
					DeleteMail(self.mailId)
					PlaySound(SOUNDS.MAIL_ITEM_DELETED)
				end
			end
		end
	end

	if BUI.Vars.JumpToLeader then
		PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_UNIT_CREATED)
		PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_ZONE_UPDATE)
		PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_GROUP_MEMBER_JOINED)
		PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_LEADER_UPDATE)
		PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_GROUP_MEMBER_LEFT)
	end

	if BUI.Vars.BlockAnnouncement then
		local function OnPlayerActivated(eventCode, initial)
			if initial then
				local scene=SCENE_MANAGER:GetScene('marketAnnouncement')
				local function OnSceneStateChange(oldState, newState)
					if newState==SCENE_SHOWN then
						SCENE_MANAGER:HideCurrentScene()
						scene:UnregisterCallback('StateChange', OnSceneStateChange)
					end
				end
				scene:RegisterCallback('StateChange', OnSceneStateChange)
			end
		end
		EVENT_MANAGER:RegisterForEvent("BUI_Event_Announce",EVENT_PLAYER_ACTIVATED,OnPlayerActivated)
	end

	local BuiltInGlobalCooldownOn=false
	if BUI.Vars.BuiltInGlobalCooldown then
		if not BuiltInGlobalCooldownOn then
	    	BuiltInGlobalCooldownOn=true
	       	d(BUI.Loc("AUTOMATION_Global_Cooldown"))
	       	ZO_ActionButtons_ToggleShowGlobalCooldown()
	    end
	end

	if BUI.Vars.GroupLeave then
		GROUP_LIST["keybindStripDescriptor"][4].callback=function() GroupLeave() end
	end

	if BUI.Vars.FriendInvite then
		EVENT_MANAGER:UnregisterForEvent("KeyboardNotifications",EVENT_INCOMING_FRIEND_INVITE_ADDED)
	end

	if BUI.Vars.QuestShare then
		EVENT_MANAGER:UnregisterForEvent("KeyboardNotifications",EVENT_QUEST_SHARED)
	end

	if BUI.Vars.GuildNot then
		EVENT_MANAGER:UnregisterForEvent("KeyboardNotifications",EVENT_GUILD_MOTD_CHANGED)
		EVENT_MANAGER:UnregisterForEvent("KeyboardNotifications",EVENT_RAID_SCORE_NOTIFICATION_ADDED)
	end

	if BUI.Vars.Books then
		local LastBook=""
		local function BookHandler(eventCode,inBook)
			local action,item,_,_ ,_,_=GetGameCameraInteractableActionInfo()
			if LastBook==item and item~="Bookshelf" then
				LastBook=""
			elseif action==GetString(SI_GAMECAMERAACTIONTYPE1)	--search
				or action==GetString(SI_GAMECAMERAACTIONTYPE15)	--examine
				or item=="Bookshelf" then
				SCENE_MANAGER:ShowBaseScene()
				LastBook=item
			end
		end
		EVENT_MANAGER:RegisterForEvent("BUI_Event",EVENT_SHOW_BOOK,BookHandler)
	end

	if BUI.Vars.FriendStatus then
		EVENT_MANAGER:UnregisterForEvent("ChatRouter", EVENT_FRIEND_PLAYER_STATUS_CHANGED)
	end

	if BUI.Vars.LargeGroupInvite then
	TryGroupInviteByName=function(Name,sentFromChat,displayInvitedMessage)
		if IsPlayerInGroup(Name) then ZO_Alert(UI_ALERT_CATEGORY_ALERT,nil,SI_GROUP_ALERT_INVITE_PLAYER_ALREADY_MEMBER) return end
		if not IsUnitGroupLeader("player") and GetGroupSize()>0 then ZO_Alert(UI_ALERT_CATEGORY_ALERT,nil,GetString("SI_GROUPINVITERESPONSE",GROUP_INVITE_RESPONSE_ONLY_LEADER_CAN_INVITE)) return end
		if IsConsoleUI() then
			local function GroupInviteCallback(success)
				if success then
					GroupInviteByName(Name)
					ZO_Menu_SetLastCommandWasFromMenu(not sentFromChat)
					if displayInvitedMessage then ZO_Alert(ALERT,nil,zo_strformat(GetString("SI_GROUPINVITERESPONSE",GROUP_INVITE_RESPONSE_INVITED),ZO_FormatUserFacingName(Name))) end
				end
			end
			ZO_ConsoleAttemptInteractOrError(GroupInviteCallback,Name,ZO_PLAYER_CONSOLE_INFO_REQUEST_DONT_BLOCK,ZO_CONSOLE_CAN_COMMUNICATE_ERROR_ALERT,ZO_ID_REQUEST_TYPE_DISPLAY_NAME,displayName)
		else
			if IsIgnored(Name) then ZO_Alert(UI_ALERT_CATEGORY_ALERT,nil,SI_GROUP_ALERT_INVITE_PLAYER_BLOCKED) return end
			GroupInviteByName(Name)
			ZO_Menu_SetLastCommandWasFromMenu(not sentFromChat)
			if displayInvitedMessage then ZO_Alert(ALERT,nil,zo_strformat(GetString("SI_GROUPINVITERESPONSE",GROUP_INVITE_RESPONSE_INVITED),Name)) end
		end
	end
	end

	if BUI.Vars.LargeGroupAnnoucement then
		EVENT_MANAGER:UnregisterForEvent("ChatRouter", EVENT_GROUP_TYPE_CHANGED)
	end

	if BUI.Vars.FastTravel and not IsInGamepadPreferredMode() then
		ESO_Dialogs["RECALL_CONFIRM"]={
			gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC},
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			canQueue=true,
			updateFn=function(dialog)
--				if not IsInGamepadPreferredMode() then
					FastTravelToNode(dialog.data.nodeIndex)
--					SCENE_MANAGER:ShowBaseScene()
					ZO_Dialogs_ReleaseDialog("RECALL_CONFIRM")
					SCENE_MANAGER:SetInUIMode(false)
--				end
			end
		}
		ESO_Dialogs["FAST_TRAVEL_CONFIRM"]={
			gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC},
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			canQueue=true,
			updateFn=function(dialog)
--				if not IsInGamepadPreferredMode() then
					FastTravelToNode(dialog.data.nodeIndex)
					ZO_Dialogs_ReleaseDialog("FAST_TRAVEL_CONFIRM")
					SCENE_MANAGER:SetInUIMode(false)
--				end
			end
		}
	end

	if BUI.Vars.InitialDialog or BUI.Vars.RepeatableQuests then
		local UndauntedNPCname={["Maj al-Ragath"]=true,["Glirion the Redbeard"]=true,["Urgarlag Chief-bane"]=true,["Bolgrul"]=true}
		local QuestNPCname={
		["Cardea Gallus"]=true,	--Fighters guild
		["Alvur Baren"]=true,	--Mages guild
--		["Maj al-Ragath"]=true,["Glirion the Redbeard"]=true,["Urgarlag Chief-bane"]=true,["Bolgrul"]=true,	--Undaunted
		["Zahari"]=true,["Battlereeve Tanerline"]=true,["Nisuzi"]=true,["Ri'hirr"]=true,	--Elsweyr
		["Jee-Lar"]=true,["Bolu"]=true,["Varo Hosidias"]=true,["Tuwul"]=true,	--Murkmire
		["Razgurug"]=true,["Clockwork Facilitator"]=true,["Novice Holli"]=true,["Bursar of Tributes"]=true,	--Clockwork City
		["Justiciar Tanorian"]=true,["Justiciar Farowel"]=true,	--Summerset
		["Traylan Omoril"]=true,["Beleru Omoril"]=true,["Dredase-Hlarar"]=true,["Valga Celatus"]=true,	--Vivec City
		["Huntmaster Sorim-Nakar"]=true,["Numani-Rasi"]=true,	--Ald'ruhn
		["Arzorag"]=true,["Guruzug"]=true,["Nednor"]=true,["Sonolia Muspidius"]=true,["Bagrugbesh"]=true,["Menninia"]=true,["Ushang the Untamed"]=true,["Arushna"]=true,["Thazeg"]=true,	--Wrothgar
		["Spencer Rye"]=true,["Reacquisition Board"]=true,["Fa'ren-dar"]=true,["Heist Board"]=true,	--Thieves Guild
		["Elam Drals"]=true,	--Dark Brotherhood	["Speaker Terenus"]=true,
		["Bounty Board"]=true,["Laronen"]=true,["Finia Sele"]=true,["Codus ap Dugal"]=true,	--Gold Coast
		}
		local BursarOfTributes={["Armor"]=true,["ed wi"]=true,["ures."]=true,["our f"]=true}
		local dialog_step=0
		local function EndQuestDialog()
			EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_QUEST_OFFERED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_QUEST_REMOVED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_QUEST_ADDED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_QUEST_COMPLETE_DIALOG)
--			d("Quest handler: done")
			EndInteraction(INTERACTION_CONVERSATION)
			dialog_step=0
		end
		local function HandleChatterBegin(eventCode, optionCount)
			local optionString,optionType=GetChatterOption(1)
			local _, name=GetGameCameraInteractableActionInfo()
--			d(name.." ["..optionType.."] "..optionString)
			if BUI.Vars.RepeatableQuests
			and (optionType==CHATTER_START_TALK or optionType==CHATTER_TALK_CHOICE or optionType==CHATTER_START_NEW_QUEST_BESTOWAL or optionType==CHATTER_START_COMPLETE_QUEST or optionType==CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS)
			and QuestNPCname[name] then
--				d("Start quest dialog")
				if optionType==CHATTER_START_NEW_QUEST_BESTOWAL then
--					d("NEW_QUEST_BESTOWAL Step: "..dialog_step)
					if name~="Bursar of Tributes" or BursarOfTributes[string.sub(GetOfferedQuestInfo(),121,125)] then
						EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_QUEST_OFFERED, AcceptOfferedQuest)
						EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_QUEST_ADDED, EndQuestDialog)
					end
					if dialog_step==0 then BUI.CallLater("ChatterBegin",250,HandleChatterBegin) end
					dialog_step=dialog_step+1
				elseif optionType==CHATTER_START_COMPLETE_QUEST then
					EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_QUEST_COMPLETE_DIALOG, CompleteQuest)
					EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_QUEST_REMOVED, EndQuestDialog)
				elseif optionType==CHATTER_START_TALK then
--					d("START_TALK")
					BUI.CallLater("ChatterBegin",250,HandleChatterBegin)
				elseif optionType==CHATTER_TALK_CHOICE or optionType==CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS then
--					d("TALK_CHOICE")
					BUI.CallLater("CompleteQuest",250,CompleteQuest)
					EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_QUEST_REMOVED, EndQuestDialog)
				end
				SelectChatterOption(1)
			elseif BUI.Vars.InitialDialog then
				if	(optionType==CHATTER_START_BANK and select(2,GetChatterOption(2))~=CHATTER_START_GUILDBANK)
				or	(optionType==CHATTER_START_SHOP and not UndauntedNPCname[name])
				or	(optionType==CHATTER_START_NEW_QUEST_BESTOWAL or optionType==CHATTER_START_COMPLETE_QUEST)
				or	(optionType==CHATTER_GOODBYE)
				or	(optionType==3400 and select(2,GetChatterOption(2))~=3902)
				then SelectChatterOption(1)
--				elseif (optionType==CHATTER_START_TALK and select(2,GetChatterOption(2))==CHATTER_START_SHOP) then SelectChatterOption(2)
				elseif (select(2,GetChatterOption(2))==3902) then SelectChatterOption(2)
				end
			end
		end

		EVENT_MANAGER:RegisterForEvent("BUI_Event",EVENT_CHATTER_BEGIN,HandleChatterBegin)
	end
--	/script local _, name=GetGameCameraInteractableActionInfo() StartChatInput("[\""..name.."\"]=true,")
--	/script StartChatInput(string.sub(GetOfferedQuestInfo(),5,12))
	if BUI.Vars.CovetousCountess or BUI.Vars.DarkBrotherhoodSpree then
		local lastInteractableName
		SecurePostHook(FISHING_MANAGER or INTERACTIVE_WHEEL_MANAGER, "StartInteraction", function() local _, name=GetGameCameraInteractableActionInfo() lastInteractableName=name end)
---		ZO_PreHook(FISHING_MANAGER, "StartInteraction", function() local _, name=GetGameCameraInteractableActionInfo() lastInteractableName=name end)
--		local tipBoard={["Tip Board"]=true,["Brett für Aufträge"]=true,["Tableau des tuyaux"]=true,["Доска объявлений"]=true,}
		local contractBook={["Marked for Death"]=true,}
--		local CovetousDialog={["eemed th"]=true,["e new fa"]=true,["ochgesch"]=true,["s gibt e"]=true,["Voleurs "]=true,["De la bl"]=true,["овые"]=true}
		local nonSpreeDialog={["'d think"]=true,[" Queen h"]=true,["re's a b"]=true,["en Ayren"]=true,["as passi"]=true,["re is a "]=true,["annot ab"]=true,[" Spinner"]=true,["e and Jo"]=true,["g Aerada"]=true,[" don't t"]=true,["re's a t"]=true,["spouse b"]=true,["more Tha"]=true,["ry day I"]=true,[" of the "]=true,["e fool k"]=true,["kwasten "]=true,["ave a cu"]=true,["s one se"]=true,["en-ja is"]=true,["dbeats. "]=true,["ls of Ju"]=true,["re are s"]=true,["ave been"]=true,[" Stone O"]=true,[" cheerin"]=true,[" at peak"]=true,["e been d"]=true,["m positi"]=true,["py hides"]=true,["an't tol"]=true,[" being m"]=true,["oward hi"]=true,["prey has"]=true,["se Dorel"]=true,["advancem"]=true,["t the be"]=true,["se who s"]=true,["ealous b"]=true,["agitator"]=true,["re's an "]=true,["m forced"]=true,[" seeds o"]=true,["eek to g"]=true,["elers ma"]=true,["kin dish"]=true,[" careles"]=true,["lorious "]=true,["rect the"]=true,["eally ca"]=true,["people m"]=true,["lover—fo"]=true,["losed ar"]=true,["re is a "]=true,["rine dut"]=true,["n the Da"]=true,[" losing "]=true,["d slaugh"]=true,[" milk-dr"]=true,[" suspici"]=true,}
		local function OverwritePopulateChatterOption(interaction)
			local PopulateChatterOption=interaction.PopulateChatterOption
			interaction.PopulateChatterOption=function(self, index, fun, txt, type, ...)
				local ZoneId=GetZoneId(GetUnitZoneIndex("player"))
--				if (BUI.Vars.CovetousCountess and tipBoard[lastInteractableName] and ZoneId==821 and not CovetousDialog[string.sub(GetOfferedQuestInfo(),5,12)])
				if (BUI.Vars.DarkBrotherhoodSpree and contractBook[lastInteractableName] and ZoneId==826 and nonSpreeDialog[string.sub(GetOfferedQuestInfo(),5,12)])
				then
					EndInteraction(INTERACTION_QUEST)
					ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, BUI.Loc("AUTOMATION_Quest_Low_Reward"))
					return
				end
				PopulateChatterOption(self, index, fun, txt, type, ...)
--				if tipBoard[lastInteractableName] then lastInteractableName=nil end
			end
		end
		OverwritePopulateChatterOption(GAMEPAD_INTERACTION)
		OverwritePopulateChatterOption(INTERACTION)
	end

	--ContainerHandler
	ContainerHandler_Init(BUI.Vars.ContainerHandler)

	if BUI.Vars.StealthWield or BUI.Vars.LootStolen then
		EVENT_MANAGER:RegisterForEvent("BUI_Event",EVENT_STEALTH_STATE_CHANGED,function(_,unitTag,stealthState)
			if unitTag=='player' then
				if stealthState<2 then
					if BUI.Vars.LootStolen and LootStolen and (not BUI.BladeOfWoe or BUI.BladeOfWoe+2000<GetGameTimeMilliseconds()) then LootStolen=false SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT_STOLEN, "0") end
				elseif stealthState>2 then
					if BUI.Vars.LootStolen and not LootStolen then LootStolen=true SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT_STOLEN, "1") end
					if BUI.Vars.StealthWield and ArePlayerWeaponsSheathed() then
						local action=GetGameCameraInteractableActionInfo()
						if action==nil then TogglePlayerWield() end
					end
				end
			end
		end)
	end

	--Queue auto confirm
	local function SwitchQueue()
		if BUI.Vars.AutoQueue then
			EVENT_MANAGER:RegisterForEvent("BUI_Event_Queue", EVENT_PLAYER_ACTIVATED,function()
				EVENT_MANAGER:RegisterForEvent("BUI_Event_Queue", EVENT_ACTIVITY_FINDER_STATUS_UPDATE, function(_,status)
					if status==ACTIVITY_FINDER_STATUS_READY_CHECK and not IsActiveWorldBattleground() then
						BUI.CallLater("ReadyCheck",1000,AcceptLFGReadyCheckNotification)
					end
				end)
			end)
			EVENT_MANAGER:RegisterForEvent("BUI_Event_Queue", EVENT_PLAYER_DEACTIVATED, function()
				EVENT_MANAGER:UnregisterForEvent("BUI_Event_Queue", EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
			end)
		else
			EVENT_MANAGER:UnregisterForEvent("BUI_Event_Queue", EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
			EVENT_MANAGER:UnregisterForEvent("BUI_Event_Queue", EVENT_PLAYER_ACTIVATED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Event_Queue", EVENT_PLAYER_DEACTIVATED)
		end
	end
	if ZO_SearchingForGroupStatus then
		local but=BUI.UI.Button("BUI_AutoQueue", ZO_SearchingForGroupStatus, {26,26}, {BOTTOMLEFT,TOPLEFT,0,0}, BSTATE_NORMAL)
		BUI.UI.Label("BUI_AutoQueue_L",but,	{174,26},{LEFT,RIGHT,0,0},"ZoFontHeader", {.8,.8,.6,1}, {0,1}, BUI.Loc("AutoConfirm"))
		but:SetNormalTexture(BUI.Vars.AutoQueue and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds")
		but:SetHandler("OnClicked", function()
			BUI.Vars.AutoQueue=not BUI.Vars.AutoQueue
			BUI_AutoQueue:SetNormalTexture(BUI.Vars.AutoQueue and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds")
			SwitchQueue()
			end)
	end
	SwitchQueue()

	CHAT_SYSTEM.maxContainerWidth,CHAT_SYSTEM.maxContainerHeight=GuiRoot:GetDimensions()
end
