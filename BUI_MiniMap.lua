BUI.MiniMap={
		Defaults={
		MiniMap			=true,
		MiniMapDimensions		=250,
		MiniMapTitle		=true,
		PinScale			=75,
		BUI_Minimap			={TOPRIGHT,TOPRIGHT,0,0},
		ZoomZone			=60,
		ZoomSubZone			=30,
		ZoomDungeon			=60,
		ZoomCyrodiil		=45,
		ZoomImperialsewer		=60,
		ZoomImperialCity		=80,
		ZoomMountRatio		=70,
		ZoomGlobal			=3,
		PinColor={
--			[MAP_PIN_TYPE_PLAYER]={1,1,1,1},
			[MAP_PIN_TYPE_GROUP_LEADER]={1,1,0,1},
			[MAP_PIN_TYPE_GROUP]={1,1,1,1},
			[MAP_PIN_TYPE_POI_COMPLETE]={1,1,1,1},
--			[MAP_PIN_TYPE_VENDOR]={1,1,1,1},
			[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE]={1,1,1,1},
			[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING]={1,1,1,1},
			}
		}}
local LastX1,LastY1,LastX2,LastY2=0,0,0,0
local BUI_MINIMAP_SCENE_NAMES={["hudui"]=true,["hud"]=true,}
local size=250
local pinscale=.75
local Subzone=false
local ZoomUpdatind=false
local MapSceneIsShowing=false
local MapPanAndZoom,PinManager
BUI:JoinTables(BUI.Defaults,BUI.MiniMap.Defaults)

local function UpdateDimensions()
	ZO_WorldMap:SetDimensions(size,size)
	ZO_WorldMapScroll:SetDimensions(size-8,size-8)
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
			Subzone=false zoom=BUI.Vars.ZoomImperialsewer
		elseif zonename=="imperialcity" then
			Subzone=false zoom=BUI.Vars.ZoomImperialCity
		else
			Subzone=true zoom=BUI.Vars.ZoomSubZone
		end
	else
		Subzone=false
		local content=GetMapContentType()
		if content==MAP_CONTENT_DUNGEON then
			zoom=BUI.Vars.ZoomDungeon
		elseif content==MAP_CONTENT_AVA then
			zoom=BUI.Vars.ZoomCyrodiil
		else
			zoom=BUI.Vars.ZoomZone
		end
	end

	MapPanAndZoom:SetCurrentNormalizedZoomInternal(zoom/100*ratio)
	local pin=PinManager:GetPlayerPin() MapPanAndZoom:PanToPin(pin, true)
end
--	/script ZO_WorldMap_GetPanAndZoom():SetCurrentNormalizedZoomInternal(1)
--	/script local pin=ZO_WorldMap_GetPinManager():GetPlayerPin() ZO_WorldMap_GetPanAndZoom():PanToPin(pin, true)
local function OnMount(eventCode,mounted)
	if not BUI.init.MiniMap or ZoomUpdatind then return end
	ZoomUpdate(mounted)
end

function BUI.MiniMap.Initialize()
	BUI.MiniMap.PinColors()
	if not BUI.Vars.MiniMap or BUI.GamepadMode then
		if BUI.init.MiniMap then
			BUI.MiniMap.Restore()
			ZO_WorldMap:SetHidden(true)
			if not BUI.Vars.ZO_FocusedQuestTrackerPanel then
				ZO_FocusedQuestTrackerPanel:ClearAnchors() ZO_FocusedQuestTrackerPanel:SetAnchor(TOPRIGHT, GuiRoot, TOPRIGHT, 0, 60)
			end
