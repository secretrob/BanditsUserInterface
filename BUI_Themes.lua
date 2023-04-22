local textures={
{"worldmap","worldmap_frame_edge.dds"},
--Action bar
{"actionbar","abilityframe64_down.dds"},
{"actionbar","abilityframe64_up.dds"},
--Target bar
{"unitattributevisualizer","targetbar_dynamic_frame.dds"},
{"unitframes","target_name_bracket_left.dds"},
{"unitframes","target_name_bracket_right.dds"},
{"unitframes","targetunitframe_bracket_level2_left.dds"},
{"unitframes","targetunitframe_bracket_level2_right.dds"},
{"unitframes","targetunitframe_bracket_level3_left.dds"},
{"unitframes","targetunitframe_bracket_level3_right.dds"},
{"unitframes","targetunitframe_bracket_level4_left.dds"},
{"unitframes","targetunitframe_bracket_level4_right.dds"},
--Player exp bar
{"miscellaneous","progressbar_frame.dds"},
--Player attributes bars
{"unitattributevisualizer","attributebar_dynamic_frame.dds"},
{"unitattributevisualizer","attributebar_small_frame.dds"},
{"unitattributevisualizer","attributebar_small_frame_center.dds"},
--Compass
{"compass","compass.dds"},
{"bossbar","bossbar_bracket_left.dds"},
{"bossbar","bossbar_bracket_right.dds"},
}
local flat={
--Target bar
{"unitattributevisualizer","targetbar_dynamic_invulnerable.dds"},
{"unitattributevisualizer","targetbar_dynamic_fill_gloss.dds"},
{"unitattributevisualizer","targetbar_dynamic_leadingedge_gloss.dds"},
--Player exp bar
{"miscellaneous","progressbar_genericfill_gloss.dds"},
{"miscellaneous","progressbar_genericfill_leadingedge_gloss.dds"},
--Player attributes bars
{"unitattributevisualizer","attributebar_dynamic_fill_gloss.dds"},
{"unitattributevisualizer","attributebar_dynamic_leadingedge_gloss.dds"},
{"unitattributevisualizer","attributebar_small_fill_center_gloss.dds"},
{"unitattributevisualizer","attributebar_small_fill_leadingedge_gloss.dds"},
}
local smooth={
"ZO_CompassFrameCenterTopMungeOverlay",
"ZO_CompassFrameCenterBottomMungeOverlay",
"ZO_PlayerAttributeHealthFrameCenterTopMunge",
"ZO_PlayerAttributeHealthFrameCenterBottomMunge",
"ZO_PlayerAttributeMagickaFrameCenterTopMunge",
"ZO_PlayerAttributeMagickaFrameCenterBottomMunge",
"ZO_PlayerAttributeStaminaFrameCenterTopMunge",
"ZO_PlayerAttributeStaminaFrameCenterBottomMunge",
"ZO_TargetUnitFramereticleoverFrameCenterTopMunge",
"ZO_TargetUnitFramereticleoverFrameCenterBottomMunge",
"ZO_IncreasedArmorFrameContainerArrow1FrameCenterBottomMunge",
"ZO_IncreasedArmorFrameContainerArrow1FrameCenterTopMunge",
"ZO_WorldMapMapFrameBottomMunge",
"ZO_WorldMapMapFrameTopMunge",
"ZO_WorldMapMapFrameLeftMunge",
"ZO_WorldMapMapFrameRightMunge",
}
local color

local function Setup_ActionSlot()
	local normal=BUI.Vars.Theme<=3 and "/esoui/art/actionbar/abilityframe64_up.dds" or "/BanditsUserInterface/textures/theme/abilityframe64_up.dds"
	BUI.abilityframe=normal
--	local mouseDown=BUI.Vars.Theme<=3 and "/esoui/art/actionbar/abilityframe64_down.dds" or "/BanditsUserInterface/textures/theme/abilityframe64_down.dds"

	--Action slots
	for i=3,9 do
		local name=i==9 and "QuickslotButton" or "ActionButton"..i
		local frame=_G[name]
		if frame then
			local button=frame:GetNamedChild("Button")
			button:SetNormalTexture("") button:SetPressedTexture("")
			local size=frame:GetWidth()
