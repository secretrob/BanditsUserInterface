BUI.Markers={
	Default={
		IconDuration=20,
		Dungeons=false,
		Trials=false,
		Message=true,
		Icon=true,
		HeavySack=true,
		},
	List={"IconDuration","Dungeons","Trials","Message","Icon","HeavySack"},
	MarkerType=nil
}

local targetX,targetY,targetZ=0,0,0
local lockpicking = nil
local lastInteractableName
SecurePostHook(FISHING_MANAGER or INTERACTIVE_WHEEL_MANAGER, "StartInteraction", function() local _, name=GetGameCameraInteractableActionInfo() lastInteractableName=name end)

function ClearMarkOnPlayer()
	local name=GetUnitName('reticleover')
	--d(name)
	--d(BUI.Markers.MarkerType)
	if name == nil or string.len(name)==0 then
		AssignTargetMarkerToReticleTarget(BUI.Markers.MarkerType)
		BUI.Markers.MarkerType=nil		
		EVENT_MANAGER:UnregisterForEvent("BUI_Markers", EVENT_RETICLE_TARGET_CHANGED)
	end	
end

function CheckFlagsToContinue()
	if not IsUnitInDungeon("player") then return false end
	if GetCurrentZoneDungeonDifficulty() <= 0 then return false end
	if not BUI.Vars.Markers_Dungeons and not IsPlayerInRaid() then return false end
	if not BUI.Vars.Markers_Trials and IsPlayerInRaid() then return false end
	if lastInteractableName ~= "Chest" and lastInteractableName ~= "Heavy Sack" then return false end
	return true
end

function MarkThenUnmark()
	AssignTargetMarkerToReticleTarget(BUI.Markers.MarkerType)
	--after Markers_IconDuration seconds call hide to drop the X.
	BUI.CallLater("HideXMarker",BUI.Vars.Markers_IconDuration*1000,function ()
		lockpicking=nil
		EVENT_MANAGER:RegisterForEvent("BUI_Markers", EVENT_RETICLE_TARGET_CHANGED, ClearMarkOnPlayer)
		ClearMarkOnPlayer()
	end)
end

function MarkPlayerOpeningChest()
	local lptimer
	if not CheckFlagsToContinue() then return end
	if lockpicking ~= nil then lptimer = lockpicking + 30 end --cooldown before checking again
	if lockpicking == nil or lptimer <= os.time() then
		quality = GetLockQuality()
		if quality < 1 then quality = 1 end
		qualitytype = {[1] = "Simple", [2] = "Intermediate", [3] = "Advanced", [4] = "Master"}
		if BUI.Vars.Markers_Message then CHAT_SYSTEM:StartTextEntry(string.format("Found %s chest at marker X", qualitytype[quality]), CHAT_CHANNEL_PARTY) end
		lockpicking = os.time()
		if BUI.Vars.Markers_Icon then
			BUI.Markers.MarkerType=TARGET_MARKER_TYPE_SEVEN
			MarkThenUnmark()
		end
	end
end

function MarkPlayerOpeningHeavySack(event, result, target_name)
	if target_name == "Heavy Sack" then 
		if not CheckFlagsToContinue() then return end		
		if BUI.Vars.Markers_Message then CHAT_SYSTEM:StartTextEntry("Found Heavy Sack at marker Moon", CHAT_CHANNEL_PARTY) end
		if BUI.Vars.Markers_Icon then
			BUI.Markers.MarkerType=TARGET_MARKER_TYPE_FIVE
			MarkThenUnmark()
		end
	end
end

function BUI.Markers.Initialize()
	for _,name in pairs(BUI.Markers.List) do		
		if BUI.Vars["Markers_"..name] == nil then BUI.Vars["Markers_"..name]=BUI.Markers.Default[name] end
	end

	EVENT_MANAGER:RegisterForEvent("BUI_Markers", EVENT_BEGIN_LOCKPICK, MarkPlayerOpeningChest)
	if BUI.Vars.Markers_HeavySack then 
		EVENT_MANAGER:RegisterForEvent("BUI_Markers", EVENT_CLIENT_INTERACT_RESULT, MarkPlayerOpeningHeavySack)
	end
end

