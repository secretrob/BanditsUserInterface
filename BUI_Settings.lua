-- MENU OPTIONS COMPONENT
local MenuOptions,MenuPanel,MenuHandlers={},{},{}
local TexturesList={} for t in pairs(BUI.Textures) do table.insert(TexturesList,t) end
local MoveMode_1,MoveMode_2=true,true
local move_init,move_anchor
local MenuIcon={
MenuMisc="/esoui/art/login/authentication_trusted_up.dds",
MenuReticle="/esoui/art/icons/guildranks/guild_indexicon_misc03_up.dds",
MenuPlayerFrames="/esoui/art/mainmenu/menubar_character_up.dds",
--MenuCurvedFrames="/esoui/art/mainmenu/menubar_character_up.dds",
MenuAttackersFrames="/esoui/art/treeicons/collection_indexicon_weapons+armor_up.dds",
MenuTargetFrames="/esoui/art/treeicons/tutorial_idexicon_death_up.dds",
MenuGroupFrames="/esoui/art/lfg/lfg_indexicon_group_up.dds",
MenuStatShare="/esoui/art/mainmenu/menubar_collections_up.dds",
MenuDamageStatistics="/esoui/art/mainmenu/menubar_skills_up.dds",
MenuBuffs="/esoui/art/progression/morph_up.dds",
MenuActions="/esoui/art/treeicons/tutorial_idexicon_timedactivities_up.dds",
MenuNotifications="/esoui/art/help/help_tabicon_tutorial_up.dds",
MenuMinimap="/esoui/art/icons/achievements_indexicon_exploration_up.dds",
MenuFrameColors="/esoui/art/tutorial/dyes_tabicon_dye_up.dds",
MenuMeters="esoui/art/treeicons/housing_indexicon_structures_up.dds",
MenuMarkers="/esoui/art/guild/guild_indexicon_leader_up.dds",
}
local MenuNumber={
MenuMisc		="1.  ",
MenuPlayerFrames	="3.  ",
MenuAttackersFrames="4.  ",
--MenuCurvedFrames	="4.  ",
MenuGroupFrames	="5.  ",
--MenuStatShare	="5.  ",
MenuTargetFrames	="6.  ",
MenuActions		="7.  ",
MenuBuffs		="8.  ",
MenuMinimap		="9.  ",
MenuReticle		="10. ",
MenuDamageStatistics="11. ",
MenuNotifications	="12. ",
MenuFrameColors	="13. ",
MenuMeters		="21. ",
MenuMarkers		="22. ",
}
local GroupDeathSounds={
"No_Sound",
"Outfitting_WeaponAdd_Mace",
"Outfitting_ArmorAdd_Light",
"Telvar_Gained",
"Undaunted_Transact",
"Lockpicking_unlocked",
}
local NotificationSounds={
"No_Sound",
"Justice_StateChanged",
"GiftInventoryView_FanfareSparks",
"New_Notification",
"BG_CTF_FlagReturned",
"LevelUpReward_Claim",
"InventoryItem_ApplyEnchant",
"Console_Game_Enter",
"Raid_Trial_Failed",
"Champion_PointsCommitted",
"BG_CTF_FlagCaptured",
"Quest_Complete",
}
local ProcSounds={
"No_Sound",
"Collectible_On_Cooldown",
"Telvar_MultiplierMax",
"Justice_PickpocketBonus",
"BG_MB_BallTaken_OtherTeam",
"Telvar_MultiplierUp",
"Ability_MorphPurchased",
"Objective_Complete",
"Telvar_Gained",
"CrownCrates_Card_Flipping",
"GiftInventoryView_FanfareSparks",
"CrownCrates_Manifest_Selected",
"CrownCrates_Manifest_Chosen",
"Ability_UpgradePurchased",
"Ability_Ultimate_Ready_Sound",
}
local function MenuMiscAdditional()
	--Add additional elements
	local mode1	=BUI.UI.Button(	"BUI_Menu_Move1_Sw",	BUI_MenuMisc,	{26,26},	{BOTTOM,TOP,-10,0,BUI_MenuButton_Move},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	mode1:SetNormalTexture(MoveMode_1 and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds")
	mode1:SetHandler("OnClicked", function(self) MoveMode_1=not MoveMode_1 self:SetNormalTexture(MoveMode_1 and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds") end)
	BUI.UI.Label(	"BUI_Menu_Move1_Label",	mode1,		{60,26},		{RIGHT,LEFT,-4,0},		BUI.UI.Font("standard",18,true), {.8,.8,.6,1}, {2,1}, "Bandits",	false)
	local mode2	=BUI.UI.Button(	"BUI_Menu_Move2_Sw",	BUI_MenuMisc,	{26,26},	{BOTTOM,TOP,90,0,BUI_MenuButton_Move},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	mode2:SetNormalTexture(MoveMode_2 and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds")
	mode2:SetHandler("OnClicked", function(self) MoveMode_2=not MoveMode_2 self:SetNormalTexture(MoveMode_2 and "/esoui/art/cadwell/checkboxicon_checked.dds" or "esoui/art/cadwell/checkboxicon_unchecked.dds") end)
	BUI.UI.Label(	"BUI_Menu_Move2_Label",	mode2,		{60,26},		{RIGHT,LEFT,-4,0},		BUI.UI.Font("standard",18,true), {.8,.8,.6,1}, {2,1}, "Default",	false)
end

ZO_Dialogs_RegisterCustomDialog("BUI_RESET_CONFIRMATION", {
	gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC, allowShowOnNextScene=true},
	title={text=SI_CUSTOMER_SERVICE_SUBMIT_CONFIRMATION},
	mainText=function(dialog) return {text=dialog.data.text} end,
	buttons=
		{
			{text=SI_OK,callback=function(dialog)dialog.data.func()end,keybind="DIALOG_PRIMARY",clickSound=SOUNDS.DIALOG_ACCEPT},
			{text=SI_DIALOG_CANCEL,keybind="DIALOG_NEGATIVE",clickSound=SOUNDS.DIALOG_ACCEPT}
		}
	}
)

local function MenuOptions_Init()	--Menu options
	BUI.Menu.Black_List,BUI.Menu.Black_List_Values=BUI.Menu.MakeList(BUI.Vars.BuffsBlackList)
	BUI.Menu.Custom_List,BUI.Menu.Custom_List_Values=BUI.Menu.MakeList(BUI.Vars.CustomBuffs)
--	local Widgets_List,Widgets_List_Values=BUI.Menu.MakeList(BUI.Vars.Widgets)

	MenuOptions["MenuMisc"]={
	--Reposition Elements
	{	type		="button",
		name		="Move",
		func		=function() BUI.Menu.MoveFrames(true) end,
		reference	="BUI_MenuButton_Move",
	},
	--Reset Default Frames
	{	type		="button",
		name		="ResetPositions",
		func		=function()ZO_Dialogs_ShowDialog ("BUI_RESET_CONFIRMATION", {text=BUI.Loc("ResetPositionsDesc"),func=function()BUI.Menu.Reset("Positions")end})end,
		reference	="BUI_MenuButton_Reset",
	},
	--Theme
	{	type		="header", name="Theme"},
	{	type		="dropdown",
		name		="Theme",
		choices	={"Standard","Standard smooth","Standard flat","Custom gloss","Custom flat","Pink pony","Advanced"},
--		choicesValues={1,2,3,4,5,6,7},
		getFunc	=function() return BUI.Vars.Theme end,
		setFunc	=function(i,value)
			if i==BUI.Vars.Theme then
				--Do nothing
			else
				BUI.Vars.Theme=i BUI.Themes_Setup(true) SCENE_MANAGER:SetInUIMode(false) a("Changing theme: Done")
			end
		end,
	},
	--Frames Texture
	{	type		="dropdown",
		name		="FramesTexture",
		choices	=TexturesList,
		getFunc	=function() return BUI.Vars.FramesTexture end,
		setFunc	=function(i,value) BUI.Menu.UpdateFrames("FramesTexture", value) end,
	},
	--Custom theme Color
	{	type		="colorpicker",
		name		="CustomEdgeColor",
		getFunc	=function() return BUI.Vars.CustomEdgeColor[1],BUI.Vars.CustomEdgeColor[2],BUI.Vars.CustomEdgeColor[3] end,
		setFunc	=function(r,g,b,a) BUI.Vars.CustomEdgeColor={math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1} BUI.Themes_Setup(true) end,
	},
	--Advanced theme Color
	{	type		="colorpicker",
		name		="AdvancedThemeColor",
		getFunc	=function() return BUI.Vars.AdvancedThemeColor[1],BUI.Vars.AdvancedThemeColor[2],BUI.Vars.AdvancedThemeColor[3],BUI.Vars.AdvancedThemeColor[4] end,
		setFunc	=function(r,g,b,a) BUI.Vars.AdvancedThemeColor={math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100, math.floor(a*100)/100} if BUI.Vars.Theme==7 then BUI.Themes_Setup(true) end end,
	},
	--QuickSlots
	{	type		="header",
		name		="QuickSlotsHeader",
	},
	{	type		="checkbox",
		name		="QuickSlots",
		getFunc	=function() return BUI.Vars.QuickSlots end,
		setFunc	=function(value) BUI.Vars.QuickSlots=value BUI.QuickSlots:Initialize() end,
	},
	{	type		="checkbox",
		name		="QuickSlotsInventory",
		getFunc	=function() return BUI.Vars.QuickSlotsInventory end,
		setFunc	=function(value) BUI.Vars.QuickSlotsInventory=value BUI.QuickSlots:Initialize() end,
	},
	--QuickSlots number
	{	type		="slider",
		name		="QuickSlotsShow",
		min		=3,
		max		=8,
		step		=1,
		getFunc	=function() return BUI.Vars.QuickSlotsShow end,
		setFunc	=function(value) BUI.Vars.QuickSlotsShow=value BUI.QuickSlots.Update() end,
	},
	--Misc
	{	type		="header",
		name		="MiscHeader1",
	},
	--Change language
	{	type		="dropdown",
		name		="ChangeLanguage",
		choices	={"en", "ru", "de", "fr", "jp","it","br"},
		getFunc	=function() return BUI.language end,
		setFunc	=function(i,value) SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8,"Reloading UI") BUI.CallLater("Language",1000,SetCVar,"Language.2",value) end,
		warning	="ChangeLanguageWarn",
	},
--[[	--Player attributes section
	{	type		="checkbox",
		name		="PlayerStatSection",
		getFunc	=function() return BUI.Vars.PlayerStatSection end,
		setFunc	=function(value) BUI.Vars.PlayerStatSection=value end,
		warning	=true,
		disabled	=function() return BUI.API>100033 end,
	},
--]]
	--PvPmode
	{	type		="checkbox",
		name		="PvPmode",
		getFunc	=function() return BUI.Vars.PvPmode end,
		setFunc	=function(value) BUI.Vars.PvPmode=value end,
	},
--[[	--Champion system helper
	{	type		="checkbox",
		name		="ChampionHelper",
		getFunc	=function() return BUI.Vars.ChampionHelper end,
		setFunc	=function(value) BUI.Vars.ChampionHelper=value BUI.Champion_Init() end,
		disabled	=function() return BUI.API>100033 end,
	},
--]]
	--Reset Addon
	{	type		="button",
		name		="Reset",
		func		=function()ZO_Dialogs_ShowDialog ("BUI_RESET_CONFIRMATION", {text=BUI.Loc("ResetDesc"),func=BUI.Menu.Reset})end,
	}}
	MenuPanel["MenuMisc"]={name="MiscHeader"}
	MenuHandlers["MenuMisc"]={
	OnEffectivelyShown=function()BUI.CallLater("MenuMisc",100,MenuMiscAdditional)end,
	OnEffectivelyHidden=function() BUI.inMenu=false end,
	}

	MenuOptions["MenuReticle"]={
	{	type		="checkbox",
		name		="LeaderArrow",
		getFunc	=function() return BUI.Vars.LeaderArrow end,
		setFunc	=function(value) BUI.Vars.LeaderArrow=value BUI.Reticle.LeaderArrow() end,
	},
	{	type		="checkbox",
		name		="InCombatReticle",
		getFunc	=function() return BUI.Vars.InCombatReticle end,
		setFunc	=function(value) BUI.Vars.InCombatReticle=value end,
	},
	{	type		="checkbox",
		name		="PreferredTarget",
		getFunc	=function() return BUI.Vars.PreferredTarget end,
		setFunc	=function(value) BUI.Vars.PreferredTarget=value end,
	},
	{	type		="checkbox",
		name		="ReticleDpS",
		getFunc	=function() return BUI.Vars.ReticleDpS end,
		setFunc	=function(value) BUI.Vars.ReticleDpS=value end,
		disabled	=function() return not BUI.Vars.StatsMiniMeter end,
	},
	{	type		="checkbox",
		name		="ReticleInvul",
		getFunc	=function() return BUI.Vars.ReticleInvul end,
		setFunc	=function(value) BUI.Vars.ReticleInvul=value if value then BUI.Target:Initialize() end end,
	},
	--Crusher timer
	{	type		="checkbox",
		name		="CrusherTimer",
		getFunc	=function() return BUI.Vars.CrusherTimer end,
		setFunc	=function(value) BUI.Vars.CrusherTimer=value end,
	},
	--Taunt timer
	{	type		="dropdown",
		name		="TauntTimer",
		choices	={"Progress bar","Bar and number","Number only","Disabled"},
		getFunc	=function() return BUI.Vars.TauntTimer end,
		setFunc	=function(i,value) BUI.Vars.TauntTimer=i end,
	},
	{	type		="checkbox",
		name		="TauntTimerSource",
		getFunc	=function() return BUI.Vars.TauntTimerSource end,
		setFunc	=function(value) BUI.Vars.TauntTimerSource=value end,
		disabled	=function() return BUI.Vars.TauntTimer==4 end,
	},
	--Reticle resist
	{	type		="dropdown",
		name		="ReticleResist",
		choices	={"Current value","Detailed info","Disabled"},
--		choicesValues={1,2,3},
		getFunc	=function() return BUI.Vars.ReticleResist end,
		setFunc	=function(i,value) BUI.Vars.ReticleResist=i end,
--		disabled	=function() return BUI.API>100033 end,
	},
	--Cast bar
	{	type		="dropdown",
		name		="CastBar",
		choices	={"Any ability","Cast time ability","Disabled"},
		getFunc	=function() return BUI.Vars.CastBar end,
		setFunc	=function(i,value) BUI.Vars.CastBar=i end,
		disabled	=function() return not BUI.Vars.Actions end,
	},
	--Swap indicator
	{	type		="checkbox",
		name		="SwapIndicator",
		getFunc	=function() return BUI.Vars.SwapIndicator end,
		setFunc	=function(value) BUI.Vars.SwapIndicator=value end,
		disabled	=function() return not BUI.Vars.Actions end,
	},
	--Impactful hit animation
	{	type		="checkbox",
		name		="ImpactAnimation",
		getFunc	=function() return BUI.Vars.ImpactAnimation end,
		setFunc	=function(value) BUI.Vars.ImpactAnimation=value BUI.Reticle.Initialize() end,
	},
	--Reticle mode
	{	type		="dropdown",
		name		="ReticleMode",
		choices	={"Default","Crosshair","Rhomboid","Circular","Triangle 1","Triangle 2","Dotty","Brackets","Dots"},
		getFunc	=function() return BUI.Vars.ReticleMode end,
		setFunc	=function(i,value) BUI.Vars.ReticleMode=i BUI.Reticle.Mode(i) end,
	},
	--Speed boost
	{	type		="checkbox",
		name		="ReticleBoost",
		getFunc	=function() return BUI.Vars.ReticleBoost end,
		setFunc	=function(value) BUI.Vars.ReticleBoost=value end,
		disabled	=function() return not BUI.Vars.PlayerBuffs end
	},
	--Block indicator
	{	type		="checkbox",
		name		="BlockIndicator",
		getFunc	=function() return BUI.Vars.BlockIndicator end,
		setFunc	=function(value) BUI.Vars.BlockIndicator=value BUI.Reticle.Blocking() end
	},
	{	type="texture",
		texture="/BanditsUserInterface/textures/reticle/menu_reticle.dds",
		dimensions={128,128}
	}}
	MenuPanel["MenuReticle"]={name="ReticleHeader"}
	MenuHandlers["MenuReticle"]={
	["OnEffectivelyHidden"]=function() BUI.inMenu=false end,
	}

	MenuOptions["MenuPlayerFrames"]={
--		type="submenu", name="PlayerHeader", controls={
	--Player Frames
	{	type		="dropdown",
		name		="PlayerHeader",
		choices	={"Default frames","Default: pyramid","Bandits: default","Bandits: pyramid","Bandits: vertical","Disabled"},
		getFunc	=function()
					if BUI.Vars.DefaultPlayerFrames then
						if BUI.Vars.RepositionFrames then return "Default: pyramid" else return "Default frames" end
					elseif BUI.Vars.PlayerFrame then
						if BUI.Vars.FrameHorisontal then
							return BUI.Vars.RepositionFrames and "Bandits: pyramid" or "Bandits: default"
						else return "Bandits: vertical" end
					else
						return "Disabled"
					end
				end,
		setFunc	=function(i,value)
					if value=="Default frames" then
						local old1=BUI.Vars.DefaultPlayerFrames BUI.Vars.DefaultPlayerFrames=true
						local old2=BUI.Vars.RepositionFrames BUI.Vars.RepositionFrames=false
						BUI.Vars.PlayerFrame=false
						BUI.Menu.Reset("DefaultFrames")
						if not old1 then BUI.Frames:ZO_PlayerAttribute_toggle(true) end
						if old2 then BUI.Frames.ZO_PlayerAttribute_reposition() end
						if BUI_PlayerFrame then BUI_PlayerFrame:SetHidden(true) end
--						if not old1 or old2 then SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8,"Reloading UI") BUI.CallLater("ReloadUI",1000,ReloadUI) end
					elseif value=="Default: pyramid" then
						local old1=BUI.Vars.DefaultPlayerFrames BUI.Vars.DefaultPlayerFrames=true
						BUI.Vars.RepositionFrames=true
						BUI.Vars.PlayerFrame=false
						BUI.Frames:ZO_PlayerAttribute_reposition()
						if not old1 then BUI.Frames:ZO_PlayerAttribute_toggle(true) end
						if BUI_PlayerFrame then BUI_PlayerFrame:SetHidden(true) end
--						if not old1 then SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8,"Reloading UI") BUI.CallLater("ReloadUI",1000,ReloadUI) end
					elseif value=="Bandits: default" then
						BUI.Vars.DefaultPlayerFrames=false
						BUI.Frames:ZO_PlayerAttribute_toggle()
						BUI.Vars.PlayerFrame=true
						BUI.Vars.FrameHorisontal=true
						BUI.Vars.RepositionFrames=false
						BUI.Frames:Controls()
						BUI.Frames:SetupPlayer()
						BUI.Menu:FramesReposition()
					elseif value=="Bandits: pyramid" then
						BUI.Vars.DefaultPlayerFrames=false
						BUI.Frames:ZO_PlayerAttribute_toggle()
						BUI.Vars.PlayerFrame=true
						BUI.Vars.FrameHorisontal=true
						BUI.Vars.RepositionFrames=true
						BUI.Vars.TargetHeight=BUI.Vars.FrameHeight
						BUI.Frames:Controls()
						BUI.Frames:SetupPlayer()
						BUI.Menu:FramesReposition()
					elseif value=="Bandits: vertical" then
						BUI.Vars.DefaultPlayerFrames=false
						BUI.Frames:ZO_PlayerAttribute_toggle()
						BUI.Vars.PlayerFrame=true
						BUI.Vars.FrameHorisontal=false
						BUI.Vars.RepositionFrames=false
						BUI.Vars.TargetHeight=BUI.Vars.FrameHeight*1.5
						BUI.Vars.TargetWidth=BUI.Vars.FrameWidth
						BUI.Frames:Controls()
						BUI.Frames:SetupPlayer()
						BUI.Menu:FramesReposition()
					elseif value=="Disabled" then
						BUI.Vars.DefaultPlayerFrames=false
						BUI.Vars.PlayerFrame=false
						BUI.Vars.FrameHorisontal=true
						BUI.Vars.TargetHeight=BUI.Vars.FrameHeight
						BUI.Frames:ZO_PlayerAttribute_toggle()
						BUI.Frames:Controls()
					end
				end,
		default	="Bandits Player frame",
--		warning	=true,
	},
	--Frames Border
	{	type		="dropdown",
		name		="FramesBorder",
		choices	={"Plain","Thin","Thin (the same)","Clockwork","Blade","Round","Dragon"},
		getFunc	=function() return BUI.Vars.FramesBorder end,
		setFunc	=function(i,value) BUI.Vars.FramesBorder=i BUI.Frames:Controls() end,
		disabled	=function() return not BUI.Vars.PlayerFrame end,
	},
	--Show Maximum Health
	{	type		="checkbox",
		name		="FrameShowMax",
		getFunc	=function() return BUI.Vars.FrameShowMax end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('FrameShowMax', value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame end,
	},
	--Show Percents
	{	type		="checkbox",
		name		="FramePercents",
		getFunc	=function() return BUI.Vars.FramePercents end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('FramePercents', value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame end,
	},
	--Unit Frame Width
	{	type		="slider",
		name		="FrameWidth",
		min		=200,
		max		=500,
		step		=10,
		getFunc	=function() return BUI.Vars.FrameWidth end,
		setFunc	=function(value) BUI.Menu.UpdateFrames("FrameWidth", value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame end,
	},
	--Unit Frame Height
	{	type		="slider",
		name		="FrameHeight",
		min		=16,
		max		=40,
		step		=4,
		getFunc	=function() return BUI.Vars.FrameHeight end,
		setFunc	=function(value) BUI.Menu.UpdateFrames("FrameHeight", value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame end,
	},
	--Frame Font Size
	{	type		="slider",
		name		="FrameFontSize",
		min		=12,
		max		=24,
		step		=1,
		getFunc	=function() return BUI.Vars.FrameFontSize end,
		setFunc	=function(value) BUI.Menu.UpdateFrames("FrameFontSize", value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame end,
	},
	--Display Nameplate
	{	type		="checkbox",
		name		="EnableNameplate",
		getFunc	=function() return BUI.Vars.EnableNameplate end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('EnableNameplate', value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame end,
	},
	--Food buff
	{	type		="checkbox",
		name		="FoodBuff",
		getFunc	=function() return BUI.Vars.FoodBuff end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('FoodBuff', value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame end,
	},
	--Reset Unit Frames
	{	type		="button",
		name		="FramesReset",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("FramesResetDesc"),func=function()BUI.Menu.Reset("Frames")end})end,
	},
	--	==Curved Frames==
	{type="submenu",name="CurvedHeader",controls={
	--Curved Frames Style
	{	type		="dropdown",
		name		="CurvedFrame",
		choices	={"Disabled","Simple","Cone","Blades"},
		getFunc	=function() return BUI.Vars.CurvedFrame+1 end,
		setFunc	=function(i,value) BUI.Vars.CurvedFrame=i-1 BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
	},
	--Curved Frames Distance
	{	type		="slider",
		name		="CurvedDistance",
		min		=80,
		max		=800,
		step		=20,
		getFunc	=function() return BUI.Vars.CurvedDistance end,
		setFunc	=function(value) BUI.Vars.CurvedDistance=value BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		warning	="CurvedDistanceWarn",
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Curved Frames offset
	{	type		="slider",
		name		="CurvedOffset",
		min		=-300,
		max		=300,
		step		=50,
		getFunc	=function() return BUI.Vars.CurvedOffset end,
		setFunc	=function(value) BUI.Vars.CurvedOffset=value BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Curved Frames height
	{	type		="slider",
		name		="CurvedHeight",
		min		=80,
		max		=640,
		step		=20,
		getFunc	=function() return BUI.Vars.CurvedHeight end,
		setFunc	=function(value) BUI.Vars.CurvedHeight=value BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Curved Frames Depth
	{	type		="slider",
		name		="CurvedDepth",
		min		=50,
		max		=100,
		step		=10,
		getFunc	=function() return BUI.Vars.CurvedDepth*100 end,
		setFunc	=function(value) BUI.Vars.CurvedDepth=value/100 BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Curved Stat Values
	{	type		="checkbox",
		name		="CurvedStatValues",
		getFunc	=function() return BUI.Vars.CurvedStatValues end,
		setFunc	=function(value) BUI.Vars.CurvedStatValues=value BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Deadly hit animation
	{	type		="checkbox",
		name		="CurvedHitAnimation",
		getFunc	=function() return BUI.Vars.CurvedHitAnimation end,
		setFunc	=function(value) BUI.Vars.CurvedHitAnimation=value BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Attributes shift
	{	type		="checkbox",
		name		="CurvedShift",
		getFunc	=function() return BUI.Vars.CurvedShift end,
		setFunc	=function(value) BUI.Vars.CurvedShift=value BUI.Curved.OnCombatState(false) BUI_CurvedTarget:SetAlpha(BUI.Vars.FrameOpacityIn/100) BUI_CurvedTarget:SetHidden(value) end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Shift animation
	{	type		="checkbox",
		name		="CurvedShiftAnimation",
		getFunc	=function() return BUI.Vars.CurvedShiftAnimation end,
		setFunc	=function(value) BUI.Vars.CurvedShiftAnimation=value if value then BUI.Curved.OnCombatState(false) end end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 or not BUI.Vars.CurvedShift end,
	},
	--Reset Curved Frames
	{
		type		="button",
		name		="CurvedReset",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("CurvedResetDesc"),func=function()BUI.Menu.Reset("Curved")end})end,
	}}},
	--	=="Advanced settings==
	{type="submenu",name="AdvancedHeader",controls={
	--Experience Bar
	{	type		="checkbox",
		name		="EnableXPBar",
		getFunc	=function() return BUI.Vars.EnableXPBar end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('EnableXPBar', value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame and BUI.Vars.CurvedFrame==0 end,
	},
	--Bound Armaments/Grim Focus
	{	type		="checkbox",
		name		="ShowDots",
		getFunc	=function() return BUI.Vars.ShowDots end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('ShowDots', value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame and BUI.Vars.CurvedFrame==0 end,
	},
	--Dodge fatigue
	{	type		="checkbox",
		name		="DodgeFatigue",
		getFunc	=function() return BUI.Vars.DodgeFatigue end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('DodgeFatigue', value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame and BUI.Vars.CurvedFrame==0 end,
	},
	--Auto hide
	{	type		="checkbox",
		name		="FramesFade",
		getFunc	=function() return BUI.Vars.FramesFade end,
		setFunc	=function(value) BUI.Vars.FramesFade=value end,
		disabled	=function() return not BUI.Vars.PlayerFrame and BUI.Vars.CurvedFrame==0 end,
	}}}
	}
	MenuPanel["MenuPlayerFrames"]={name="PlayerHeader"}
	MenuHandlers["MenuPlayerFrames"]={
	["OnEffectivelyShown"]=BUI.Menu.FramesReposition,
	["OnEffectivelyHidden"]=function() BUI.Menu.FramesRestore() BUI.inMenu=false end,
	}
--[[
	MenuOptions["MenuCurvedFrames"]={
	--	type="header", name="CurvedHeader", curved=true
	--Curved Frames Style
	{	type		="dropdown",
		name		="CurvedFrame",
		choices	={"Disabled","Simple","Cone","Blades"},
		getFunc	=function() return BUI.Vars.CurvedFrame+1 end,
		setFunc	=function(i,value) BUI.Vars.CurvedFrame=i-1 BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
	},
	--Curved Frames Distance
	{	type		="slider",
		name		="CurvedDistance",
		min		=80,
		max		=800,
		step		=20,
		getFunc	=function() return BUI.Vars.CurvedDistance end,
		setFunc	=function(value) BUI.Vars.CurvedDistance=value BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		warning	="CurvedDistanceWarn",
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Curved Frames offset
	{	type		="slider",
		name		="CurvedOffset",
		min		=-300,
		max		=300,
		step		=50,
		getFunc	=function() return BUI.Vars.CurvedOffset end,
		setFunc	=function(value) BUI.Vars.CurvedOffset=value BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Curved Frames height
	{	type		="slider",
		name		="CurvedHeight",
		min		=80,
		max		=640,
		step		=20,
		getFunc	=function() return BUI.Vars.CurvedHeight end,
		setFunc	=function(value) BUI.Vars.CurvedHeight=value BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Curved Frames Depth
	{	type		="slider",
		name		="CurvedDepth",
		min		=10,
		max		=100,
		step		=10,
		getFunc	=function() return BUI.Vars.CurvedDepth*100 end,
		setFunc	=function(value) BUI.Vars.CurvedDepth=value/100 BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Curved Stat Values
	{	type		="checkbox",
		name		="CurvedStatValues",
		getFunc	=function() return BUI.Vars.CurvedStatValues end,
		setFunc	=function(value) BUI.Vars.CurvedStatValues=value BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Deadly hit animation
	{	type		="checkbox",
		name		="CurvedHitAnimation",
		getFunc	=function() return BUI.Vars.CurvedHitAnimation end,
		setFunc	=function(value) BUI.Vars.CurvedHitAnimation=value BUI.Curved.Initialize() BUI.Menu.FramesReposition() end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Attributes shift
	{	type		="checkbox",
		name		="CurvedShift",
		getFunc	=function() return BUI.Vars.CurvedShift end,
		setFunc	=function(value) BUI.Vars.CurvedShift=value BUI.Curved.OnCombatState(false) BUI_CurvedTarget:SetAlpha(BUI.Vars.FrameOpacityIn/100) BUI_CurvedTarget:SetHidden(value) end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Shift animation
	{	type		="checkbox",
		name		="CurvedShiftAnimation",
		getFunc	=function() return BUI.Vars.CurvedShiftAnimation end,
		setFunc	=function(value) BUI.Vars.CurvedShiftAnimation=value if value then BUI.Curved.OnCombatState(false) end end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 or not BUI.Vars.CurvedShift end,
	},
	--Auto hide
	{	type		="checkbox",
		name		="FramesFade",
		getFunc	=function() return BUI.Vars.FramesFade end,
		setFunc	=function(value) BUI.Vars.FramesFade=value end,
		disabled	=function() return BUI.Vars.CurvedFrame==0 end,
	},
	--Reset Curved Frames
	{
		type		="button",
		name		="CurvedReset",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("CurvedResetDesc"),func=function()BUI.Menu.Reset("Curved")end})end,
	}}
	MenuPanel["MenuCurvedFrames"]={name="CurvedHeader"}
	MenuHandlers["MenuCurvedFrames"]={
	["OnEffectivelyShown"]=BUI.Menu.FramesReposition,
	["OnEffectivelyHidden"]=function() BUI.Menu.FramesRestore() BUI.inMenu=false end,
	}
--]]
	MenuOptions["MenuTargetFrames"]={
--		type="submenu", name="TargetHeader", controls={
	--Execute Threshold
	{	type		="slider",
		name		="ExecuteThreshold",
		min		=0,
		max		=50,
		step		=5,
		getFunc	=function() return BUI.Vars.ExecuteThreshold end,
		setFunc	=function(value) BUI.Vars.ExecuteThreshold=value end,
	},
	--Execute Sound
	{	type		="checkbox",
		name		="ExecuteSound",
		getFunc	=function() return BUI.Vars.ExecuteSound end,
		setFunc	=function(value) BUI.Vars.ExecuteSound=value end,
	},
	--Default Target Frame
	{	type		="header", name="DefaultTargetFrame"},
	{	type		="checkbox",
		name		="DefaultTargetFrame",
		getFunc	=function() return BUI.Vars.DefaultTargetFrame end,
		setFunc	=function(value)
			BUI.Vars.DefaultTargetFrame=value
			if value then SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8,"Reloading UI") BUI.CallLater("ReloadUI",1000,ReloadUI) return end
			BUI.SwitchUnitFramesEvents()
		end,
		warning	="ReloadUiWarn4",
	},
	{	type		="checkbox",
		name		="DefaultTargetFrameText",
		getFunc	=function() return BUI.Vars.DefaultTargetFrameText end,
		setFunc	=function(value) BUI.Vars.DefaultTargetFrameText=value end,
		disabled	=function() return not BUI.Vars.DefaultTargetFrame end
	},
	--Additional Target Frame
	{	type		="header", name="TargetFrame"},
	{	type		="checkbox",
		name		="TargetFrame",
		getFunc	=function() return BUI.Vars.TargetFrame end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('TargetFrame', value) end,
	},
	--Target Frame Width
	{	type		="slider",
		name		="TargetWidth",
		min		=200,
		max		=500,
		step		=20,
		getFunc	=function() return BUI.Vars.TargetWidth end,
		setFunc	=function(value) BUI.Menu.UpdateFrames("TargetWidth", value) end,
		disabled	=function() return not BUI.Vars.TargetFrame end,
	},
	--Target Frame Height
	{	type		="slider",
		name		="TargetHeight",
		min		=16,
		max		=40,
		step		=10,
		getFunc	=function() return BUI.Vars.TargetHeight end,
		setFunc	=function(value) BUI.Menu.UpdateFrames("TargetHeight", value) end,
		disabled	=function() return not BUI.Vars.TargetFrame end,
	},	
	--Center Frame Text
	{	type		="checkbox",
		name		="TargetFrameCenter",
		getFunc	=function() return BUI.Vars.TargetFrameCenter end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('TargetFrameCenter', value) end,
		disabled	=function() return not BUI.Vars.PlayerFrame end,
	},
	--Show Percents
	{	type		="checkbox",
		name		="TargetFramePercents",
		getFunc	=function() return BUI.Vars.TargetFramePercents end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('TargetFramePercents', value) end,
		disabled	=function() return not BUI.Vars.TargetFrame end,
	},
	--Boss Frame
	{	type		="header", name="BossFrame"},
	{	type		="checkbox",
		name		="BossFrame",
		getFunc	=function() return BUI.Vars.BossFrame end,
		setFunc	=function(value) BUI.Vars.BossFrame=value if BUI_BossFrame==nil then BUI.Frames.Bosses_UI() end BUI_BossFrame:SetHidden(not BUI.Vars.BossFrame) end,
	},
	--Boss Frame Width
	{	type		="slider",
		name		="BossWidth",
		min		=180,
		max		=360,
		step		=20,
		getFunc	=function() return BUI.Vars.BossWidth end,
		setFunc	=function(value) BUI.Menu.UpdateFrames("BossWidth", value) end,
		disabled	=function() return not BUI.Vars.BossFrame end,
	},
	--Boss Frame Height
	{	type		="slider",
		name		="BossHeight",
		min		=20,
		max		=80,
		step		=2,
		getFunc	=function() return BUI.Vars.BossHeight end,
		setFunc	=function(value) BUI.Menu.UpdateFrames("BossHeight", value) end,
		disabled	=function() return not BUI.Vars.BossFrame end,
	},
	--Reset Unit Frames
	{	type		="button",
		name		="FramesReset",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("FramesResetDesc"),func=function()BUI.Menu.Reset("Frames")end})end,
	}}
	MenuPanel["MenuTargetFrames"]={name="TargetHeader"}
	MenuHandlers["MenuTargetFrames"]={
	["OnEffectivelyShown"]=BUI.Menu.FramesReposition,
	["OnEffectivelyHidden"]=function() BUI.Menu.FramesRestore() BUI.inMenu=false end,
	}

	MenuOptions["MenuAttackersFrames"]={
	{	type		="checkbox",
		name		="Attackers",
		getFunc	=function() return BUI.Vars.Attackers end,
		setFunc	=function(value) BUI.Vars.Attackers=value BUI_Attackers:SetHidden(not BUI.Vars.Attackers) end,
	},
	--Attackers Frame Width
	{	type		="slider",
		name		="AttackersWidth",
		min		=180,
		max		=360,
		step		=20,
		getFunc	=function() return BUI.Vars.AttackersWidth end,
		setFunc	=function(value) BUI.Vars.AttackersWidth=value BUI.Damage.Attackers_UI() end,
		disabled	=function() return not BUI.Vars.Attackers end,
	},
	--Attackers Frame Height
	{	type		="slider",
		name		="AttackersHeight",
		min		=20,
		max		=80,
		step		=2,
		getFunc	=function() return BUI.Vars.AttackersHeight end,
		setFunc	=function(value) BUI.Vars.AttackersHeight=value BUI.Damage.Attackers_UI() end,
		disabled	=function() return not BUI.Vars.Attackers end,
	}}
	MenuPanel["MenuAttackersFrames"]={name="Attackers"}
	MenuHandlers["MenuAttackersFrames"]={
	["OnEffectivelyShown"]=function()
		BUI.inMenu=true
		if BUI.Vars.Attackers then
			BUI_Attackers:SetHidden(false)
			BUI_Attackers[1]:SetHidden(false)
		end
		BanditsUI:SetHidden(false)
	end,
	["OnEffectivelyHidden"]=function()
		if BUI.Vars.Attackers then
			BUI_Attackers:SetHidden(true)
		end
		BUI.inMenu=false
	end,
	}

local function PreviewGroupFrames()
--		BUI.Frames.Raid_UI(BUI.Vars.SmallGroupScale/100)
		if BUI.Vars.RaidFrames then
			for i=1,4 do
				local frame=BUI_RaidFrame["group"..i]
				frame:SetHidden(false)
			end
			BUI_RaidFrame:SetHidden(false)
		end
		BanditsUI:SetHidden(false)
end
	MenuOptions["MenuGroupFrames"]={
--		type="submenu",name="GroupHeader",controls={
	--Use Group Frame
	{	type		="checkbox",
		name		="RaidFrames",
		getFunc	=function() return BUI.Vars.RaidFrames end,
		setFunc	=function(value)
			BUI.Vars.RaidFrames=value
			if value then
				ZO_UnitFramesGroups:SetHidden(true)
				BUI.Frames.Raid_UI()
				BUI.Frames:SetupGroup()
				PreviewGroupFrames()
			else
				BUI.Vars.GroupSynergy=3
				SCENE_MANAGER:SetInUIMode(false)
				BUI.OnScreen.Notification(8,"Reloading UI")
				BUI.CallLater("ReloadUI",1000,ReloadUI)
				return
			end
			BUI.SwitchUnitFramesEvents()
		end,
		warning	="ReloadUiWarn5",
	},
	--Compact mode
	{	type		="checkbox",
		name		="RaidCompact",
		getFunc	=function() return BUI.Vars.RaidCompact end,
		setFunc	=function(value) BUI.Vars.RaidCompact=value if value then BUI.Vars.GroupBuffs=false BUI.Vars.StatsGroupDPS=false end BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Group Animation
	{	type		="checkbox",
		name		="GroupAnimation",
		getFunc	=function() return BUI.Vars.GroupAnimation end,
		setFunc	=function(value) BUI.Vars.GroupAnimation=value end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--GroupDeathSound
	{	type		="dropdown",
		name		="GroupDeathSound",
		choices	=GroupDeathSounds,
		getFunc	=function() return BUI.Vars.GroupDeathSound end,
		setFunc	=function(i,value) BUI.Vars.GroupDeathSound=value PlaySound(value) end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Show levels
	{	type		="checkbox",
		name		="RaidLevels",
		getFunc	=function() return BUI.Vars.RaidLevels end,
		setFunc	=function(value) BUI.Vars.RaidLevels=value BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Raid Column Size
	{	type		="slider",
		name		="RaidColumnSize",
		min		=1,
		max		=12,
		step		=1,
		getFunc	=function() return BUI.Vars.RaidColumnSize end,
		setFunc	=function(value) BUI.Vars.RaidColumnSize=value BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Raid Frame Width
	{	type		="slider",
		name		="RaidWidth",
		min		=120,
		max		=300,
		step		=10,
		getFunc	=function() return BUI.Vars.RaidWidth end,
		setFunc	=function(value) BUI.Vars.RaidWidth=value BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Raid Frame Height
	{	type		="slider",
		name		="RaidHeight",
		min		=18,
		max		=70,
		step		=2,
		getFunc	=function() return BUI.Vars.RaidHeight end,
		setFunc	=function(value) BUI.Vars.RaidHeight=value BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Raid Frame Font Size
	{	type		="slider",
		name		="RaidFontSize",
		min		=10,
		max		=20,
		step		=1,
		getFunc	=function() return BUI.Vars.RaidFontSize end,
		setFunc	=function(value) BUI.Vars.RaidFontSize=value BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Stat value
	{	type		="dropdown",
		name		="RaidStatValue",
		choices	={"Number","Percent","Disabled"},
		getFunc	=function() return BUI.Vars.RaidStatValue or 1 end,
		setFunc	=function(i,value) BUI.Vars.RaidStatValue=i BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--	==Advanced settings==
	{type="submenu",name="AdvancedHeader",controls={
	--Group election
	{	type		="checkbox",
		name		="GroupElection",
		getFunc	=function() return BUI.Vars.GroupElection end,
		setFunc	=function(value) BUI.Vars.GroupElection=value BUI.StatShare.GroupElection() BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Group Buffs
	{	type		="checkbox",
		name		="GroupBuffs",
		getFunc	=function() return BUI.Vars.GroupBuffs end,
		setFunc	=function(value) BUI.Vars.GroupBuffs=value BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Group members status
	{	type		="checkbox",
		name		="StatusIcons",
		getFunc	=function() return BUI.Vars.StatusIcons end,
		setFunc	=function(value) BUI.Vars.StatusIcons=value end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Small group scale
	{	type		="slider",
		name		="SmallGroupScale",
		min		=100,
		max		=200,
		step		=10,
		getFunc	=function() return BUI.Vars.SmallGroupScale end,
		setFunc	=function(value) BUI.Vars.SmallGroupScale=value BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Large raid scale
	{	type		="slider",
		name		="LargeRaidScale",
		min		=40,
		max		=100,
		step		=10,
		getFunc	=function() return BUI.Vars.LargeRaidScale end,
		setFunc	=function(value) BUI.Vars.LargeRaidScale=value BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Split group
	{	type		="slider",
		name		="RaidSplit",
		min		=0,
		max		=12,
		step		=1,
		getFunc	=function() return BUI.Vars.RaidSplit end,
		setFunc	=function(value) BUI.Vars.RaidSplit=value BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	--Raid sort
	{	type		="dropdown",
		name		="RaidSort",
		choices	={"By name","Auto","By role","By main power","By level","By accname"},
		getFunc	=function() return BUI.Vars.RaidSort+1 end,
		setFunc	=function(i,value) BUI.Vars.RaidSort=i-1 BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	}}},
	--	==Stats share==
	{type="submenu",name="StatShareHeader",controls={
	--Stat Share
	{	type		="checkbox",
		name		="StatShare",
		getFunc	=function() return BUI.Vars.StatShare end,
		setFunc	=function(value) BUI.Vars.StatShare=value BUI.StatShare.Initialize() BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
	},
	--Group ultimates
	{	type		="dropdown",
		name		="StatShareUlt",
		choices	={"All","Horn only","Disabled"},
		getFunc	=function() return BUI.Vars.StatShareUlt end,
		setFunc	=function(i,value) BUI.Vars.StatShareUlt=i BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames or not BUI.Vars.StatShare end,
	},
	--Ultimate order
	{	type		="dropdown",
		name		="UltimateOrder",
		choices	={"Enabled","Auto","Disabled"},
		getFunc	=function() return BUI.Vars.UltimateOrder end,
		setFunc	=function(i,value)
			BUI.Vars.UltimateOrder=i
			if not BUI.Vars.UltimateOrder then
				BUI_HornInfo_Bar:SetWidth(0) BUI_HornInfo_Names:SetText("") BUI_HornInfo_Value:SetText("") BUI_HornInfo:SetHeight(0)
				BUI_ColossusInfo_Bar:SetWidth(0) BUI_ColossusInfo_Names:SetText("") BUI_ColossusInfo_Value:SetText("") BUI_ColossusInfo:SetHeight(0)
			end
		end,
		disabled	=function() return not BUI.Vars.RaidFrames or not BUI.Vars.StatShare end,
	}}},
	--	==Group synergy==
	{type="submenu",name="GroupSynergy",controls={
	{	type		="dropdown",
		name		="GroupSynergy",
		choices	={"All","Tanks","Disabled"},
		getFunc	=function() return BUI.Vars.GroupSynergy end,
		setFunc	=function(i,value) BUI.Vars.GroupSynergy=i BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames end,
	},
	{	type		="slider",
		name		="GroupSynergyCount",
		min		=1,
		max		=5,
		step		=1,
		getFunc	=function() return BUI.Vars.GroupSynergyCount end,
		setFunc	=function(value) BUI.Vars.GroupSynergyCount=value BUI.Frames.Raid_UI() BUI.Frames:SetupGroup() PreviewGroupFrames() end,
		disabled	=function() return not BUI.Vars.RaidFrames or not BUI.Vars.GroupSynergy end,
	}}},
	--Group leader
	{type="submenu",name="GroupLeaderHeader",controls={
	{	type		="checkbox",
		name		="MarkerLeader",
		getFunc	=function() return BUI.Vars.MarkerLeader end,
		setFunc	=function(value) BUI.Vars.MarkerLeader=value BUI.Menu.MarkerLeader() end,
	},
	{	type		="slider",
		name		="MarkerSize",
		min		=26,
		max		=72,
		step		=4,
		getFunc	=function() return BUI.Vars.MarkerSize end,
		setFunc	=function(value) BUI.Vars.MarkerSize=value BUI.Menu.MarkerLeader() end,
		disabled	=function() return not BUI.Vars.MarkerLeader end,
	}}},
	--Reset Unit Frames
	{	type		="button",
		name		="FramesReset",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("FramesResetDesc"),func=function()BUI.Menu.Reset("Frames")end})end,
	}
	}
	MenuPanel["MenuGroupFrames"]={name="GroupHeader"}
	MenuHandlers["MenuGroupFrames"]={
	["OnEffectivelyShown"]=function()
		BUI.inMenu=true
		PreviewGroupFrames()
	end,
	["OnEffectivelyHidden"]=function()
		if not BUI.InGroup and BUI_RaidFrame then BUI_RaidFrame:SetHidden(true) end
		BUI.inMenu=false
	end,
	}

	MenuOptions["MenuDamageStatistics"]={
	--	type="submenu",name="StatHeader",controls={
--[[
	--Damage Tracker Timeout
	{	type		="slider",
		name		="DamageTimeout",
		min		=5,
		max		=60,
		step		=5,
		getFunc	=function() return BUI.Vars.DamageTimeout end,
		setFunc	=function(value) BUI.Menu.Update("DamageTimeout", value) end,
	},
--]]
	--DPS share
	{	type		="header",
		name		="StatsUpdateDPS",
	},
	{	type		="checkbox",
		name		="StatsUpdateDPS",
		getFunc	=function() return BUI.Vars.StatsUpdateDPS end,
		setFunc	=function(value) BUI.Vars.StatsUpdateDPS=value BUI.Stats.Initialize() end,
--		disabled	=function() return not BUI.Vars.EnableStats end
	},
	--Post DPS on member plates
	{	type		="checkbox",
		name		="StatsGroupDPS",
		getFunc	=function() return BUI.Vars.StatsGroupDPS end,
		setFunc	=function(value) BUI.Vars.StatsGroupDPS=value end,
		disabled	=function() return not BUI.Vars.RaidFrames or BUI.Vars.RaidCompact end,
	},
	--Group DPS Frame
	{	type		="checkbox",
		name		="StatsGroupDPSframe",
		getFunc	=function() return BUI.Vars.StatsGroupDPSframe end,
		setFunc	=function(value) BUI.Vars.StatsGroupDPSframe=value if value and not BUI_GroupDPS then BUI.Stats.GroupDPS_Init() end end,
--		disabled	=function() return not BUI.Vars.EnableStats end
	},
--[[
	--Share DPS with Group?
	{	type		="checkbox",
		name		="StatsShareDPS",
		getFunc	=function() return BUI.Vars.StatsShareDPS end,
		setFunc	=function(value) BUI.Menu.Update('StatsShareDPS', value) end,
	},
--]]
	--Minimeter
	{	type		="header",
		name		="StatMiniHeader",
	},
	{
		type		="checkbox",
		name		="StatsMiniMeter",
		getFunc	=function() return BUI.Vars.StatsMiniMeter end,
		setFunc	=function(value) BUI.Vars.StatsMiniMeter=value BUI.Stats.Initialize() end,
--		disabled	=function() return not BUI.Vars.EnableStats end,
	},
	--Minimeter alpha
	{	type		="slider",
		name		="MiniMeterAplha",
		min		=0,
		max		=100,
		step		=10,
		getFunc	=function() return BUI.Vars.MiniMeterAplha*100 end,
		setFunc	=function(value) BUI.Vars.MiniMeterAplha=value/100 if BUI.Vars.StatsMiniMeter then BUI_MiniMeter_BG:SetEdgeColor(0,0,0,BUI.Vars.MiniMeterAplha) end end,
		disabled	=function() return not BUI.Vars.EnableStats or not BUI.Vars.StatsMiniMeter end,
	},
	--Minimeter HPS
	{	type		="checkbox",
		name		="StatsMiniHealing",
		getFunc	=function() return BUI.Vars.StatsMiniHealing end,
		setFunc	=function(value) BUI.Vars.StatsMiniHealing=value BUI.Stats.Minimeter_Init() end,
		disabled	=function() return not BUI.Vars.EnableStats or not BUI.Vars.StatsMiniMeter end,
	},
	--Minimeter Group DPS
	{	type		="checkbox",
		name		="StatsMiniGroupDps",
		getFunc	=function() return BUI.Vars.StatsMiniGroupDps end,
		setFunc	=function(value) BUI.Vars.StatsMiniGroupDp=value BUI.Stats.Minimeter_Init() end,
		disabled	=function() return not BUI.Vars.EnableStats or not BUI.Vars.StatsMiniMeter end,
	},
	--Minimeter Speed
	{	type		="checkbox",
		name		="StatsMiniSpeed",
		getFunc	=function() return BUI.Vars.StatsMiniSpeed end,
		setFunc	=function(value) BUI.Vars.StatsMiniSpeed=value BUI.Stats.Minimeter_Init() end,
		disabled	=function() return not BUI.Vars.EnableStats or not BUI.Vars.StatsMiniMeter end,
	},
	{	type		="header",
		name		="StatHeader",
		width		="full"
	},
--[[
	--Report Scale
	{	type		="slider",
		name		="ReportScale",
		min		=50,
		max		=150,
		step		=10,
		getFunc	=function() return BUI.Vars.ReportScale*100 end,
		setFunc	=function(value) BUI.Vars.ReportScale=value/100 BUI.Stats.Analistics_Init() end,
--		disabled	=function() return not BUI.Vars.EnableStats end,
	},
--]]
	--Split Elements
	{	type		="checkbox",
		name		="StatsSplitElements",
		getFunc	=function() return BUI.Vars.StatsSplitElements end,
		setFunc	=function(value) BUI.Vars.StatsSplitElements=value end,
--		disabled	=function() return not BUI.Vars.EnableStats end
	},
	--Buffs report
	{	type		="checkbox",
		name		="StatsBuffs",
		getFunc	=function() return BUI.Vars.StatsBuffs end,
		setFunc	=function(value) BUI.Vars.StatsBuffs=value BUI.Stats.Analistics_Init() end,
		disabled	=function() return not BUI.Vars.EnableStats or not BUI.Vars.PlayerBuffs end
	},
	--Combat log
	{	type		="header",
		name		="Log",
	},
	{
		type		="checkbox",
		name		="Log",
		getFunc	=function() return BUI.Vars.Log end,
		setFunc	=function(value) BUI.Vars.Log=value end,
	},
	--Reset Stats
	{	type		="button",
		name		="StatsReset",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("StatsResetDesc"),func=function()BUI.Menu.Reset("Stats")end})end,
	}}
	MenuPanel["MenuDamageStatistics"]={name="StatHeader"}
	MenuHandlers["MenuDamageStatistics"]={
	["OnEffectivelyHidden"]=function() BUI.inMenu=false end,
	}

	MenuOptions["MenuBuffs"]={
	--Player Buffs
	{type="submenu",name="PlayerBuffs",controls={
	{	type		="checkbox",
		name		="PlayerBuffs",
		getFunc	=function() return BUI.Vars.PlayerBuffs end,
		setFunc	=function(value) BUI.Vars.PlayerBuffs=value if value then BUI.Buffs:Initialize() else BUI.Frames.PlayerBuffs_Init() BUI.Frames.PassiveBuffs_Init() BUI.Frames.CustomBuffs_Init() end end,
	},
	--Important buffs
	{	type		="checkbox",
		name		="BuffsImportant",
		getFunc	=function() return BUI.Vars.BuffsImportant end,
		setFunc	=function(value) BUI.Vars.BuffsImportant=value end,
		disabled	=function() return not BUI.Vars.PlayerBuffs end
	},
	--Minimum Duration
	{	type		="slider",
		name		="MinimumDuration",
		min		=0,
		max		=10,
		step		=1,
		getFunc	=function() return BUI.Vars.MinimumDuration end,
		setFunc	=function(value) BUI.Vars.MinimumDuration=value end,
		disabled	=function() return not BUI.Vars.PlayerBuffs and not BUI.Vars.TargetBuffs end
	},
	--Player Buffs Size
	{	type		="slider",
		name		="PlayerBuffSize",
		min		=30,
		max		=80,
		step		=2,
		getFunc	=function() return BUI.Vars.PlayerBuffSize end,
		setFunc	=function(value) BUI.Vars.PlayerBuffSize=value BUI.Frames.PlayerBuffs_Init() end,
		disabled	=function() return not BUI.Vars.PlayerBuffs end
	},
	--Player Buffs Alignment
	{	type		="dropdown",
		name		="PlayerBuffsAlign",
		choices	={[8]="Left",[128]="Center",[2]="Right"},
--		choicesValues={LEFT,CENTER,RIGHT},
		getFunc	=function() return BUI.Vars.PlayerBuffsAlign end,
		setFunc	=function(i,value) BUI.Vars.PlayerBuffsAlign=i BUI.Frames.PlayerBuffs_Init() end,
		disabled	=function() return not BUI.Vars.PlayerBuffs end
	}}},
	--Buffs Passives
	{type="submenu",name="BuffsPassives",controls={
	{	type		="dropdown",
		name		="BuffsPassives",
		choices	={"On one panel","On additional panel","Disabled"},
		getFunc	=function() return BUI.Vars.BuffsPassives end,
		setFunc	=function(i,value) BUI.Vars.BuffsPassives=value BUI.Frames.PassiveBuffs_Init() end,
		disabled	=function() return not BUI.Vars.PlayerBuffs end,
	},
	--Passive Buffs Size
	{	type		="slider",
		name		="PassiveBuffSize",
		min		=30,
		max		=80,
		step		=2,
		getFunc	=function() return BUI.Vars.PassiveBuffSize end,
		setFunc	=function(value) BUI.Vars.PassiveBuffSize=value BUI.Frames.PassiveBuffs_Init() end,
		disabled	=function() return not (BUI.Vars.PlayerBuffs and BUI.Vars.BuffsPassives=="On additional panel") end
	},
	{	type		="checkbox",
		name		="PassiveProgress",
		getFunc	=function() return BUI.Vars.PassiveProgress end,
		setFunc	=function(value) BUI.Vars.PassiveProgress=value BUI.Frames.PassiveBuffs_Init() end,
		disabled	=function() return not BUI.Vars.PlayerBuffs or BUI.Vars.BuffsPassives~="On additional panel" end,
	},
	{	type		="slider",
		name		="PassivePWidth",
		min		=50,
		max		=200,
		step		=10,
		getFunc	=function() return BUI.Vars.PassivePWidth end,
		setFunc	=function(value) BUI.Vars.PassivePWidth=value BUI.Frames.PassiveBuffs_Init() end,
		disabled	=function() return not BUI.Vars.PlayerBuffs or BUI.Vars.BuffsPassives~="On additional panel" or not BUI.Vars.PassiveProgress end
	},
	{	type		="dropdown",
		name		="PassivePSide",
		choices	={"left","right"},
		getFunc	=function() return BUI.Vars.PassivePSide end,
		setFunc	=function(i,value) BUI.Vars.PassivePSide=value BUI.Frames.PassiveBuffs_Init() end,
		disabled	=function() return not BUI.Vars.PlayerBuffs or BUI.Vars.BuffsPassives~="On additional panel" or not BUI.Vars.PassiveProgress end,
	},
	{	type		="checkbox",
		name		="PassiveOakFilter",
		getFunc	=function() return BUI.Vars.PassiveOakFilter end,
		setFunc	=function(value) BUI.Vars.PassiveOakFilter=value BUI.Frames.PassiveBuffs_Init() end,
		disabled	=function() return not BUI.Vars.PlayerBuffs or BUI.Vars.BuffsPassives~="On additional panel" end,
	}}},
	--Target Buffs
	{type="submenu",name="TargetBuffs",controls={
	{
		type		="checkbox",
		name		="TargetBuffs",
		getFunc	=function() return BUI.Vars.TargetBuffs end,
		setFunc	=function(value) BUI.Vars.TargetBuffs=value if value then BUI.Buffs:Initialize() else BUI.Frames.TargetBuffs_Init() end end,
	},
	--Target Buffs Size
	{	type		="slider",
		name		="TargetBuffSize",
		min		=30,
		max		=80,
		step		=2,
		getFunc	=function() return BUI.Vars.TargetBuffSize end,
		setFunc	=function(value) BUI.Vars.TargetBuffSize=value BUI.Frames.TargetBuffs_Init() end,
		disabled	=function() return not BUI.Vars.TargetBuffs end
	},
	--Hide buffs form others
	{
		type		="checkbox",
		name		="BuffsOtherHide",
		getFunc	=function() return BUI.Vars.BuffsOtherHide end,
		setFunc	=function(value) BUI.Vars.BuffsOtherHide=value end,
		disabled	=function() return not BUI.Vars.TargetBuffs end
	},
	--Target Buffs Alignment
	{	type		="dropdown",
		name		="TargetBuffsAlign",
		choices	={[8]="Left",[128]="Center",[2]="Right"},
--		choicesValues={LEFT,CENTER,RIGHT},
		getFunc	=function() return BUI.Vars.TargetBuffsAlign end,
		setFunc	=function(i,value) BUI.Vars.TargetBuffsAlign=i BUI.Frames.TargetBuffs_Init() end,
		disabled	=function() return not BUI.Vars.TargetBuffs end
	}}},
	--Buffs black list
	{type="submenu",name="BlackListHeader",controls={
	{	type		="checkbox",
		name		="EnableBlackList",
		getFunc	=function() return BUI.Vars.EnableBlackList end,
		setFunc	=function(value) BUI.Vars.EnableBlackList=value end,
	},
	{	type="editbox",
		name		="BlackListAdd",
		getFunc	=function() end,
		setFunc	=function(text) BUI.Buffs.AddTo(BUI.Vars.BuffsBlackList,text,"Black List") end,
		disabled	=function() return not BUI.Vars.EnableBlackList end,
	},
	{	type		="dropdown",
		name		="BlackListDel",
		choices	=BUI.Menu.Black_List,
		scrollable	=30,
		getFunc	=function() end,
		setFunc	=function(i,value) BUI.Buffs.RemoveFrom(BUI.Vars.BuffsBlackList,BUI.Menu.Black_List_Values[i],"Black List") end,
		disabled	=function() return not BUI.Vars.EnableBlackList end,
		reference	="BUI_Black_List_Dropdown"
	}}},
	--Custom Buffs
	{type="submenu",name="CustomBuffsHeader",controls={
	{	type		="checkbox",
		name		="EnableCustomBuffs",
		getFunc	=function() return BUI.Vars.EnableCustomBuffs end,
		setFunc	=function(value) BUI.Vars.EnableCustomBuffs=value BUI.Frames.CustomBuffs_Init() end,
	},
	{	type		="slider",
		name		="CustomBuffSize",
		min		=30,
		max		=80,
		step		=2,
		getFunc	=function() return BUI.Vars.CustomBuffSize end,
		setFunc	=function(value) BUI.Vars.CustomBuffSize=value BUI.Frames.CustomBuffs_Init() end,
		disabled	=function() return not BUI.Vars.EnableCustomBuffs end
	},
	{	type		="dropdown",
		name		="CustomBuffsDirection",
		choices	={"horisontal","vertical"},
		getFunc	=function() return BUI.Vars.CustomBuffsDirection end,
		setFunc	=function(i,value) BUI.Vars.CustomBuffsDirection=value BUI.Frames.CustomBuffs_Init() end,
		disabled	=function() return not BUI.Vars.EnableCustomBuffs end,
	},
	{	type		="checkbox",
		name		="CustomBuffsProgress",
		getFunc	=function() return BUI.Vars.CustomBuffsProgress end,
		setFunc	=function(value) BUI.Vars.CustomBuffsProgress=value BUI.Frames.CustomBuffs_Init() end,
		disabled	=function() return not BUI.Vars.EnableCustomBuffs or BUI.Vars.CustomBuffsDirection~="vertical" end,
	},
	{	type		="slider",
		name		="CustomBuffsPWidth",
		min		=50,
		max		=200,
		step		=10,
		getFunc	=function() return BUI.Vars.CustomBuffsPWidth end,
		setFunc	=function(value) BUI.Vars.CustomBuffsPWidth=value BUI.Frames.CustomBuffs_Init() end,
		disabled	=function() return not BUI.Vars.EnableCustomBuffs or not BUI.Vars.CustomBuffsProgress or BUI.Vars.CustomBuffsDirection~="vertical" end
	},
	{	type		="dropdown",
		name		="CustomBuffsPSide",
		choices	={"left","right"},
		getFunc	=function() return BUI.Vars.CustomBuffsPSide end,
		setFunc	=function(i,value) BUI.Vars.CustomBuffsPSide=value BUI.Frames.CustomBuffs_Init() end,
		disabled	=function() return not BUI.Vars.EnableCustomBuffs or not BUI.Vars.CustomBuffsProgress or BUI.Vars.CustomBuffsDirection~="vertical" end
	},
	{	type="editbox",
		name		="CustomBuffsAdd",
		getFunc	=function() end,
		setFunc	=function(text) BUI.Buffs.AddTo(BUI.Vars.CustomBuffs,text,"Custom buffs") end,
		disabled	=function() return not BUI.Vars.EnableCustomBuffs end,
	},
	{	type		="dropdown",
		name		="CustomBuffsDel",
		choices	=BUI.Menu.Custom_List,
		scrollable	=30,
		getFunc	=function() end,
		setFunc	=function(i,value) BUI.Buffs.RemoveFrom(BUI.Vars.CustomBuffs,BUI.Menu.Custom_List_Values[i],"Custom buffs") end,
		disabled	=function() return not BUI.Vars.EnableCustomBuffs end,
		reference	="BUI_Custom_Buffs_Dropdown"
	}}},
	--Synergy CD
	{type="submenu",name="SynergyCdHeader",controls={
	{	type		="checkbox",
		name		="EnableSynergyCd",
		getFunc	=function() return BUI.Vars.EnableSynergyCd end,
		setFunc	=function(value) BUI.Vars.EnableSynergyCd=value BUI.Frames.SynergyCd_Init() end,
		default	=BUI.Defaults.EnableSynergyCd,
	},
	{	type		="slider",
		name		="SynergyCdSize",
		min		=30,
		max		=80,
		step		=2,
		getFunc	=function() return BUI.Vars.SynergyCdSize end,
		setFunc	=function(value) BUI.Vars.SynergyCdSize=value end,
		disabled	=function() return not BUI.Vars.EnableSynergyCd end
	},
	{	type		="dropdown",
		name		="SynergyCdDirection",
		choices	={"horisontal","vertical"},
		getFunc	=function() return BUI.Vars.SynergyCdDirection end,
		setFunc	=function(i,value) BUI.Vars.SynergyCdDirection=value if value~="vertical" then BUI.Vars.SynergyCdProgress=false end BUI.Frames.SynergyCd_Init() end,
		disabled	=function() return not BUI.Vars.EnableSynergyCd end,
	},
	{	type		="checkbox",
		name		="SynergyCdProgress",
		getFunc	=function() return BUI.Vars.SynergyCdProgress end,
		setFunc	=function(value) BUI.Vars.SynergyCdProgress=value BUI.Frames.SynergyCd_Init() end,
		disabled	=function() return not BUI.Vars.EnableSynergyCd or BUI.Vars.SynergyCdDirection~="vertical" end,
	},
	{	type		="slider",
		name		="SynergyCdPWidth",
		min		=50,
		max		=200,
		step		=10,
		getFunc	=function() return BUI.Vars.SynergyCdPWidth end,
		setFunc	=function(value) BUI.Vars.SynergyCdPWidth=value BUI.Frames.SynergyCd_Init() end,
		disabled	=function() return not BUI.Vars.SynergyCdProgress end
	},
	{	type		="dropdown",
		name		="SynergyCdPSide",
		choices	={"left","right"},
		getFunc	=function() return BUI.Vars.SynergyCdPSide end,
		setFunc	=function(i,value) BUI.Vars.SynergyCdPSide=value BUI.Frames.SynergyCd_Init() end,
		disabled	=function() return not BUI.Vars.EnableSynergyCd end,
	}}},
	--Widgets
	{type="submenu",name="WidgetsHeader",controls={
	{	type		="checkbox",
		name		="EnableWidgets",
		getFunc	=function() return BUI.Vars.EnableWidgets end,
		setFunc	=function(value) BUI.Vars.EnableWidgets=value BUI.Frames.Widgets_Init() end,
		default	=BUI.Defaults.EnableWidgets,
	},
--[[
	{	type="editbox",
		name		="WidgetsAdd",
		getFunc	=function() end,
		setFunc	=function(text) BUI.Buffs.AddTo(BUI.Vars.Widgets,text,"Widgets") end,
		disabled	=function() return not BUI.Vars.EnableWidgets end,
	},
--]]
	{	type		="slider",
		name		="WidgetsSize",
		min		=30,
		max		=80,
		step		=2,
		getFunc	=function() return BUI.Vars.WidgetsSize end,
		setFunc	=function(value) BUI.Vars.WidgetsSize=value BUI.Frames.Widgets_Init() end,
		disabled	=function() return not BUI.Vars.EnableWidgets end
	},
--[[
	{	type		="dropdown",
		name		="WidgetsDel",
		choices	=Widgets_List,
		choicesValues=Widgets_List_Values,
		scrollable	=30,
		getFunc	=function() end,
		setFunc	=function(value) BUI.Buffs.RemoveFrom(BUI.Vars.Widgets,value,"Widgets") end,
		disabled	=function() return not BUI.Vars.EnableWidgets end,
		reference	="BUI_Widgets_Dropdown"
	},
--]]
	{	type		="slider",
		name		="WidgetsPWidth",
		min		=50,
		max		=200,
		step		=10,
		getFunc	=function() return BUI.Vars.WidgetsPWidth end,
		setFunc	=function(value) BUI.Vars.WidgetsPWidth=value BUI.Frames.Widgets_Init() end,
		disabled	=function() return not BUI.Vars.EnableWidgets end
	},
	{	type		="checkbox",
		name		="WidgetPotion",
		getFunc	=function() return BUI.Vars.WidgetPotion end,
		setFunc	=function(value) BUI.Vars.WidgetPotion=value BUI.Frames.Widgets_Init() end,
		disabled	=function() return not BUI.Vars.EnableWidgets end,
	},
	--Sound
	{	type		="dropdown",
		name		="WidgetSound1",
		choices	=ProcSounds,
		getFunc	=function() return BUI.Vars.WidgetSound1 end,
		setFunc	=function(i,value) BUI.Vars.WidgetSound1=value PlaySound(value) end,
		disabled	=function() return not BUI.Vars.EnableWidgets end,
	},
	{	type		="dropdown",
		name		="WidgetSound2",
		choices	=ProcSounds,
		getFunc	=function() return BUI.Vars.WidgetSound2 end,
		setFunc	=function(i,value) BUI.Vars.WidgetSound2=value PlaySound(value) end,
		disabled	=function() return not BUI.Vars.EnableWidgets end,
	},
	--ManageWidgets
	{	type		="button",
		name		="WidgetsManage",
		func		=function() BUI.Menu.ManageWidgets(true) end,
	}}},
	{--Reset
		type		="button",
		name		="BuffsReset",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("BuffsResetDesc"),func=function()BUI.Menu.Reset("Buffs")end})end,
	}}
	MenuPanel["MenuBuffs"]={name="BuffsHeader"}
	MenuHandlers["MenuBuffs"]={
	["OnEffectivelyShown"]=function() BUI.inMenu=true BanditsUI:SetHidden(false) end,
	["OnEffectivelyHidden"]=function() BUI.inMenu=false end,
	}

	MenuOptions["MenuActions"]={
	--	type="submenu",name="ActionsHeader",controls={
	{	type		="checkbox",
		name		="Actions",
		getFunc	=function() return BUI.Vars.Actions end,
		setFunc	=function(value) BUI.Vars.Actions=value BUI.Actions:Initialize() end,
	},
	{
		type		="checkbox",
		name		="ActionsPrecise",
		getFunc	=function() return BUI.Vars.ActionsPrecise end,
		setFunc	=function(value) BUI.Vars.ActionsPrecise=value BUI.Actions:Initialize() end,
--		warning	="PerformanceWarn",
		disabled	=function() return not BUI.Vars.Actions end,
	},
	{
		type		="checkbox",
		name		="UseSwapPanel",
		getFunc	=function() return BUI.Vars.UseSwapPanel end,
		setFunc	=function(value) BUI.Vars.UseSwapPanel=value BUI.Actions:Initialize() end,
		disabled	=function() return not BUI.Vars.Actions end,
	},
	{
		type		="checkbox",
		name		="HideSwapPanel",
		getFunc	=function() return BUI.Vars.HideSwapPanel end,
		setFunc	=function(value) BUI.Vars.HideSwapPanel=value end,
		disabled	=function() return not BUI.Vars.Actions or not BUI.Vars.UseSwapPanel end,
	},
	{	type		="checkbox",
		name		="ExpiresAnimation",
		getFunc	=function() return BUI.Vars.ExpiresAnimation end,
		setFunc	=function(value) BUI.Vars.ExpiresAnimation=value end,
		disabled	=function() return not BUI.Vars.Actions end,
	},
	{	type		="slider",
		name		="ActionsFontSize",
		min		=15,
		max		=20,
		step		=1,
		getFunc	=function() return BUI.Vars.ActionsFontSize end,
		setFunc	=function(value) BUI.Vars.ActionsFontSize=value BUI.Actions:Initialize() end,
		disabled	=function() return not BUI.Vars.Actions end,
	},
	--Proc Animation
	{	type		="checkbox",
		name		="ProcAnimation",
		getFunc	=function() return BUI.Vars.ProcAnimation end,
		setFunc	=function(value) BUI.Vars.ProcAnimation=value end,
		disabled	=function() return not BUI.Vars.Actions end,
		warning	="ReloadUiWarn"
	},
	--Proc Sound
	{	type		="dropdown",
		name		="ProcSound",
		choices	=ProcSounds,
		getFunc	=function() return BUI.Vars.ProcSound end,
		setFunc	=function(i,value) BUI.Vars.ProcSound=value PlaySound(value) end,
		disabled	=function() return not BUI.Vars.Actions or not BUI.Vars.ProcAnimation end,
	},
	--Reset
	{	type		="button",
		name		="ActionsReset",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("ActionsResetDesc"),func=function()BUI.Menu.Reset("Actions")end})end,
	}}
	MenuPanel["MenuActions"]={name="ActionsHeader"}
	MenuHandlers["MenuActions"]={
	["OnEffectivelyHidden"]=function() BUI.inMenu=false end,
	}

	MenuOptions["MenuNotifications"]={
	--	type="submenu", name="NotHeader", controls={
	--Food
	{	type		="checkbox",
		name		="NotificationFood",
		getFunc	=function() return BUI.Vars.NotificationFood end,
		setFunc	=function(value) BUI.Vars.NotificationFood=value end,
	},
	--Effect visualisation
	{	type		="checkbox",
		name		="EffectVisualisation",
		getFunc	=function() return BUI.Vars.EffectVisualisation end,
		setFunc	=function(value) BUI.Vars.EffectVisualisation=value BUI.OnScreen:Initialize() end,
	},
	--Font Size
	{	type		="slider",
		name		="NotificationsSize",
		min		=24,
		max		=40,
		step		=2,
		getFunc	=function() return BUI.Vars.NotificationsSize end,
		setFunc	=function(value) BUI.Vars.NotificationsSize=value BUI.OnScreen.UI_Init() end,
		advanced	=false
	},
	{	type		="header",name="NotificationsGroup"},
	--Group Notifications
	{	type		="checkbox",
		name		="NotificationsGroup",
		getFunc	=function() return BUI.Vars.NotificationsGroup end,
		setFunc	=function(value) BUI.Vars.NotificationsGroup=value BUI.OnScreen:Initialize() end,
	},
	--Healer or Tank death
	{	type		="checkbox",
		name		="OnScreenPriorDeath",
		getFunc	=function() return BUI.Vars.OnScreenPriorDeath end,
		setFunc	=function(value) BUI.Vars.OnScreenPriorDeath=value end,
	},
	{	type		="header",name="NotificationsCombatHeader"},
	--World Notifications
	{	type		="checkbox",
		name		="NotificationsWorld",
		getFunc	=function() return BUI.Vars.NotificationsWorld end,
		setFunc	=function(value) BUI.Vars.NotificationsWorld=value BUI.OnScreen:Initialize() end,
	},
	--Trial Notifications
	{	type		="checkbox",
		name		="NotificationsTrial",
		getFunc	=function() return BUI.Vars.NotificationsTrial end,
		setFunc	=function(value) BUI.Vars.NotificationsTrial=value BUI.OnScreen:Initialize() end,
	},
	--Sound
	{	type		="dropdown",
		name		="NotificationSound_1",
		choices	=NotificationSounds,
		getFunc	=function() return BUI.Vars.NotificationSound_1 end,
		setFunc	=function(i,value) BUI.Vars.NotificationSound_1=value PlaySound(value) end,
		disabled	=function() return not BUI.Vars.NotificationsTrial and not BUI.Vars.NotificationsWorld end,
	},
	--Sound
	{	type		="dropdown",
		name		="NotificationSound_2",
		choices	=NotificationSounds,
		getFunc	=function() return BUI.Vars.NotificationSound_2 end,
		setFunc	=function(i,value) BUI.Vars.NotificationSound_2=value PlaySound(value) end,
		disabled	=function() return not BUI.Vars.NotificationsTrial and not BUI.Vars.NotificationsWorld end,
	},
--[[
	--PvP Notifications
	{	type		="checkbox",
		name		="NotificationsPvP",
		getFunc	=function() return BUI.Vars.NotificationsPvP end,
		setFunc	=function(value) BUI.Vars.NotificationsPvP=value BUI.OnScreen:Initialize() end,
	},
	--Notifications Timer
	{	type		="slider",
		name		="NotificationsTimer",
		min		=1000,
		max		=8000,
		step		=1000,
		getFunc	=function() return BUI.Vars.NotificationsTimer end,
		setFunc	=function(value) BUI.Vars.NotificationsTimer=value end,
	},
	--Glyphs
	{	type		="checkbox",
		name		="Glyphs",
		getFunc	=function() return BUI.Vars.Glyphs end,
		setFunc	=function(value) BUI.Vars.Glyphs=value end,
	}
--]]
	}
	MenuPanel["MenuNotifications"]={name="NotificationsHeader"}
	MenuHandlers["MenuNotifications"]={
	["OnEffectivelyHidden"]=function() BUI.inMenu=false end,
	}

	MenuOptions["MenuMinimap"]={
	--	type="header",name="Minimap",advanced=true
	--Enable Minimap
	{	type		="checkbox",
		name		="Minimap",
		getFunc	=function() return BUI.Vars.MiniMap end,
		setFunc	=function(value) BUI.Vars.MiniMap=value BUI.MiniMap.Initialize() end,
	},
	--Minimap Size
	{	type		="slider",
		name		="MiniMapDimensions",
		min		=200,
		max		=500,
		step		=20,
		getFunc	=function() return BUI.Vars.MiniMapDimensions end,
		setFunc	=function(value) BUI.Vars.MiniMapDimensions=value BUI.MiniMap.Initialize() end,
		disabled	=function() return not BUI.Vars.MiniMap end,
	},
	--Minimap title
	{	type		="checkbox",
		name		="MinimapTitle",
		getFunc	=function() return BUI.Vars.MiniMapTitle end,
		setFunc	=function(value) BUI.Vars.MiniMapTitle=value BUI.MiniMap.Initialize() end,
		disabled	=function() return not BUI.Vars.MiniMap end,
	},
	--Minimap PinScale
	{	type		="slider",
		name		="PinScale",
		min		=50,
		max		=100,
		step		=2,
		getFunc	=function() return BUI.Vars.PinScale end,
		setFunc	=function(value) BUI.Vars.PinScale=value BUI.MiniMap.Initialize() end,
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
	MenuPanel["MenuMinimap"]={name="MinimapHeader"}
	MenuHandlers["MenuMinimap"]={
	["OnEffectivelyShown"]=function() BUI.inMenu=true BUI.MiniMap.Show() end,
	["OnEffectivelyHidden"]=function() BUI.inMenu=false end,
	}
	do	--Pin colors
		local PinTypes={
		--	[MAP_PIN_TYPE_PLAYER]={name="Player",icon="/EsoUI/Art/MapPins/UI-WorldMapPlayerPip.dds"},
			[MAP_PIN_TYPE_GROUP_LEADER]={name="Group leader",icon="/EsoUI/Art/Compass/groupLeader.dds"},
			[MAP_PIN_TYPE_GROUP]={name="Group member",icon="/EsoUI/Art/MapPins/UI-WorldMapGroupPip.dds"},
			[MAP_PIN_TYPE_POI_COMPLETE]={name="POI complete",icon="/esoui/art/icons/poi/poi_areaofinterest_complete.dds"},
			[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE]={name="Wayshrine",icon="/esoui/art/icons/poi/poi_wayshrine_complete.dds"},
			[MAP_PIN_TYPE_ASSISTED_QUEST_ENDING]={name="Quest complete",icon="/esoui/art/compass/quest_icon_assisted.dds"},
		--	[MAP_PIN_TYPE_VENDOR]={name="Vandor",icon="/esoui/art/icons/mapkey/mapkey_vendor.dds"},
			}
		table.insert(MenuOptions["MenuMinimap"],{type="header",name="PinColorsHeader"})
		for pin,data in pairs(PinTypes) do
			table.insert(MenuOptions["MenuMinimap"],
			{	type		="colorpicker",
				name		=zo_iconFormat(data.icon,32,32).." "..data.name,
				getFunc	=function() return unpack(BUI.Vars.PinColor[pin]) end,
				setFunc	=function(r,g,b,a) BUI.Vars.PinColor[pin]={r,g,b,a} BUI.MiniMap.PinColors() BUI.MiniMap.Show() end,
			})
		end
		table.insert(MenuOptions["MenuMinimap"],
		{--Reset
		type		="button",
		name		="MinimapReset",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("MinimapResetDesc"),func=function()BUI.Menu.Reset("Minimap")end})end,
		})
	end

	MenuOptions["MenuFrameColors"]={
	--	type="header",name="ColorsHeader"
	--Name
	{	type		="dropdown",
		name		="FrameNameFormat",
		choices	={"Name","@AccName","Name@AccName"},
		getFunc	=function() return BUI.Vars.FrameNameFormat end,
		setFunc	=function(i,value) BUI.Vars.FrameNameFormat=i BUI.Menu.UpdateFrames() end,
	},
	--Primary Frame Font
	{	type		="dropdown",
		name		="FrameFont1",
		choices	={"Metamorphous", "ESO Standard", "ESO Bold", "Prose Antique", "Handwritten", "Trajan Pro", "Futura Standard", "Futura Bold", "Gamepad Standard", "Gamepad Bold"},
		getFunc	=function() return BUI.TranslateFont(BUI.Vars.FrameFont1) end,
		setFunc	=function(i,value) BUI.Menu.UpdateFrames("FrameFont1", BUI.TranslateFont(value)) end,
	},
	--Secondary Frame Font
	{	type		="dropdown",
		name		="FrameFont2",
		choices	={"Metamorphous", "ESO Standard", "ESO Bold", "Prose Antique", "Handwritten", "Trajan Pro", "Futura Standard", "Futura Bold", "Gamepad Standard", "Gamepad Bold"},
		getFunc	=function() return BUI.TranslateFont(BUI.Vars.FrameFont2) end,
		setFunc	=function(i,value) BUI.Menu.UpdateFrames("FrameFont2", BUI.TranslateFont(value)) end,
	},
	{	type		="checkbox",
		name		="DecimalValues",
		getFunc	=function() return BUI.Vars.DecimalValues end,
		setFunc	=function(value) BUI.Vars.DecimalValues=value end,
	},
	--In-Combat Opacity
	{	type		="slider",
		name		="FrameOpacityIn",
		min		=0,
		max		=100,
		step		=10,
		getFunc	=function() return BUI.Vars.FrameOpacityIn end,
		setFunc	=function(value) BUI.Menu.UpdateFrames("FrameOpacityIn", value) end,
	},
	--Non-Combat Opacity
	{	type		="slider",
		name		="FrameOpacityOut",
		min		=0,
		max		=100,
		step		=10,
		getFunc	=function() return BUI.Vars.FrameOpacityOut end,
		setFunc	=function(value) BUI.Menu.UpdateFrames("FrameOpacityOut", value) end,
	},
	{type="header",name="AttributeColors"},
	--Health Bar Color
	{	type		="gradient",
		name		="FrameHealthColor",
		getFunc	=function() return BUI.Vars.FrameHealthColor[1],BUI.Vars.FrameHealthColor[2],BUI.Vars.FrameHealthColor[3] end,
		setFunc	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameHealthColor', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1}) end,
		getFunc2	=function() return BUI.Vars.FrameHealthColor1[1],BUI.Vars.FrameHealthColor1[2],BUI.Vars.FrameHealthColor1[3] end,
		setFunc2	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameHealthColor1', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1}) end,
	},
	--Magicka Bar Color
	{	type		="gradient",
		name		="FrameMagickaColor",
		getFunc	=function() return BUI.Vars.FrameMagickaColor[1],BUI.Vars.FrameMagickaColor[2],BUI.Vars.FrameMagickaColor[3] end,
		setFunc	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameMagickaColor', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1}) end,
		getFunc2	=function() return BUI.Vars.FrameMagickaColor1[1],BUI.Vars.FrameMagickaColor1[2],BUI.Vars.FrameMagickaColor1[3] end,
		setFunc2	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameMagickaColor1', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1}) end,
	},
	--Stamina Bar Color
	{	type		="gradient",
		name		="FrameStaminaColor",
		getFunc	=function() return BUI.Vars.FrameStaminaColor[1],BUI.Vars.FrameStaminaColor[2],BUI.Vars.FrameStaminaColor[3] end,
		setFunc	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameStaminaColor', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1}) end,
		getFunc2	=function() return BUI.Vars.FrameStaminaColor1[1],BUI.Vars.FrameStaminaColor1[2],BUI.Vars.FrameStaminaColor1[3] end,
		setFunc2	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameStaminaColor1', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1}) end,
	},
	--Shield Bar Colors
	{	type		="gradient",
		name		="FrameShieldColor",
		getFunc	=function() return BUI.Vars.FrameShieldColor[1],BUI.Vars.FrameShieldColor[2],BUI.Vars.FrameShieldColor[3] end,
		setFunc	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameShieldColor', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1}) end,
		getFunc2	=function() return BUI.Vars.FrameShieldColor1[1],BUI.Vars.FrameShieldColor1[2],BUI.Vars.FrameShieldColor1[3] end,
		setFunc2	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameShieldColor1', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1}) end,
	},
	--Trauma Bar Colors
	{	type		="gradient",
		name		="FrameTraumaColor",
		getFunc	=function() return BUI.Vars.FrameTraumaColor[1],BUI.Vars.FrameTraumaColor[2],BUI.Vars.FrameTraumaColor[3] end,
		setFunc	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameTraumaColor', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1}) end,
		getFunc2	=function() return BUI.Vars.FrameTraumaColor[1],BUI.Vars.FrameTraumaColor[2],BUI.Vars.FrameTraumaColor[3] end,
		setFunc2	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameTraumaColor', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100,1}) end,
	},
	{	type		="button",
		name		="SameColors",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("SameColorsDesc"),func=function()BUI.Menu.Reset("SameColors")end})end,
	},
	{type="header",name="GroupRolesHeader"},	--Group Roles
	--Self Color difference
	{	type		="checkbox",
		name		="SelfColor",
		getFunc	=function() return BUI.Vars.SelfColor end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('SelfColor', value) end,
	},
	--Colorize Roles
	{	type		="checkbox",
		name		="ColorRoles",
		getFunc	=function() return BUI.Vars.ColorRoles end,
		setFunc	=function(value) BUI.Menu.UpdateFrames('ColorRoles', value) end,
	},
	--Tank Role Color
	{	type		="colorpicker",
		name		="FrameTankColor",
		getFunc	=function() return unpack(BUI.Vars.FrameTankColor) end,
		setFunc	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameTankColor', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100}) end,
		disabled	=function() return not BUI.Vars.ColorRoles end,
	},
	--Healer Role Color
	{	type		="colorpicker",
		name		="FrameHealerColor",
		getFunc	=function() return unpack(BUI.Vars.FrameHealerColor) end,
		setFunc	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameHealerColor', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100}) end,
		disabled	=function() return not BUI.Vars.ColorRoles end,
	},
	--DD Role Color
	{	type		="colorpicker",
		name		="FrameDamageColor",
		getFunc	=function() return unpack(BUI.Vars.FrameDamageColor) end,
		setFunc	=function(r,g,b,a) BUI.Menu.UpdateFrames('FrameDamageColor', {math.floor(r*100)/100, math.floor(g*100)/100, math.floor(b*100)/100}) end,
		disabled	=function() return not BUI.Vars.ColorRoles end,
	},
	--Reset Colors
	{	type		="button",
		name		="ColorsReset",
		func		=function()ZO_Dialogs_ShowDialog("BUI_RESET_CONFIRMATION", {text=BUI.Loc("ColorsResetDesc"),func=function()BUI.Menu.Reset("Colors")end})end,
	}}
	MenuPanel["MenuFrameColors"]={name="ColorsHeader"}
	MenuHandlers["MenuFrameColors"]={
	["OnEffectivelyShown"]=BUI.Menu.FramesReposition,
	["OnEffectivelyHidden"]=function() BUI.Menu.FramesRestore() BUI.inMenu=false end,
	}

	MenuOptions["MenuMeters"]={
	{	type		="checkbox",
		name		="Meter_Speed",
		getFunc	=function() return BUI.Vars.Meter_Speed end,
		setFunc	=function(value) BUI.Vars.Meter_Speed=value BUI.Meters.Initialize() end,
	},
	{	type		="checkbox",
		name		="Meter_Power",
		getFunc	=function() return BUI.Vars.Meter_Power end,
		setFunc	=function(value) BUI.Vars.Meter_Power=value BUI.Meters.Initialize() end,
	},
	{	type		="checkbox",
		name		="Meter_Crit",
		getFunc	=function() return BUI.Vars.Meter_Crit end,
		setFunc	=function(value) BUI.Vars.Meter_Crit=value BUI.Meters.Initialize() end,
	},
	{	type		="checkbox",
		name		="Meter_Exp",
		getFunc	=function() return BUI.Vars.Meter_Exp end,
		setFunc	=function(value) BUI.Vars.Meter_Exp=value BUI.Meters.Initialize() end,
	},
	{	type		="checkbox",
		name		="Meter_DPS",
		getFunc	=function() return BUI.Vars.Meter_DPS end,
		setFunc	=function(value) BUI.Vars.Meter_DPS=value BUI.Meters.Initialize() end,
	},
	{	type		="checkbox",
		name		="Meter_Criminal",
		getFunc	=function() return BUI.Vars.Meter_Criminal end,
		setFunc	=function(value) BUI.Vars.Meter_Criminal=value BUI.Meters.Initialize() end,
	},
	{	type		="slider",
		name		="Meter_Scale",
		min		=80,
		max		=200,
		step		=10,
		getFunc	=function() return BUI.Vars.Meter_Scale or BUI.Meters.Default.Meter_Scale end,
		setFunc	=function(value) BUI.Vars.Meter_Scale=value BUI.Meters.Initialize() end,
	}}
	MenuPanel["MenuMeters"]={name="Meters_Header"}
	MenuHandlers["MenuMeters"]={
	["OnEffectivelyShown"]=function()
		BUI.inMenu=true
		BanditsUI:SetHidden(false)
	end,
	["OnEffectivelyHidden"]=function()
		BUI.inMenu=false
	end,
	}

end

function BUI.Menu.MakeList(var)
	local fs=18
	local data,options,values={},{},{}
	for id,value in pairs(var) do
		if value then
			table.insert(data,{type(id)=="number" and GetAbilityName(id) or id,id})
		end
	end
	table.sort(data,function(a,b) return a[1]<b[1] end)
	for i,value in ipairs(data) do
		options[i]=type(value[2])=="number" and zo_iconFormat(GetAbilityIcon(value[2]),fs,fs).."["..value[2].."] "..value[1] or value[1]
		values[i]=value[2]
	end
	return options,values
end

function BUI.Menu.MakeBuffsList()
	local fs=18
	local options,values={},{}
	local i=0
	for name,data in pairs(BUI.Stats.Current[BUI.ReportN].PlayerBuffs) do
		if name then
			i=i+1
			options[i]=zo_iconFormat(GetAbilityIcon(data.id),fs,fs).."["..data.id.."] "..name
			values[i]=data.id
		end
	end
	return options,values
end

function BUI.Menu.Initialize()
	if BUI.init.Menu then return true end
	local AdvancedMenu=true
	--Setup the menu
	MenuOptions_Init()
	for index,data in pairs(MenuOptions) do
		local Options={}
		for i=1, #data do
			if not data[i].advanced or AdvancedMenu then
				if data[i].type=="submenu" then
					local controls={}
					for j=1, #data[i].controls do
						if (not data[i].controls[j].advanced or AdvancedMenu) and (not data[i].controls[j].curved or(data[i].controls[j].curved and BUI.Vars.CurvedFrame~="Disabled")) then
							table.insert(controls, data[i].controls[j])
						end
					end
					table.insert(Options, {["type"]="submenu",["name"]=data[i].name,["controls"]=controls})
				else
					table.insert(Options, data[i])
				end
			end
		end
		MenuPanel[index].name=MenuNumber[index].."|t32:32:"..MenuIcon[index].."|t"..BUI.Loc(MenuPanel[index].name)
--		LAMb:RegisterAddonPanel("BUI_"..index, MenuPanel[index])
		BUI.Menu.RegisterPanel("BUI_"..index, MenuPanel[index])
		if MenuHandlers[index] then for event,handler in pairs(MenuHandlers[index]) do _G["BUI_"..index]:SetHandler(event, handler) end end
--		LAMb:RegisterOptionControls("BUI_"..index, Options)
		BUI.Menu.RegisterOptions("BUI_"..index, Options)
	end
	BUI.init.Menu=true
end

function BUI.Menu:FramesReposition()
	BUI.inMenu=true
	--Unit Frames Display
	if BUI.init.Frames then
		if BUI.Vars.TargetFrame then
			BUI_TargetFrame:SetHidden(false)
		end
		if BUI.Vars.PlayerFrame then
			--Show the player frame
			if not BUI.Vars.FrameHorisontal then
				BUI_PlayerFrame:ClearAnchors()
				BUI_PlayerFrame:SetAnchor(LEFT,BUI_MenuPlayerFrames,RIGHT,20,0)
			end
			BUI_PlayerFrame_Base:SetHidden(false)
			BUI_PlayerFrame_Base:SetAlpha(BUI.Vars.FrameOpacityIn/100)
			BUI.Frames.Regen('player',3,nil,2000) BUI.Frames.Regen('player',4,nil,2000)
			if BUI_TargetFrame then
				BUI_TargetFrame:SetHidden(false)
				BUI.Frames.Regen('reticleover',3,nil,2000) BUI.Frames.Regen('reticleover',4,nil,2000)
			end
		end
		if BUI.Vars.CurvedFrame~=0 then
			BUI.Curved.Initialize()
			BUI_Curved:ClearAnchors()
			BUI_Curved:SetAnchor(CENTER,BUI_MenuPlayerFrames,RIGHT,300,BUI.Vars.CurvedOffset)
			BUI.Curved.Regen('player',3,nil,2000) BUI.Curved.Regen('player',4,nil,2000)
			BUI_Curved_Alt:SetHidden(false)
			BUI_Curved:SetAlpha(BUI.Vars.FrameOpacityIn/100)
			BUI_CurvedTarget:ClearAnchors()
			BUI_CurvedTarget:SetAnchor(CENTER,BUI_MenuPlayerFrames,RIGHT,300,BUI.Vars.CurvedOffset)

			--Spoof a shield
			BUI.Curved.Shield('player',math.floor(BUI.Player.health.max*.5),BUI.Player.health.pct,BUI.Player.health.max,BUI.Player.trauma.current)
			BUI.Curved.Trauma('player',math.floor(BUI.Player.health.max*.25),BUI.Player.health.pct,BUI.Player.health.max,BUI.Player.shield.current)

			if not BUI.Vars.CurvedShift then
				BUI_CurvedTarget:SetHidden(false)
				BUI_CurvedTarget:SetAlpha(BUI.Vars.FrameOpacityIn/100)
				BUI.Curved.Regen('reticleover',3,nil,2000) BUI.Curved.Regen('reticleover',4,nil,2000)
			end
		end
		if BUI.Vars.BossFrame then
			if BUI.Frame["boss1"] then BUI.Frame["boss1"]:SetHidden(false) end
		end
	end
	--Spoof a shield on the player frame
	BUI.Player:UpdateShield('player', math.floor(BUI.Player.health.max*.5),	BUI.Player.health.max)
	--Spoof trauma on the player frame
	BUI.Player:UpdateTrauma('player', math.floor(BUI.Player.health.max*.25),	BUI.Player.health.max)
	--Show the UI layer
	BanditsUI:SetHidden(false)
end

function BUI.Menu.FramesRestore()
	BUI.inMenu=false
	--Unit Frames Display
	if BUI.init.Frames then
		if BUI.Vars.TargetFrame then
			BUI_TargetFrame:SetHidden(true)
		end
		if BUI.Vars.PlayerFrame then
			BUI_PlayerFrame:ClearAnchors()
			local anchor=BUI.Vars.FrameHorisontal and BUI.Vars.BUI_HPlayerFrame or BUI.Vars.BUI_PlayerFrame
			BUI_PlayerFrame:SetAnchor(anchor[1],BanditsUI,anchor[2],anchor[3],anchor[4])
		end
		if BUI.Vars.CurvedFrame~=0 then
			BUI.Curved.Initialize()
		end
		if BUI.Vars.BossFrame then
			if BUI.Frame["boss1"] then BUI.Frame["boss1"]:SetHidden(true) end
		end
	end
	BUI.Player:UpdateShield('player')
	BUI.Player:UpdateTrauma('player')
	--Toggle visibility
	BanditsUI:SetHidden(not BUI_SettingsWindow:IsHidden())
end

function BUI.Menu.Update(setting, value, reload)
	BUI.Vars[setting]=value
	if reload then SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8,"Reloading UI") BUI.CallLater("ReloadUI",1000,ReloadUI) end
end

function BUI.Menu.Reset(context)
	--Reset everything
	if not context then
		for var, value in pairs(BUI.Defaults) do BUI.Vars[var]=value end
		SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8,"Reloading UI") BUI.CallLater("ReloadUI",1000,ReloadUI)
	--Reset unit frames
	elseif context=="Frames" then
		for var, value in pairs(BUI.Frames.Defaults) do BUI.Vars[var]=value end
		BUI.Menu.UpdateFrames()
		BUI.Menu.UpdateOptions("BUI_MenuPlayerFrames")
		BUI.Menu.UpdateOptions("BUI_MenuTargetFrames")
		BUI.Menu.UpdateOptions("BUI_MenuGroupFrames")
	elseif context=="Positions" then
		if MoveMode_1 then
			local frames={
				"BUI_OnScreen","BUI_PlayerFrame","BUI_HPlayerFrame","BUI_TargetFrame","BUI_BossFrame","BUI_RaidFrame","BUI_MiniMeter",
				"BUI_BuffsP","BUI_BuffsPas","BUI_BuffsT","BUI_BuffsC",
				"BUI_Meter_Speed","BUI_Meter_Power","BUI_Meter_Crit","BUI_Meter_Exp","BUI_Meter_DPS","BUI_Meter_Criminal"
				}
			for _,frame in pairs(frames) do BUI.Vars[frame]=BUI.Defaults[frame] end
		end
		if MoveMode_2 then
			for frame in pairs(BUI.DefaultFrames) do BUI.Vars[frame]=nil end
		end
		if MoveMode_1 or MoveMode_2 then
			SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8,"Reloading UI") BUI.CallLater("ReloadUI",1000,ReloadUI)
		end
	elseif context=="Curved" then
		for var, value in pairs(BUI.Curved.Defaults) do BUI.Vars[var]=value end
		BUI.Curved.Initialize()
		BUI.Menu.UpdateOptions("BUI_MenuCurvedFrames")
	elseif context=="Stats" then
		for var, value in pairs(BUI.Stats.Defaults) do BUI.Vars[var]=value end
		BUI.Stats:Initialize()
		BUI.Menu.UpdateOptions("BUI_MenuDamageStatistics")
	elseif context=="Buffs" then
		for var, value in pairs(BUI.Buffs.Defaults) do BUI.Vars[var]=value end
		BUI.Buffs:Initialize()
		BUI.Menu.UpdateOptions("BUI_MenuBuffs")
	elseif context=="Actions" then
		for var, value in pairs(BUI.Actions.Defaults) do BUI.Vars[var]=value end
		BUI.Actions:Initialize()
		BUI.Menu.UpdateOptions("BUI_MenuActions")
	elseif context=="Minimap" then
		for var, value in pairs(BUI.MiniMap.Defaults) do BUI.Vars[var]=value end
		BUI.MiniMap.Initialize()
		BUI.Menu.UpdateOptions("BUI_MenuMinimap")
	elseif context=="Colors" then
		for var, value in pairs(BUI.Colors.Defaults) do BUI.Vars[var]=value end
		BUI.Menu.UpdateFrames()
		BUI.Menu.UpdateOptions("BUI_MenuFrameColors")
	elseif context=="SameColors" then
		local vars={"FrameHealthColor","FrameMagickaColor","FrameStaminaColor","FrameShieldColor","FrameTraumaColor"}
		for _,var in pairs(vars) do BUI.Vars[var.."1"]=BUI.Vars[var] end
		BUI.Menu.UpdateFrames()
		BUI.Menu.UpdateOptions("BUI_MenuFrameColors")
	elseif context=="DefaultFrames" then
		local frames={"ZO_PlayerAttributeMagicka","ZO_PlayerAttributeStamina","ZO_PlayerAttributeSiegeHealth"}
		for frame in pairs(frames) do BUI.Vars[frame]=nil end
	end
end

function BUI.Menu.UpdateFrames(setting,value,...)
	--Maybe apply a new setting
	if (setting and value~=nil) then BUI.Vars[setting]=value end
	--Rebuild the frames dynamically
	BUI.Frames:Controls()
	--Reset the fade animation
	BUI.Frames.resetAnim=true
	--Re-populate the frames
	BUI.Frames.SetupPlayer()
	if BUI_RaidFrame then BUI.Frames:SetupGroup() end
	--Position the frame for menu display
	BUI.Menu.FramesReposition()
	if setting=="FramesTexture" then BUI.Frames.ChangeTextures() end
end

function BUI.Menu.MarkerLeader(init)
	if BUI.Vars.MarkerLeader then
		SetFloatingMarkerInfo(MAP_PIN_TYPE_GROUP_LEADER, BUI.Vars.MarkerSize, "/esoui/art/tutorial/gamepad/gp_playermenu_icon_store.dds")
	elseif not init then
		SetFloatingMarkerInfo(MAP_PIN_TYPE_GROUP_LEADER)
	end
end

--Manage widgets
local function ShowWidgetButtons(self)
	BUI_Menu_Move_B1:ClearAnchors() BUI_Menu_Move_B1:SetAnchor(TOPRIGHT,self,TOPRIGHT,-5,5+16) BUI_Menu_Move_B1:SetParent(self) BUI_Menu_Move_B1:SetHidden(false)
	BUI_Menu_Move_B2:ClearAnchors() BUI_Menu_Move_B2:SetAnchor(TOPRIGHT,self,TOPRIGHT,-5,5) BUI_Menu_Move_B2:SetParent(self) BUI_Menu_Move_B2:SetHidden(false)
	BUI_Menu_Move_B3:ClearAnchors() BUI_Menu_Move_B3:SetAnchor(TOPRIGHT,self,TOPRIGHT,-5-16,5) BUI_Menu_Move_B3:SetParent(self) BUI_Menu_Move_B3:SetHidden(false)
	BUI_Menu_Move_B4:ClearAnchors() BUI_Menu_Move_B4:SetAnchor(TOPRIGHT,self,TOPRIGHT,-5-16,5+16) BUI_Menu_Move_B4:SetParent(self) BUI_Menu_Move_B4:SetHidden(false)
end

local function WidgetContext_UI(parent)	--Context menu
	local name=parent:GetName()
	local fs=17
	local w,h=260,fs*1.5*10+20+28
	local header=tonumber(parent.index) and "["..parent.index.."] "..parent.name:GetText() or parent.index
	local ui	=BUI.UI.TopLevelWindow("BUI_Menu_Context",	parent,	{w,h},	{TOP,BOTTOM,0,0}, false) ui:SetDrawTier(2)
	ui.bg		=BUI.UI.Backdrop(	"BUI_Menu_Context_Bg",		ui,		{w,h},		{TOPLEFT,TOPLEFT,0,0},	{0,0,0,.9}, {0.4,0.4,0.4,.9}, nil, false)
	BUI.UI.Label(	"BUI_Menu_Context_Id",	ui,	{w-20,fs*1.5},		{TOPLEFT,TOPLEFT,10,5},	BUI.UI.Font("esobold",fs,true), {.6,.6,.4,1}, {1,1}, header,	false)
	--Progress bar
	local label=BUI.UI.Label(	"BUI_Menu_Context_pBar_Label",	ui,	{w-15,fs*1.5},		{TOPLEFT,TOPLEFT,10,5+fs*1.5*1},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsProgress"))
	local enable=BUI.Vars[name] and BUI.Vars[name][8]
	BUI.UI.CheckBox("BUI_Menu_Context_pBar", label, {20,20}, {RIGHT,RIGHT,0,0}, enable,
		function(value)
			if not BUI.Vars[name] then BUI.Vars[name]={[8]=value} else BUI.Vars[name][8]=value end
			BUI.Frames.Widgets_Init(name)
			local ability=_G[name] if ability then ability:SetHandler("OnMouseEnter", ShowWidgetButtons) end
		end)
	--Progress bar side
	local label=BUI.UI.Label(	"BUI_Menu_Context_Side_Label",	ui,	{w-15,fs*1.5},		{TOPLEFT,TOPLEFT,10,5+fs*1.5*2},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsPSide"))
	local side=BUI.Vars[name] and BUI.Vars[name][6]
	BUI.UI.SimpleButton("BUI_Menu_Context_Side", label, {20,20}, {RIGHT,RIGHT,0,0}, (side and "/esoui/art/buttons/leftarrow_disabled.dds" or "/esoui/art/buttons/rightarrow_disabled.dds"), false,
		function(self)
			local side=BUI.Vars[name] and BUI.Vars[name][6]
			side=not side
			if not BUI.Vars[name] then BUI.Vars[name]={[6]=side} else BUI.Vars[name][6]=side end
			self:SetTexture(side and "/esoui/art/buttons/leftarrow_disabled.dds" or "/esoui/art/buttons/rightarrow_disabled.dds")
			BUI.Frames.Widgets_Init(name)
			local ability=_G[name] if ability then ability:SetHandler("OnMouseEnter", ShowWidgetButtons) end
		end)
	--Multi target
	local label=BUI.UI.Label(	"BUI_Menu_Context_mTarg_Label",	ui,	{w-15,fs*1.5},		{TOPLEFT,TOPLEFT,10,5+fs*1.5*3},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsMultiTarget"))
	local enable=BUI.Vars[name] and BUI.Vars[name][9]
	BUI.UI.CheckBox("BUI_Menu_Context_mTarg", label, {20,20}, {RIGHT,RIGHT,0,0}, enable,
		function(value)
			if not BUI.Vars[name] then BUI.Vars[name]={[9]=value} else BUI.Vars[name][9]=value end
		end)
	--Player effects
	local label=BUI.UI.Label(	"BUI_Menu_Context_Self_Label",	ui,	{w-15,fs*1.5},		{TOPLEFT,TOPLEFT,10,5+fs*1.5*4},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsSelfEffects"))
	local enable=not (BUI.Vars[name] and BUI.Vars[name][10])
	BUI.UI.CheckBox("BUI_Menu_Context_Self", label, {20,20}, {RIGHT,RIGHT,0,0}, enable,
		function(value)
			if not BUI.Vars[name] then BUI.Vars[name]={[10]=not value} else BUI.Vars[name][10]=not value end
		end)
	--Always show
	local label=BUI.UI.Label(	"BUI_Menu_Context_AllwaysShow_Label",	ui,	{w-15,fs*1.5},		{TOPLEFT,TOPLEFT,10,5+fs*1.5*5},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsAlwaysShow"))
	local enable=(BUI.Vars[name] and BUI.Vars[name][12])
	BUI.UI.CheckBox("BUI_Menu_Context_AllwaysShow", label, {20,20}, {RIGHT,RIGHT,0,0}, enable,
		function(value)
			if not BUI.Vars[name] then BUI.Vars[name]={[12]=value} else BUI.Vars[name][12]=value end
		end)
	--Ability cooldown
	local label=BUI.UI.Label(	"BUI_Menu_Context_Cooldown_Label",	ui,	{w-10-fs*4,fs*1.5},	{TOPLEFT,TOPLEFT,10,10+fs*1.5*6},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, GetString(SI_GAMEPAD_TOOLTIP_COOLDOWN_HEADER))
	label:SetMouseEnabled(true)
	label:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, BOTTOM, BUI.Loc("WidgetsCooldownDesc")) end)
	label:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
	BUI.UI.TextBox("BUI_Menu_Context_Cooldown",	ui,	{fs*4,fs*1.2},	{TOPLEFT,TOPLEFT,w-10-fs*4,10+fs*1.5*6},	5,	(BUI.Vars[name] and BUI.Vars[name][7] or parent.duration) or "",
		function(value)
			value=tonumber(value)
			if value and value>1000 then
				if not BUI.Vars[name] then BUI.Vars[name]={[7]=value} else BUI.Vars[name][7]=value end
			else
				if BUI.Vars[name] then BUI.Vars[name][7]=nil end
				BUI_Menu_Context_Cooldown.eb:SetText(parent.duration or "")
			end
		end)
	--Combine
	local label=BUI.UI.Label(	"BUI_Menu_Context_Combine_Label",	ui,	{w-10-fs*4,fs*1.5},	{TOPLEFT,TOPLEFT,10,10+fs*1.5*7},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsCombine"))
	label:SetMouseEnabled(true)
	label:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, BOTTOM, BUI.Loc("WidgetsCombineDesc")) end)
	label:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
	BUI.UI.TextBox("BUI_Menu_Context_Combine",	ui,	{fs*4,fs*1.2},	{TOPLEFT,TOPLEFT,w-10-fs*4,10+fs*1.5*7},	20,	tostring(BUI.Vars[name] and BUI.Vars[name][11] or ""),
		function(value)
			local id=tonumber(value)
			local WidgetId=(id and id>100 and id<900000) and id or string.len(value)>3 and value or nil
--			d(WidgetId)
			if WidgetId then
				BUI.Vars.Widgets[WidgetId]=true
				if not BUI.Vars[name] then BUI.Vars[name]={[11]=WidgetId} else BUI.Vars[name][11]=WidgetId end
				local refer_name="BUI_Widget_"..string.gsub(WidgetId," ","_")
				if not BUI.Vars[refer_name] then BUI.Vars[refer_name]={[11]=true} else BUI.Vars[refer_name][11]=true end
			else
				a("Additional effect was removed",SOUNDS.NEGATIVE_CLICK)
				if BUI.Vars[name] then BUI.Vars[name][11]=nil end
				BUI_Menu_Context_Combine.eb:SetText("")
			end
		end)
	--Sound
	local label=BUI.UI.Label(	"BUI_Menu_Context_Sound_Label",	ui,	{w-10-fs*4,fs*1.5},	{TOPLEFT,TOPLEFT,10,10+fs*1.5*8},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, GetString(SI_AUDIO_OPTIONS_SOUND_ENABLED))
--	label:SetMouseEnabled(true)
--	label:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, BOTTOM, BUI.Loc("WidgetsSoundDesc")) end)
--	label:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
	local array={"Activation","Deactivation","Both","Disabled"}
	BUI.UI.ComboBox("BUI_Menu_Context_Sound",	ui,	{fs*7+2,fs*1.5},	{TOPLEFT,TOPLEFT,w-10-fs*7,10+fs*1.5*8}, array, (BUI.Vars[name] and BUI.Vars[name][13] or 4),
		function(i)
			if not BUI.Vars[name] then BUI.Vars[name]={[13]=i} else BUI.Vars[name][13]=i end
		end)
	--Delete
	local label=BUI.UI.Label(	"BUI_Menu_Context_Delete_Label",	ui,	{w-15,fs*1.5},		{TOPLEFT,TOPLEFT,10,10+fs*1.5*9},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, GetString(SI_MAIL_DELETE))
	BUI.UI.SimpleButton("BUI_Menu_Context_Delete", label, {20,20}, {RIGHT,RIGHT,0,0}, 4, false, function()BUI.Buffs.RemoveFrom(BUI.Vars.Widgets,parent.index,"Widgets")end)
	--Close button
	local button=BUI_Menu_Context_Close or WINDOW_MANAGER:CreateControlFromVirtual("BUI_Menu_Context_Close", ui, "ZO_DefaultButton")
	button:SetWidth(90, 28)
	button:SetText(GetString(SI_DIALOG_CLOSE))
	button:SetAnchor(BOTTOM,ui,BOTTOM,0,-10)
	button:SetClickSound("Click")
	button:SetFont("ZoFontGame")
	button:SetHandler("OnClicked", function()BUI_Menu_Context:SetHidden(true)end)
end

local function ManageWidgets_UI()		--Manage widgets
	local fs=17
	local rs=fs*1.8
	local w,h=280,rs*8+20+28
	local choices,values=BUI.Menu.MakeList(BUI.Vars.Widgets)
	BUI.ActionsUpdate()
	local a_choices,a_values=BUI.Menu.MakeList(BUI.Actions.AbilityBar)
	local b_choices,b_values=BUI.Menu.MakeBuffsList()
	local ResetFunc	=function(i,value)
		local value=values[i]
		if BUI.Vars.Widgets[value] then
			local id="BUI_Widget_"..string.gsub(value," ","_")
			local frame=_G[id]
			if BUI.Vars[id] then
				BUI.Vars[id][1]=CENTER
				BUI.Vars[id][2]=CENTER
				BUI.Vars[id][3]=0
				BUI.Vars[id][4]=0
			else
				BUI.Vars[id]={CENTER,CENTER,0,0}
			end
			if frame then
				frame:ClearAnchors()
				frame:SetAnchor(CENTER,BanditsUI,CENTER,0,0)
			end
		else
			a("Widget \""..tostring(value).."\" is not found")
		end
	end
	local AddWidget=function(value)
		BUI.Buffs.AddTo(BUI.Vars.Widgets,value,"Widgets")
		local frame=_G["BUI_Widget_"..string.gsub(value," ","_")]
		if frame then
			frame:SetHidden(false)
			frame:SetHandler("OnMouseEnter", function(self) ShowWidgetButtons(self) end)
			frame:SetMovable(true)
		end
		choices,values=BUI.Menu.MakeList(BUI.Vars.Widgets)
		BUI_Menu_WManage_Reset_DropBox:UpdateValues(choices)
		BUI_Menu_WManage_Delete_DropBox:UpdateValues(choices)
	end

	local function AddTooltip(parent,text)	--Help
		if parent.help then return end
		parent.help=WINDOW_MANAGER:CreateControl("$(parent)Help", parent, CT_TEXTURE)
		parent.help:SetDimensions(26,26)
		parent.help:SetAnchor(RIGHT,parent,RIGHT,0,0)
		parent.help:SetTexture('/esoui/art/help/help_tabicon_tutorial_up.dds')
		parent.help:SetMouseEnabled(true)
		parent.help:SetHandler("OnMouseEnter", function(self)ZO_Tooltips_ShowTextTooltip(self,BOTTOM,text)end)
		parent.help:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
	end
	local ui	=BUI.UI.TopLevelWindow("BUI_Menu_WManage",	BanditsUI,	{w,h},	{RIGHT,RIGHT,-20,0}) ui:SetDrawTier(1)
	ui:SetMouseEnabled(true) ui:SetMovable(true)
	ui.bg		=BUI.UI.Backdrop(	"BUI_Menu_WManage_Bg",		ui,		{w,h},		{TOPLEFT,TOPLEFT,0,0},	{0,0,0,.9}, {0.4,0.4,0.4,.9})
	BUI.UI.Label(	"BUI_Menu_WManage_Id",	ui,	{w-20,rs},		{TOPLEFT,TOPLEFT,10,5},	BUI.UI.Font("esobold",fs,true), {.6,.6,.4,1}, {1,1}, BUI.Loc("WidgetsManage"))
	BUI.UI.Label(	"BUI_Menu_WManage_Add_Label",	ui,	{w*.5-10,rs},		{TOPLEFT,TOPLEFT,10,5+rs*1},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsAdd"))
	--Add ability widget
	local label=BUI.UI.Label(	"BUI_Menu_WManage_Add_Ability",	ui,	{w*.5-10,rs},		{TOPLEFT,TOPLEFT,10,5+rs*2},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsAbility"))
	local box=BUI.UI.ComboBox(	"BUI_Menu_WManage_Add_Ability_DropBox", label, {w*.5-10,28}, {TOPLEFT,TOPRIGHT,0,0}, a_choices, nil, function(i,value)AddWidget(a_values[i])end)
	box:SetDisabled(not BUI.Vars.Actions)
	if not BUI.Vars.Actions then AddTooltip(label,BUI.Loc("WidgetsAbilityDesc")) elseif label.help then label.help:SetHidden(true) end
	--Add buff widget
	local label=BUI.UI.Label(	"BUI_Menu_WManage_Add_Buff",	ui,	{w*.5-10,rs},		{TOPLEFT,TOPLEFT,10,5+rs*3},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsBuff"))
	local box=BUI.UI.ComboBox(	"BUI_Menu_WManage_Add_Buff_DropBox", label, {w*.5-10,28}, {TOPLEFT,TOPRIGHT,0,0}, b_choices, nil, function(i,value)AddWidget(b_values[i])end)
	box:SetDisabled(not BUI.Vars.EnableStats or not BUI.Vars.StatsBuffs)
	if not BUI.Vars.EnableStats or not BUI.Vars.StatsBuffs then AddTooltip(label,BUI.Loc("WidgetsBuffDesc")) elseif label.help then label.help:SetHidden(true) end
	--Add custom widget
	local label=BUI.UI.Label(	"BUI_Menu_WManage_Add_Custom",	ui,	{w*.5-10,rs},		{TOPLEFT,TOPLEFT,10,5+rs*4},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsCustom"))
	BUI.UI.TextBox(	"BUI_Menu_WManage_Add_Custom_TextBox",	ui,	{w*.5-10,fs*1.2},	{TOPLEFT,TOPLEFT,w*.5,10+rs*4},	20,	"", function(value)AddWidget(value)end)
	AddTooltip(label,BUI.Loc("WidgetsAddDesc"))
	--Reset position
	local label=BUI.UI.Label(	"BUI_Menu_WManage_Reset",	ui,	{w*.5-10,rs},		{TOPLEFT,TOPLEFT,10,5+rs*6},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, BUI.Loc("WidgetsReset"))
	BUI.UI.ComboBox(	"BUI_Menu_WManage_Reset_DropBox", label, {w*.5-10,28}, {TOPLEFT,TOPRIGHT,0,0}, choices, nil, ResetFunc)
	--Delete widget
	local label=BUI.UI.Label(	"BUI_Menu_WManage_Delete",	ui,	{w*.5-10,rs},		{TOPLEFT,TOPLEFT,10,5+rs*7},	BUI.UI.Font("standard",fs,true), {.6,.6,.4,1}, {0,1}, GetString(SI_MAIL_DELETE))
	BUI.UI.ComboBox(	"BUI_Menu_WManage_Delete_DropBox", label, {w*.5-10,28}, {TOPLEFT,TOPRIGHT,0,0}, choices, nil, function(i,value)BUI.Buffs.RemoveFrom(BUI.Vars.Widgets,values[i],"Widgets")end)
	--Close button
	local button=BUI_Menu_WManage_Close or WINDOW_MANAGER:CreateControlFromVirtual("BUI_Menu_WManage_Close", ui, "ZO_DefaultButton")
	button:SetWidth(90, 28)
	button:SetText(GetString(SI_DIALOG_CLOSE))
	button:SetAnchor(BOTTOM,ui,BOTTOM,0,-10)
	button:SetClickSound("Click")
	button:SetFont("ZoFontGame")
	button:SetHandler("OnClicked", function()BUI.Menu.ManageWidgets(false)end)
end

local function MoveFramesButtons()
	--Add additional elements
	local ahchor=BUI.UI.Texture("BUI_Menu_Move_Anchor",	BanditsUI,	{26,26},	{TOP,TOP,0,5},	"/esoui/art/icons/mapkey/mapkey_dock.dds", false)
	move_anchor=BanditsUI
	if move_init then return end
	ahchor:SetDrawLayer(3)

	BUI.UI.SimpleButton("BUI_Menu_Move_B1", BanditsUI, {16,16}, {TOPRIGHT,TOPRIGHT,0,0}, "/esoui/art/miscellaneous/gamepad/arrow_down.dds", false,
		function(self)
			local frame=self:GetParent()
			local name=frame:GetName() if BUI.Vars.FrameHorisontal and name=="BUI_PlayerFrame" then name="BUI_HPlayerFrame" end
			BUI.Menu:SaveAnchor(frame,move_anchor)
			frame:ClearAnchors() frame:SetAnchor(BUI.Vars[name][1],BanditsUI,BUI.Vars[name][2],BUI.Vars[name][3],BUI.Vars[name][4])
		end,
		"Center frame by anchor")

	BUI.UI.SimpleButton("BUI_Menu_Move_B2", BanditsUI, {16,16}, {TOPRIGHT,TOPRIGHT,0,0}, "/esoui/art/icons/mapkey/mapkey_dock.dds", false,
		function(self)
			move_anchor=move_anchor==BanditsUI and self:GetParent() or BanditsUI
			ahchor:ClearAnchors() ahchor:SetAnchor(TOP,move_anchor,TOP,0,5) ahchor:SetHidden(false)
		end,
		"Set frame as anchor")

	BUI.UI.SimpleButton("BUI_Menu_Move_B3", BanditsUI, {16,16}, {TOPRIGHT,TOPRIGHT,0,0}, "/esoui/art/inventory/inventory_icon_hiddenby.dds", false,
		function(self)
			self:GetParent():SetHidden(true)
--			BUI_Menu_Move_B1:SetHidden(true) BUI_Menu_Move_B2:SetHidden(true) BUI_Menu_Move_B3:SetHidden(true) BUI_Menu_Move_B4:SetHidden(true)
		end,
		"Temporarily hide")

	BUI.UI.SimpleButton("BUI_Menu_Move_B4", BanditsUI, {16,16}, {TOPRIGHT,TOPRIGHT,0,0}, "/esoui/art/guild/gamepad/gp_guild_menuicon_customization.dds", false,
		function(self) WidgetContext_UI(self:GetParent()) end,
		"Settings")

	move_init=true
end

function BUI.Menu.ManageWidgets(move)
	if SCENE_MANAGER:IsInUIMode() and not WINDOW_MANAGER:IsSecureRenderModeEnabled() then SCENE_MANAGER:SetInUIMode(false) end
	--Move elements back to their normal positions
	if move then
		BUI.Menu.FramesRestore()
		ZO_WorldMap:SetHidden(true)
		BanditsUI.line_vert	=BUI.UI.Line("BanditsUI_Line_vert",	BanditsUI,	{0,BanditsUI:GetHeight()},	{TOPLEFT,TOP,0,0},	{.2,.8,.2,.5},1.8, false)
		BanditsUI.line_hor	=BUI.UI.Line("BanditsUI_Line_hor",	BanditsUI,	{BanditsUI:GetWidth(),0},	{TOPLEFT,LEFT,0,0},	{.2,.8,.2,.5},1.8, false)
		if BUI.Vars.CurvedFrame~=0 then
--			BUI.Curved.Initialize()
			BUI_Curved:SetAlpha(BUI.Vars.FrameOpacityIn/100)
			BUI_CurvedTarget:SetHidden(false)
			BUI_CurvedTarget:SetAlpha(BUI.Vars.FrameOpacityIn/100)
			BUI_Curved_Alt:SetHidden(false)
		end
		ManageWidgets_UI()
	else
		BanditsUI_Line_vert:SetHidden(true)
		BanditsUI_Line_hor:SetHidden(true)
		if BUI_Menu_Context then BUI_Menu_Context:SetHidden(true) end
		if BUI.Vars.CurvedFrame~=0 then
--			BUI.Curved.Initialize()
			BUI_Curved:SetAlpha(0) BUI_CurvedTarget:SetAlpha(0)
		end
		if BUI_Menu_WManage then BUI_Menu_WManage:SetHidden(true) end
	end

	--Unit Frames
	MoveFramesButtons()
	if BUI.Vars.EnableWidgets then
		for _id,enable in pairs(BUI.Vars.Widgets) do
			local id=string.gsub(_id," ","_")
			local ability=_G["BUI_Widget_"..id]
			if ability and enable then
				local data=BUI.Vars["BUI_Widget_"..id] if not data then data={} end
				ability:SetHidden(not (move or data[12]))
				ability:SetHandler("OnMouseEnter", move and function(self) ShowWidgetButtons(self) end or BUI.Buffs.ShowTooltip)
				ability:SetMovable(move)
				ability.timer:SetText("")
				ability.progress:SetHidden(not (move and data[8]))
				ability.bar:SetWidth(BUI.Vars.WidgetsPWidth-4)
			end
		end
	end
--	/script for id in pairs(BUI.Vars.Widgets) do _G["BUI_Widget_"..string.gsub(id," ","_")]:SetHidden(false) end
	SetGameCameraUIMode(move)
	BUI.move=move
	--Register events
	if move then
		local function OnLayerChange(eventCode, layerIndex, activeLayerIndex)
			if layerIndex<=4 and activeLayerIndex>2 then
				BanditsUI:SetHandler("OnEffectivelyShown", nil)
				BUI.Menu.ManageWidgets(false)
			end
		end
		--EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_ACTION_LAYER_POPPED	,OnLayerChange)
		EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_ACTION_LAYER_PUSHED	,OnLayerChange)
	else
		BUI_Menu_Move_Anchor:SetHidden(true) BUI_Menu_Move_B1:SetHidden(true) BUI_Menu_Move_B2:SetHidden(true) BUI_Menu_Move_B3:SetHidden(true) BUI_Menu_Move_B4:SetHidden(true)
		EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_ACTION_LAYER_POPPED)
		EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_ACTION_LAYER_PUSHED)
	end
end

--Move frames
local function MoveDefaultFrames(move)
	if BUI.init.DefaultFrames then
		BUI_Move:SetHidden(not move)
	elseif move then
		BUI.UI.TopLevelWindow("BUI_Move",GuiRoot,{GuiRoot:GetWidth(),GuiRoot:GetHeight()},{CENTER,CENTER,0,0},false)
		for name,desc in pairs(BUI.DefaultFrames) do
			local frame=_G[name]
			local lX,lY,anchorPoint=0,0,CENTER
			if frame and not (name=="ZO_LootHistoryControl_Keyboard" and BUI.GamepadMode) and not (name=="ZO_LootHistoryControl_Gamepad" and not BUI.GamepadMode) then
			if name=="ZO_LootHistoryControl_Keyboard" then
				lX,lY=-300,-95
				anchorPoint=BOTTOMRIGHT
			elseif name=="ZO_LootHistoryControl_Gamepad" then
				lX,lY=260,-95
				anchorPoint=BOTTOMLEFT
			elseif name=="ZO_AlertTextNotification" then
				lX=ZO_Compass:GetRight()+40-GuiRoot:GetRight()
				lY=100
				anchorPoint=TOPRIGHT
			elseif name=="ZO_PlayerAttributeMagicka" then
				anchorPoint=RIGHT
			elseif name=="ZO_PlayerAttributeStamina" then
				anchorPoint=LEFT
			elseif name=="ZO_EndDunHUDTrackerContainer" then
				frame:SetWidth(200)
				lX,lY=-100,-20
				anchorPoint=BOTTOMRIGHT
			end
			local w,h=frame:GetDimensions()
			if w==0 then w=14 end w=w+math.abs(lX)
			if h==0 then h=14 end h=h+math.abs(lY)
			local bg=BUI.UI.Backdrop(name.."_BUI_BG",	frame,	{w,h},	{CENTER,CENTER,lX/2,lY/2},	{0,.1,.4,0.3}, {0,0,0,1}, nil, false)
			bg:SetParent(BUI_Move)
			BUI.UI.Label(name.."_BUI_Label",	bg,	{string.len(desc)*14,14},	{CENTER,CENTER,0,0},	BUI.UI.Font("trajan",14,true), nil, {1,1}, desc, false)
			BUI.UI.Line(name.."_Line_hor",	bg,	{w+200,0},	{TOPLEFT,LEFT,-100,0},	{.8,.8,.8,.4},1.8, false)
			BUI.UI.Line(name.."_Line_vert",	bg,	{0,h+200},	{TOPLEFT,TOP,0,-100},	{.8,.8,.8,.4},1.8, false)
			bg:SetMovable(true)
			bg:SetMouseEnabled(true)
			bg:SetHandler("OnMouseUp", function(self)
				BUI.Menu:SaveAnchor(self,nil,name,anchorPoint)
				BUI.Frames.ZO_Frame_reposition()
				end)
			end
		end
		BUI.init.DefaultFrames=true
	end
	BUI.moveDefault=move
end

function BUI.Menu.MoveFrames(move)
	if not (MoveMode_1 or MoveMode_2) then return end
	if SCENE_MANAGER:IsInUIMode() and not WINDOW_MANAGER:IsSecureRenderModeEnabled() then SCENE_MANAGER:SetInUIMode(false) end
	--Move elements back to their normal positions
	if move then
		BUI.inMenu=false
		BUI.Menu.FramesRestore()
		ZO_WorldMap:SetHidden(true)
		BanditsUI.line_vert	=BUI.UI.Line("BanditsUI_Line_vert",	BanditsUI,	{0,BanditsUI:GetHeight()},	{TOPLEFT,TOP,0,0},	{.2,.8,.2,.5},1.8, false)
		BanditsUI.line_hor	=BUI.UI.Line("BanditsUI_Line_hor",	BanditsUI,	{BanditsUI:GetWidth(),0},	{TOPLEFT,LEFT,0,0},	{.2,.8,.2,.5},1.8, false)
	else
		BanditsUI_Line_vert:SetHidden(true)
		BanditsUI_Line_hor:SetHidden(true)
	end

	local function ShowButtons(self)
		BUI_Menu_Move_B1:ClearAnchors() BUI_Menu_Move_B1:SetAnchor(TOPRIGHT,self,TOPRIGHT,-5,5+16) BUI_Menu_Move_B1:SetParent(self) BUI_Menu_Move_B1:SetHidden(false)
		BUI_Menu_Move_B2:ClearAnchors() BUI_Menu_Move_B2:SetAnchor(TOPRIGHT,self,TOPRIGHT,-5,5) BUI_Menu_Move_B2:SetParent(self) BUI_Menu_Move_B2:SetHidden(false)
		BUI_Menu_Move_B3:ClearAnchors() BUI_Menu_Move_B3:SetAnchor(TOPRIGHT,self,TOPRIGHT,-5-16,5) BUI_Menu_Move_B3:SetParent(self) BUI_Menu_Move_B3:SetHidden(false)
		BUI_Menu_Move_B4:SetHidden(true)
	end
	--Unit Frames
	MoveFramesButtons()
	if BUI.init.Frames and MoveMode_1 then
		local frames={}
		if BUI.Vars.RaidFrames then table.insert(frames, BUI_RaidFrame) end
		if BUI.Vars.PlayerFrame then table.insert(frames, BUI_PlayerFrame) end
		if BUI.Vars.TargetFrame and BUI_TargetFrame~=nil then table.insert(frames, BUI_TargetFrame) end
		if BUI.Vars.PlayerBuffs then table.insert(frames, BUI_BuffsP) end
		if BUI.Vars.EnableCustomBuffs then table.insert(frames, BUI_BuffsC) end
		if BUI.Vars.EnableSynergyCd then table.insert(frames, BUI_BuffsS) end
		if BUI.Vars.TargetBuffs then table.insert(frames, BUI_BuffsT) end
		if BUI.Vars.BuffsPassives=="On additional panel" then table.insert(frames, BUI_BuffsPas) end
		if BUI.Vars.BossFrame then table.insert(frames, BUI_BossFrame) end
		if BUI.Vars.MiniMap then table.insert(frames, BUI_Minimap) end
		if BUI.Vars.NotificationsTrial or BUI.Vars.NotificationsWorld or BUI.Vars.NotificationsGroup then table.insert(frames, BUI_OnScreen) table.insert(frames, BUI_OnScreenS) end
		if BUI.Vars.Glyphs and BUI_Glyphs then table.insert(frames, BUI_Glyphs) end
		if BUI.Vars.StatsMiniMeter then table.insert(frames, BUI_MiniMeter) end
		if BUI.Vars.StatsGroupDPSframe then table.insert(frames, BUI_GroupDPS) end
		if BUI.Vars.Attackers then table.insert(frames, BUI_Attackers) end
		for _,name in pairs(BUI.Meters.List) do
			if BUI.Vars["Meter_"..name] then table.insert(frames, _G["BUI_Meter_"..name]) end
		end		
		for _, frame in pairs(frames) do
			frame:SetMouseEnabled(move)
			frame:SetHidden(false)
			frame:SetAlpha(1)
			frame:SetHandler("OnMouseEnter", ShowButtons)
			if frame.backdrop then frame.backdrop:SetHidden(not move) end
			if frame.base then frame.base:SetHidden(move) end
			if move then
				local name=frame:GetName()
				local width=frame:GetWidth()
				local height=frame:GetHeight()
				frame.line_top	=BUI.UI.Line(name.."_Line_top",	frame,	{width+600,0},	{TOPLEFT,TOPLEFT,-300,0},	{.8,.8,.8,.3},1.8, false)
				frame.line_bot	=BUI.UI.Line(name.."_Line_bot",	frame,	{width+600,0},	{TOPLEFT,BOTTOMLEFT,-300,0},	{.8,.8,.8,.3},1.8, false)
				frame.line_left	=BUI.UI.Line(name.."_Line_left",	frame,	{0,height+600},	{TOPLEFT,TOPLEFT,0,-300},	{.8,.8,.8,.3},1.8, false)
				frame.line_right	=BUI.UI.Line(name.."_Line_right",	frame,	{0,height+600},	{TOPLEFT,TOPRIGHT,0,-300},	{.8,.8,.8,.3},1.8, false)
				frame.line_hor	=BUI.UI.Line(name.."_Line_hor",	frame,	{width+200,0},	{TOPLEFT,LEFT,-100,0},		{.8,.8,.8,.3},1.8, false)
				frame.line_vert	=BUI.UI.Line(name.."_Line_vert",	frame,	{0,height+200},	{TOPLEFT,TOP,0,-100},		{.8,.8,.8,.3},1.8, false)
			else
				frame.line_top:SetHidden(true)
				frame.line_bot:SetHidden(true)
				frame.line_left:SetHidden(true)
				frame.line_right:SetHidden(true)
				frame.line_hor:SetHidden(true)
				frame.line_vert:SetHidden(true)
			end
		end
		--If we are done moving, make sure frame visibility is correct
		if not move then
			BUI.Frames:SetupPlayer()
			if BUI_TargetFrame then BUI_TargetFrame:SetHidden(true) end
			BUI.Frames:SetupGroup()
			if BUI.Vars.MiniMap then BUI.MiniMap.Show() end
		end
	end
	if MoveMode_2 then MoveDefaultFrames(move) end
	SetGameCameraUIMode(move)
	BUI.move=move
	--Register events
	if move then
		local function OnLayerChange(eventCode, layerIndex, activeLayerIndex)
		--	d(BUI.TimeStamp().." ["..eventCode.."] "..layerIndex.." "..activeLayerIndex)
			--We only need to act if it's in move mode
			if not BUI.move and not BUI.moveDefault then return end
			if layerIndex<=4 and activeLayerIndex>2 then
			--Unregister events
				EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_ACTION_LAYER_POPPED)
				EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_ACTION_LAYER_PUSHED)
				BanditsUI:SetHandler("OnEffectivelyShown", nil)
				if BUI.move then BUI.Menu.MoveFrames(false) end
		--		if BUI.moveDefault then BUI.Menu:MoveDefaultFrames(false) end
			end
		end
		--EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_ACTION_LAYER_POPPED	,OnLayerChange)
		EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_ACTION_LAYER_PUSHED	,OnLayerChange)
	else
		BUI_Menu_Move_Anchor:SetHidden(true) BUI_Menu_Move_B1:SetHidden(true) BUI_Menu_Move_B2:SetHidden(true) BUI_Menu_Move_B3:SetHidden(true) BUI_Menu_Move_B4:SetHidden(true)
	end
end

function BUI.Menu:SaveAnchor(control,anchor,name,anchorPoint,widget_side,widget_cd,widget_progress,multi_target,self_effects,combine,allwaysshow,sound)
	--Get anchor position
	local anchorX=0
	local w,h=control:GetWidth(),control:GetHeight()
	anchorPoint=anchorPoint or CENTER
	if anchor and anchor~=BanditsUI then
		local _, point, _, _, offsetX, offsetY=anchor:GetAnchor()
		offsetX=point==128 and offsetX or((point==3 or point==6) and offsetX-GuiRoot:GetWidth()/2+w/2 or GuiRoot:GetWidth()/2+offsetX-w/2)
--		offsetY=point==128 and offsetY or((point==3 or point==9) and offsetY-GuiRoot:GetHeight()/2+h/2 or GuiRoot:GetHeight()/2+offsetY-h/2)
		anchorX=math.floor(offsetX*10)/10 --offsetY=math.floor(offsetY*10)/10
	end
	--Get the new position
	local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY=control:GetAnchor()
	if not isValidAnchor then return end
	--Save the anchors
	offsetX=math.floor(offsetX*10)/10 offsetY=math.floor(offsetY*10)/10
	frame=control:GetName() if BUI.Vars.FrameHorisontal and frame=="BUI_PlayerFrame" then frame="BUI_HPlayerFrame" end
	name=name or frame
	if frame=="BUI_RaidFrame" then
		offsetX=point==128 and offsetX or((point==3 or point==6) and offsetX-GuiRoot:GetWidth()/2 or GuiRoot:GetWidth()/2+offsetX-w)
		offsetY=point==128 and offsetY or((point==3 or point==9) and offsetY-GuiRoot:GetHeight()/2 or GuiRoot:GetHeight()/2+offsetY-h)
		offsetX=math.floor(offsetX*10)/10 offsetY=math.floor(offsetY*10)/10
		BUI.Vars[frame]={TOPLEFT,CENTER,offsetX,offsetY}
	else
--		local anchor_name={[BOTTOM]="BOTTOM",[BOTTOMLEFT]="BOTTOMLEFT",[BOTTOMRIGHT]="BOTTOMRIGHT",[CENTER]="CENTER",[LEFT]="LEFT",[NONE]="NONE",[RIGHT]="RIGHT",[TOP]="TOP",[TOPLEFT]="TOPLEFT",[TOPRIGHT]="TOPRIGHT"}
--		d(frame..": "..anchor_name[point]..", "..anchor_name[relativePoint]..", "..offsetX.. ", "..offsetY)
		offsetX=point==128 and offsetX or((point==3 or point==6) and offsetX-GuiRoot:GetWidth()/2+w/2 or GuiRoot:GetWidth()/2+offsetX-w/2)
		offsetY=point==128 and offsetY or((point==3 or point==9) and offsetY-GuiRoot:GetHeight()/2+h/2 or GuiRoot:GetHeight()/2+offsetY-h/2)
		offsetX=math.floor(offsetX*10)/10 offsetY=math.floor(offsetY*10)/10
		if anchorPoint==RIGHT or anchorPoint==BOTTOMRIGHT or anchorPoint==TOPRIGHT then offsetX=offsetX+w/2
		elseif anchorPoint==LEFT or anchorPoint==BOTTOMLEFT or anchorPoint==TOPLEFT then offsetX=offsetX-w/2
		end
		if anchorPoint==BOTTOM or anchorPoint==BOTTOMRIGHT or anchorPoint==BOTTOMRIGHT then offsetY=offsetY+h/2
		elseif anchorPoint==TOP or anchorPoint==TOPRIGHT or anchorPoint==TOPLEFT then offsetY=offsetY-h/2
		end
		BUI.Vars[name]={[1]=anchorPoint,[2]=CENTER,[3]=(anchor and anchorX or offsetX),[4]=offsetY,[6]=widget_side,[7]=widget_cd,[8]=widget_progress,[9]=multi_target,[10]=self_effects,[11]=combine,[12]=allwaysshow,[13]=sound}
--		d("New: "..anchor_name[anchorPoint]..", "..anchor_name[CENTER]..", "..(anchor and anchorX or offsetX)..", "..offsetY)
	end
end
