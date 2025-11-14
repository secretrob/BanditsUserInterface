local ZOShowMapHeader

local function UpdateDimensions()
	ZO_WorldMap:SetDimensions(BUI.MiniMap.size,BUI.MiniMap.size)
	ZO_WorldMapScroll:SetDimensions(BUI.MiniMap.size-8,BUI.MiniMap.size-8)
end

local function UpdatePosition()
	ZO_WorldMap:ClearAnchors()
	ZO_WorldMap:SetAnchor(BUI.Vars.BUI_Minimap[1],nil,BUI.Vars.BUI_Minimap[2],BUI.Vars.BUI_Minimap[3],BUI.Vars.BUI_Minimap[4])
end

local function ZoomUpdate(mounted)
	mounted=mounted or IsMounted()
	local zoom
	local ratio=mounted and BUI.Vars.ZoomMountRatio/100 or 1

	if GetMapType()==MAPTYPE_SUBZONE then
		local zonename=string.match(GetMapTileTexture(), "%w+/%w+/%w+/(%w+)")
		if zonename=="Imperialsewers" then
			BUI.MiniMap.Subzone=false zoom=BUI.Vars.ZoomImperialsewer
		elseif zonename=="imperialcity" then
			BUI.MiniMap.Subzone=false zoom=BUI.Vars.ZoomImperialCity
		else
			BUI.MiniMap.Subzone=true zoom=BUI.Vars.ZoomSubZone
		end
	else
		BUI.MiniMap.Subzone=false
		local content=GetMapContentType()
		if content==MAP_CONTENT_DUNGEON then
			zoom=BUI.Vars.ZoomDungeon
		elseif content==MAP_CONTENT_AVA then
			zoom=BUI.Vars.ZoomCyrodiil
		else
			zoom=BUI.Vars.ZoomZone
		end
	end

	BUI.MiniMap.MapPanAndZoom:SetCurrentNormalizedZoomInternal(zoom/100*ratio)
	local pin=BUI.MiniMap.PinManager:GetPlayerPin() BUI.MiniMap.MapPanAndZoom:PanToPin(pin, true)
end
--	/script ZO_WorldMap_GetPanAndZoom():SetCurrentNormalizedZoomInternal(1)
--	/script local pin=ZO_WorldMap_GetPinManager():GetPlayerPin() ZO_WorldMap_GetPanAndZoom():PanToPin(pin, true)
local function OnMount(eventCode,mounted)
	if not BUI.init.MiniMap or BUI.MiniMap.ZoomUpdatind then return end
	BUI.MiniMap.ZoomUpdate(mounted)
end

local function ReInit()
	local function OnHUD(oldState, newState)
		if BUI.moveDefault or BUI.move then return end
		if newState==SCENE_HIDDEN then BUI.CallLater("MiniMap",20,function()
				if not BUI.MiniMap.BUI_MINIMAP_SCENE_NAMES[SCENE_MANAGER:GetCurrentSceneName()] then
					if BUI.init.MiniMap then ZO_WorldMap:SetHidden(true) _G["ZO_WorldMapMapFrame"]:SetHidden(true) end
				end
			end)
		elseif newState==SCENE_SHOWING then if BUI.init.MiniMap then ZO_WorldMap:SetHidden(false) _G["ZO_WorldMapMapFrame"]:SetHidden(false) else BUI.MiniMap.Show() end end
	end

	local function WorldSceneChanged(oldState, newState)
		if newState==SCENE_SHOWING and BUI.init.MiniMap then BUI.MiniMap.MapSceneIsShowing=true BUI.MiniMap.Restore()
--		elseif newState==SCENE_SHOWN then ZO_WorldMap_SetCustomZoomLevels(1.2,1.2) BUI.CallLater("MiniMap",500,ZO_WorldMap_ClearCustomZoomLevels)
--		elseif newState==SCENE_HIDING then ZO_MapPin.UpdateSize=function()end
		elseif newState==SCENE_HIDDEN then BUI.CallLater("MiniMap",100,function() BUI.MiniMap.MapSceneIsShowing=false BUI.MiniMap.Show() end) end
	end

	EVENT_MANAGER:RegisterForEvent("BUI_MiniMap_Event", EVENT_GAMEPAD_PREFERRED_MODE_CHANGED,	function(_,gamepadPreferred)
		BUI.MiniMap.ReInit()
	end)

	BUI.MiniMap.PinColors()
	if not BUI.Vars.MiniMap or BUI.GamepadMode then
		if BUI.init.MiniMap then
			BUI.MiniMap.Restore()
			ZO_WorldMap:SetHidden(true)
			_G["ZO_WorldMapMapFrame"]:SetHidden(true)
			if not BUI.Vars.ZO_FocusedQuestTrackerPanel then
				ZO_FocusedQuestTrackerPanel:ClearAnchors() ZO_FocusedQuestTrackerPanel:SetAnchor(TOPRIGHT, GuiRoot, TOPRIGHT, 0, 60)
			end
