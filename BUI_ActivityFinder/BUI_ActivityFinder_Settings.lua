function BUI_ActivityFinder.SettingsInit()
	local defaults={
		UndauntedPledges=false,
		CollapseNormalDungeon=false,
		DungeonQuests=false,
		AutoQueue=false,
	}
	local menuOptions={
		{type="header",	param="ActivityFinderHeader"},
		{type="checkbox",	param="UndauntedPledges",	warning=true},
		{type="checkbox",	param="DungeonQuests",	warning=true},
		{type="checkbox",	param="CollapseNormalDungeon",	warning=true, disabled=function() return not BUI.Vars.UndauntedPledges end},
		{type="button",	name="Reload UI",func=function() SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8, BUI.Loc("SETTINGS_ReloadingUI")) BUI.CallLater("ReloadUI",1000,ReloadUI) end},
	}
	local name = "26. |t32:32:/esoui/art/treeicons/store_indexicon_bundle_up.dds|t"..BUI.Loc("ACTIVITYFINDER_Label")
	local id = "BUI_MenuActivityFinder"
	local Panel={type="panel", name=name, displayName=name}
	local Options=BUI.Menu.OptionsTransformer(menuOptions, defaults)
	BUI.Menu.RegisterPanel(id, Panel)
	BUI.Menu.RegisterOptions(id, Options)
end