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
	CollapseNormalDungeon=false,
	PlayerToPlayer=false,
	BuiltInGlobalCooldown=false,
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

local DailyPledges={
	[1]={	--Maj
		{en="Elden Hollow II",		ru="Элденская расщелина II",	de="Eldengrund II",	fr="Creuset des aînés II"},
		{en="Wayrest Sewers I",		ru="Канализация Вэйреста I",	de="Kanalisation I",	fr="Égouts d'Haltevoie I"},
		{en="Spindleclutch II",		ru="Логово Мертвой Хватки II",	de="Spindeltiefen II",	fr="Tressefuseau II"},
		{en="Banished Cells I",		ru="Темницы изгнанников I",	de="Verbannungszellen I",	fr="Cachot interdit I"},
		{en="Fungal Grotto II",		ru="Грибной грот II",		de="Pilzgrotte II",	fr="Champignonnière II"},
		{en="Spindleclutch I",		ru="Логово Мертвой Хватки I",	de="Spindeltiefen I",	fr="Tressefuseau I"},
		{en="Darkshade Caverns II",	ru="Пещеры Глубокой Тени II",	de="Dunkelschattenkavernen II",		fr="Cavernes d'Ombre-noire II"},
		{en="Elden Hollow I",		ru="Элденская расщелина I",	de="Eldengrund I",	fr="Creuset des aînés I"},
		{en="Wayrest Sewers II",	ru="Канализация Вэйреста II",	de="Kanalisation II",	fr="Égouts d'Haltevoie II"},
		{en="Fungal Grotto I",		ru="Грибной грот I",		de="Pilzgrotte I",	fr="Champignonnière I"},
		{en="Banished Cells II",	ru="Темницы изгнанников II",	de="Verbannungszellen II",	fr="Cachot interdit II"},
		{en="Darkshade Caverns I",	ru="Пещеры Глубокой Тени I",	de="Dunkelschattenkavernen I",		fr="Cavernes d'Ombre-noire I"},
		shift=0
	},
	[2]={	--Glirion
		{en="Volenfell",			ru="Воленфелл"},
		{en="Blessed Crucible I",	ru="Священное Горнило",		de="Gesegnete Feuerprobe",	fr="Creuset béni"},
		{en="Direfrost Keep I",		ru="Крепость Лютых Морозов",	de="Burg Grauenfrost",		fr="Donjon d'Affregivre"},
		{en="Vaults of Madness",	ru="Своды Безумия",		de="Kammern des Wahnsinns",	fr="Chambres de la folie"},
		{en="Crypt of Hearts II",	ru="Крипта Сердец II",		de="Krypta der Herzen II",	fr="Crypte des cœurs II"},
		{en="City of Ash I",		ru="Город Пепла I",		de="Stadt der Asche I",		fr="Cité des cendres I"},
		{en="Tempest Island",		ru="Остров Бурь",			de="Orkaninsel",			fr="Île des Tempêtes"},
		{en="Blackheart Haven",		ru="Гавань Черного Сердца",	de="Schwarzherz-Unterschlupf",fr="Havre de Cœurnoir"},
		{en="Arx Corinium",			ru="Аркс-Кориниум"},
		{en="Selene's Web",			ru="Паутина Селены",		de="Selenes Netz"},
		{en="City of Ash II",		ru="Город Пепла II",		de="Stadt der Asche II",	fr="Cité des cendres II"},
		{en="Crypt of Hearts I",	ru="Крипта Сердец I",		de="Krypta der Herzen I",	fr="Crypte des cœurs I"},
		shift=0
	},
	[3]={	--Urgarlag
		{en="Imperial City Prison",	ru="Тюрьма Имперского города",de="Gefängnis der Kaiserstadt",	fr="Tour d'Or Blanc"},
		{en="Ruins of Mazzatun",	ru="Руины Маззатуна",		de="Ruinen von Mazzatun",	fr="Ruines de Mazzatun"},
		{en="White-Gold Tower",		ru="Башня Белого Золота",	de="Weißgoldturm",		fr="Tour d'Or Blanc"},
		{en="Cradle of Shadows",	ru="Колыбель Теней",		de="Wiege der Schatten",	fr="Berceau des ombres"},
		{en="Bloodroot Forge",		ru="Кузница Кровавого корня",	de="Blutquellschmiede",		fr="Forge de Sangracine"},
		{en="Falkreath Hold",		ru="Владение Фолкрит",		de="Falkenring",			fr="Forteresse d'Épervine"},
		{en="Fang Lair",			ru="Логово Клыка",		de="Krallenhort",			fr="Repaire du croc"},
		{en="Scalecaller Peak",		ru="Пик Воспевательницы Дракона",de="Gipfel der Schuppenruferin",	fr="Pic de la Mandécailles"},
		{en="Moon Hunter Keep",		ru="Крепость Лунного Охотника",de="Mondjägerfeste",		fr="Fort du Chasseur lunaire"},
		{en="March of Sacrifices",	ru="Путь Жертвоприношений",	de="Marsch der Aufopferung",	fr="Procession des Sacrifiés"},
		{en="Depths of Malatar",	ru="Глубины Малатара",		de="Tiefen von Malatar",	fr="Profondeurs de Malatar"},
		{en="Frostvault",			ru="Морозное хранилище",	de="Frostgewölbe",		fr="Arquegivre"},
		{en="Moongrave Fane",		ru="Храм Погребенных Лун",	de="Mondgrab-Tempelstadt",	fr="le reliquaire des Lunes funèbres"},
		{en="Lair of Maarselok",	ru="Логово Марселока",		de="Hort von Maarselok",	fr="Repaire de Maarselok"},
		{en="Icereach",				ru="Ледяной Предел",		de="Eiskap",			fr="Crève-Nève"},
		{en="Unhallowed Grave",		ru="Нечестивая Могила",		de="Unheiliges Grab",		fr="Sépulcre profane"},
		{en="Stone Garden",			ru="Каменный Сад",		de="Steingarten",			fr="Jardin de pierre"},
		{en="Castle Thorn",			ru="Замок Шипов",			de="Kastell Dorn",		fr="Bastion-les-Ronce"},
		{en="Black Drake Villa",	ru="Вилла Черного Змея",	de="Schwarzdrachenvilla",	fr="Villa du Dragon noir"},
		{en="Cauldron",				ru="Котел",				de="Kessel",			fr="Chaudron"},
		{en="Red Petal Bastion",	ru="Оплот Алый Лепесток",	de="Rotblütenbastion",		fr="Bastion du Pétale rouge"},
		{en="Dread Cellar",			ru="Ужасный Подвал",		de="Schreckenskeller",		fr="Cave d'effroi"},
		{en="Coral Aerie",			ru="Коралловое Гнездо",	de="Korallenhorst",	fr="L'Aire de corail"},
		{en="Shipwright's Regret",	ru="Горе Корабела",	de="Gram des Schiffsbauers",	fr="Le Regret du Charpentier"},
		{en="Earthen Root Enclave",	ru="Анклав Земляного Корня",	de="Erdwurz-Enklave",	fr="Enclave des Racines de la terre"},
		{en="Graven Deep",			ru="Могильная Пучина",		de="Kentertiefen",	fr="Profondeurs mortuaires"},
		{en="Bal Sunnar",			ru="Бал-Суннар",	de="Bal Sunnar",	fr="Bal Sunnar"},
		{en="Scrivener's Hall",		ru="Зал Книжников",		de="Halle der Schriftmeister",	fr="Salles du Scribe"},
		shift=7
	},
}

