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

BUI_ActivityFinder = {}

function BUI_ActivityFinder.Initialize()
  -- Unregister Callback
	CALLBACK_MANAGER:UnregisterCallback("BUI_Ready", BUI_ActivityFinder.Initialize)

	BUI_ActivityFinder.SettingsInit()

  -- Undaunted Pledges
	if BUI.Vars.UndauntedPledges or BUI.Vars.DungeonQuests then UndauntedPledges() end

  -- Register /daily command
	if BUI.Vars.UndauntedPledges then SLASH_COMMANDS["/daily"]=BUI.DailyPledges end

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

end

CALLBACK_MANAGER:RegisterCallback("BUI_Ready", BUI_ActivityFinder.Initialize)