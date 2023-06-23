	--DAMAGE STATISTICS COMPONENT
local PingConfirmed=0
local StatShare_Code=74
local DamageTimeout=5000
local ReportToShow, LastSection, LastTarget, TargetBuffsIsExpanded
local BuffsSection=true
local BUFF_W=355
local ChampionDisciplineColor={[CHAMPION_DISCIPLINE_TYPE_CONDITIONING]={.7,.2,.2,1},[CHAMPION_DISCIPLINE_TYPE_COMBAT]={.4,.4,.9,1},[CHAMPION_DISCIPLINE_TYPE_WORLD]={.2,.7,.2,1}}
local _seconds=BUI.language=="ru" and "|r сек." or BUI.language=="de" and "|r Sekunden" or BUI.language=="fr" and "|r secondes" or BUI.language=="br" and "|r segundos" or "|r seconds"
local AbilityIcons={
	[103]="esoui/art/tutorial/swap_button_up.dds",	--Swap
	--Resource gain
	[62796]='/esoui/art/icons/ability_mage_013.dds',			--Minor Magickasteal
	[63114]='/esoui/art/icons/ability_mage_013.dds',			--Arcane Well
	[45223]='/esoui/art/icons/consumable_potion_002_type_005.dds',	--Restore Magicka
	[45225]='/esoui/art/icons/consumable_potion_003_type_005.dds',	--Restore Stamina
	[55400]='/esoui/art/icons/ability_undaunted_004.dds',			--Magicka Restore (orb)
	[87876]='/esoui/art/icons/ability_warden_017.dds',			--Bety Netch
	[88483]='/esoui/art/icons/passive_warden_006.dds',			--Natures Give
	[63110]='/esoui/art/champion/champion_points_health_icon.dds',	--Spell Absorption
	[34813]='/esoui/art/icons/gear_dunmer_light_shirt_a.dds',		--Magicka Furnace
	[16270]='/esoui/art/icons/ability_mage_057.dds',			--Brace Cost
	[55678]='/esoui/art/icons/passive_templar_002.dds',			--Undaunted Commando
	[55679]='/esoui/art/icons/passive_templar_002.dds',			--Undaunted Commando
	[32760]='/esoui/art/icons/death_recap_magic_ranged.dds',		--Heavy Attack (Restoration)
	[60763]='/esoui/art/icons/death_recap_fire_ranged.dds',		--Heavy Attack (Fire)
	[60764]='/esoui/art/icons/death_recap_shock_ranged.dds',		--Heavy Attack (Shock)
	[60762]='/esoui/art/icons/death_recap_cold_ranged.dds',		--Heavy Attack (Frost)
	[58430]='/esoui/art/icons/passive_armor_014.dds',			--Constitution
	[45382]='/esoui/art/icons/consumable_potion_001_type_005.dds',	--Restore Health
	[44986]='/esoui/art/icons/ability_dragonknight_031.dds',		--Battle Roar
	[33733]='/esoui/art/icons/ability_dragonknight_012_b.dds',		--Draw Essence
	--Ultimate gain
	[37555]='/esoui/art/icons/ability_nightblade_007_b.dds',		--Soul Harvest
	[63707]='/esoui/art/icons/passive_sorcerer_046.dds',			--Amhibious Regen
	[42495]='/esoui/art/icons/ability_mageguild_005_a.dds',		--Shooting Star
	}
BUI.Stats.Defaults={
	EnableStats			=true,
	BUI_MiniMeter		={TOPRIGHT,TOP,-400,0},
	BUI_GroupDPS		={TOPLEFT,TOP,-400,120},
--	BUI_Targets			={TOPRIGHT,TOPRIGHT,-260,0},
--	BUI_BuffsUp			={TOPLEFT,TOPLEFT,260,0},
	ReportScale			=1,
	StatTriggerHeals		=false,
	StatsShareDPS		=true,
	StatsUpdateDPS		=false,
	StatsGroupDPS		=false,
	StatsGroupDPSframe	=false,
--	CalculateGroupDPS		=true,
	StatsMiniMeter		=true,
	ReticleDpS			=false,
	MiniMeterAplha		=.8,
--	GroupDPS			=true,
	StatsMiniHealing		=false,
	StatsMiniGroupDps		=true,
	StatsMiniSpeed		=false,
	StatsFontSize		=18,
	StatsTransparent		=true,
	StatsSplitElements	=true,
	StatsBuffs			=true,
	Reports			={},
}
BUI:JoinTables(BUI.Defaults,BUI.Stats.Defaults)
local SLOTS={
EQUIP_SLOT_HEAD,
EQUIP_SLOT_SHOULDERS,
EQUIP_SLOT_CHEST,
EQUIP_SLOT_WAIST,
EQUIP_SLOT_HAND,
EQUIP_SLOT_LEGS,
EQUIP_SLOT_FEET,

EQUIP_SLOT_NECK,
EQUIP_SLOT_RING1,
EQUIP_SLOT_RING2,

EQUIP_SLOT_MAIN_HAND,
EQUIP_SLOT_OFF_HAND,
EQUIP_SLOT_POISON,

EQUIP_SLOT_BACKUP_MAIN,
EQUIP_SLOT_BACKUP_OFF,
EQUIP_SLOT_BACKUP_POISON,
}
local RaceIcon={
"breton_01",
"redguard_01",
"orc_01",
"dunmer_01",
"nord_01",
"argonian_01",
"altmer_01",
"bosmer_01",
"khajiit_01",
"imperial_01",
}
--	/script for i=0,11 do d("["..i.."]"..tostring(GetRaceName(nil,i))) end
--[[
function BUI.Stats:BuffsUp_Init()	--BuffsUp REPORT
	local fs=BUI.Vars.StatsFontSize
	local BuffsUp	=BUI.UI.Control(	"BUI_BuffsUp",			BanditsUI,	{270+fs*7,200},	BUI.Vars.BUI_BuffsUp,			true)
	BuffsUp.backdrop	=BUI.UI.Backdrop(	"BUI_BuffsUp_BG",			BuffsUp,	"inherit",		{CENTER,CENTER,0,0},			{0,0,0,0.25}, {0,0,0,0}, nil, false)
--	BuffsUp:SetAlpha(1)
	BuffsUp:SetMouseEnabled(true)
	BuffsUp:SetMovable(true)
	BuffsUp:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	--Headers
	BuffsUp.namesH	=BUI.UI.Label(	"BUI_BuffsUp_NamesHeader",	BuffsUp,	{270,25},		{TOPLEFT,TOPLEFT,10,5},			BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "Buff"	, false)
	BuffsUp.timeH	=BUI.UI.Label(	"BUI_BuffsUp_TimeHeader",	BuffsUp,	{fs*3,25},		{LEFT,RIGHT,0,0,BuffsUp.namesH},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "Time"	, false)
--	BuffsUp.damageH	=BUI.UI.Label(	"BUI_BuffsUp_DamageHeader",	BuffsUp,	{90,25},		{LEFT,RIGHT,0,0,BuffsUp.timeH},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "Damage"	, false)
	BuffsUp.percentH	=BUI.UI.Label(	"BUI_BuffsUp_PercentHeader",	BuffsUp,	{fs*4,25},		{LEFT,RIGHT,0,0,BuffsUp.timeH},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "%%"	, false)
	--Divider
	BuffsUp.divider	=BUI.UI.Texture(	"BUI_BuffsUp_Divider",		BuffsUp,	{270+fs*7-40,8},	{TOPLEFT,TOPLEFT,20,32},		'EsoUI/Art/Miscellaneous/horizontalDivider.dds', false)
	BuffsUp.divider:SetTextureCoords(0.181640625, 0.818359375, 0, 1) BuffsUp:SetDrawLayer(DL_OVERLAY)
	--List
	local list		=BUI.UI.Control(	"BUI_BuffsUp_List",		BuffsUp,	{270,600},		{TOPLEFT,TOPLEFT,10,40},		false)
	BuffsUp.names	=BUI.UI.Label(	"BUI_BuffsUp_Names",		list,		"inherit",		{TOP,TOP,0,0},				BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false)
	BuffsUp.time	=BUI.UI.Label(	"BUI_BuffsUp_Time",		list,		{fs*3,600},		{LEFT,RIGHT,0,0,BuffsUp.names},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false)
--	BuffsUp.damage	=BUI.UI.Label(	"BUI_BuffsUp_Damage",		list,		{90,600},		{LEFT,RIGHT,0,0,BuffsUp.time},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, "damage"	, false)
	BuffsUp.percent	=BUI.UI.Label(	"BUI_BuffsUp_Percent",		list,		{fs*4,600},		{LEFT,RIGHT,0,0,BuffsUp.time},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false)
end
--]]
function BUI.Stats.Minimeter_Init()		--MINI DAMAGE METER
	--ReticleDpS
	local fs	=15
	BUI.UI.Label("BUI_ReticleDpS",	ZO_ReticleContainerReticle,	{fs*2,fs},	{TOPRIGHT,TOPLEFT,0,1},	BUI.UI.Font("esobold",fs), {.8,.8,.67,1}, {2,0}, "", false)
	if not BUI.Vars.StatsMiniMeter then return end
	local width=171
	local damage,healing,GroupDps,speed,time
	if BUI.Vars.StatsMiniHealing then width=width+110 end
	if BUI.Vars.StatsMiniGroupDps then width=width+90 end
	if BUI.Vars.StatsMiniSpeed then width=width+65 end
	local ui	=BUI.UI.Control(	"BUI_MiniMeter",			BanditsUI,	{width,44},		BUI.Vars.BUI_MiniMeter,		not BUI.Vars.StatsMiniMeter)
	ui.backdrop	=BUI.UI.Backdrop("BUI_MiniMeter_Backdrop",	ui,{width,44},{TOPLEFT,TOPLEFT,0,0},{0,0,0,0.4},{0,0,0,1},nil,true) --ui.backdrop:SetEdgeTexture("",16,4,4)
	ui.label	=BUI.UI.Label("BUI_MiniMeter_Label",		ui.backdrop,{width,44},{TOPLEFT,TOPLEFT,0,0},BUI.UI.Font("standard",20,false),nil,{1,1},BUI.Loc("StatMiniHeader"))
	ui.base	=BUI.UI.Control("BUI_MiniMeter_Base",		ui,	{width,44},	{TOPLEFT,TOPLEFT,0,0},	false)
--	ui.bg		=BUI.UI.Backdrop("BUI_MiniMeter_BG",		ui.base,		"inherit",		{TOPLEFT,TOPLEFT,0,0},		{0,0,0,BUI.Vars.MiniMeterAplha}, {0,0,0,BUI.Vars.MiniMeterAplha+0.1}, nil, false)
	ui.bg		=BUI.UI.Backdrop("BUI_MiniMeter_BG",		ui.base,		"inherit",		{TOPLEFT,TOPLEFT,0,0},		{1,1,1,0}, {1,1,1,BUI.Vars.MiniMeterAplha}, "/esoui/art/chatwindow/chat_bg_center.dds", false)
	ui.bg:SetEdgeTexture("/esoui/art/chatwindow/chat_bg_edge.dds", 256, 128, 22)
	ui:SetMovable(true)
	ui:SetHandler("OnMoveStop", function(self) BUI.Menu:SaveAnchor(self) end)
	damage		=BUI.UI.Control(	"BUI_MiniMeter_Dam",		ui.base,	{116,32},		{LEFT,LEFT,5,0},			false)
	damage.label	=BUI.UI.Label(	"BUI_MiniMeter_DamLabel",	damage,	{98,32},		{LEFT,LEFT,28,0},			BUI.UI.Font(BUI.Vars.FrameFont1,16,true), {1,1,1,1}, {0,1}, "0", false)
	damage.icon		=BUI.UI.Texture(	"BUI_MiniMeter_DamIcon",	damage,	{30,30},		{LEFT,LEFT,0,0},			'/esoui/art/menubar/gamepad/gp_playermenu_icon_skills.dds', false)
	--esoui/art/icons/poi/poi_battlefield_complete.dds
	damage:SetMouseEnabled(true)
	damage:SetHandler("OnMouseDown", function(self,button)
		if button==1 then BUI.Stats.Toggle()
		elseif button==2 then BUI.Stats.Post()
		elseif button==3 then BUI.Stats.Reset()
		end
	end)
	damage:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, BOTTOMRIGHT, BUI.Loc("MiniMeterDPSToolTip")) end)
	damage:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
	ui.damage		=damage
	if BUI.Vars.StatsMiniHealing then
	healing		=BUI.UI.Control(	"BUI_MiniMeter_Heal",		ui.base,	{110,32},		{LEFT,RIGHT,0,0,damage},	false)
	healing.label	=BUI.UI.Label(	"BUI_MiniMeter_HealLabel",	healing,	{90,32},		{LEFT,LEFT,28,0},			BUI.UI.Font(BUI.Vars.FrameFont1,16,true), {1,1,1,1}, {0,1}, "0", false)
	healing.icon	=BUI.UI.Texture(	"BUI_MiniMeter_HealIcon",	healing,	{24,24},		{LEFT,LEFT,3,0},			'/esoui/art/buttons/gamepad/pointsplus_up.dds', false)
	healing:SetMouseEnabled(true)
	healing:SetHandler("OnMouseDown", function(self,button) BUI.Helper_Toggle() end)
	healing:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, BOTTOMRIGHT, BUI.Loc("MiniMeterHPSToolTip")) end)
	healing:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
	ui.healing		=healing
	elseif BUI_MiniMeter_Heal then BUI_MiniMeter_Heal:SetHidden(true) end
	if BUI.Vars.StatsMiniGroupDps then
	GroupDps		=BUI.UI.Control(	"BUI_MiniMeter_gDps",		ui.base,	{90,32},		{LEFT,RIGHT,0,0,healing or damage},	false)
	GroupDps.label	=BUI.UI.Label(	"BUI_MiniMeter_gDpsLabel",	GroupDps,	{62,32},		{LEFT,LEFT,28,0},			BUI.UI.Font(BUI.Vars.FrameFont1,16,true), {1,1,1,1}, {0,1}, "0", false)
	GroupDps.icon	=BUI.UI.Texture(	"BUI_MiniMeter_gDpsIcon",	GroupDps,	{30,30},		{LEFT,LEFT,0,0},			'/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_magicweaponsarmor.dds', false)
	--esoui/art/lfg/lfg_icon_dps.dds
	--esoui/art/icons/poi/poi_battlefield_complete.dds
	GroupDps:SetMouseEnabled(true)
	GroupDps:SetHandler("OnMouseDown", function(self,button)
		if button==1 then LastSection="Group" BUI.Stats.Toggle()
		elseif button==2 then
			CHAT_SYSTEM.textEntry:SetText("/p"..BUI.GroupDPS_text)
			CHAT_SYSTEM:Maximize() CHAT_SYSTEM.textEntry:Open() CHAT_SYSTEM.textEntry:FadeIn()
		end
	end)
	GroupDps:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, BOTTOMRIGHT, (BUI.GroupDPS_tip~="" and BUI.GroupDPS_tip.."\n"..BUI.Loc("MiniMeterGDPSToolTip2").."\n" or "")..BUI.Loc("MiniMeterGDPSToolTip1")) end)
	GroupDps:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
	ui.GroupDps		=GroupDps
	elseif BUI_MiniMeter_gDps then BUI_MiniMeter_gDps:SetHidden(true) end
	if BUI.Vars.StatsMiniSpeed then
	speed			=BUI.UI.Control(	"BUI_MiniMeter_Speed",		ui.base,	{65,32},		{LEFT,RIGHT,0,0,GroupDps or healing or damage},	false)
	speed.label		=BUI.UI.Label(	"BUI_MiniMeter_SpeedLabel",	speed,	{37,32},		{RIGHT,RIGHT,0,0},		BUI.UI.Font(BUI.Vars.FrameFont1,16,true), {1,1,1,1}, {0,1}, "0|cAAAAAA%|r", false)
	speed.icon		=BUI.UI.Texture(	"BUI_MiniMeter_SpeedIcon",	speed,	{28,28},		{LEFT,LEFT,3,1},			'/esoui/art/ava/overview_icon_underdog_score.dds', false)
	ui.speed		=speed
	elseif BUI_MiniMeter_Speed then BUI_MiniMeter_Speed:SetHidden(true) end
	time			=BUI.UI.Control(	"BUI_MiniMeter_Time",		ui.base,	{60,32},		{LEFT,RIGHT,0,0,speed or GroupDps or healing or damage},	false)
	time.label		=BUI.UI.Label(	"BUI_MiniMeter_TimeLabel",	time,		{48,32},		{RIGHT,RIGHT,0,0},		BUI.UI.Font(BUI.Vars.FrameFont1,16,true), {1,1,1,1}, {0,1}, "0:00", false)
	time.icon		=BUI.UI.Texture(	"BUI_MiniMeter_TimeIcon",	time,		{12,15},		{LEFT,LEFT,0,0},			'/esoui/art/journal/journal_quest_repeat.dds', false)
	ui.time		=time
end

function BUI.Stats.GroupDPS_Init()
	local fs=BUI.Vars.RaidFontSize
	local w,h=fs*.6*19,fs*1.335*10
	local ui	=BUI.UI.Control(	"BUI_GroupDPS",			BanditsUI,	{w,h},	BUI.Vars.BUI_GroupDPS,		true)
	ui.backdrop	=BUI.UI.Backdrop(	"BUI_GroupDPS_Backdrop",	ui,		{w,h},	{TOPLEFT,TOPLEFT,0,0},{0,0,0,0.4},{0,0,0,1},nil,true)
	ui.label	=BUI.UI.Label(	"BUI_GroupDPS_Label",		ui.backdrop,{w,h},	{TOPLEFT,TOPLEFT,0,0},BUI.UI.Font("standard",20,false),nil,{1,1},BUI.Loc("GroupDPS"))
	ui.base	=BUI.UI.Control(	"BUI_GroupDPS_Base",		ui,		{w,h},	{TOPLEFT,TOPLEFT,0,0},	false)
	ui:SetMovable(true)
--	ui:SetAlpha(0)
	ui:SetHandler("OnMoveStop", function(self) BUI.Menu:SaveAnchor(self) end)
	BUI.UI.Label("BUI_GroupDPS_Names", ui, {fs*.6*12,h}, {TOPLEFT,TOPLEFT,0,0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,0}, "")
	BUI.UI.Label("BUI_GroupDPS_Value", ui, {fs*.6*7,h}, {TOPRIGHT,TOPRIGHT,0,0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,0}, "")
end

local function ResetHeaderButtons()
	local buttons={"BUI_Report_Dbutton","BUI_Report_Hbutton","BUI_Report_Rbutton","BUI_Report_Ibutton","BUI_Report_Gbutton"}
	for _,button in pairs(buttons) do _G[button]:SetState(BSTATE_NORMAL) end
end