local DungeonIndex={
--Normal
[2]	={id=294},	--Fungal Grotto I
[3]	={id=301},	--Spindleclutch I
[4]	={id=325},	--Banished Cells I
[5]	={id=78},	--Darkshade Caverns I
[6]	={id=79},	--Wayrest Sewers I
[7]	={id=11},	--Elden Hollow I
[8]	={id=272},	--Arx Corinium
[9]	={id=80},	--Crypt of Hearts I
[10]	={id=551},	--City of Ash I
[11]	={id=357},	--Direfrost Keep
[12]	={id=391},	--Volenfell
[13]	={id=81},	--Tempest Island
[14]	={id=393},	--Blessed Crucible
[15]	={id=410},	--Blackheart Haven
[16]	={id=417},	--Selene's Web
[17]	={id=570},	--Vaults of Madness
[18]	={id=1562},	--Fungal Grotto II
[22]	={id=1595},	--Wayrest Sewers II
[288]	={id=1346},	--White-Gold Tower
[289]	={id=1345},	--Imperial City Prison
[293]	={id=1504},	--Ruins of Mazzatun
[295]	={id=1522},	--Cradle of Shadows
[300]	={id=1555},	--Banished Cells II
[303]	={id=1579},	--Elden Hollow II
[308]	={id=1587},	--Darkshade Caverns II
[316]	={id=1571},	--Spindleclutch II
[317]	={id=1616},	--Crypt of Hearts II
[322]	={id=1603},	--City of Ash II
[324]	={id=1690},	--Bloodroot Forge
[368]	={id=1698},	--Falkreath Hold
[420]	={id=1959},	--Fang Lair
[418]	={id=1975},	--Scalecaller Peak
[428]	={id=2162},	--March of Sacrifices
[426]	={id=2152},	--Moon Hunter Keep
[433]	={id=2260},	--Frostvault
[435]	={id=2270},	--Depths of Malatar
[496]	={id=2425},	--Lair of Maarselok
[494]	={id=2415},	--Moongrave Fane
[503]	={id=2539},	--Icereach
[505]	={id=2549},	--Unhallowed Grave
[507]	={id=2694},	--Stone Garden
[509]	={id=2704},	--Castle Thorn
[591]	={id=2831},	--Black Drake Villa
[593]	={id=2841},	--Cauldron
[595]	={id=3016},	--Red Petal Bastion
[597]	={id=3026},	--The Dread Cellar
[599]	={id=3104},	--Coral Aerie
[601]	={id=3114},	--Shipwright's Regret
[608]	={id=3375},	--Earthen Root Enclave
[610]	={id=3394},	--Graven Deep
[613]	={id=3468},	--Bal Sunnar
[615]	={id=3529},	--Scrivener's Hall
--Veteran
[19]	={id=421,	hm=448,	tt=446,	nd=1572},	--Spindleclutch II
[20]	={id=1549,	hm=1554,	tt=1552,	nd=1553},	--Banished Cells I
[21]	={id=464,	hm=467,	tt=465,	nd=1588},	--Darkshade Caverns II
[23]	={id=1573,	hm=1578,	tt=1576,	nd=1577},	--Elden Hollow I
[261]	={id=1610,	hm=1615,	tt=1613,	nd=1614},	--Crypt of Hearts I
[267]	={id=878,	hm=1114,	tt=1108,	nd=1107},	--City of Ash II
[268]	={id=880,	hm=1303,	tt=1128,	nd=1129},	--Imperial City Prison
[287]	={id=1120,	hm=1279,	tt=1275,	nd=1276},	--White-Gold Tower
[294]	={id=1505,	hm=1506,	tt=1507,	nd=1508},	--Ruins of Mazzatun
[296]	={id=1523,	hm=1524,	tt=1525,	nd=1526},	--Cradle of Shadows
[299]	={id=1556,	hm=1561,	tt=1559,	nd=1560},	--Fungal Grotto I
[301]	={id=545,	hm=451,	tt=449,	nd=1564},	--Banished Cells II
[302]	={id=459,	hm=463,	tt=461,	nd=1580},	--Elden Hollow II
[304]	={id=1629,	hm=1634,	tt=1632,	nd=1633},	--Volenfell
[305]	={id=1604,	hm=1609,	tt=1607,	nd=1608},	--Arx Corinium
[306]	={id=1589,	hm=1594,	tt=1592,	nd=1593},	--Wayrest Sewers I
[307]	={id=678,	hm=681,	tt=679,	nd=1596},	--Wayrest Sewers II
[309]	={id=1581,	hm=1586,	tt=1584,	nd=1585},	--Darkshade Caverns I
[310]	={id=1597,	hm=1602,	tt=1600,	nd=1601},	--City of Ash I
[311]	={id=1617,	hm=1622,	tt=1620,	nd=1621},	--Tempest Island
[312]	={id=343,	hm=342,	tt=340,	nd=1563},	--Fungal Grotto II
[313]	={id=1635,	hm=1640,	tt=1638,	nd=1639},	--Selene's Web
[314]	={id=1653,	hm=1658,	tt=1656,	nd=1657},	--Vaults of Madness
[315]	={id=1565,	hm=1570,	tt=1568,	nd=1569},	--Spindleclutch I
[318]	={id=876,	hm=1084,	tt=941,	nd=942},	--Crypt of Hearts II
[319]	={id=1623,	hm=1628,	tt=1626,	nd=1627},	--Direfrost Keep
[320]	={id=1641,	hm=1646,	tt=1644,	nd=1645},	--Blessed Crucible
[321]	={id=1647,	hm=1652,	tt=1650,	nd=1651},	--Blackheart Haven
[325]	={id=1691,	hm=1696,	tt=1694,	nd=1695},	--Bloodroot Forge
[369]	={id=1699,	hm=1704,	tt=1702,	nd=1703},	--Falkreath Hold
[421]	={id=1960,	hm=1965,	tt=1963,	nd=1964},	--Fang Lair
[419]	={id=1976,	hm=1981,	tt=1979,	nd=1980},	--Scalecaller Peak
[429]	={id=2163,	hm=2164,	tt=2165,	nd=2166},	--March of Sacrifices
[427]	={id=2153,	hm=2154,	tt=2155,	nd=2156},	--Moon Hunter Keep
[434]	={id=2261,	hm=2262,	tt=2263,	nd=2264},	--Frostvault
[436]	={id=2271,	hm=2272,	tt=2273,	nd=2274},	--Depths of Malatar
[497]	={id=2426,	hm=2427,	tt=2428,	nd=2429},	--Lair of Maarselok
[495]	={id=2416,	hm=2417,	tt=2418,	nd=2419},	--Moongrave Fane
[504]	={id=2540,	hm=2541,	tt=2542,	nd=2543},	--Icereach
[506]	={id=2550,	hm=2551,	tt=2552,	nd=2553},	--Unhallowed Grave
[508]	={id=2695,	hm=2755,	tt=2697,	nd=2698},	--Stone Garden
[510]	={id=2705,	hm=2706,	tt=2707,	nd=2708},	--Castle Thorn
[592]	={id=2832,	hm=2833,	tt=2834,	nd=2835},	--Black Drake Villa
[594]	={id=2842,	hm=2843,	tt=2844,	nd=2845},	--Cauldron
[596]	={id=3017,	hm=3018,	tt=3019,	nd=3020},	--Red Petal Bastion
[598]	={id=3027,	hm=3028,	tt=3029,	nd=3030},	--The Dread Cellar
[600]	={id=3105,	hm=3153,	tt=3107,	nd=3108},	--Coral Aerie
[602]	={id=3115,	hm=3154,	tt=3117,	nd=3118},	--Shipwright's Regret
[609]	={id=3376,	hm=3377,	tt=3378,	nd=3379},	--Earthen Root Enclave
[611]	={id=3395,	hm=3396,	tt=3397,	nd=3398},	--Graven Deep
[614]	={id=3469,	hm=3470,	tt=3471,	nd=3472},	--Bal Sunnar
[616]	={id=3530,	hm=3531,	tt=3532,	nd=3533},	--Scrivener's Hall
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
			local text=ContainerHandlerRunning and "Stop (left: " or GetString(Type==ITEMTYPE_FISH and SI_KEYBIND_STRIP_FILLET_FISH or SI_KEYBIND_STRIP_OPEN_CONTAINERS).." ("
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
			local text=string.format("%s",name:gsub(".*:%s*",""):gsub(" "," "):gsub("%s+"," "):lower())
			if BUI.language~="ru" and BUI.language~="fr" then
				local number=string.match(text,"%sii$")
				text=string.match(text,"[^%s]+")..(number or "")
			end
			Pledges[text]=stepType~=QUEST_STEP_TYPE_AND
			if stepType==QUEST_STEP_TYPE_AND then haveQuest=true end
--			if BUI.Vars.DeveloperMode then d(zo_strformat("QuestName: \"<<1>>\" Dungeon: \"<<2>>\" Step: <<3>>",name,text,stepType)) end
		end
	end
	return Pledges,haveQuest
end

local function UndauntedPledges()
	local Pledges,haveQuest={},false
	local offset=1517479200
	if GetCVar("LastRealm")~="NA Megaserver" then offset=1517454000 end	
	local day=math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(),offset)/86400)

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
					if obj then
						--Achievement
						local id=obj.node.data.id
						if DungeonIndex[id] then
							local text=IsAchievementComplete(DungeonIndex[id].id) and "|t16:16:/esoui/art/cadwell/check.dds|t" or ""
							text=text..((DungeonIndex[id].hm and IsAchievementComplete(DungeonIndex[id].hm)) and "|t20:20:/esoui/art/unitframes/target_veteranrank_icon.dds|t" or "")
							text=text..((DungeonIndex[id].tt and IsAchievementComplete(DungeonIndex[id].tt)) and "|t20:20:/esoui/art/ava/overview_icon_underdog_score.dds|t" or "")
							text=text..((DungeonIndex[id].nd and IsAchievementComplete(DungeonIndex[id].nd)) and "|t20:20:/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds|t" or "")
							local info=BUI.UI.Label("BUI_DungeonInfo"..c..i, obj, {80,20}, {LEFT,LEFT,465,0}, "ZoFontGameLarge", nil, {0,1}, text)
							--Quest
							local orig=obj.text:GetText()
							local text=orig:lower() text=text:gsub("the ",""):gsub(" "," "):gsub("der ",""):gsub("die ",""):gsub("das ","")
							if c==3 then
								local _start,_end=string.find(text,"s|t")
								if _start then text=string.sub(text,_end+2) end
							end
							if BUI.language~="ru" and BUI.language~="fr" then
								local number=string.match(text,"%sii$")
								text=string.match(text,"[^%s]+")..(number or "")
							elseif RuESO_init then
								text=string.match(text,"[^(]+"):gsub("%s$","")
							end