--			ZO_ActionBar1:GetScale()
			local edge=_G[name.."Edge"] or WINDOW_MANAGER:CreateControl("$(parent)Edge", frame, CT_TEXTURE)
			edge:SetDimensions(size,size)
			edge:ClearAnchors()
			edge:SetAnchor(TOPLEFT,frame,TOPLEFT,0,0)
			edge:SetTexture(normal)
			if color then edge:SetColor(unpack(color)) end edge:SetDrawLayer(2)
			local backdrop=frame:GetNamedChild("Backdrop") if backdrop then backdrop:SetAlpha(0) end
			local bg=frame:GetNamedChild("BG") if bg then bg:SetHidden(false) end
			if i==8 then backdrop=frame:GetNamedChild("Frame") if backdrop then backdrop:SetAlpha(0) end end
		end
	end
end

local function Setup_TargetFrame()
	local texture=BUI.Vars.Theme<=3 and "/esoui/art/unitattributevisualizer/targetbar_dynamic_frame.dds" or "/BanditsUserInterface/textures/theme/targetbar_dynamic_frame.dds"
	for _,text in pairs({"Center","Left","Right"}) do
		local frame=_G["ZO_TargetUnitFramereticleoverFrame"..text]
		if frame then frame:SetTexture(texture) if color then frame:SetColor(unpack(color)) end end
	end
end

local function Setup_AdvancedTheme()
	local a_color={BUI.Vars.AdvancedThemeColor[1],BUI.Vars.AdvancedThemeColor[2],BUI.Vars.AdvancedThemeColor[3],BUI.Vars.AdvancedThemeColor[4]/2}
	local function HideElements(hide)
		for _,text in pairs({"Center","Left","Right"}) do local frame=_G["ZO_CompassFrame"..text] if frame then frame:SetHidden(hide) end end
		for _,text in pairs({"Left","Right"}) do local frame=_G["ZO_BossBarBracket"..text] if frame then frame:SetHidden(hide) end end
		ZO_ChatWindowDivider:SetHidden(hide) ZO_ChatWindowBg:SetHidden(hide)
		if BUI.Vars.StatsMiniMeter then BUI_MiniMeter_BG:SetHidden(hide) end
		ZO_PerformanceMetersBg:SetHidden(hide)
		ZO_FocusedQuestTrackerPanelContainerQuestContainerAssistedKeyLabel:SetHidden(hide)
	end
	if BUI.Vars.Theme~=7 then
		if BUI_AdvancedTheme then
			BUI_AdvancedTheme:SetHidden(true) BUI_Chat_Edge:SetHidden(true) HideElements(false)
		end
		return
	elseif BUI_AdvancedTheme then
		BUI_AdvancedTheme:SetHidden(false) BUI_Chat_Edge:SetHidden(false) HideElements(true)
		local frames={"BUI_AdvancedTheme","BUI_Chat_Edge","BUI_Compass_Edge"}
		for _,name in pairs(frames) do
			control=_G[name]
			for i=1,control:GetNumChildren() do
				local obj=control:GetChild(i)
				if obj:GetType()==CT_LINE then
					obj:SetColor(unpack(a_color))
				end
			end
		end
		return
	end
	HideElements(true)
	local ui=BUI.UI.Control("BUI_AdvancedTheme", BanditsUI, "inherit", {TOPLEFT,TOPLEFT,0,0}, false)
