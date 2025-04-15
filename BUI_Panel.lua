--[[	Bandits User Interface Side Panel
Other add-ons can add its own buttons. Example:
local content={
		{	--Button 1
		icon		= Icon texture file name,
		tooltip	= Tooltip text or function (optional),
		context	= Context menu function (optional),
		func		= Click function,
		enabled	= boolean or function (optional)
		},
		{icon="",tooltip="",func=function()end,enabled=true},	--Button 2, etc.
	}
BUI.SidePanel.PanelAdd(content)
--]]

local Defaults = {
	"Enable",
	"AllowOther",
	"Settings",
	"Statistics",
	"Share",
	"HealerHelper",
	"GearManager",
	"Minimap",
	"Compass",
	"LeaderArrow",
	"DismissPets",
	"SubSampling",
--	"VanishPlayers",
	"Widgets",
	"VeteranDifficulty",
	"LFG_Role",
--	"Assistans",
	"Banker",
	"Trader",
	"Smuggler",
	"Armorer",
	"Ragpicker",
--	"Event",
	"WPamA",
	"Teleporter",
}

do	--Default
	local t = {}
	for _,name in pairs(Defaults) do t[name]=true end
	BUI:JoinTables(BUI.Defaults.SidePanel, t)
end

-- START Local Functions
local function CollectibleUnlocked(data)
	for _,id in pairs(data) do
		if (IsCollectibleUnlocked(id)) then return id end
	end
	return false
end
-- END Local Functions

BUI.SidePanel = {}
BUI.SidePanel.VanishPlayers = false -- Appears to be commented out everywhere


-- Sidebar Assistans
-- Notes:
-- You can find the ID for new assistans by searching for the name in collectibles on UESP:
-- https://content3.m.uesp.net/esolog/viewlog.php?search=Tythis+Andromo&searchtype=collectibles
-- You can see detailed information about collectibles by ID on UESP:
-- https://content3.m.uesp.net/esolog/viewlog.php?action=view&record=collectibles&id=267
BUI.SidePanel.Assistans = {}
BUI.SidePanel.Assistans.Armorer = {}
BUI.SidePanel.Assistans.Armorer[1] = 9745 -- Ghrasharog, Armory Assistant
BUI.SidePanel.Assistans.Armorer[2] = 10618 -- Zuqoth, Armory Advisor
BUI.SidePanel.Assistans.Armorer[3] = 11876 -- Drinweth, Valenwood Armorer
BUI.SidePanel.Assistans.Banker = {}
BUI.SidePanel.Assistans.Banker[1] = 267 -- Tythis Andromo, the Banker
BUI.SidePanel.Assistans.Banker[2] = 6376 -- Ezabi the Banker
BUI.SidePanel.Assistans.Banker[3] = 8994 -- Baron Jangleplume, the Banker
BUI.SidePanel.Assistans.Banker[4] = 9743 -- Factotum Property Steward
BUI.SidePanel.Assistans.Banker[5] = 11097 -- Pyroclast, Infernace Conservator
BUI.SidePanel.Assistans.Banker[6] = 12413 -- Eri, Barking Banker
BUI.SidePanel.Assistans.Ragpicker = {}
BUI.SidePanel.Assistans.Ragpicker[1] = 10184 -- Giladil the Ragpicker
BUI.SidePanel.Assistans.Ragpicker[2] = 10617 -- Aderene, Fargrave Dregs Dealer
BUI.SidePanel.Assistans.Ragpicker[3] = 11877 -- Tzozabrar, Dwarven Deconstructor
BUI.SidePanel.Assistans.Smuggler = {}
BUI.SidePanel.Assistans.Smuggler[1] = 300 -- Pirharri the Smuggler
BUI.SidePanel.Assistans.Trader = {}
BUI.SidePanel.Assistans.Trader[1] = 301 -- Nuzhimeh the Merchant
BUI.SidePanel.Assistans.Trader[2] = 6378 -- Fezez the Merchant
BUI.SidePanel.Assistans.Trader[3] = 8995 -- Peddler of Prizes, the Merchant
BUI.SidePanel.Assistans.Trader[4] = 9744 -- Factotum Commerce Delegate
BUI.SidePanel.Assistans.Trader[5] = 11059 -- Hoarfrost, Takubar Trader
BUI.SidePanel.Assistans.Trader[6] = 12414 -- Xyn, Planar Purveyor