--			EVENT_MANAGER:UnregisterForEvent("BUI_Minimap", EVENT_RETICLE_HIDDEN_UPDATE)
			EVENT_MANAGER:UnregisterForEvent("BUI_ZoneChange", EVENT_PLAYER_ACTIVATED)
			EVENT_MANAGER:UnregisterForEvent("BUI_ZoneChange", EVENT_ZONE_CHANGED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Minimap", EVENT_SCREEN_RESIZED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Minimap", EVENT_MOUNTED_STATE_CHANGED)
			for scene in pairs(BUI.MiniMap.BUI_MINIMAP_SCENE_NAMES) do SCENE_MANAGER:GetScene(scene):UnregisterCallback("StateChange") end
			CALLBACK_MANAGER:UnregisterCallback("OnWorldMapChanged")
			WORLD_MAP_SCENE:UnregisterCallback("StateChange")
		end
		return
	end
--[[	Reticle distance
	if BUI.Vars.DeveloperMode then
		local fs	=17
		BUI.UI.Label("BUI_ReticleDistance",	ZO_ReticleContainerReticle,	{fs*3.5,fs},	{TOP,BOTTOM,0,0},	BUI.UI.Font("esobold",fs), nil, {1,0}, "", false)
	end
--]]
	--Set variables
	BUI.MiniMap.LastX1,BUI.MiniMap.LastY1=GetMapPlayerPosition('player')
	BUI.MiniMap.LastX2=BUI.MiniMap.LastX1
	BUI.MiniMap.LastY2=BUI.MiniMap.LastY1
	BUI.MiniMap.size=BUI.Vars.MiniMapDimensions
	BUI.MiniMap.pinscale=BUI.Vars.PinScale/100

	--QuestTracker
	if not BUI.Vars.ZO_FocusedQuestTrackerPanel then
		ZO_FocusedQuestTrackerPanel:ClearAnchors() ZO_FocusedQuestTrackerPanel:SetAnchor(TOPRIGHT, GuiRoot, TOPRIGHT, 0, BUI.MiniMap.size+20)
	end

	EVENT_MANAGER:RegisterForEvent("BUI_ZoneChange", EVENT_PLAYER_ACTIVATED,	function() BUI.MiniMap.ZoneChanged(1000) end)
	EVENT_MANAGER:RegisterForEvent("BUI_ZoneChange", EVENT_ZONE_CHANGED,		function() BUI.MiniMap.ZoneChanged() end)
	EVENT_MANAGER:RegisterForEvent("BUI_Minimap", EVENT_SCREEN_RESIZED,		BUI.MiniMap.Show)
	EVENT_MANAGER:RegisterForEvent("BUI_Minimap", EVENT_MOUNTED_STATE_CHANGED,	BUI.MiniMap.OnMount)

	for scene in pairs(BUI.MiniMap.BUI_MINIMAP_SCENE_NAMES) do SCENE_MANAGER:GetScene(scene):RegisterCallback("StateChange", OnHUD) end

	CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged",	function(navigateIn) BUI.MiniMap.Show() end)

	WORLD_MAP_SCENE:RegisterCallback("StateChange", WorldSceneChanged)
--[[
	GAMEPAD_WORLD_MAP_SCENE:RegisterCallback("StateChange", function(oldState, newState)
		if newState==SCENE_SHOWING and BUI.init.MiniMap then BUI.MiniMap.MapSceneIsShowing=true BUI.MiniMap.Restore()
		elseif newState==SCENE_HIDDEN then BUI.MiniMap.MapSceneIsShowing=false BUI.MiniMap.Show() end
	end)
--]]
	--Controls
	local ctrl	=BUI.UI.Control("BUI_Minimap",	BanditsUI,	{BUI.MiniMap.size, BUI.MiniMap.size},	BUI.Vars.BUI_Minimap,	false)
	ctrl.backdrop=BUI.UI.Backdrop("BUI_Minimap_B",	ctrl,		"inherit",		{CENTER,CENTER,0,0},	{0,0,0,0.4}, {0,0,0,1}, nil, true)
	ctrl.label	=BUI.UI.Label("BUI_Minimap_L",	ctrl.backdrop,		"inherit",		{CENTER,CENTER,0,0},	BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("MiniMap_Label"))

	ctrl:SetMovable(true)
	ctrl:SetMouseEnabled(false)
	ctrl:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(BUI_Minimap) end)	
	--Map Title
	ZO_WorldMapTitle:SetFont(BUI.UI.Font("standard", 20, "shadow"))
	ZO_WorldMapTitle:ClearAnchors()
	ZO_WorldMapTitle:SetAnchor(TOP,ZO_WorldMap,TOP,0,0)
	ZO_WorldMapTitle:SetHidden(not BUI.Vars.MiniMapTitle)
	BUI.MiniMap.Show()