--							d(text)
							--Daily pledges
							local daily=""
							for npc=1,3 do
								local dp=DailyPledges[npc]
								local n=1+(day+dp.shift)%#dp
								local name=dp[n][BUI.language] or dp[n].en
								if name then
									name=name:lower()
									if BUI.language~="ru" and BUI.language~="fr" then
										local number=string.match(name,"%sii$")
										name=string.match(name,"[^%s]+")..(number or "")
									elseif RuESO_init then
										name=string.match(name,"[^(]+"):gsub("%s$","")
									end
									if text==name then daily=" ("..BUI.Loc("UndauntedDaily")..")" obj.text:SetText(orig.." |c3388EE"..daily.."|r") end
								end
							end
							--Current pledges
							local completed=Pledges[text]
							obj.pledge=completed==false
							if completed==false then
								obj.text:SetText(orig.." |c3388EE- "..BUI.Loc("UndauntedQuest")..daily.."|r")
							elseif completed==true then
								obj.text:SetText(orig.." |c33EE33- "..BUI.Loc("UndauntedDone")..daily.."|r")
							end
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
						--Achievement
						local id=obj.node.data.id
						if DungeonIndex[id] then
							--Daily pledges
							local daily=""
							for npc=1,3 do
								local dp=DailyPledges[npc]
								local n=1+(day+dp.shift)%#dp
								local name=dp[n][BUI.language] or dp[n].en
								if name then
									name=name:lower()
									if BUI.language~="ru" and BUI.language~="fr" then
										local number=string.match(name,"%sii$")
										name=string.match(name,"[^%s]+")..(number or "")
									elseif RuESO_init then
										name=string.match(name,"[^(]+"):gsub("%s$","")
									end
									if text==name then daily=" ("..BUI.Loc("UndauntedDaily")..")" control:AddLine(orig.." |c3388EE"..daily.."|r", "ZoFontWinH4") end
								end
							end
							--Current pledges
							local completed=Pledges[text]
							obj.pledge=completed==false
							if completed==false then
								control:AddLine(orig.." |c3388EE- "..BUI.Loc("UndauntedQuest")..daily.."|r", "ZoFontWinH4")
							elseif completed==true then
								control:AddLine(orig.." |c33EE33- "..BUI.Loc("UndauntedDone")..daily.."|r", "ZoFontWinH4")
							end
						end
					end
				end
			end
			local parent=ZO_DungeonFinder_Keyboard	--ZO_DungeonFinder_KeyboardActionButtonContainer
			if parent then