-- Sidebar Disabled
BUI.SidePanel.Disabled = {}

-- Sidebar Icons
BUI.SidePanel.Icons = {}
BUI.SidePanel.Icons.AllowOther = "/esoui/art/inventory/gamepad/gp_inventory_icon_miscellaneous.dds"
BUI.SidePanel.Icons.Armorer = "/esoui/art/treeicons/gamepad/gp_collectionicon_weapona+armor.dds"
BUI.SidePanel.Icons.Assistans = "/esoui/art/treeicons/gamepad/gp_collection_indexicon_assistants.dds"
BUI.SidePanel.Icons.Banker = "/esoui/art/icons/mapkey/mapkey_bank.dds"
BUI.SidePanel.Icons.Compass = "/esoui/art/treeicons/gamepad/achievement_categoryicon_exploration.dds"
BUI.SidePanel.Icons.DismissPets = "/esoui/art/treeicons/gamepad/gp_store_indexicon_vanitypets.dds"
BUI.SidePanel.Icons.Enable = "/esoui/art/cadwell/check.dds"
BUI.SidePanel.Icons.Event = "/esoui/art/treeicons/gamepad/achievement_categoryicon_events.dds"
BUI.SidePanel.Icons.HealerHelper = "/esoui/art/lfg/gamepad/lfg_roleicon_healer_down.dds"
BUI.SidePanel.Icons.GearManager = "/esoui/art/treeicons/gamepad/gp_collection_indexicon_upgrade.dds"
BUI.SidePanel.Icons.LeaderArrow = "/esoui/art/compass/groupleader.dds"
BUI.SidePanel.Icons.LFG_Role = "/esoui/art/tutorial/gamepad/gp_lfg_tank.dds"
BUI.SidePanel.Icons.Minimap = "/EsoUI/Art/ZoneStories/completionTypeIcon_pointOfInterest.dds"
BUI.SidePanel.Icons.Ragpicker = "esoui/art/crafting/gamepad/gp_crafting_menuicon_deconstruct.dds"
BUI.SidePanel.Icons.Settings = "/esoui/art/guild/gamepad/gp_guild_menuicon_customization.dds"
BUI.SidePanel.Icons.Share = "esoui/art/treeicons/gamepad/achievement_categoryicon_collections.dds"
BUI.SidePanel.Icons.Smuggler = "/esoui/art/icons/mapkey/mapkey_fence.dds"
BUI.SidePanel.Icons.Statistics = "/esoui/art/menubar/gamepad/gp_playermenu_icon_skills.dds"
BUI.SidePanel.Icons.SubSampling = "/esoui/art/inventory/inventory_icon_visible.dds"
BUI.SidePanel.Icons.Teleporter = "/esoui/art/tutorial/poi_wayshrine_complete.dds"
BUI.SidePanel.Icons.Trader = "/esoui/art/mail/gamepad/gp_mailmenu_attachitem.dds"
-- BUI.SidePanel.Icons.VanishPlayers = "/esoui/art/lfg/gamepad/gp_lfg_icon_groupsize.dds"
BUI.SidePanel.Icons.VeteranDifficulty = "/esoui/art/lfg/gamepad/lfg_menuicon_veteranldungeon.dds"
BUI.SidePanel.Icons.Widgets = "/esoui/art/inventory/inventory_tabicon_items_down.dds"
BUI.SidePanel.Icons.WPamA = "/esoui/art/icons/poi/poi_solotrial_complete.dds"

-- START Export Functions
BUI.SidePanel.Disabled.Widgets = function() return not BUI.Vars.EnableWidgets end
BUI.SidePanel.Disabled.Teleporter = function() return not CTS end
BUI.SidePanel.Disabled.WPamA = function() return not WPamA end
BUI.SidePanel.Disabled.Banker = function() return not CollectibleUnlocked(BUI.SidePanel.Assistans.Banker) end
BUI.SidePanel.Disabled.Trader = function() return not CollectibleUnlocked(BUI.SidePanel.Assistans.Trader) end
BUI.SidePanel.Disabled.Smuggler = function() return not CollectibleUnlocked(BUI.SidePanel.Assistans.Smuggler) end
BUI.SidePanel.Disabled.Armorer = function() return not CollectibleUnlocked(BUI.SidePanel.Assistans.Armorer) end
BUI.SidePanel.Disabled.Ragpicker = function() return not CollectibleUnlocked(BUI.SidePanel.Assistans.Ragpicker) end
BUI.SidePanel.Disabled.GearManager = function() return not BUI_GearShow end
BUI.SidePanel.Disabled.VeteranDifficulty = function() return not CanPlayerChangeGroupDifficulty() end
-- END Export Functions

