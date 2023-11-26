--UNIT FRAMES COMPONENT ---------------------------
local ReactionColor,PlayerFrameFadeDelay
local Decay={health=0,magicka=0,stamina=0}
local DecayStep,Border,theme_color
local ult,syn,syn_count
local TrialGroupInit
local dot_off,dot_on="esoui/art/buttons/featuredot_inactive.dds","esoui/art/buttons/featuredot_active.dds"	--"/BanditsUserInterface/textures/point_off.dds","/BanditsUserInterface/textures/point_on.dds"
local dodge_icon="esoui/art/icons/passive_armor_009.dds"
local ReactionColor={
	[UNIT_REACTION_COMPANION]={.1,.5,.1,1},
	[UNIT_REACTION_DEFAULT]={.6,.1,.2,1},
	[UNIT_REACTION_FRIENDLY]={.1,.5,.1,1},
	[UNIT_REACTION_HOSTILE]={.6,.1,.2,1},
	[UNIT_REACTION_NEUTRAL]={.9,.9,.3,1},
	[UNIT_REACTION_NPC_ALLY]={.1,.5,.1,1},
	[UNIT_REACTION_PLAYER_ALLY]={0,.3,.8,1},
	["INVULNERABLE"]={.5,.5,.2,1},
	}
local TrialSortingRules={
	cloudresttrial_base={	--Cloudrest
	5,1,1,
	5,1,1,
	5,4,4,
	},
	mawlorkajsuthaysanctuary_base={	--MoL Twins
	5,4,1,1,1,1,
	5,4,1,1,1,1,
	}
	}
local TrialSplitingRules={
	cloudresttrial_base=3,	--Cloudrest
	mawlorkajsuthaysanctuary_base=6	--MoL
	}
local Boss_Phase={
	["Any"]				={100,50,25,0},
	["Ra Kotu"]				={100,35,0,0},	["Ра Коту"]				={100,35,0,0},
	["The Warrior"]			={100,35,0,0},	["Krieger"]				={100,35,0,0},	["Guerrierd"]			={100,35,0,0},	["Воин"]				={100,35,0,0},
	["Yokeda Kai"]			={100,30,0,0},	["Yokeda Kaid"]			={100,30,0,0},	["Йокеда Кай"]			={100,30,0,0},
	["Zhaj'hassa the Forgotten"]	={100,70,30,0},	["Zhaj'hassa der Vergessene"]	={100,70,30,0},	["Zhaj'hassa l'Oublié"]		={100,70,30,0},	["Жай'хасса Забытый"]		={100,70,30,0},
	["Hunter-Killer Negatrix"]	={100,30,0,0},	["Abfänger Negatrix"]		={100,30,0,0},	["Chasseur-tueur négatrix"]	={100,30,0,0},	["Охотник-убийца Негатрикс"]	={100,30,0,0},
	["Hunter-Killer Positrox"]	={100,30,0,0},	["Abfänger Positrox"]		={100,30,0,0},	["Chasseur-tueur positrox"]	={100,30,0,0},	["Охотник-убийца Позитрокс"]	={100,30,0,0},
	["Reactor"]				={100,70,40,20},	["Reaktor"]				={100,70,40,20},	["Réacteur"]			={100,70,40,20},	["Реактор"]				={100,70,40,20},
	["Reducer"]				={100,70,40,20},	["Minderer"]			={100,70,40,20},	["Réducteur"]			={100,70,40,20},	["Редуктор"]			={100,70,40,20},
	["Reclaimer"]			={100,70,40,20},	["Rückforderer"]			={100,70,40,20},	["Récupérateur"]			={100,70,40,20},	["Регенератор"]			={100,70,40,20},
	["Assembly General"]		={86,66,46,26},	["Montagegeneral"]		={86,66,46,26},	["Assembleur général"]		={86,66,46,26},	["Сборочный генерал"]		={86,66,46,26},
	["Saint Olms the Just"]		={90,75,50,25},	["Heiliger Olms der Gerechte"]={90,75,50,25},	["Saint Olms le Juste"]		={90,75,50,25},	["Святой Олмс Справедливый"]	={90,75,50,25},
	["Foundation Stone Atronach"]	={100,75,25,0},	["Grundsteinatronach"]		={100,75,25,0},	["Atronach de pierre des fondationsm"]={100,75,25,0},	["Фундаментальный каменный атронах"]={100,75,25,0},
	["The Mage"]			={100,16,0,0},	["Magierin"]			={100,16,0,0},	["Maged"]				={100,16,0,0},	["Маг"]				={100,16,0,0},
	["Tree-Minder Na-Kesh"]		={100,70,40,0},	["Baumhirtin Na-Kesh"]		={100,70,40,0},	["Sylvegarde Na-Keshd"]		={100,70,40,0},	["Древохранительница На-Кеш"]	={100,70,40,0},
	["Domihaus the Bloody-Horned"]={80,60,40,25},	["Domihaus der Blutgehörnte"]	={80,60,40,25},	["Domihaus Corne-Sanglante"]	={80,60,40,25},	["Домихаус Кровавые Рога"]	={80,60,40,25},
	["Hiath the Battlemaster"]	={75,45,20,0},	["Hiath der Kampfmeister"]	={75,45,20,0},	["Hiath le Maître de guerre"]	={75,45,20,0},	["Хиат Полководец"]		={75,45,20,0},
	["Stonebreaker"]			={75,50,25,0},	["Steinbrecher"]			={75,50,25,0},	["Briseroc"]			={75,50,25,0},	["Камнелом"]			={75,50,25,0},
	["Velidreth"]			={100,65,30,0},	["Велидрет"]			={100,65,30,0},
	["Ash Titan"]			={100,65,35,0},	["Aschtitan"]			={100,65,35,0},	["Titan de cendres"]		={100,65,35,0},	["Пепельный титан"]		={100,65,35,0},
	["Stormfist"]			={100,70,40,0},	["Sturmfaust"]			={100,70,40,0},	["Poigne-tempête"]		={100,70,40,0},	["Штормовой Кулак"]		={100,70,40,0},
	["Valkyn Skoria"]			={100,60,20,0},	["Валкин Скория"]			={100,60,20,0},
	["Zaan the Scalecaller"]	={80,60,40,20},	["Zaan die Schuppenruferin"]	={80,60,40,20},	["Zaan la Mandécailles"]	={80,60,40,20},	["Заан Призывательница Чешуи"]={80,60,40,20},
	["Thurvokun"]			={85,75,65,55},	["Турвокун"]			={85,75,65,55},
	["Molag Kena"]			={100,60,30,0},	["Молаг Кена"]			={100,60,30,0},
	["Z'Maja"]				={75,50,25,5},	["З'Маджа"]				={75,50,25,5},
	["Tarcyr"]				={80,50,20,0},	["Тарсир"]				={80,50,20,0},
	["Doylemish Ironheart"]		={80,60,40,20},	["Doylemish Eisenherz"]		={80,60,40,20},	["Doylemish Cœur-de-Fer"]	={80,60,40,20},	["Дойлемиш Железное Сердце"]	={80,60,40,20},
	["Vykosa the Ascendant"]	={90,70,50,30},	["Vykosa die Aufgestiegene"]	={90,70,50,30},	["Vykosa l'Ascendante"]		={90,70,50,30},	["Вайкоса Вознесшаяся"]		={90,70,50,30},
	["Tames-the-Beast"]		={100,60,40,0},	["Zähmt-die-Bestien"]		={100,60,40,0},	["Dompte-la-Bête"]		={100,60,40,0},	["Приручает-Чудовищ"]		={100,60,40,0},
	["Pinnacle Factotum"]		={80,60,40,20},	["Perfektioniertes Faktotum"]	={80,60,40,20},	["Factotum du Pinnacle"]	={80,60,40,20},	["Вершинный фактотум"]		={80,60,40,20},
	["Balorgh"]				={80,60,40,20},
	Yolnahkriin				={75,50,25,0},
	Lokkestiiz				={80,50,20,0},
	Nahviintaas				={80,60,40,0},
	-- Stone Garden / Steingarten
	["Stone Behemoth"]		={80,60,40,0}, ["Steinbehemoth"]	={80,60,40,0},
	["Arkasis the Mad Alchemist"]={100,60,20,0}, ["Arkasis der irre Alchemist"]	={100,60,20,0},
	-- Castle Thorn / Kastell Dorn
	["Vaduroth"]			={75,50,25,0},
	["Lady Thorn"]			={100,60,20,0}, ["Fürstin Dorn"]	={100,60,20,0},
	-- Shipwrights Regret / Gram des Schiffbauers
	["Foreman Bradiggan"]	={100,60,30,0}, ["Vorarbeiter Bradiggan"]	={100,60,30,0},
	["Captain Numirril"]	={100,85,40,0}, ["Kapitän Numirril"]	={100,85,40,0},
	-- Coral Aerie / Korallenhorst
	["Maligalig"]			={100,70,40,20},
	["Sarydil"]				={100,75,30,0},
	--["Varallion"]			={95,65,50,35},
	-- Dreadsail Reef / Grauenssegelriff
	["Turlassil"]			={80,70,50,30},
	["Lylanar"]				={80,70,50,30},
	["Reef Guardian"]		={100,80,50,0},["Riffwächter"]			={100,80,50,0},
	["Tideborn Taleria"]	={50,35,20,0}, ["Gezeitengeborene Taleria"]	={50,35,20,0},
	-- Rockgrove / Felshain
	["Oaxiltso"]			={95,75,50,20},
	["Flame-Herald Bahsei"]	={90,50,30,10}, ["Flammenheroldin Bahsei"]	={90,50,30,10},
	["Xalvakka"]			={100,70,40,25},
	-- Kyne's Aegis / Kynes Ägis
	["Lord Falgravn"]		={90,80,70,35},["Fürst Falgravn"]	={90,80,70,35},
	-- Black Drake Villa / Schwarzdrachenvilla
	["Kinras Ironeye"]		={75,50,25,0},["Kinras Einauge "]	={75,50,25,0},
	["Captain Geminus"]		={100,70,30,0},["Hauptmann Geminus"]	={100,70,30,0},
	["Pyroturge Encratis"]	={100,65,25,0},["Pyroturg Encratis"]	={100,65,25,0},
	-- Dread Cellar / Schreckenskeller
	["Scorion Broodlord"]	={80,60,40,20}, ["Skorionbrutfürst"]	={80,60,40,20},
	["Magma Incarnate"] 	={100,60,30,0}, ["Magmaverkörperung"]	={100,60,30,0},
	-- Red Petal Bastion / Rotblütenbastion
	["Eliam Merric"] 		={80,50,30,0}, ["Reliktträgern"]	={80,50,30,0},
	-- Bloodroot Forge / Blutquellschmiede
	["Mathgamain"]			={75,50,25,0},
	["Caillaoife"]			={75,50,25,0},
	-- Imperial City Prison / Gefängnis der Kaiserstadt
	["Ibomez the Flesh Sculptor"]={75,50,25,0}, ["Ibomez den Fleischbildner"]	={75,50,25,0},
	["Lord Warden Dusk"]	={100,65,35,0}, ["Hochwärter Dämmer"]	={100,65,35,0},
	-- Graven Deep / Kentertiefen
	["Zelvraak the Unbreathing"]={75,50,25,0},["Zelvraak der Atemlose"]	={75,50,25,0},
	-- Earthen Root Enclave / Erdwurz-Enklave
	["Corruption of Stone"] ={75,50,25,0}, ["Verderbnis des Steins"]	={75,50,25,0},
	-- Frostvault / Frostgewölbe
	["Vault Protector"]		={75,40,20,0}, ["Gewölbebeschützer"]	={75,40,20,0},
	["Warlord Tzogvin"]		={100,70,30,0}, ["Kriegsfürst Tzogvin"]	={100,70,30,0},
	["The Stonekeeper"]		={100,55,25,0}, ["Steinwahrer"]	={100,55,25,0},
	-- Scrivener's Hall / Halle der Schriftmeister
	["Ritemaster Naqri"]	={80,55,35,0}, ["Rissmeister Naqri"]	={80,55,35,0},
	["Ozezan the Inferno"]	={100,40,20,0}, ["Ozezan das Inferno"]	={100,40,20,0},
	-- Bal Sunnar 
	["Kovan Giryon"]		={65,45,20,0},
	["Roksa the Warped"]	={100,70,40,0}, ["Roksa die Verkrümmte"]	={100,70,40,0},
	["Matriarch Lladi Telvanni"]={100,70,35,0}, ["Matriarchin Lladi Telvanni"]	={100,70,35,0},		
	}