local function EquipmentInfo()
	if BUI_Report_Einfo and not BUI_Report_Einfo:IsHidden() then
		BUI_Report_Einfo:SetHidden(true)
		BUI_Report_Ebutton:SetTextureRotation(0)
		return
	end
	BUI_Report_Ebutton:SetTextureRotation(math.pi)
	if BUI_Report_Uptimes and not BUI_Report_Uptimes:IsHidden() then
		BUI_Report_Uptimes:SetHidden(true)
		BUI_Report_Ubutton:SetTextureRotation(0)
	end
	local i,fs=0,BUI.Vars.StatsFontSize
	local sfs=(BUI.language=="en" or BUI.Vars.ActionsPrecise)and fs or fs-4
	local w=720+20+((BUI.language=="en" or BUI.Vars.ActionsPrecise)and 50 or 0)
	local w1=20+275+70+160
	local w2=(w-w1-22)/7
	local w3=BUFF_W-40
	local h1=fs*1.5*16	--(math.max(i+1,14))
	local weapon={}
	local armorTypes={[ARMORTYPE_LIGHT]=" (|c5555EEL|r)",[ARMORTYPE_MEDIUM]=" (|c22DD22M|r)",[ARMORTYPE_HEAVY]=" (|cDD2222H|r)"}
	local ui=BUI_Report_Einfo or WINDOW_MANAGER:CreateControl("BUI_Report_Einfo", BUI_Report, CT_BACKDROP)
	ui:SetCenterColor(0,0,0,BUI.Vars.StatsTransparent and 0.7 or 1)
	ui:SetEdgeColor(.7,.7,.5,.3)
	ui:SetEdgeTexture("",8,2,2)
	ui:SetHidden(false)
	ui:ClearAnchors()
	ui:SetAnchor(TOPLEFT,BUI_Report,BOTTOMLEFT,0,-2)
	ui:SetAnchor(BOTTOMRIGHT,BUI_Report,BOTTOMRIGHT,0,h1+2)
	BUI.UI.Line("BUI_Report_Einfo_L1", ui, {0,h1}, {TOPLEFT,TOPLEFT,w1-1,2}, {.7,.7,.5,.3}, 2)
	BUI.UI.Line("BUI_Report_Einfo_L2", ui, {0,h1}, {TOPLEFT,TOPLEFT,w-1,2}, {.7,.7,.5,.3}, 2)
	BUI.UI.Texture("BUI_Report_Logo", ui, {128,128}, {CENTER,RIGHT,-BUFF_W/2,0}, "/BanditsUserInterface/textures/Bandits_logo.dds") BUI_Report_Logo:SetAlpha(.5)

	--Items header
	local header	=BUI.UI.Control(	"BUI_Report_Items_Header",	ui,		{w1-20,fs*1.3},	{TOPLEFT,TOPLEFT,10,2})
	header.bg		=BUI.UI.Backdrop(	"BUI_Report_Items_BG",		header,	{w1-20,fs*1.3},	{TOPLEFT,TOPLEFT,0,0},			{.4,.4,.4,.3}, {0,0,0,0})
	header.name		=BUI.UI.Label(	"BUI_Report_Items_Name",	header,	{255,fs*1.5},	{LEFT,LEFT,30,0},				BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, "Item")
	header.trait	=BUI.UI.Label(	"BUI_Report_Items_Trait",	header,	{70,fs*1.5},	{LEFT,RIGHT,0,0,header.name},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, "Trait")
	header.ench		=BUI.UI.Label(	"BUI_Report_Items_Enchant",	header,	{160,fs*1.5},	{LEFT,RIGHT,0,0,header.trait},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, "Enchant")
	--Items
	for _,slot in pairs(SLOTS) do
		local itemLink	=GetItemLink(BAG_WORN,slot)
		if itemLink~="" then
			i=i+1
			local icon		=GetItemLinkInfo(itemLink)
			if slot==EQUIP_SLOT_MAIN_HAND then weapon[1]=icon elseif slot==EQUIP_SLOT_BACKUP_MAIN then weapon[2]=icon end
--			local itemType	=GetItemLinkItemType(itemLink)
			local _,_,enchant	=GetItemLinkEnchantInfo(itemLink)
			local traitType	=GetItemLinkTraitInfo(itemLink)
			local armorType	=GetItemLinkArmorType(itemLink)
			local traitName	=traitType==ITEM_TRAIT_TYPE_NONE and "" or GetString("SI_ITEMTRAITTYPE", traitType)
			enchant=string.gsub(enchant,"Maximum","Max")
			enchant=string.gsub(enchant,"Максимум","Макс")
			enchant=string.gsub(enchant,"Increase your","Inc.")
			enchant=string.gsub(enchant,"Damage","Dmg")
			enchant=string.gsub(enchant,"([0-9]+)|r(%s[^%s]+%sHealth)","|cFF2222%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%s[^%s]+%sStamina)","|c22FF22%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%s[^%s]+%sMagicka)","|c5555EE%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%sHealth)","|cFF2222%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%sStamina)","|c22FF22%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%sMagicka)","|c5555EE%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%sMagick)","|c5555EE%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%sSpell)","|c5555EE%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%sFlame)","|cEE3333%1%2|r")
--			enchant=string.gsub(enchant,"([0-9]+)|r(%sWeapon)","|cEEEEEE%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%s[^%s]+%sCritical)","|cBB33BB%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%sDisease)","|cBB33BB%1%2|r")
			enchant=string.gsub(enchant,"([0-9]+)|r(%sPoison)","|c33BB33%1%2|r")
			--Item
			local label=_G["BUI_Report_ItemName"..i] or WINDOW_MANAGER:CreateControl("BUI_Report_ItemName"..i, ui, CT_LABEL)
			label:SetDimensions(270, fs*1.5)
			label:ClearAnchors()
			label:SetAnchor(TOPLEFT,ui,TOPLEFT,20,fs*1.5*i)
			label:SetFont(BUI.UI.Font("standard",fs,true))
			label:SetColor(.65,.6,.5,1)
			label:SetHorizontalAlignment(0)
			label:SetVerticalAlignment(1)
			label:SetText(zo_iconFormat(icon,fs*1.5-2,fs*1.5-2).." "..itemLink..(armorTypes[armorType] and armorTypes[armorType] or ""))
			--Trait
			local label=_G["BUI_Report_ItemTrait"..i] or WINDOW_MANAGER:CreateControl("BUI_Report_ItemTrait"..i, ui, CT_LABEL)
			label:SetDimensions(65, fs*1.5)
			label:ClearAnchors()
			label:SetAnchor(TOPLEFT,ui,TOPLEFT,20+275,fs*1.5*i)
			label:SetFont(BUI.UI.Font("standard",fs-4,true))
			label:SetColor(.8,.8,.8,1)
			label:SetHorizontalAlignment(0)
			label:SetVerticalAlignment(1)
			label:SetText(traitName)
			--Enchant
			local label=_G["BUI_Report_ItemEnchant"..i] or WINDOW_MANAGER:CreateControl("BUI_Report_ItemEnchant"..i, ui, CT_LABEL)
			label:SetDimensions(155, fs*1.5)
			label:ClearAnchors()
			label:SetAnchor(TOPLEFT,ui,TOPLEFT,20+275+70,fs*1.5*i)
			label:SetFont(BUI.UI.Font("standard",fs-4,true))
			label:SetColor(.8,.8,.8,1)
			label:SetHorizontalAlignment(0)
			label:SetVerticalAlignment(1)
			label:SetText(enchant)
		end
	end

	--Panels
	ui.panels=BUI.UI.Control("BUI_Report_Einfo_Panels", ui, {w-w1,w2*2}, {TOPLEFT,TOPLEFT,w1,2})
	for pair=1,2 do
		for slot=3,8 do
			local id=BUI.Actions.AbilitySlots[pair][slot]
			if BUI.Actions.AbilityBar[id] then
				BUI.UI.Texture("BUI_Report_Einfo_Ab"..pair..slot, ui.panels, {w2-2,w2-2}, {TOPLEFT,TOPLEFT,10+w2*(slot-2)+(slot==8 and 10 or 0),w2*(pair-1)}, BUI.Actions.AbilityBar[id].Texture)
			end
		end
	end
	for pair in pairs(weapon) do
		BUI.UI.Texture("BUI_Report_Einfo_Weapon"..pair, ui.panels, {w2-2,w2-2}, {TOPLEFT,TOPLEFT,0,w2*(pair-1)}, weapon[pair])
	end
	BUI.UI.Line("BUI_Report_Einfo_L3", ui.panels, {w-w1-2,0}, {TOPLEFT,BOTTOMLEFT,0,0}, {.7,.7,.5,.3}, 2)

	--Stats
	for i,data in pairs(BUI.PassiveBuffs) do
		if data.id==35792 then	--Vampire
			BUI.UI.Texture("BUI_Report_Einfo_Buff1", ui, {w2-2,w2-2}, {TOPRIGHT,BOTTOMRIGHT,-2,2,ui.panels}, data.Texture)
		end
		local _,id=BUI.GetFoodBuff()
		if id then	--Food
			BUI.UI.Texture("BUI_Report_Einfo_Buff2", ui, {w2-2,w2-2}, {TOPRIGHT,BOTTOMRIGHT,-2-w2,2,ui.panels}, GetAbilityIcon(id))
		end
	end
	local name=BUI.UI.Label("BUI_Report_Einfo_Char", ui, {w-w1-10,fs*1.4}, {TOPLEFT,TOPLEFT,w1+5,10+w2*2}, BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,0}, BUI.GetIcon("esoui/art/icons/heraldrycrests_race_"..RaceIcon[GetUnitRaceId("player")]..".dds",fs*1.4)..BUI.GetIcon(GetClassIcon(GetUnitClassId("player")),fs*1.4)..BUI.Player.name.." ("..BUI.Player:GetColoredLevel("player")..")")
	local mainpower=BUI.Player["stamina"].max>BUI.Player["magicka"].max and "stamina" or "magicka"
--	local s_crit,m_crit=BUI.GetCritDamage()
--	local b_cost,b_mitigation=BUI.GetBlockCost()
	local text="|cbb3333"..zo_strformat("<<!aC:1>>",EsoStrings[SI_ATTRIBUTES1]).."|r "..BUI.DisplayNumber(BUI.Player["health"].max).." |cbb3333Recovery|r "..BUI.DisplayNumber(GetPlayerStat(STAT_HEALTH_REGEN_COMBAT)).."\n"
		.."|c33bb33"..zo_strformat("<<!aC:1>>",EsoStrings[SI_ATTRIBUTES3]).."|r "..BUI.DisplayNumber(BUI.Player["stamina"].max).." |c33bb33Recovery|r "..BUI.DisplayNumber(GetPlayerStat(STAT_STAMINA_REGEN_COMBAT)).."\n"
		.."|c5555ff"..zo_strformat("<<!aC:1>>",EsoStrings[SI_ATTRIBUTES2]).."|r "..BUI.DisplayNumber(BUI.Player["magicka"].max).." |c5555ffRecovery|r "..BUI.DisplayNumber(GetPlayerStat(STAT_MAGICKA_REGEN_COMBAT))
	local stat1=BUI.UI.Label("BUI_Report_Einfo_Stats1", ui, {w-w1-10,sfs*1.4*3}, {TOPLEFT,BOTTOMLEFT,0,10,name}, BUI.UI.Font("standard",sfs,true), {.8,.8,.8,1}, {0,0}, text)
	local penetr=mainpower=="stamina" and GetPlayerStat(STAT_PHYSICAL_PENETRATION) or GetPlayerStat(STAT_SPELL_PENETRATION)
	local text=(mainpower=="stamina" and "|c33bb33"..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS33]) or "|c5555ff"..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS34])).."|r "..BUI.DisplayNumber(penetr).." |c808080("..math.floor(penetr/66.2)/10 .."%)|r\n"
		..(mainpower=="stamina" and "|c33bb33"..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS35]).."|r "..BUI.DisplayNumber(GetPlayerStat(STAT_POWER)) or "|c5555ff"..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS25]).."|r "..BUI.DisplayNumber(GetPlayerStat(STAT_SPELL_POWER))).."\n"
		..(mainpower=="stamina" and "|c33bb33"..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS16]).."|r "..math.floor(GetPlayerStat(STAT_CRITICAL_STRIKE)/219*10)/10 or "|c5555ff"..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS23]).."|r "..math.floor(GetPlayerStat(STAT_SPELL_CRITICAL)/219*10)/10).."%\n"
--		..(mainpower=="stamina" and "|c33bb33"..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS16]).."|r bonus "..s_crit or "|c5555ff"..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS23]).."|r bonus "..m_crit).."%"
	local stat2=BUI.UI.Label("BUI_Report_Einfo_Stats2", ui, {w-w1-10,sfs*1.4*4}, {TOPLEFT,BOTTOMLEFT,0,10,stat1}, BUI.UI.Font("standard",sfs,true), {.8,.8,.8,1}, {0,0}, text)
	local p_resist,s_resist=GetPlayerStat(STAT_PHYSICAL_RESIST),GetPlayerStat(STAT_SPELL_RESIST)
	local text=zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS38]).." "..BUI.DisplayNumber(p_resist).." |c808080("..math.floor(p_resist/66.2)/10 .."%)|r\n"
		..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS44]).." "..BUI.DisplayNumber(s_resist).." |c808080("..math.floor(s_resist/66.2)/10 .."%)|r\n"
--		..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS1142]).." "..BUI.DisplayNumber(b_cost).."\n"
--		..zo_strformat("<<!aC:1>>",EsoStrings[SI_DERIVEDSTATS1143]).." "..b_mitigation.."%"
	local stat3=BUI.UI.Label("BUI_Report_Einfo_Stats3", ui, {w-w1-10,sfs*1.4*4}, {TOPLEFT,BOTTOMLEFT,0,10,stat2}, BUI.UI.Font("standard",sfs,true), {.8,.8,.8,1}, {0,0}, text)

	--Champion system v2
	ui.champ=BUI.UI.Control("BUI_Report_Einfo_Champion", ui, {w3,fs*3.5*9}, {TOPLEFT,TOPLEFT,w+(BUFF_W-w3)/2,0},not(BUI.Vars.StatsBuffs and BuffsSection))
--	BUI.UI.Line("BUI_Report_Einfo_L2", ui.champ, {w-w1-2,0}, {TOPLEFT,TOPLEFT,0,0}, {.7,.7,.5,.3}, 2)
--	for di=1, GetNumChampionDisciplines() do
		--Discipline
		local di=2	--Warfare
		local d_id=GetChampionDisciplineId(di)
		local d_name=zo_strformat("<<!aC:1>>",GetChampionDisciplineName(d_id))
		local d_label=_G["BUI_Report_Discipline"..di] or WINDOW_MANAGER:CreateControl("BUI_Report_Discipline"..di, ui.champ, CT_LABEL)
		d_label:SetDimensions(w3/3, fs)
		d_label:ClearAnchors()
		d_label:SetAnchor(TOPLEFT,ui.champ,TOPLEFT,0,(fs+(fs-3)*2)*(di-1))
		d_label:SetFont(BUI.UI.Font("standard",fs-1,true))
		d_label:SetColor(unpack(ChampionDisciplineColor[GetChampionDisciplineType(d_id)]))
		d_label:SetHorizontalAlignment(1)
		d_label:SetVerticalAlignment(1)
		d_label:SetText((BUI.Vars.DeveloperMode and di..". " or "")..d_name)
		for si=1,GetNumChampionDisciplineSkills(di) do
			local s_id=GetChampionSkillId(di,si)
			--Skill
			local s_name=zo_strformat("<<!aC:1>>",GetChampionSkillName(s_id))
			local s_label=_G["BUI_Report_Skill"..di..si] or WINDOW_MANAGER:CreateControl("BUI_Report_Skill"..di..si, ui.champ, CT_LABEL)
			s_label:SetDimensions(w3/2-20, fs-4)
			s_label:ClearAnchors()
			s_label:SetAnchor(TOPLEFT,d_label,BOTTOMLEFT,math.abs(si%2-1)*w3/2,math.floor((si-1)/2)*(fs-2))
			s_label:SetFont(BUI.UI.Font("standard",fs-4,true))
			s_label:SetColor(.8,.8,.8,1)
			s_label:SetHorizontalAlignment(0)
			s_label:SetVerticalAlignment(1)
			s_label:SetText((BUI.Vars.DeveloperMode and si..". " or "")..s_name)
			--Value
			local s_value=GetNumPointsSpentOnChampionSkill(s_id)
			local label=_G["BUI_Report_SkillValue"..di..si] or WINDOW_MANAGER:CreateControl("BUI_Report_SkillValue"..di..si, ui.champ, CT_LABEL)
			label:SetDimensions(20, fs-4)
			label:ClearAnchors()
			label:SetAnchor(TOPLEFT,s_label,TOPRIGHT,0,0)
			label:SetFont(BUI.UI.Font("standard",fs-4,true))
			label:SetColor(1,.9,.8,1)
			label:SetHorizontalAlignment(0)
			label:SetVerticalAlignment(1)
			label:SetText(s_value>0 and s_value or "-")
--		end
	end
--[[	Champion system v1
	for i=0,8 do
		local line=i<8 and i+2 or i-7
		--Discipline
		local d_name=zo_strformat("<<!aC:1>>",GetChampionDisciplineName(line))
		local d_label=_G["BUI_Report_Discipline"..line] or WINDOW_MANAGER:CreateControl("BUI_Report_Discipline"..line, ui.champ, CT_LABEL)
		d_label:SetDimensions(w3/3, fs)
		d_label:ClearAnchors()
		d_label:SetAnchor(TOPLEFT,ui.champ,TOPLEFT,0,(fs+(fs-3)*2)*i)
		d_label:SetFont(BUI.UI.Font("standard",fs-1,true))
		d_label:SetColor(unpack(AttributeColor[GetChampionDisciplineAttribute(line)]))
		d_label:SetHorizontalAlignment(1)
		d_label:SetVerticalAlignment(1)
		d_label:SetText((BUI.Vars.DeveloperMode and line..". " or "")..d_name)
		for skill=1,4 do
			--Skill
			local s_name=zo_strformat("<<!aC:1>>",GetChampionSkillName(line,skill))
			local s_label=_G["BUI_Report_Skill"..line..skill] or WINDOW_MANAGER:CreateControl("BUI_Report_Skill"..line..skill, ui.champ, CT_LABEL)
			s_label:SetDimensions(w3/2-20, fs-4)
			s_label:ClearAnchors()
			s_label:SetAnchor(TOPLEFT,d_label,BOTTOMLEFT,math.abs(skill%2-1)*w3/2,math.floor((skill-1)/2)*(fs-3))
			s_label:SetFont(BUI.UI.Font("standard",fs-4,true))
			s_label:SetColor(.8,.8,.8,1)
			s_label:SetHorizontalAlignment(0)
			s_label:SetVerticalAlignment(1)
			s_label:SetText((BUI.Vars.DeveloperMode and skill..". " or "")..s_name)
			--Value
			local s_value=GetNumPointsSpentOnChampionSkill(line,skill)
			local label=_G["BUI_Report_SkillValue"..line..skill] or WINDOW_MANAGER:CreateControl("BUI_Report_SkillValue"..line..skill, ui.champ, CT_LABEL)
			label:SetDimensions(20, fs-4)
			label:ClearAnchors()
			label:SetAnchor(TOPLEFT,s_label,TOPRIGHT,0,0)
			label:SetFont(BUI.UI.Font("standard",fs-4,true))
			label:SetColor(1,.9,.8,1)
			label:SetHorizontalAlignment(0)
			label:SetVerticalAlignment(1)
			label:SetText(s_value>0 and s_value or "-")
		end
	end
--]]
end