local PanelContent={
	{	--Settings
	tooltip	=BUI.DisplayName.." settings",
	func	=BUI.Menu.Open,
	var		="Settings"
	},
	{	--Statistics
	tooltip	=function() return GetString(SI_BINDING_NAME_DISPLAY_DAMAGE_REPORT_WINDOW) end,
	func	=BUI.Stats.Toggle,
	var		="Statistics"
	},
	{	--Share
	tooltip	=function() return BUI.Loc("StatShare")..", "..BUI.Loc("StatsUpdateDPS") end,
	func	=function()
		local enabled=(BUI.Vars.StatsUpdateDPS and BUI.Vars.StatShare)
		BUI.Vars.StatsUpdateDPS=not enabled
		BUI.Vars.StatShare=not enabled
		BUI.StatShare.Initialize() BUI.Frames.Raid_UI() BUI.Frames:SetupGroup()
	end,
	enabled	=function()return BUI.Vars.StatsUpdateDPS and BUI.Vars.StatShare end,
	var		="Share"
	},
	{	--Healer helper
	tooltip	="Healer helper",
	func	=BUI.Helper_Toggle,
	var		="HealerHelper"
	},
	{	--Gear manager
	tooltip	="Gear Manager",
	func	=function()BUI_GearShow()end,
	var		="GearManager",
	disabled	=function() return not BUI_GearShow end
	},
	{	--Minimap
	tooltip	=function() return GetString(SI_BINDING_NAME_TOGGLE_MINIMAP) end,
	func	=function()BUI.Vars.MiniMap=not BUI.Vars.MiniMap BUI.MiniMap.ReInit()end,
	enabled	=function()return BUI.Vars.MiniMap end,
	var		="Minimap"
	},
	{	--Compass
	tooltip	=function() return GetString(SI_BINDING_NAME_TOGGLE_COMPASS) end,
	func	=function()BUI.Compass=not BUI.Compass BUI.Compass_Init()end,
	enabled	=function()return BUI.Compass end,
	var		="Compass"
	},
	{	--Leader arrow
	tooltip	=function() return BUI.Loc("LeaderArrow") end,
	func	=function()BUI.Vars.LeaderArrow=not BUI.Vars.LeaderArrow BUI.Reticle.LeaderArrow() end,
	enabled	=function()return BUI.Vars.LeaderArrow end,
	var		="LeaderArrow"
	},
	{	--Dismiss pets
	tooltip	=function() return GetString(SI_BINDING_NAME_BUI_DISMISS_ALL) end,
	func	=BUI.DismissPets,
	var		="DismissPets",
	disabled	=function()local class=GetUnitClassId('player') return class~=2 and class~=4 end	--and class~=5
	},
	{	--SubSampling Quality
	tooltip	=GetString(SI_GRAPHICS_OPTIONS_VIDEO_SUB_SAMPLING),
	func	=function()local val=tonumber(GetSetting(SETTING_TYPE_GRAPHICS,GRAPHICS_SETTING_SUB_SAMPLING)) val=val<2 and 2 or 1 SetSetting(SETTING_TYPE_GRAPHICS,GRAPHICS_SETTING_SUB_SAMPLING,tostring(val)) end,
	enabled	=function()return GetSetting(SETTING_TYPE_GRAPHICS,GRAPHICS_SETTING_SUB_SAMPLING)=="2" end,
	var		="SubSampling"
	},
--[[
	{	--Vanish players
	tooltip	=function() return BUI.Loc("VanishPlayersDesc") end,
	func		=function()VanishPlayers=not VanishPlayers SetCrownCrateNPCVisible(VanishPlayers)end,
	enabled	=function()return VanishPlayers end,
	var		="VanishPlayers"
	},
--]]
	{	--Manage widgets
	tooltip	=function() return BUI.Loc("WidgetsManage") end,
	func		=function()BUI.Menu.ManageWidgets(true)end,
	disabled	=function()return not BUI.Vars.EnableWidgets end,
	var		="Widgets"
	},
	{divider=true},
	{	--VeteranDifficulty
	icons		={[true]="/esoui/art/lfg/gamepad/lfg_menuicon_veteranldungeon.dds",[false]="/esoui/art/lfg/gamepad/lfg_menuicon_normaldungeon.dds"},
	tooltip	="Dungeons normal/veteran difficulty",
	func		=function(self)
		local dif=not IsUnitUsingVeteranDifficulty('player')
		SetVeteranDifficulty(dif)
		self:SetTexture(self.data.icons[dif])
		local control=ZO_GroupListVeteranDifficultySettings
		if control then
			control.veteranModeButton:SetState(dif and BSTATE_PRESSED or BSTATE_NORMAL)
			control.normalModeButton:SetState(dif and BSTATE_NORMAL or BSTATE_PRESSED)
		end
	end,
	enabled	=CanPlayerChangeGroupDifficulty,
	switch	=function()return IsUnitUsingVeteranDifficulty('player') end,
	var		="VeteranDifficulty"
	},
	{	--Role
	icons	={[LFG_ROLE_DPS]="/esoui/art/tutorial/gamepad/gp_lfg_dps.dds",[LFG_ROLE_TANK]="/esoui/art/tutorial/gamepad/gp_lfg_tank.dds",[LFG_ROLE_HEAL]="/esoui/art/tutorial/gamepad/gp_lfg_healer.dds"},
	tooltip	="Group role",
	func	=function(self)
		local role=GetSelectedLFGRole()+1 if role==3 then role=4 elseif role>4 then role=1 end
		UpdateSelectedLFGRole(role)
		self:SetTexture(self.data.icons[role])
	end,
	enabled	=CanUpdateSelectedLFGRole,
	switch	=GetSelectedLFGRole,
	var		="LFG_Role"
	},
	{divider=true},
	{	--Banker
	icon	="/esoui/art/icons/mapkey/mapkey_bank.dds",
	func	=function()
--			local id=IsCollectibleUnlocked(9743) and 9743 or IsCollectibleUnlocked(8994) and 8994 or IsCollectibleUnlocked(6376) and 6376 or 267
			local id=BUI.Vars.SidePanel.Banker
			if id == 1 or id == true then id = CollectibleUnlocked(BUI.SidePanel.Assistans.Banker) end
			UseCollectible(id)
			SCENE_MANAGER:SetInUIMode()
		end,
	tooltip	=GetString(SI_INTERACT_OPTION_BANK),
	var		="Banker",
	disabled = BUI.SidePanel.Disabled.Banker
	},
	{	--Trader
	icon	="/esoui/art/mail/gamepad/gp_mailmenu_attachitem.dds",
	func	=function()
			local id=BUI.Vars.SidePanel.Trader
			if id == 1 or id == true then id = CollectibleUnlocked(BUI.SidePanel.Assistans.Trader) end
			UseCollectible(id)
			SCENE_MANAGER:SetInUIMode()
		end,
	tooltip	=GetString(SI_GAMEPAD_GUILD_KIOSK_TRADER_HEADER),
	var		="Trader",
	disabled = BUI.SidePanel.Disabled.Trader
	},
	{	--Smuggler
	icon	="/esoui/art/icons/mapkey/mapkey_fence.dds",
	func	=function()
			local id=BUI.Vars.SidePanel.Smuggler
			if id == 1 or id == true then id = CollectibleUnlocked(BUI.SidePanel.Assistans.Smuggler) end
			UseCollectible(id)
			SCENE_MANAGER:SetInUIMode()
			end,
	tooltip	="Smuggler",
	var		="Smuggler",
	disabled = BUI.SidePanel.Disabled.Smuggler
	},
	{	--Armorer
	icon	="/esoui/art/treeicons/gamepad/gp_collectionicon_weapona+armor.dds",	--/esoui/art/crafting/smithing_multiple_armorweaponslot.dds
	func	=function()
			local id=BUI.Vars.SidePanel.Armorer
			if id == 1 or id == true then id = CollectibleUnlocked(BUI.SidePanel.Assistans.Armorer) end
			UseCollectible(id)
			SCENE_MANAGER:SetInUIMode()
		end,
	tooltip	="Armorer",
	var		="Armorer",
	disabled	= BUI.SidePanel.Disabled.Armorer
	},
	{	--Ragpicker
	icon	="esoui/art/crafting/gamepad/gp_crafting_menuicon_deconstruct.dds",
	func	=function()
			local id=BUI.Vars.SidePanel.Ragpicker
			if id == 1 or id == true then id = CollectibleUnlocked(BUI.SidePanel.Assistans.Ragpicker) end
			UseCollectible(id)
			SCENE_MANAGER:SetInUIMode()
		end,
	tooltip	="Ragpicker",
	var		="Ragpicker",
	disabled	= BUI.SidePanel.Disabled.Ragpicker
	},
--[[
	{	--Jubilee event
	func		=function()UseCollectible(7619)SCENE_MANAGER:SetInUIMode()end,
	tooltip	="Jubilee Cake 2020",
	var		="Event",
	disabled	=GetDate()-20190000>10414
	},
	{	--Halloween event
	func		=function()UseCollectible(479)SCENE_MANAGER:SetInUIMode()end,
	tooltip	="Halloween Event",
	var		="Event",
	disabled	=GetDate()-20190000>1211
	},
--]]
	{divider=true},
	{	--What pledges of my alts add-on
	icon		="/esoui/art/icons/mapkey/mapkey_groupinstance.dds",
	func		=function()WPamA.ChangeUIModeClnd()end,
	tooltip	=function()return WPamA.i18n.KeyBindClndStr end,
	var		="WPamA",
	disabled	=function()return not WPamA end
	},
	{	--What pledges of my alts add-on
	icon		="/esoui/art/icons/mapkey/mapkey_raiddungeon.dds",
	func		=function()WPamA.ChangeUIModeTrial()end,
	tooltip	=function()return WPamA.i18n.KeyBindTrialStr end,
	var		="WPamA",
	disabled	=function()return not WPamA end
	}
}