--[[	--HUD
	if BUI.Vars.CurvedFrame==0 then
		local w,h=BanditsUI:GetDimensions()
		local points={
			{ui,CENTER,w/6-20,-h/4-10},
			{ui,CENTER,w/6-10,-h/4},
			{ui,CENTER,w/6-10,h/6-74-10},
			{ui,CENTER,w/6,h/6-74},
			{ui,CENTER,w/6,h/6},
			{ui,CENTER,w/6-10,h/6+10},
		}
		BUI.UI.Path(nil, ui, points, a_color, 2)
		local points={
			{ui,CENTER,-w/6+20,-h/4-10},
			{ui,CENTER,-w/6+10,-h/4},
			{ui,CENTER,-w/6+10,h/6-74-10},
			{ui,CENTER,-w/6,h/6-74},
			{ui,CENTER,-w/6,h/6},
			{ui,CENTER,-w/6+10,h/6+10},
		}
		BUI.UI.Path(nil, ui, points, a_color, 2)
	end
--]]
	--Compass
	local w,h=ZO_CompassFrame:GetDimensions() h=h*.6
	local sw,sh=14,3
	local w1,h1=w/sw,h/sh
	local compass=BUI.UI.Control("BUI_Compass_Edge", ui, {w+h,h}, {TOPLEFT,TOPLEFT,-h/2,h*.33,ZO_CompassFrame}, false)
	for i=0,sh do
		local line=BUI.UI.Line(nil, compass, {w+i*h1,0}, {TOPLEFT,TOPLEFT,(h-i*h1)/2,i*h1}, a_color, 2)
	end
	for i=0,sw do
		local pos=(w+h)/sw*i-i*w1-h/2
		local line=BUI.UI.Line(nil, compass, {pos,h}, {TOPLEFT,TOPLEFT,i*w1+h/2,0}, a_color, 2)
	end
	--Chat
	if not BUI.GamepadMode and ZO_ChatWindow and ZO_ChatWindowTabTemplate1 then
		local chat=BUI.UI.Control("BUI_Chat_Edge", ZO_ChatWindow, "inherit", {TOPLEFT,TOPLEFT,0,0}, false)
		BUI.UI.Path(nil, chat, {{ZO_ChatWindowDivider,TOPLEFT,0,0},{ZO_ChatWindowDivider,TOPRIGHT,0,0}}, a_color, 2)
		local offset=ZO_ChatWindow:GetTop()-ZO_ChatWindowTabTemplate1:GetTop()
		local points={
			{ZO_ChatWindow,BOTTOMLEFT,0,-10},
			{ZO_ChatWindow,TOPLEFT,0,10-offset},
			{ZO_ChatWindowTabTemplate1,TOPLEFT,ZO_ChatWindow:GetLeft()-ZO_ChatWindowTabTemplate1:GetLeft()+10,0},
			{ZO_ChatWindowNewWindowTab,TOPRIGHT,0,ZO_ChatWindowTabTemplate1:GetTop()-ZO_ChatWindowNewWindowTab:GetTop()},
			{ZO_ChatWindowNewWindowTab,TOPRIGHT,offset,ZO_ChatWindowTabTemplate1:GetTop()-ZO_ChatWindowNewWindowTab:GetTop()+offset},
			{ZO_ChatWindow,TOPRIGHT,-10,0},
			{ZO_ChatWindow,TOPRIGHT,0,10},
			{ZO_ChatWindow,BOTTOMRIGHT,0,-10},
			{ZO_ChatWindow,BOTTOMRIGHT,-10,0},
			{ZO_ChatWindow,BOTTOMLEFT,10,0},
			{ZO_ChatWindow,BOTTOMLEFT,0,-10}
		}
		BUI.UI.Path(nil, chat, points, a_color, 2)
	end