--	/script StartChatInput(GetUnitName("boss1"))
local PhaseTimer={
	Olms		={name="|t18:18:"..GetAbilityIcon(98549).."|t Storm of Heavens",timer=0,[98549]=31000},
	Felms		={name="|t18:18:"..GetAbilityIcon(99138).."|t Teleport Strike",timer=0,[99138]=21000},
--	Serpent	={name="Emerald Eclipse",timer=0,[56857]=21000,[54692]=0},
	Ozara		={name="|t18:18:"..GetAbilityIcon(57839).."|t Trapping Bolt",timer=0,[57839]=30000,[57861]=30000,atStart=true,initial=30000},
	Hiath		={name="|t18:18:"..GetAbilityIcon(55174).."|t Mark of Fire",timer=0,[55174]=60000},
--	Rakkhat	={name="Darkness Falls",timer=0,id={[74035]=true},[74035]=60000},
	Varlariel	={name="Clones",timer=0,atStart=true,initial=18500,duration=60000,repeatable=true},
	Warrior	={name="Time to all adds",timer=0,atStart=true,initial=540000},
	Skjoralmor	={name="|t18:18:"..GetAbilityIcon(98080).."|t Corpse Explosion",timer=0,[98080]=35000,atStart=true,initial=35000},
	Rilis		={name="|t18:18:"..GetAbilityIcon(18840).."|t Soul Blast",timer=0,[18840]=13000,atStart=true,initial=13000},
	Minara	={name="|t18:18:"..GetAbilityIcon(111659).."|t Bat Swarm",timer=0,[111659]=18000,atStart=true,initial=18000},
	Domihaus	={name="|t18:18:"..GetAbilityIcon(95291).."|t Shout",timer=0,[95291]=36000,atStart=true,initial=36000},
	ZMaja		={name="|t18:18:/esoui/art/icons/collectible_memento_pearlsummon.dds|t Shadow Realm",timer=0,silent=true},	--,[105890]=30000,[108045]=47000
--	Lokkestiiz	={name="|t18:18:"..GetAbilityIcon(114085).."|t Frost Atronach",timer=0,[114085]=20000,atStart=true,initial=20000},
}
BUI.Phase_Timers={
	["Saint Olms the Just"]		=PhaseTimer.Olms,		["Heiliger Olms der Gerechte"]=PhaseTimer.Olms,		["Saint Olms le Juste"]		=PhaseTimer.Olms,		["Святой Олмс Справедливый"]	=PhaseTimer.Olms,
	["Saint Felms the Bold"]	=PhaseTimer.Felms,	["Heiliger Felms der Tapfere"]=PhaseTimer.Felms,	["Saint Felms l'Audacieux"]	=PhaseTimer.Felms,	["Святой Фелмс Отважный"]	=PhaseTimer.Felms,
--	["The Serpent"]			=PhaseTimer.Serpent,	["Schlange"]	["Serpentd"]	["Змей"]
	["Ozara"]				=PhaseTimer.Ozara,	["Озара"]				=PhaseTimer.Ozara,
	["Hiath the Battlemaster"]	=PhaseTimer.Hiath,	["Hiath der Kampfmeister"]	=PhaseTimer.Hiath,	["Hiath le Maître de guerre"]	=PhaseTimer.Hiath,	["Хиат Полководец"]		=PhaseTimer.Hiath,
--	["Rakkhat"]				=PhaseTimer.Rakkhat,	["Ракхат"]
	["Varlariel"]			=PhaseTimer.Varlariel,	["Varlariël"]			=PhaseTimer.Varlariel,	["Варлариэль"]			=PhaseTimer.Varlariel,
	["The Warrior"]			=PhaseTimer.Warrior,	["Krieger"]				=PhaseTimer.Warrior,	["Guerrierd"]			=PhaseTimer.Warrior,	["Воин"]				=PhaseTimer.Warrior,
	["Deathlord Bjarfrud Skjoralmor"]=PhaseTimer.Skjoralmor,	["Todesfürst Bjarfrud Skjoralmor"]=PhaseTimer.Skjoralmor,	["Seigneur de la Mort Bjarfrud Skjoralmor"]=PhaseTimer.Skjoralmor,	["Военачальник Бьярфруд Скьоралмор"]=PhaseTimer.Skjoralmor,
	["High Kinlord Rilis"]		=PhaseTimer.Rilis,	["Sippenhochfürst Rilis"]	=PhaseTimer.Rilis,	["Haut Patriarche Rilis"]	=PhaseTimer.Rilis,	["Верховный Кинлорд Рилис"]	=PhaseTimer.Rilis,
	["Lady Minara"]			=PhaseTimer.Minara,	["Fürstin Minara"]		=PhaseTimer.Minara,	["Dame Minara"]			=PhaseTimer.Minara,	["Леди Минара"]			=PhaseTimer.Minara,
	["Domihaus the Bloody-Horned"]=PhaseTimer.Domihaus,	["Domihaus der Blutgehörnte"]	=PhaseTimer.Domihaus,	["Domihaus Corne-Sanglante"]	=PhaseTimer.Domihaus,	["Домихаус Кровавые Рога"]	=PhaseTimer.Domihaus,
	["Z'Maja"]				=PhaseTimer.ZMaja,	["З'Маджа"]				=PhaseTimer.ZMaja,
	["Lokkestiiz"]			=PhaseTimer.Lokkestiiz,
}
--	/script d("|t26:26:"..GetAbilityIcon(117815).."|t")
local function Frame_Player_UI()	--UI init
	local ch,cm,cs,cw,ct=BUI.Vars.FrameHealthColor,BUI.Vars.FrameMagickaColor,BUI.Vars.FrameStaminaColor,BUI.Vars.FrameShieldColor,BUI.Vars.FrameTraumaColor
	local ch1,cm1,cs1,cw1,ct1=BUI.Vars.FrameHealthColor1,BUI.Vars.FrameMagickaColor1,BUI.Vars.FrameStaminaColor1,BUI.Vars.FrameShieldColor1,BUI.Vars.FrameTraumaColor1
	local b,b1,b2=BUI.border[Border][2],BUI.border[Border][3],BUI.border[Border][4]
	local color=BUI.border[Border][5] and {1,1,1,1} or theme_color
	local w,h=BUI.Vars.FrameWidth,BUI.Vars.FrameHeight
	local fs=math.min(BUI.Vars.FrameFontSize,h*.8)
	local anchor=BUI.Vars.FrameHorisontal and BUI.Vars.BUI_HPlayerFrame or BUI.Vars.BUI_PlayerFrame
	--Create the player frame container
	local w1=BUI.Vars.FrameHorisontal and (BUI.Vars.RepositionFrames and (w*1.25+b1*2)*2+2 or (w+b1*2)*3+10) or w+b1*2
	local h1=BUI.Vars.FrameHorisontal and (BUI.Vars.RepositionFrames and (h+b2*2)*2+2 or h+b2*2) or (h+b2*2)*3
	local player	=BUI.UI.Control("BUI_PlayerFrame",				BanditsUI,	{w1,h1},		anchor,				not BUI.Vars.PlayerFrame)
	player.backdrop	=BUI.UI.Backdrop("BUI_PlayerFrame_BG",			player,	"inherit",		{TOP,TOP,0,0},			{0,0,0,0.4}, {0,0,0,1}, nil, true) --player.backdrop:SetEdgeTexture("",16,4,4)
	player.label	=BUI.UI.Label("BUI_PlayerFrame_Label",			player.backdrop,	"inherit",		{CENTER,CENTER,0,0},		BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("PF_Label"), false)
	player:SetDrawTier(DT_HIGH)
	player:SetMovable(true)
	player:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	player.width=w
	player.base		=BUI.UI.Control("BUI_PlayerFrame_Base",			player,	{w1,h1},		{TOPLEFT,TOPLEFT,0,0})

	--Health Bar
	local h2=BUI.Vars.FrameHorisontal and h or h*1.5
	local health	=BUI.UI.Backdrop("BUI_PlayerFrame_Health",		player.base,	{w+b1*2,h2+b2*2},	{TOP,TOP,0,0},			{0,0,0,0}, color, nil, false)
	health:SetDrawLayer(2) health:SetEdgeTexture(BUI.border[Border][1],b*8,b,b) health:SetEdgeColor(unpack(color))
	health.bg		=BUI.UI.Backdrop("BUI_PlayerFrame_HealthBg",		health,	{w,h2},		{CENTER,CENTER,0,0},		{0,0,0,1}, {0,0,0,0}, nil, false)
	health.bg:SetDrawLayer(0)
	health.resist	=BUI.UI.Texture("BUI_PlayerFrame_Resist",			health,	{h*2,h*2},		{CENTER,LEFT,0,0},		'/esoui/art/icons/gear_breton_shield_d.dds', true)
	health.resist:SetDrawLayer(3)
	player.name		=BUI.UI.Label("BUI_PlayerFrame_PlateName",		health,	{w-(Border==7 and h*2 or 5)*2,fs*1.5},		{BOTTOMLEFT,TOPLEFT,(Border==7 and h*2 or 5),b2/2},	BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,1}, "Player Name (Level)", not BUI.Vars.EnableNameplate)
	health.bar		=BUI.UI.Statusbar("BUI_PlayerFrame_HealthBar",		health.bg,	{w,h2},		{CENTER,CENTER,0,0},		ch, BUI.Textures[BUI.Vars.FramesTexture], false)
	health.bar:SetDrawLayer(1) health.bar:SetGradientColors(ch[1],ch[2],ch[3],ch[4],ch1[1],ch1[2],ch1[3],ch1[4])
	health.bar1		=BUI.UI.Backdrop("BUI_PlayerFrame_HealthBar1",		health.bar,	{0,h2},		{LEFT,RIGHT,0,0},			{ch[1],ch[2],ch[3],.3}, {0,0,0,0}, nil, false)
	health.bar2		=BUI.UI.Backdrop("BUI_PlayerFrame_HealthBar2",		health.bar,	{0,h2},		{RIGHT,LEFT,0,0},			{ch[1],ch[2],ch[3],.3}, {0,0,0,0}, nil, false)
	health.current	=BUI.UI.Label("BUI_PlayerFrame_HealthCurrent",		health,	{w*2/3,h},		{CENTER,CENTER,0,0},		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {1,1}, 'Health', false)
	health.current:SetDrawLayer(3)
	health.pct		=BUI.UI.Label("BUI_PlayerFrame_HealthPct",		health,	{w*1/3,h},		{RIGHT,RIGHT,-12-b1,0},		BUI.UI.Font(BUI.Vars.FrameFont2,fs,true), nil, {2,1}, 'Pct%', not BUI.Vars.FramePercents)
	health.pct:SetDrawLayer(3)
	health.hot		=BUI.UI.Texture("BUI_PlayerFrame_HealthHoT",		health,	{h*3/2,h*3/4},	{LEFT,CENTER,6+b1,0},		'/BanditsUserInterface/textures/regen_sm.dds', true)
	health.hot:SetDrawLayer(3)
	health.dot		=BUI.UI.Texture("BUI_PlayerFrame_HealthDoT",		health,	{h*3/2,h*3/4},	{RIGHT,CENTER,-6-b1,0},		'/BanditsUserInterface/textures/regen_sm.dds', true)
	health.dot:SetDrawLayer(3) health.dot:SetTextureRotation(math.pi)
	player.health	=health

	--Magicka Bar
	local magicka	=BUI.UI.Backdrop("BUI_PlayerFrame_Magicka",		health,	{w+b1*2,h+b2*2},	{RIGHT,LEFT,-5,0},		{0,0,0,0}, color, nil, false)
	magicka:SetDrawLayer(2) magicka:SetEdgeTexture(BUI.border[Border][1],b*8,b,b) magicka:SetEdgeColor(unpack(color))
	magicka.bg		=BUI.UI.Backdrop("BUI_PlayerFrame_MagickaBg",		magicka,	{w,h},		{CENTER,CENTER,0,0},		{0,0,0,1}, {0,0,0,0}, nil, false)
	magicka.bg:SetDrawLayer(0)
	magicka.bar		=BUI.UI.Statusbar("BUI_PlayerFrame_MagickaBar",		magicka.bg,	{w,h},		{RIGHT,RIGHT,0,0},		cm, BUI.Textures[BUI.Vars.FramesTexture], false)
	magicka.bar:SetDrawLayer(1) magicka.bar:SetGradientColors(cm1[1],cm1[2],cm1[3],cm1[4],cm[1],cm[2],cm[3],cm[4])
	magicka.bar1	=BUI.UI.Backdrop("BUI_PlayerFrame_MagickaBar1",		magicka.bar,{0,h},		{RIGHT,LEFT,0,0},			{cm[1],cm[2],cm[3],.3}, {0,0,0,0}, nil, false)
	magicka.current	=BUI.UI.Label("BUI_PlayerFrame_MagickaCurrent",		magicka,	{w*2/3,h},		{CENTER,CENTER,0,0},		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {1,1}, 'Magicka', false)
	magicka.pct		=BUI.UI.Label("BUI_PlayerFrame_MagickaPct",		magicka,	{w*1/3,h},		{RIGHT,RIGHT,-12-b1,0},		BUI.UI.Font(BUI.Vars.FrameFont2,fs,true), nil, {2,1}, 'Pct%', not BUI.Vars.FramePercents)
	player.magicka	=magicka

	--Stamina Bar
	local stamina	=BUI.UI.Backdrop("BUI_PlayerFrame_Stamina",		health,	{w+b1*2,h+b2*2},	{LEFT,RIGHT,5,0},			{0,0,0,0}, color, nil, false)
	stamina:SetDrawLayer(2) stamina:SetEdgeTexture(BUI.border[Border][1],b*8,b,b) stamina:SetEdgeColor(unpack(color))
	stamina.bg		=BUI.UI.Backdrop("BUI_PlayerFrame_StaminaBg",		stamina,	{w,h},		{CENTER,CENTER,0,0},		{0,0,0,1}, {0,0,0,0}, nil, false)
	stamina.bg:SetDrawLayer(0)
	stamina.bar		=BUI.UI.Statusbar("BUI_PlayerFrame_StaminaBar",		stamina.bg,	{w,h},		{LEFT,LEFT,0,0},			cs, BUI.Textures[BUI.Vars.FramesTexture], false)
	stamina.bar:SetDrawLayer(1) stamina.bar:SetGradientColors(cs[1],cs[2],cs[3],cs[4],cs1[1],cs1[2],cs1[3],cs1[4])
	stamina.bar1	=BUI.UI.Backdrop("BUI_PlayerFrame_StaminaBar1",		stamina.bar,{0,h},		{LEFT,RIGHT,0,0},			{cs[1],cs[2],cs[3],.3}, {0,0,0,0}, nil, false)
	stamina.current	=BUI.UI.Label("BUI_PlayerFrame_StaminaCurrent",		stamina,	{w*2/3,h},		{CENTER,CENTER,0,0},		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {1,1}, 'Stamina', false)
	stamina.pct		=BUI.UI.Label("BUI_PlayerFrame_StaminaPct",		stamina,	{w*1/3,h},		{RIGHT,RIGHT,-12-b1,0},		BUI.UI.Font(BUI.Vars.FrameFont2,fs,true), nil, {2,1}, 'Pct%', not BUI.Vars.FramePercents)
	player.stamina	=stamina

	--Shield Bar
	player.shield	=BUI.UI.Backdrop("BUI_PlayerFrame_ShieldBar",		health,	{w,h2},		{CENTER,CENTER,0,0},		{cw[1],cw[2],cw[3],.5}, {0,0,0,0}, nil, true)
	player.shield:SetDrawLayer(2)

	--Trauma Bar
	player.trauma	=BUI.UI.Backdrop("BUI_PlayerFrame_TraumaBar",		health,	{w,h2},		{LEFT,LEFT,2,0},		{ct[1],ct[2],ct[3],ct[4]}, {0,0,0,0}, nil, true)
	player.trauma:SetDrawLayer(2)

	--redraw the borders
	health:SetEdgeTexture(BUI.border[Border][1],b*8,b,b) health:SetEdgeColor(unpack(color))

	--Alternate Progress Bar
	local alt		=BUI.UI.Control("BUI_PlayerFrame_Alt",			health,	{w*2/3,h/2},	{TOPLEFT,BOTTOMLEFT,0,2,stamina},	true)
	alt.bg		=BUI.UI.Backdrop("BUI_PlayerFrame_AltBg",			alt,		{w*2/3-h*2/3-2,8},{RIGHT,RIGHT,0,0},		{0,0,0,0}, {1,1,1,1}, nil, false)
	alt.bg:SetEdgeTexture(BUI.progress[BUI.Vars.Theme],32,4,4) alt.bg:SetEdgeColor(unpack(theme_color))
	alt.bar		=BUI.UI.Statusbar("BUI_PlayerFrame_AltBar",		alt.bg,	{alt.bg:GetWidth()-4,8-4},	{LEFT,LEFT,2,0},	{0,1,1,1}, BUI.Textures[BUI.Vars.FramesTexture], false)
	alt.icon		=BUI.UI.Texture("BUI_PlayerFrame_AltIcon",		alt,		{h*2/3,h*2/3},	{LEFT,LEFT,0,0},			"/esoui/art/champion/champion_points_magicka_icon-hud-32.dds", false)
	alt.icon:SetDrawLayer(3)
	player.alt		=alt

	--Dodge fatigue Bar
	local dodge		=BUI.UI.Control("BUI_PlayerFrame_Dodge",			health,	{w/3,8},		{BOTTOMLEFT,TOPLEFT,0,-2,stamina},	true)
	dodge.bg		=BUI.UI.Backdrop("BUI_PlayerFrame_DodgeBg",		dodge,	{w/3-h*2/3-2,8},	{RIGHT,RIGHT,0,0},		{0,0,0,0}, {1,1,1,1}, nil, false)
	dodge.bg:SetEdgeTexture(BUI.progress[BUI.Vars.Theme],32,4,4) dodge.bg:SetEdgeColor(unpack(theme_color))
	dodge.bar		=BUI.UI.Statusbar("BUI_PlayerFrame_DodgeBar",		dodge.bg,	{alt.bg:GetWidth()-4,8-4},	{LEFT,LEFT,2,0},	{.26,.44,.78,1}, BUI.Textures[BUI.Vars.FramesTexture], false)
	dodge.icon		=BUI.UI.Texture("BUI_PlayerFrame_DodgeIcon",		dodge,	{h*2/3,h*2/3},	{LEFT,LEFT,0,0},			dodge_icon, false)
	dodge.icon:SetDrawLayer(3)
	player.dodge	=dodge

	--Ornament
	local orn1=Border==4 and '/BanditsUserInterface/textures/gear_large.dds' or Border==7 and '/BanditsUserInterface/textures/dragon_large.dds' or nil
	local orn2=Border==4 and '/BanditsUserInterface/textures/gear_small.dds' or nil
	if orn1 then
	local size=h*(Border==4 and 3 or Border==7 and 4 or 3)
	local anchor=Border==4 and {CENTER,TOPLEFT,b1,b2} or Border==7 and {CENTER,TOPLEFT,b1,h*.6-b2} or {CENTER,TOPLEFT,b1,b2}
	local t=BUI.UI.Texture("BUI_PlayerFrame_Orn1",	health,	{size,size},	anchor,	orn1, false) t:SetDrawLayer(0)
	elseif BUI_PlayerFrame_Orn1 then BUI_PlayerFrame_Orn1:SetHidden(true) end
	if orn2 then
	local t=BUI.UI.Texture("BUI_PlayerFrame_Orn2",	health,	{h*1.8,h*1.8},	{CENTER,RIGHT,-b1/4,0},	orn2, false) t:SetDrawLayer(0)
	elseif BUI_PlayerFrame_Orn2 then BUI_PlayerFrame_Orn2:SetHidden(true) end

	--Reposition
	if not BUI.Vars.FrameHorisontal then
		health.bar:ClearAnchors() health.bar:SetAnchor(LEFT,health.bg,LEFT,0,0)
		magicka:ClearAnchors() magicka:SetAnchor(TOPLEFT,health,BOTTOMLEFT,0,-b2)
		magicka.bar:ClearAnchors() magicka.bar:SetAnchor(LEFT,magicka.bg,LEFT,0,0)
		magicka.bar:SetGradientColors(cm[1],cm[2],cm[3],cm[4],cm1[1],cm1[2],cm1[3],cm1[4])
		magicka.bar1:ClearAnchors() magicka.bar1:SetAnchor(LEFT,magicka.bar,RIGHT,0,0)
		stamina:ClearAnchors() stamina:SetAnchor(TOPLEFT,magicka,BOTTOMLEFT,0,-b2)
		player.shield:ClearAnchors() player.shield:SetAnchor(RIGHT,health,RIGHT,0,0)
		player.trauma:ClearAnchors() player.trauma:SetAnchor(RIGHT,health,RIGHT,0,0)
		dodge:ClearAnchors() dodge:SetAnchor(LEFT,stamina,RIGHT,2,0)
	elseif BUI.Vars.RepositionFrames then
		magicka:ClearAnchors() magicka:SetAnchor(TOPRIGHT,health,BOTTOM,-1,3-b2)
		stamina:ClearAnchors() stamina:SetAnchor(TOPLEFT,health,BOTTOM,1,3-b2)
		dodge:ClearAnchors() dodge:SetAnchor(BOTTOMRIGHT,stamina,TOPRIGHT,0,-2)
		player.name:SetHorizontalAlignment(1)
	end
	if not BUI.Vars.FrameHorisontal or BUI.Vars.FramePercents then
		health.current:ClearAnchors() health.current:SetAnchor(LEFT,health,LEFT,12+b1,0) health.current:SetHorizontalAlignment(0)
		magicka.current:ClearAnchors() magicka.current:SetAnchor(LEFT,magicka,LEFT,12+b1,0) magicka.current:SetHorizontalAlignment(0)
		stamina.current:ClearAnchors() stamina.current:SetAnchor(LEFT,stamina,LEFT,12+b1,0) stamina.current:SetHorizontalAlignment(0)
	end

	--Dots control
	if BUI.Vars.ShowDots then
		local bar	=BUI.UI.Control("BUI_PlayerFrame_Dots",		health,	{16*5+4,16},	{BOTTOMRIGHT,TOPRIGHT,-10,0},	false)
		bar:SetDrawLayer(2)
		for i=1,5 do
			bar[i]=BUI.UI.Texture("BUI_PlayerFrame_Dots"..i,	bar,	{16,16},		{LEFT,LEFT,(i-1)*16+3,0},	dot_off, false)
			bar[i]:SetDrawLayer(3) bar[i]:SetColor(unpack(theme_color))
		end
	elseif BUI_PlayerFrame_Dots then
		BUI_PlayerFrame_Dots:SetHidden(true)
	end

	player.base:SetAlpha(BUI.Vars.FramesFade and 0 or BUI.Vars.FrameOpacityOut/100)