local function UI_Init()
	local eventFrames={ZO_SharedRightPanelBackground,ZO_TopBar,ZO_GameMenu_InGame}
	if not BUI.Vars.SidePanel.Enable then
		if BUI_Panel then BUI_Panel:SetHidden(true) end
		return
	end
	local w,space,div,i,total,last=26,2,0,0,0
	local color_on,color_off={.6,.57,.46,1},{.3,.3,.2,1}	--{.7,.3,.2,1}
	local top=GuiRoot:GetHeight()-ZO_ChatWindowMinBar:GetTop()/2-70

	local function Panel_Show()
		for i=1,total do
			local button=_G["BUI_PanelButton"..i]
			if button and button.data then
				local enabled=button.data.enabled==nil and true or type(button.data.enabled)=="boolean" and button.data.enabled or button.data.enabled()
				local color=enabled and color_on or color_off
				button:SetColor(unpack(color))
				if button.data.switch then
					button:SetTexture(button.data.icons[button.data.switch()])
				end
			end
		end
		BUI_Panel:SetHidden(false)
	end

	local control=BUI_Panel or WINDOW_MANAGER:CreateTopLevelWindow("BUI_Panel")
	--Bg
	local bg=BUI_PanelBg or WINDOW_MANAGER:CreateControl("$(parent)Bg", control, CT_BACKDROP)
	bg:SetCenterTexture("/esoui/art/chatwindow/chat_bg_center.dds")
	bg:SetEdgeTexture("/esoui/art/chatwindow/chat_bg_edge.dds", 256, 128, w/2+10)
	bg:ClearAnchors()
	bg:SetAnchor(TOPLEFT,control,TOPLEFT,-10,-10)
	bg:SetAnchor(BOTTOMRIGHT,control,BOTTOMRIGHT,10,10)
	bg:SetCenterColor(1,1,1,0)
	bg:SetEdgeColor(1,1,1,0.5)
	if BUI.Vars.Theme==7 then
		local a_color={BUI.Vars.AdvancedThemeColor[1],BUI.Vars.AdvancedThemeColor[2],BUI.Vars.AdvancedThemeColor[3],BUI.Vars.AdvancedThemeColor[4]/2}
		local points={
			{BUI_Panel,TOPRIGHT,-5,-5},
			{BUI_Panel,TOPRIGHT,5,5},
			{BUI_Panel,BOTTOMRIGHT,5,-5},
			{BUI_Panel,BOTTOMRIGHT,-5,5},
		}
		BUI.UI.Path(nil, control, points, a_color, 2)
		bg:SetHidden(true)
	end
	for _,data in pairs(PanelContent) do
		local disabled=type(data.disabled)=="function" and data.disabled() or false
		if data.divider and last~="divider" then
			i=i+1
			local button=_G["BUI_PanelButton"..i] or WINDOW_MANAGER:CreateControl("$(parent)Button"..i, control, CT_TEXTURE)
			button:SetDimensions(w,8)
			button:ClearAnchors()
			button:SetAnchor(TOPLEFT,control,TOPLEFT,0,(w+space)*(i-1)-(w-8)*div)
			button:SetHidden(false)
			button:SetTexture("/EsoUI/Art/Miscellaneous/horizontalDivider.dds")
			button:SetColor(1,1,1,1)
			button:SetMouseEnabled(false)
			button.data=nil
			div=div+1
			last="divider"
		elseif BUI.Vars.SidePanel[data.var] and BUI.Vars.SidePanel[data.var]~=0 and not disabled then
			i=i+1
			local button=_G["BUI_PanelButton"..i] or WINDOW_MANAGER:CreateControl("$(parent)Button"..i, control, CT_TEXTURE)
			button:SetDimensions(w,w)
			button:ClearAnchors()
			button:SetAnchor(TOPLEFT,control,TOPLEFT,0,(w+space)*(i-1)-(w-8)*div)
			button:SetHidden(false)
			button:SetTexture(data.icon or BUI.SidePanel.Icons[data.var])
			button:SetColor(unpack(color_on))
			button:SetMouseEnabled(true)
			button:SetHandler("OnMouseEnter", function(self)
				self:SetColor(.9,.9,.8,1)
				if data.tooltip then
					ZO_Tooltips_ShowTextTooltip(self, BOTTOMRIGHT, (type(data.tooltip)=="string" and data.tooltip or data.tooltip()))
				end
				if BUI_Panel.context then BUI_Panel.context:SetHidden(true) end
				if data.context then control.context=data.context(self) end
			end)
			button:SetHandler("OnMouseExit", function(self)
				local enabled=data.enabled==nil and true or type(data.enabled)=="boolean" and data.enabled or data.enabled()
				local color=enabled and color_on or color_off
				self:SetColor(unpack(color))
				if data.tooltip then ZO_Tooltips_HideTextTooltip() end
			end)
			button:SetHandler("OnMouseDown", function(self)
				if BUI_Panel.context then BUI_Panel.context:SetHidden(true) end
				data.func(self)
				local enabled=data.enabled==nil and true or type(data.enabled)=="boolean" and data.enabled or data.enabled()
				local color=enabled and color_on or color_off
				self:SetColor(unpack(color))
			end)
			button.data=data
			last=nil
		end
	end
	if last=="divider" then local button=_G["BUI_PanelButton"..i] if button then button:SetHidden(true) end i=i-1 div=div-1 end
	control:ClearAnchors()
	control:SetAnchor(BOTTOMLEFT,GuiRoot,TOPLEFT,0,top)
	control:SetHidden(not BUI.inMenu)
	control:SetDimensions(w,(w+space)*i-(w-8)*div)
	total=i
	for index=total+1, 20 do local button=_G["BUI_PanelButton"..index] if button then button:SetHidden(true) end end
	--Events
	local function RegisterEvent(on)
		if on then
			EVENT_MANAGER:RegisterForEvent("BUI_Panel_Event", EVENT_RETICLE_HIDDEN_UPDATE, function(_,hidden)
				if not BUI.Vars.SidePanel.Enable then return end
				if hidden then
					local interact=IsPlayerInteractingWithObject()
					if not interact then Panel_Show() end
				else
					BUI_Panel:SetHidden(true)
					if BUI_Panel.context then BUI_Panel.context:SetHidden(true) end
				end
			end)
		else
			EVENT_MANAGER:UnregisterForEvent("BUI_Panel_Event", EVENT_RETICLE_HIDDEN_UPDATE)
		end
	end
	for _,frame in pairs(eventFrames) do
		frame:SetHandler('OnEffectivelyShown',function()
			RegisterEvent(false)
			BUI_Panel:SetHidden(true)
			if BUI_Panel.context then BUI_Panel.context:SetHidden(true) end
		end)
		frame:SetHandler('OnEffectivelyHidden',function()if BUI.Vars.SidePanel.Enable then RegisterEvent(true) end end)
	end

	RegisterEvent(true)