--[[	--World Map
	local points={
		{ZO_WorldMapMapFrame,TOPLEFT,0,0},
		{ZO_WorldMapMapFrame,TOPLEFT,-10,10},
		{ZO_WorldMapMapFrame,TOPLEFT,-10,100},
		{ZO_WorldMapMapFrame,TOPLEFT,0,110},
	}
	BUI.UI.Path(nil, ZO_WorldMapMapFrame, points, a_color, 2)
--]]
	--BUI_MiniMeter
	if BUI_MiniMeter then
	local points={
		{BUI_MiniMeter,BOTTOMLEFT,0,-10-5},
		{BUI_MiniMeter,BOTTOMLEFT,10,-5},
		{BUI_MiniMeter,BOTTOMRIGHT,-10,-5},
		{BUI_MiniMeter,BOTTOMRIGHT,0,-10-5},
	}
	BUI.UI.Path(nil, ui, points, a_color, 2)
	end
	--BUI_GroupDPS
	if BUI_GroupDPS then
	local points={
		{BUI_GroupDPS,TOPLEFT,-10,10},
		{BUI_GroupDPS,TOPLEFT,0,0},
		{BUI_GroupDPS,TOPRIGHT,0,0},
		{BUI_GroupDPS,TOPRIGHT,10,10},
	}
	BUI.UI.Path(nil, BUI_GroupDPS, points, a_color, 2)
	end
	--BUI_HornInfo
	if BUI_HornInfo then
	local points={
		{BUI_HornInfo,TOPLEFT,-10,10},
		{BUI_HornInfo,TOPLEFT,0,0},
		{BUI_HornInfo,TOPRIGHT,0,0},
		{BUI_HornInfo,TOPRIGHT,10,10},
	}
	BUI.UI.Path(nil, BUI_HornInfo, points, a_color, 2)
	end
	--Performance Meters
	local points={
		{ZO_PerformanceMeters,BOTTOMLEFT,0,-10-20},
		{ZO_PerformanceMeters,BOTTOMLEFT,10,-20},
		{ZO_PerformanceMeters,BOTTOMRIGHT,-10,-20},
		{ZO_PerformanceMeters,BOTTOMRIGHT,0,-10-20},
	}
	BUI.UI.Path(nil, ui, points, a_color, 2)
	--QuestTracker
	local frame=ZO_FocusedQuestTrackerPanelContainerQuestContainer
	local points={
		{frame,BOTTOMLEFT,-5,-5},
		{frame,BOTTOMLEFT,5,5},
		{frame,BOTTOMRIGHT,-5,5},
		{frame,BOTTOMRIGHT,5,-5},
		{frame,TOPRIGHT,5,5},
		{frame,TOPRIGHT,-5,-5},
		{frame,TOPLEFT,5,-5},
		{frame,TOPLEFT,-5,5},
		{frame,BOTTOMLEFT,-5,-5},
	}
	BUI.UI.Path(nil, ui, points, a_color, 2)
	--ZO_ActionBar
	local h=ActionButton3:GetHeight()
	local anchor_right=BUI.Vars.CustomBar.Enable and BUI_CustomBar or ActionButton8
	local points={
		{QuickslotButton,TOPLEFT,-5,5},
		{QuickslotButton,TOPLEFT,5,-5},
		{ActionButton3,TOPLEFT,h/6-h/2,-5},
		{ActionButton3,TOPLEFT,h/6,-h/2-5},
		{ActionButton7,TOPRIGHT,h/6,-h/2-5},
		{ActionButton7,TOPRIGHT,h/6+h/2,-5},
		{anchor_right,TOPRIGHT,-5,-5},
		{anchor_right,TOPRIGHT,5,5},
	}
	BUI.UI.Path(nil, ui, points, a_color, 2)
	--BUI_BuffsP_Panel
	if BUI_BuffsP_Panel then
	local points={
		{BUI_BuffsP_Panel,BOTTOMLEFT,-5,-5},
		{BUI_BuffsP_Panel,BOTTOMLEFT,5,5},
		{BUI_BuffsP_Panel,BOTTOMRIGHT,-5,5},
		{BUI_BuffsP_Panel,BOTTOMRIGHT,5,-5},
	}
	BUI.UI.Path(nil, ui, points, a_color, 2)
	end
	--BUI_BuffsT_Panel
	if BUI_BuffsT_Panel then
	local points={
		{BUI_BuffsT_Panel,BOTTOMLEFT,-5,-5},
		{BUI_BuffsT_Panel,BOTTOMLEFT,5,5},
		{BUI_BuffsT_Panel,BOTTOMRIGHT,-5,5},
		{BUI_BuffsT_Panel,BOTTOMRIGHT,5,-5},
	}
	BUI.UI.Path(nil, ui, points, a_color, 2)
	end
	--BUI_BuffsPas
	if BUI_BuffsPas then
	local points={
		{BUI_BuffsPas_Base,BOTTOMLEFT,-5,0},
		{BUI_BuffsPas_Base,TOPLEFT,-5,5},
		{BUI_BuffsPas_Base,TOPLEFT,5,-5},
	}
	BUI.UI.Path(nil, ui, points, a_color, 2)
	end
end

function BUI.Themes_Setup(change)
	color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.Theme>3 and BUI.Vars.CustomEdgeColor or {1,1,1,1}
	--Progress bar
	if BUI.Vars.Theme==4 or BUI.Vars.Theme==5 then