end

local function Frame_Target_UI()	--UI init
	local ch,cm,cs,cw,ct=BUI.Vars.FrameHealthColor,BUI.Vars.FrameMagickaColor,BUI.Vars.FrameStaminaColor,BUI.Vars.FrameShieldColor,BUI.Vars.FrameTraumaColor
	local ch1,cm1,cs1,cw1,ct1=BUI.Vars.FrameHealthColor1,BUI.Vars.FrameMagickaColor1,BUI.Vars.FrameStaminaColor1,BUI.Vars.FrameShieldColor1,BUI.Vars.FrameTraumaColor1
	local b,b1,b2=BUI.border[Border][2],BUI.border[Border][3],BUI.border[Border][4]
	local color=BUI.border[Border][5] and {1,1,1,1} or theme_color
	local w,h=BUI.Vars.TargetWidth,BUI.Vars.TargetHeight
	local fs=math.min(BUI.Vars.FrameFontSize,h*.8)
	local textpos={
		health = BUI.Vars.TargetFrameCenter and CENTER or LEFT,
		healthw = BUI.Vars.TargetFrameCenter and w*1/3 or w*2/3,
		percent = BUI.Vars.TargetFrameCenter and CENTER or RIGHT,
		spacing = BUI.Vars.TargetFrameCenter and math.min((14-BUI.Vars.FrameFontSize)*2,0) or 12
	}	
	local target	=BUI.UI.Control("BUI_TargetFrame",BanditsUI,{w+b1*2,h+b2*2+fs*1.5*2},BUI.Vars.BUI_TargetFrame,true)
	target.backdrop	=BUI.UI.Backdrop("BUI_TargetFrame_Bg",target,"inherit",{CENTER,CENTER,0,0},{0,0,0,0.4},{0,0,0,1},nil,true)
	target.label	=BUI.UI.Label("BUI_TargetFrame_Label",target.backdrop,"inherit",{CENTER,CENTER,0,0},BUI.UI.Font("standard",20,true),nil,{1,1},BUI.Loc("TF_Label"),false)
	target:SetMovable(true)
	target:SetHandler("OnMouseUp",function(self)BUI.Menu:SaveAnchor(self)end)
	target.width=w
	target.base		=BUI.UI.Control("BUI_TargetFrame_Base",target,{w+b1*2,h+b2*2+fs*1.5*2},{TOPLEFT,TOPLEFT,0,0})
	target.base:SetAlpha(BUI.Vars.FrameOpacityOut/100)
	local plate		=BUI.UI.Control("BUI_TargetFrame_Plate",target.base,{w,(fs+2)*1.3},{TOP,TOP,0,0},false)
	plate.name		=BUI.UI.Label("BUI_TargetFrame_PlateName",plate,{w-42,(fs+2)*1.3},{BOTTOM,BOTTOM,6,0},BUI.UI.Font(BUI.Vars.FrameFont1,fs+2,true),nil,{1,1},"TargetName(Level)",false)
	plate.class		=BUI.UI.Texture("BUI_TargetFrame_PlateClass",plate,{fs*1.5,fs*1.3},{RIGHT,RIGHT,0,2},"/esoui/art/contacts/social_classicon_"..BUI.Player.class..".dds",false)
	target.plate=plate
	local health	=BUI.UI.Backdrop("BUI_TargetFrame_Health",target.base,{w+b1*2,h+b2*2},	{TOP,TOP,0,fs*1.5},{0,0,0,0}, color, nil, false)
	health:SetDrawLayer(2) health:SetEdgeTexture(BUI.border[Border][1],b*8,b,b)
	health.bg		=BUI.UI.Backdrop("BUI_TargetFrame_HealthBg",health,{w,h},{CENTER,CENTER,0,0},{0,0,0,1},{0,0,0,0},nil,false)
	health.bg:SetDrawLayer(0)
	health.bar		=BUI.UI.Statusbar("BUI_TargetFrame_HealthBar",health.bg,{w,h},{CENTER,CENTER,0,0},ch,BUI.Textures[BUI.Vars.FramesTexture],false)
--	health.bar:SetGradientColors(ch[1],ch[2],ch[3],ch[4],ch1[1],ch1[2],ch1[3],ch1[4])
	health.current	=BUI.UI.Label("BUI_TargetFrame_HealthCurrent",health.bg,{textpos.healthw,h},{CENTER,CENTER,0,0},BUI.UI.Font(BUI.Vars.FrameFont1,fs,true),nil,{1,1},'Health',false)
	health.pct		=BUI.UI.Label("BUI_TargetFrame_HealthPct",health.bg,{w*1/3,h},{textpos.percent,textpos.percent,-textpos.spacing,0},BUI.UI.Font(BUI.Vars.FrameFont2,fs,true),nil,{2,1},'Pct%',not BUI.Vars.TargetFramePercents)
	health.hot		=BUI.UI.Texture("BUI_TargetFrame_HealthHoT",health.bg,{w/6,w/12},{LEFT,CENTER,6,0},'/BanditsUserInterface/textures/regen_sm.dds',true)
	health.dot		=BUI.UI.Texture("BUI_TargetFrame_HealthDoT",health.bg,{w/6,w/12},{RIGHT,CENTER,0,0},'/BanditsUserInterface/textures/regen_sm.dds',true) health.dot:SetTextureRotation(math.pi)
	target.health=health
	target.execute	=BUI.UI.Texture("BUI_TargetFrame_Execute",health,{h*2,h*2},{CENTER,BOTTOM,0,h},'/esoui/art/icons/mapkey/mapkey_groupboss.dds',true,1)
	local lplate	=BUI.UI.Control("BUI_TargetFrame_LPlate",target.base,{w,fs*1.5},{BOTTOM,BOTTOM,0,0},false)
	lplate.title	=BUI.UI.Label("BUI_TargetFrame_LPlateTitle",lplate,{w,fs*1.5},{TOP,TOP,0,0},BUI.UI.Font(BUI.Vars.FrameFont1,fs,true),nil,{1,1},'Title',false)
	lplate.rank		=BUI.UI.Texture("BUI_TargetFrame_LPlateIcon",lplate,{fs*1.5,fs*1.5},{LEFT,LEFT,0,0},"/esoui/art/ava/ava_rankicon_sergeant.dds",false) target.lplate=lplate
	target.shield	=BUI.UI.Statusbar("BUI_TargetFrame_ShieldBar",health,{w,h},{CENTER,CENTER,0,0},{cw[1],cw[2],cw[3],.5},BUI.Textures[BUI.Vars.FramesTexture],true)	--target.shield:SetDrawTier(2)
	target.trauma   =BUI.UI.Statusbar("BUI_TargetFrame_TraumaBar",health,{w,h},{LEFT,LEFT,2,0},{ct[1],ct[2],ct[3],.5},BUI.Textures[BUI.Vars.FramesTexture],true)
	--Reposition
	if not BUI.Vars.FrameHorisontal then
		health.bar:ClearAnchors() health.bar:SetAnchor(LEFT,health.bg,LEFT,0,0)
		target.shield:ClearAnchors() target.shield:SetAnchor(LEFT,health,LEFT,0,0)
		target.trauma:ClearAnchors() target.trauma:SetAnchor(LEFT,health,LEFT,0,0)
	end
	if not BUI.Vars.FrameHorisontal or BUI.Vars.TargetFramePercents then
		health.current:ClearAnchors() health.current:SetAnchor(textpos.health,health.bg,textpos.health,textpos.spacing,0) health.current:SetHorizontalAlignment(0)
	end
	--Default target bar
	local parent=_G["ZO_TargetUnitFramereticleover"] BUI.UI.Label("BUI_Targethealth",parent,{parent:GetWidth(),20},{CENTER,CENTER,0,-1},BUI.UI.Font(BUI.Vars.FrameFont2,fs,true),nil,{1,1},nil,false)
end

	--Group frame
local function ClearDeathCount()
	for accname in pairs(BUI.Group) do if accname~="members" then BUI.Group[accname].death=nil end end
	a("Group death list is cleared")
end

local function PostDeathCount()
	local data={}
	for i=1, BUI.Group.members do
		local unitTag=GetGroupUnitTagByIndex(i)
		local accname=GetUnitDisplayName(unitTag)
		if BUI.Group[accname].death then table.insert(data,{accname=accname, death=BUI.Group[accname].death}) end
	end
	if #data>0 then
		table.sort(data, function(x,y) return (x.death>y.death) end)
		local text=""
		for i=1,#data do
			if text~="" then text=text..", " end
			text=text..data[i].accname..": "..data[i].death
		end
		CHAT_SYSTEM:Maximize() CHAT_SYSTEM.primaryContainer:FadeIn()
		StartChatInput("/p Group deaths: "..text)
	else
		a("Group death list is empty")
	end
end

local function GroupMember_OnMouseUp(control, button, upInside)
	if(button==MOUSE_BUTTON_INDEX_RIGHT and upInside) then
		local i=control.index
		if not BUI.Group[i] then return end
		local unitTag=BUI.Group[i].tag	--GetGroupUnitTagByIndex(i)
		local accname=BUI.Group[unitTag].accname
		local isPlayer=(GetUnitName(unitTag)==BUI.Player.name)
		local isLeader=IsUnitGroupLeader('player')
		local isOnline=IsUnitOnline(unitTag)
		local requiresVoting=DoesGroupModificationRequireVote()
		local ModificationAvailable=IsGroupModificationAvailable()
--		d("unitTag "..tostring(unitTag).."||name "..tostring(accname).."||isPlayer "..tostring(isPlayer).."||isLeader "..tostring(isLeader).."||isOnline "..tostring(isOnline))
		ClearMenu()
		if isOnline then
			if isPlayer then
				AddMenuItem(GetString(SI_GROUP_LIST_MENU_LEAVE_GROUP), function()
--					ZO_Dialogs_ShowDialog("GROUP_LEAVE_DIALOG")
					GroupLeave()
				end)
			else
				if IsChatSystemAvailableForCurrentPlatform() then
					AddMenuItem(GetString(SI_SOCIAL_LIST_PANEL_WHISPER), function() StartChatInput("", CHAT_CHANNEL_WHISPER, accname) end)
				end