end

local function PinColors()
	ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_GROUP_LEADER].tint=ZO_ColorDef:New(unpack(BUI.Vars.PinColor[MAP_PIN_TYPE_GROUP_LEADER]))
	ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_GROUP].tint=ZO_ColorDef:New(unpack(BUI.Vars.PinColor[MAP_PIN_TYPE_GROUP]))
	ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE].tint=ZO_ColorDef:New(unpack(BUI.Vars.PinColor[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE]))
	ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_POI_COMPLETE].tint=ZO_ColorDef:New(unpack(BUI.Vars.PinColor[MAP_PIN_TYPE_POI_COMPLETE]))
	ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING].tint=ZO_ColorDef:New(unpack(BUI.Vars.PinColor[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING]))
	ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_ASSISTED_QUEST_REPEATABLE_ENDING].tint=ZO_ColorDef:New(unpack(BUI.Vars.PinColor[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING]))
	ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_TRACKED_QUEST_ENDING].tint=ZO_ColorDef:New(unpack(BUI.Vars.PinColor[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING]))
	ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_TRACKED_QUEST_REPEATABLE_ENDING].tint=ZO_ColorDef:New(unpack(BUI.Vars.PinColor[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING]))
	ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING].tint=ZO_ColorDef:New(unpack(BUI.Vars.PinColor[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING]))
end

local function Show()
	if not BUI.Vars.MiniMap or BUI.MiniMap.MapSceneIsShowing or BUI.GamepadMode then return end
	EVENT_MANAGER:UnregisterForUpdate("BUI_Minimap")
	BUI.MiniMap.ResizePins(true)
	if BUI.inMenu then ZO_WorldMap_UpdateMap() end
	BUI.MiniMap.UpdatePosition()
--	ZO_WorldMap:SetMouseEnabled(false)
	ZO_WorldMap:SetHidden(not (SCENE_MANAGER:IsShowingBaseScene() or BUI.inMenu))
	_G["ZO_WorldMapMapFrame"]:SetHidden(not (SCENE_MANAGER:IsShowingBaseScene() or BUI.inMenu))
	BUI.init.MiniMap=true
	BUI.MiniMap.ZoneChanged()	
	BUI.CallLater("MiniMap_Shown",100,function() EVENT_MANAGER:RegisterForUpdate("BUI_Minimap", 500, BUI.MiniMap.Update) end)
	CALLBACK_MANAGER:FireCallbacks("BUI_MiniMap_Shown", true)
	local EMPTY_HEADER_INFO =
	{
		nameText = "",
		descriptionText = "",
		owner = "BUI",
		showProgressBar = false,
	}
	WORLD_MAP_MANAGER:SetMapHeader(EMPTY_HEADER_INFO)	
end

local function Restore()	
	EVENT_MANAGER:UnregisterForUpdate("BUI_Minimap")
--	if BUI.API<=10024 then
	BUI.MiniMap.ResizePins(false)
	BUI.MiniMap.MapPanAndZoom:SetCurrentNormalizedZoomInternal(BUI.Vars.ZoomGlobal/100)	
	ZO_WorldMap_UpdateMap()
	BUI.init.MiniMap=false
	CALLBACK_MANAGER:FireCallbacks("BUI_MiniMap_Shown", false)
	if BUI.g_mapPinManager and (BUI.Vars.StatsShareDPS or BUI.Vars.StatShare) then
		BUI.g_mapPinManager:RemovePins("pings", MAP_PIN_TYPE_PING)
	end
	local CLEAR_HEADER_INFO =
	{
		nameText = "",
		descriptionText = "",
		owner = nil,
		showProgressBar = false,
	}
	WORLD_MAP_MANAGER:SetMapHeader(CLEAR_HEADER_INFO)	