--		RedirectTexture("/esoui/art/miscellaneous/progressbar_frame.dds","/BanditsUserInterface/textures/theme/progressbar_frame.dds")
--		for i,data in pairs(textures) do RedirectTexture("/esoui/art/"..data[1].."/"..data[2],"/BanditsUserInterface/textures/theme/"..data[2]) end
	end
	--Attribute bar textures
	BUI.Frames.ChangeTextures()
	--Smooth
	local a=(BUI.Vars.Theme==1) and 1 or 0
	for i,name in pairs(smooth) do
		local control=_G[name] if control then control:SetAlpha(a) end
	end
	--Pink pony
	if BUI.Vars.Theme==6 then
		if BUI_Theme_Pony then
			BUI_Theme_Pony:SetHidden(false)
		else
			local scale=GetCVar("UseCustomUIScale.2")=="0" and .8 or tonumber(GetCVar("CustomUIScale"))
			BUI.UI.Statusbar("BUI_Theme_Pony",QuickslotButton,{128*scale,128*scale},{BOTTOMRIGHT,BOTTOMRIGHT,0,0},{1,1,1,1},"/BanditsUserInterface/textures/pink_pony.dds",false)
		end
	elseif BUI_Theme_Pony then
		BUI_Theme_Pony:SetHidden(true)
	end
	--Player exp bar
	local texture=BUI.Vars.Theme<=3 and "/esoui/art/miscellaneous/progressbar_frame.dds" or "/BanditsUserInterface/textures/theme/progressbar_frame.dds"
	for _,text in pairs({"Middle","Left","Right"}) do local frame=_G["ZO_PlayerProgressBarOverlay"..text] if frame then frame:SetTexture(texture) if color then frame:SetColor(unpack(color)) end end end
	--Attribute bars
	local texture=BUI.Vars.Theme<=3 and "/esoui/art/unitattributevisualizer/attributebar_dynamic_frame.dds" or "/BanditsUserInterface/textures/theme/attributebar_dynamic_frame.dds"
	local bars={"ZO_PlayerAttributeHealth","ZO_PlayerAttributeMagicka","ZO_PlayerAttributeStamina"}
	for _,bar in pairs(bars) do
		for _,text in pairs({"Center","Left","Right"}) do
			local frame=_G[bar.."Frame"..text] if frame then frame:SetTexture(texture) if color then frame:SetColor(unpack(color)) end end
--			local frame=_G[bar.."BgContainerBG"..text] if frame then frame:SetTexture(fill) end
		end
	end
	local frame=_G["ZO_PlayerAttributeSiegeHealthFrame"] if frame then
		local texture=BUI.Vars.Theme<=3 and "/esoui/art/unitattributevisualizer/attributebar_small_frame_center.dds" or "/BanditsUserInterface/textures/theme/attributebar_small_frame_center.dds"
		frame:SetTexture(texture) if color then frame:SetColor(unpack(color)) end
	end
	local frame=_G["ZO_PlayerAttributeWerewolfFrame"] if frame then
		local texture=BUI.Vars.Theme<=3 and "/esoui/art/unitattributevisualizer/attributebar_small_frame.dds" or "/BanditsUserInterface/textures/theme/attributebar_small_frame.dds"
		frame:SetTexture(texture) if color then frame:SetColor(unpack(color)) end
	end
	local frame=_G["ZO_PlayerAttributeMountStaminaFrame"] if frame then
		local texture=BUI.Vars.Theme<=3 and "/esoui/art/unitattributevisualizer/attributebar_small_frame.dds" or "/BanditsUserInterface/textures/theme/attributebar_small_frame.dds"
		frame:SetTexture(texture) if color then frame:SetColor(unpack(color)) end
	end
	--Target frame
	Setup_TargetFrame()
	--Worldmap
	local frame=_G["ZO_WorldMapMapFrame"] if frame then
		local texture=BUI.Vars.Theme<=3 and "/esoui/art/worldmap/worldmap_frame_edge.dds" or "/BanditsUserInterface/textures/theme/worldmap_frame_edge.dds"
		frame:SetEdgeTexture(texture,128,16,16) if color then frame:SetEdgeColor(unpack(color)) end
	end
	--ActionBar
	Setup_ActionSlot()
	--Compass
	local texture=BUI.Vars.Theme<=3 and "/esoui/art/compass/compass.dds" or "/BanditsUserInterface/textures/theme/compass.dds"
	for _,text in pairs({"Center","Left","Right"}) do local frame=_G["ZO_CompassFrame"..text] if frame then frame:SetTexture(texture) if color then frame:SetColor(unpack(color)) end end end
	local texture=BUI.Vars.Theme<=3 and "/esoui/art/bossbar/bossbar_bracket_left.dds" or "/BanditsUserInterface/textures/theme/bossbar_bracket_left.dds"
	local frame=_G["ZO_BossBarBracketLeft"] if frame then frame:SetTexture(texture) if color then frame:SetColor(unpack(color)) end end
	local texture=BUI.Vars.Theme<=3 and "/esoui/art/bossbar/bossbar_bracket_right.dds" or "/BanditsUserInterface/textures/theme/bossbar_bracket_right.dds"
	local frame=_G["ZO_BossBarBracketRight"] if frame then frame:SetTexture(texture) if color then frame:SetColor(unpack(color)) end end
	--Change frame colors
	if change then
		if BUI.init.Frames then BUI.Frames:Initialize() end
		if BUI.init.Actions then BUI.Actions.ChangeTheme() end
		if BUI.Vars.PlayerBuffs or BUI.Vars.TargetBuffs or BUI.Vars.EnableCustomBuffs or BUI.Vars.EnableWidgets then BUI.Buffs:Initialize() end
		if BUI.Vars.QuickSlots then BUI.QuickSlots.Update(true) end
		BUI.CustomBarUpdate(true)
	end

	Setup_AdvancedTheme()