--				AddMenuItem(GetString(SI_SOCIAL_MENU_VISIT_HOUSE), function() JumpToHouse(accname) end)
				AddMenuItem(GetString(SI_SOCIAL_MENU_JUMP_TO_PLAYER), function()
					BUI.OnScreen.Notification(11,"Jump to "..accname.."("..GetUnitName(unitTag)..")".." is started")
					JumpToGroupMember(accname)
				end)
				if control.dps>4000 then 
					AddMenuItem("Post DPS", function()
						CHAT_SYSTEM:Maximize() CHAT_SYSTEM.primaryContainer:FadeIn()
						StartChatInput("/p "..accname.." DPS: "..BUI.DisplayNumber(control.dps).." ("..ZO_FormatTime(control.time,SI_TIME_FORMAT_TIMESTAMP)..")")
					end)
				end
			end
			AddMenuItem("Post death count", function() PostDeathCount() end)
			AddMenuItem("Clear death count", function() ClearDeathCount() end)
			AddMenuItem("Save group list", function() BUI.RG_Save() end)
--			AddMenuItem("Post group list", function() BUI.RG_ListGroup() end)
			if isLeader and ModificationAvailable and not requiresVoting then
				AddMenuItem("Regroup", function() BUI.RG_ReGroup() end)
			end
			AddMenuItem(GetString(SI_GROUP_LIST_READY_CHECK_BIND), function() BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_UNANIMOUS, ZO_GROUP_ELECTION_DESCRIPTORS.READY_CHECK) end)
		end
		if ModificationAvailable then
			if isLeader then
				if not requiresVoting then
					AddMenuItem(GetString(SI_GROUP_LIST_MENU_DISBAND_GROUP), function() ZO_Dialogs_ShowDialog("GROUP_DISBAND_DIALOG") end)
					if not isPlayer then
						AddMenuItem(GetString(SI_GROUP_LIST_MENU_KICK_FROM_GROUP), function() GroupKick(unitTag) end)
					end
				end
			end
			if requiresVoting and not isPlayer then
				AddMenuItem(GetString(SI_GROUP_LIST_MENU_VOTE_KICK_FROM_GROUP), function() BeginGroupElection(GROUP_ELECTION_TYPE_KICK_MEMBER, ZO_GROUP_ELECTION_DESCRIPTORS.NONE, unitTag) end)
			end
		end
		if isLeader and not isPlayer and isOnline then
			AddMenuItem(GetString(SI_GROUP_LIST_MENU_PROMOTE_TO_LEADER), function() GroupPromote(unitTag) end)
		end
--		AddMenuItem("Refresh frame", function() BUI.Frames:SetupGroup() end)
		ShowMenu(control)
	end
end

local function GetDBGNInfo(displayName)
	if DBGN and DBGN.GetGuildMemberInfo then
		local rec=DBGN:GetGuildMemberInfo(displayName, "DBGN")
		if rec~=nil then
			local rank={[0]=false,[1]="Normal",[2]="Veteran",[3]="Master"}
			return (rec.FlAttDD and rec.DPS or false),rank[rec.IndAttTank],rank[rec.IndAttHeal]
		end
	end
	return false,false,false
end

local function GroupMember_ShowTooltip(control)
	if BUI.Group[control.index] then
		local unitTag=BUI.Group[control.index].tag	--GetGroupUnitTagByIndex(control.index)
		if unitTag then
			local accname=BUI.Group[unitTag].accname
			local name=BUI.Group[unitTag].name
--			local isOnline=IsUnitOnline(unitTag)
			local zone=string.gsub(GetUnitZone(unitTag),"%^%w+","")
			local dd,tank,healer=GetDBGNInfo(accname)
			InitializeTooltip(InformationTooltip, control, BOTTOM, 0, -16)
			InformationTooltip:AddLine(accname.."("..name..")",'$(BOLD_FONT)'..'|22',1,1,1)
			local text='Location: |cFFFFFF'..zone..'|r'
			if control.dps>4000 then text=text..'\nLast DPS: |cFFFFFF'..BUI.DisplayNumber(control.dps).." ("..ZO_FormatTime(control.time,SI_TIME_FORMAT_TIMESTAMP)..')|r' end
			if BUI.Group[accname].death then text=text..'\nDeath: |cFFFFFF'..BUI.Group[accname].death..'|r' end
			if dd then text=text..'\nDD attestation: |cFFFFFF'..BUI.DisplayNumber(dd)..' dps|r' end
			if tank then text=text..'\nTank attestation: |cFFFFFF'..tank..'|r' end
			if healer then text=text..'\nHealer attestation: |cFFFFFF'..healer..'|r' end
			SetTooltipText(InformationTooltip, text)
		end
	end
end

function BUI.Frames.Raid_UI(s)	--UI init
	s=s or BUI_RaidFrame and BUI_RaidFrame.scale or 1
	local col=BUI.Vars.RaidColumnSize
	local ch,cm,cs,cw,ct=BUI.Vars.FrameHealthColor,BUI.Vars.FrameMagickaColor,BUI.Vars.FrameStaminaColor,BUI.Vars.FrameShieldColor,BUI.Vars.FrameTraumaColor
--	local ch1,cm1,cs1,cw1=BUI.Vars.FrameHealthColor1,BUI.Vars.FrameMagickaColor1,BUI.Vars.FrameStaminaColor1,BUI.Vars.FrameShieldColor1
	local w,h=BUI.Vars.RaidWidth*s,BUI.Vars.RaidHeight*s
	local hs=h-(BUI.Vars.StatShare and 8-1 or 0)*s
	local fs=math.min(BUI.Vars.RaidFontSize,hs*.8)*s
	local t=GetFormattedTime()
	local comp=BUI.Vars.RaidCompact
	local split=BUI.Vars.RaidSplit
	if BUI.Vars.RaidSort==1 and TrialSplitingRules[BUI.MapId] then	--Auto
		split=TrialSplitingRules[BUI.MapId]
		TrialGroupInit=true
	else
		TrialGroupInit=false
	end
	ult=BUI.Vars.StatShare and BUI.Vars.StatShareUlt~=3
	syn=BUI.Vars.GroupSynergy<3 and BUI.Vars.GroupSynergy
	syn_count=BUI.Vars.GroupSynergyCount+(ult and 1 or 0)-1
	local indent=math.max((ult and hs or 0)+(syn and hs*(syn_count+1) or 0),(BUI.Vars.GroupElection and hs or 0))
	--Create the group frame container
	local raid		=BUI.UI.Control("BUI_RaidFrame",			BanditsUI,	{w*(24/col),(h+(comp and 0 or fs+3))*col},	BUI.Vars.BUI_RaidFrame,	false)
	raid.backdrop	=BUI.UI.Backdrop("BUI_RaidFrame_Bg",		raid,		"inherit",		{CENTER,CENTER,0,0},	{0,0,0,0.4}, {0,0,0,1}, nil, true)
	raid.label		=BUI.UI.Label(	"BUI_RaidFrame_Label",		raid.backdrop,		"inherit",		{CENTER,CENTER,0,0},	BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("GF_Label"), false)
	raid:SetAlpha(BUI.Vars.FrameOpacityOut/100)
	raid:SetDrawTier(DT_HIGH)
	raid:SetMovable(true)
	raid:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	raid.scale=s
	--Iterate over 24 possible raid members
	local anchor	={TOPLEFT,TOPLEFT,0,0,raid}
	for i=1, 24 do
	local member	=BUI.UI.Control(	"BUI_RaidFrame"..i,		raid,		{w,h+(comp and 0 or fs+3)},	anchor,			true)
--	member.bg		=BUI.UI.Backdrop("BUI_RaidFrame"..i.."_Bg",	member,	{w-6*s+fs*1.2,h-2*s},		{TOPLEFT,TOPLEFT,-fs*1.2+2*s,0},{.3,.3,.2,.7}, {0,0,0,0}, nil, not comp) member.bg:SetDrawLayer(0)
	member.width=w
	member.index=i
	member:SetMouseEnabled(true)
	member:SetHandler("OnMouseUp", GroupMember_OnMouseUp)
	member:SetHandler("OnMouseEnter", GroupMember_ShowTooltip)
	member:SetHandler("OnMouseExit", function()ClearTooltip(InformationTooltip)end)
	--Health Bar
	local health	=BUI.UI.Backdrop("BUI_RaidFrame"..i.."_Health",	member,	{w,hs},		{TOPLEFT,TOPLEFT,0,(comp and 0 or fs)},{0,0,0,0}, {1,1,1,1}, nil, false)
	health:SetDrawLayer(0) health:SetEdgeTexture(BUI.progress[BUI.Vars.Theme],32,4,4) health:SetEdgeColor(unpack(theme_color))
	health.bg		=BUI.UI.Backdrop("BUI_RaidFrame"..i.."_HealthBg",health,	{w-6*s,hs-6*s},	{TOPLEFT,TOPLEFT,3*s,3*s},	{0,0,0,1}, {0,0,0,0}, nil, false)
	health.bg:SetDrawLayer(0)
	health.bar		=BUI.UI.Statusbar("BUI_RaidFrame"..i.."_Bar",	health,	{w-4*s,hs-4*s},	{LEFT,LEFT,2*s,0},		ch, BUI.Textures[BUI.Vars.FramesTexture], false)
	health.bar:SetDrawLayer(1)
	member.shield	=BUI.UI.Backdrop(	"BUI_RaidFrame"..i.."_Shield",health,	{w,hs-4*s},		{RIGHT,RIGHT,-2*s,0},	{cw[1],cw[2],cw[3],.5}, {0,0,0,0}, nil, true)
	member.shield:SetDrawLayer(2)	--member.shield:SetEdgeTexture("",2,2,2)
	member.trauma	=BUI.UI.Backdrop(	"BUI_RaidFrame"..i.."_Trauma",health,	{w,hs-4*s},		{LEFT,LEFT,2*s,0},	{ct[1],ct[2],ct[3],ct[4]}, {0,0,0,0}, nil, true)
	member.trauma:SetDrawLayer(2)
	health.current	=BUI.UI.Label(	"BUI_RaidFrame"..i.."_Current",health,	{w*2/3,hs},		(comp and {RIGHT,RIGHT,-fs*1.3,0} or {LEFT,LEFT,8,0}),		BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {comp and 2 or 0,1}, (BUI.Vars.RaidStatValue==3 and "" or BUI.Vars.RaidStatValue==2 and "0%" or "0.0k"), false)
	health.current:SetDrawLayer(3)
	health.pct		=BUI.UI.Label(	"BUI_RaidFrame"..i.."_Pct",	health,	{w*1/3,hs},		{RIGHT,RIGHT,-8*s,2*s},	BUI.UI.Font(BUI.Vars.FrameFont2,fs,true), nil, {2,1}, 'Pct%', true)
	health.pct:SetDrawLayer(3)
	health.hot		=BUI.UI.Texture(	"BUI_RaidFrame"..i.."_HoT",	health,	{hs*3/2,hs*3/4},	{LEFT,CENTER,-w/6,0},	'/BanditsUserInterface/textures/regen_sm.dds', true)
	health.hot:SetDrawLayer(3)
	health.dot		=BUI.UI.Texture(	"BUI_RaidFrame"..i.."_DoT",	health,	{hs*3/2,hs*3/4},	{RIGHT,CENTER,w/6,0},	'/BanditsUserInterface/textures/regen_sm.dds', true) health.dot:SetTextureRotation(math.pi)
	health.dot:SetDrawLayer(3)
	health.dps		=BUI.UI.Label(	"BUI_RaidFrame"..i.."_DPS",	health,	{w*2/3,hs},		{RIGHT,RIGHT,-8*s,0},	BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {2,1}, '', false)
	health.dps:SetDrawLayer(3) member.dps=0 member.time=0
	member.health=health
	--Nameplate
	member.name		=BUI.UI.Label(	"BUI_RaidFrame"..i.."_Name",	health,	{w-(comp and fs*1.2+w/3.6 or fs*1.2),fs*1.3},		(comp and {LEFT,LEFT,2*s,0} or {BOTTOMLEFT,TOPLEFT,2*s,fs*.1}),	BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,1}, "Member "..i, false)
	member.name:SetDrawLayer(3)
	member.lead		=BUI.UI.Texture(	"BUI_RaidFrame"..i.."_Lead",	health,	{fs*1.2,fs*.9},	(comp and {RIGHT,RIGHT,-3,-fs*.1} or {BOTTOMRIGHT,TOPRIGHT,0,-fs*.1}),	"/esoui/art/tutorial/gamepad/gp_playermenu_icon_store.dds",i~=1,nil,{0,1,0,.8}) member.lead:SetColor(1,1,.09)
	member.lead:SetDrawLayer(2)
	--Ultimate/Synergy
	member.UltB={} member.UltL={}
	for u=0,syn_count+1 do
	member.UltB[u]	=BUI.UI.Backdrop(	"BUI_RaidFrame"..i.."_UltB"..u,	health,	{hs,hs},		{LEFT,RIGHT,(hs-2*s)*u,0},	{1,1,1,.8}, theme_color, nil, true)
	member.UltL[u]	=BUI.UI.Label(	"BUI_RaidFrame"..i.."_UltL"..u,	member.UltB[u],{h,h},		{CENTER,CENTER,0,0},	BUI.UI.Font(BUI.Vars.FrameFont2,fs-4,true), nil, {1,1}, '0', false)
	end
	--Group Buffs
	if BUI.Vars.GroupBuffs then
	member.buffs	=BUI.UI.Label(	"BUI_RaidFrame"..i.."_Buffs",	member,	{16*7*s,16*s},		{BOTTOMRIGHT,BOTTOMRIGHT,0,0},BUI.UI.Font(BUI.Vars.FrameFont1,16,true), nil, {2,1}, "", false)
	BUI.Group["group"..i].Buff={"","","","","","","","",""} BUI.Group["group"..i].BuffTime={t,t,t,t,t,t,t,t,t}
	end
	--Status Indicator
	member.horn	=BUI.UI.Texture(	"BUI_RaidFrame"..i.."_Horn",		health,	{hs,hs},	{RIGHT,LEFT,0,0},	"/esoui/art/icons/ability_ava_003_a.dds", true)	--'/esoui/art/icons/justice_stolen_horn_001.dds'
	member.horn:SetDrawLayer(3)
	member.debuff=BUI.UI.Texture(	"BUI_RaidFrame"..i.."_Debuff",	health,	{hs*1.3,hs*1.3},	{RIGHT,RIGHT,-w/7,0},'/esoui/art/treeicons/tutorial_idexicon_death_up.dds', true)
	member.debuff:SetDrawLayer(3)
	member.resist=BUI.UI.Texture(	"BUI_RaidFrame"..i.."_Resist",	health,	{hs*1.3,hs*1.3},	{RIGHT,LEFT,0,0,member.debuff},	'/esoui/art/repair/inventory_tabicon_repair_disabled.dds', true)
	member.resist:SetDrawLayer(3)
	member.dead	=BUI.UI.Texture(	"BUI_RaidFrame"..i.."_Dead",		health,	{hs*1.3,hs*1.3},	{RIGHT,LEFT,0,0,member.resist},	'/esoui/art/icons/mapkey/mapkey_groupboss.dds', true)
	member.dead:SetDrawLayer(3)
	--Stat bar
	local sw=BUI.Vars.GroupBuffs and w/2 or w
	member.bg		=BUI.UI.Backdrop("BUI_RaidFrame"..i.."_Bg",	health,	{w-4*s,6*s},	{TOPLEFT,BOTTOMLEFT,0,0},{.2,.2,.2,.7}, {0,0,0,0},nil,not BUI.Vars.StatShare) member.bg:SetDrawLayer(0)
	member.stat		=BUI.UI.Backdrop("BUI_RaidFrame"..i.."_Stat",	health,	{sw,8*s},		{TOPLEFT,BOTTOMLEFT,0,-2*s},{0,0,0,0}, {1,1,1,1}, nil, true)
	member.stat:SetDrawLayer(1) member.stat:SetEdgeTexture(BUI.progress[BUI.Vars.Theme],32,4,4) member.stat:SetEdgeColor(unpack(theme_color))
	member.stat.bar	=BUI.UI.Statusbar("BUI_RaidFrame"..i.."_StatBar",member.stat,{sw-4,5*s},	{LEFT,LEFT,2*s,0},		cw, BUI.Textures[BUI.Vars.FramesTexture], false)
	member.stat.bar:SetDrawLayer(2)
	member.stat.width=sw
	--Extra settings
	raid["group"..i]=member
	local space=(split>1 and i%split==0) and hs or 0
	anchor=(i%col==0) and {TOPLEFT,TOPRIGHT,5*s+indent,0,_G["BUI_RaidFrame"..(i-col+1)]} or {TOP,BOTTOM,0,space-2*s,member}
	end
	--Horn info
	local info		=BUI.UI.Control("BUI_HornInfo",raid,{fs*.6*16,0},{TOPLEFT,TOPRIGHT,10,0,BUI_RaidFrame1}) info.row=fs*1.335
	info.space=10*s+indent
	BUI.UI.Backdrop("BUI_HornInfo_Bar", info, {0,fs}, {TOPLEFT,TOPLEFT,0,fs/5}, cs, {0,0,0,0}, nil) BUI_HornInfo_Bar.width=fs*.6*17
	BUI.UI.Label("BUI_HornInfo_Names", info, {fs*.6*13,(h*1.2+fs)*col}, {TOPLEFT,TOPLEFT,0,0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,0}, "")
	BUI.UI.Label("BUI_HornInfo_Value", info, {fs*.6*4,(h*1.2+fs)*col}, {TOPRIGHT,TOPRIGHT,0,0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,0}, "")
	--Major Vulnerability info
	local info		=BUI.UI.Control("BUI_ColossusInfo",raid,{fs*.6*16,0},{TOPLEFT,BOTTOMLEFT,0,0,BUI_HornInfo}) info.row=fs*1.335
	BUI.UI.Backdrop("BUI_ColossusInfo_Bar", info, {0,fs}, {TOPLEFT,TOPLEFT,0,fs/5}, cs, {0,0,0,0}, nil) BUI_ColossusInfo_Bar.width=fs*.6*17
	BUI.UI.Label("BUI_ColossusInfo_Names", info, {fs*.6*13,(h*1.2+fs)*col}, {TOPLEFT,TOPLEFT,0,0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,0}, "")
	BUI.UI.Label("BUI_ColossusInfo_Value", info, {fs*.6*4,(h*1.2+fs)*col}, {TOPRIGHT,TOPRIGHT,0,0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,0}, "")
	--Barrier info
	local info		=BUI.UI.Control("BUI_BarrierInfo",raid,{fs*.6*16,0},{TOPLEFT,BOTTOMLEFT,0,0,BUI_ColossusInfo}) info.row=fs*1.335
	BUI.UI.Backdrop("BUI_BarrierInfo_Bar", info, {0,fs}, {TOPLEFT,TOPLEFT,0,fs/5}, cs, {0,0,0,0}, nil) BUI_BarrierInfo_Bar.width=fs*.6*17
	BUI.UI.Label("BUI_BarrierInfo_Names", info, {fs*.6*13,(h*1.2+fs)*col}, {TOPLEFT,TOPLEFT,0,0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,0}, "")
	BUI.UI.Label("BUI_BarrierInfo_Value", info, {fs*.6*4,(h*1.2+fs)*col}, {TOPRIGHT,TOPRIGHT,0,0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,0}, "")