--				local w=parent:GetWidth()
				if isVeteran==c then
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
	d("Daily pledges:")
	for npc=1,3 do
		local dp=DailyPledges[npc]
		local n=1+(day+dp.shift)%#dp
		local pledge=dp[n][BUI.language] or dp[n].en

		local quest=""
		if pledge then
			local text=pledge:lower()
			if BUI.language~="ru" and BUI.language~="fr" then
				local number=string.match(text,"%sii$")
				text=string.match(text,"[^%s]+")..(number or "")
			elseif RuESO_init then
				text=string.match(text,"[^(]+"):gsub("%s$","")
			end
			if Pledges[text]==false then quest=" |c3388EE- "..BUI.Loc("UndauntedQuest").."|r" end
--			d(text)
		end

		d("["..npc.."] "..tostring(pledge)..quest)
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
		{type="dropdown",	param="HousePins",		warning="ReloadUiWarn3", choices={"All","Owned","Unowned","Disabled"}},

		{type="header",	param="ImprovementsHeader"},
		{type="checkbox",	param="UndauntedPledges",	warning=true},
		{type="checkbox",	param="CollapseNormalDungeon",	warning=true, disabled=function() return not BUI.Vars.UndauntedPledges end},
		{type="checkbox",	param="PlayerToPlayer",		warning=true},
		{type="checkbox",   param="BuiltInGlobalCooldown", warning=true},
		{type="button",	name="Reload UI",func=function() SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8,"Reloading UI") BUI.CallLater("ReloadUI",1000,ReloadUI) end},
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

	if BUI.Vars.UndauntedPledges then UndauntedPledges() end

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

	if BUI.Vars.DeleteMail then
		MAIL_INBOX.Delete=function(self)
			if self.mailId then
				if self:IsMailDeletable() then
					local numAttachments,attachedMoney=GetMailAttachmentInfo(self.mailId)
					if numAttachments>0 and attachedMoney>0 then
						ZO_Dialogs_ShowDialog("DELETE_MAIL_ATTACHMENTS_AND_MONEY",self.mailId)
					elseif numAttachments>0 then
						ZO_Dialogs_ShowDialog("DELETE_MAIL_ATTACHMENTS",self.mailId)
					elseif attachedMoney>0 then
						ZO_Dialogs_ShowDialog("DELETE_MAIL_MONEY",self.mailId)
					else
						if BUI.Vars.DeleteMail then
							self:ConfirmDelete(self.mailId) 
						else
							ZO_Dialogs_ShowDialog("DELETE_MAIL",{callback=function(...) self:ConfirmDelete(...) end,mailId=self.mailId})
						end
					end
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
	       	d("Setting Global Cooldown") 
	       	ZO_ActionButtons_ToggleShowGlobalCooldown()
	    end		
	end

	if BUI.Vars.GroupLeave then
		GROUP_LIST["keybindStripDescriptor"][3].callback=function() GroupLeave() end
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
					ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, "Quest with low reward is skipped")
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
