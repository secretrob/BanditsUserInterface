-- Core Bandits User Interface Settings

BUI	={
	name				="BanditsUserInterface",
	DisplayName			="|c4B8BFEBandits|cFEFEFE User Interface|r",	--"|c4B8BFEBandits|r User Interface",
	ShortName			="|c4B8BFEBandits|r UI",
	URL					="http://bandits-clan.ru/",
	Version				=4.401,
	language			=tostring(GetCVar("language.2")),
	API					=GetAPIVersion(),
	GamepadMode			=IsInGamepadPreferredMode(),
	ESOVersion			=string.match(GetESOVersionString(), "eso.([%w%-]+.[%w%-]+.[%w%-]+.[%w%-])"),
	GroupMembers		={},
	Enemy				={},
	Attacker			={},
	Controlled			={},
	CControl			=0,
	Stats				={},
	Menu				={},
	Frame				={},
	Damage				={},
	Player				={},
	Group				={},
	Target				={},
	QuickSlots			={},
	Reticle				={},
	Log					={},
	OnScreen			={Message={},Group={}},
	Proc				={},
	GroupSynergy		={},
	SynergyTexture		={},
	CurrentPair			=1,
	Widgets				={},
	GroupDPS_text		="",
	GroupDPS_tip		="",
	BossFight			=false,
	GroupBuffsLoopActive	=false,
	PvPzone				=false,
	InGroup				=false,
	abilityframe		="/BanditsUserInterface/textures/theme/abilityframe64_up.dds",
	NeedToEat			=false,
	PotionEndTime		=0,
	Cloudrest			={Group=0,Plus=0,Timer=0,Init=0,Fallen=0,Hoarfrost=0},
	PingMap				=PingMap,
	Markers				=0,
	GroupMarker			={},
	Penetration={
		Target={
			[GetAbilityName(62787)]=5948,--Major Breach
			[GetAbilityName(62588)]=2974,--Minor Breach
			[GetAbilityName(17906)]=2108,--Crusher (Standard: 1622, Infused: 2108, Infused with Torugs: 2740)
			[GetAbilityName(61743)]=5948,--Major Breach
			[GetAbilityName(61742)]=2974,--Minor Breach
			[GetAbilityName(75753)]=3010,--Line-Breaker(Alkosh)
			[GetAbilityName(120018)]=3010,--Line-Breaker(Amalgamm)
			[GetAbilityName(159288)]=3541,--Crimson Outh's Rive
		},
		Self={
			[51176]=860,--Twice-Fanged Serpent
		},
	},
	Defaults={
		SidePanel			={},
		CustomBar			={},
		ChampionHelper		=true,
		Champion			={[1]={},[2]={},[3]={}},
		DeveloperMode		=false,
		PlayerStatSection	=false,
		PvPmode				=true,
		Theme				=2,
		CustomEdgeColor		={0,.07,.07,1},
		AdvancedThemeColor	={.5,.6,1,.9},
		Log					=false,
		--Reticle
		InCombatReticle		=true,
		PreferredTarget		=true,
		ImpactAnimation		=true,
		ReticleMode			=1,
		TauntTimer			=1,
		ReticleResist		=3,
		LeaderArrow			=false,
		ReticleInvul		=false,
		CastBar			=3,
		--Notifications
		NotificationsGroup	=true,
		OnScreenPriorDeath	=true,
		NotificationsTrial	=true,
		NotificationsWorld	=true,
		NotificationFood	=true,
		NotificationsSize	=32,
		NotificationsTimer	=3000,
		EffectVisualisation	=true,
		BUI_OnScreen		={CENTER,CENTER,0,-110},
		BUI_OnScreenS		={CENTER,CENTER,360,-210},
		Glyphs				=true,
		NotificationSound_1	="Champion_PointsCommitted",
		NotificationSound_2	="No_Sound",
		--QuickSlots
		QuickSlots			=true,
		QuickSlotsShow		=4,
		QuickSlotsInventory	=true,
	},
	Frames={
		Defaults={
		--Player Frame
		PlayerFrame			=true,
		DefaultPlayerFrames	=false,
		RepositionFrames	=true,
		BUI_PlayerFrame		={TOPRIGHT,CENTER,-250,200},
		BUI_HPlayerFrame	={CENTER,CENTER,0,410},
		FramesTexture		="rounded",
		FramesBorder		=1,
		EnableNameplate		=true,
		FoodBuff			=true,
		EnableXPBar			=true,
		FrameWidth			=280,
		FrameHeight			=22,
		FrameHorisontal		=true,
		DodgeFatigue		=false,
		FramesFade			=false,
		FrameShowMax		=false,
		FramePercents		=false,
		--Target Frame
		TargetFrame			=false,
		TargetWidth			=320,
		TargetHeight		=22,
		TargetFrameTextAlign="default",
		DefaultTargetFrame	=true,
		DefaultTargetFrameText	=true,
		BUI_TargetFrame		={TOPLEFT,CENTER,250,200},
		ExecuteThreshold	=25,
		ExecuteSound		=false,
		BossFrame			=true,
		BossWidth			=280,
		BossHeight			=28,
--		BUI_BossFrame		={LEFT,LEFT,50,120},
		Attackers			=nil,
		AttackersWidth		=280,
		AttackersHeight		=28,
		--Group Frame
		RaidFrames			=true,
		GroupAnimation		=true,
		GroupDeathSound		="Lockpicking_unlocked",
		BUI_RaidFrame		={TOPLEFT,TOPLEFT,50,160},
		RaidLevels			=true,
		RaidWidth			=220,
		RaidHeight			=32,
		RaidColumnSize		=6,
		RaidFontSize		=17,
		--Advanced
		GroupElection		=true,
		GroupBuffs			=false,
		StatusIcons			=true,
		SmallGroupScale		=120,
		LargeRaidScale		=80,
		RaidSplit			=0,
		RaidSort			=1,
		--StatShare
		StatShare			=true,
		StatShareUlt		=3,	--Disabled
		UltimateOrder		=2,	--Auto
		--Synergy
		GroupSynergy		=3,	--Disabled
		GroupSynergyCount	=2,
		--Group leader
		MarkerLeader		=false,
		MarkerSize			=40,
		}
	},
	Colors={
		Defaults={
		--Shared Settings
		FrameNameFormat		=2,
		FrameFont1			='esobold',
		FrameFont2			='esobold',
		DecimalValues		=true,
		FrameFontSize		=15,
		FrameHealthColor	={150/255,30/255,060/255,1},
		FrameMagickaColor	={0,030/255,220/255,1},
		FrameStaminaColor	={0/255,140/255,030/255,1},
		FrameShieldColor	={250/255,100/255,20/255,1},
		FrameHealthColor1	={255/255,40/255,70/255,1},
		FrameMagickaColor1	={0,122/255,1,1},
		FrameStaminaColor1	={0,210/255,20/255,1},
		FrameShieldColor1	={230/255,100/255,20/255,1},
		FrameOpacityIn		=90,
		FrameOpacityOut		=80,
		ColorRoles			=true,
		FrameTankColor		={219/255,143/255,255/255},
		FrameHealerColor	={255/255,193/255,127/255},
		FrameDamageColor	={224/255,028/255,028/255},
		SelfColor			=true,
		FrameTraumaColor    ={150/255,50/255,255/255,1},
		FrameTraumaColor1   ={075/255,0/255,150/255,1},
		}
	},
	init={
		Menu				=false,
		inMenu				=false,
		move				=false,
		Frames				=false,
		Curved				=false,
		DefaultFrames		=false,
		MiniMap				=false,
		QS					=false,
		OnScreen			=false,
		},
	DefaultFrames={
		ZO_PlayerAttributeHealth	="Player Health",
		ZO_PlayerAttributeSiegeHealth="Siege Health",
		ZO_PlayerAttributeMagicka	="Player Magicka",
--		"ZO_PlayerAttributeWerewolf",
		ZO_PlayerAttributeStamina	="Player Stamina",
--		"ZO_PlayerAttributeMountStamina",
		ZO_PlayerProgress			="Player Progress",
		ZO_HUDEquipmentStatus		="Equipment Status",
		ZO_SynergyTopLevelContainer	="Synergy",
		ZO_CompassFrame			="Compass Frame",
		ZO_TargetUnitFramereticleover	="Target Unit",
		ZO_ActionBar1			="Action Bar",
--		ZO_SmallGroupAnchorFrame	="Group Frame",	--Disabled at the time of solving the ZO_PlatformStyle update problem
--		"ZO_LargeGroupAnchorFrame1",
--		"ZO_LargeGroupAnchorFrame2",
--		"ZO_LargeGroupAnchorFrame3",
--		"ZO_LargeGroupAnchorFrame4",
--		"ZO_LargeGroupAnchorFrame5",
--		"ZO_LargeGroupAnchorFrame6",
		ZO_FocusedQuestTrackerPanel	="Quest Tracker",
		ZO_PlayerToPlayerAreaPromptContainer	="Player to Player prompt",
		ZO_AlertTextNotification	="Alert text notification",
		ZO_CenterScreenAnnounce		="Center Screen Announce",
		ZO_HUDInfamyMeter			="Infamy Meter",
		ZO_HUDTelvarMeter			="Telvar Meter",
--		ZO_ActiveCombatTips		="Combat tips",
--		"ZO_TutorialHudInfoTipKeyboard",
		ZO_ObjectiveCaptureMeter	="Objective Capture Meter",
		ZO_LootHistoryControl_Keyboard="Loot history",
--		ZO_LootHistoryControl_Gamepad	="Loot history",
		ZO_RamTopLevel			="AvA Ram",
		ZO_Subtitles			="Subtitles",
		ZO_BuffDebuffTopLevelSelfContainerContainer1="Buff / Debuff",
		ZO_EndDunHUDTrackerContainer="Endless Archive",
		},
--	KeyCode={ "KEY_0", "KEY_1", "KEY_2", "KEY_3", "KEY_4", "KEY_5", "KEY_6", "KEY_7", "KEY_8", "KEY_9", "KEY_A", "KEY_ALT", "KEY_B", "KEY_BACKSPACE", "KEY_C", "KEY_CAPSLOCK", "KEY_COMMAND", "KEY_CTRL", "KEY_D", "KEY_DELETE", "KEY_DOWNARROW", "KEY_E", "KEY_END", "KEY_ENTER", "KEY_ESCAPE", "KEY_F", "KEY_F1", "KEY_F10", "KEY_F11", "KEY_F12", "KEY_F13", "KEY_F14", "KEY_F15", "KEY_F16", "KEY_F17", "KEY_F18", "KEY_F19", "KEY_F2", "KEY_F20", "KEY_F21", "KEY_F22", "KEY_F23", "KEY_F24", "KEY_F3", "KEY_F4", "KEY_F5", "KEY_F6", "KEY_F7", "KEY_F8", "KEY_F9", "KEY_G", "KEY_GAMEPAD_BACK", "KEY_GAMEPAD_BACK_HOLD", "KEY_GAMEPAD_BOTH_BACK_START", "KEY_GAMEPAD_BOTH_BUTTON_1_BUTTON_4", "KEY_GAMEPAD_BOTH_BUTTON_2_BUTTON_3", "KEY_GAMEPAD_BOTH_BUTTON_2_BUTTON_4", "KEY_GAMEPAD_BOTH_DPAD_RIGHT_BUTTON_2", "KEY_GAMEPAD_BOTH_LEFT_SHOULDER_BUTTON_1", "KEY_GAMEPAD_BOTH_LEFT_SHOULDER_BUTTON_2", "KEY_GAMEPAD_BOTH_LEFT_SHOULDER_BUTTON_3", "KEY_GAMEPAD_BOTH_LEFT_SHOULDER_BUTTON_4", "KEY_GAMEPAD_BOTH_LEFT_SHOULDER_DPAD_LEFT", "KEY_GAMEPAD_BOTH_LEFT_SHOULDER_LEFT_STICK", "KEY_GAMEPAD_BOTH_LEFT_SHOULDER_RIGHT_STICK", "KEY_GAMEPAD_BOTH_LEFT_TRIGGER_BUTTON_1", "KEY_GAMEPAD_BOTH_RIGHT_SHOULDER_BUTTON_1", "KEY_GAMEPAD_BOTH_RIGHT_SHOULDER_BUTTON_2", "KEY_GAMEPAD_BOTH_RIGHT_SHOULDER_BUTTON_3", "KEY_GAMEPAD_BOTH_RIGHT_SHOULDER_BUTTON_4", "KEY_GAMEPAD_BOTH_SHOULDERS", "KEY_GAMEPAD_BOTH_STICKS", "KEY_GAMEPAD_BOTH_TOUCHPAD_START", "KEY_GAMEPAD_BOTH_TRIGGERS", "KEY_GAMEPAD_BUTTON_1", "KEY_GAMEPAD_BUTTON_1_HOLD", "KEY_GAMEPAD_BUTTON_2", "KEY_GAMEPAD_BUTTON_2_HOLD", "KEY_GAMEPAD_BUTTON_3", "KEY_GAMEPAD_BUTTON_3_HOLD", "KEY_GAMEPAD_BUTTON_4", "KEY_GAMEPAD_BUTTON_4_HOLD", "KEY_GAMEPAD_DPAD_DOWN", "KEY_GAMEPAD_DPAD_DOWN_HOLD", "KEY_GAMEPAD_DPAD_LEFT", "KEY_GAMEPAD_DPAD_LEFT_HOLD", "KEY_GAMEPAD_DPAD_RIGHT", "KEY_GAMEPAD_DPAD_RIGHT_HOLD", "KEY_GAMEPAD_DPAD_UP", "KEY_GAMEPAD_DPAD_UP_HOLD", "KEY_GAMEPAD_LEFT_SHOULDER", "KEY_GAMEPAD_LEFT_SHOULDER_HOLD", "KEY_GAMEPAD_LEFT_STICK", "KEY_GAMEPAD_LEFT_STICK_HOLD", "KEY_GAMEPAD_LEFT_TRIGGER", "KEY_GAMEPAD_LEFT_TRIGGER_HOLD", "KEY_GAMEPAD_LSTICK_DOWN", "KEY_GAMEPAD_LSTICK_LEFT", "KEY_GAMEPAD_LSTICK_RIGHT", "KEY_GAMEPAD_LSTICK_UP", "KEY_GAMEPAD_RIGHT_SHOULDER", "KEY_GAMEPAD_RIGHT_SHOULDER_HOLD", "KEY_GAMEPAD_RIGHT_STICK", "KEY_GAMEPAD_RIGHT_STICK_HOLD", "KEY_GAMEPAD_RIGHT_TRIGGER", "KEY_GAMEPAD_RIGHT_TRIGGER_HOLD", "KEY_GAMEPAD_RSTICK_DOWN", "KEY_GAMEPAD_RSTICK_LEFT", "KEY_GAMEPAD_RSTICK_RIGHT", "KEY_GAMEPAD_RSTICK_UP", "KEY_GAMEPAD_START", "KEY_GAMEPAD_START_HOLD", "KEY_GAMEPAD_TOUCHPAD_HOLD", "KEY_GAMEPAD_TOUCHPAD_PRESSED", "KEY_GAMEPAD_TOUCHPAD_SWIPE_DOWN", "KEY_GAMEPAD_TOUCHPAD_SWIPE_LEFT", "KEY_GAMEPAD_TOUCHPAD_SWIPE_RIGHT", "KEY_GAMEPAD_TOUCHPAD_SWIPE_UP", "KEY_GAMEPAD_TOUCHPAD_TOUCHED", "KEY_H", "KEY_HOME", "KEY_I", "KEY_INSERT", "KEY_INVALID", "KEY_J", "KEY_K", "KEY_L", "KEY_LEFTARROW", "KEY_LWINDOWS", "KEY_M", "KEY_MOUSEWHEEL_DOWN", "KEY_MOUSEWHEEL_UP", "KEY_MOUSE_4", "KEY_MOUSE_5", "KEY_MOUSE_LEFT", "KEY_MOUSE_LEFTRIGHT", "KEY_MOUSE_MIDDLE", "KEY_MOUSE_RIGHT", "KEY_N", "KEY_NUMLOCK", "KEY_NUMPAD0", "KEY_NUMPAD1", "KEY_NUMPAD2", "KEY_NUMPAD3", "KEY_NUMPAD4", "KEY_NUMPAD5", "KEY_NUMPAD6", "KEY_NUMPAD7", "KEY_NUMPAD8", "KEY_NUMPAD9", "KEY_NUMPAD_ADD", "KEY_NUMPAD_DOT", "KEY_NUMPAD_ENTER", "KEY_NUMPAD_MINUS", "KEY_NUMPAD_SLASH", "KEY_NUMPAD_STAR", "KEY_O", "KEY_OEM_102_GERMAN_LESS_THAN", "KEY_OEM_1_SEMICOLON", "KEY_OEM_2_FORWARD_SLASH", "KEY_OEM_3_TICK", "KEY_OEM_4_LEFT_SQUARE_BRACKET", "KEY_OEM_5_BACK_SLASH", "KEY_OEM_6_RIGHT_SQUARE_BRACKET", "KEY_OEM_7_SINGLE_QUOTE", "KEY_OEM_COMMA", "KEY_OEM_MINUS", "KEY_OEM_PERIOD", "KEY_OEM_PLUS", "KEY_P", "KEY_PAGEDOWN", "KEY_PAGEUP", "KEY_PAUSE", "KEY_PRINTSCREEN", "KEY_Q", "KEY_R", "KEY_RIGHTARROW", "KEY_RWINDOWS", "KEY_S", "KEY_SCROLLLOCK", "KEY_SHIFT", "KEY_SPACEBAR", "KEY_T", "KEY_TAB", "KEY_U", "KEY_UPARROW", "KEY_V", "KEY_W", "KEY_X", "KEY_Y", "KEY_Z" }
	Textures={
		none			='',
		grainy			='/BanditsUserInterface/textures/attribute/bar_grainy.dds',
		barrel			='/BanditsUserInterface/textures/attribute/bar_barrel.dds',
		tube			='/BanditsUserInterface/textures/attribute/bar_tube.dds',
		rounded			='/BanditsUserInterface/textures/attribute/bar_rounded.dds',
		loadingbar		='/esoui/art/screens/gamepad/loadingbar_fill.dds',
--		attributebar	='/esoui/art/unitattributevisualizer/gamepad/gp_attributebar_small_fill_center.dds',
		enlightenment	='/esoui/art/miscellaneous/progressbar_enlightenment_fill.dds'
	},
	Texture_edge={
		none			='/BanditsUserInterface/textures/attribute/bar_enlightenment_edge.dds',
		grainy			='/BanditsUserInterface/textures/attribute/bar_grainy_edge.dds',
		barrel			='/BanditsUserInterface/textures/attribute/bar_barrel_edge.dds',
		tube			='/BanditsUserInterface/textures/attribute/bar_tube_edge.dds',
		rounded			='/BanditsUserInterface/textures/attribute/bar_rounded_edge.dds',
		loadingbar		='/BanditsUserInterface/textures/attribute/bar_loadingbar_edge.dds',
--		attributebar	='/esoui/art/unitattributevisualizer/gamepad/gp_attributebar_small_fill_center.dds',
		enlightenment	='/BanditsUserInterface/textures/attribute/bar_enlightenment_edge.dds'
	},
	border={
		[1]={"",2,2,2},	--Plain
		[2]={"/BanditsUserInterface/textures/theme/attributebar_thin_2.dds",4,2,1},	--Thin
		[3]={"/BanditsUserInterface/textures/theme/attributebar_thin_2.dds",4,2,1},	--Thin	--Need to add new border
		[4]={"/BanditsUserInterface/textures/theme/attributebar_copper_16.dds",16,16,8,true},	--Clockwork
		[5]={"/BanditsUserInterface/textures/theme/attributebar_blade_16.dds",16,12,3},	--Blade
		[6]={"/BanditsUserInterface/textures/theme/attributebar_round_8.dds",8,4,2},	--Round
		[7]={"/BanditsUserInterface/textures/theme/attributebar_round_8.dds",8,4,2},	--Dragon
		},
	progress={
		[1]="/BanditsUserInterface/textures/theme/progressbar_right_2.dds",	--Standart
		[2]="/BanditsUserInterface/textures/theme/progressbar_right_2.dds",	--Standart smooth
		[3]="/BanditsUserInterface/textures/theme/progressbar_right_2.dds",	--Standart flat
		[4]="/BanditsUserInterface/textures/theme/progressbar_right_2.dds",	--Custom gloss
		[5]="/BanditsUserInterface/textures/theme/progressbar_right_2.dds",	--Custom flat
		[6]="/BanditsUserInterface/textures/theme/progressbar_right_2.dds",	--Pink pony
		[7]="/BanditsUserInterface/textures/theme/progressbar_right_2.dds",	--Advanced
		},
	Localization={},
	Loc	=function(var) return BUI.Localization[BUI.language] and BUI.Localization[BUI.language][var] or BUI.Localization.en[var] or var end
	}