end

	--Bosses frame
function BUI.Frames.Bosses_UI()	--UI init
	local ch,ch1=BUI.Vars.FrameHealthColor,BUI.Vars.FrameHealthColor1
	local w,h=BUI.Vars.BossWidth,BUI.Vars.BossHeight
	local fs=math.min(BUI.Vars.RaidFontSize,h*.8)
	--Create the bosses frame container
	local bosses	=BUI.UI.Control(	"BUI_BossFrame",				BanditsUI,	{w,h*3+8},		BUI.Vars.BUI_BossFrame or {TOPRIGHT,TOP,-710/2,5,ZO_CompassFrame},		not BUI.Vars.BossFrame)
	bosses.backdrop	=BUI.UI.Backdrop(	"BUI_BossFrame_BG",			bosses,	"inherit",		{CENTER,CENTER,0,0},		{0,0,0,0.4}, {0,0,0,1}, nil, true) --bosses.backdrop:SetEdgeTexture("",16,4,4)
	bosses.label	=BUI.UI.Label(	"BUI_BossFrame_Label",			bosses.backdrop,	"inherit",		{CENTER,CENTER,0,0},		BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("BF_Label"), false)
	bosses:SetDrawTier(DT_HIGH)
	bosses:SetMovable(true)
	bosses:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	--Iterate over 3 possible bosses
	local anchor	={TOPLEFT,TOPLEFT,0,0,bosses}
	for i=1, MAX_BOSSES do
		local unitTag="boss"..i
		local boss	=BUI.UI.Backdrop("BUI_BossFrame"..i.."_Health",		bosses,	{w,h},		anchor,				{0,0,0,1}, theme_color, nil, true) boss:SetDrawTier(0)
		boss.bar	=BUI.UI.Statusbar("BUI_BossFrame"..i.."_Bar",		boss,		{w-4,h-4},		{LEFT,LEFT,2,0},			ch, BUI.Textures[BUI.Vars.FramesTexture], false)
		boss.bar:SetGradientColors(ch[1],ch[2],ch[3],ch[4],ch1[1],ch1[2],ch1[3],ch1[4])
		boss.name	=BUI.UI.Label(	"BUI_BossFrame"..i.."_Name",		boss,		{w,h},		{LEFT,LEFT,8,0},			BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,1}, 'Name', false)
		boss.pct	=BUI.UI.Label(	"BUI_BossFrame"..i.."_Pct",		boss,		{w,h},		{RIGHT,RIGHT,-8,0},		BUI.UI.Font(BUI.Vars.FrameFont2,fs,true), nil, {2,1}, 'Pct%', false)
		anchor={TOP,BOTTOM,0,4,boss}
		BUI.Frame[unitTag]=boss
	end
	local line	=BUI.UI.Control(	"BUI_BossFrame_Line",				BUI_BossFrame1_Health,	{w,h},		{TOP,TOP,0,0},			false)
	for i=1, MAX_BOSSES do
		line["l"..i]=BUI.UI.Line(	"BUI_BossFrame"..i.."_Line",		line,		{0,h},		{TOPLEFT,TOPLEFT,0,-2},		{.8,.8,.8,.6},1.8, false) line:SetDrawTier(1)
		line["p"..i]=BUI.UI.Label(	"BUI_BossFrame"..i.."_N",		line["l"..i],{(fs-4)*1.5,fs-4},{BOTTOM,TOP,0,-2},		BUI.UI.Font(BUI.Vars.FrameFont2,fs-4,true), nil, {1,1}, '', false)
	end
	local phase	=BUI.UI.Control(	"BUI_BossFrame_Phase",				bosses,	{w,h},		{TOP,BOTTOM,0,0},			true)
	phase.name	=BUI.UI.Label(	"BUI_BossFrame_Phase_Name",			phase,	{w,h},		{LEFT,LEFT,8,0},			BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,1}, 'Name', false)
	phase.timer	=BUI.UI.Label(	"BUI_BossFrame_Phase_Timer",			phase,	{w,h},		{RIGHT,RIGHT,-8,0},		BUI.UI.Font(BUI.Vars.FrameFont2,fs,true), nil, {2,1}, 'Pct%', false)
end

local function Bosses_Update()
	local total=0
	for i=1, MAX_BOSSES do
		local unitTag="boss"..i
		if DoesUnitExist(unitTag) then
			local name=GetUnitName(unitTag)
			BUI.Frame[unitTag]:SetHidden(false)
			local curHealth, maxHealth=GetUnitPower(unitTag, POWERTYPE_HEALTH)
			local _pct=curHealth/maxHealth
			local _color="|cFFFFFF"
			total=total+curHealth
			if Boss_Phase[name] and _pct<1 then
				for _,pct in pairs(Boss_Phase[name]) do
					if _pct>=(pct+3)/100 and _pct<(pct+6)/100 then _color="|cFFFF22"
					elseif _pct>=pct/100 and _pct<(pct+3)/100 then _color="|cFF2222"
					end
				end
			else
				if	(_pct<.25)	then _color="|cFF2222"
				elseif(_pct<.50)	then _color="|cFFFF22"
				end
			end
			BUI.Frame[unitTag].name:SetText(name)
			BUI.Frame[unitTag].bar:SetWidth((BUI.Vars.BossWidth-4)*_pct)
			BUI.Frame[unitTag].pct:SetText(_color..math.floor(_pct*100) .."%|r")
		else
			BUI.Frame[unitTag]:SetHidden(true)
		end
	end
	if total==0 then	--Bosses are dead
--		if BUI.Vars.DeveloperMode and BUI.BossFight then d(BUI.TimeStamp().."|cEE2222Boss fight end|r") end
		BUI.BossFight=false
		BUI.BossKilledMs=GetGameTimeMilliseconds()
		EVENT_MANAGER:UnregisterForUpdate("BUI_Bosses")
		for i=1, MAX_BOSSES do BUI.Frame["boss"..i]:SetHidden(true) end
		BUI_BossFrame_Phase:SetHidden(true)
		BUI_BossFrame_Line:SetHidden(true)
		--Notifications module
		if BUI.Vars.NotificationsTrial then
			BUI.OnScreen.Message[3]={["message"]="",["time"]=0} BUI.OnScreen.Update()	--Horn
		end
	end
	--Phase
	if BUI.BossName and BUI.Vars.NotificationsTrial then
		local _phase=BUI.Phase_Timers[BUI.BossName]
		if _phase and _phase.timer>0 then
			local now=GetGameTimeMilliseconds()
			if _phase.timer-now<=0 then
				_phase.timer=_phase.repeatable and now+_phase.duration or 0
				--Notifications module
				if not _phase.atStart and not _phase.silent then BUI.OnScreen.Notification(_phase.name,"|cFF2222Get ready for|r ".._phase.name) end
			end
			BUI_BossFrame_Phase.timer:SetText((_phase.timer-now<=5000 and "|cFF2222" or "|cFFFFFF")..BUI.FormatTime((_phase.timer-now)/1000).."|r")
		end
	end
end

function BUI.Frames.Bosses_Init(phase)
	local n_bosses=0
	for i=1, MAX_BOSSES do
		local unitTag="boss"..i
		if DoesUnitExist(unitTag) then
			if unitTag=="boss1" then n_bosses=1 
			elseif unitTag=="boss2" then n_bosses=2 
			elseif unitTag=="boss3" then n_bosses=3 
			elseif unitTag=="boss4" then n_bosses=4
			elseif unitTag=="boss5" then n_bosses=5
			end
			BUI.Stats.Bosses[string.gsub(GetRawUnitName(unitTag),"%^%w+","")]=true
		end
	end

	if n_bosses>0 then
		local curHealth, maxHealth, _=GetUnitPower("boss1", POWERTYPE_HEALTH)
		local _pct=curHealth/maxHealth
		--Statistics
		if _pct==1 then BUI.Stats.CombatEnd=true end
		--Notifications
		if BUI.Vars.NotificationFood and BUI.NeedToEat then
			BUI.OnScreen.Notification(0,BUI.Loc("Food"))
			CALLBACK_MANAGER:FireCallbacks("BUI_Food",true)
		end
--[[
		if BUI.Vars.NotificationsTrial and BUI.inCombat then
			if _pct<.96 and _pct>0 then
				if BUI.BossName=="Saint Olms the Just" then BUI.OnScreen.Notification(10,"Additional target arrived!") end
				if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."|cFF2222Additional target arrived!|r "..math.floor(_pct*100).."%") end
			end
		end
--]]
		if BUI.Vars.BossFrame then
			EVENT_MANAGER:RegisterForUpdate("BUI_Bosses", 500, Bosses_Update)
			BUI.BossFight=true
			local _name=(DoesUnitExist("boss1")) and GetUnitName("boss1") or ((DoesUnitExist("boss2")) and GetUnitName("boss2") or false)
			BUI.BossName=_name
			--Phase
			if BUI.Phase_Timers[BUI.BossName] and BUI.Vars.NotificationsTrial then
				BUI_BossFrame_Phase:SetHidden(false)
				BUI_BossFrame_Phase:ClearAnchors()
				BUI_BossFrame_Phase:SetAnchor(TOP,BUI_BossFrame,TOP,0,(BUI.Vars.BossHeight+4)*n_bosses)
				BUI_BossFrame_Phase.name:SetText(BUI.Phase_Timers[BUI.BossName].name)
				if not phase then
					BUI_BossFrame_Phase.timer:SetText("")
					BUI.Phase_Timers[BUI.BossName].timer=0
				end
			end
			--Lines
			phase=phase or Boss_Phase[_name] or Boss_Phase["Any"]
			for i,pct in pairs(phase) do
				control=_G["BUI_BossFrame"..i.."_Line"]
				control:ClearAnchors()
				control:SetAnchor(TOPLEFT,BUI_BossFrame1_Health,TOPLEFT,BUI.Vars.BossWidth*(pct/100)+((pct==100) and -1 or 1),-2)
				control:SetAnchor(BOTTOMRIGHT,BUI_BossFrame1_Health,TOPLEFT,BUI.Vars.BossWidth*(pct/100)+((pct==100) and -1 or 1),(BUI.Vars.BossHeight+4)*n_bosses-2)
--				control:SetHidden(false)
				_G["BUI_BossFrame"..i.."_N"]:SetText(pct)
			end
			BUI_BossFrame_Line:SetHidden(false)
		end
	else
--		if BUI.Vars.DeveloperMode and BUI.BossFight then d(BUI.TimeStamp().."|cEE2222Boss fight end|r") end
		BUI.BossFight=false
		if BUI.Vars.BossFrame then
			EVENT_MANAGER:UnregisterForUpdate("BUI_Bosses")
			for i=1, MAX_BOSSES do BUI.Frame["boss"..i]:SetHidden(true) end
			BUI_BossFrame_Phase:SetHidden(true)
			BUI_BossFrame_Line:SetHidden(true)
		end
		--Notifications module
		if BUI.Vars.NotificationsTrial then
			BUI.OnScreen.Message[3]={["message"]="",["time"]=0} BUI.OnScreen.Update()	--Horn
		end
	end