end

local function ResizePins(resize)
	local scale=(resize) and BUI.MiniMap.pinscale or 1
	for pin=9,210 do
		if ZO_MapPin.PIN_DATA[pin] then
			local size=ZO_MapPin.PIN_DATA[pin].size
			local origsize=ZO_MapPin.PIN_DATA[pin].origsize or size or 40
			ZO_MapPin.PIN_DATA[pin].origsize=origsize
			ZO_MapPin.PIN_DATA[pin].size=origsize*scale
		end
	end
end

local function Map_Toggle() -- Unreferenced Function
	local _visible=not ZO_WorldMap:IsHidden()
	ZO_WorldMap:SetHidden(_visible)
	_G["ZO_WorldMapMapFrame"]:SetHidden(_visible)
	if not _visible then
--		ZO_WorldMap_SetCustomZoomLevels(2.5,2.5)
		ZO_WorldMap_JumpToPlayer()
	end
end

local function Update()
	if BUI.inCombat or not BUI.init.MiniMap then return end
	local x,y=GetMapPlayerPosition('player')
	local delta=math.floor(math.abs((BUI.MiniMap.LastX1-x)^2+(BUI.MiniMap.LastY1-y)^2)*100000)
	if delta>=(BUI.MiniMap.Subzone and 100 or 9) then
		BUI.MiniMap.LastX1=x
		BUI.MiniMap.LastY1=y
		if delta<1000 then
--			ZO_WorldMap_PanToPlayer()
			local pin=BUI.MiniMap.PinManager:GetPlayerPin() BUI.MiniMap.MapPanAndZoom:PanToPin(pin, true)
			CALLBACK_MANAGER:FireCallbacks("BUI_MiniMap_Update", true)
		end
	end

--[[
	if BUI.Vars.DeveloperMode and MapPinsCurrentLocationChests then
		delta=math.floor(math.abs((BUI.MiniMap.LastX2-x)^2+(BUI.MiniMap.LastY2-y)^2)*1000000)
		if delta>=(BUI.MiniMap.Subzone and 10 or 1) then
			BUI.MiniMap.LastX2=x
			BUI.MiniMap.LastY2=y
			local mindist=100
			local nearest
			for i,chData in pairs(MapPinsCurrentLocationChests) do
				for _,chest in pairs(chData) do
					local dist=math.sqrt((x-chest[1])^2+(y-chest[2])^2)*10000
					if dist<mindist then mindist=dist nearest=chest end
				end
			end
			if mindist<100 then
				mindist=math.floor(mindist)
--				d("Distance: "..mindist)
				BUI_ReticleDistance:SetText(mindist)
			else
				BUI_ReticleDistance:SetText("")
			end
		end
	end
--]]
end

local function ZoneChanged(delay)
	if not BUI.init.MiniMap then return end
	BUI.MiniMap.UpdateDimensions()

	if BUI.MiniMap.ZoomUpdatind then return end
	BUI.MiniMap.ZoomUpdatind=true
	BUI.CallLater("MiniMap_ZoomUpdate",delay and delay or 0,function() BUI.MiniMap.ZoomUpdate() BUI.MiniMap.ZoomUpdatind=false end)
end