--			EVENT_MANAGER:UnregisterForEvent("BUI_Minimap", EVENT_RETICLE_HIDDEN_UPDATE)
			EVENT_MANAGER:UnregisterForEvent("BUI_ZoneChange", EVENT_PLAYER_ACTIVATED)
			EVENT_MANAGER:UnregisterForEvent("BUI_ZoneChange", EVENT_ZONE_CHANGED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Minimap", EVENT_SCREEN_RESIZED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Minimap", EVENT_MOUNTED_STATE_CHANGED)
			for scene in pairs(BUI_MINIMAP_SCENE_NAMES) do SCENE_MANAGER:GetScene(scene):UnregisterCallback("StateChange") end
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
	LastX1,LastY1=GetMapPlayerPosition('player') LastX2,LastY2=LastX1,LastY1
	size=BUI.Vars.MiniMapDimensions
	pinscale=BUI.Vars.PinScale/100
	MapPanAndZoom=ZO_WorldMap_GetPanAndZoom()
	PinManager=ZO_WorldMap_GetPinManager()
	--QuestTracker
	if not BUI.Vars.ZO_FocusedQuestTrackerPanel then
		ZO_FocusedQuestTrackerPanel:ClearAnchors() ZO_FocusedQuestTrackerPanel:SetAnchor(TOPRIGHT, GuiRoot, TOPRIGHT, 0, size+20)
	end

	EVENT_MANAGER:RegisterForEvent("BUI_ZoneChange", EVENT_PLAYER_ACTIVATED,	function() BUI.MiniMap.ZoneChanged(1000) end)
	EVENT_MANAGER:RegisterForEvent("BUI_ZoneChange", EVENT_ZONE_CHANGED,		function() BUI.MiniMap.ZoneChanged() end)
	EVENT_MANAGER:RegisterForEvent("BUI_Minimap", EVENT_SCREEN_RESIZED,		BUI.MiniMap.Show)
	EVENT_MANAGER:RegisterForEvent("BUI_Minimap", EVENT_MOUNTED_STATE_CHANGED,	OnMount)
	local function OnHUD(oldState, newState)
		if BUI.moveDefault or BUI.move then return end
		if newState==SCENE_HIDDEN then BUI.CallLater("MiniMap",20,function()
				if not BUI_MINIMAP_SCENE_NAMES[SCENE_MANAGER:GetCurrentSceneName()] then
					if BUI.init.MiniMap then ZO_WorldMap:SetHidden(true) end
				end
			end)
		elseif newState==SCENE_SHOWING then if BUI.init.MiniMap then ZO_WorldMap:SetHidden(false) else BUI.MiniMap.Show() end end
	end
	for scene in pairs(BUI_MINIMAP_SCENE_NAMES) do SCENE_MANAGER:GetScene(scene):RegisterCallback("StateChange", OnHUD) end

	CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged",	function(navigateIn) BUI.MiniMap.Show() end)
	WORLD_MAP_SCENE:RegisterCallback("StateChange", function(oldState, newState)
		if newState==SCENE_SHOWING and BUI.init.MiniMap then MapSceneIsShowing=true BUI.MiniMap.Restore()
--		elseif newState==SCENE_SHOWN then ZO_WorldMap_SetCustomZoomLevels(1.2,1.2) BUI.CallLater("MiniMap",500,ZO_WorldMap_ClearCustomZoomLevels)
--		elseif newState==SCENE_HIDING then ZO_MapPin.UpdateSize=function()end
		elseif newState==SCENE_HIDDEN then BUI.CallLater("MiniMap",100,function() MapSceneIsShowing=false BUI.MiniMap.Show() end) end
	end)
--[[
	GAMEPAD_WORLD_MAP_SCENE:RegisterCallback("StateChange", function(oldState, newState)
		if newState==SCENE_SHOWING and BUI.init.MiniMap then MapSceneIsShowing=true BUI.MiniMap.Restore()
		elseif newState==SCENE_HIDDEN then MapSceneIsShowing=false BUI.MiniMap.Show() end
	end)
--]]
	--Controls
	local ctrl	=BUI.UI.Control("BUI_Minimap",	BanditsUI,	{size,size},	BUI.Vars.BUI_Minimap,	false)
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