function BUI:JoinTables(t1,t2)
	local t1=t1 or {}
	local t2=t2 or {}
	for k,v in pairs(t2) do t1[k]=v end
	return t1
end
BUI:JoinTables(BUI.Defaults,BUI.Frames.Defaults)
BUI:JoinTables(BUI.Defaults,BUI.Colors.Defaults)

BUI.Defaults.LastVersion=BUI.Version

function BUI.TranslateFont(font)
	--Maintain a translation between tags and names
	local fonts={
--		['meta']		="Metamorphous",
		["standard"]	="ESO Standard",
		["esobold"]		="ESO Bold",
		["antique"]		="Prose Antique",
		["handwritten"]	="Handwritten",
		["trajan"]		="Trajan Pro",
		["futura"]		="Futura Standard",
		["futurabold"]	="Futura Bold",
		gamepad_medium	="Gamepad Standard",
		gamepad_bold	="Gamepad Bold"
	}
	--Iterate through the table matching
	for k,v in pairs(fonts) do
		if (font==k) then return v
		elseif (font==v) then return k end
	end
end

function BUI.TranslateColor(color)
	return "R:"..math.floor(color[1]*255).." G:"..math.floor(color[2]*255).." B:"..math.floor(color[3]*255).." ("..BUI.ColorString(unpack(color))..")"
end