local function Settings_Init()
	local MenuOptions={
		--	type="header",name="Minimap",advanced=true
		--Enable Minimap
		{	type		="checkbox",
			name		="Minimap",
			getFunc	=function() return BUI.Vars.MiniMap end,
			setFunc	=function(value) BUI.Vars.MiniMap=value BUI.MiniMap.ReInit() end,
		},
		--Minimap Size
		{	type		="slider",
			name		="MiniMapDimensions",
			min		=200,
			max		=500,
			step		=20,
			getFunc	=function() return BUI.Vars.MiniMapDimensions end,
			setFunc	=function(value) BUI.Vars.MiniMapDimensions=value BUI.MiniMap.ReInit() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
		--Minimap title
		{	type		="checkbox",
			name		="MinimapTitle",
			getFunc	=function() return BUI.Vars.MiniMapTitle end,
			setFunc	=function(value) BUI.Vars.MiniMapTitle=value BUI.MiniMap.ReInit() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
		--Minimap PinScale
		{	type		="slider",
			name		="PinScale",
			min		=50,
			max		=100,
			step		=2,
			getFunc	=function() return BUI.Vars.PinScale end,
			setFunc	=function(value) BUI.Vars.PinScale=value BUI.MiniMap.ReInit() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
		{	type		="header",
			name		="ZoomHeader",
		},
		{	type		="slider",
			name		="ZoomZone",
			min		=0,
			max		=100,
			step		=10,
			getFunc	=function() return BUI.Vars.ZoomZone end,
			setFunc	=function(value) BUI.Vars.ZoomZone=value BUI.MiniMap.Show() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
		{	type		="slider",
			name		="ZoomSubZone",
			min		=0,
			max		=100,
			step		=10,
			getFunc	=function() return BUI.Vars.ZoomSubZone end,
			setFunc	=function(value) BUI.Vars.ZoomSubZone=value BUI.MiniMap.Show() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
		{	type		="slider",
			name		="ZoomDungeon",
			min		=0,
			max		=100,
			step		=10,
			getFunc	=function() return BUI.Vars.ZoomDungeon end,
			setFunc	=function(value) BUI.Vars.ZoomDungeon=value BUI.MiniMap.Show() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
		{	type		="slider",
			name		="ZoomCyrodiil",
			min		=0,
			max		=100,
			step		=10,
			getFunc	=function() return BUI.Vars.ZoomCyrodiil end,
			setFunc	=function(value) BUI.Vars.ZoomCyrodiil=value BUI.MiniMap.Show() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
		{	type		="slider",
			name		="ZoomImperialsewer",
			min		=0,
			max		=100,
			step		=10,
			getFunc	=function() return BUI.Vars.ZoomImperialsewer end,
			setFunc	=function(value) BUI.Vars.ZoomImperialsewer=value BUI.MiniMap.Show() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
		{	type		="slider",
			name		="ZoomImperialCity",
			min		=0,
			max		=100,
			step		=10,
			getFunc	=function() return BUI.Vars.ZoomImperialCity end,
			setFunc	=function(value) BUI.Vars.ZoomImperialCity=value BUI.MiniMap.Show() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
		{	type		="slider",
			name		="ZoomMountRatio",
			min		=50,
			max		=100,
			step		=10,
			getFunc	=function() return BUI.Vars.ZoomMountRatio end,
			setFunc	=function(value) BUI.Vars.ZoomMountRatio=value BUI.MiniMap.Show() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
		{	type		="slider",
			name		="ZoomGlobal",
			min		=0,
			max		=100,
			step		=10,
			getFunc	=function() return BUI.Vars.ZoomGlobal end,
			setFunc	=function(value) BUI.Vars.ZoomGlobal=value BUI.MiniMap.Show() end,
			disabled	=function() return not BUI.Vars.MiniMap end,
		},
	--[[
		{--Reset
			type		="button",
			name		="MinimapReset",
			func		=function() BUI.Menu.Reset("Minimap") end,
		}
	--]]
	}

	local PinTypes={
	--	[MAP_PIN_TYPE_PLAYER]={name="Player",icon="/EsoUI/Art/MapPins/UI-WorldMapPlayerPip.dds"},
		[MAP_PIN_TYPE_GROUP_LEADER]={name="Group leader",icon="/EsoUI/Art/Compass/groupLeader.dds"},
		[MAP_PIN_TYPE_GROUP]={name="Group member",icon="/EsoUI/Art/MapPins/UI-WorldMapGroupPip.dds"},
		[MAP_PIN_TYPE_POI_COMPLETE]={name="POI complete",icon="/esoui/art/icons/poi/poi_areaofinterest_complete.dds"},
		[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE]={name="Wayshrine",icon="/esoui/art/icons/poi/poi_wayshrine_complete.dds"},
		[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING]={name="Quest complete",icon="/esoui/art/compass/quest_icon_assisted.dds"},
	--	[MAP_PIN_TYPE_VENDOR]={name="Vandor",icon="/esoui/art/icons/mapkey/mapkey_vendor.dds"},
	}

	do	--Pin colors
		table.insert(MenuOptions,{type="header",name="PinColorsHeader"})
		for pin,data in pairs(PinTypes) do
			table.insert(MenuOptions,
			{	type		="colorpicker",
				name		=zo_iconFormat(data.icon,32,32).." "..data.name,
				getFunc	=function() return unpack(BUI.Vars.PinColor[pin]) end,
				setFunc	=function(r,g,b,a) BUI.Vars.PinColor[pin]={r,g,b,a} BUI.MiniMap.PinColors() BUI.MiniMap.Show() end,
			})
		end
		table.insert(MenuOptions,
			{--Reset
			type		="button",
			name		="MinimapReset",
			func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("MinimapResetDesc"),func=function()BUI.Menu.Reset("Minimap")end})end,
		})
	end
	BUI.Menu.RegisterPanel("BUI_MenuMinimap",{
			type="panel",
			name="9.  |t32:32:/esoui/art/icons/achievements_indexicon_exploration_up.dds|t"..BUI.Loc("MinimapHeader"),
			})
	BUI.Menu.RegisterOptions("BUI_MenuMinimap", MenuOptions)
	MenuHandlers={
		["OnEffectivelyShown"]=function() BUI.inMenu=true BUI.MiniMap.Show() end,
		["OnEffectivelyHidden"]=function() BUI.inMenu=false end,
	}
	for event,handler in pairs(MenuHandlers) do _G["BUI_MenuMinimap"]:SetHandler(event, handler) end
end

local function Initialize()
	ZOShowMapHeader = ZO_WorldMapManager.TryShowSpectacleMapHeader
	BUI.MiniMap.Settings_Init()
	BUI.MiniMap.ReInit()
end

-- Setup MiniMap
BUI.MiniMap={}
BUI.MiniMap.LastX1=0
BUI.MiniMap.LastY1=0
BUI.MiniMap.LastX2=0
BUI.MiniMap.LastY2=0
BUI.MiniMap.size=250
BUI.MiniMap.pinscale=.75
BUI.MiniMap.Subzone=false
BUI.MiniMap.ZoomUpdatind=false
BUI.MiniMap.MapSceneIsShowing=false
BUI.MiniMap.MapPanAndZoom=ZO_WorldMap_GetPanAndZoom()
BUI.MiniMap.PinManager=ZO_WorldMap_GetPinManager()
BUI.MiniMap.BUI_MINIMAP_SCENE_NAMES={["hudui"]=true,["hud"]=true,}

-- Setup Defaults
BUI.MiniMap.Defaults={}
BUI.MiniMap.Defaults.MiniMap=true
BUI.MiniMap.Defaults.MiniMapDimensions=250
BUI.MiniMap.Defaults.MiniMapTitle=true
BUI.MiniMap.Defaults.PinScale=75
BUI.MiniMap.Defaults.BUI_Minimap={TOPRIGHT,TOPRIGHT,0,0}
BUI.MiniMap.Defaults.ZoomZone=60
BUI.MiniMap.Defaults.ZoomSubZone=30
BUI.MiniMap.Defaults.ZoomDungeon=60
BUI.MiniMap.Defaults.ZoomCyrodiil=45
BUI.MiniMap.Defaults.ZoomImperialsewer=60
BUI.MiniMap.Defaults.ZoomImperialCity=80
BUI.MiniMap.Defaults.ZoomMountRatio=70
BUI.MiniMap.Defaults.ZoomGlobal=3
BUI.MiniMap.Defaults.PinColor={}
-- BUI.MiniMap.Defaults.PinColor[MAP_PIN_TYPE_PLAYER]={1,1,1,1}
BUI.MiniMap.Defaults.PinColor[MAP_PIN_TYPE_GROUP_LEADER]={1,1,0,1}
BUI.MiniMap.Defaults.PinColor[MAP_PIN_TYPE_GROUP]={1,1,1,1}
BUI.MiniMap.Defaults.PinColor[MAP_PIN_TYPE_POI_COMPLETE]={1,1,1,1}
-- BUI.MiniMap.Defaults.PinColor[MAP_PIN_TYPE_VENDOR]={1,1,1,1}
BUI.MiniMap.Defaults.PinColor[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE]={1,1,1,1}
BUI.MiniMap.Defaults.PinColor[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING]={1,1,1,1}

BUI:JoinTables(BUI.Defaults,BUI.MiniMap.Defaults)

-- Register Functions
BUI.MiniMap.ZoneChanged = ZoneChanged
BUI.MiniMap.Update = Update
BUI.MiniMap.Map_Toggle = Map_Toggle -- Unreferenced Function
BUI.MiniMap.ResizePins = ResizePins
BUI.MiniMap.Restore = Restore
BUI.MiniMap.Show = Show
BUI.MiniMap.PinColors = PinColors
BUI.MiniMap.Initialize = Initialize
BUI.MiniMap.UpdateDimensions = UpdateDimensions
BUI.MiniMap.UpdatePosition = UpdatePosition
BUI.MiniMap.ZoomUpdate = ZoomUpdate
BUI.MiniMap.OnMount = OnMount
BUI.MiniMap.Settings_Init = Settings_Init
BUI.MiniMap.ReInit = ReInit
BUI.MiniMap.HideHeader = HideHeader