end

function BUI.Frames.ChangeTextures()
	local v=BUI.Vars.Theme
	local bars={ZO_TargetUnitFramereticleoverBarLeft=true,ZO_TargetUnitFramereticleoverBarRight=true,ZO_BossBarHealthBarRight=false,ZO_BossBarHealthBarLeft=false,ZO_PlayerAttributeHealthBarRight=false,ZO_PlayerAttributeHealthBarLeft=false,ZO_PlayerAttributeStaminaBar=false,ZO_PlayerAttributeMagickaBar=false,ZO_PlayerAttributeSiegeHealthBarLeft=true,ZO_PlayerAttributeSiegeHealthBarRight=true,ZO_PlayerAttributeWerewolfBar=true,ZO_PlayerAttributeMountStaminaBar=true}
	for bar,half in pairs(bars) do
		_G[bar.."Gloss"]:SetHidden(v==3 or v==5 or v==7)
		if (v==3 or v==5 or v==7) and not BUI.GamepadMode then
			local frame=_G[bar]
			if frame then
				local h=frame:GetHeight()
				frame:SetTexture(BUI.Textures[BUI.Vars.FramesTexture])
				frame:SetTextureCoords(0,1,(half and .5 or 0),1)
				frame:SetLeadingEdge(BUI.Texture_edge[BUI.Vars.FramesTexture],h*(half and .8235 or .647),h)
				frame:SetLeadingEdgeTextureCoords(0,1,(half and .5 or 0),1)
			end
		end
	end
--	if v==3 or v==5 then for i,data in pairs(flat) do RedirectTexture("/esoui/art/"..data[1].."/"..data[2],"/BanditsUserInterface/textures/theme/blank.dds") end end
end

function BUI.Frames.ZO_PlayerAttribute_toggle(update)
	local frames={['Health']=POWERTYPE_HEALTH,['Stamina']=POWERTYPE_STAMINA,['Magicka']=POWERTYPE_MAGICKA,['MountStamina']=POWERTYPE_MOUNT_STAMINA,['SiegeHealth']=POWERTYPE_HEALTH,['Werewolf']=POWERTYPE_WEREWOLF}
	--Disables Default Frames
	if not BUI.Vars.DefaultPlayerFrames then
		for name in pairs(frames) do
			local frame=_G["ZO_PlayerAttribute"..name]
			frame:UnregisterForEvent(EVENT_POWER_UPDATE)
			frame:UnregisterForEvent(EVENT_INTERFACE_SETTING_CHANGED)
			frame:UnregisterForEvent(EVENT_PLAYER_ACTIVATED)
			frame:UnregisterForEvent(EVENT_UNIT_CREATED)
			EVENT_MANAGER:UnregisterForUpdate("ZO_PlayerAttribute"..name.."FadeUpdate")
			frame:SetHidden(true)
		end
	--Enables Default Frames
	elseif update then
		for name,powerType in pairs(frames) do
			local frame=_G["ZO_PlayerAttribute"..name]
			local bar=frame.playerAttributeBarObject
			frame:RegisterForEvent(EVENT_POWER_UPDATE, function(_, unitTag, powerPoolIndex, powerType, current, max, effectiveMax) bar:OnPowerUpdate(unitTag, powerPoolIndex, powerType, current, max, effectiveMax) end)
			frame:AddFilterForEvent(EVENT_POWER_UPDATE, REGISTER_FILTER_POWER_TYPE, powerType)
			frame:RegisterForEvent(EVENT_INTERFACE_SETTING_CHANGED, function(_, settingType, settingId) bar:OnInterfaceSettingChanged(settingType, settingId) end)
			frame:AddFilterForEvent(EVENT_INTERFACE_SETTING_CHANGED, REGISTER_FILTER_SETTING_SYSTEM_TYPE, SETTING_TYPE_UI)
			frame:RegisterForEvent(EVENT_PLAYER_ACTIVATED, function() bar:OnPlayerActivated() end)
			EVENT_MANAGER:RegisterForUpdate(frame:GetName() .. "FadeUpdate", 1500, function() bar:UpdateContextualFading() end)
			frame:SetHidden(false)
		end
	end
