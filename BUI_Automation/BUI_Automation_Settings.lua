function BUI_Automation.SettingsInit()
  local defaults = {
		-- Main Defaults
    DeleteMail = false,
    GroupLeave = false,
    Books = false,
    LargeGroupInvite = true,
    FastTravel = false,
    InitialDialog = false,
    RepeatableQuests = false,
    DarkBrotherhoodSpree = false,
    ContainerHandler = false,
		StealthWield = false,
		LootStolen = false,
    ConfirmLocked = false,
		-- Blocking Defaults
    AdvancedSynergy = false,
    JumpToLeader = false,
    LargeGroupAnnoucement = true,
    FriendStatus = false,
    BlockAnnouncement = false,
    HousePins = 4,
		-- Improvements Defaults
    PlayerToPlayer = false,
    BuiltInGlobalCooldown = false,
    AutoDismissPet = true,
	}
	local menuOptions = {
    -- Main Options
		{type="header",	param="AutomationHeader"},
		{type="checkbox",	param="DeleteMail",		warning=true},
		{type="checkbox",	param="GroupLeave",		warning=true},
		{type="checkbox",	param="Books",			warning=true},
		{type="checkbox",	param="LargeGroupInvite",	warning=true},
		{type="checkbox",	param="FastTravel",		warning=true},
		{type="checkbox",	param="InitialDialog",		warning=true},
		{type="checkbox",	param="RepeatableQuests",	warning=true},
		{type="checkbox",	param="DarkBrotherhoodSpree",	warning=true},
		{type="checkbox",	param="ContainerHandler",	warning=true},
		{type="checkbox",	param="StealthWield",		warning=true},
		{type="checkbox",	param="LootStolen",		warning=true},
		{type="checkbox",	param="ConfirmLocked"},
    -- Blocking Options
    {type="header",	param="BlockingsHeader"},
		{type="checkbox",	param="AdvancedSynergy"},
		{type="checkbox",	param="JumpToLeader",		warning=true},
		{type="checkbox",	param="LargeGroupAnnoucement",warning=true},
		{type="checkbox",	param="FriendStatus",		warning=true},
		{type="checkbox",	param="BlockAnnouncement",	warning=true},
		{type="dropdown",	param="HousePins",		warning="ReloadUiWarn3", choices={"All","Owned","Unowned","Disabled"}},
    -- Improvements
    {type="header",	param="ImprovementsHeader"},
		{type="checkbox",	param="PlayerToPlayer",		warning=true},
		{type="checkbox",   param="BuiltInGlobalCooldown", warning=true},
		{type="checkbox",   param="AutoDismissPet", warning=true},
		{type="button",	name="Reload UI",func=function() SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8,"Reloading UI") BUI.CallLater("ReloadUI",1000,ReloadUI) end},
	}
	local name = "18. |t32:32:/esoui/art/treeicons/store_indexicon_bundle_up.dds|t"..BUI.Loc("AutomationHeader")
	local id = "BUI_MenuAutomation"
	local Panel={type="panel", name=name, displayName=name}
	local Options=BUI.Menu.OptionsTransformer(menuOptions, defaults)
	BUI.Menu.RegisterPanel(id, Panel)
	BUI.Menu.RegisterOptions(id, Options)
end