end

	--Animations
function BUI.Frames.Fade(frame, hide)
	if not frame or BUI.move or BUI.inMenu then return end
	if hide then
		if frame.fade==nil then
			local animation, timeline=CreateSimpleAnimation(ANIMATION_ALPHA,frame,0)
			animation:SetAlphaValues(BUI.Vars.FrameOpacityOut/100,0)
			animation:SetEasingFunction(ZO_EaseOutQuadratic)
			animation:SetDuration((frame==BUI_CurvedTarget or frame==BUI_TargetFrame) and 500 or 1000)
			timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
			frame.fade=timeline
		end
		if not(frame:GetAlpha()<.05 or frame.fade:IsPlaying()) then frame.fade:PlayFromStart() end
	else
		if frame.fade and frame.fade:IsPlaying() then frame.fade:Stop() end
		frame:SetAlpha(BUI.inCombat and BUI.Vars.FrameOpacityIn/100 or BUI.Vars.FrameOpacityOut/100)
		frame:SetHidden(false)
	end
end

function BUI.Frames.Regen(unitTag,unitAttributeVisual,powerType,duration)
	--Declare parameters
	duration		=duration or 1000
	local context	=nil
	local regenType	=nil
	local attrType	=nil
	local distance	=nil
	local member	=nil
	local control	=nil
	--Get the regen type
	if (unitAttributeVisual==ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER) then
		regenType="HoT"
		distance=80
	elseif (unitAttributeVisual==ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER) then
		regenType="DoT"
		distance=-80
	end
	--Determine context
	context=(unitTag=="player") and "Player" or "Target"
	--Get the attribute name
	if (powerType==POWERTYPE_HEALTH) then attrType="Health"
	elseif (powerType==POWERTYPE_STAMINA) then attrType="Stamina"
	elseif (powerType==POWERTYPE_MAGICKA) then attrType="Magicka"
	else return end
	for i=1,((BUI.Vars.FrameHorisontal and powerType==POWERTYPE_HEALTH) and 2 or 1) do
		--Get the parent control
		if i==2 then distance=-distance regenType=regenType=="DoT" and "HoT" or "DoT" end
		control=_G["BUI_"..context.."Frame_"..attrType..regenType]
		if (control==nil) then return end
		--Does the animation need to be set up from scratch?
		if (control.animation==nil) then
			--Set the draw layer
			control:SetHidden(false)
			control:SetAlpha(0)
			control:SetDrawLayer(DL_OVERLAY)
			--Get the position
			local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY=control:GetAnchor()
			--Create an horizontal sliding animation
			local animation, timeline=CreateSimpleAnimation(ANIMATION_TRANSLATE,control,0)
			animation:SetTranslateOffsets(offsetX, offsetY, offsetX + distance, offsetY)
			animation:SetDuration(duration*3/4)
			--Fade alpha coming in
			local fadeIn=timeline:InsertAnimation(ANIMATION_ALPHA,control,0)
			fadeIn:SetAlphaValues(.20,.75)
			fadeIn:SetDuration(duration/4)
			fadeIn:SetEasingFunction(ZO_EaseOutQuadratic)
			--Fade alpha going out
			local fadeOut=timeline:InsertAnimation(ANIMATION_ALPHA,control,duration*1/2)
			fadeOut:SetAlphaValues(.75,.20)
			fadeOut:SetDuration(duration/4)
			fadeIn:SetEasingFunction(ZO_EaseOutQuadratic)
			--Add an extra delay at the end
			local fadeOut=timeline:InsertAnimation(ANIMATION_ALPHA,control,duration*3/4)
			fadeOut:SetAlphaValues(0,0)
			fadeOut:SetDuration(duration/4)
			--Assign the timeline
			control.animation=animation
			control.timeline=timeline
		end
		--Maybe stop the animation
		if (duration==0 and control.animation:IsPlaying()) then
			control.timeline:SetPlaybackLoopsRemaining(1)
		--Otherwise play it normally with a maximum of 5 loops (10 seconds)
		else
			control.timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, 4)
			control.timeline:PlayFromStart()
		end
	end
end

function BUI.Frames:GroupRegen(unitTag,unitAttributeVisual,powerType,duration)
--	duration		=duration or 1000
	local context,regenType,attrType,distance,member,control,i=nil,nil,nil,nil,nil,nil,nil
	--Determine context
	if (IsUnitGrouped('player') and BUI.Vars.RaidFrames) then context="Raid" else return end
	i=GetGroupIndexByUnitTag(unitTag)
	if i==nil then return end
	--Get the regen type
	if unitAttributeVisual==ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER then regenType="HoT" distance=80
	else regenType="DoT" distance=-80 end
	--Get the parent control
	control=_G["BUI_"..context.."Frame"..i.."_"..regenType]
	if control==nil then return end
	--Does the animation need to be set up from scratch?
	if (control.animation==nil) then
		--Set the draw layer
		control:SetHidden(false) control:SetAlpha(0) control:SetDrawLayer(1)
		--Get the position
		local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY=control:GetAnchor()
		--Create an horizontal sliding animation
		local animation, timeline=CreateSimpleAnimation(ANIMATION_TRANSLATE,control,0)
		animation:SetTranslateOffsets(offsetX, offsetY, offsetX + distance, offsetY)
		animation:SetDuration(duration*3/4)
		--Fade alpha coming in
		local fadeIn=timeline:InsertAnimation(ANIMATION_ALPHA,control,0)
		fadeIn:SetAlphaValues(.20,.75)
		fadeIn:SetDuration(duration/4)
		fadeIn:SetEasingFunction(ZO_EaseOutQuadratic)
		--Fade alpha going out
		local fadeOut=timeline:InsertAnimation(ANIMATION_ALPHA,control,duration*1/2)
		fadeOut:SetAlphaValues(.75,.20)
		fadeOut:SetDuration(duration/4)
		fadeIn:SetEasingFunction(ZO_EaseOutQuadratic)
		--Add an extra delay at the end
		local fadeOut=timeline:InsertAnimation(ANIMATION_ALPHA,control,duration*3/4)
		fadeOut:SetAlphaValues(0,0)
		fadeOut:SetDuration(duration/4)
		--Assign the timeline
		control.animation=animation
		control.timeline=timeline
	end
	--Maybe stop the animation
	if (duration==0 and control.animation:IsPlaying()) then
		control.timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, 1)
	--Otherwise play it normally with a maximum of 5 loops (10 seconds)
	else
		control.timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, 10)
		control.timeline:PlayFromStart()
	end
end

local function AttributeDecay()
	local frame=_G["BUI_PlayerFrame"]
	local count=0
	for attribute,value in pairs(Decay) do
		if value>0 then
			local w=value-DecayStep if w<DecayStep then w=0 end
			Decay[attribute]=w
			count=count+w
			local control=frame[attribute]
			if attribute=="health" and BUI.Vars.FrameHorisontal then
				control.bar1:SetWidth(w/2)
				control.bar2:SetWidth(w/2)
			else
				control.bar1:SetWidth(w)
			end
		end
	end
	if count<=0 then EVENT_MANAGER:UnregisterForUpdate("BUI_AttributeDecay") end
end

	--Initialisation
function BUI.Frames:Controls(n)
	theme_color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.CustomEdgeColor
	Border=n and n or BUI.Vars.FramesBorder
	if BUI.Vars.PlayerFrame then
		DecayStep=BUI.Vars.FrameWidth/60
		Frame_Player_UI()
	elseif BUI_PlayerFrame then BUI_PlayerFrame:SetHidden(true) end
	if BUI.Vars.TargetFrame then Frame_Target_UI() elseif BUI_TargetFrame then BUI_TargetFrame:SetHidden(true) end
	if BUI.Vars.RaidFrames then BUI.Frames.Raid_UI() elseif BUI_RaidFrame then BUI_RaidFrame:SetHidden(true) end
	if BUI.Vars.BossFrame then BUI.Frames.Bosses_UI() end

	BUI.Curved.Initialize()
end

function BUI.Frames:Initialize()
	if BUI.Vars.DefaultTargetFrame and BUI.Vars.DefaultTargetFrameText and ZO_TargetUnitFramereticleover then
		ZO_TargetUnitFramereticleoverResourceNumbers:SetHidden(true)
		BUI.UI.Label("BUI_TargetResourceNumbers", ZO_TargetUnitFramereticleover, "inherit", {CENTER,CENTER,0,0}, "ZoFontWinH5", nil, {1,1}, "")
	end
	--Create unit frame UI elements
	BUI.Frames:Controls()
	BUI.init.Frames=true
	--Populate initial frames
	BUI.Frames:SetupPlayer()
	BUI.Frames:SetupTarget()
	if BUI.Vars.RaidFrames then
		BUI.Frames:SetupGroup()
		ZO_PreHookHandler(ZO_GuildRoster,'OnShow', function() if IsUnitGroupLeader('player') then BUI_RaidFrame:SetParent(ZO_GuildRoster) BUI_RaidFrame:ClearAnchors() BUI_RaidFrame:SetAnchor(RIGHT,ZO_GuildRoster,LEFT,0,0) end end)
		ZO_PreHookHandler(ZO_GuildRoster,'OnHide', function() BUI_RaidFrame:SetParent(BanditsUI) BUI_RaidFrame:ClearAnchors() BUI_RaidFrame:SetAnchor(BUI.Vars.BUI_RaidFrame[1],BanditsUI,BUI.Vars.BUI_RaidFrame[2],BUI.Vars.BUI_RaidFrame[3],BUI.Vars.BUI_RaidFrame[4]) end)
	end
	--Activate safety check
	EVENT_MANAGER:RegisterForUpdate("BUI_PlayerFrame",5000,BUI.Frames.SafetyCheck)
end

	--Frames functions
function BUI.Frames:SetupPlayer()
	--Bail if frames are disabled
	if not BUI.init.Frames then return end
	--Custom player frame
	if BUI.Vars.PlayerFrame then
		--Configure the nameplate
		if BUI.Vars.EnableNameplate then
			local level=BUI.Player:GetColoredLevel('player')
			local icon="|t"..BUI.Vars.FrameFontSize*1.2 ..":"..BUI.Vars.FrameFontSize*1.2 ..":"..GetClassIcon(GetUnitClassId('player')).."|t "
			BUI_PlayerFrame_PlateName:SetText(icon..BUI.Player.name.." ("..level..")")
		end
		BUI_PlayerFrame_PlateName:SetHidden(not BUI.Vars.EnableNameplate)
		--Food buff feature
		if BUI.Vars.FrameHorisontal and BUI.Vars.FoodBuff then
			local stats=BUI.GetFoodBuff()
			local w,b1=BUI.Vars.FrameWidth,BUI.border[Border][3]
			for _,stat in pairs({"Health","Stamina","Magicka"}) do
				_G["BUI_PlayerFrame_"..stat]:SetWidth(w*(stats[stat] and 1.25 or 1)+b1*2)
				_G["BUI_PlayerFrame_"..stat.."Bg"]:SetWidth(w*(stats[stat] and 1.25 or 1))
			end
		end
	end
	--Setup alternate bar
	if BUI.Vars.PlayerFrame then
		BUI.Frames:SetupAltBar()
	end
	--Repopulate attributes
	BUI.Player:UpdateAttribute('player', POWERTYPE_HEALTH, nil)
	BUI.Player:UpdateAttribute('player', POWERTYPE_MAGICKA, nil)
	BUI.Player:UpdateAttribute('player', POWERTYPE_STAMINA, nil)
	--Repopulate shield
	BUI.Player:UpdateShield('player', nil, nil)
	--Repopulate trauma
	BUI.Player:UpdateTrauma('player', nil, nil)
end

function BUI.Frames:SetupTarget()
	--Bail if frames are disabled
	if not BUI.init.Frames then return end
	--Ensure the default frame stays hidden
--	if BUI.Vars.TargetFrame and BUI.Vars.DefaultTargetFrame==false then ZO_TargetUnitFramereticleover:SetHidden(true) end
	--Bail out if no target unless we are moving
	if not DoesUnitExist('reticleover') and not BUI.move then
		if BUI_TargetFrame then BUI_TargetFrame:SetHidden(true) end
		return
	end
	--Custom Target Frame
	if BUI.Vars.TargetFrame and BUI_TargetFrame then
		local frame=BUI_TargetFrame
		local accName=GetUnitDisplayName('reticleover')
		local name=(BUI.Vars.FrameNameFormat==2 and accName and accName~="") and accName
		or BUI.Vars.FrameNameFormat==3 and BUI.Target.name.."|cB0B0FF"..(accName or "") .."|r" or BUI.Target.name
		local level=BUI.Player:GetColoredLevel('reticleover')
		local icon,title,rank
		--Players
		if IsUnitPlayer('reticleover') then
			icon=GetClassIcon(GetUnitClassId('reticleover'))
			title=GetUnitTitle('reticleover')
			if title=="" then title=GetAvARankName(GetUnitGender('reticleover'), GetUnitAvARank('reticleover')) end
			rank=GetAvARankIcon(GetUnitAvARank('reticleover'))
		else
			title=GetUnitCaption('reticleover')
			--Champion Mobs
			if BUI.Target.difficulty==2 then
				icon="/esoui/art/lfg/lfg_normaldungeon_down.dds"
			--Boss Mobs
			elseif BUI.Target.difficulty>=3 then
				icon="/esoui/art/unitframes/target_veteranrank_icon.dds"
			--Normal NPCs
			else
				--
			end
		end
		--Boss edge color
		if BUI.Target.difficulty==MONSTER_DIFFICULTY_DEADLY then
			BUI_TargetFrame_Health:SetEdgeColor(.7,0,0,1)
			frame.plate.class:SetColor(1,.2,.2,1)
		else
			BUI_TargetFrame_Health:SetEdgeColor(unpack(BUI.border[Border][5] and {1,1,1,1} or theme_color))
			frame.plate.class:SetColor(1,1,1,1)
		end
		--Populate name plate
--		frame.plate.name:SetText(reaction.."||"..tostring(IsUnitAttackable('reticleover')).."||"..tostring(IsUnitInvulnerableGuard('reticleover')).."/"..tostring(IsUnitJusticeGuard('reticleover')))
		frame.plate.name:SetText(name.." ("..level..")")
		frame.plate.class:SetTexture(icon)
		frame.plate.class:SetHidden(icon==nil)
		frame.lplate.title:SetText(zo_strformat("<<!aC:1>>",title))
		--Populate rank icon
		frame.lplate.rank:SetTexture(rank)
		frame.lplate.rank:SetHidden(rank==nil)
		frame:SetHidden(not BUI.Vars.TargetFrame)
		frame.shield:SetHidden(true)
		frame.trauma:SetHidden(true)
		BUI.Frames.TargetReactionUpdate()
	end
	--Repopulate health
	BUI.Player:UpdateAttribute('reticleover', POWERTYPE_HEALTH)
	--Repopulate shield
	BUI.Player:UpdateShield('reticleover')
	--Repopulate trauma
	BUI.Player:UpdateTrauma('reticleover')