function BUI.Stats.Analistics_Init()	--ANALYTICS WINDOW
	local fs,s=BUI.Vars.StatsFontSize,1	--BUI.Vars.ReportScale
	local buf=BUI.Vars.StatsBuffs and BUFF_W or 0
	local w=720+((BUI.language=="en" or BUI.Vars.ActionsPrecise)and 50 or 0)
	local head=(fs-4)*1.358*2
	local ui		=BUI.UI.TopLevelWindow("BUI_Report",				GuiRoot,	{w+20+buf,200},{TOP,TOP,0,28}, true) ui:SetDrawTier(2)
	ui.bg=BUI_Report_Backdrop or WINDOW_MANAGER:CreateControl("BUI_Report_Backdrop", ui, CT_BACKDROP)
	ui.bg:SetCenterColor(0,0,0,BUI.Vars.StatsTransparent and 0.7 or 1)
	ui.bg:SetEdgeColor(0,0,0,0.9)
	ui.bg:SetEdgeTexture("",8,2,2)
	ui.bg:SetHidden(false)
	ui.bg:ClearAnchors()
	ui.bg:SetAnchor(TOPLEFT,ui,TOPLEFT)
	ui.bg:SetAnchor(BOTTOMRIGHT,ui,BOTTOMRIGHT)

	ui.cont=BUI_Report_Border or WINDOW_MANAGER:CreateControl("BUI_Report_Border", ui, CT_BACKDROP)
	ui.cont:SetCenterColor(0,0,0,0)
	ui.cont:SetEdgeColor(.7,.7,.5,.3)
	ui.cont:SetEdgeTexture("",8,2,2)
	ui.cont:SetHidden(false)
	ui.cont:ClearAnchors()
	ui.cont:SetAnchor(TOPLEFT,ui,TOPLEFT,0,30)
	ui.cont:SetAnchor(BOTTOMRIGHT,ui,BOTTOMLEFT,w+20,-22)

	ui.top		=BUI.UI.Statusbar("BUI_Report_Header",				ui,		{w+20+buf,30},	{TOPLEFT,TOPLEFT,0,0},			{.5,.5,.5,.7}, nil, false)
	ui.top:SetGradientColors(0.4,0.4,0.4,0.7,0,0,0,0) ui.top:SetDrawLayer(0)
	ui.title		=BUI.UI.Label(	"BUI_Report_Title",				ui.top,	{w,head},		{TOPLEFT,BOTTOMLEFT,10*s,0},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("DReport"), false)
	--Character summary
	BUI.UI.Label(	"BUI_Report_Summary",	ui,	{220,head*1.2},	{TOPLEFT,TOPLEFT,(w+20-10-220)*s,30},	BUI.UI.Font("standard",fs-4,true), {1,1,1,1}, {0,0}, "", false)
	--Buttons right
	ui.close		=BUI.UI.Button(	"BUI_Report_Close",				ui,		{34,34},		{TOPRIGHT,TOPRIGHT,5*s,5*s},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.close:SetNormalTexture('/esoui/art/buttons/closebutton_up.dds')
	ui.close:SetMouseOverTexture('/esoui/art/buttons/closebutton_mouseover.dds')
	ui.close:SetHandler("OnClicked", function() PlaySound("Click") BUI.Stats.Toggle() end)
	BUI.UI.SimpleButton("BUI_Report_Help", ui, {26,26}, {TOP,TOPRIGHT,-45,3*s}, "/esoui/art/miscellaneous/help_icon.dds", false, nil, BUI.Loc("ReportDesc"))
	BUI.UI.SimpleButton("BUI_Report_Transparent", ui, {26,26}, {TOP,TOPRIGHT,-75,3*s}, "/esoui/art/inventory/inventory_icon_visible.dds", false,
		function()
			BUI.Vars.StatsTransparent=not BUI.Vars.StatsTransparent
			BUI_Report_Backdrop:SetCenterColor(0,0,0,BUI.Vars.StatsTransparent and 0.7 or 1)
			if BUI_Report_Einfo then BUI_Report_Einfo:SetCenterColor(0,0,0,BUI.Vars.StatsTransparent and 0.7 or 1) end
		end)
	--Buttons left
	ui.box		=BUI.UI.Button(	"BUI_Report_Box",					ui.top,	{30,30},		{TOPLEFT,TOPLEFT,5*s,3*s},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	ui.box:SetNormalTexture('/esoui/art/tradinghouse/tradinghouse_listings_tabicon_up.dds')
	ui.box:SetMouseOverTexture('/esoui/art/tradinghouse/tradinghouse_listings_tabicon_over.dds')
	BUI.UI.SimpleButton("BUI_Report_Save", ui.top, {24,24}, {LEFT,LEFT,40*s,3*s}, 2, false, BUI.Stats.SaveReport)
	BUI.UI.SimpleButton("BUI_Report_Del", ui.top, {24,24}, {LEFT,LEFT,40+25*1*s,3*s}, 4, false, function()BUI.Stats.ClearReport(ReportToShow)end)
	BUI.UI.SimpleButton("BUI_Report_Prev", ui.top, {24,24}, {LEFT,LEFT,40+25*2*s,3*s}, 0, false, function()BUI.Stats.NextReport(true)end)
	BUI.UI.SimpleButton("BUI_Report_Next", ui.top, {24,24}, {LEFT,LEFT,40+25*3*s,3*s}, 1, false, function()BUI.Stats.NextReport(false)end)
	BUI.UI.Label("BUI_Report_Count",ui.top,{60,fs},{LEFT,LEFT,40+25*4*s,0},BUI.UI.Font("standard",fs-2,true), {1,1,1,1}, {0,1}, "", false)
	--Tabs
	ui.tabs		=BUI.UI.Control("BUI_Report_Tabs", ui.top, {350,30}, {TOP,TOP,0,0})
--	local tabs		=BUI.UI.Texture("BUI_Report_TabsBg", ui.tabs, {512,32}, {CENTER,CENTER,0,0}, "/BanditsUserInterface/textures/tabs1.dds") tabs:SetColor(.7,.7,.5,.3)
	ui.dbutton		=BUI.UI.Button(	"BUI_Report_Dbutton",				ui.tabs,	{70,24},		{LEFT,LEFT,70*0*s,0},		BSTATE_DISABLED, BUI.UI.Font("esobold",fs-2,true), {1,1}, {.7,.7,.5,1}, nil, {1,1,1,1}, false)
	ui.dbutton:SetText("Damage") ui.dbutton:SetHandler("OnClicked", function(self) PlaySound("Click") BUI.Stats.SetupReport("Damage",self) end)
	ui.dbutton.tab	=BUI.UI.Texture(nil, ui.dbutton, {128,32}, {CENTER,CENTER,0,0}, "/BanditsUserInterface/textures/tab.dds") ui.dbutton.tab:SetColor(.21,.21,.15,1)
	ui.hbutton		=BUI.UI.Button(	"BUI_Report_Hbutton",				ui.tabs,	{70,24},		{LEFT,LEFT,70*1*s,0},		BSTATE_NORMAL, BUI.UI.Font("esobold",fs-2,true), {1,1}, {.7,.7,.5,1}, nil, {1,1,1,1}, false)
	ui.hbutton:SetText("Healing") ui.hbutton:SetHandler("OnClicked", function(self) PlaySound("Click") BUI.Stats.SetupReport("Healing",self) end)
	ui.hbutton.tab	=BUI.UI.Texture(nil, ui.hbutton, {128,32}, {CENTER,CENTER,0,0}, "/BanditsUserInterface/textures/tab.dds") ui.hbutton.tab:SetColor(.21,.21,.15,1)
	ui.rbutton		=BUI.UI.Button(	"BUI_Report_Rbutton",				ui.tabs,	{70,24},		{LEFT,LEFT,70*2*s,0},		BSTATE_NORMAL, BUI.UI.Font("esobold",fs-2,true), {1,1}, {.7,.7,.5,1}, nil, {1,1,1,1}, false)
	ui.rbutton:SetText("Resource") ui.rbutton:SetHandler("OnClicked", function(self) PlaySound("Click") BUI.Stats.SetupReport("Power",self) end)
	ui.rbutton.tab	=BUI.UI.Texture(nil, ui.rbutton, {128,32}, {CENTER,CENTER,0,0}, "/BanditsUserInterface/textures/tab.dds") ui.rbutton.tab:SetColor(.21,.21,.15,1)
	ui.ibutton		=BUI.UI.Button(	"BUI_Report_Ibutton",				ui.tabs,	{70,24},		{LEFT,LEFT,70*3*s,0},		BSTATE_NORMAL, BUI.UI.Font("esobold",fs-2,true), {1,1}, {.7,.7,.5,1}, nil, {1,1,1,1}, false)
	ui.ibutton:SetText("Incoming") ui.ibutton:SetHandler("OnClicked", function(self) PlaySound("Click") BUI.Stats.SetupReport("Incoming",self) end)
	ui.ibutton.tab	=BUI.UI.Texture(nil, ui.ibutton, {128,32}, {CENTER,CENTER,0,0}, "/BanditsUserInterface/textures/tab.dds") ui.ibutton.tab:SetColor(.21,.21,.15,1)
	ui.gbutton		=BUI.UI.Button(	"BUI_Report_Gbutton",				ui.tabs,	{70,24},		{LEFT,LEFT,70*4*s,0},		BSTATE_NORMAL, BUI.UI.Font("esobold",fs-2,true), {1,1}, {.7,.7,.5,1}, nil, {1,1,1,1}, false)
	ui.gbutton:SetText("Group") ui.gbutton:SetHandler("OnClicked", function(self) PlaySound("Click") BUI.Stats.SetupGroupReport() end)
	ui.gbutton.tab	=BUI.UI.Texture(nil, ui.gbutton, {128,32}, {CENTER,CENTER,0,0}, "/BanditsUserInterface/textures/tab.dds") ui.gbutton.tab:SetColor(.21,.21,.15,1)
	--Abilitys Detail
	local abilities	=BUI.UI.Control(	"BUI_Report_Ability",				ui,		{w,fs*1.5},		{LEFT,LEFT,10*s,0},			true)
	local header	=BUI.UI.Control(	"BUI_Report_Ability_Header",			abilities,	{w-20,fs*1.3},	{TOPLEFT,TOPLEFT,10*s,0},		false)
	header.bg		=BUI.UI.Backdrop(	"BUI_Report_Ability_BG",			header,	{w-20,fs*1.3},	{TOPLEFT,TOPLEFT,0,0},			{.4,.4,.4,.3}, {0,0,0,0}, nil, false)
	header.name		=BUI.UI.Label(	"BUI_Report_Ability_Name",			header,	{220,fs*1.5},	{LEFT,LEFT,30*s,0},			BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("Ability"), false)
--	header.uses		=BUI.UI.Label(	"BUI_Report_Ability_Uses",			header,	{30,fs*1.5},	{LEFT,RIGHT,0,0,header.name},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, "#", false)
	header.total	=BUI.UI.Label(	"BUI_Report_Ability_Total",			header,	{130,fs*1.5},	{LEFT,RIGHT,0,0,header.name},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("Damage"), false)
	header.dps		=BUI.UI.Label(	"BUI_Report_Ability_DPS",			header,	{70,fs*1.5},	{LEFT,RIGHT,0,0,header.total},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("DPS"), false)
	header.count	=BUI.UI.Label(	"BUI_Report_Ability_Count",			header,	{70,fs*1.5},	{LEFT,RIGHT,0,0,header.dps},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("Hit"), false)
	header.crit		=BUI.UI.Label(	"BUI_Report_Ability_Crit",			header,	{50,fs*1.5},	{LEFT,RIGHT,0,0,header.count},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("Crit"), false)
	header.avg		=BUI.UI.Label(	"BUI_Report_Ability_Avg",			header,	{70,fs*1.5},	{LEFT,RIGHT,0,0,header.crit},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("Average"), false)
	header.max		=BUI.UI.Label(	"BUI_Report_Ability_Max",			header,	{70,fs*1.5},	{LEFT,RIGHT,0,0,header.avg},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("Max"), false)
	if (BUI.language=="en" or BUI.Vars.ActionsPrecise)then
	header.perc		=BUI.UI.Label(	"BUI_Report_Ability_Perc",			header,	{50,fs*1.5},	{LEFT,RIGHT,0,0,header.max},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, "Up", false)
	end
--	header.min		=BUI.UI.Label(	"BUI_Report_Ability_Min",			header,	{70,fs*1.5},	{LEFT,RIGHT,0,0,header.perc},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, "Min", true)
	abilities.header	=header
	abilities.content	=BUI.UI.Control(	"BUI_Report_Content",				abilities,	{w-10,fs*1.5},	{TOPLEFT,TOPLEFT,10*s,fs*1.5},	false)
	local scroll	=BUI.UI.Scroll(abilities.content)
	abilities.list	=BUI.UI.Control(	"BUI_Report_List",				scroll,	{w-10,fs*1.5},	{TOP,TOP,0,0},				false)
	ui.abilities	=abilities
	--Bottom
	ui.foot=BUI_Report_Foot or WINDOW_MANAGER:CreateControl("BUI_Report_Foot", ui, CT_BACKDROP)
	ui.foot:SetCenterColor(.15,.15,.15,1)
	ui.foot:SetEdgeColor(.15,.15,.15,1)
	ui.foot:SetEdgeTexture("",8,2,2)
	ui.foot:SetHidden(false)
	ui.foot:ClearAnchors()
	ui.foot:SetAnchor(TOPLEFT,ui,BOTTOMLEFT,0,-24)
	ui.foot:SetAnchor(BOTTOMRIGHT,ui,BOTTOMRIGHT,0,0)
		--EquipmentInfo
	ui.ebutton		=BUI.UI.Texture("BUI_Report_Ebutton", ui.foot, {fs,fs}, {LEFT,LEFT,10*s,0}, "/esoui/art/icons/mapkey/mapkey_groupmember.dds")
	ui.ebutton:SetColor(156/256,147/256,117/256,1)
	ui.ebutton:SetMouseEnabled(true)
	ui.ebutton:SetHandler("OnMouseDown", function(self) PlaySound("Click")EquipmentInfo()end)
	ui.ebutton:SetHandler("OnMouseEnter", function(self)self:SetColor(.9,.9,.8,1)end)
	ui.ebutton:SetHandler("OnMouseExit", function(self)self:SetColor(156/256,147/256,117/256,1)end)
	ui.ebutton:SetDrawTier(DT_HIGH)
    ui.ebutton:SetDrawLayer(DL_CONTROLS)
	BUI.UI.Label(	"BUI_Report_eDescription",	ui.foot,	{180,fs*1.5},		{LEFT,LEFT,(20+fs)*s,0},	BUI.UI.Font("standard",fs,true), {.8,.8,.6,1}, {0,1}, BUI.Loc("ReportEinfo"), false)
		--Uptimes
	ui.ubase		=BUI.UI.Control("BUI_Report_Ubutton_Base", ui.foot, {200,24}, {TOPLEFT,TOPLEFT,200*s,0}, true)
	ui.ubutton		=BUI.UI.Texture("BUI_Report_Ubutton", ui.ubase, {fs,fs}, {LEFT,LEFT,0,0}, "/esoui/art/icons/mapkey/mapkey_groupmember.dds")
	ui.ubutton:SetColor(156/256,147/256,117/256,1)
	ui.ubutton:SetMouseEnabled(true)
	ui.ubutton:SetHandler("OnMouseDown", function(self) PlaySound("Click")BUI.Stats.SetupUptimes()end)
	ui.ubutton:SetHandler("OnMouseEnter", function(self)self:SetColor(.9,.9,.8,1)end)
	ui.ubutton:SetHandler("OnMouseExit", function(self)self:SetColor(156/256,147/256,117/256,1)end)
	ui.ubutton:SetDrawTier(DT_HIGH)
    ui.ubutton:SetDrawLayer(DL_CONTROLS)
	BUI.UI.Label(	"BUI_Report_uDescription",	ui.ubase,	{180,fs*1.5},		{LEFT,LEFT,(10+fs)*s,0},	BUI.UI.Font("standard",fs,true), {.8,.8,.6,1}, {0,1}, "Uptimes", false)

	BUI.UI.Label(	"BUI_Report_Version",		ui.foot,	{345,fs*1.5},	{RIGHT,RIGHT,-10*s,0},		BUI.UI.Font("standard",fs,true), {.8,.8,.6,1}, {2,1}, ""	, false)
	--Buffs
	if BUI.Vars.StatsBuffs then
		--Elements
		BUI.UI.Label(	"BUI_Report_Elements",	ui,	{300,(fs-4)*1.6*3},	{TOPRIGHT,TOPRIGHT,-40*s,7*s},	BUI.UI.Font("standard",fs-4,true), {1,1,1,1}, {0,0}, "", false)
		--Buffs
		local control	=BUI.UI.Control(	"BUI_Report_BuffsUp_Control",		ui,		{345,fs*1.5},	{TOPRIGHT,TOPRIGHT,-10*s,(30+head)*s},	false)
		control.bg		=BUI.UI.Backdrop(	"BUI_Report_BuffsUp_BG",		control,	{345,fs*1.5},	{TOP,TOP,0,0},				{.3,.3,.3,.7}, {0,0,0,1}, BUI.Textures["grainy"], false)
		control.name	=BUI.UI.Label(	"BUI_Report_BuffsUp_Name",		control,	{190,fs*1.5},	{LEFT,LEFT,10*s,0,control},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("ReportPBHeader"), false)
		--Buffs Headers
		local BuffsUp	=BUI.UI.Control(	"BUI_Report_BuffsUp",			control,	{345,fs*1.5*2},	{TOPLEFT,BOTTOMLEFT,0,0},		true)
		BuffsUp.namesH	=BUI.UI.Label(	"BUI_Report_BuffsUp_NamesHeader",	BuffsUp,	{240,fs*1.5},	{TOPLEFT,TOPLEFT,0,0},			BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, BUI.Loc("ReportBuffHeader")	, false)
		BuffsUp.timeH	=BUI.UI.Label(	"BUI_Report_BuffsUp_TimeHeader",	BuffsUp,	{50,fs*1.5},	{LEFT,RIGHT,0,0,BuffsUp.namesH},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, BUI.Loc("ReportTimeHeader")	, false)
		BuffsUp.percH	=BUI.UI.Label(	"BUI_Report_BuffsUp_PercentHeader",	BuffsUp,	{50,fs*1.5},	{LEFT,RIGHT,0,0,BuffsUp.timeH},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, "Up "	, false)
		--Buffs List
		local list		=BUI.UI.Control(	"BUI_Report_BuffsUp_Content",		BuffsUp,	{345,20},		{TOPLEFT,TOPLEFT,0,(fs*1.5/2+10)*s},		false)
		local scroll	=BUI.UI.Scroll(list)
		BuffsUp.names	=BUI.UI.Label(	"BUI_Report_BuffsUp_Names",		scroll,	{240,20},		{TOPLEFT,TOPLEFT,0,0},			BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false)
		BuffsUp.time	=BUI.UI.Label(	"BUI_Report_BuffsUp_Time",		scroll,	{50,20},		{LEFT,RIGHT,0,0,BuffsUp.names},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false)
		BuffsUp.perc	=BUI.UI.Label(	"BUI_Report_BuffsUp_Percent",		scroll,	{50,20},		{LEFT,RIGHT,0,0,BuffsUp.time},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false)
	else
		control=_G["BUI_Report_Elements"] if control~=nil then control:SetHidden(true) end
		control=_G["BUI_Report_BuffsUp_Control"] if control~=nil then control:SetHidden(true) end
		control=_G["BUI_Report_Description"] if control~=nil then control:SetHidden(true) end
		control=_G["BUI_Report_BuffsUp_Description"] if control~=nil then control:SetHidden(true) end
	end
	--Setup Pool
	if (BUI.Stats.TargetPool==nil) then BUI.Stats.TargetPool=ZO_ObjectPool:New(BUI.Stats.CreateTarget, function(object)object:SetHidden(true)end) end
	if (BUI.Stats.AbilityPool==nil) then BUI.Stats.AbilityPool=ZO_ObjectPool:New(BUI.Stats.CreateAbility, function(object)object:SetHidden(true)end) end

	ui:SetMouseEnabled(true) ui:SetMovable(true) ui:SetScale(s)
	BUI_Report:RegisterForEvent(EVENT_NEW_MOVEMENT_IN_UI_MODE,function() if not BUI_Report:IsHidden() then BUI.Stats.Toggle() end end)
end

local function PostGroupDps(name)
	local Report=BUI.Stats.Current[ReportToShow]
	local GroupData=Report.GroupDPS
	local fighttime=GroupData.Total.time
	local GroupDPS=GroupData.Total.dps
	local TotalDmg=GroupData.Total.damage or GroupData.Total.dps*GroupData.Total.time
	--Retreive primary target
	targets={}
	for target,abilities in pairs(Report.Damage) do
		local damage,bosscount=0,0
		for _,stats in pairs(abilities) do damage=damage+stats.total end
		if target~="Total" and target~=Report.Char then
			if BUI.Stats.Bosses[target] or (Report.Boss and Report.Boss[target]) then bosscount=bosscount+1 target=target.." ("..BUI.Loc("Boss")..")" end
			table.insert(targets,{name=target,damage=damage})
		end
	end
	table.sort(targets,BUI.Stats.SortDamage)
	local text=#targets>0 and targets[1].name.."+"..#targets-1 .." - "

	if name=="Total" then
		local members={}
		for name,data in pairs(GroupData) do if name~="Total" and data.dps and data.time then table.insert(members,{name=name,damage=data.dps*data.time}) end end
		table.sort(members,BUI.Stats.SortDamage)
		--Add total
		text="Group DPS: "..text..BUI.DisplayNumber(GroupDPS).." ("..ZO_FormatTime(fighttime,SI_TIME_FORMAT_TIMESTAMP)..")"
		--Loop over members
		for i=1,math.min(#members,12) do
			local n=members[i].name
			if GroupData[n].average~="~" then
				local pct=math.min(math.floor(members[i].damage/TotalDmg*100),100)
				if pct>2 then
					text=text..", "
					..n..": "..BUI.DisplayNumber(GroupData[n].dps).." "..ZO_FormatTime(GroupData[n].time,SI_TIME_FORMAT_TIMESTAMP)
					.." ("..pct.."%)"
				end
			end
		end
	elseif GroupData[name] then
		local damage=GroupData[name].dps*GroupData[name].time
		text=text..name.." DPS: "..BUI.DisplayNumber(GroupData[name].dps)..
			" ("..ZO_FormatTime(GroupData[name].time,SI_TIME_FORMAT_TIMESTAMP)..") "..
			math.min(math.floor(damage/TotalDmg*100),100).."%"
	end
	if text then
		CHAT_SYSTEM:Maximize() CHAT_SYSTEM.primaryContainer:FadeIn()
		StartChatInput(text)
	end
end

function BUI.Stats.CreateTarget()
	local fs,s=BUI.Vars.StatsFontSize,1	--BUI.Vars.ReportScale
	local w=720+((BUI.language=="en" or BUI.Vars.ActionsPrecise)and 50 or 0)
	local i	=BUI.Stats.TargetPool:GetNextControlId()
	local parent=BUI_Report
	--Create target
	local control	=BUI.UI.Control(	"BUI_Report_Target"..i,			parent,		{w,fs*1.5},				{LEFT,LEFT,10*s,0},		false)
	control.bg		=BUI.UI.Backdrop(	"BUI_Report_Target"..i.."_BG",	control,		{w,fs*1.5},				{TOP,TOP,0,0},			{.3,.3,.3,.7}, {0,0,0,1}, BUI.Textures["grainy"], false)
	control.name	=BUI.UI.Label(	"BUI_Report_Target"..i.."_Name",	control.bg,		{220,fs*1.5},			{LEFT,LEFT,10*s,0},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("ReportTargetName"), false)
	control.total	=BUI.UI.Label(	"BUI_Report_Target"..i.."_Total",	control.name,	{220,fs*1.5},			{LEFT,RIGHT,0,0},			BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, "", false)	--BUI.Loc("ReportTotalDamage")
	control.dps		=BUI.UI.Label(	"BUI_Report_Target"..i.."_DPS",	control.bg,		{100,fs*1.5},			{RIGHT,RIGHT,-fs*6*s,0},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, "", false)	--"DPS"
	--Expand button
	control.expand	=BUI.UI.Button(	"BUI_Report_Target"..i.."_Expand",	control,		{fs,fs},				{RIGHT,RIGHT,-10*s,0,control.bg},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	control.expand:SetNormalTexture('/esoui/art/buttons/pointsplus_up.dds')
	control.expand:SetMouseOverTexture('/esoui/art/buttons/pointsplus_over.dds')
	control.expand:SetPressedTexture('/esoui/art/buttons/pointsminus_up.dds')
	control.expand:SetPressedMouseOverTexture('/esoui/art/buttons/pointsminus_over.dds')
	control.expand:SetDisabledTexture('/esoui/art/buttons/pointsplus_disabled.dds')
	control.expand:SetDisabledPressedTexture('/esoui/art/buttons/pointsminus_disabled.dds')
	control.expand:SetHandler("OnClicked", function(self) PlaySound("Click") BUI.Stats.ExpandTarget(self) end)
	--Target buff button
	control.targetbuffs=BUI.UI.Button(	"BUI_Report_Target"..i.."_Debuff",	control,		{fs*1.2,fs*1.2},			{RIGHT,LEFT,0,0,control.expand},	BSTATE_NORMAL, nil, nil, nil, nil, nil, not BUI.Vars.StatsBuffs)
	control.targetbuffs:SetNormalTexture('/esoui/art/tutorial/smithing_rightarrow_up.dds')
	control.targetbuffs:SetPressedTexture('/esoui/art/tutorial/smithing_leftarrow_up.dds')
	control.targetbuffs.state="collapsed"
	control.targetbuffs:SetHandler("OnClicked", function(self) PlaySound("Click") BUI.Stats.ExpandTargetBuffs(self) end)
	--Post button
	control.post	=BUI.UI.Button(	"BUI_Report_Target"..i.."_Post",	control,		{fs*1.5,fs*1.5},			{RIGHT,LEFT,0,0,control.targetbuffs},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false)
	control.post:SetNormalTexture('/esoui/art/chatwindow/chat_notification_up.dds')
	control.post:SetMouseOverTexture('/esoui/art/chatwindow/chat_notification_over.dds')
	control.post:SetDisabledTexture('/esoui/art/chatwindow/chat_notification_disabled.dds')
	control.post:SetHandler("OnClicked", BUI.Stats.Post)
	--Store some data
	control.state	="collapsed"
	--DeBuffs Backdrop
	control.d		=BUI.UI.Control(	"BUI_Report_DeBuffs"..i,			control,		{345,fs*1.5},	{TOPLEFT,TOPRIGHT,10*s,0},	true)
	control.d.bg	=BUI.UI.Backdrop(	"BUI_Report_DeBuffs"..i.."_BG",		control.d,		{345,fs*1.5},		{TOP,TOP,0,0},			{.3,.3,.3,.7}, {0,0,0,1}, BUI.Textures["grainy"], false)
	control.d.name	=BUI.UI.Label(	"BUI_Report_DeBuffs"..i.."_Name",		control.d,		{190,fs*1.5},	{LEFT,LEFT,10*s,0},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("ReportTBHeader"), false)
	--DeBuffs Headers
	control.d.header	=BUI.UI.Control(	"BUI_Report_DeBuffs"..i.."_Header",		control.d,		{345,fs*1.5*2},	{TOPLEFT,BOTTOMLEFT,0,0},	false)
	control.d.namesH	=BUI.UI.Label(	"BUI_Report_DeBuffs"..i.."_NamesHeader",	control.d.header,	{240,fs*1.5},	{TOPLEFT,TOPLEFT,0,0},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, BUI.Loc("ReportBuffHeader")	, false)
	control.d.timeH	=BUI.UI.Label(	"BUI_Report_DeBuffs"..i.."_TimeHeader",	control.d.namesH,	{50,fs*1.5},	{LEFT,RIGHT,0,0},			BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, BUI.Loc("ReportTimeHeader")	, false)
	control.d.percH	=BUI.UI.Label(	"BUI_Report_DeBuffs"..i.."_PercHeader",	control.d.timeH,	{50,fs*1.5},	{LEFT,RIGHT,0,0},			BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {1,1}, "Up "	, false)
	--Buffs List
	control.d.content	=BUI.UI.Control(	"BUI_Report_DeBuffsUp"..i.."_Content",	control.d.header,	{345,20},		{TOPLEFT,TOPLEFT,0,(fs*1.5/2+10)*s},		false)
	local scroll	=BUI.UI.Scroll(control.d.content)
	control.d.names	=BUI.UI.Label(	"BUI_Report_DeBuffsUp"..i.."_Names",	scroll,		{240,20},		{TOPLEFT,TOPLEFT,0,0},BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false)
	control.d.time	=BUI.UI.Label(	"BUI_Report_DeBuffsUp"..i.."_Time",		scroll,		{50,20},		{LEFT,RIGHT,0,0,control.d.names},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false)
	control.d.perc	=BUI.UI.Label(	"BUI_Report_DeBuffsUp"..i.."_Perc",		scroll,		{50,20},		{LEFT,RIGHT,0,0,control.d.time},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,0}, ""	, false)
	--Summary
	control.d.summary	=BUI.UI.Label(	"BUI_Report_Target"..i.."_Summary",		control.d,		{345,(fs-4)*1.36*3},	{BOTTOMLEFT,TOPLEFT,20*s,0},	BUI.UI.Font("standard",fs-4,true), {1,1,1,1}, {0,0}, "", false)
	return control
end

function BUI.Stats.CreateAbility()
	local fs=BUI.Vars.StatsFontSize
	local w=720+((BUI.language=="en" or BUI.Vars.ActionsPrecise)and 50 or 0)
	local i	=BUI.Stats.AbilityPool:GetNextControlId()
	local parent=BUI_Report_List
	--Create ability
	local control	=BUI.UI.Control(	"BUI_Report_Ability"..i,			parent,	{w,fs*1.5},			{LEFT,LEFT,10,0},		false)
	control.icon	=BUI.UI.Texture(	"BUI_Report_Ability"..i.."_Icon",		control,	{fs*1.5-2,fs*1.5-2},	{LEFT,LEFT,0,0},		'/esoui/art/icons/icon_missing.dds', false)
	control.bg		=BUI.UI.Backdrop(	"BUI_Report_Ability"..i.."_BG",		control,	{220,fs*1.2},		{LEFT,RIGHT,0,0,control.icon},	{.4,.4,.4,.4}, {0,0,0,0}, nil, false)
	control.name	=BUI.UI.Label(	"BUI_Report_Ability"..i.."_Name",		control,	{220,fs*1.5},		{LEFT,RIGHT,0,0,control.icon},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("Ability"), false)
--	control.uses	=BUI.UI.Label(	"BUI_Report_Ability"..i.."_Uses",		control,	{30,fs*1.5},		{LEFT,RIGHT,0,0,control.name},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("ReportCount"), false)
	control.total	=BUI.UI.Label(	"BUI_Report_Ability"..i.."_Total",		control,	{130,fs*1.5},		{LEFT,RIGHT,0,0,control.name},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("ReportTotal"), false)
	control.dps		=BUI.UI.Label(	"BUI_Report_Ability"..i.."_DPS",		control,	{70,fs*1.5},		{LEFT,RIGHT,0,0,control.total},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "DPS", false)
	control.count	=BUI.UI.Label(	"BUI_Report_Ability"..i.."_Count",		control,	{70,fs*1.5},		{LEFT,RIGHT,0,0,control.dps},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("ReportCount"), false)
	control.crit	=BUI.UI.Label(	"BUI_Report_Ability"..i.."_Crit",		control,	{50,fs*1.5},		{LEFT,RIGHT,0,0,control.count},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("Crit"), false)
	control.avg		=BUI.UI.Label(	"BUI_Report_Ability"..i.."_Avg",		control,	{70,fs*1.5},		{LEFT,RIGHT,0,0,control.crit},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("Average"), false)
	control.max		=BUI.UI.Label(	"BUI_Report_Ability"..i.."_Max",		control,	{70,fs*1.5},		{LEFT,RIGHT,0,0,control.avg},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, BUI.Loc("Max"), false)
	if (BUI.language=="en" or BUI.Vars.ActionsPrecise)then
	control.perc	=BUI.UI.Label(	"BUI_Report_Ability"..i.."_Perc",		control,	{50,fs*1.5},		{LEFT,RIGHT,0,0,control.max},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "", false)
	end
--	control.min		=BUI.UI.Label(	"BUI_Report_Ability"..i.."_Min",		control,	{70,fs*1.5},		{LEFT,RIGHT,0,0,control.perc},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "Min", false)
	--Post button
	control.post	=BUI.UI.Button(	"BUI_Report_Ability"..i.."_Post",		control,	{fs*1.5,fs*1.5},		{LEFT,RIGHT,0,0,control.avg},	BSTATE_NORMAL, nil, nil, nil, nil, nil, true)
	control.post:SetNormalTexture('/esoui/art/chatwindow/chat_notification_up.dds')
	control.post:SetMouseOverTexture('/esoui/art/chatwindow/chat_notification_over.dds')
	control.post:SetDisabledTexture('/esoui/art/chatwindow/chat_notification_disabled.dds')
	control.post:SetHandler("OnClicked", function(self)PostGroupDps(self:GetParent().name:GetText())end)
	return control
end

function BUI.Stats.NextReport(prev)
	if not BUI.init.Stats then return end
	if prev then
		if ReportToShow>1 then
			ReportToShow=ReportToShow-1
			if not BUI.Stats.Current[ReportToShow] or BUI.Stats.Current[ReportToShow].damage==0 then BUI.Stats.NextReport(prev) end
		end
	else
		if ReportToShow<BUI.ReportN then
			ReportToShow=ReportToShow+1
			if not BUI.Stats.Current[ReportToShow] or BUI.Stats.Current[ReportToShow].damage==0 then BUI.Stats.NextReport(prev) end
		end
	end
	BUI.Stats.Toggle(true)
end

local function SetupPlayerBuffs()
	local parent=BUI_Report_BuffsUp
	if not BUI.Vars.StatsBuffs then
		if parent then parent:SetHidden(true) end
		return
	elseif not parent then return end
	local Report=BUI.Stats.Current[ReportToShow]
	local data=Report.PlayerBuffs
	if data==nil then parent:SetHidden(true) return end
	data[62117]=nil data[62118]=nil	--Marciless Resolve proc
	data[46327]=nil	--Crystal Fragment proc
	--Setup labels
--	local fighttime=math.max(zo_round((Report.endTime-Report.startTime)/10)/100,1)
	local fighttime=math.max((Report.endTime-Report.startTime)/1000,1)
	local names,time,percent,t,fs="","","",{},BUI.Vars.StatsFontSize
	local penetr_p,penetr_m=0,0
	--Print to the BuffsUp window
	for name,buff in pairs(data) do
		if buff.timeEnding*1000>Report.endTime then buff.timeEnding=Report.endTime/1000 end
		local duration=buff.Duration+buff.timeEnding-buff.timeStarted if duration<0 then duration=0 end
		local percent=(buff.timeStarted==buff.timeEnding) and 100 or math.min(math.floor(duration*100/fighttime+.5),100)
		table.insert(t,{
				icon		=buff.icon,
				id		=buff.id,
				player	=buff.player,
				name		=name,
				duration	=duration,
				positive	=buff.Positive,
				percent	=percent
				})
		if BUI.Penetration.Self[buff.id] then penetr_p=penetr_p+BUI.Penetration.Self[buff.id]*5*(percent/100) end
	end
	table.sort(t, function(x,y) return x.percent>y.percent end)
	for i=1, #t do
		local id	=BUI.Vars.DeveloperMode and zo_strformat("[<<1>>] ",t[i].id) or ""
		local name	=zo_strformat("<<!aC:1>>",t[i].name)
		names		=names..(names=="" and "" or "\n")..(t[i].player and "|c33BB33v|r " or "   ")..zo_iconFormat(t[i].icon,fs,fs)..(t[i].positive==false and "|cFF3333" or "")..string.sub(id..name,0,23).."|r"
		time		=time..(time=="" and "" or "\n")..BUI.FormatTime(t[i].duration)
		percent	=percent..(percent=="" and "|cAAAAAA" or "\n")..t[i].percent.."%"
	end
	if not Report.penetr then Report.penetr={["stamina"]=0,["magicka"]=0} end	--Compatibility
	if not Report.penetr.tmp then Report.penetr.tmp={["stamina"]=penetr_p,["magicka"]=penetr_m} end
	--Apply labels
	parent.names:SetText(names)
	parent.time:SetText(time)
	parent.perc:SetText(percent)
	local h=#t*fs*1.335
	parent.names:SetHeight(h)
	parent.time:SetHeight(h)
	parent.perc:SetHeight(h)
	parent:SetHidden(false)
end

local function SetupTargetBuffs(control)
	local target=zo_strformat("<<!aC:1>>",control.target)
	local parent=control.d
	if target=="Total" or target==BUI.Player.name or not BUI.Vars.StatsBuffs then parent:SetHidden(true) return end
	--Setup labels
	local Report=BUI.Stats.Current[ReportToShow]
	local data=Report.TargetBuffs[target]
	if data==nil then parent:SetHidden(true) return end
--	local fighttime=math.max(zo_round((Report.endTime-Report.startTime)/10)/100,1)
	local fighttime=math.max((Report.endTime-Report.startTime)/1000,1)
	local penetr_p_avg,penetr_m_avg,penetr_p_max,penetr_m_max,names,time,percent,t,fs=0,0,0,0,"","","",{},BUI.Vars.StatsFontSize
	local ab_Magickasteal=GetAbilityName(39100)	--Minor Magickasteal
	local ab_Crusher=GetAbilityName(17906)	--Crusher
	local ab_Alkosh=GetAbilityName(75753)	--Line-Breaker
	local ab_Breach=GetAbilityName(62787)	--Major Breach
	local ab_mBreach=GetAbilityName(62588)	--Minor Breach
	local msteal,crusher,alkosh,Breach,mBreach=0,0,0,0,0
	--Print to the BuffsUp window
	for name,buff in pairs(data) do
		if buff.timeEnding*1000>Report.endTime then buff.timeEnding=Report.endTime/1000 end
		local duration=buff.Duration+buff.timeEnding-buff.timeStarted if duration<0 then duration=0 end
		local percent=(buff.timeStarted==buff.timeEnding) and 100 or math.min(math.floor(duration*100/fighttime+.45),100)
		table.insert(t,{
				icon		=buff.icon,
				id		=buff.id,
				player	=buff.player,
				name		=name,
				duration	=duration,
				percent	=percent
				})
		--Summary calculation
		if BUI.Penetration.Target[name] then
			penetr_p_avg=penetr_p_avg+BUI.Penetration.Target[name]*(percent/100)
			penetr_p_max=penetr_p_max+BUI.Penetration.Target[name]
			penetr_m_avg=penetr_m_avg+BUI.Penetration.Target[name]*(percent/100)
			penetr_m_max=penetr_m_max+BUI.Penetration.Target[name]
		end
		if name==ab_Magickasteal then msteal=msteal+percent
		elseif name==ab_Crusher then crusher=crusher+percent
		elseif name==ab_Alkosh then alkosh=alkosh+percent
		elseif name==ab_Breach then Breach=Breach+percent
		elseif name==ab_mBreach then mBreach=mBreach+percent
		end
	end
	table.sort(t, function(x,y) return x.percent>y.percent end)
	for i=1, #t do
		local id=BUI.Vars.DeveloperMode and zo_strformat("[<<1>>] ",t[i].id) or ""
		local name	=zo_strformat("<<!aC:1>>",t[i].name)
		names		=names..(names=="" and "" or "\n")..(t[i].player and "|c33BB33v|r " or "   ")..zo_iconFormat(t[i].icon,fs,fs)..string.sub(id..name,0,23)
		time		=time..(time=="" and "" or "\n")..BUI.FormatTime(t[i].duration)
		percent	=percent..(percent=="" and "|cAAAAAA" or "\n")..t[i].percent.."%"
	end
	if not Report.penetr[target] then Report.penetr[target]={avg={["stamina"]=penetr_p_avg,["magicka"]=penetr_m_avg},max={["stamina"]=penetr_p_max,["magicka"]=penetr_m_max}} end
	--Apply labels
	parent.summary:SetHeight((fs-4)*1.36*(control.index>1 and 4 or 3))
	parent.summary:SetText(
		"|cbbbbbbCrusher:|r "..crusher.."|cbbbbbb%  Line-Breaker:|r "..alkosh.."|cbbbbbb%|r"..
		"\n|cbbbbbbMajor/Minor Breach:|r "..Breach.."|cbbbbbb/|r"..mBreach.."|cbbbbbb%|r"..
		"\n|cbbbbbbMagickasteal:|r "..msteal.."%"
--		"\n|cbbbbbbPenetration average:|r |c33bb33"..math.floor(penetr_p_avg).."|cbbbbbb/|r|c5555ff"..math.floor(penetr_m_avg).."|r"..
--		(control.index>1 and "\n|cbbbbbbPenetration max phisical/magical:|r |c33bb33"..math.floor(penetr_p_max).."|cbbbbbb/|r|c5555ff"..math.floor(penetr_m_max).."|r" or "")
		)
	parent.names:SetText(names)
	parent.time:SetText(time)
	parent.perc:SetText(percent)
	local h=#t*fs*1.335
	parent.names:SetHeight(h)
	parent.time:SetHeight(h)
	parent.perc:SetHeight(h)
end

function BUI.Stats.Toggle(redraw)
	if not BUI.init.Stats or not BUI.Vars.EnableStats then return end
	if redraw~=true then redraw=BUI_Report:IsHidden() ReportToShow=BUI.ReportN end
	--Hide additional info
	if BUI_Report_Einfo and not BUI_Report_Einfo:IsHidden() then
		BUI_Report_Einfo:SetHidden(true)
		BUI_Report_Ebutton:SetTextureRotation(0)
	end
	if BUI_Report_Uptimes and not BUI_Report_Uptimes:IsHidden() then
		BUI_Report_Uptimes:SetHidden(true)
		BUI_Report_Ubutton:SetTextureRotation(0)
	end

	if redraw then
		if BUI.Stats.Current[ReportToShow].damage>0 then
			SetupPlayerBuffs()
			if BUI.Stats.Current[ReportToShow].Saved then
				BUI_Report_Save:SetDisabled(true)
			else BUI_Report_Save:SetDisabled(nil) end
			BUI_Report_Del:SetDisabled(nil)
		else
			BUI_Report_Save:SetDisabled(true)
			BUI_Report_Del:SetDisabled(true)
		end
		if LastSection then
			if LastSection=="Group" then BUI.Stats.SetupGroupReport() else BUI.Stats.SetupReport(LastSection) end
		else
			BUI.Stats.SetupReport("Damage")
		end
		TargetBuffsIsExpanded=false
		if ReportToShow==1 then
			BUI_Report_Prev:SetDisabled(true)
		else
			BUI_Report_Prev:SetDisabled(nil)
		end
		if ReportToShow==BUI.ReportN then
			BUI_Report_Next:SetDisabled(true)
		else
			BUI_Report_Next:SetDisabled(nil)
		end
		BUI_Report_Count:SetText("("..ReportToShow.."/"..BUI.ReportN..")")
		SetGameCameraUIMode(true)
	end
	--Toggle visibility
	BanditsUI:SetHidden(redraw)
	BUI_Report:SetHidden(not redraw)
end

local function CharacterSummary(target)
	local Report=BUI.Stats.Current[ReportToShow]
	local mainpower=(Report.stamina and Report.magicka) and ((Report.stamina>Report.magicka) and "stamina" or "magicka")
	local penetr=(Report.penetr.own and Report.penetr.own[mainpower] or 0)+(Report.penetr.tmp and Report.penetr.tmp[mainpower] or 0)
	local text=
		(Report.health and "|cbb3333Health|r "..BUI.DisplayNumber(Report.health) or "")..
		(mainpower and (mainpower=="stamina" and "  |c33bb33Stamina|r "..BUI.DisplayNumber(Report.stamina) or "  |c5555ffMagicka|r "..BUI.DisplayNumber(Report.magicka)) or "")..
--		((mainpower and Report.damagepower) and (mainpower=="stamina" and "\n|c33bb33W dmg|r " or "\n|c5555ffSp dmg|r ")..BUI.DisplayNumber(Report.damagepower[mainpower]) or "")..
--		((mainpower and Report.crit and Report.crit[mainpower]) and (mainpower=="stamina" and "  |c33bb33" or "  |c5555ff").."Crit chance|r "..BUI.DisplayNumber(Report.crit[mainpower]).."|cbbbbbb%|r" or "")..
		(mainpower and "\n|cbbbbbbPenetration avg/max:|r "..
			BUI.DisplayNumber(penetr+(Report.penetr[target] and Report.penetr[target].avg and Report.penetr[target].avg[mainpower] or 0)).."|cbbbbbb/|r"..
			BUI.DisplayNumber(penetr+(Report.penetr[target] and Report.penetr[target].max and Report.penetr[target].max[mainpower] or 0)) or "")
--	d("Penetration: "..(Report.penetr.own and Report.penetr.own[mainpower] or 0).."+"..(Report.penetr.tmp and Report.penetr.tmp[mainpower] or 0).."+"..(Report.penetr[target] and Report.penetr[target][mainpower] or 0))
	BUI_Report_Summary:SetText(text)
	BUI_Report_Summary:SetHidden(false)
end

local function RemoveElementName(name)
	local element={" of Fire"," of Storms"," of Ice","Elemental ","'"}
	for _,el in pairs(element) do
		name=string.gsub(name,el,"")
	end
	name=string.gsub(name,"Deadly Cloak","Blade Cloak")
	return zo_strformat("<<!aC:1>>",name)
end

local function TogleBuffsSection(context)
	local visible=(context and context~="Incoming")
	BuffsSection=visible
	local w=720+((BUI.language=="en" or BUI.Vars.ActionsPrecise)and 50 or 0)
	local buf=(BUI.Vars.StatsBuffs and visible) and BUFF_W or 0
	control=_G["BUI_Report_Elements"] if control~=nil then control:SetHidden(not visible) end
	control=_G["BUI_Report_BuffsUp_Control"] if control~=nil then control:SetHidden(not visible) end
	control=_G["BUI_Report_Description"] if control~=nil then control:SetHidden(not visible) end
	control=_G["BUI_Report_BuffsUp_Description"] if control~=nil then control:SetHidden(not visible) end
	BUI_Report_Summary:SetHidden(not visible)
	BUI_Report:SetWidth(w+20+buf)
	BUI_Report:SetWidth(w+20+buf)
--	BUI_Report_Backdrop:SetWidth(w+20+buf)
	BUI_Report_Header:SetWidth(w+20+buf)
--	BUI_Report_Foot:SetWidth(w+20+buf)
	if BUI_Report_Einfo_Champion then BUI_Report_Einfo_Champion:SetHidden(not (BUI.Vars.StatsBuffs and BuffsSection)) end
end

local function IsDoT(id)
	return id==18084		--Burning
		or id==21481	--Chill
		or id==21929	--Poisoned
		or id==21925	--Dieseased
		or id==80565	--Kragh
		or id==80526	--Ilambris
		or GetAbilityTargetDescription(id)~=GetString(SI_TARGETTYPE0)
end

local function GetAbilityUptime(id,ab_name,target)
	local Report=BUI.Stats.Current[ReportToShow]
	local up=target and Report.Damage[target][ab_name].uptime or 0
	if up and up>0 then return up end
	local name=ab_name and RemoveElementName(ab_name)
	local fighttime=math.max(Report.endTime-Report.startTime,1000)
	--From buffs
	if target and Report.TargetBuffs[target] then
		for buff_name,buff in pairs(Report.TargetBuffs[target]) do
			if buff_name==name then
--				d("Uptime from buffs: "..buff_name)
				if buff.timeEnding*1000>Report.endTime then buff.timeEnding=Report.endTime/1000 end
				local duration=math.max(buff.Duration+buff.timeEnding-buff.timeStarted,0)
				up=(buff.timeStarted==buff.timeEnding) and 100 or math.min(math.floor(duration*1000/fighttime*100),100)
				break
			end
		end
		if up and up>0 then
			Report.Damage[target][ab_name].uptime=up
			return up
		end
	end
	--From ability used
	if Report.Uptimes then
		local Uptimes=Report.Uptimes[id]
		if not Uptimes and name then
			for _id in pairs(Report.Uptimes) do
				if name==RemoveElementName(GetAbilityName(_id)) then
					Uptimes=Report.Uptimes[_id]
--					d("Uptime from ability used: ["..id.."]=".._id)
					break
				end
			end
		end
		if Uptimes then
			local duration,endtime=0,0
			for i,data in ipairs(Uptimes) do
				if Report.endTime<data[1]+data[2] then data[2]=Report.endTime-data[1] end
				local delta=data[1]<endtime and data[2]-(endtime-data[1]) or data[2]
				duration=duration+delta
				endtime=data[1]+data[2]
			end
			up=math.floor(duration/fighttime*100)
--			d("Uptime from ability used: ["..id.."] "..duration..", "..fighttime)
			if target then Report.Damage[target][ab_name].uptime=up end
			return up
		end
	end
	--By ticks
	if target then
		local ab_table={}	--Prepare ability table
		for i=1,88 do
			local n,m,r=GetAbilityProgressionInfo(i)
			if n~="" then local id=GetAbilityProgressionAbilityId(i,m,r) ab_table[RemoveElementName(GetAbilityName(id))]=id else break end
		end
		if ab_table[name] then
--			d("Uptime by ticks: "..name.."="..tostring(ab_table[name]))
			local count=Report.Damage[target][ab_name].count
			up=math.min(math.floor(count*BUI.GetAbilityTickTime(ab_table[name])*1000/fighttime*100),100)
			Report.Damage[target][ab_name].uptime=up
		end
	end

	return up or 0
end
--	/script d(BUI.Stats.Current[BUI.ReportN].Uptimes)
function BUI.Stats.SetupUptimes()		--Uptimes
	local Report=BUI.Stats.Current[ReportToShow] if not Report or not Report.Uptimes then return end

	if BUI_Report_Uptimes and not BUI_Report_Uptimes:IsHidden() then
		BUI_Report_Uptimes:SetHidden(true)
		BUI_Report_Ubutton:SetTextureRotation(0)
		return
	end
	BUI_Report_Ubutton:SetTextureRotation(math.pi)
	if BUI_Report_Einfo and not BUI_Report_Einfo:IsHidden() then
		BUI_Report_Einfo:SetHidden(true)
		BUI_Report_Ebutton:SetTextureRotation(0)
	end
	local fs,s=BUI.Vars.StatsFontSize,1	--BUI.Vars.ReportScale
	local w=BUI_Report:GetWidth()-20	--720+((BUI.language=="en" or BUI.Vars.ActionsPrecise)and 50 or 0)+BUFF_W
	local head=40
	local ui=BUI_Report_Uptimes or WINDOW_MANAGER:CreateControl("BUI_Report_Uptimes", BUI_Report, CT_BACKDROP)
	ui:SetCenterColor(0,0,0,BUI.Vars.StatsTransparent and 0.7 or 1)
	ui:SetEdgeColor(.7,.7,.5,.3)
	ui:SetEdgeTexture("",8,2,2)
	ui:SetHidden(false)
	ui:ClearAnchors()
	ui:SetAnchor(TOPLEFT,BUI_Report,BOTTOMLEFT,0,-2)
	ui:SetDrawTier(DT_HIGH)
    ui:SetDrawLayer(DL_CONTROLS)
--	ui:SetAnchor(BOTTOMRIGHT,BUI_Report,BOTTOMRIGHT)
	if not ui.line then
		ui.line=WINDOW_MANAGER:CreateControl("BUI_Report_Uptimes_L1", ui, CT_LINE)
		ui.line:ClearAnchors()
		ui.line:SetAnchor(TOPLEFT,ui,TOPLEFT,230,2)
		ui.line:SetAnchor(BOTTOMRIGHT,ui,BOTTOMLEFT,230,-2)
		ui.line:SetColor(.7,.7,.5,.3)
		ui.line:SetThickness(2)
		ui.line:SetHidden(false)
		ui.title=BUI.UI.Label("BUI_Report_Uptimes_Title", ui, {230,fs*1.5}, {TOPLEFT,TOPLEFT,10*s,0}, BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, "", false)
	end
	--Start
	local ElementColor={[0]={.2,.2,.2,.7},[1]={.5,.5,.5,.7},[2]={.7,.7,.7,.7},[3]={.7,.2,.2,.7},[4]={1,1,1,.7},[5]={.5,.5,.5,.7},[6]={.7,.7,1,.7},[7]={.7,.7,.2,.7},[8]={.3,.3,.7,.7},[9]={.5,.5,.5,.7},[10]={.7,.2,.7,.7},[11]={.2,.7,.2,.7}}
	local AbilityName={[103]="Swap"}
	local startTime=Report.startTime
	local fighttime=math.max(Report.endTime-Report.startTime,1000)
	local scale=(w-230)/fighttime
	local h=fs*1.8
--		local space=(h-fs*1.2)/2
	local row=0
	--Grid
	local grid=BUI_Report_Grid
	if not grid then
		grid=BUI.UI.Control("BUI_Report_Grid", ui, {w-230,30}, {TOPLEFT,TOPLEFT,240,5})
		BUI.UI.Line(nil, grid, {w-230,0}, {TOPLEFT,TOPLEFT,0,0}, {.7,.7,.7,1}, 2)
		BUI.UI.Line(nil, grid, {0,15}, {TOPLEFT,TOPLEFT,0,0}, {.7,.7,.7,1}, 2) BUI.UI.Label(nil, grid, {fs-4,fs-4}, {TOP,TOPLEFT,0,15}, BUI.UI.Font("standard",fs-4,true), {1,1,1,1}, {1,0}, "0")
		BUI.UI.Line(nil, grid, {0,15}, {TOPRIGHT,TOPRIGHT,0,0}, {.7,.7,.7,1}, 2) BUI.UI.Label("BUI_Report_Grid_L1000", grid, {(fs-4)*2,fs-4}, {TOPRIGHT,TOPRIGHT,0,15}, BUI.UI.Font("standard",fs-4,true), {1,1,1,1}, {2,0}, "")
	end
	BUI_Report_Grid_L1000:SetText(tostring(ZO_FormatTime(fighttime/1000,SI_TIME_FORMAT_TIMESTAMP)))
	local step,n=math.max(math.floor(fighttime/100000)*10,5),1
	for i=step,math.floor(fighttime/1000),step do
		local x=i*1000*scale
		local round=math.floor(i/10)==i/10
		local line=_G["BUI_Report_Grid_"..n] or WINDOW_MANAGER:CreateControl("BUI_Report_Grid_"..n, grid, CT_LINE)
		line:ClearAnchors()
		line:SetAnchor(TOPLEFT,grid,TOPLEFT,x,0)
		line:SetAnchor(BOTTOMRIGHT,grid,TOPLEFT,x,round and 15 or 10)
		line:SetColor(.7,.7,.7,1)
		line:SetThickness(2)
		line:SetHidden(false)
--			BUI.UI.Line("BUI_Report_Grid_"..n, grid, {0,round and 15 or 10}, {TOPLEFT,TOPLEFT,i*1000*scale,0}, {.7,.7,.7,1}, 2)
		if round then BUI.UI.Label("BUI_Report_Grid_L"..n, grid, {(fs-4)*2,fs-4}, {TOP,TOPLEFT,x,15}, BUI.UI.Font("standard",fs-4,true), {1,1,1,1}, {1,0}, tostring(ZO_FormatTime(i,SI_TIME_FORMAT_TIMESTAMP))) end
		n=n+1
	end
	for i=n,20 do
		local line=_G["BUI_Report_Grid_"..i] if line then line:SetHidden(true) end
		local label=_G["BUI_Report_Grid_L"..i] if label then label:SetHidden(true) end
	end
	for id,uptimes in pairs(Report.Uptimes) do
		local name=RemoveElementName(GetAbilityName(id))
		local element=0
		for ab_name,data in pairs(Report.Damage.Total) do
			if name==RemoveElementName(ab_name) then
				element=data.damageType
				break
			end
		end
		local uptime=id>200 and GetAbilityUptime(id) or 0
		local text=zo_iconFormat(AbilityIcons[id] or GetAbilityIcon(id),fs,fs)..string.sub((uptime>1 and uptime.."% " or " ")..(AbilityName[id] or GetAbilityName(id)),1,24)	--"["..id.."] "..
		local bar=BUI.UI.Backdrop("BUI_Report_Uptimes"..row.."_BG", ui,	{210*uptime/100,fs*1.2}, {TOPLEFT,TOPLEFT,10,head+row*h},	{.4,.4,.4,.4}, {0,0,0,0}, nil, false)
		BUI.UI.Label("BUI_Report_Uptimes_Title"..row, bar, {210,fs*1.2}, {TOPLEFT,TOPLEFT,10,head+row*h,ui}, BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, text)
		local last_bar=0
		for i,data in ipairs(uptimes) do
			if i<100 and data[1]<Report.endTime then
			local delta=Report.endTime<data[1]+data[2] and Report.endTime-data[1] or data[2]
			local color=id==103 and {.5,0,.5,1} or ElementColor[element]
			local bar=BUI.UI.Backdrop("BUI_Report_Uptime_Bar"..row.."_"..i, ui, {delta*scale,fs*1.2}, {TOPLEFT,TOPLEFT,240+(data[1]-startTime)*scale,head+row*h}, color,color)
			bar.LA=bar.LA or BUI.UI.Line("BUI_Report_Uptime_LA"..row.."_"..i, bar, {0,-fs*1.2-4}, {BOTTOMLEFT,BOTTOMLEFT,-1,2}, {.7,.7,.7,1}, 4)
			bar.LA:SetHidden(not data[3])
			bar.Sw=bar.Sw or BUI.UI.Line("BUI_Report_Uptime_Sw"..row.."_"..i, bar, {0,-fs*1.2-8}, {BOTTOMLEFT,BOTTOMLEFT,-5,4}, {.5,0,.5,1}, 4)
			bar.Sw:SetHidden(not data[4])
			last_bar=i
			end
		end
		for i=last_bar+1,100 do local bar=_G["BUI_Report_Uptime_Bar"..row.."_"..i] if bar then bar:SetHidden(true) else break end end
		row=row+1
	end
	if row>0 then
		for ii=row,14 do
			local bar=_G["BUI_Report_Uptimes"..ii.."_BG"] if bar then bar:SetHidden(true) else break end
			for i=1,100 do local bar=_G["BUI_Report_Uptime_Bar"..ii.."_"..i] if bar then bar:SetHidden(true) end end
		end
		ui:SetAnchor(BOTTOMRIGHT,BUI_Report,BOTTOMRIGHT,0,head+row*h)
		ui.title:SetText("Uptimes for "..ZO_FormatTime(fighttime/1000,SI_TIME_FORMAT_TIMESTAMP))
		if ui:GetBottom()>GuiRoot:GetBottom() then
			BUI_Report:ClearAnchors()
			BUI_Report:SetAnchor(TOP,GuiRoot,TOP,0,0)
			local delta=ui:GetBottom()-GuiRoot:GetBottom()
			if delta>0 and BUI_Report.expanded then
				if BUI.Vars.StatsBuffs then
					BUI_Report_BuffsUp_Content:SetHeight(BUI_Report_BuffsUp_Content:GetHeight()-delta)
					BUI_Report.expanded.d.content:SetHeight(BUI_Report.expanded.d.content:GetHeight()-delta)
				end
				BUI_Report_Ability.content:SetHeight(BUI_Report_Ability.content:GetHeight()-delta)
				BUI_Report:SetHeight(BUI_Report:GetHeight()-delta)
			end
		end
		return
	end
	ui:SetHidden(true)
end
--	/script BUI.Stats.SetupUptimes()
function BUI.Stats.SetupReport(context,header_button)	--Setup player report
	BUI.Stats.TargetPool:ReleaseAllObjects()
--	BUI.Stats.AbilityPool:ReleaseAllObjects()
	local Report=BUI.Stats.Current[ReportToShow]
	if not Report then return end
	local fs,s=BUI.Vars.StatsFontSize,1	--BUI.Vars.ReportScale
	--HeaderButtons
	ResetHeaderButtons() if header_button then header_button:SetState(BSTATE_DISABLED) end
	BUI_Report_Ubutton_Base:SetHidden(context~="Damage" or not Report.Uptimes)
	BUI_Report_Ability:SetHidden(true)
	if BUI_Report_PostDeathTotal then BUI_Report_PostDeathTotal:SetHidden(true) end
	--Compute index of targets
	local targets={}
	local anchor=_G["BUI_Report_Title"]
	local realcontext=context
	local nodamage=true
	if context=="Incoming" then
		context="Damage"
		local abilities=Report[context][BUI.Player.name]
		--Calculate total damage dealt to target
		local damage=0
		if abilities then for _,stats in pairs(abilities) do damage=damage+stats.total end end
		targets={[1]={["name"]=Report.Char,["damage"]=damage}}
		nodamage=Report.Damage[Report.Char]==nil
	else
		for target,abilities in pairs(Report[context]) do
			--Calculate total damage dealt to target
			local damage=0
			for _,stats in pairs(abilities) do damage=damage+stats.total end
			local data={["name"]=target,["damage"]=damage}
			--Add the target to an index table
			if not(context=="Damage" and target==Report.Char) then table.insert(targets,data) end
		end
		--Sort targets based on total damage
		table.sort(targets,BUI.Stats.SortDamage)
		--Remove total if there is only one target
		if (#targets==2) then table.remove(targets,1) end
		nodamage=Report[string.lower(context)]==0
	end
	BUI.Stats[realcontext.."Targets"]=targets
	--Loop over targets,setting up controls
	local fighttime=math.max(zo_round((Report.endTime-Report.startTime)/10)/100,1)
	for i=1,math.min(#targets,6) do
		--Get a control from the pool
		local control,objectKey=BUI.Stats.TargetPool:AcquireObject()
		control.id=objectKey
		--Assign data
		local target=targets[i]
		control.target=target.name
		control.index=i
		control.context=realcontext
		BUI.Stats[realcontext.."Section"]={[target.name]=control}
		--Compute data
		local pct=BUI.DisplayNumber(target.damage*100/Report[string.lower(context)],1)
		--Set Labels
		if nodamage then
			local name=BUI.Loc("NoDamage")
			control.name:SetText(name)
			control.total:SetText()
			control.dps:SetText()
			control.expand:SetState(BSTATE_DISABLED)
			control.targetbuffs:SetState(BSTATE_DISABLED)
--			control.more:SetState(BSTATE_DISABLED)
			TogleBuffsSection()
		else
			local targetname=zo_strformat("<<!aC:1>>",target.name)
			local name=(target.name=="Total") and BUI.Loc("AllTargets") or targetname
			if BUI.Stats.Bosses[targetname] or (Report.Boss and Report.Boss[targetname]) then name=name.." ("..BUI.Loc("Boss")..")" end
			control.name:SetText(name)
			local damname=(context=="Damage") and BUI.Loc("Damage") or (context=="Healing") and BUI.Loc("Healing") or BUI.Loc("Power")
			control.total:SetText(BUI.DisplayNumber(target.damage) .. " " .. damname .. " |cAAAAAA(" .. pct .. "%)|r")
			local dpsname=(context=="Damage") and "DPS" or (context=="Healing") and "HPS" or "RPS"
			control.dps:SetText(BUI.DisplayNumber(target.damage/fighttime,0) .. " " .. dpsname)
			control.expand:SetState(BSTATE_ENABLED)
			TogleBuffsSection(realcontext)
			control.targetbuffs:SetState(BSTATE_NORMAL)
			control.targetbuffs:SetHidden(target.name=="Total" or context~="Damage" or name==BUI.Player.name or not BUI.Vars.StatsBuffs)
		end
		--Reset Button
		control.expand:SetState(nodamage and BSTATE_DISABLED or BSTATE_NORMAL)
		control.state="collapsed"
		--Post Button
		control.post:SetState(target.damage==0 and BSTATE_DISABLED or BSTATE_NORMAL)
		--Set Anchors
		control:SetHeight(fs*1.5)
		control:ClearAnchors()
		control:SetAnchor(TOPLEFT,anchor,BOTTOMLEFT,0,0)
		anchor=control
		--Display
		control:SetHidden(false)
	end
	--Modify headers
	if nodamage then
		control=_G["BUI_Report_Elements"] if control~=nil then control:SetHidden(true) end
		BUI_Report_Title:SetText(BUI.Loc("DReport"))
		BUI_Report:SetHeight(200)
		return
	else
		local targetName=(#targets==0) and "" or (#targets>1) and targets[2].name or targets[1].name
		local title=(context=="Damage") and BUI.Loc("DReport") or (context=="Healing") and BUI.Loc("HReport") or (context=="Power") and BUI.Loc("PReport") or BUI.Loc("IReport")
		local name="|t"..fs..":"..fs..":"..GetClassIcon(Report.Class).."|t"..Report.Char..(Report.Level and " ("..Report.Level..")" or "")
		title=name.." "..title.." - "..zo_strformat("<<!aC:1>>",targetName).." (" .. ZO_FormatTime(fighttime,SI_TIME_FORMAT_TIMESTAMP)..")"
		BUI_Report_Title:SetText(title)
	end
	--Elements
	if BUI.Vars.StatsBuffs then
		local Dot_Damage=0
		local Direct_Damage=0
		local Spell_Damage=0
		local Weapon_Damage=0
		local Element_Damage={[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0,[13]=0,[14]=0}
		for name,data in pairs(Report.Damage.Total) do
--			if not BUI.Stats.IsSingleAttack(ability) then Dot_Damage=Dot_Damage+data.total end
			if GetAbilityUptime(data.id,name)==0 then Direct_Damage=Direct_Damage+data.total end
			local damageType=data.damageType
			if (damageType==DAMAGE_TYPE_MAGIC or damageType==DAMAGE_TYPE_COLD or damageType==DAMAGE_TYPE_EARTH or damageType==DAMAGE_TYPE_FIRE or damageType==DAMAGE_TYPE_SHOCK) then Spell_Damage=Spell_Damage+data.total
			elseif (damageType==DAMAGE_TYPE_PHYSICAL or damageType==DAMAGE_TYPE_POISON or damageType==DAMAGE_TYPE_DISEASE) then Weapon_Damage=Weapon_Damage+data.total end
			Element_Damage[damageType]=Element_Damage[damageType]+data.total
		end
		Direct_Damage=math.floor(Direct_Damage*100/Report.damage)
		if (Report.magicka or 0)>(Report.stamina or 0) then
			title=
			"|cbb3333Fire|r "..math.floor(Element_Damage[3]*100/Report.damage).."%"..
			"  |cffffffShock|r "..math.floor(Element_Damage[4]*100/Report.damage).."%"..
			"  |cbbbbffCold|r "..math.floor(Element_Damage[6]*100/Report.damage).."%"..
			"  |c5555ffMagic|r "..math.floor(Element_Damage[DAMAGE_TYPE_MAGIC]*100/Report.damage).."%"
		else
			title=
			"|cbbbbbbPhysical|r "..math.floor(Element_Damage[DAMAGE_TYPE_PHYSICAL]*100/Report.damage).."%"..
			"  |c33bb33Poison|r "..math.floor(Element_Damage[11]*100/Report.damage).."%"..
			"  |cbb33bbDisease|r "..math.floor(Element_Damage[DAMAGE_TYPE_DISEASE]*100/Report.damage).."%"..
			"  |cbb3333Bleed|r "..math.floor(Element_Damage[DAMAGE_TYPE_BLEED]*100/Report.damage).."%"
		end
			title=title.."\n"..
			"|cbbbbbbWeapon|r "..math.floor(Weapon_Damage*100/Report.damage).."%"..
			"  |c5555ffSpell|r "..math.floor(Spell_Damage*100/Report.damage).."%"..
--			"  |cAAAAAADoT|r ".. 100-Direct_Damage.."%"..
			(Direct_Damage<100 and "  |cAAAAAADirect damage|r "..Direct_Damage.."%" or "")
		--Weawing
		title=title.."\n"..
			(Report.Ability.w and "|cAAAAAAWeapon Attack/Ability:|r "..Report.Ability.w.."|cAAAAAA/|r"..(Report.Ability.a or 0) or "")..
			(Report.Ability.a and "  |cbbbbbbRotation speed:|r "..math.min(math.floor(Report.Ability.a/fighttime*100),100).."|cAAAAAA%|r" or "")
		BUI_Report_Elements:SetText(title)
		BUI_Report_Elements:SetHidden(realcontext=="Incoming")
	end

	BUI_Report_Version:SetText((Report.Acc or "").." "..(Report.ESOVersion or ""))
	BUI.Stats.ExpandTarget(#targets>1 and BUI_Report_Target2_Expand or BUI_Report_Target1_Expand)
end

local function CollapseAll()
	local buf=(BUI.Vars.StatsBuffs and BuffsSection) and BUFF_W or 0
	local w=720+((BUI.language=="en" or BUI.Vars.ActionsPrecise)and 50 or 0)
	for i,control in pairs (BUI.Stats.TargetPool.m_Active) do
		control.d:SetHidden(true)
		control.targetbuffs:SetState(BSTATE_DISABLED)
		control.targetbuffs.state="collapsed"
		control:SetWidth(w) control.bg:SetWidth(w)
	end
	BUI_Report_Ability:SetWidth(w)
	BUI_Report:SetWidth(w+20+buf)
--	BUI_Report_Backdrop:SetWidth(w+20+buf)
--	BUI_Report_Foot:SetWidth(w+20+buf)
end

function BUI.Stats.ExpandTargetBuffs(self)
	local parent=self:GetParent()
	local state=self.state
	local w=720+((BUI.language=="en" or BUI.Vars.ActionsPrecise)and 50 or 0)
	local buf=BUI.Vars.StatsBuffs and BUFF_W or 0
	self:SetState(BSTATE_NORMAL)
	CollapseAll()
	if state=="collapsed" then
		self:SetState(BSTATE_PRESSED)
		self.state="expanded"
		TargetBuffsIsExpanded=true
		parent.d:SetHidden(false)
		BUI_Report:SetWidth(w+20+buf+BUFF_W)
--		BUI_Report_Backdrop:SetWidth(w+20+buf+BUFF_W)
--		BUI_Report_Foot:SetWidth(w+20+buf+BUFF_W)
	else
		self:SetState(BSTATE_NORMAL)
		TargetBuffsIsExpanded=false
		parent.d:SetHidden(true)
	end
end

function BUI.Stats.ExpandTarget(self)
	--Get data
	local fs,s=BUI.Vars.StatsFontSize,1	--BUI.Vars.ReportScale
	local parent	=self:GetParent()
	local state		=parent.state
	local target	=parent.target
	local realcontext	=parent.context
	local context	=realcontext=="Incoming" and "Damage" or realcontext
	local container	=BUI_Report_Ability
	local Report	=BUI.Stats.Current[ReportToShow]
	local mainpower	=(Report.stamina and Report.magicka) and ((Report.stamina>Report.magicka) and "stamina" or "magicka")
	LastSection		=realcontext
	BUI_Report.expanded=nil
	--Release existing objects
	BUI.Stats.AbilityPool:ReleaseAllObjects()
	--Maybe Collapse
	local oldButton=nil
	if not container:IsHidden() then
		--Get the old parent
		local _,_,oldParent=BUI_Report_Ability:GetAnchor()
		oldButton=oldParent.expand
		--Set the button state
		oldButton:SetState(BSTATE_DISABLED)
		--Expand the parent container
		oldParent:SetHeight(fs*1.5/s)
		container:SetHidden(true)
		--Restore the button state
		oldButton:SetState(BSTATE_NORMAL)
		oldParent.state="collapsed"
		parent.targetbuffs:SetState(BSTATE_DISABLED)
	end
	--Maybe Expand
	if (self~=oldButton and parent.state=="collapsed") then
		SetupTargetBuffs(parent)
		--Set the button state
		self:SetState(BSTATE_DISABLED_PRESSED)
		parent.state="disabled"
		if TargetBuffsIsExpanded and context=="Damage" then BUI.Stats.ExpandTargetBuffs(parent.targetbuffs) else CollapseAll() end
		if context=="Damage" then parent.targetbuffs:SetState(BSTATE_NORMAL) end
		--Compute index of abilities
		local abilities={}
		for name,stats in pairs(Report[context][target]) do
			--Setup some data
			local data={
				["name"]	=name,
				["damage"]	=stats.total,
				["id"]	=stats.id,
				["source"]	=(target==BUI.Player.name) and ("|cCCCCCC"..zo_strformat("(<<!aC:1>>)",stats.source.."|r")) or ""
			}
			--Add the target to an index table
			table.insert(abilities,data)
		end
		if #abilities==0 then return end
		--Sort targets based on total damage
		table.sort(abilities,BUI.Stats.SortDamage)
		local highest=abilities[1].damage
		--Get total damage for the target
		local tarTotal=0
		local targets=BUI.Stats[realcontext.."Targets"]
		for _,data in pairs(targets) do if (data.name==target) then tarTotal=data.damage end end
		--Setup the display of abilities
		local anchor={TOP,container.list,TOP,0,0}
--		local Element={"Generic","Physical","Fire","Shock","Oblivion","Cold","Earth","Magic","Drown","Diesease","Poison"} Element[0]="None"
		local ElementColor={"|c888888","|cbbbbbb","|cbb3333","|cffffff","|c888888","|cbbbbff","|cbbbb33","|c5555ff","|c888888","|cbb33bb","|c33bb33"} ElementColor[0]="|cbbbb55"
		local PowerColor={[POWERTYPE_HEALTH]="|cbb3333",[POWERTYPE_MAGICKA]="|c5555ff",[POWERTYPE_STAMINA]="|c33bb33",[POWERTYPE_ULTIMATE]="|cbbbb33"}
		for i=1,#abilities do
			--Get the ability
			local name	=abilities[i].name
			local id	=abilities[i].id
			local data	=Report[context][target][name]
			--Get a control from the pool
			local control,objectKey=BUI.Stats.AbilityPool:AcquireObject()
			control.id=objectKey
			--Compute data
--			local fighttime	=math.max(zo_round((Report.endTime-Report.startTime)/10)/100,1)
			local fighttime	=math.max((Report.endTime-Report.startTime)/1000,1)
			local crit	=math.floor(data.crit*100/data.count+.45)
			local pct	=data.total*100/tarTotal
			local c_color	=(Report.crit and Report.crit[mainpower] and Report.crit[mainpower]<crit) and "|c"..BUI.ColorString(.6+(crit-Report.crit[mainpower])/90,.5,.5,1) or "|cAAAAAA"
			local icon	=AbilityIcons[id] or GetAbilityIcon(id)
			--Set data
			control.icon:SetTexture(icon)
			control.bg:SetWidth(control.name:GetWidth()*(data.total/highest))
			local color=(context=="Power") and PowerColor[data.powerType] or ElementColor[data.damageType] color=color or "|c888888"
			local descr=(BUI.Vars.DeveloperMode and "["..id.."] " or "")..color..zo_strformat("<<!aC:1>>",name)..abilities[i].source
			control.name:SetText(descr)
			control.total:SetText((context~="Power") and BUI.DisplayNumber(data.total).." |cAAAAAA("..BUI.DisplayNumber(pct,1).."%)|r" or BUI.DisplayNumber(data.total))
			control.dps:SetText(BUI.DisplayNumber(data.total/fighttime,0))
			control.count:SetText((context~="Power") and (data.crit>0 and "|cbb3333"..data.crit.."|cAAAAAA/|r" or "")..data.count or data.count)
			control.crit:SetText((context~="Power" and crit~=0) and c_color..crit.."%|r" or "")
			control.avg:SetText(BUI.DisplayNumber(data.total/data.count))
			--control.min:SetText(BUI.DisplayNumber(data.min))
			control.max:SetText(BUI.DisplayNumber(data.max))
			control.post:SetHidden(true)
			--Uptime
			if control.perc then
				local up=0
				if realcontext=="Damage" then up=GetAbilityUptime(id,name,target) end
				control.perc:SetText((realcontext=="Damage" and up>0) and "|cAAAAAA"..up.."%|r" or "")
			end
			--Set Anchors
			control:ClearAnchors() control:SetAnchor(unpack(anchor))
			anchor={TOP,control,BOTTOM,0,3*s}
			control:SetHidden(false)
		end

		--Modify header labels
		container.header.name:SetText(BUI.Loc("Ability"))
		--container.header.uses
		container.header.total:SetText((context=="Damage") and BUI.Loc("Damage") or (context=="Healing") and BUI.Loc("Healing") or BUI.Loc("Power"))
		container.header.dps:SetText((context=="Damage") and BUI.Loc("DPS") or (context=="Healing") and "HPS" or "RPS")
		container.header.count:SetText(BUI.Loc("Hit"))
		container.header.crit:SetText(BUI.Loc("Crit"))
		container.header.avg:SetText(BUI.Loc("Average"))
		container.header.max:SetText(BUI.Loc("Max"))
		if container.header.perc then container.header.perc:SetText("Up") end
		--Expand the parent container
		parent:SetHeight((math.min(#abilities,14)+2)*(fs*1.5+3))
		container:ClearAnchors()
		container:SetAnchor(TOP,parent,TOP,0,(fs*1.5)*s)
		container:SetHidden(false)
		container.content:SetHeight(math.min(#abilities,14)*(fs*1.5+3))
		container.list:SetHeight(#abilities*(fs*1.5+3))
		--Restore the button state
		self:SetState(BSTATE_PRESSED)
		parent.state="expanded"
	else
		CollapseAll()
	end
	if realcontext~="Incoming" then CharacterSummary(target) end
	--Resizing
	local bottom=BUI_Report_Title:GetBottom()
	for _,control in pairs(BUI.Stats.TargetPool.m_Active) do bottom=math.max(bottom,control:GetBottom()) end
	if BUI.Vars.StatsBuffs then
		bottom=math.max(bottom,math.min(BUI_Report_BuffsUp_Names:GetBottom(),BUI_Report_BuffsUp_Content:GetTop()+17*fs*1.335))
		bottom=math.max(bottom,math.min(parent.d.names:GetBottom(),parent.d.content:GetTop()+17*fs*1.335))
		BUI_Report_BuffsUp_Content:SetHeight((bottom-BUI_Report_BuffsUp_Content:GetTop())/s)
		parent.d.content:SetHeight((bottom-parent.d.content:GetTop())/s)
	end
	local h=(bottom-BUI_Report:GetTop())/s
	BUI_Report:SetHeight(h+26)
	BUI_Report.expanded=parent
end

function BUI.Stats.SetupGroupReport()	--Setup group report
	BUI.Stats.TargetPool:ReleaseAllObjects()
	local Report=BUI.Stats.Current[ReportToShow] if not Report then return end
	--HeaderButtons
	ResetHeaderButtons() BUI_Report_Gbutton:SetState(BSTATE_DISABLED)
	LastSection="Group"
	--Hide some elements
	if BUI_Report_Uptimes and not BUI_Report_Uptimes:IsHidden() then
		BUI_Report_Uptimes:SetHidden(true)
		BUI_Report_Ubutton:SetTextureRotation(0)
	end
	BUI_Report_Ubutton_Base:SetHidden(true)
	BUI_Report_Ability:SetHidden(true)
	TogleBuffsSection()
	local GroupData=Report.GroupDPS if not GroupData or not GroupData.Total then BUI_Report_Title:SetText(BUI.Loc("NoDamage")) BUI_Report:SetHeight(200) return end
	local roles={["Damage"]="/esoui/art/lfg/gamepad/lfg_roleicon_dps.dds",["Tank"]="/esoui/art/lfg/gamepad/lfg_roleicon_tank.dds",["Healer"]="/esoui/art/lfg/gamepad/lfg_roleicon_healer.dds"}
	local fs,s=BUI.Vars.StatsFontSize,1	--BUI.Vars.ReportScale
	local container=BUI_Report_Ability
	--Release existing objects
	BUI.Stats.AbilityPool:ReleaseAllObjects()
	--Prepare total data
	local fighttime=GroupData.Total.time
	local GroupDPS=GroupData.Total.dps
	local TotalDmg=GroupData.Total.damage or GroupData.Total.dps*GroupData.Total.time
	--Sort members based on total damage
	local members,death_table={},{}
	for name,data in pairs(GroupData) do table.insert(members,{name=name,damage=data.dps and data.dps*data.time or 0}) end
	table.sort(members,BUI.Stats.SortDamage)
	local highest=members[2] and members[2].damage or 100
	--Loop over members
	local anchor={TOP,container.list,TOP,0,0}
	for i=1,#members do
		local name		=members[i].name
		local damage	=members[i].damage
		local role		=GroupData[name].role
		local icon		=name=="Total" and '/esoui/art/lfg/gamepad/gp_lfg_icon_groupsize.dds' or (roles[role] and roles[role] or '/esoui/art/icons/icon_missing.dds')
--		local average	=GroupData[name].average or " "
		local dps		=GroupData[name].dps or 0
		local time		=GroupData[name].time or 0
		local pct		=math.min(math.floor(damage/TotalDmg*100),100)
		local death		=GroupData[name].death
		if death then table.insert(death_table,{name=name, death=GroupData[name].death}) end
--		local hide		=average=="~" and role~=LFG_ROLE_DPS
		--Get a control from the pool
		local control,objectKey=BUI.Stats.AbilityPool:AcquireObject() control.id=objectKey
		--Set data
		control.bg:SetWidth(control.name:GetWidth()*(name=="Total" and 0 or damage/highest))
		control.icon:SetTexture(icon)
		control.name:SetText(name)
		control.count:SetText(death or "")
		control.total:SetText(damage>0 and BUI.DisplayNumber(damage) or "")
		control.dps:SetText(dps>0 and BUI.DisplayNumber(dps) or "")
		control.crit:SetText((name~="Total" and pct>0) and "|cAAAAAA"..pct.."%" or "")
		control.avg:SetText(time>0 and ZO_FormatTime(time,SI_TIME_FORMAT_TIMESTAMP) or "")
		control.max:SetText("")
		control.post:SetHidden(dps==0)
		if control.perc then control.perc:SetText("") end
		--Death total
		if name=="Total" then
			local post=BUI.UI.Button("BUI_Report_PostDeathTotal", control.count, {fs*1.5,fs*1.5}, {CENTER,CENTER,0,0}, BSTATE_NORMAL)
			post:SetNormalTexture('/esoui/art/chatwindow/chat_notification_up.dds')
			post:SetMouseOverTexture('/esoui/art/chatwindow/chat_notification_over.dds')
			post:SetDisabledTexture('/esoui/art/chatwindow/chat_notification_disabled.dds')
		end
		--Set Anchors
		control:ClearAnchors() control:SetAnchor(unpack(anchor))
		anchor={TOP,control,BOTTOM,0,3*s}
		control:SetHidden(false)
	end
	--Death total
	if #death_table>0 then
		table.sort(death_table, function(x,y) return (x.death>y.death) end)
		local text=""
		for i=1,#death_table do
			if text~="" then text=text..", " end
			text=text..death_table[i].name..": "..death_table[i].death
		end
		BUI_Report_PostDeathTotal:SetHandler("OnClicked", function(self)StartChatInput("/p Group deaths: "..text)end)
	end
	--Modify header labels
	container.header.name:SetText("Group member")
--	container.header.uses
	container.header.count:SetText("Death")	--BUI.Loc("Hit")
	container.header.total:SetText(BUI.Loc("Damage"))
	container.header.dps:SetText(BUI.Loc("DPS"))
	container.header.crit:SetText("%")	--BUI.Loc("Crit")
	container.header.avg:SetText(BUI.Loc("ReportTimeHeader"))	--BUI.Loc("Average")
	container.header.max:SetText("")	--BUI.Loc("Max")
	if container.header.perc then container.header.perc:SetText("") end
	--Expand the parent container
	local parent=_G["BUI_Report_Title"]
--	parent:SetHeight((math.min(#members,12)+2)*(fs*1.5+3))
	container:ClearAnchors()
	container:SetAnchor(TOP,parent,TOP,0,fs*1.5)
	container:SetHidden(false)
	container.content:SetHeight(math.min(#members,11)*(fs*1.5+3)/s)
	container.list:SetHeight(#members*(fs*1.5+3)/s)
	--Resizing
	local h=(container.content:GetBottom()-BUI_Report:GetTop())/s
	BUI_Report:SetHeight(h+30)
--	BUI_Report_Backdrop:SetHeight(h+26)
--	BUI_Report_Border:SetHeight(h+2-30)
	--Retreive primary target
	targets={}
	for target,abilities in pairs(Report.Damage) do
		local damage,bosscount=0,0
		for _,stats in pairs(abilities) do damage=damage+stats.total end
		if target~="Total" and target~=Report.Char then
			if BUI.Stats.Bosses[target] or (Report.Boss and Report.Boss[target]) then bosscount=bosscount+1 target=target.." ("..BUI.Loc("Boss")..")" end
			table.insert(targets,{name=target,damage=damage})
		end
	end
	table.sort(targets,BUI.Stats.SortDamage)
	--Modify headers
	if #targets>0 then BUI_Report_Title:SetText(targets[1].name..(#targets>1 and "+"..#targets-1 or "")) end
end

function BUI.Stats.SortDamage(x,y)
	if (x.name=="Total") then return true
	elseif (y.name=="Total") then return false
	else return x.damage>y.damage end
end

local function SetupStatsCurrent(n,now)
	now=now or GetGameTimeMilliseconds()
	local date=GetDate() date=" "..string.sub(date,7,8).."."..string.sub(date,5,6).."."..string.sub(date,1,4)
	BUI.Stats.Current[n]={
		Ability	={w=(BUI.Stats.LastSlot==1 and 1 or 0),a=(BUI.Stats.LastSlot~=1 and 1 or 0)},
		Damage	={Total={}},
		Healing	={Total={}},
		Power		={Total={}},
		damage	=0,
		healing	=0,
		power		=0,
		startTime	=now,
		endTime	=now,
		PlayerBuffs	={},
		TargetBuffs	={},
		Uptimes	={},
		Boss		={},
		GroupDPS	={},
		--Character info
		Char		=BUI.Player.name,
		Acc			=BUI.Player.accname,
		Level		=BUI.Player:GetColoredLevel("player"),
		Class		=GetUnitClassId("player"),
		ESOVersion	=BUI.ESOVersion..date,
		--Attributes
		health	=BUI.Player["health"].max,
		stamina	=BUI.Player["stamina"].max,
		magicka	=BUI.Player["magicka"].max,
		penetr	={own={["stamina"]=GetPlayerStat(STAT_PHYSICAL_PENETRATION),["magicka"]=GetPlayerStat(STAT_SPELL_PENETRATION)}},
		damagepower	={["stamina"]=GetPlayerStat(STAT_POWER),["magicka"]=GetPlayerStat(STAT_SPELL_POWER)},
		crit		={["stamina"]=(math.floor(GetPlayerStat(STAT_CRITICAL_STRIKE)/219*10)+.5)/10,["magicka"]=(math.floor(GetPlayerStat(STAT_SPELL_CRITICAL)/219*10)+.5)/10}
	}
end

function BUI.Stats.Reset(now)
	now=now or GetGameTimeMilliseconds()
	--Save bosses names
	if BUI.Stats.Current[BUI.ReportN] then
		for target in pairs(BUI.Stats.Current[BUI.ReportN].Damage) do
			if BUI.Stats.Bosses[zo_strformat("<<!aC:1>>",target)] then
				BUI.Stats.Current[BUI.ReportN].Boss[target]=true
			end
		end
	end
	--Cloudrest
	BUI.Cloudrest.Plus=0; BUI.Cloudrest.Group=0
	--Group DPS frame
	if BUI_GroupDPS then BUI_GroupDPS:SetHidden(true) end
	--Initialize new report
	if	BUI.Stats.Current[BUI.ReportN] and BUI.Stats.Current[BUI.ReportN].endTime-BUI.Stats.Current[BUI.ReportN].startTime>=10000
--	or	BUI.Stats.RevivedTime>BUI.Stats.Current[BUI.ReportN].startTime
	then
		BUI.ReportN=BUI.ReportN+1
--		if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."New report ("..BUI.ReportN..") initialized") end
	end
	--Setup variables
--	BUI.Stats.RevivedTime	=now
	BUI.Stats.lastPing	=0
	BUI.Stats.CombatEnd	=false
	BUI.Stats.GroupLog	={Damage={Total=0},Healing={Total=0}}
	--Setup main table
	SetupStatsCurrent(BUI.ReportN,now)
end

--[[function BUI.Stats.SaveBuffs()
	local now=GetGameTimeMilliseconds()
	if BUI.Stats.Current[BUI.ReportN].PlayerBuffs then
		for i in pairs(BUI.Stats.Current[BUI.ReportN].PlayerBuffs) do
			if BUI.Stats.Current[BUI.ReportN].PlayerBuffs[i].timeEnding>now then BUI.Stats.Current[BUI.ReportN].PlayerBuffs[i].timeEnding=now end
		end
	end
	if BUI.Stats.Current[BUI.ReportN].TargetBuffs then
--		local j=0
		for target in pairs(BUI.Stats.Current[BUI.ReportN].TargetBuffs) do
			for i in pairs(BUI.Stats.Current[BUI.ReportN].TargetBuffs[target]) do
				if BUI.Stats.Current[BUI.ReportN].TargetBuffs[target][i].timeEnding>now then BUI.Stats.Current[BUI.ReportN].TargetBuffs[target][i].timeEnding=now end
			end
--		j=j+1
		end
--		if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."Buffs for "..j.." targets are saved") end
	end
end--]]

function BUI.Stats.SaveReport()		--Save
	local slot=1 for i in pairs(BUI.Reports.data) do if i+1>slot then slot=i+1 end end
	BUI.Reports.data[slot]={}
	BUI:JoinTables(BUI.Reports.data[slot],BUI.Stats.Current[ReportToShow])
	BUI.Stats.Current[ReportToShow].Saved=slot
	BUI_Report_Save:SetDisabled(true)
	a("Report "..ReportToShow.." is saved")
end

function BUI.Stats.ClearReport(n)		--Del
	if BUI.Stats.Current[n].Saved then a("Report "..n.." was deleted") BUI.Reports.data[BUI.Stats.Current[n].Saved]=nil end
	SetupStatsCurrent(n)
	BUI.Stats.NextReport(true)
end
--	/script for i,data in pairs(BUI.Reports.data) do d("["..i.."] "..data.Char..": "..math.floor(data.damage/(data.endTime-data.startTime)).." DPS")end
function BUI.Stats.Initialize(disable)	--Init
	BUI.Stats.Bosses		={}
	if not disable and BUI.Vars.EnableStats then
		--Setup tables
		if not BUI.init.StatsTable then
			BUI.Stats.groupDPS={}
			BUI.Stats.Current	={}
			local t={}
			for i,data in pairs(BUI.Reports.data) do table.insert(t,i) end
			table.sort(t,function(x,y)return x<y end)
			for i=1,#t do table.insert(BUI.Stats.Current,BUI.Reports.data[ t[i] ]) local n=#BUI.Stats.Current BUI.Stats.Current[n].Saved=i end
			BUI.ReportN=#BUI.Stats.Current+1
			BUI.Stats.Reset()
			BUI.Stats.CombatEnd	=true
			BUI.init.StatsTable	=true
		end
		--Create the controls
		BUI.Stats.Analistics_Init()
		if BUI.Vars.StatsGroupDPSframe then BUI.Stats.GroupDPS_Init() end
--		if BUI.Vars.DeveloperMode then BUI.Stats:Targets_Init() BUI.Stats:BuffsUp_Init() end
		--MiniMeter
		if BUI.Vars.StatsMiniMeter then
			BUI.Stats.Minimeter_Init()
			EVENT_MANAGER:RegisterForUpdate("BUI_MiniMeter",500,BUI.Stats.Update)
		elseif BUI_MiniMeter then
			BUI_MiniMeter:SetHidden(true)
			EVENT_MANAGER:UnregisterForUpdate("BUI_MiniMeter")
		end
		--ShareDPS
		if BUI.Vars.StatsUpdateDPS then
			EVENT_MANAGER:RegisterForUpdate("BUI_ShareDPS",2500,function() if BUI.inCombat then BUI.Stats.SendPing() end end)
		else
			EVENT_MANAGER:UnregisterForUpdate("BUI_ShareDPS")
		end
		BUI.init.Stats		=true
		return true
	else
		if BUI_MiniMeter then
			BUI_MiniMeter:SetHidden(true)
			EVENT_MANAGER:UnregisterForUpdate("BUI_MiniMeter")
		end
		EVENT_MANAGER:UnregisterForUpdate("BUI_ShareDPS")
		BUI.init.Stats		=false
		if BUI.Vars.EnableStats then return false end
	end
end

function BUI.Stats.RegisterDamage(damage)
	--Don't register anything if the player is out of combat
	if not BUI.inCombat and (damage.heal or damage.power) then return end
--	if (damage.heal and BUI.Vars.StatTriggerHeals==false) then return end
	if BUI.Stats.CombatEnd and damage.ms-BUI.Stats.Current[BUI.ReportN].endTime>DamageTimeout then BUI.Stats.Reset(damage.ms) end	--else BUI.Stats.CombatEnd=false end
	--Add damage value to tracker
	if damage.heal then
		BUI.Stats.Current[BUI.ReportN].healing=BUI.Stats.Current[BUI.ReportN].healing+damage.value
	elseif damage.power then
		BUI.Stats.Current[BUI.ReportN].power=BUI.Stats.Current[BUI.ReportN].power+damage.value
	elseif damage.target~=BUI.Player.name then
		BUI.Stats.Current[BUI.ReportN].damage=BUI.Stats.Current[BUI.ReportN].damage+damage.value
	end
	--Flag the time
	if (not damage.heal or BUI.Vars.StatTriggerHeals) and not damage.power and BUI.inCombat then
		BUI.Stats.Current[BUI.ReportN].endTime=damage.ms
	end
	--Get the tables
	local data=(damage.heal) and BUI.Stats.Current[BUI.ReportN].Healing or (damage.power) and BUI.Stats.Current[BUI.ReportN].Power or BUI.Stats.Current[BUI.ReportN].Damage
	--Setup some placeholder data
	local ability=damage.ability
	--Add data to total
	if damage.out and damage.power==false then
		if (data.Total[ability]==nil) then
			data.Total[ability]={
				['total']		=damage.value,
				['count']		=1,
				['crit']		=damage.crit and 1 or 0,
				['max']		=damage.value,
				['min']		=damage.value,
				["damageType"]	=damage.damageType,
				["id"]		=damage.id,
			}
		--Update existing ability
		else
			data.Total[ability].total=data.Total[ability].total+damage.value
			data.Total[ability].count=data.Total[ability].count+1
			data.Total[ability].crit=data.Total[ability].crit+(damage.crit and 1 or 0)
			data.Total[ability].max=math.max(damage.value,data.Total[ability].max)
			data.Total[ability].min=math.min(damage.value,data.Total[ability].min)
		end
	end
	--Maybe set up new target
	local target=damage.target
	if (data[target]==nil) then data[target]={} end
	--Add new ability to target
	if (data[target][ability]==nil) then
		data[target][ability]={
			['total']		=damage.value,
			['count']		=1,
			['crit']		=damage.crit and 1 or 0,
			['max']		=damage.value,
			['min']		=damage.value,
			['dot']		=damage.dot,
			["damageType"]	=damage.damageType,
			["id"]		=damage.id,
			["source"]		=damage.source,
			["powerType"]	=damage.powerType,
		}
	--Update existing ability
	else
		data[target][ability].total=data[target][ability].total+damage.value
		data[target][ability].count=data[target][ability].count+1
		data[target][ability].crit=data[target][ability].crit+(damage.crit and 1 or 0)
		data[target][ability].max=math.max(damage.value,data[target][ability].max)
		data[target][ability].min=math.min(damage.value,data[target][ability].min)
	end
end

function BUI.Stats.Update()
	--Bail out if there is no damage to report
	if (BUI.Stats.Current[BUI.ReportN].damage==0 and BUI.Stats.Current[BUI.ReportN].healing==0) then return end
	--Retrieve data
	local mini	=_G["BUI_MiniMeter"]
	--Compute the fight time
--	local fighttime=math.max(zo_round((BUI.Stats.Current[BUI.ReportN].endTime-BUI.Stats.Current[BUI.ReportN].startTime)/10)/100,1)
	local fighttime=math.max((BUI.Stats.Current[BUI.ReportN].endTime-BUI.Stats.Current[BUI.ReportN].startTime)/1000,1)
	--Compute player statistics
	local dps	=BUI.Stats.Current[BUI.ReportN].damage/fighttime
	local hps	=BUI.Stats.Current[BUI.ReportN].healing/fighttime
	--Compute group statistics
	local gdps	=BUI.Stats.GroupLog.Damage.Total/fighttime
	local ghps	=BUI.Stats.GroupLog.Healing.Total/fighttime
	--Update the labels
	mini.damage.label:SetText(BUI.DisplayNumber(dps)..(gdps~=0 and "|cAAAAAA ("..math.min(math.floor(dps/gdps*100),100).."%)|r" or ""))
	if BUI.Vars.StatsMiniHealing then mini.healing.label:SetText(BUI.DisplayNumber(hps)..((BUI.InGroup and ghps~=0) and "|cAAAAAA ("..math.min(math.floor(hps/ghps*100),100).."%)|r" or "")) end
	if BUI.Vars.StatsMiniGroupDps then mini.GroupDps.label:SetText(BUI.DisplayNumber(gdps)) end
	if BUI.Vars.StatsMiniSpeed then mini.speed.label:SetText(math.min(math.floor(BUI.Stats.Current[BUI.ReportN].Ability.a/fighttime*100),100).."|cAAAAAA%|r") end
	mini.time.label:SetText(ZO_FormatTime(fighttime,SI_TIME_FORMAT_TIMESTAMP))
	if BUI.Vars.ReticleDpS then BUI_ReticleDpS:SetText(GetGameTimeMilliseconds()-BUI.Stats.Current[BUI.ReportN].endTime<5000 and math.floor(dps/1000).."K" or "") end
end

function BUI.Stats.Post(self,button)
	local context,UnitName,units,damage,bossDamage,bossUnits,fighttime="Damage",nil,0,0,0,0,0
	if button~=nil then	--Specific target requested
		if (BUI.Stats.Current[ReportToShow].damage+BUI.Stats.Current[ReportToShow].healing==0) then d(BUI.Loc("NoDamageToReport")) return end
		--Get data
		local parent	=self:GetParent()
		context		=parent.context
		local Targets	=BUI.Stats[context.."Targets"]
		for i=1,#Targets do if (Targets[i].name==parent.target) then damage=Targets[i].damage end end
		UnitName=(parent.target~="Total") and parent.target or nil
	else		--Otherwise assume total
		ReportToShow=BUI.ReportN
		if (BUI.Stats.Current[ReportToShow].damage+BUI.Stats.Current[ReportToShow].healing==0) then d(BUI.Loc("NoDamageToReport")) return end
		damage=BUI.Stats.Current[ReportToShow].damage
	end
	--Maybe compute the most damaged target
	if UnitName==nil then
		local targets={}
		for target,abilities in pairs(BUI.Stats.Current[ReportToShow].Damage) do
			--Calculate total damage dealt to target
			if target~=BUI.Player.name then
				local damage=0
				for ability,stats in pairs(abilities) do
					damage=damage+stats.total
				end
				--Setup some data
				local data={
					["name"]	=target,
					["damage"]	=damage,
				}
				--Add the target to an index table
				table.insert(targets,data)
				--Calculate bosses
--				d(zo_strformat("<<!aC:1>>",target).." Is Boss: "..tostring(BUI.Stats.Bosses[zo_strformat("<<!aC:1>>",target)]))
				if BUI.Stats.Bosses[zo_strformat("<<!aC:1>>",target)] then
					bossUnits=bossUnits+1
					bossDamage=bossDamage+damage
				end
			end
		end
		--Sort targets based on total damage
		table.sort(targets,BUI.Stats.SortDamage)
--		UnitName	=(#targets>2) and targets[2].name .. " (+" .. (#targets-2) .. ")" or targets[2].name
		UnitName	=zo_strformat("<<!aC:1>>",targets[2].name)
		units		=#targets-2
	end
--	fighttime=math.max(zo_round((BUI.Stats.Current[ReportToShow].endTime-BUI.Stats.Current[ReportToShow].startTime)/10)/100,1)
	fighttime=math.max((BUI.Stats.Current[ReportToShow].endTime-BUI.Stats.Current[ReportToShow].startTime)/1000,1)
	--Minimize the report if it is shown
--	if (not BUI_Report:IsHidden()) then BUI.Stats.Toggle() end
	if BUI.Stats.Bosses[UnitName] then UnitName=UnitName.."(Boss)" end
	local dpsLabel	=(context=="Damage") and "DPS" or "HPS"
	local bossDPS	=BUI.DisplayNumber(bossDamage/fighttime,2)	bossDamage	=BUI.DisplayNumber(bossDamage)
	local bossString	=(bossUnits>0) and "Boss DPS" or "DPS"
	local timeString	=ZO_FormatTime(fighttime,SI_TIME_FORMAT_TIMESTAMP)
	local totalDamage	=BUI.DisplayNumber(damage)
	local totalDPS	=BUI.DisplayNumber(damage/fighttime,2)
	local unitsString	=(units>0) and " (+"..units..")" or ""
	--Generate output
	local output	=string.format("%s (%s) - Total %s%s: %s (%s Damage)", UnitName, timeString, dpsLabel, unitsString, totalDPS, totalDamage)
	if bossUnits>0 then output=output..string.format(", %s: %s (%s Damage)", bossString, bossDPS, bossDamage) end
	--Determine appropriate channel
	local channel=""	--IsUnitGrouped('player') and "/p " or "/say "
	--Print output to chat
	CHAT_SYSTEM.textEntry:SetText(channel..output)
	CHAT_SYSTEM:Maximize() CHAT_SYSTEM.textEntry:Open() CHAT_SYSTEM.primaryContainer:FadeIn()
end

local function GroupDPS_Fade(frame)
	local function FadeControl(control)
		--Fade in
		if control.fadeIn==nil then
			local animation, timeline=CreateSimpleAnimation(ANIMATION_ALPHA,control,0)
			animation:SetAlphaValues(0,1)
			animation:SetEasingFunction(ZO_EaseInQuadratic)
			animation:SetDuration(500)
			timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
			control.fadeIn=timeline
		end
		--Fade Out
		if control.fadeOut==nil then
			local animation, timeline=CreateSimpleAnimation(ANIMATION_ALPHA,control,15000)
			animation:SetAlphaValues(1,0)
			animation:SetEasingFunction(ZO_EaseInQuadratic)
			animation:SetDuration(1000)
			timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
			control.fadeOut=timeline
		end
		control.fadeOut:Stop()
		if control:GetAlpha()<1 then control.fadeIn:PlayFromStart() end
		control.fadeOut:PlayFromStart()
	end

	if frame then FadeControl(frame) return end
	for i=1, BUI.Group.members do
		local unitTag=GetGroupUnitTagByIndex(i)
		if DoesUnitExist(unitTag) then
			local control=_G["BUI_RaidFrame"..i.."_DPS"]
			if control then FadeControl(control) end
		end
	end
--	if BUI.Vars.StatsGroupDPSframe then FadeControl(BUI_GroupDPS) end
end

local function GroupDPS_Frame(now)
	local t={}
	for _,data in pairs(BUI.Stats.groupDPS) do
		if data.ms+10000>now and data.dps>4000 and #t<8 then table.insert(t,{accname=data.accname,dps=data.dps,time=data.time}) end
	end
	table.sort(t,function(x,y)return x.dps>y.dps end)
	local names,values="",""
	if BUI.BossFight or (BUI.BossKilledMs or 0)+10000>now then
		local gdps	=BUI.Stats.GroupLog.Damage.Total/math.max((BUI.Stats.Current[BUI.ReportN].endTime-BUI.Stats.Current[BUI.ReportN].startTime)/1000,1)
		names="  |cEE3333"..string.sub(tostring(BUI.BossName),0,12).."|r\n" values=BUI.DisplayNumber(gdps).."\n"
	end
	for i,data in ipairs(t) do
		names=names..(data.accname==BUI.Player.accname and "|c22FF22" or "")..string.sub(data.accname,0,12).."|r\n"
		values=values..BUI.DisplayNumber(data.dps).."\n"
	end
	BUI_GroupDPS_Names:SetText(names)
	BUI_GroupDPS_Value:SetText(values)
--	GroupDPS_Fade(BUI_GroupDPS)
	BUI_GroupDPS:SetHidden(false)
end

function BUI.Stats.SendPing()
	if not BUI.Vars.StatsShareDPS or not BUI.InGroup then return end
	--Don't ping without damage
	if BUI.Stats.Current[BUI.ReportN].damage==0 then return end
	--Don't spam ping
--	if BUI.Stats.lastPing+450>BUI.Stats.Current[BUI.ReportN].endTime then return end
	--Compute player statistics
	local fighttime	=math.max(zo_round((BUI.Stats.Current[BUI.ReportN].endTime-BUI.Stats.Current[BUI.ReportN].startTime)/10)/100,1)
	local dps		=BUI.Stats.Current[BUI.ReportN].damage/fighttime
	--Don't ping fights less than 10 seconds
	if fighttime<10 or dps<500 then return end
	--Send the ping
	SetMapToPlayerLocation()
	BUI.PingMap(MAP_PIN_TYPE_PING,MAP_TYPE_LOCATION_CENTERED,StatShare_Code/100+fighttime/100000,dps/200000)
	BUI.Stats.lastPing=BUI.Stats.Current[BUI.ReportN].endTime
--[[	--Ping confirmation
	PingConfirmed=2
	local function PingConfirmation()
		if PingConfirmed>0 then
			PingConfirmed=PingConfirmed-1
			if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."|cEE2222Ping was not confirmed! Resending...|r") end
			BUI.PingMap(MAP_PIN_TYPE_PING,MAP_TYPE_LOCATION_CENTERED,StatShare_Code/100+fighttime/10000,dps/200000)
			BUI.CallLater("PingConfirmation",500,PingConfirmation)
		elseif BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."Ping was confirmed")
		end
	end
	BUI.CallLater("PingConfirmation",500,PingConfirmation)
--]]
end

function BUI.Stats.AddPing(offsetX,offsetY,pingTag,isOwner)
	if not BUI.Vars.StatsShareDPS then return end
	--Ignore ping terminations
--	local code=math.floor(offsetX*100) if isOwner and code~=76 then d("Code: "..code.." Time: "..offsetX*100000-StatShare_Code*1000) end
	if offsetX==0 or offsetY==0 or math.floor(offsetX*100)~=StatShare_Code then return false end
	--Get data
--	local name		=GetUnitName(pingTag)
	local accname	=BUI.Group[pingTag] and BUI.Group[pingTag].accname or GetUnitDisplayName(pingTag)
	local time		=offsetX*100000-StatShare_Code*1000
	local dps		=offsetY*200000
	local damage	=dps*time
	--Only accept pings within a reasonable range
	if dps<500 or dps>200000 or time<10 or time>1200 then return true end
--	if isOwner then PingConfirmed=0 return true end
	local now=GetGameTimeMilliseconds()
	--Log
	if BUI.Vars.Log then
		table.insert(BUI.Log,{now,accname,"","DPS: "..math.floor(dps).." ("..ZO_FormatTime(time,SI_TIME_FORMAT_TIMESTAMP)..")",100})
	end
	--Populate data
	BUI.Stats.groupDPS[accname]={
		["accname"]	=accname,
		["damage"]	=damage,
		["dps"]	=dps,
		["time"]	=time,
		["ms"]	=now,
	}
	--Remember for report
	if not BUI.Stats.Current[BUI.ReportN].GroupDPS[accname] then BUI.Stats.Current[BUI.ReportN].GroupDPS[accname]={} end
	BUI.Stats.Current[BUI.ReportN].GroupDPS[accname].dps=dps
	BUI.Stats.Current[BUI.ReportN].GroupDPS[accname].time=time
	BUI.Stats.Current[BUI.ReportN].GroupDPS[accname].role=BUI.Group[pingTag] and BUI.Group[pingTag].role or nil
	--Display control
	if BUI.Vars.StatsGroupDPS and BUI.Vars.RaidFrames then
		BUI.Group[pingTag].frame.health.dps:SetAlpha(1)
		BUI.Group[pingTag].frame.health.dps:SetText("DPS: "..BUI.DisplayNumber(dps).." "..ZO_FormatTime(time,SI_TIME_FORMAT_TIMESTAMP))
	end
	if now>BUI.Stats.Current[BUI.ReportN].endTime+10000 then
--		if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."Received DPS from "..(BUI.Group[pingTag] and BUI.Group[pingTag].name or "").."("..name.."): "..math.floor(dps).." ("..ZO_FormatTime(time,SI_TIME_FORMAT_TIMESTAMP)..")".." delta: "..ZO_FormatTime((now-BUI.Stats.Current[BUI.ReportN].endTime)/1000,SI_TIME_FORMAT_TIMESTAMP)) end
		return true
	end
	if BUI.InGroup and BUI.Vars.StatsGroupDPSframe then GroupDPS_Frame(now) end
--	if not BUI.inCombat then BUI.Stats.DisplayGroupDPS() end
	return true
end

function BUI.Stats.DisplayGroupDPS()
	local fighttime=0
	for accname,info in pairs(BUI.Stats.groupDPS) do
		if info.ms<BUI.Stats.Current[BUI.ReportN].startTime then
			--Throw out any entries from previous fights
			BUI.Stats.groupDPS[accname]=nil
		else
			--Calculate longest figt time
			fighttime=(fighttime<info.time) and info.time or fighttime
		end
	end
	--Add own dps
	if BUI.Stats.Current[BUI.ReportN].damage>10000 then
		local fighttime=math.max(zo_round((BUI.Stats.Current[BUI.ReportN].endTime-BUI.Stats.Current[BUI.ReportN].startTime)/10)/100,1)
		if fighttime>=10 then
			BUI.Stats.groupDPS[BUI.Player.accname]={
				["accname"]	=BUI.Player.accname,
				["damage"]	=BUI.Stats.Current[BUI.ReportN].damage,
				["dps"]	=BUI.Stats.Current[BUI.ReportN].damage/fighttime,
				["time"]	=fighttime,
				["ms"]	=BUI.Stats.Current[BUI.ReportN].endTime
				}
		end
	else
--		if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."No own dps!") end
	end
	local stamp_placed
	if fighttime>0 then
		--Calculate Group dps
		local TotalDmg=BUI.Stats.GroupLog.Damage.Total
		local GroupDPS=TotalDmg/fighttime
		BUI.Stats.Current[BUI.ReportN].GroupDPS["Total"]={dps=GroupDPS,time=fighttime,damage=TotalDmg}
		for i=1,BUI.Group.members do
			local unitTag=GetGroupUnitTagByIndex(i)
			if DoesUnitExist(unitTag) then
				local accname=BUI.Group[unitTag] and BUI.Group[unitTag].accname or GetUnitDisplayName(unitTag)
				--Remember for report
				if not BUI.Stats.Current[BUI.ReportN].GroupDPS[accname] then BUI.Stats.Current[BUI.ReportN].GroupDPS[accname]={} end
				BUI.Stats.Current[BUI.ReportN].GroupDPS[accname].role=BUI.Group[accname] and BUI.Group[accname].role or nil
				BUI.Stats.Current[BUI.ReportN].GroupDPS[accname].death=BUI.Group[accname] and BUI.Group[accname].death or nil
				local info=BUI.Stats.groupDPS[accname]
				if info then
					BUI.Stats.Current[BUI.ReportN].GroupDPS[accname].dps=info.dps
					BUI.Stats.Current[BUI.ReportN].GroupDPS[accname].time=info.time
					info.dps_text=BUI.DisplayNumber(info.dps).." "..ZO_FormatTime(info.time,SI_TIME_FORMAT_TIMESTAMP)
					info.pct=math.floor(info.damage/TotalDmg*100)
					--Group frames DPS stamp
					if BUI.Vars.StatsGroupDPS and BUI.Vars.RaidFrames then
						if BUI.Group[unitTag] then BUI.Group[unitTag].frame.health.dps:SetText("DPS: "..info.dps_text) end
						stamp_placed=true
					end
				elseif BUI.Vars.RaidFrames then
					BUI_RaidFrame["group"..i].health.dps:SetText("")
				end
			end
		end
		--Prepare group DPS text
		BUI.GroupDPS_tip=""
		BUI.GroupDPS_text=""
		BUI.GroupDPS_tip="Group DPS: "..BUI.DisplayNumber(GroupDPS).." "..ZO_FormatTime(fighttime,SI_TIME_FORMAT_TIMESTAMP).." Total: "..BUI.DisplayNumber(TotalDmg)
		BUI.GroupDPS_text=" "..BUI.GroupDPS_tip..", "
		local roles={Damage="/esoui/art/lfg/gamepad/lfg_roleicon_dps.dds",Tank="/esoui/art/lfg/gamepad/lfg_roleicon_tank.dds",Healer="/esoui/art/lfg/gamepad/lfg_roleicon_healer.dds"}

		local data={}
		for accname,info in pairs(BUI.Stats.groupDPS) do table.insert(data,info) end
		--Sort in descending order
		table.sort(data,BUI.Stats.SortDamage)

		for _,info in ipairs(data) do
			if info.pct and info.pct>2 then
				BUI.GroupDPS_tip=BUI.GroupDPS_tip.."\n |t16:16:"..(roles[BUI.Group[info.accname] and BUI.Group[info.accname].role or "None"] or "").."|t"..tostring(info.accname)..": "..info.dps_text.." ("..info.pct.."%)"
				BUI.GroupDPS_text=BUI.GroupDPS_text..", "..tostring(info.accname)..": "..info.dps_text.." ("..info.pct.."%)"
			end
		end
	end
	--Fade animation
	if stamp_placed then GroupDPS_Fade() end
end

function BUI.Stats.PostGroupDPS()
	local data=BUI.Stats.groupDPS
	--Post to the group chat
	BUI.Stats.Msg("Group Damage results:")
	for i in pairs(data) do
		BUI.Stats.Msg(
			" DPS:" .. BUI.DisplayNumber(data[i].dps,0) ..
			" in "..ZO_FormatTime(data[i].time,SI_TIME_FORMAT_TIMESTAMP)..
			" - "..string.sub(zo_strformat("<<!aC:1>>",data[i].name),0,15)
			)
	end
end

function BUI.Stats.PostTargets()
	if BUI.Stats.GroupLog=={} then return end
	local Count,TotalDmg=0,0
	for target in pairs(BUI.Stats.GroupLog) do
		Count=Count+1
		TotalDmg=TotalDmg+BUI.Stats.GroupLog[target].dmg
		BUI.Stats.Msg("-"..BUI.Stats.GroupLog[target].name.." ("..target..") Damage="..BUI.Stats.GroupLog[target].dmg)
	end
	if Count>1 then BUI.Stats.Msg("->>TotalDamage="..TotalDmg) end
end

local AbilityDuration={
--	[39298]=5000,[42028]=5000,[42038]=5000,--Energy Orb
	[40465]=24000,--Scalding Rune
	[32792]=2500,[32785]=2500,--Inhale
	[22095]=20000,--Solar Barrage
	[39012]=14400,--Blockade
	[39053]=10600,--Unstable Wall
	[35750]=10000,[40372]=20000,[40382]=20000,--Trap
--	[23316]=8400,[30664]=8400,[30669]=8400,[30674]=8400,--Volatile Familiar
	[38669]=10000,--Draining Shot
	[117850]=10500,--Avid Boneyard
--	[38689]=9500,--Endless Hail
--	[40255]=14500,--Anti-Cavalry Caltrops
	[126941]=7000,--Maarselok
	[20252]=5000,--Burning Talons
	}
local AbilityArmTime={
	[35750]=1500,[40382]=1500,[40372]=1500,--Trap
	[40465]=2000,--Scalding Rune
	}
function BUI.GetAbilityDuration(id)
	local _sec=AbilityDuration[id] or GetAbilityDuration(id)
	if _sec<3000 then
		local _descr=GetAbilityDescription(id)
		local _start,_end=string.find(_descr,_seconds)
		if _start then
			local function GetDuration(descr,start)
				local sec=string.gsub(string.sub(descr,start-2,start-1),"f","")
				if string.sub(sec,1,1)=="." then sec=string.gsub(string.sub(descr,start-4,start-1),"f","") end
				return sec
			end
			_sec=GetDuration(_descr,_start)
			_descr=string.sub(_descr,_end)
			_start,_end=string.find(_descr,_seconds)
			local _sec1=_start and GetDuration(_descr,_start) or 0
			_sec=math.max((tonumber(_sec) or 0),(tonumber(_sec1) or 0))*1000
		end
	end
	local _,castTime,channelTime=GetAbilityCastInfo(id)
	local armTime=BUI.Vars.ActionsPrecise and AbilityArmTime[id] or 0
	return _sec,castTime+channelTime+armTime
end

function BUI.GetAbilityTickTime(id)
	local _descr=GetAbilityDescription(id)
	local _over=string.find(_descr," over |c")
	if _over then return 1 end
	local _start,_end=string.find(_descr," every |c")
	if _start then
		_sec=string.gsub(string.gsub(string.sub(_descr,_end+7,_end+9),"|",""),"r","")
		_descr=string.sub(_descr,_end)
		_start,_end=string.find(_descr," every |c")
		local _sec1=_start and string.gsub(string.gsub(string.sub(_descr,_end+7,_end+9),"|",""),"r","") or 0
		_sec=math.max((tonumber(_sec) or 0),(tonumber(_sec1) or 0))
		return _sec
	end
	return 0
end

function BUI.Stats.Msg(msg)
	if (CHAT_SYSTEM.primaryContainer) then CHAT_SYSTEM.primaryContainer:OnChatEvent(nil,msg,CHAT_CATEGORY_SYSTEM)
	else CHAT_SYSTEM:AddMessage(msg) end
end