--[[
function BUI.PlaceMarker(num)
	local r=3
	local zone,worldX,worldY,worldZ=GetUnitRawWorldPosition('player')
	local pX,pY,pZ=WorldPositionToGuiRender3DPosition(worldX,worldY,worldZ)
	local marker=_G["BUI_Marker"..num] or WINDOW_MANAGER:CreateControl("BUI_Marker"..num,ParticleUI,CT_TEXTURE)
	marker:Destroy3DRenderSpace()
	marker:Create3DRenderSpace()
	marker:SetTexture("/BanditsUserInterface/textures/marker.dds")
	marker:Set3DRenderSpaceUsesDepthBuffer(true)
	marker:Set3DLocalDimensions(r,r)
--	marker:SetColor(1,1,1,1)
	marker:SetAlpha(.5)
	marker:Set3DRenderSpaceOrigin(pX,pY+.05,pZ)
	marker:Set3DRenderSpaceOrientation(-math.pi/2,0,0)
	marker:SetHidden(false)

	PlaySound("DaedricArtifact_Revealed")
	targetX=pX
	targetY=pY
	targetZ=pZ
end
**
	/script PlaySound("DaedricArtifact_Despawned")
	/script BUI_Marker:Set3DLocalDimensions(.5,.5)
	/script BUI_Marker:Set3DRenderSpaceUsesDepthBuffer(false)
	/script BUI_Marker:Set3DRenderSpaceOrientation(0,math.pi,0)
	/script BUI.PlaceMarker(1)
**
local function GetTargetPosition()
	local _,worldX,worldY,worldZ=GetUnitRawWorldPosition(BUI.GroupLeader)
	return WorldPositionToGuiRender3DPosition(worldX,worldY,worldZ)
--	return targetX,targetY,targetZ
end

local function NormalizeAngle(angle)
	if angle>math.pi then return angle-2*math.pi end
	if angle<-math.pi then return angle+2*math.pi end
	return angle
end

local function Update()
	local _,worldX,worldY,worldZ=GetUnitRawWorldPosition('player')
	local pX,pY,pZ=WorldPositionToGuiRender3DPosition(worldX,worldY,worldZ)
	if BUI.Compass then
		BUI_Compass:Set3DRenderSpaceOrigin(pX,pY+.5,pZ)
--		if BUI.GroupLeader and not BUI.Player.isLeader then
			local tX,tY,tZ=GetTargetPosition()
--			local dist=math.sqrt((pX-tX)^2+(pZ-tZ)^2))
--			BUI_TauntTimer:SetText(math.floor(dist*100))
			local angle=math.atan2(pX-tX,pZ-tZ)
			BUI_Crown:Set3DRenderSpaceOrientation(-math.pi/2,angle,0)
			BUI_Crown:Set3DRenderSpaceOrigin(pX,pY+.03,pZ)
--	end
	end
	if BUI.Markers>0 then	--BUI.InGroup
		local heading=GetPlayerCameraHeading()
		for i=1,BUI.Group.members do
			local unitTag=BUI.Group[i].tag
			local _,worldX,worldY,worldZ=GetUnitRawWorldPosition(unitTag)
			local tX,tY,tZ=WorldPositionToGuiRender3DPosition(worldX,worldY,worldZ)
			BUI.GroupMarker[i]:Set3DRenderSpaceOrigin(tX,tY+3,tZ)
			local angle=math.atan2(pX-tX,pZ-tZ)
			BUI.GroupMarker[i]:Set3DRenderSpaceOrientation(0,angle,0)
		end
	end
end

function BUI.Markers_Init()
	BUI.Markers=3
	if BUI.Markers>0 then
		for i=1,24 do
			if not BUI.GroupMarker[i] then
				BUI.GroupMarker[i]=WINDOW_MANAGER:CreateControl("BUI_GroupMarker"..i,ParticleUI,CT_TEXTURE)
				BUI.GroupMarker[i]:Create3DRenderSpace()
				BUI.GroupMarker[i]:Set3DLocalDimensions(.5,.5)
				if BUI.Group[i] then
					BUI.GroupMarker[i]:SetTexture(BUI.Group[BUI.Group[i].tag].marker or "")
				end
				BUI.GroupMarker[i]:SetHidden(not(BUI.Group[i] and BUI.Group[i].marker==BUI.Markers))
			end
		end
		EVENT_MANAGER:RegisterForUpdate("BUI_Markers", 10, Update)
	else
		for i=1,24 do
			if BUI.GroupMarker[i] then BUI.GroupMarker[i]:SetHidden(true) end
		end
		if not BUI.Compass then EVENT_MANAGER:UnregisterForUpdate("BUI_Markers") end
	end
end
**
/script BUI.Markers_Init()
/script
for i=1,24 do
BUI.GroupMarker[i]:Destroy3DRenderSpace()
BUI.GroupMarker[i]:Create3DRenderSpace()
end
**
function BUI.Compass_Init()
	if BUI.Compass then
		local compass=_G["BUI_Compass"] or WINDOW_MANAGER:CreateControl("BUI_Compass",ParticleUI,CT_TEXTURE)
		compass:Destroy3DRenderSpace()
		compass:Create3DRenderSpace()
		compass:SetTexture("/BanditsUserInterface/textures/compass.dds")
		compass:Set3DRenderSpaceUsesDepthBuffer(true)
		compass:Set3DLocalDimensions(3,3)
	--	compass:SetColor(1,1,1,1)
		compass:SetAlpha(.5)
		compass:Set3DRenderSpaceOrientation(-math.pi/2,0,0)
		compass:SetHidden(false)

		local crown=_G["BUI_Crown"] or WINDOW_MANAGER:CreateControl("BUI_Crown",ParticleUI,CT_TEXTURE)
		crown:Destroy3DRenderSpace()
		crown:Create3DRenderSpace()
		crown:SetTexture("/BanditsUserInterface/textures/crown.dds")
		crown:Set3DRenderSpaceUsesDepthBuffer(true)
		crown:Set3DLocalDimensions(.5,4)
	--	crown:SetColor(1,1,1,1)
		crown:SetAlpha(.5)
	--	crown:Set3DRenderSpaceOrientation(-math.pi/2,0,0)
		crown:SetHidden(not (BUI.GroupLeader and not BUI.Player.isLeader))

		EVENT_MANAGER:RegisterForUpdate("BUI_Markers", 10, Update)
	else
		if BUI_Compass then BUI_Compass:SetHidden(true) end
		if BUI_Crown then BUI_Crown:SetHidden(true) end
		if BUI.Markers==0 then EVENT_MANAGER:UnregisterForUpdate("BUI_Markers") end
	end
end

function GetTargetPoint()
	local _,worldX,worldY,worldZ=GetUnitRawWorldPosition('player')
	local pX,pY,pZ=WorldPositionToGuiRender3DPosition(worldX,worldY,worldZ)

	BUI_Camera:Set3DLocalDimensions(1,1)
	BUI_Camera:SetTexture("esoui/art/compass/compass_waypoint.dds")
	BUI_Camera:SetHidden(false)
	Set3DRenderSpaceToCurrentCamera("BUI_Camera")
	local cX,cY,cZ=BUI_Camera:Get3DRenderSpaceOrigin()
--	local pitch,yaw,roll=BUI_Camera:Get3DRenderSpaceOrientation()
--	d(pitch,yaw,roll)
	local cH=cY-pY
--	local range=cH/math.tan(yaw)
	d("Camera height: "..cH)
--	d("Target range: "..range)
end

**
/script Set3DRenderSpaceToCurrentCamera("BUI_Camera") d(BUI_Crown:Get3DRenderSpaceOrientation())
/script GetTargetPoint()
/script BUI_Compass:Set3DRenderSpaceSystem(GUI_RENDER_3D_SPACE_SYSTEM_WORLD)
/script Set3DRenderSpaceToCurrentCamera("BUI_Compass")
/script BUI_Compass:SetTexture("/BanditsUserInterface/textures/compass.dds")
/script BUI_Compass:SetColor(1,1,1,1)
/script d(BUI_Compass:Get3DRenderSpaceOrientation())
/script BUI_Crown:Set3DRenderSpaceOrientation(0,0,0)
/script BUI_Crown:Set3DLocalDimensions(1,4)
/script BUI_Compass:Set3DRenderSpaceOrientation(-math.pi/2,0,0)
/script BUI_Compass:SetAlpha(.5)
/script BUI_Compass:Destroy3DRenderSpace()
/script BUI_Compass:Create3DRenderSpace()
/script BUI_Camera:Set3DLocalDimensions(3,3)
/script EVENT_MANAGER:UnregisterForUpdate("BUI_Compass")
/script BUI.Compass_Init()

/script local zone,worldX,worldY,worldZ=GetUnitRawWorldPosition('player')
local x,y,z=WorldPositionToGuiRender3DPosition(worldX,worldY,worldZ)
BUI_Compass:Set3DRenderSpaceOrigin(x,y+.005,z)
--]]