end

function BUI.Frames.TargetReactionUpdate()
	if BUI_TargetFrame then
		local color
		if BUI.Target.Invul then
			color=ReactionColor["INVULNERABLE"]
		else
			color=ReactionColor[GetUnitReaction('reticleover')] or ReactionColor[UNIT_REACTION_NEUTRAL]
		end
		BUI.Target.color=color
		BUI_TargetFrame.health.bar:SetColor(unpack(color))
	end
end

local function SortGroup(list)
	if BUI.Vars.RaidSort==0 then
		if TrialGroupInit then BUI.Frames.Raid_UI() end
		return
	end
	local sorted=false
	if BUI.Vars.RaidSort==1 and not BUI.Aspect then	--Auto
		local SortingRules=TrialSortingRules[BUI.MapId]
		if SortingRules then
			local new_list={}
			for i=1,9 do
				local role=SortingRules[i]
				local tag=nil
				for _,data in pairs(list) do
					if data.role==role then
						tag=data.tag
						table.remove(list,_)
						break
					end
				end
				table.insert(new_list,{tag=tag})
			end
			for i=1,12 do
				if new_list[i]==nil or new_list[i].tag==nil then
					if list[1] then
						local tag=list[1].tag
						table.remove(list,1)
						new_list[i]={tag=tag}
					end
				end
			end
			list=new_list
			sorted=true
		end
		if sorted then
			if not TrialGroupInit then BUI.Frames.Raid_UI() end
		end
	end
	if not sorted then
		if TrialGroupInit then BUI.Frames.Raid_UI() end
		if BUI.Vars.RaidSort==3 then	--By power
			table.sort(list,function(a,b) return a.power>b.power end)
		elseif BUI.Vars.RaidSort==4 then	--By level
			for i,data in pairs(list) do
				list[i].level=GetUnitLevel(data.tag)+GetUnitChampionPoints(data.tag)
			end
			table.sort(list,function(a,b) return a.level>b.level end)
		elseif BUI.Vars.RaidSort==5 then	--By accname
			table.sort(list,function(a,b) return a.accname<b.accname end)
		else	--Auto
			if BUI.Vars.RaidSort==1 and BUI.Aspect then	--By aspect
				for i=1,12 do
					if list[i] then
						local name=BUI.Group[list[i].tag].name
						list[i].aspect=BUI.Group[name].Aspect or 0
					end
				end
				table.sort(list,function(a,b) return a.aspect>b.aspect end)
			else	--By role
				table.sort(list,function(a,b) return a.role>b.role end)
			end
		end
	end
	local index=1
	for i,data in pairs(list) do
		if data and data.tag then
			BUI.Group[i]={role=BUI.Group[data.tag].role,tag=data.tag}
			BUI.Group[data.tag].index=i
			BUI.Group[BUI.Group[data.tag].name].index=i
			index=i
		else
			BUI.Group[i]=nil
		end
	end
	for i=index+1,24 do BUI.Group[i]=nil end
end

function BUI.Frames.GetGroupData()
	BUI.Group.members=GetGroupSize()
	local list,tanks,healers,dds={},{},{},{}
	for i=1,BUI.Group.members do
		local unitTag	=GetGroupUnitTagByIndex(i)
		if unitTag and string.sub(unitTag, 0, 5)=="group" then	-- and DoesUnitExist(unitTag)
			local accname	=GetUnitDisplayName(unitTag)
			local name		=string.gsub(GetUnitName(unitTag),"%^%w+","")
			local role_n	=GetGroupMemberSelectedRole(unitTag)
			local role		=role_n==2 and "Tank" or (role_n==4 and "Healer" or "Damage")
			local marker	=role_n==2 and 1 or (role_n==2 or role_n==4) and 2 or 3
			local class		=GetUnitClassId(unitTag)
			local icon		=GetClassIcon(class)
			if name==BUI.Player.name then BUI.Player.role=role BUI.Player.groupTag=unitTag end
			if accname then
				if not BUI.Group[accname] then BUI.Group[accname]={} end
				BUI.Group[accname].name=name
--				BUI.Group[accname].index=i
				BUI.Group[accname].role=role
				BUI.Group[accname].tag=unitTag
			end
			if name then
				if not BUI.Group[name] then BUI.Group[name]={} end
				BUI.Group[name].accname=accname
				BUI.Group[name].role=role
				BUI.Group[name].index=i
				BUI.Group[name].tag=unitTag
			end
			BUI.Group[i]={role=role,marker=marker,tag=unitTag}
			if not BUI.Group[unitTag] then BUI.Group[unitTag]={} end
			BUI.Group[unitTag].icon=icon
			BUI.Group[unitTag].marker=role_n==2 and "esoui/art/lfg/lfg_icon_tank.dds" or (role_n==4 and "esoui/art/lfg/lfg_icon_healer.dds" or icon)
			BUI.Group[unitTag].name=name
			BUI.Group[unitTag].accname=accname
			BUI.Group[unitTag].role=role
			BUI.Group[unitTag].index=i
			if IsUnitGroupLeader(unitTag) then
				BUI.Group[unitTag].leader=true
				BUI.GroupLeader=unitTag
			else
				BUI.Group[unitTag].leader=nil
			end
			table.insert(list,{tag=unitTag,accname=accname,role=role_n==2 and 5 or role_n,power=BUI.Group[unitTag].power or 0})	--,leader=BUI.Group[unitTag].leader})
			if BUI.GroupMarker[i] then
				BUI.GroupMarker[i]:SetTexture(BUI.Group[unitTag].marker)
				BUI.GroupMarker[i]:SetHidden(not(marker==BUI.Markers))
			end
		else
			BUI.Group[i]=nil
			if BUI.GroupMarker[i] then BUI.GroupMarker[i]:SetHidden(true) end
		end
	end
	for i=BUI.Group.members+1,24 do BUI.Group[i]=nil end
	if #list>1 then SortGroup(list) end
end

function BUI.Frames:SetupGroup()
	--Using group frame
	if BUI.InGroup then
		if BUI.Vars.RaidFrames then
			ZO_UnitFramesGroups:SetHidden(true)
		else
			ZO_UnitFramesGroups:SetHidden(false)
			if BUI_RaidFrame then BUI_RaidFrame:SetHidden(true) end
			return
		end
	elseif not BUI.inMenu then
		if BUI_RaidFrame then BUI_RaidFrame:SetHidden(true) end
		return
	end
	--Set scale
	local scale=BUI.Group.members<=4 and BUI.Vars.SmallGroupScale/100 or BUI.Group.members>12 and BUI.Vars.LargeRaidScale/100 or 1
	if BUI_RaidFrame.scale~=scale then BUI.Frames.Raid_UI(scale) end
	--Get group data
	BUI.Frames.GetGroupData()
	--Iterate over members
	for i=1,24 do
		local unitTag=BUI.Group[i] and BUI.Group[i].tag
		local frame=BUI_RaidFrame["group"..i]
		--Only proceed for members which exist
		if unitTag then	--and DoesUnitExist(unitTag) then
			local member=BUI.Group[unitTag]
			BUI.Group[unitTag].frame=frame
			--Name@AccountName
			local displayname=(member.leader and "|cFFFF22" or (BUI.Vars.SelfColor and member.name==BUI.Player.name) and "|c22FF22" or "")
			..(BUI.Vars.FrameNameFormat==2 and member.accname or BUI.Vars.FrameNameFormat==3 and member.name.."|cB0B0FF"..member.accname.."|r" or member.name).."|r"
			--Determine bar color
			local color=BUI.Vars.ColorRoles and BUI.Vars["Frame"..member.role.."Color"] or BUI.Vars.FrameHealthColor
			local pcolor=color[2]
			--Color bar by role
			frame.health.bar:SetColor(color[1],pcolor,color[3],1)
			frame.lead:SetHidden(not member.leader)
			--Populate nameplate
			local level		=BUI.Player:GetColoredLevel(unitTag)
			local label=(BUI.Group[unitTag].icon and zo_iconFormat(BUI.Group[unitTag].icon,BUI.Vars.FrameFontSize*1.2*BUI_RaidFrame.scale,BUI.Vars.FrameFontSize*1.2*BUI_RaidFrame.scale) or " ").." "..(BUI.Vars.RaidLevels and level.." " or "")..displayname
			frame.name:SetText(label)
			--Populate health data
			BUI.Player:UpdateAttribute(unitTag, POWERTYPE_HEALTH, nil)
			--Change the bar color
			BUI.Frames:GroupRange(unitTag, nil)
			--Display the frame
			frame:SetHidden(false)
		--Otherwise hide the frame
		else
			frame:SetHidden(true)
		end
	end
	--Display custom frames
	BUI_RaidFrame:SetHidden(false)
	--Horn info position
	BUI_HornInfo:ClearAnchors()
	BUI_HornInfo:SetAnchor(TOPLEFT,_G["BUI_RaidFrame"..(math.ceil(BUI.Group.members/BUI.Vars.RaidColumnSize)-1)*BUI.Vars.RaidColumnSize+1],TOPRIGHT,BUI_HornInfo.space,0)
	BUI.init.Group=true
end

function BUI.Frames:GroupRange(unitTag, inRange)
	if not BUI.init.Group or not BUI.Group[unitTag] then return end
	--Retrieve the frame
	local frame=BUI.Group[unitTag].frame
	if frame then
		--If a range status was not passed, retrieve it
		if inRange==nil then inRange=IsUnitInGroupSupportRange(unitTag) end
		--Get player roles
		local role=BUI.Group[unitTag].role
		local color=(BUI.Vars.ColorRoles and role~=nil) and BUI.Vars["Frame"..role.."Color"] or BUI.Vars.FrameHealthColor
		--Darken the color of the bar
		if inRange then
			frame.health.bar:SetColor(unpack(color))
		else
			frame.health.bar:SetColor(color[1]/2, color[2]/2, color[3]/2, 1)
		end
	end
end

function BUI.Frames.Attribute(unitTag, attribute, powerValue, powerMax, pct, shieldValue, traumaValue)
	local frame,group,enabled=nil,false,false
	local ShowMax=BUI.Vars.FrameShowMax
	local pctLabel=(pct*100).."%"

	--Player Frame
	if unitTag=='player' then
		frame		=BUI_PlayerFrame
		enabled	=BUI.Vars.PlayerFrame
		if enabled and BUI.Vars.FramesFade and not BUI.inMenu and BUI.Player.alt==nil then
			if BUI.inCombat or BUI.Player.health.pct<.99 or BUI.Player.magicka.pct<.99 or BUI.Player.stamina.pct<.99 then
				if BUI_PlayerFrame_Base:GetAlpha()<.05 then
					BUI.Frames.Fade(BUI_PlayerFrame_Base)
				end
			elseif not PlayerFrameFadeDelay and BUI_PlayerFrame_Base:GetAlpha()>.05 then
				PlayerFrameFadeDelay=true
				BUI.CallLater("Player_FramesFade",1500,function()
					PlayerFrameFadeDelay=false
					if not(BUI.inCombat or BUI.Player.health.pct<.95 or BUI.Player.magicka.pct<.95 or BUI.Player.stamina.pct<.95) then
						BUI.Frames.Fade(BUI_PlayerFrame_Base,true)
					end
				end)
			end
		end
	--Target Frame
	elseif unitTag=='reticleover' then
		frame		=BUI_TargetFrame
		enabled	=BUI.Vars.TargetFrame
		local dead	=IsUnitDead(unitTag)
		local execute=pct<BUI.Vars.ExecuteThreshold/100
		--Add %% to ZO_Target frame
		if not dead then
			if execute and BUI.Target.health.pct>BUI.Vars.ExecuteThreshold/100 and powerMax>35000 then
				if BUI.Vars.CurvedFrame~=0 then
					BUI.UI.Expires(BUI_Curved_Execute)
				end
				if BUI.Vars.TargetFrame then
					BUI.UI.Expires(frame.execute)
				end
				if BUI.Vars.ExecuteSound then PlaySound(SOUNDS.LOCKPICKING_UNLOCKED) end
			end
			if BUI.Vars.DefaultTargetFrame and BUI.Vars.DefaultTargetFrameText and BUI_TargetResourceNumbers then
				local label=powerValue>100000 and BUI.DisplayNumber(powerValue/1000).."k" or BUI.DisplayNumber(powerValue)
				BUI_TargetResourceNumbers:SetText(label.." ("..pctLabel..")"..(execute and ' |t36:36:/esoui/art/icons/mapkey/mapkey_groupboss.dds|t' or ""))
			end
		end
		--Execute icon
		if BUI.Vars.TargetFrame then
			frame.execute:SetHidden(dead or not execute)
		end
		if BUI.Vars.CurvedFrame~=0 then
			BUI_Curved_Execute:SetHidden(dead or not execute)
		end
		BUI.Target.health={current=powerValue,max=powerMax,pct=pct}
	--Group Frames
	elseif BUI.init.Group and BUI.Group[unitTag] then
		frame=BUI.Group[unitTag].frame
		if not frame then return end
		enabled	=true
		group	=true
		ShowMax	=false
	else return end

	if enabled then
		local short=powerValue>100000 or group
		local label=group and (BUI.Vars.RaidStatValue==3 and "" or BUI.Vars.RaidStatValue==2 and pctLabel or BUI.DisplayNumber(powerValue/1000,1).."k") or
			(short and BUI.DisplayNumber(powerValue/1000,1) or BUI.DisplayNumber(powerValue))
			..(ShowMax and "/".. (short and BUI.DisplayNumber(powerMax/1000,1) or BUI.DisplayNumber(powerMax)) or "")
		local dead=IsUnitDead(unitTag)

		if attribute=="health" then
			if not IsUnitOnline(unitTag) then				
				label,pct,pctLabel,short=BUI.Loc("Offline"),0,"",false
			elseif dead or powerValue<0 then
				label,pct,pctLabel,short=BUI.Loc("Dead"),0,"",false
				if group then
					if frame.dead:IsHidden() then PlaySound(BUI.Vars.GroupDeathSound) end
					frame.dead:SetHidden(false)
					BUI.UI.Expires(frame.dead)
				end
			else
				local add_pct=unitTag=='reticleover' and not BUI.Vars.TargetFramePercents
				label=(traumaValue>0 and "["..BUI.DisplayNumber(traumaValue/(short and 1000 or 1)).."]" or "")..label..(shieldValue>0 and "["..BUI.DisplayNumber(shieldValue/(short and 1000 or 1)).."]" or "")
				if group then frame.dead:SetHidden(true) end
			end
		end

		local control=frame[attribute]
		local w=(group and BUI.Vars.RaidWidth*BUI_RaidFrame.scale-4 or control.bg:GetWidth())
		--Decay animation
		if unitTag=='player' then
			local dw=control.bar:GetWidth()-pct*w dw=dw>0 and dw-Decay[attribute] or dw+Decay[attribute]
			if dw>=DecayStep then
				control.bar1:SetWidth(dw)
				Decay[attribute]=dw
				EVENT_MANAGER:RegisterForUpdate("BUI_AttributeDecay", 50, AttributeDecay)
			end
		end
		control.bar:SetWidth(pct*w)
		control.current:SetText(label..((short and not group) and "k" or ""))
		control.pct:SetText(pctLabel)
	end