end

function BUI.Frames.ZO_PlayerAttribute_reposition()
	if not BUI.Vars.DefaultPlayerFrames then return end
	if BUI.Vars.RepositionFrames then
		local _, point, relativeTo, relativePoint, offsetX, offsetY=ZO_PlayerAttributeHealth:GetAnchor()
		if not BUI.Vars.ZO_PlayerAttributeHealth then
			ZO_PlayerAttributeHealth:ClearAnchors()
			ZO_PlayerAttributeHealth:SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY-40)
		end
		if not BUI.Vars.ZO_PlayerAttributeMagicka then
			ZO_PlayerAttributeMagicka:ClearAnchors()
			ZO_PlayerAttributeMagicka:SetAnchor(TOPRIGHT, ZO_PlayerAttributeHealth, BOTTOM, -2.5, 8)
		end
		if not BUI.Vars.ZO_PlayerAttributeStamina then
			ZO_PlayerAttributeStamina:ClearAnchors()
			ZO_PlayerAttributeStamina:SetAnchor(TOPLEFT, ZO_PlayerAttributeHealth, BOTTOM, 2.5, 8)
		end
		if not BUI.Vars.ZO_PlayerAttributeSiegeHealth then
			--Shift to the right siege weapon health and ram control
			ZO_PlayerAttributeSiegeHealth:ClearAnchors()
			ZO_PlayerAttributeSiegeHealth:SetAnchor(CENTER, ZO_PlayerAttributeHealth, CENTER, 300, 0)
		end
		if not BUI.Vars.ZO_RamTopLevel then
			ZO_RAM.control:ClearAnchors()
			ZO_RAM.control:SetAnchor(BOTTOM, ZO_PlayerAttributeHealth, TOP, 300, 0)
		end
	else
		ZO_PlayerAttributeHealth:ClearAnchors()
		ZO_PlayerAttributeHealth:SetAnchor(CENTER, ZO_PlayerAttribute, CENTER, 0, 0)
		ZO_PlayerAttributeMagicka:ClearAnchors()
		ZO_PlayerAttributeMagicka:SetAnchor(RIGHT, ZO_PlayerAttribute, LEFT, 237, 0)
		ZO_PlayerAttributeStamina:ClearAnchors()
		ZO_PlayerAttributeStamina:SetAnchor(LEFT, ZO_PlayerAttribute, RIGHT, -237, 0)
		ZO_PlayerAttributeSiegeHealth:ClearAnchors()
		ZO_PlayerAttributeSiegeHealth:SetAnchor(TOP, ZO_PlayerAttributeHealth, BOTTOM, 0, -1)
	end
end

function BUI.Frames.ZO_Frame_reposition()
	local function SetupFunction(control, data)
		control:SetWidth(GuiRoot:GetRight()-ZO_Compass:GetRight()-40)
		control:SetText(data.text)
		control:SetColor(data.color:UnpackRGBA())
		local align=TEXT_ALIGN_RIGHT	--TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER
		local var=BUI.Vars["ZO_AlertTextNotification"] if var and var[5] then align=var[5] end
		control:SetHorizontalAlignment(align)
		ZO_SoundAlert(data.category, data.soundId)
	end
	ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, ' ')
	local line
	if not BUI.GamepadMode then
		line=ZO_AlertTextNotification:GetChild(1)