end

local function Menu_Init()
	BUI.Menu.RegisterPanel("BUI_MenuSidePanel",
	{
		type="panel",
		name="2.  |t32:32:/esoui/art/tutorial/ordering_up.dds|t"..BUI.Loc("PanelHeader"),
		displayName="2. "..BUI.Loc("PanelHeader"),
	})

	--Extrimely ugly part. Hate LUA, hate users requests...
	local AssistansNames={}
	local AssistansValues={}
	local AssistansIndexes={}
	for var, data in pairs(BUI.SidePanel.Assistans) do
		temp={
			[0]=BUI.GetIcon('esoui/art/contacts/tabicon_ignored_up.dds',32).." Disabled",
			[1]=BUI.GetIcon('/esoui/art/help/help_tabicon_feedback_up.dds',32).." Auto"
		}
		for _,id in pairs(data) do
			local name,desc,icon,_,unlocked=GetCollectibleInfo(id)
			if unlocked then
				temp[id]=BUI.GetIcon(icon,32).." "..tostring(name)
			end
		end
		AssistansNames[var]={}
		AssistansValues[var]={}
		AssistansIndexes[var]={}
		local i=1
		for id,val in pairs(temp) do
			AssistansNames[var][i]=val
			AssistansValues[var][i]=id
			AssistansIndexes[var][id]=i
			i=i+1
		end
	end

	local Options={}
	for _,var in pairs(Defaults) do
		table.insert(Options,
		{
		type = BUI.SidePanel.Assistans[var] and "dropdown" or "checkbox",
		icon = BUI.SidePanel.Icons[var],
		name		="Panel"..var,
		choices		=AssistansNames[var],	--nil if var is not key of Assistans
		getFunc = BUI.SidePanel.Assistans[var] and
					function()
						local value=BUI.Vars.SidePanel[var]
						local res=value
						if type(value)=='boolean' then res=value and 1 or 0 end
						local index=AssistansIndexes[var][res]
--						d(tostring(var)..': '..tostring(res)..' ('..tostring(index)..')')
						return index
					end
					or
					function() return BUI.Vars.SidePanel[var] end,
		setFunc = BUI.SidePanel.Assistans[var] and
					function(i,value) BUI.Vars.SidePanel[var]=AssistansValues[var][i] UI_Init() end
					or
					function(value) BUI.Vars.SidePanel[var]=value UI_Init() end,
		disabled	=BUI.SidePanel.Disabled[var]
		})
	end
	BUI.Menu.RegisterOptions("BUI_MenuSidePanel", Options)
	BUI_MenuSidePanel:SetHandler("OnEffectivelyShown",function()BUI.inMenu=true if BUI_Panel then BUI_Panel:SetHidden(false)end end)
	BUI_MenuSidePanel:SetHandler("OnEffectivelyHidden",function()BUI.inMenu=false if BUI_Panel then BUI_Panel:SetHidden(true)end end)
end

function BUI.SidePanel.PanelAdd(content)
	if content and type(content)=="table" then
		table.insert(PanelContent,{divider=true})
		for _,data in pairs(content) do
			if data.divider then
				PanelContent[#PanelContent+1]={divider=true}
			elseif (data.icon and type(data.icon)=="string")
			and	(data.func and type(data.func)=="function")
			then
				PanelContent[#PanelContent+1]={
					icon=data.icon,
					tooltip=(type(data.tooltip)=="string" or type(data.tooltip)=="function") and data.tooltip or nil,
					context=type(data.context)=="function" and data.context or nil,
					func=data.func,
					enabled=data.enabled,
					var=data.var or "AllowOther"
				}
			end
		end
	end
	if BUI.Vars.SidePanel.Enable then UI_Init() end
end

function BUI.SidePanel.Initialize()
	Menu_Init()
	BUI.CallLater("SidePanel",500,function() if BUI.Vars.SidePanel.Enable then UI_Init() end end)
end

-- Legacy Init Function called Externally - kept for compatibility but should be refactored out
BUI.PanelAdd = BUI.SidePanel.PanelAdd -- Bandit's Companions rely's on this
BUI.Panel_Init = BUI.SidePanel.Initialize