end

function BUI.Frames:Shield(unitTag, shieldValue, shieldPct, healthValue, healthMax, traumaValue)
	--Setup placeholders
	local frame,update,group
	--Player Frame
	if unitTag=='player' then
		frame=BUI_PlayerFrame
		update=BUI.Vars.PlayerFrame
	--Target Frame
	elseif unitTag=='reticleover' then
		frame=BUI_TargetFrame
		update=BUI.Vars.TargetFrame
	--Group Frames
	elseif BUI.init.Group and BUI.Group[unitTag] then
		frame=BUI.Group[unitTag].frame
		update=BUI.Vars.RaidFrames
		group=true
	else return end
	--Update custom frames
	if update and frame then
		local width=math.min(shieldPct,1)*(frame.width-4)
		frame.shield:SetWidth(width)
		frame.shield:SetHidden(shieldValue<=0)
			--Update bar labels
		local short=group or healthValue>100000
		local label=(short and BUI.DisplayNumber(healthValue/1000,1) or BUI.DisplayNumber(healthValue))
			..(BUI.Vars.FrameShowMax and "/"..(short and BUI.DisplayNumber(healthMax/1000,1).."K" or BUI.DisplayNumber(healthMax)) or "")
			..((shieldValue>0 or traumaValue>0) and "[" or "")
			..(shieldValue>0 and BUI.DisplayNumber(shieldValue/(short and 1000 or 1)) or "")
			..(traumaValue>0 and "-"..BUI.DisplayNumber(traumaValue/(short and 1000 or 1)) or "")
			..((shieldValue>0 or traumaValue>0) and "]" or "")
		frame.health.current:SetText(label)
	end
end

function BUI.Frames:Trauma(unitTag, traumaValue, traumaPct, healthValue, healthMax, shieldValue)
	--Setup placeholders
	local frame,update,group
	--Player Frame
	if unitTag=='player' then
		frame=BUI_PlayerFrame
		update=BUI.Vars.PlayerFrame
	--Target Frame
	elseif unitTag=='reticleover' then
		frame=BUI_TargetFrame
		update=BUI.Vars.TargetFrame
	--Group Frames
	elseif BUI.init.Group and BUI.Group[unitTag] then
		frame=BUI.Group[unitTag].frame
		update=BUI.Vars.RaidFrames
		group=true
	else return end
	--Update custom frames
	if update and frame then
		local width=math.min(traumaPct,1)*(frame.width-4)
		frame.trauma:SetWidth(width)
		frame.trauma:SetHidden(traumaValue<=0)
			--Update bar labels
		local short=group or healthValue>100000
		local label=(short and BUI.DisplayNumber(healthValue/1000,1) or BUI.DisplayNumber(healthValue))
		..(BUI.Vars.FrameShowMax and "/"..(short and BUI.DisplayNumber(healthMax/1000,1).."K" or BUI.DisplayNumber(healthMax)) or "")
		..((shieldValue>0 or traumaValue>0) and "[" or "")
			..(shieldValue>0 and BUI.DisplayNumber(shieldValue/(short and 1000 or 1)) or "")
			..(traumaValue>0 and "-"..BUI.DisplayNumber(traumaValue/(short and 1000 or 1)) or "")
			..((shieldValue>0 or traumaValue>0) and "]" or "")
		frame.health.current:SetText(label)
	end
end

function BUI.Frames.GroupSynergy()
	local now=GetGameTimeMilliseconds()
	local reset=true
	if BUI_RaidFrame then
		for i, member_data in pairs(BUI.GroupSynergy) do
			if syn==1 or (BUI.Group[i] and BUI.Group[i].role=="Tank") then
				local frame=BUI_RaidFrame["group"..i]
				local syn_table={}
				for id, syn_data in pairs(member_data) do
					local delta=syn_data.t-now
					if delta<=0 then
						if syn_data.u then frame.UltB[syn_data.u]:SetHidden(true) end
						BUI.GroupSynergy[i][id]=nil
					else
						table.insert(syn_table,{t=delta,id=id,u=syn_data.u})
						reset=false
					end
				end
				if #syn_table>0 then
					table.sort(syn_table,function(a,b) return a.t<b.t end)
					local u=ult and 1 or 0
					for _,data in pairs(syn_table) do
						if data.u and data.u~=u then frame.UltB[data.u]:SetHidden(true) end
						frame.UltL[u]:SetText((data.t<3000 and "|cEE2222" or "|cEEEEEE")..math.floor(data.t/1000+.5).."|r")
						frame.UltB[u]:SetCenterTexture(BUI.SynergyTexture[data.id])
						frame.UltB[u]:SetCenterColor(1,1,1,1)
						frame.UltB[u]:SetHidden(false)
						BUI.GroupSynergy[i][data.id].u=u
						u=u+1 if u>syn_count then break end
					end
				end
			end
		end
	end
	if reset then
		BUI.GroupSynergyActive=false
		EVENT_MANAGER:UnregisterForUpdate("BUI_GroupSynergy")
	end
end

--Player effects
function BUI.Frames:PlayerAttributeResize(powerType,gain)
	local stat=(powerType==POWERTYPE_HEALTH and "Health" or (powerType==POWERTYPE_STAMINA and "Stamina" or "Magicka"))
	local w,b1=BUI.Vars.FrameWidth,BUI.border[Border][3]
	_G["BUI_PlayerFrame_"..stat]:SetWidth(w*(gain and 1.25 or 1)+b1*2)
	_G["BUI_PlayerFrame_"..stat.."Bg"]:SetWidth(w*(gain and 1.25 or 1))
	BUI.Player:UpdateAttribute('player', powerType, nil)
end
--	/script BUI.Group['group1'].frame.horn:SetHidden(false)
function BUI.Frames:AttributeVisual(unitTag,effect,gain)
	if unitTag=="player" then
		if gain then
			BUI_PlayerFrame_Resist:SetTexture(effect==ATTRIBUTE_VISUAL_INCREASED_STAT
			and "/esoui/art/icons/gear_malacath_shield_a.dds"
			or "/esoui/art/repair/inventory_tabicon_repair_disabled.dds")
		end
		BUI_PlayerFrame_Resist:SetHidden(not gain)
	elseif BUI.init.Group and BUI.Group[unitTag] and BUI.Vars.StatusIcons then	--Group
		local frame=BUI.Group[unitTag].frame
		if frame then
			if effect==ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER then
				frame.debuff:SetHidden(not gain)
			elseif effect==ATTRIBUTE_VISUAL_DECREASED_STAT then
				frame.resist:SetHidden(not gain)
			elseif effect==20 then
				frame.horn:SetHidden(not gain)
			end
		end
	end
end

function BUI.Frames.DodgeFatigue(value)
	local cur,max=value,value
	local function Update()
		if BUI_PlayerFrame_Dodge then BUI_PlayerFrame_DodgeBar:SetWidth(cur/max*(BUI_PlayerFrame_DodgeBg:GetWidth()-4)) end
		if BUI.Vars.CurvedFrame~=0 then BUI.Curved.Alt(true,cur/max) end
		cur=cur-100
		if cur<=0 then
			EVENT_MANAGER:UnregisterForUpdate("BUI_DodgeFatigue")
			if BUI_PlayerFrame_Dodge then BUI_PlayerFrame_Dodge:SetHidden(true) end
			if BUI.Vars.CurvedFrame~=0 then BUI.Curved.Alt(false) end
		end
	end
	if BUI.Vars.PlayerFrame then BUI_PlayerFrame_Dodge:SetHidden(false) end
	if BUI.Vars.CurvedFrame~=0 then BUI.Curved.Alt(true,cur/max,dodge_icon,{.26,.44,.78,1}) end
	EVENT_MANAGER:UnregisterForUpdate("BUI_DodgeFatigue")
	Update()
	EVENT_MANAGER:RegisterForUpdate("BUI_DodgeFatigue",100,Update)
end

function BUI.Frames.ShowDots(count,total)
	if BUI.Vars.ShowDots then
		if count>0 or BUI.Vars.Theme==7 then
			for i=1,5 do
				if i>total then
					if BUI_PlayerFrame_Dots then
						BUI_PlayerFrame_Dots[i]:SetHidden(true)
					end
					if BUI_CurvedFrame_Dots then
						BUI_CurvedFrame_Dots[i]:SetHidden(true)
					end
				else
					local texture=count>=i and dot_on or dot_off
					local color=count>=i and {1,0,0,1} or theme_color
					if BUI_PlayerFrame_Dots then
						BUI_PlayerFrame_Dots[i]:SetTexture(texture)
						BUI_PlayerFrame_Dots[i]:SetColor(unpack(color))
					end
					if BUI_CurvedFrame_Dots then
						BUI_CurvedFrame_Dots[i]:SetTexture(texture)
						BUI_CurvedFrame_Dots[i]:SetColor(unpack(color))
					end
				end
			end
		end
		if BUI_PlayerFrame_Dots then
			BUI_PlayerFrame_Dots:SetHidden(count==0)
		end
		if BUI_CurvedFrame_Dots then
			BUI_CurvedFrame_Dots:SetHidden(count==0)
		end
	end
end

--Player alt bar
local function GetAvailableEnlightenedPool()
	if IsEnlightenedAvailableForCharacter() then
		return GetEnlightenedPool()*(GetEnlightenedMultiplier() + 1)
	else return 0 end
end

function BUI.Frames:SetupAltBar()
	local done,icon,color,pct=true,"/esoui/art/icons/icon_experience.dds",{.7,.7,0,1},1
	if IsMounted() then
		BUI.Player.alt="mount"
		icon="/esoui/art/icons/mapkey/mapkey_stables.dds"
		color={BUI.Vars.FrameStaminaColor[1],BUI.Vars.FrameStaminaColor[2],BUI.Vars.FrameStaminaColor[3],1}
		local current, maximum, effectiveMax=GetUnitPower('player', POWERTYPE_MOUNT_STAMINA)
		pct=math.min(current/effectiveMax,1)
	elseif IsWerewolf() then
		BUI.Player.alt="werewolf"
		icon="/esoui/art/icons/mapkey/mapkey_undaunted.dds"
		color={0.8,0,0,1}
		local current, maximum, effectiveMax=GetUnitPower('player', POWERTYPE_WEREWOLF)
		pct=math.min(current/maximum,1)
	elseif IsPlayerControllingSiegeWeapon() or IsPlayerEscortingRam() then
		BUI.Player.alt="siege"
		icon="/esoui/art/icons/mapkey/mapkey_borderkeep.dds"
		color={0.8,0,0,1}
		local current, maximum, effectiveMax=GetUnitPower('controlledsiege', POWERTYPE_HEALTH)
		pct=math.min(current/maximum,1)
	elseif BUI.Vars.EnableXPBar then
		BUI.Player.alt=nil
		if (BUI.Player.level>=50) then
			icon="/esoui/art/champion/champion_icon_32.dds"
			color={.7,.7,0,1}
--[[			--Get champion rank
			local rank=GetChampionPointAttributeForRank(GetPlayerChampionPointsEarned()+1)
			--The Warrior
			if rank==1 then icon="/esoui/art/champion/champion_points_health_icon-hud-32.dds" color={0.6,0.2,0}
			--The Mage
			elseif rank==2 then icon="/esoui/art/champion/champion_points_magicka_icon-hud-32.dds" color={0,0.6,1}
			--The Thief
			else icon="/esoui/art/champion/champion_points_stamina_icon-hud-32.dds" color={0.3,0.6,0.1} end
--]]
			--Fetch the current experience level
			maxExp=GetNumChampionXPInChampionPoint(BUI.Player.clevel) or 1
			pct=math.min(BUI.Player.cxp/maxExp,1)
		else
			--Fetch the current experience level
			maxExp=GetUnitXPMax('player')
			pct=math.min(BUI.Player.exp/maxExp,1)
		end
	else
		BUI.Player.alt=nil
		done=false
	end

	if done then
		if BUI.Vars.PlayerFrame then
			local parent=_G["BUI_PlayerFrame_Alt"]
			parent:SetHidden(false)
			parent.icon:SetTexture(icon)
			parent.bar:SetWidth((parent.bg:GetWidth()-6)*pct)
			parent.bar:SetColor(unpack(color))
		end
		if BUI.Vars.CurvedFrame~=0 then BUI.Curved.Alt(true,pct,icon,color) end
	else
		if BUI.Vars.PlayerFrame then BUI_PlayerFrame_Alt:SetHidden(true) end
		if BUI.Vars.CurvedFrame~=0 then BUI.Curved.Alt(false) end
	end
end

function BUI.Frames:UpdateAltBar(powerValue, powerMax, powerEffectiveMax,context)
	if BUI.Player.alt~=context then return end
	local pct=powerValue/powerEffectiveMax
	if BUI.Vars.PlayerFrame then
		local parent=_G["BUI_PlayerFrame_Alt"]
		parent.bar:SetWidth(pct*(parent.bg:GetWidth()-6))

		if BUI.Vars.FramesFade and not BUI.inMenu then
			if BUI.inCombat or BUI.Player.health.pct<.99 or BUI.Player.magicka.pct<.99 or BUI.Player.stamina.pct<.99 or pct<.99 then
				if BUI_PlayerFrame_Base:GetAlpha()<.05 then
					BUI.Frames.Fade(BUI_PlayerFrame_Base)
				end
			elseif not PlayerFrameFadeDelay and BUI_PlayerFrame_Base:GetAlpha()>.05 then
				PlayerFrameFadeDelay=true
				BUI.CallLater("Player_FramesFade",1500,function()
					PlayerFrameFadeDelay=false
					if not(BUI.inCombat or BUI.Player.health.pct<.95 or BUI.Player.magicka.pct<.95 or BUI.Player.stamina.pct<.95 or pct<.95) then
						BUI.Frames.Fade(BUI_PlayerFrame_Base,true)
					end
				end)
			end
		end
	end
	if BUI.Vars.CurvedFrame~=0 then BUI.Curved.Alt(true,pct) end
end

function BUI.Frames:SafetyCheck()
	--Group frames
	if BUI.Vars.RaidFrames then
		BUI.InGroup=IsUnitGrouped('player')
		if BUI.InGroup then BUI.Frames:SetupGroup() elseif not BUI.inMenu and not BUI.move then BUI_RaidFrame:SetHidden(true) end
	end
	if BUI.inCombat then return end --Don't update the player in combat
	if BUI.Vars.PlayerFrame then
		--Make sure attributes are up to date
		if not BUI.inMenu then
			BUI.Player:UpdateAttribute(	'player',POWERTYPE_HEALTH,nil,nil,nil)
			BUI.Player:UpdateAttribute(	'player',POWERTYPE_MAGICKA,nil,nil,nil)
			BUI.Player:UpdateAttribute(	'player',POWERTYPE_STAMINA,nil,nil,nil)
			BUI.Player:UpdateShield(	'player',nil,nil)
			BUI.Player:UpdateTrauma(    'player',nil,nil)
		end
	end
end