function BUI.MiniMap.PinColors()
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

function BUI.MiniMap.Show()
	if not BUI.Vars.MiniMap or MapSceneIsShowing or BUI.GamepadMode then return end
	EVENT_MANAGER:UnregisterForUpdate("BUI_Minimap")
	BUI.MiniMap.ResizePins(true)
	if BUI.inMenu then ZO_WorldMap_UpdateMap() end
	UpdatePosition()
--	ZO_WorldMap:SetMouseEnabled(false)
	ZO_WorldMap:SetHidden(not (SCENE_MANAGER:IsShowingBaseScene() or BUI.inMenu))
	BUI.init.MiniMap=true
	BUI.MiniMap.ZoneChanged()
	BUI.CallLater("MiniMap_Shown",100,function() EVENT_MANAGER:RegisterForUpdate("BUI_Minimap", 500, BUI.MiniMap.Update) end)
	CALLBACK_MANAGER:FireCallbacks("BUI_MiniMap_Shown", true)
end

function BUI.MiniMap.Restore()
	EVENT_MANAGER:UnregisterForUpdate("BUI_Minimap")
--	if BUI.API<=10024 then
	BUI.MiniMap.ResizePins(false)
	MapPanAndZoom:SetCurrentNormalizedZoomInternal(BUI.Vars.ZoomGlobal/100)
	ZO_WorldMap_UpdateMap()
	BUI.init.MiniMap=false
	CALLBACK_MANAGER:FireCallbacks("BUI_MiniMap_Shown", false)
	if BUI.g_mapPinManager and (BUI.Vars.StatsShareDPS or BUI.Vars.StatShare) then
		BUI.g_mapPinManager:RemovePins("pings", MAP_PIN_TYPE_PING)
	end
end

function BUI.MiniMap.ResizePins(resize)
	local scale=(resize) and pinscale or 1
	for pin=9,210 do
		if ZO_MapPin.PIN_DATA[pin] then
			local size=ZO_MapPin.PIN_DATA[pin].size
			local origsize=ZO_MapPin.PIN_DATA[pin].origsize or size or 40
			ZO_MapPin.PIN_DATA[pin].origsize=origsize
			ZO_MapPin.PIN_DATA[pin].size=origsize*scale
		end
	end
end

function BUI.Map_Toggle()
	local _visible=not ZO_WorldMap:IsHidden()
	ZO_WorldMap:SetHidden(_visible)
	if not _visible then
--		ZO_WorldMap_SetCustomZoomLevels(2.5,2.5)
		ZO_WorldMap_JumpToPlayer()
	end
end

function BUI.MiniMap.Update()
	if BUI.inCombat or not BUI.init.MiniMap then return end
	local x,y=GetMapPlayerPosition('player')
	local delta=math.floor(math.abs((LastX1-x)^2+(LastY1-y)^2)*100000)
	if delta>=(Subzone and 100 or 9) then
		LastX1=x
		LastY1=y
		if delta<1000 then
--			ZO_WorldMap_PanToPlayer()
			local pin=PinManager:GetPlayerPin() MapPanAndZoom:PanToPin(pin, true)
			CALLBACK_MANAGER:FireCallbacks("BUI_MiniMap_Update", true)
		end
	end

--[[
	if BUI.Vars.DeveloperMode and MapPinsCurrentLocationChests then
		delta=math.floor(math.abs((LastX2-x)^2+(LastY2-y)^2)*1000000)
		if delta>=(Subzone and 10 or 1) then
			LastX2=x
			LastY2=y
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

function BUI.MiniMap.ZoneChanged(delay)
	if not BUI.init.MiniMap then return end
	UpdateDimensions()

	if ZoomUpdatind then return end
	ZoomUpdatind=true
	BUI.CallLater("MiniMap_ZoomUpdate",delay and delay or 0,function() ZoomUpdate() ZoomUpdatind=false end)
end