--		line.fadingControlBuffer.templates.ZO_AlertLine.setup=SetupFunction
		local var=BUI.Vars["ZO_AlertTextNotification"]
		if var then line.fadingControlBuffer.anchor=ZO_Anchor:New(var[1],GuiRoot,var[2],var[3],var[4]) end
	else
		line=ZO_AlertTextNotificationGamepad:GetChild(1)
--		line.fadingControlBuffer.templates.ZO_AlertLineGamepad.setup=SetupFunction
	end

	local function ApplyTemplateHook(obj,name)
		local ZO_Func=obj['ApplyStyle']
		obj['ApplyStyle']=function(self)
			local result=ZO_Func(self)
			if BUI.Vars[name] then
				local frame=_G[name] frame:ClearAnchors() frame:SetAnchor(BUI.Vars[name][1],GuiRoot,BUI.Vars[name][2],BUI.Vars[name][3],BUI.Vars[name][4])
			end
			return result
		end
	end

	local block={ZO_CompassFrame_Keyboard_Template=true,ZO_CompassFrame_Gamepad_Template=true,ZO_PlayerProgressTemplate=true,ZO_PlayerChampionProgressTemplate=true,ZO_GamepadPlayerProgressTemplate=true,ZO_GamepadPlayerChampionProgressTemplate=true}	--ZO_ActionButton_Keyboard_Template=true
	local ZO_ApplyTemplateToControl=ApplyTemplateToControl
	ApplyTemplateToControl=function(control, templateName) if block[templateName] then return else ZO_ApplyTemplateToControl(control,templateName) end end
	for name in pairs(BUI.DefaultFrames) do
		local var=BUI.Vars[name]
		if var then
			local frame=_G[name]
			if frame then
				if name=='ZO_ActiveCombatTips' then ApplyTemplateHook(ACTIVE_COMBAT_TIP_SYSTEM,'ZO_ActiveCombatTips')
				elseif name=='ZO_CenterScreenAnnounce' then ApplyTemplateHook(CENTER_SCREEN_ANNOUNCE,'ZO_CenterScreenAnnounce')
				elseif name=='ZO_CompassFrame' then ApplyTemplateHook(COMPASS_FRAME,'ZO_CompassFrame') end
				frame:ClearAnchors() frame:SetAnchor(var[1],GuiRoot,var[2],var[3],var[4])
			else
				pl(name.." was not placed")
			end
		end
	end
	if BUI.Vars.RepositionFrames then BUI.Frames.ZO_PlayerAttribute_reposition() end

	ZO_PreHookHandler(ZO_ActionBar1, 'OnShow', function()
		local scenename=SCENE_MANAGER:GetCurrentSceneName() if scenename=="skills" or scenename=="inventory" then return end
		local name="ZO_ActionBar1"
		if BUI.Vars[name] then
			ZO_ActionBar1:ClearAnchors() ZO_ActionBar1:SetAnchor(BUI.Vars[name][1],GuiRoot,BUI.Vars[name][2],BUI.Vars[name][3],BUI.Vars[name][4])
		end
		ZO_ActionBar1KeybindBG:SetHidden(true)
	end)
end

function BUI.Themes_Initialize()
	BUI.abilityframe=BUI.Vars.Theme<=3 and "/esoui/art/actionbar/abilityframe64_up.dds" or "/BanditsUserInterface/textures/theme/abilityframe64_up.dds"
	--Hide keybinds background
	ZO_ActionBar1KeybindBG:SetHidden(true)
	--Change default frames
	BUI.Frames.ZO_PlayerAttribute_toggle()
	if BUI.Vars.RepositionFrames then BUI.Frames.ZO_PlayerAttribute_reposition() end

	EVENT_MANAGER:RegisterForEvent("BUI_Theme_Event", EVENT_PLAYER_ACTIVATED,	function()
		EVENT_MANAGER:UnregisterForEvent("BUI_Theme_Event", EVENT_PLAYER_ACTIVATED)
		BUI.Frames.ZO_Frame_reposition()
		BUI.Themes_Setup()
	end)
end

--[[
ZO_BattlegroundHUDFragmentTopLevelBattlegroundScoreHudTeamsSection1
GetPlayerCameraHeading()
Get3DRenderSpaceForward()
Get3DRenderSpaceOrientation()
Get3DRenderSpaceOrigin()

Convert3DLocalPositionToWorldPosition
--]]