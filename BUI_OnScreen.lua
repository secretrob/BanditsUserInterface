local SpectralCharge,CounterEvent,NotificationSecondary,NotificationsEnabled,inQueue=0,0,{},false,false
local lastEvent,message_map=0,{}
local InterruptResult={
[ACTION_RESULT_FEARED]=true,
[ACTION_RESULT_INTERRUPT]=true,
[ACTION_RESULT_DIED]=true,
[ACTION_RESULT_STUNNED]=true,
[ACTION_RESULT_DIED_XP]=true,
}
local ControlResult={
[ACTION_RESULT_FEARED]=true,
[ACTION_RESULT_INTERRUPT]=true,
[ACTION_RESULT_STUNNED]=true,
}
local DeathResult={
[ACTION_RESULT_DIED]=true,
[ACTION_RESULT_DIED_XP]=true,
}
local action_result={
	[ACTION_RESULT_BEGIN]="|cCCCCCC(|cCCCC00start|cCCCCCC)",
	[ACTION_RESULT_EFFECT_GAINED]="|cCCCCCC(|cCC0000gain|cCCCCCC)",
	[ACTION_RESULT_EFFECT_GAINED_DURATION]="|cCCCCCC(durat)",
	[ACTION_RESULT_INTERRUPT]="|cCCCCCC(|cCCCC00stop|cCCCCCC)",
	[ACTION_RESULT_DIED]="|cCCCCCC(|cCC0000dead|cCCCCCC)",
	[ACTION_RESULT_DIED_XP]="|cCCCCCC(|cCC0000dead|cCCCCCC)",
	[ACTION_RESULT_STUNNED]="|cCCCCCC(|cCC0000stun|cCCCCCC)",
	}
local textures	={
	[0]="/esoui/art/tutorial/inventory_tabicon_food_up.dds",		--Food
	[1]="/esoui/art/icons/ability_undaunted_004.dds",			--Orb
	[2]="/esoui/art/icons/ability_templar_light_strike.dds",		--Shard
	[3]="/esoui/art/icons/ability_ava_003_a.dds",				--Horn
	[4]="/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds",--Dead
	[5]="/esoui/art/tutorial/gamepad/gp_playermenu_icon_character.dds",--Group member
	[6]="/esoui/art/unitframes/gamepad/gp_group_leader.dds",		--Leader
	[7]="/esoui/art/icons/ability_ava_005_a.dds",				--Purge
	[8]="/esoui/art/mounts/ridingskill_ready.dds",				--Reload
--	[9]="/esoui/art/icons/justice_stolen_unique_attunement_sphere.dds",--Sphere
	[9]="/esoui/art/tutorial/gamepad/gp_lfg_healer.dds",			--Healer
	[10]="/esoui/art/icons/poi/poi_groupboss_incomplete.dds",		--Boss
	[11]="/esoui/art/icons/mapkey/mapkey_wayshrine.dds",			--Wayshrine
	[12]="/esoui/art/tutorial/gamepad/achievement_categoryicon_fishing.dds",--Fishing
	[13]="/esoui/art/treeicons/gamepad/gp_collection_indexicon_upgrade.dds",--Gear
	[18]="/esoui/art/icons/ability_debuff_knockback.dds",			--Crowd Control
	[44]="/esoui/art/icons/death_recap_disease_aoe.dds",			--Unstable Void
	[56]="/esoui/art/icons/ability_debuff_reveal.dds",			--Reveal
	[77]="/esoui/art/icons/ability_warrior_021.dds",			--Come to the crown
	[78]="/esoui/art/icons/ability_warrior_018.dds",			--Start fight
	[79]="/esoui/art/icons/ability_mage_019.dds",				--Wipe
	[80]="/esoui/art/icons/passive_sorcerer_037.dds",			--Break
	[9321]="/esoui/art/icons/quest_head_monster_015.dds",			--Strangler
	[6166]="/esoui/art/icons/ability_destructionstaff_004.dds",		--Heat Wave
	[7100]="/esoui/art/icons/ability_destructionstaff_004.dds",		--Hand of Flame
	[15164]="/esoui/art/icons/ability_destructionstaff_004.dds",	--Heat Wave
	[55442]="/esoui/art/icons/ability_destructionstaff_004.dds",	--Heat Wave
	[103555]="/esoui/art/icons/death_recap_shock_melee.dds",		--Voltaic Overload
	[103946]="/esoui/art/icons/collectible_memento_pearlsummon.dds",	--Shadow realm
	}
--	/script local icon=GetAbilityIcon(6166) d("|t16:16:"..icon.."|t") StartChatInput(icon)
local ability_name={
[103555]="Voltaic Overload in",
[100584]="Pestilent Breath: LEFT",
[100886]="Pestilent Breath: CENTER",
[101223]="Pestilent Breath: RIGHT",
[105291]="Spheres",
[105016]="Tentacle",
[111315]="Troll",
[111329]="Wamasu",
[111332]="Haj Mota",
[114213]="Infuser",
[114223]="Colossus",
[114230]="Colossus + Infuser",
[114236]="Colossus + 2x Infusers",
}
local IgnoreTip={
	[1]=true,--Block
	[2]=true,--Exploit
	[3]=true,--Interrupt
	[4]=true,--Dodge
	[11]=true,--HR Area effect
	[12]=true,--HR Area effect
	[13]=true,--Dodge
--	[18]=true,--Crowd Controlled
	[19]=true,--Rooted
	[34]=true,--Spectral charge
	[35]=true,--Dodge
	[40]=true,--Spectral charge
	[41]=true,--Dodge
	[49]=true,--Conversation
	[50]=true,--Shattered
	[69]=true,--Domihaus Shout
	[73]=true,--Maim (AS)
	[74]=true,--Defile (AS)
	[76]=true,--Tremor (Fang Lair)
	[96]=true,[97]=true,--Overload
	[98]=true,[99]=true,--Hoarfrost, Roaring Flare
	[100]=true,[101]=true,--Portal to Shadow world
	[102]=true,--Crushing darkness
	[103]=true,--Razorhorn
	[110]=true,[111]=true,
	[112]=true,--March of Sacrifices
	[126]=true,
	[130]=true,--Block
	}
local IgnoreAbility={
[125050]=true,--Putrid Stalk
[46324]=true,--Crystal Fragments
[38687]=true,--Focused Aim
[105906]=true,[105907]=true,--Crushing Swipe
[74380]=true,--Lunar Platform 8
[104384]=true,[104378]=true,--Zel,Ary Loc Update
[106312]=true,--B4 See Stealth
[108455]=true,[107335]=true,--Hidden Corn
[100877]=true,--Spell Breaker's Protection
[106350]=true,--Blind
[80382]=true,--Bite (Wolf)
[71901]=true,--Sigil of Power
[71948]=true,--Sigil of Health
[71956]=true,--Sigil of Defense
[71959]=true,--Sigil of Haste
[6788]=true,[6800]=true,--(Hoarvor)
[50011]=true,--Dummy
[51487]=true,--Shehai Shockwave
[20546]=true,--Prioritize Hit
[69168]=true,--Purifying Light Heal FX
[20667]=true,--Heal Cast Test
[27278]=true,--Clensing Ritual Dummy
[52515]=true,--Grand Healing Fx
[20663]=true,--Range Cast Test
[41189]=true,--Combat Prayer
[31221]=true,--Skyshard Collect
[36010]=true,--Mount Up
[41467]=true,--Regeneration Dummy
[57466]=true,--Rapid Regeneration Dummy
[57468]=true,--Mutagen Dummy
[95806]=true,--Static Charge (Dark Anchor)
[87876]=true,--Betty Netch Restore Magicka
[86103]=true,--Bull Netch
[37360]=true,--No Light Attacks
[74347]=true,--Lunar Bastion
[74135]=true,--Grant Heightened Sense
[21904]=true,[5362]=true,--(Skeever)
[66094]=true,[66098]=true,--Wildfire
[45508]=true,--Passing Through
[99436]=true,--Slice
[98164]=true,--Reveal
[12437]=true,--Quick Shot
[26382]=true,--Bolt
[76303]=true,[76304]=true,[76305]=true,[76306]=true,[76307]=true,[76308]=true,--(Gloam Wolf)
[2901]=true,--Staff Strike (Hag)
[98331]=true,--Crow Strike (Shrike Crowcaller)
[98204]=true,[95894]=true,[98203]=true,[100551]=true,--(The Imperfect)
[53329]=true,--Warming Aura (DSA)
[87867]=true,--Out of Shield (Caillaoife)
[86921]=true,--Bludgeon (Earthgore Amalgam)
[92977]=true,--Gust of the Grave
[92973]=true,--Chill of the Grave
[16691]=true,--Heavy Attack (Bow)
[15279]=true,--Heavy Attack (1H)
[16041]=true,--Heavy Attack (2H)
[16420]=true,--Heavy Attack (Dual Wield)
[15383]=true,--Heavy Attack (Flame)
[16261]=true,--Heavy Attack (Frost)
[18396]=true,--Heavy Attack (Shock)
[10618]=true,--Quick Strike
[72214]=true,[72217]=true,--Poisoned Arrow
[34917]=true,[34919]=true,--Low Slash
[4798]=true,--Headbutt
[29035]=true,--Quick Strike
[18084]=true,--Burning
[97524]=true,--Rake
[14524]=true,--Shock
[87093]=true,[87280]=true,[4022]=true,[5278]=true,[9642]=true,[4583]=true,[6127]=true,[97282]=true,[5308]=true,[85201]=true,[9287]=true,--Bite
[97489]=true,--Fireball
[6137]=true,--Laceration
[7719]=true,--Shocking Touch
[20507]=true,[8812]=true,[8813]=true,--Double Strike
[62197]=true,[43958]=true,[90826]=true,[71904]=true,[93134]=true,[57832]=true,--Ethernal Guardian(pet)
[87875]=true,[70116]=true,[89103]=true,--Betty Netch
[88361]=true,--Vile Flare
[10735]=true,[49252]=true,[49254]=true,--Blood Craze
[8550]=true,[8551]=true,--Slash
[84815]=true,[84817]=true,--Skaafin Flare
[96304]=true,--Fright Force
[10611]=true,--Flare
[75863]=true,--Chop
[89733]=true,--Strangler Move Track
[90000]=true,[88119]=true,--Lava Ball Tracker
[54593]=true,[97504]=true,[97513]=true,--Flare
[12456]=true,--Ice Arrow
[95660]=true,[95687]=true,[95688]=true,--Oppressive Bolts
[18471]=true,--Flare
[26324]=true,--Lava Geyser
[18472]=true,--Flare
[20508]=true,--Double Strike (Dwarwen Spider)
[76330]=true,[35165]=true,--Agony
[4192]=true,[4200]=true,[4224]=true,[4226]=true,--(Crab)
[76579]=true,[73166]=true,[73214]=true,[73184]=true,[76580]=true,--(Swarm)
[9225]=true,[9226]=true,--(Wasp)
[88979]=true,[88985]=true,--Whirring Blade
[97533]=true,[97535]=true,--Saw
[10639]=true,--Flare
[17965]=true,--Impeding Webs
[12286]=true,--Storm Bound
[41803]=true,--Frostbite
--[80607]=true,[80609]=true,[11317]=true,--(Ghost Bear)
[9743]=true,--Entropic Touch (Banekin)
[7158]=true,[7161]=true,[7170]=true,[14249]=true,[60630]=true,[60641]=true,--(Sabre Cat)
[52286]=true,[52400]=true,[52480]=true,[53431]=true,[52335]=true,--Rain Fire (CoH II)
[7590]=true,--Entropic Bolt (Necromancer)
[11076]=true,--Chasten (Harvester)
[50596]=true,--Shadow Bolt (Twilight)
[4730]=true,[4731]=true,[21929]=true,[5685]=true,--(Spider)
[8429]=true,--Zap (Thunderbug)
[84263]=true,[80578]=true,[80575]=true,[80590]=true,--Tele Out Cata (Craddle of Shadows)
[31247]=true,[31248]=true,[31249]=true,[46648]=true,[49275]=true,--Ensnare (Selene)
[6158]=true,--Flare (Scamp)
[88982]=true,--Serrated Blade
[89307]=true,--Web
[82901]=true,--Revealed
[60768]=true,--Sudden Sacrifice (Dark Anchor)
[102273]=true,--Shadow of the Dead
[108698]=true,--Purge (Yaghra)
[8239]=true,--Hamstrung
[108694]=true,--Lacerate (Yaghra)
[104667]=true,--Shadow Flare
[105176]=true,--Crushing Darkness
[105204]=true,--Crushing Darkness
}
local Trial_Alert_id={
--Rockgrove
[149531]=true,--Blistering Smash
[149648]=true,--Ravenous Chomp
[150065]=true,--Rend Flesh
[150308]=true,--Power Bash
[153181]=true,[156982]=true,--Sunburst
[156995]=true,--Monstrous Cleave
[157265]=true,--Kiss of Poison
[157471]=true,--Uppercut
[149180]=true,[153448]=true,[153450]=true,--Scathing Evisceration
[149414]=true,[157932]=true,--Savage Blitz
[152688]=true,--Cinder Cleave
[150026]=true,--Convoke the Flesh
[155357]=true,--Meteor Swarm
[152414]=true,--Meteor Call
[157236]=true,--Astral Shield
[157243]=true,--Taking Aim
[150137]=true,--Hot Spring
--Kine's Kiss
[139827]=true,--Wrath of Tides
[133685]=true,--Shield Bash
--Sea Adder
[136551]=true,--Swipe
[136546]=true,--Bite
[136563]=true,--Slam
[136591]=true,--Bile Spray
--Gryphon
[136439]=true,--Ravaging Talons
--Yandir
[135324]=true,--Butcher's Blade
--Totems
--133515,133510,133045,133513,136860
[139881]=true,--Totem Picker
--Capitan Vrol
[133808]=true,--Frigid Fog
[133753]=true,[133756]=true,--Thunderous Bash
[135991]=true,--Toppling Blow
--[133913]=true,--Shocking Harpoon	?

--Sunspire
--[121833]=100,[121849]=100,[115587]=100,[123042]=100,--Wing Thrash
[122012]=103,--Storm Crush (Gale-Claw)
[120890]=103,--Crush (Fire-Fang)
[122309]=100,--Flaming Bat
[116836]=true,--Storm Leap
[116820]=true,[116821]=true,[116822]=true,[116824]=true,--Furious Sweeps (Will)
[116955]=true,--Furious Slash (Fury)
[116940]=true,--Fiery Rage (Fury)
--[116962]=true,--Rage of Alkosh (Fury)
[117071]=true,--Shield Bash (Ruin)
[117075]=true,--Shield Charge (Ruin)

[119179]=true,--Pyroclasm
[122124]=true,--Bite
[119549]=100,--Emberstorm
[121723]=100,--Fire Breath
[124546]=true,--Lava Geyser
[119817]=true,--Anvil Cracker
[121722]=106.3,--Focus Fire
[120505]=100,--Meteor
[122216]=100,--Blast Furnace

[119222]=true,--Frostbolt
[115723]=true,--Bite
--[122820]=100,[122821]=100,[122822]=100,--Gravechill
[115702]=300,--Storm Fury	Effect:115858
[119283]=100,--Frost Breath
[119632]=300,--Frozen Tomb
[120838]=true,--Glacial Fist
[114085]=200,--Frost Atro Init

[115443]=true,--Bite
[121980]=100,--Searing Breath
[118562]=300,--Thrash
[118743]=300,[120188]=300,--Sweeping Breath
[117251]=true,--Meteor

[121676]=100,--Time Shift
[121411]=true,--Negate Field
[121422]=true,--Sundering Gale
[121271]=100,--Lightning Storm
[121436]=100,--Translation Apocalypse
[117526]=true,--Soul Tear
[120567]=true,--Stonefist
[120542]=true,--Powerful Slam
--[120848]=true,--Hail of Stone
--Black Rose Prison
[114578]=100,--Portal Spawn
[110898]=true,[111209]=true,[113146]=true,--Taking Aim
[111634]=true,--Heavy Attack
[110814]=true,[111161]=true,--Lava Whip
[111163]=true,--Toppling Blow
[111022]=true,--Meteor
[71787]=100,--Impending Storm
[113208]=100,--Shockwave
[113191]=true,--Latch On
[110181]=100,--Bug Bomb
[99539]=true,--Focal Quake
[99527]=true,--Lacerate
[111541]=true,--Explosive Bash
[92892]=true,--Clash of Bones
[110271]=true,--Minara's Curse
[111683]=true,--Drain Essence
[111659]=100,--Bat Swarm
[113396]=true,[111871]=true,--Uppercut
[114443]=100,--Stone Totem
[114803]=100,--Defiling Eruption
[114453]=300,--Chill Spear	[114455]=true,
[111881]=true,--Barrage of Stone
--[113385]=true,[114629]=true,--Void
[112155]=true,[112158]=true,[112834]=true,--Avoid Death
[111315]=100,--Summon Troll
[111329]=100,--Summon Wamasu
[111332]=100,--Summon Haj Mota
[114213]=100,--Summon Infuser
[114223]=100,[114230]=100,[114236]=100,--Summon Colossus

--Cloudrest
[106375]=true,--Ravaging Blow
[105574]=true,--Lava Whip
[105780]=100,--Shocking Smash
[104755]=true,--Scalding Sunder
[104535]=true,--Nocturnal's Favor
--[104430]=true,[104435]=true,[104439]=true,[104440]=true,[104441]=true,[104442]=true,[104443]=true,--Spn Yaghra Config 1
--[103760]=7,--Hoarfrost
--[103697]=true,--Hoarfrost Synergy
--[103714]=true,--Shed Hoarfrost
[106374]=true,--Chilling Comet
[103531]=307,[110431]=307,--Roaring Flare
--[103946]=102,--Shadow Realm Cast
[105239]=10,--Crushing Darkness
--[105120]=2.2,--SotDead Proj to Corpse
[105673]=true,--Talon Slice
[105975]=true,--Baneful Barb (Monstrosity)
--[103980]=200,--Grant Malevolent Core
[103555]=3,--Voltaic Current
--[87346]=10,--Voltaic Overload
--[105890]=200,--Set Start CD of SRealm
[105291]=100,--SUM Shadow Beads
[105016]=200,--SUM Lrg Tentacle
--[107082]=true,--Baneful Mark
--[107196]=true,--Shade Baneful Mark
--[105597]=200,--Preyed Upon
--[106023]=200,--ZMaja Break Amulet

--Sanctum Ophidia
[78781]=true,--Taking Aim
[51729]=true,--Poison Strike
[56324]=100,--Spear (Mantikora)
[54125]=300,--Quake (Mantikora)
[52442]=300,--Leaping Crush
[52447]=300,--Ground Slam
[57839]=300,[57861]=300,--Trapping Bolts (Ozara)
--[53681]=true,[54690]=true,[53775]=true,[53796]=true,[53812]=true,--Teleport
[53786]=100,--Poison Mist
--[59036]=true,--Serp Target
--[56781]=11,--Magicka Detonation (Serpent)
[56857]=305,--Emerald Eclipse (Serpent)
--[52036]=true,[58663]=true,[82591]=true,[54419]=true,[58669]=true,[82597]=true,[54420]=true,[80794]=true,--Spreading Poison (Troll)
--[52012]=true,--Boulder Toss (Troll)
--[52024]=true,--Rock Toss (Troll)
[52466]=true,--Destructive Aura (Troll)
[58218]=14,--Overcharge (Overcharger)
--[58219]=true,--Overcharge (Overcharger)
[79390]=10,--Call Lightning (Overcharger)
--[79391]=true,--Call Lightning (Overcharger)
[52530]=true,--Venomous Bite

--Hel Ra
[49606]=true,--Heavy Attack (Ra Kotu)
[56354]=true,[10583]=true,[33686]=true,[56243]=true,[33686]=true,[33686]=true,[33686]=true,[48213]=true,--Leap (Celestial Warrior)
[56576]=true,[56578]=true,--Stone Form
[47975]=300,[48267]=300,--Shield Throw
[47819]=true,--Channeled Swipes
--[56667]=true,--Destructive Outbreak
[52213]=true,[52214]=true,--Meteor (Yokeda Kai)
[52207]=true,--Impulse (Yokeda Kai)
[50585]=true,--Yokeda Res Shout
--[28629]=true,--Volley
[47466]=true,--Bash (War-Priest)
[47481]=true,--Obliterate (Destroyer)
[47488]=true,--Uppercut (Destroyer)

--Aetherian Archive
[49583]=300,--Impending Storm (Storm Atronach)
[47898]=310,--Lightning Storm (Storm Atronach)
[48240]=310,--Boulder Storm (Stone Atronach)
[49098]=110,--Big Quake (Stone Atronach)
[49311]=true,--Boulder (Stone Atronach)
[49506]=200,[49508]=200,[49669]=200,--Conjure Axe (Celestial Mage)
[50547]=true,--Slam

--Dragonstar Arena
--[29510]=true,--Thunder Hammer
[74978]=true,--Taking Aim
[52825]=true,--Lethal Arrow
[54792]=true,--Crystal Blast
--[53286]=true,--Crushing Shock
[54608]=true,--Drain Resource
[54053]=true,--Stone Giant (Earth Knight)
[54067]=true,--Fossilize (Earth Knight)
[51352]=true,--Petrify (Gargoyle)
[54841]=true,--Ice Charge (Arena 8)
[54838]=true,--Fire Charge (Arena 8)
[52041]=300,--Blink Strike (Arena 9)
[52746]=true,--Flawless Dawnbreaker
--[52733]=true,--Silver Shards
[53251]=true,--Wrecking Blow
[54833]=true,--Negate Magic
[55442]=300,--Heat Wave
--[16588]=true,--Heat Wave
[52773]=300,--Ice Comet
[55174]=true,--Marked for Death (Hiath the Battlemaster)

--Maelstrom Arena
[72057]=100,--Portal Spawn
[54021]=true,--Release Flame
	--Stage 3 (Drome of Toxic Shock)
[76094]=true,--Strangler
	--Stage 4 (Seth's Flywhell)
--[15954]=100,--Boss (Clockwork Sentry)
	--Stage 5 (Frozen Blood)
[5881]=true,--Smash (Ogre)
[66325]=true,--Shatter
[66378]=true,--Sweep
	--Stage 6 (Spiral Shadows)
[70985]=true,--Carve (Xivilai)
[70963]=true,--Venom Sunder
[70955]=true,--Blight Bomb
[68011]=100,--Web Up Artifact
	--Stage 7 (Vault of Umbrage)
--[71088]=1.6,--Rock Toss (Troll)
[68871]=true,[68909]=true,[68910]=true,[69855]=true,--Volatile Poison
--[69854]=true,[73866]=true,--Volatile Explosion
[71771]=true,--Ball Lightning (Wamasu)
[70695]=true,--Taking Aim 
[68811]=true,--Lightning Charge
[70723]=100,--Rupturing Fog
	--Stage 8 (Igneous cistern)
[67462]=true,--Ignite
[71867]=true,--Empowering Chains
[67516]=true,--Withering Bolt
[67411]=true,--Uppercut
[71172]=true,--Double Slam
	--Stage 9 (Theater of Despair)
[72268]=true,--Pyrocasm
[70809]=true,--Uppercut
--[67527]=true,--Soulwell Die Trigger
--[67354]=true,[67356]=true,--Spectral Charge
--[67359]=true,--Spectral Charge Ready
[67420]=true,[69001]=true,--Necrotic Blast (Voriak Solkyn)
[73182]=true,--Necrotic Swarm (Voriak Solkyn)
[67528]=true,--Necrotic Pulse

--Maw of Lorkhaj
--[57513]=true,[57515]=true,[57469]=true,[57470]=true,[57471]=true,--Grip of Lorkhaj
--[57517]=true,--Grip of Lorkhaj
--[57525]=true,--Glyph (duration 25)
--[59472]=true,[59474]=true,[59534]=true,[59535]=true,[59536]=true,[59537]=true,[59538]=true,--Lunar Aspect
--[59523]=true,[59524]=true,[59527]=true,[59528]=true,[59529]=true,[59629]=true,[59465]=true,--Shadow Aspect
[75460]=true,[75456]=true,--Lunar Conversion
[59698]=true,[59699]=true,--Shadow Conversion
--[59639]=true,--Shadow Aspect Removed
--[59640]=true,--Lunar Aspect Removed
[74488]=4,--Unstable Void (Rakkhat)
[73741]=300,--Threshing Wings
--[74080]=100,[74081]=100,[74083]=100,[74084]=100,[74085]=100,[74086]=100,--Threshing Wings (Rakkhat)
[74384]=5,[74385]=5,[74388]=5,[74390]=5,[74391]=5,[74392]=5,[75965]=5,[75966]=5,[75967]=5,[75968]=5,[78015]=5,[74389]=5,--Dark Barrage
[76064]=true,[73700]=true,--Eclipse Field (Sun-Eater)
[55104]=true,[55105]=true,[59892]=true,[73223]=true,[55099]=true,[55181]=true,[55182]=true,[58459]=true,--Marked for Death
[75674]=true,[75672]=true,--Marked for Death (Big Panthers)
--[57514]=1.6,--Void Bolt (Sun Eater)
[73721]=true,--Void Rush (Shadowguard)
[73053]=true,--Lunar Slam (Shadowguard)
[74035]=302,--Darkness Falls
--[77894]=100,--Darkness Falls Stack
[73258]=true,--Crescent Swing (Savage)
[73249]=true,--Shattering Strike (Savage)
--[74745]=true,--Dark Static (Rakkhat)
[74548]=true,--Searing Shadows (Orb)
--[73676]=1,--Crushing Void (Rakkhat)
[75682]=true,--Deadly Claw
[74670]=true,--Thunderous Smash

--Halls of Fabrication
--[95230]=true,--Venom Injection
[90264]=true,--Lightning Lunge
[90755]=true,--Flux Burst
[90888]=true,--Hack
[91781]=300,--Conduit Spawn
[91792]=true,--Conduit Drain
[90916]=true,--Scalded Debuff
[94747]=true,[94736]=true,--Reducer Overheat
[94759]=true,[94757]=true,--Reactor Overload
--[90409]=true,--Reducer Melting Point
[90715]=200,--Reclaimer Overcharge
[90499]=100,--Fabricant Spawn
[89065]=true,--Clash (Reducer)
[87735]=true,--Powered Realignment--Calefactor
[90889]=true,--Hammer
--[88987]=true,--Discharge (Capacitor)
--[94458]=true,--Planned Obsolescence has failed
--[90581]=true,[90632]=true,[90634]=true,[91358]=true,[91359]=true,[94764]=true,[94765]=true,[94766]=true,[94767]=true,[94939]=true,[94941]=true,[94942]=true,[94944]=true,[94949]=true,[94950]=true,--Catastrophic Discharge
[90428]=true,--Titanic Smash (Assembly General)
--[88036]=true,[94613]=true,--Conduit Strike
--[88041]=true,--Power Leech
[91736]=true,--Taking Aim
[91077]=true,--Draining Ballista
[90688]=true,--Hoist Subject (Dissector)

--Asylum Sanctorium
--[99466]=100,--Defiled Blast (Saint Llothis)
[95545]=307,--Defiling Dye Blast (Saint Llothis)
--[101286]=true,--Shrapnel Storm (Saint Felms the Bold) 20s
[99138]=true,--Teleport Strike (Saint Felms the Bold)
[100437]=true,--Exhaustive Charges (Saint Olms the Just)
[99027]=300,--Manifest Wrath (Saint Felms the Bold)
[98683]=true,--Scalding Roar (Saint Olms the Just)
--[99974]=true,--Eruption (Saint Olms the Just)
--[95466]=true,--Unraveling Energies
[98582]=100,--Trial by Fire
--[96010]=true,--Static Shield
[95585]=100,--Soul Stained Corruption
[15954]=300,--Ordinated Protector
}
local World_Alert_id={
--Provided by Zym:
[72979]=true,--Неблагозвучный удар
[84359]=true,--Пикирование
[84356]=true,--Растерзание
[25504]=true,--Укус Короткозуба (ВБ кагути)
[8244]=true,--Опустошение (ВБ зомби)
[6308]=true,--Электризующее касание
[85082]=true,--Безжалостные клешни (краб, ВБ)
[139956]=true,--Беспощадный удар (медведь)
[2969]=true,--Нападение
[6756]=true,--Паралич
[75173]=true,--Сокрушающие конечности
[13515]=101.5,--Порыв ветра
--[47318]=true,--Ограда
[105210]=true,--Чудовищные клешни
[139115]=true,--Увечья
[133379]=true,--Силовая атака (мать, ВБ)
[132749]=true,--Убийственный удар
[139015]=true,--Электризующее сокрушение
[131085]=true,--Увечья
[139731]=true,--Размашистый удар наискось
[130048]=true,--Откусывание
[31539]=true,--Дурманящие брызги
[31722]=true,--Раздавливание

[7268]=1.2,--Leech
[137148]=true,--Veiled Strike
[135713]=true,--Lingering Spit
[10615]=true,--Raven Storm
--Moongrave Fane
[115942]=true,--Boulder
[115985]=100,--Charge
[128527]=true,--Heavy Slash
[120740]=true,--Lacerate
--Lair of Maarselok
[124045]=100,[123985]=100,--Lunge
--[123831]=true,--Poison Bolt
[123825]=100,--Poison Bolt
[124691]=true,--Azureblight Carrier
[123532]=100,--Sweeping Breath
[123401]=true,--Claw
[124364]=true,--Blighting Bolt
[123402]=true,--Crushing Limbs
--Elsveyr
[109308]=true,--Fiery Oil
[108848]=true,--Volatile Concoction (Zhi)
[83174]=true,--Burning Bolt (Blyhicius)
[120682]=true,--Decapitate (Na'ruzz)
[120690]=true,--Flay (Na'ruzz)
[83504]=true,--Fiery Whip (Sword Master)
[116859]=true,--Crush (Thannar)
[115821]=true,--Rake (Meat of the Discarded)
--Dragons
[123372]=100,--Tail Whip
[124712]=100,--Headbutt
[124550]=100,[124561]=100,--Wing Thrash
[124704]=100,[124708]=100,--Sweeping Breath
[124036]=true,[124041]=true,[124040]=true,--Chomp
[123817]=true,--Bite
[125578]=true,[125577]=true,--Fireball
[117299]=100,--Bursting Fireball
[125074]=true,--Unrelenting Force
[124959]=true,--Iron Hand
[124957]=true,--Anvil Cracker
--Justice
--[78761]="Target was lost",--LOS Tar
[63168]=true,--Cage Talons (Guard)
[63157]=1.6,--Heavy Blow (Guard)
[63094]=1,--Shield Charge (Guard)
[63179]=2,--Flame Shard (Guard)
--Murkmire
[111021]=1,--Voriplasmic Upward Swing
[85395]=true,--Dive
--Summerset
[77087]=true,--Basilisk Powder
[105968]=2.6,--Corpulence (Yaghra Monstrosity)
[98836]=1.6,--Stunning Shock (Storm Shark)
[98934]=4,--Sky Strike (Storm Shark)
[98830]=1.6,--Discharge (Storm Shark)
[108016]=2.7,--Pyroclasm (Nolore Stieve)
[101743]=1,--Mind Blast (K'Garza)
[107994]=1.6,--Pound of Flesh (Waste of Flesh)
[107594]=1.6,--Repulsive Strike (Ruella)
[99551]=1.6,--Spider Slash (Kayliriax)
[99739]=1.6,--Heavy Attack
[100966]=1.6,--Tail Whip (Gilleruk)
[103931]=1.4,--Luminescent Mark (Yaghra Spellwear)
[103606]=2.5,--Clash of Bones
[108057]=true,--Cataclysm (Tendirrion)
[107531]=true,--Lightning Spit (Muustikar)
--Mobs
--[2874]=true,--Staggered (Status effect)
--[26006]=true,[26007]=true,[26008]=true,[26009]=true,--Black Winter
--[36986]=true,--Void
[132134]=true,--Reap
[134109]=true,--Cross Swipe
[133122]=true,--Deep Freeze
[131939]=true,--Vampiric Feed
--[48256]=true,--Boulder Toss
[137450]=true,--Poisoned Dagger
[63684]=true,--Uppercut
[5452]=true,--Lacerate
[7520]=1.6,--Steam Wall (Dwarven sphere)
[14350]=2,--Aspect of Terror
[12459]=2,[4337]=2,--Winter's Reach
[6166]=100,[15164]=100,--Heat Wave
[7100]=100,--Hand of Flame (Xivilai)
[91855]=1.6,--Boulder Toss (Ogrim)
[28499]=1.6,--Trow Dagger
[29400]=1.6,--Power Bash
[29378]=1.6,[82735]=1.6,--Uppercut
[44216]=true,--Negate Magic
[91937]=102,--Burst of Embers (Daedrot)
--[91946]=102,--Ground Tremor (Daedrot)
[9321]=true,--Grapple (Strangler)
[19137]=2,--Haunting Spectre (Ghost)
[13783]=1.6,--Hammer (Centurion)
--[11245]=1.6,--Axe (Centurion)
[16031]=100,--Ricochet Wave (Sphere)
[75867]=1.6,--Clobber (Minotaur)
[36470]=2.5,--Veiled Strike (Voidstalker)
[4817]=1.6,--Unyielding Mace (Flesh Atronach)
[50626]=1.6,--Shadow Strike (Grievous Twili)
[63261]=1.6,--Heavy Blow
[7095]=1.6,--Heavy Attack
[66869]=true,--Pin (Flesh Colossus)
[4864]=true,--Storm Bound (Storm Atronach)
--[12287]=true,--Storm Bound (Storm Atronach)
[38554]=1.6,--Stun (Lurcher)
[64980]=1.6,--Javelin (Vosh Rakh)
--[14096]=1.6,--Heavy Attack (Draugr)
[54027]=3.5,--Divine Leap
--[36460]=true,[63821]=true,--Teleport Strike
[55862]=true,--Storm Bound (Wamasu)
[80413]=true,--Consecrated Ground
[34646]=1.6,--Lava Whip
[93745]=2,--Rending Leap (Clannfear)
--[10259]=true,--Double Swipe (Gargoyle)
[10256]=1.6,--Lacerate (Gargoyle)
[35164]=2,--Agony
[2867]=1.6,--Crushing Leap (Werevolf)
[77473]=1.6,--Shield Charge (Bronzefist)
[84944]=1,--Hollow (Hunger)
--[67872]=1.6,--Sweep (Flesh Colossus)
[76089]=2.5,--Snipe (Lurker)
[5363]=1.6,--Chomp
[3855]=true,--Crushing Limbs (Lurcher)
--Dungeons
	--Spindleclutch I
[22034]=1.6,--Inject Poison (Swarm Mother)
[18078]=1.6,--Web Blast (Whisperer)
[18111]=1.6,--Arachnophobia (Whisperer)
	--Spindleclutch II
[8569]=true,--Devastating Leap (Mad Mortine)
[28093]=true,--Vicious Smash (Blood Spawn)
[27741]=true,--Enervating Seal (Praxin Douare)
[27703]=true,--Harrowing Ring (Praxin Douare)
[4829]=true,--Fire Brand (Flesh Atronach Test!!!)
[27905]=true,--Blood Pool (Vorenor)
	--ICP
[58342]=2.5,--Hircine's Rage (Overfiend)
[83079]=100,--Subjugation
--[72584]=true,--Snare (Overfiend)
[57146]=true,--Venom Sunder (Flesh Sculptor)
[57310]=1.6,--Carve (Flesh Sculptor)
[57271]=true,--Shadow Barrage (Lord Warden)
	--Tempest
[26370]=true,--Crushing Blow (Valaran)
[27826]=1.6,--Crushing Blow (Yalorass)
[5696]=true,--Backstab (Yalorass)
[26712]=100,--Gust of Wind (Stormree)
[26741]=1,--Swift Wind (Stormree)
	--Mazzatun
[82975]=1.6,[76538]=1.6,--Bash (Zatzu)
[76363]=3,--Mucous Spray (Chudan)
[76335]=1,--Barrage of Stone (Stoneshaper)
[76423]=1.6,--Root Slam (Na-Kesh)
[76848]=6,--Taking Aim (Xit-Xaht)
[76464]=true,--Brutal Bellow (Test)
[78326]=true,--Feral Intimidation (Xit-Xaht)
[76939]=true,--Monstrous Intimidation (Xal-Nur)
[77149]=true,--Bog Rush
	--Blackhart
[31362]=true,--Raven Storm (Roost Mother)
[29454]=true,--Breathe Flame (Roost Mother)
	--Arx Corinum
[39437]=true,--Bolt Ballistae (Ixniaa)
[21834]=true,--Venomous Bite
	--Craddle of Shadows
[81054]=true,--Wrath of Mephala (Statue of Mephala)
[79252]=1.6,--Blade Weaver (Dranos Velador)
[79201]=2.4,--Corpulence (Velidreth)
	--Selene
[30896]=true,--Summon Senche Spirit
--[30887]=true,--Leap (Spectral Tige)
	--City of Ash I
[34607]=1.6,--Measured Uppercut (Warden of the Shrine)
[44278]=true,--Lava Geyser (Dark Ember)
[34901]=true,--Blazing Arrow (Razor Master Erthas)
	--City of Ash II
[55513]=true,--Flame Bolt (Valkyn Skoria)
[55426]=true,--Magma Prison (Valkyn Skoria)
[55387]=true,--Meteor Strike (Valkyn Skoria)
[55744]=true,--Bone Flare (Flame Colossus)
	--Darkshade I
[21203]=true,--Extracted Poison (Llothan)
[10425]=true,--Summon Scribs (Hive Lord)
[20915]=true,--Overhead Smash (Hive Lord)
[21111]=true,--Decapitating Swing (Rkugamz)
	--Darkshade II
[16690]=1.6,--Thrust (Netchling)
[31869]=true,--Enervating Trap (Grobull)
	--Crypt of Harts I
[22342]=100,--Rolling Fire (Ilambris-Zaven)
[22338]=true,--Axe Strike (Ilambris-Athor)
[22768]=true,--Induce Horror (Siniel)
	--Crypt of Harts II
[51539]=2.5,--Necrotic Blast (Nerien'eth)
[51988]=true,--Lethal Stab (Nerien'eth)
[51993]=true,--Heavy Slash (Nerien'eth)
[52269]=true,--Bone Shock (Ilambris Amalgam)
[54620]=1.2,--Uppercut (Chamber Guardian)
[51719]=true,--Consuming Horror (Chamber Guardian)
	--Volenfell
[25151]=true,--Summon Wraith (Verres)
[25034]=true,--Crushing Blow (Verres)
[24777]=true,--Tail Swipe (Tremorscale)
[25263]=true,--Decapitation Function (Guardian)
[25262]=true,--Hammer Strike
	--Elden Hollow I
[16834]=1.6,--Executioner's Strike (Akash)
[15114]=true,--Pulling Grasp (Chokethorn)
[9845]=1.6,--Rotting Bolt (Canonreeve)
	--Elden Hollow II
[33052]=true,--Shadow Stomp (Murklight)
[32811]=1.6,--Double Slam (Murklight)
	--WGT
[52975]=3,--Stumbling Blows (Glutton)
[65712]=1.6,--Bash (Xivkin Bulwark)
[65889]=1.6,--Shadow Strike (Grievous Twilight)
[29469]=true,--Thunder Thrall (Dremora Morikyn )
[32852]=1,--Scourge Bolt (The Scion of Wroth)
[26551]=1,--Strike (The Scion of Wroth)
--[61151]=true,--Shock Strike (Molag Kena)
--[69857]=true,--Storm Fury (Molag Kena)
--[61173]=true,--Heavy Shock (Molag Kena)
	--Blessed Crucible
[26212]=true,--Project Toxin (Stinger)
[26035]=1.6,--Gash (Kayd)
[25962]=1.6,--Overpowering Swing (Lava Queen)
[10938]=1,--Catching Flame (Lava Queen)
--Wayrest Sewers
--[4587]=true,--Crushing Chomp (Slimecraw)
[9441]=true,--Dark Lance (Garron)
[25548]=true,--Smite (Varannie Pellingare)
[36442]=true,--Tidal Slash (Varannie Pellingare)
[9648]=true,--Spinning Cleave (Varannie Pellingare)
[9656]=true,--Poisoned Blade (Varannie Pellingare)
[11752]=true,--Penetrating Daggers (Allene Pellingare)
[36396]=true,--Bludgeon (Varaine)
	--Direfrost
[23958]=true,--Frost Breath (Guardian of the Flam)
[24540]=1.6,--Destructive Smite (Guardian of the Flam)
[23791]=1.6,--Teleport (Drodda)
[23601]=true,--Sapping Freeze (Drodda)
	--Craddle of Shadows
[78856]=true,--Tide of Darkness (Khephidaen)
[83734]=true,--Umbral Bolts (Khephidaen)
	--Fungal I
[17046]=1.6,--Haymaker (Ozozai)
[21847]=1.6,--Lunging Strike (Kra'gh)
[17101]=102,--Lightning Field (Kra'gh)
	--Fungal II
[22953]=1.6,--Ripper (Gamine Bandu)
[23022]=1.6,--Shadow Chains (Gamine Bandu)
[23156]=1.6,--Shadow Bolt (Spawn of Mephala)
	--Vault of Madness
[35252]=1.6,--Overhead Smash (Grothdarr)
[35248]=1.6,--Torch Bludgeon (Grothdarr)
[35348]=true,--Potent Ethereal Burst
	--Banished Cells
[18840]=1,--Soul Blast (Hihg Kinglord Rilis)
[33189]=2.5,--Crushing Blow (High Kinlord Rilis)
[49150]=1.6,--Cone of Rot (Maw of the Infernal)
	--Clockwork City
[96354]=1.6,[96359]=1.6,--Steam Punch (Factotum Expurgator)
[97438]=1.6,--Stamp (Kagouti)
--[77089]=true,--Basilisk Powder (Factotum Seeker)
[77019]=1.6,--Pin (Factotum Seeker)
[96365]=1.6,--Shadow Slice
[97170]=true,--Abyss (Whispering Sentinel)
[96422]=true,--Grasping Void (Whispering Sentinel)
[65033]=1.6,--Retaliation (Factotum Adjudicator)
--[70070]=1.6,--Heavy Strike
[97525]=1,--Pinning Leap (Dancing Spider)
[94074]=1.6,--Dorsal Spin (Verminous Fabricant)
[96728]=2,--Charge (Kagouti Fabricant)
[96196]=1.6,--Essence of Terror
[98415]=true,--Carrion Call (Shrike Crowcaller)
[98423]=true,--Sting of Despair (Shrike Crowcaller)
--[88334]=true,--Pool of Shadow (Skaafin Masquer)
[88327]=true,--Shadeway (Skaafin Masquer)
[78432]=1.6,--Lunge (Factotum Seeker)
[96433]=1.6,--Gloam Slash
[73172]=true,--Swarm
--World bosses
[83847]=1.6,--Savage Leap (Rageclaw)
[75161]=1.6,--Scourge Bolt (Zandadunoz)
[75150]=1.6,--Soul Flame (Zandadunoz)
[89309]=2,--Hollow (Wuyuvus)
[82879]=true,--Colossal Kick (Lonely Papa)
[82880]=true,--Heavy Stomp (Lonely Papa)
[82878]=true,--Sweeping Strike (Lonely Papa)
[82881]=true,--Thunderous Swing (Lonely Papa)
[83009]=true,--Rending Leap (Snapjaw)
[77906]=true,--Stun (Capitan Blanchete)
[83372]=true,--Surging Inferno (Dayarrus)
[88120]=true,--Ravening Blaze (Night Sister Kamira)
[83180]=true,--Molten Pillar (Big Ozur)
[83930]=true,--Trapping Bolt (Trapjaw)
[26641]=true,--Soul Flame (Ozozzachar)
[74833]=true,--Venomous Bite (Syvarra)
[92083]=1,--Slam (Hive Lord)
[97773]=.5,--Murder (Ithoxis)
[83430]=1.6,--Skeletal Smash (Duriatundur)
[83429]=1,--Frost Rush (Duriatundur)
[64125]=1.6,--Poison Spit (Garil)
[83590]=101.8,--Burst of Embers (Urrai)
[81215]=102,--Shock Aura (Panthius)
[81217]=1.6,--Thunder Hammer (Panthius)
[78360]=1.6,--Wallop (Limenaruruus)
[9674]=2.8,--Resonate (Zalgaz)
[85759]=1.6,--Disorienting Leap (Mehz the Conzener)
[87038]=1.5,--Spinning Blades (Barbas)
[107345]=1.6,--Snowflake (Alluri)
[75219]=1.6,--Hammer (Nyzchaleft)
[75220]=1.6,--Axe (Nyzchaleft)
[26124]=1.6,--Shatter (Longstride)
[104479]=true,--Reave (Sheefar)
[75169]=true,--Uppercut (Edu)
--Bloodroot Forge
--[87012]=true,--Choking Poison (Strangler)
[87328]=true,--Lunge
[86910]=100,--Chill of Winter (Caillaoife)
[87424]=1,[88138]=1,--Wave of Earth
[88182]=1.6,--Mantle Breaker
--[75863]=true,--Chop (Dreadhorn Earthgorer)
[90115]=4,--Lava Geyser (Dreadhorn Earthgorer)
[90178]=true,--Flames of Retribution (Dreadhorn Firehide)
[86914]=2,--Anvil Cracker (Earthgore Amalgam)
[87035]=true,--Drown in Flame (Earthgore Amalgam)
[87320]=1,--Slam (Mathgamain)
[55909]=1.6,--Grasping Vines
--Falkreath
[75872]=1.6,--Flying Axe (Dreadhorn Wallbraker)
[93133]=1.6,--Clobber (Dreadhorn Wallbrake)
[95291]=100,--Shout of Desolation
--[95770]=true,--Hoarfrost Charms
[93146]=1.6,--Lava Whip
[93158]=true,--Deathlord's Fury
[92679]=true,--Sweeping Tusks (Mamonth)
[92255]=1.6,--Charge (Mammoth)
[92239]=3,--Stomp (Mammoth)
[93149]=1.6,--Toppling Blow
[47095]=true,--Fire Rune
[92999]=1.6,--Fiery Blast (Domihaus)
[92873]=1.6,--Death's Herald (Ergogar)
--Scalecaller Peak
--[100106]=2,--Dragon's Fury
[99460]=1.6,--Crushing Blow (Orzun)
[99527]=2.5,--Lacerate (Gargoyle)
[100947]=6,--Taking Aim (Prestilent Archar)
[101685]=1.6,--Power Bash (Mortieu's Guard)
[15715]=1.6,--Obliterate (Giant)
[100584]=100,[100886]=100,[101223]=100,--Pestilent Breath
[99723]=100,--Inferno's Hold
[99881]=true,--Terrorizing Tremor Tracker
--[101084]=100,--Glacial Impact
--Fang Lair
[92892]=2.5,--Clash of Bones (Colossus)
--[102421]=102,--Flaming Whirlwind (Ulfnor)
[98667]=1.6,--Uppercut (Ulfnor)
[98827]=true,--Coup De Grace (Ulfnor)
[96687]=2.5,--Revolting Scarab (Thurvokun)
[96885]=true,--Bilious Blight (Thurvokun)
[96556]=true,--Necrotic Swarm (Orryn)
--[98960]=true,--Baleful Stare
--[99136]=true,--Baleful Stare
--[102342]=true,--Dormant
--[103328]=true,--Death Grip
[97117]=true,--Uppercut
--Moon Hunter Keep
[105303]=9,--Taking Aim
[110225]=true,--Crushing Leap
[105494]=true,--Crushing Limbs (Maze Guardian)
[104196]=true,--Root Stomp (Maze Guardian)
[103587]=true,--Shred (Mylenne)
[104859]=true,--Feral Slam (Hulking)
[102107]=true,--Crushing Leap
[108569]=true,--Ravaging Blow
[104863]=100,--Pounce
[104922]=true,--Lunge
[103994]=true,--Rending Slash (Vykosa)
[111845]=true,--Devastating Leap
[105324]=true,--Devastating Leap
[108152]=true,--Dire Lunge (Dire Wolf)
[113626]=100,--Time to Switch
[104044]=true,--Grapple
[103951]=true,--Lunge
[111655]=true,--Lunge
--March of Sacrifices
[106808]=1.6,--Ravaging Blow (Bulky)
[107955]=true,--Slaughtering Strike (Balofgh)
[107697]=1.6,--Power Bash (Ursus)
[107711]=1,--Shield Charge (Ursus)
[108564]=2.5,--Fetid Globule (Lurcher)
[107323]=2.3,--Horn Burst
[108155]=1.6,--Crushing Leap
[106727]=2.2,--Venomous Slam (Balrogh)
[112386]=300,--Fiery Eruption (Balrogh)
[107624]=100,--Electric Water
[107777]=100,--Venomous Spores
[111420]=true,--Trapping Bolt
[107654]=true,--Taking Aim
[111472]=true,--Sunder
--Malatar
[114349]=true,--Ravaging Blow
[114340]=100,--Jagged Ice
[112767]=true,--Dissonant Blow (Symphony of Blades)
[113707]=true,--Meridian Destruction (Symphony of Blades)
[113631]=true,[113243]=true,--Sunburst
[113650]=true,--Ice Pillar
[113173]=true,--Smiting Dawn
[114112]=true,--Decrepify
[114075]=true,--Gelid Globe
--Frostvault
[117294]=true,--Rotbone
[117310]=true,--Uppercut
[117287]=true,--Crushing Blow
[109121]=true,--Colossal Smash (Tzogvin)
[109205]=true,--Bola Ball
[109574]=true,--Fire Power
[117348]=true,--Shield Bash
[113465]=100,--Reverberating Smash
[109925]=true,--FRONT - BACK LEFT
[109957]=true,--BACK - FRONT RIGHT
[109962]=true,--FRONT - SLIGHT LEFT/RIGHT
--[109663]=100,--Frost Volley
[112999]=100,--Targeted Salvo
[112995]=true,--Hammer
--[112996]=true,--Hack
[115615]=100,--Grind L Arm FX

[109932]=true,--Enfeebling Effluvium
[115310]=true,--Skeev Charge Key
[118251]=true,--Steam Suppression
[114930]=true,--Scattered Embers
[114923]=true,[114924]=true,--Disintegration Protocol
[114939]=true,--Ignite
[116300]=true,--Grind Collision Off
[117491]=true,--Whipping Bolts

}
local Control_id_alert={
[88041]=true,--Power Leech
[44352]=true,--Soul Tether
[63822]=true,--Teleport Strike
[47968]=true,--Stun (Imp AA)
[48237]=true,--Fury Unleashed (AA)
[69764]=true,--Consuming Energy (ICP)
[9220]=true,--Doom-Truth's Gaze (Watcher ICP)
[70794]=true,--Unavoidable Knockdown (Gravelight Sentry ICP)
[35865]=true,--Shadow Cloak
[76328]=true,--Agony
[14935]=true,--Charge
[88339]=true,--Shadeway (Skaafin Masquer)
[93755]=true,--Rending Leap (Clannfear)
[6412]=true,--Dusk's Howl (Winged Twilight)
[91871]=true,--Boulder Toss (Ogrim)
[36868]=true,--Scorching Flames (Uulgarg the Risen)
[32672]=true,--Double Swipe (Gargoyle)
[35647]=true,--Terrifying Roar (Uulgarg)
[46568]=true,--Teleport Strike
[47483]=true,--CON_Knockback
[33164]=true,--Incite Fear (Bogdan)
[30905]=true,--IntroKB (Spectral Tiger leap)
}
local Control_id={
[88041]=1,--Power Leech
[44352]=1,--Soul Tether
[63821]=1,[63822]=1,[46568]=1,[66063]=1,--Teleport Strike
[29380]=1,--Uppercut
[47968]=1,--Stun (Imp AA)
[48237]=1,--Fury Unleashed (AA)
[69764]=1,--Consuming Energy (ICP)
[9220]=1,--Doom-Truth's Gaze (Watcher ICP)
[70794]=1,--Unavoidable Knockdown (Gravelight Sentry ICP)
[35865]=1,--Shadow Cloak
[37084]=1,--Aspect of Terror
[76328]=1,--Agony
[29402]=1,--Power Bash
[96428]=1,--Grasping Void
[14935]=1,--Charge
[36471]=1,--Veiled Strike
[97530]=1,--Pinning Leap (Dancing Spider)
[97444]=1,--Stamp (Kagouti Fabricant)
[88339]=1,--Shadeway (Skaafin Masquer)
[93755]=1,--Rending Leap (Clannfear)
[6412]=1,--Dusk's Howl (Winged Twilight)
[91871]=1,--Boulder Toss (Ogrim)
[36868]=1,--Scorching Flames (Uulgarg the Risen)
[14926]=1,--Charge
[19138]=1,[19140]=1,[98598]=1,--Haunting Spectre
[32672]=1,[25716]=1,--Stun (Gargoyle)
[97530]=1,--Pinning Leap
[79930]=1,--Lunge (Factotum Seeker)
[47483]=1,--CON_Knockback
[23601]=1,--Sapping Freeze (Direfrost)
[33164]=1,--Incite Fear (Bogdan)
[30905]=1,--IntroKB (Spectral Tiger leap)
[47608]=1,--Knocked Down (Shadowrend)
[20226]=1,--Stun (Flesh Atronach)
[26110]=1,--The Feast (Harvester)
[22602]=1,[73925]=1,[99214]=1,--Soul Cage (Lich)
[26064]=1,--Intimidating Roar
[8069]=1,--Intimidating Roar (Ogre)
[74130]=1,--Intimidating Roar (Giant)
[26064]=1,--Intimidating Roar (Blessed Crucible)
[31001]=1,--Horrifying Roar (Selene)
[75439]=1,--Thunderous Roar
[35647]=1,--Terrifying Roar (Uulgarg)
[70105]=1,--Corrupt Water Stun (ICP)
[26938]=1,--Enervating Stone (Tempest)
[32696]=1,--Soul Flame(Titan)
[87247]=1,--Devour (Hunger)
[86983]=1,--Succubus Touch
[73987]=1,--No Scream Knockdown
[73680]=1,--Crushing Void Stun (Rakkhat)
[52051]=1,--Blink Strike
[83910]=1,--Guar Stomp (Bittergreen)
[2874]=2,[74794]=2,[88510]=2,--Staggered
[43817]=2,--Shockwave Snare
[93748]=1,--Rending Leap Ranged
[26212]=1,--Project Toxin
[104958]=1,--Totem of Terror
[26037]=1,--Gash
[26212]=1,--Project Toxin
[110098]=1,--Downed
[117934]=1,--Don't Target Curses
[102484]=1,--Mind Blast
[13950]=1,--Flurry
[112211]=1,--Grapple Stun
[98836]=1,--Stunning Shock
[110055]=1,[110097]=1,--Downed
[104509]=1,--Reave
[31869]=1,--Enervating Trap
}
local Interrupt_id={
[110898]=true,[111209]=true,[113146]=true,[74978]=true,[70695]=true,[91736]=true,[76848]=true,[105303]=true,[100947]=true,--Taking Aim
[73182]=true,--Necrotic Swarm
[112999]=true,--Targeted Salvo
[16031]=true,--Ricochet Wave (Sphere)
[112999]=true,--Targeted Salvo
}
--Glyphs
local curseCount,knownGlyphs,glyphTimers=0,{},{}
local glyphs={{x=.555, y=.2917},{x=.5634, y=.254},{x=.6, y=.2487},{x=.623, y=.2625},{x=.6405, y=.2977},{x=.625, y=.327},}

local function Glyphs_Init()
	local size	=32
	local anchor=(BUI.Vars.BUI_Glyphs) and BUI.Vars.BUI_Glyphs or {BOTTOMRIGHT,BOTTOMLEFT,0,0,QuickslotButton}
	--Create the glyphs frame container
	local ui		=BUI.UI.Control(	"BUI_Glyphs",			BanditsUI,	{(size+10)*3,(size+10)*3},	anchor,				not BUI.Vars.Glyphs)
	ui.backdrop		=BUI.UI.Backdrop(	"BUI_Glyphs_BG",			ui,	"inherit",				{CENTER,CENTER,0,0},		{0,0,0,0.4}, {0,0,0,1}, nil, true) --ui.backdrop:SetEdgeTexture("",16,4,4)
	ui.label		=BUI.UI.Label(	"BUI_Glyphs_Label",		ui.backdrop,	"inherit",				{CENTER,CENTER,0,0},		BUI.UI.Font("trajan",20,true), nil, {1,1}, "MoL Glyphs")
	ui:SetDrawTier(DT_HIGH)
	ui:SetMovable(true)
	ui:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	anchor	={TOPRIGHT,TOPRIGHT,0,0,ui}
	for i=1, 6 do
		local glyph	=BUI.UI.Statusbar("BUI_Glyph"..i.."_Bar",		ui,	{size*2,size*2},			anchor,				nil, "/esoui/art/crafting/crafting_enchanting_glyphslot_pentagon.dds", false)
		glyph.timer	=BUI.UI.Label(	"BUI_Glyph"..i.."_Timer",	glyph,	{size,size},			{CENTER,CENTER,0,0},		BUI.UI.Font(BUI.Vars.FrameFont1,16,true), nil, {1,1}, "", false)
		if i<6 then anchor=(i>2) and {RIGHT,LEFT,0,0,_G["BUI_Glyph".. 6-i .."_Bar"]} or {TOP,BOTTOM,0,5-size,glyph} end
	end
	BUI.init.Glyphs=true
end

local function FindGlyph(glyphId)
	if not knownGlyphs[glyphId] then
		local lowestDistance=99999
		local lowestIndex=0
		local lowestUnit=""
		for index, data in ipairs(glyphs) do
			for i=1, BUI.Group.members do
				if IsUnitOnline("group"..i) then
					local pX, pY=GetMapPlayerPosition("group"..i)
					if (knownGlyphs[index] == nil) then
						local distance=math.sqrt((pX-data.x)^2+(pY-data.y)^2)*1000
						if (distance<lowestDistance) then
							lowestDistance=distance
							lowestIndex=index
							lowestUnit=GetUnitName("group"..i)
						end
					end
				end
			end
		end
		if lowestDistance<8 and lowestIndex>0 then
--			if BUI.Vars.DeveloperMode then d(ZO_CachedStrFormat("[<<1>>]Glyph N<<2>> used by <<3>>", glyphId,lowestIndex,lowestUnit)) end
--			knownGlyphs[lowestIndex]=glyphId
--			knownGlyphs[glyphId]=lowestIndex
			return lowestIndex
		else
			return 0
		end
	else
		return knownGlyphs[glyphId]
	end
end

local function GlyphTimers()
	local _now=GetGameTimeMilliseconds()
	for i=1,6 do
		color={1,1,1,1}
--		local color=(curseCount<4 and i<4) and {1,0,0,1} or {1,1,1,1}
		_G["BUI_Glyph"..i.."_Bar"]:SetColor(unpack(color))
		if glyphTimers[i] then
			local t=math.floor((glyphTimers[i]+25000-_now)/1000)
			if t>0 then
				_G["BUI_Glyph"..i.."_Timer"]:SetText(t)
				_G["BUI_Glyph"..i.."_Bar"]:SetColor(color[1]/2,color[2]/2,color[3]/2,1)
			else
				glyphTimers[i]=nil
				_G["BUI_Glyph"..i.."_Timer"]:SetText("")
				_G["BUI_Glyph"..i.."_Bar"]:SetColor(unpack(color))
			end
		end
	end
end

local function OnGlyphs(_,result,_,_,_,_,_,_,_,_,_,_,_,_,_,targetUnitId,abilityId)
--	local _res=(result==ACTION_RESULT_BEGIN) and "(start)" or ((result==ACTION_RESULT_EFFECT_GAINED) and "(gain)" or ((result==ACTION_RESULT_EFFECT_GAINED_DURATION) and "(durat)" or "(fade)"))
--	d(BUI.TimeStamp().."["..abilityId.."] "..GetAbilityName(abilityId).." ".._res..": "..hitValue.." ||"..sourceUnitId..">"..targetUnitId)
	if abilityId==57525 then
		if result==ACTION_RESULT_EFFECT_FADED then
			glyphTimers[FindGlyph(targetUnitId)]=GetGameTimeMilliseconds()
		else
			glyphTimers[FindGlyph(targetUnitId)]=0
		end
	elseif abilityId==57517 and result==ACTION_RESULT_EFFECT_GAINED_DURATION then
		curseCount=curseCount+1 if curseCount>=4 then curseCount=0 end
	end
end

local function Glyphs_Show(show)
	if not BUI.Vars.Glyphs then return end
	if show then
		if not BUI.init.Glyphs then Glyphs_Init() end
		BUI_Glyphs:SetHidden(false)
		EVENT_MANAGER:RegisterForUpdate("BUI_Glyphs", 1000, GlyphTimers)
		EVENT_MANAGER:RegisterForEvent("BUI_Glyphs1", EVENT_COMBAT_EVENT,		OnGlyphs)
		EVENT_MANAGER:AddFilterForEvent("BUI_Glyphs1", EVENT_COMBAT_EVENT,	REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED_DURATION, REGISTER_FILTER_IS_ERROR, false)
		EVENT_MANAGER:AddFilterForEvent("BUI_Glyphs1", EVENT_COMBAT_EVENT,	REGISTER_FILTER_ABILITY_ID, 57517)
		EVENT_MANAGER:RegisterForEvent("BUI_Glyphs2", EVENT_COMBAT_EVENT,		OnGlyphs)
		EVENT_MANAGER:AddFilterForEvent("BUI_Glyphs2", EVENT_COMBAT_EVENT,	REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_FADED, REGISTER_FILTER_IS_ERROR, false)
		EVENT_MANAGER:AddFilterForEvent("BUI_Glyphs1", EVENT_COMBAT_EVENT,	REGISTER_FILTER_ABILITY_ID, 57525)
	elseif BUI.init.Glyphs then
		BUI_Glyphs:SetHidden(true)
		EVENT_MANAGER:UnregisterForUpdate("BUI_Glyphs")
		EVENT_MANAGER:UnregisterForEvent("BUI_Glyphs1", EVENT_COMBAT_EVENT)
		EVENT_MANAGER:UnregisterForEvent("BUI_Glyphs2", EVENT_COMBAT_EVENT)
	end
end

--Notifications
function BUI.OnScreen.UI_Init()
	local fs	=BUI.Vars.NotificationsSize
	local w	=800
	--Create Primary Notifications frame container
	local ui		=BUI.UI.Control(	"BUI_OnScreen",			BanditsUI,	{w,30},	BUI.Vars.BUI_OnScreen,	false)
	ui.backdrop		=BUI.UI.Backdrop(	"BUI_OnScreen_BG",		ui,		{w,30},	{BOTTOM,BOTTOM,0,0},	{0,0,0,0.4}, {0,0,0,1}, nil, true)	--ui.backdrop:SetEdgeTexture("",16,4,4)
	ui.label		=BUI.UI.Label(	"BUI_OnScreen_Label",		ui.backdrop,		{w,30},	{BOTTOM,BOTTOM,0,0},	BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("NotP_Label"))
	ui:SetDrawTier(DT_HIGH)
	ui:SetMovable(true)
	ui:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	--Iterate over 5 possible messages
	local anchor	={TOP,TOP,0,-fs*1.5*5,ui}
	for i=1, 5 do
		ui[i]=BUI.UI.Label(	"BUI_OnScreenMessageP"..i,	ui,		{w,fs*1.5},	anchor,			BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {1,1}, '', false)
		anchor={TOP,BOTTOM,0,0,ui[i]}
	end
	--Create Secondary notifications frame container
	fs=fs*.75
	w=w*.75
	local ui		=BUI.UI.Control(	"BUI_OnScreenS",			BanditsUI,	{w,30},	BUI.Vars.BUI_OnScreenS,	false)
	ui.backdrop		=BUI.UI.Backdrop(	"BUI_OnScreenS_BG",			ui,		{w,30},	{BOTTOM,BOTTOM,0,0},	{0,0,0,0.4}, {0,0,0,1}, nil, true)
	ui.label		=BUI.UI.Label(	"BUI_OnScreenS_Label",		ui.backdrop,		{w,30},	{BOTTOM,BOTTOM,0,0},	BUI.UI.Font("standard",20,true), nil, {1,1}, BUI.Loc("NotS_Label"))
	ui:SetDrawTier(DT_HIGH)
	ui:SetMovable(true)
	ui:SetHandler("OnMouseUp", function(self) BUI.Menu:SaveAnchor(self) end)
	--Iterate over 5 possible messages
	for i=1, 5 do
		ui[i]=BUI.UI.Label(	"BUI_OnScreenMessageS"..i,		ui,		{w,fs*1.5},	{BOTTOM,BOTTOM,0,-(i-1)*fs*1.5,ui},	BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {1,1}, '', true)
		local animation, timeline=CreateSimpleAnimation(ANIMATION_SCALE,ui[i],0)
		animation:SetScaleValues(1, 1.2) animation:SetDuration(300)
		ui[i].animation=animation ui[i].timeline=timeline
		ui[i].timeline:SetPlaybackType(ANIMATION_PLAYBACK_PING_PONG,1)
	end
	--Arrow bar
	local width=60
	local texture=BUI_ArrowBar or WINDOW_MANAGER:CreateControl("BUI_ArrowBar", ZO_ReticleContainerReticle, CT_TEXTURE)
	texture:SetDimensions(width,width/3*2)
	texture:ClearAnchors()
	texture:SetAnchor(BOTTOM,ZO_ReticleContainerReticle,CENTER,0,0)
	texture:SetTexture('/BanditsUserInterface/textures/reticle/arrow_bar.dds')
	texture:SetColor(1,1,.09,.8)
	texture:SetHidden(true)
	local texture=BUI_ArrowCircle or WINDOW_MANAGER:CreateControl("BUI_ArrowCircle", ZO_ReticleContainerReticle, CT_TEXTURE)
	texture:SetDimensions(52,52)
	texture:ClearAnchors()
	texture:SetAnchor(CENTER,ZO_ReticleContainerReticle,CENTER,0,0)
	texture:SetTexture('/BanditsUserInterface/textures/reticle/circle_bar.dds')	--'/esoui/art/dye/gamepad/gp_colorselector_monoround.dds'
	texture:SetColor(1,.09,.09,.4)
	texture:SetHidden(true)
end

local function NotificationBar(ArrowTarget,ArrowTimer)
	local width=60
	local scaleX,scaleY=BUI.MapData()

	local function NormalizeAngle(angle)
		if angle>math.pi then return angle-2*math.pi end
		if angle<-math.pi then return angle+2*math.pi end
		return angle
	end

	local function ArrowBar()
		if ArrowTimer<GetGameTimeMilliseconds() then
			BUI_ArrowBar:SetHidden(true)
			BUI_ArrowCircle:SetHidden(true)
			EVENT_MANAGER:UnregisterForUpdate("BUI_OnScreen_ArrowBar")
		else
			local pX, pY=GetMapPlayerPosition("player")
			local tX, tY=GetMapPlayerPosition(ArrowTarget)
			local dist=math.min(math.sqrt(((pX-tX)*scaleX)^2+((pY-tY)*scaleY)^2)*1000,.9)
			if dist>.08 then
				local angle=NormalizeAngle(math.atan2(pX-tX,pY-tY)-NormalizeAngle(GetPlayerCameraHeading()))
				BUI_ArrowBar:SetTextureCoords(dist/2,1-dist/2,0,1)
				BUI_ArrowBar:SetWidth(width*(1-dist))
				BUI_ArrowBar:SetTextureRotation(angle,.5,1)
				BUI_ArrowBar:SetHidden(false)
				BUI_ArrowCircle:SetHidden(true)
			else
				BUI_ArrowCircle:SetHidden(false)
				BUI_ArrowBar:SetHidden(true)
			end
		end
	end

	if ArrowTarget then
		EVENT_MANAGER:RegisterForUpdate("BUI_OnScreen_ArrowBar", 40, ArrowBar)
	end
end

function BUI.OnScreen.Update()
	if BUI.Vars.NotificationsGroup or NotificationsEnabled then	--or BUI.Vars.NotificationsPvP
		local done,now,position,delay=true,GetGameTimeMilliseconds(),5,BUI.Vars.NotificationsTimer
		for id,mes in pairs(BUI.OnScreen.Message) do
			local count=0
			if mes.count then
				count=(mes.time+mes.count-now)/1000
				delay=mes.count+1000
			end
			if mes.time+delay<now and not mes.units then
--				if BUI.Vars.DeveloperMode then if mes.message ~= "" then d(BUI.TimeStamp()..'Notification "'..mes.message..'" expired') end end
				if mes.id then message_map[mes.id]=nil end
				BUI.OnScreen.Message[id]=nil
			elseif BUI.OnScreen.Message[id] and position>0 and count>=0 then
				BUI_OnScreen[position]:SetText(mes.message..(mes.units and " |cFF2222"..mes.units or "")..((mes.target and mes.target~="") and "|cFFFF22 on "..mes.target.."|r" or "")..(count>0 and (mes.silent and " " or count<=1 and " |cFF2222" or " |cEEEE22")..BUI.FormatTime(count).."|r" or ""))
				position=position-1
			end
			done=false
		end
		if position>0 then
			for i=1,position do BUI_OnScreen[i]:SetText("") end
			if done then
				EVENT_MANAGER:UnregisterForUpdate("BUI_OnScreen_Update")
			end
		end
	end
end

function BUI.OnScreen.Notification(id,message,sound,count,sourceId,target,units)
	local mesId=id
	if sourceId then
		mesId=sourceId*100000+id
		message_map[sourceId]=mesId
	end
	if BUI.OnScreen.Message[mesId] then return end
--	if count and count>1500 and count<3000 and sourceId then BUI.CallLater("Notification",count-1500,function() BUI.OnScreen.Notification(id,message,sound,1500,sourceId,target) end) return end
	local now=GetGameTimeMilliseconds()
--	if BUI.Vars.DeveloperMode then d(BUI.TimeStamp()..'Notification: '..message) end
	local _icon=type(id)~="number" and textures[4] or textures[id] or GetAbilityIcon(id)
	if ability_name[id] then message=ability_name[id] end
	if _icon and _icon~="" then local ts=BUI.Vars.NotificationsSize message="|t"..ts..":"..ts..":".._icon.."|t "..message end
	if sound then PlaySound(sound) end
	if count and count<500 then count=nil end	
	BUI.OnScreen.Message[mesId]={["message"]=zo_strformat("<<!aC:1>>",message),["time"]=now,count=count,target=target,silent=not sound,units=units,id=id}
--	if BUI.Vars.DeveloperMode then d(BUI.OnScreen.Message[mesId]) end
	BUI.OnScreen.Update()
	EVENT_MANAGER:RegisterForUpdate("BUI_OnScreen_Update", 200, BUI.OnScreen.Update)
	--Arrow bar
	if target and target~="" then NotificationBar(BUI.Group[target] and BUI.Group[target].tag, now+(count or BUI.Vars.NotificationsTimer)) end
end

function BUI.OnScreen.NotificationSecondary(id,message,sound,count,sourceId)
	local mesId=sourceId and sourceId*100000+id or id
	if BUI.OnScreen.Group[mesId] or BUI.OnScreen.Message[mesId] then return end
	local now=GetGameTimeMilliseconds()
	local ts=BUI.Vars.NotificationsSize*.75
--	if BUI.Vars.DeveloperMode then d(BUI.TimeStamp()..'Notification: '..message) end
	local _icon=type(id)~="number" and textures[4] or textures[id] or GetAbilityIcon(id)
	if ability_name[id] then message=ability_name[id] end
	if _icon and _icon~="" then message="|t"..ts..":"..ts..":".._icon.."|t "..message end
	PlaySound(BUI.Vars.NotificationSound_2)
	if count and count<500 then count=nil end
	for i=1,5 do
		if not NotificationSecondary[i] then
			NotificationSecondary[i]=true
			BUI.OnScreen.Group[mesId]=i
			BUI_OnScreenS[i]:SetText(message)
			BUI_OnScreenS[i]:SetHidden(false)
			BUI_OnScreenS[i].timeline:PlayFromStart()
			BUI.CallLater("NotificationSecondary"..i,BUI.Vars.NotificationsTimer,
				function()
					BUI.OnScreen.Group[mesId]=nil
					NotificationSecondary[i]=nil
					BUI_OnScreenS[i]:SetHidden(true)
				end)
			break
		end
	end
end

--Events
local function OnCombatTip(_,id)
	if IgnoreTip[id] then return end
	local sound=BUI.Vars.NotificationSound_1
	local name, tipText, _icon=GetActiveCombatTipInfo(id)
--	d("["..id.."] "..tipText)
	if _icon~="" then textures[id]=_icon end
	if id==18 or id==56 then
		sound=nil tipText=name
		if id==18 then
			local now=GetGameTimeMilliseconds()
			if BUI.CControl+5000<now then
				CALLBACK_MANAGER:FireCallbacks("BUI_CControl", 1)
				BUI.CControl=now
			end
		end
	end
--	if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."["..id.."] "..name.." "..tostring(id==18)) end
	BUI.OnScreen.Notification(id,tipText,sound)
end

local function OnCrowdControl(cc)
	local now=GetGameTimeMilliseconds()
	table.insert(BUI.Log,{now,"",BUI.Player.name,(cc==1 and "|cEE2222Crowd control|r" or "|cEEEE22Staggered|r"),100})
end

local function OnCombatState(eventCode, inCombat)
	if inCombat then
		if BUI.Vars.Log and BUI.Stats.CombatEnd then
			BUI.Log={{GetGameTimeMilliseconds(),"",BUI.Player.name,"|cEE2222Combat start|r "..(BUI.BossFight and tostring(BUI.BossName).." (boss) alive" or ""),100}}
		end
		BUI.OnScreen.Message[80]=nil
	else
--		d("|c22EE22Combat end")
		if BUI.Vars.Log then
			table.insert(BUI.Log,{GetGameTimeMilliseconds(),"",BUI.Player.name,"|c22EE22Combat end"
			..(BUI.init.Stats and " ("..ZO_FormatTime(math.max((BUI.Stats.Current[BUI.ReportN].endTime-BUI.Stats.Current[BUI.ReportN].startTime)/1000,1),SI_TIME_FORMAT_TIMESTAMP)..")" or "")
			,100})
		end
		SpectralCharge=0
		if BUI.Cloudrest.Init==0 then
			for id in pairs (BUI.OnScreen.Message) do
				if id~=9 and id~=10 then BUI.OnScreen.Message[id]=nil end
			end
		end
	end
end

local function OnBosses(eventCode)
	if DoesUnitExist("boss1") then
		local bossName=GetUnitName("boss1")
		local MoL1={["Zhaj'hassa the Forgotten"]=true,["Zhaj'hassa der Vergessene"]=true,["Zhaj'hassa l'Oublié"]=true,["Жай'хасса Забытый"]=true}
		local MoL2={["S'kinrai"]=true}
		if MoL1[bossName] then Glyphs_Show(true) end
		if MoL2[bossName] then BUI.MapId=string.match(string.gsub(GetMapTileTexture():lower(),"ui_map_",""),"maps/[%w%-]+/([%w%-]+_[%w%-]+)") BUI.Frames:SetupGroup() end
	else
		Glyphs_Show(false)
		if BUI.Aspect then BUI.Aspect=nil BUI.Frames:SetupGroup() end
	end
end

local CombatEventAction={
--Ressurection
[26770]=function(result,targetName)
	if BUI.Vars.NotificationsGroup and BUI.Group[targetName] and (BUI.Group[targetName].role=="Tank" or BUI.Group[targetName].role=="Healer") then
		targetName=(BUI.Group[targetName]) and BUI.Group[targetName].accname or targetName
		BUI.OnScreen.NotificationSecondary(targetName,"|cFFFF22"..targetName..BUI.Loc("Resurrecting").."|r")	--Group member is being resurrected
	end
end,
--[[
--Spectral Charge
[67376]=function(result)
	if result==ACTION_RESULT_EFFECT_GAINED then
		SpectralCharge=SpectralCharge+1
		d(BUI.TimeStamp().."|cEE2222Spectral Charges: "..SpectralCharge.."|r")
	end
end,
[67359]=function(result) if result==ACTION_RESULT_EFFECT_GAINED then SpectralCharge=0 end end,
--Lunar Aspect
[59474]=function(result,targetName)
	if result==ACTION_RESULT_EFFECT_GAINED and BUI.Group[targetName] then
		BUI.Group[targetName].Aspect=1
		if not inQueue then inQueue=true BUI.CallLater("SetupGroup",500,function() inQueue=false BUI.Frames:SetupGroup() end) end
	end
end,
--Shadow Aspect
[59465]=function(result,targetName)
	if result==ACTION_RESULT_EFFECT_GAINED and BUI.Group[targetName] then BUI.Group[targetName].Aspect=2 end
end,
--]]
[87346]=function(result,targetName)	--Voltaic Overload
	if result==ACTION_RESULT_EFFECT_GAINED and string.gsub(targetName,"%^%w+","")==BUI.Player.name then
--		BUI.VoltaicPair=BUI.CurrentPair
		CALLBACK_MANAGER:FireCallbacks("BUI_VoltaicOverload", BUI.CurrentPair)
	end
end,
--Cloudrest init
[105890]=function(result)
	if result==ACTION_RESULT_EFFECT_GAINED then
		BUI.Cloudrest.Init=GetGameTimeMilliseconds()
		BUI.Cloudrest.Group=0
		BUI.Cloudrest.Plus=0
		BUI.Cloudrest.Fallen=0
		if BUI.BossName and BUI.Phase_Timers[BUI.BossName] then	--Phase timers
			if BUI_BossFrame_Phase then BUI_BossFrame_Phase.name:SetText(BUI.Phase_Timers[BUI.BossName].name..": |cFFFF22Group 1|r") end
			BUI.Phase_Timers[BUI.BossName].timer=GetGameTimeMilliseconds()+20000
		end
	end
end,
--Cloudrest Elf init
[105541]=function(result)
	if result==ACTION_RESULT_EFFECT_GAINED then
		if BUI.Cloudrest.Init+10000>GetGameTimeMilliseconds() then
			if BUI.BossName and BUI.Phase_Timers[BUI.BossName] then	--Phase timers
				BUI.Phase_Timers[BUI.BossName].timer=BUI.Phase_Timers[BUI.BossName].timer+5000
			end
			BUI.Cloudrest.Plus=BUI.Cloudrest.Plus+1
			if BUI.Cloudrest.Plus==1 then
				BUI.CallLater("CloudrestPlus",500,function()
					if BUI.Vars.DeveloperMode then d("Cloudrest+"..BUI.Cloudrest.Plus) end
					if BUI.Cloudrest.Plus<3 then	--Phase percents
						BUI.Frames.Bosses_Init(BUI.Cloudrest.Plus==1 and {100,50,25,5} or {100,65,35,5})
					end
				end)
			end
		else
			BUI.OnScreen.NotificationSecondary(10,"Elf spawned")
		end
	end
end,
--Cloudrest portal spawn
[103946]=function(result,targetName,hitValue)
	if result==ACTION_RESULT_BEGIN and BUI.Vars.NotificationsTrial then
		BUI.Cloudrest.Timer=GetGameTimeMilliseconds()
		BUI.Cloudrest.Group=BUI.Cloudrest.Group+1 if BUI.Cloudrest.Group>2 then BUI.Cloudrest.Group=1 end
		BUI.OnScreen.Notification(103946,"Portal to Shadow world: |cFFFF22"..BUI.Cloudrest.Group.." Group|r",BUI.Vars.NotificationSound_1,hitValue)
		if BUI.BossName and BUI.Phase_Timers[BUI.BossName] then
			BUI.Phase_Timers[BUI.BossName].timer=GetGameTimeMilliseconds()+80000
		end
		if BUI_BossFrame_Phase then
			BUI_BossFrame_Phase.timer:SetColor(1,.2,.2,1)
		end
	end
end,
--Cloudrest Portal entering/exiting
[108045]=function(result,targetName,hitValue,sourceUnitId,targetUnitId)
	targetName=BUI.GroupMembers[targetUnitId]
	if result==ACTION_RESULT_EFFECT_GAINED_DURATION then
		--Portal entering
		if targetName==BUI.Player.name then
			BUI.OnScreen.Notification(108045,"Portal",nil,BUI.Cloudrest.Timer+80000-GetGameTimeMilliseconds())
		elseif targetName and BUI.Group[targetName] and BUI.Group[targetName].role=="Tank" then
			BUI.OnScreen.NotificationSecondary(108045,"Tank is inside")
		end
	elseif result==ACTION_RESULT_EFFECT_FADED then
		local now=GetGameTimeMilliseconds()
		local dead=IsUnitDead(targetName and BUI.Group[targetName] and BUI.Group[targetName].tag or nil)
		if now-lastEvent>5 and not dead then
			lastEvent=now
			--Time to close
			if (BUI.Vars.DeveloperMode or BUI.Player.isLeader) and now-lastEvent>5 and not dead then
				d(BUI.FormatTime((now-BUI.Cloudrest.Init)/1000)..". Shadow realm. Group "..BUI.Cloudrest.Group..". Time to close: "..BUI.FormatTime((now-BUI.Cloudrest.Timer)/1000))
			end
			--Phase timers
			local group=BUI.Cloudrest.Group+1 if group>2 then group=1 end
			if BUI.BossName and BUI.Phase_Timers[BUI.BossName] then
				if BUI_BossFrame_Phase then
					BUI_BossFrame_Phase.name:SetText(BUI.Phase_Timers[BUI.BossName].name..": |cFFFF22Group "..group.."|r")
					BUI_BossFrame_Phase.timer:SetColor(1,1,1,1)
				end
				BUI.Phase_Timers[BUI.BossName].timer=now+47000+BUI.Cloudrest.Plus*5000
			end
		end
		--Portal timer
		if targetName==BUI.Player.name then
			BUI.OnScreen.Message[108045]=nil
		end
	end
end,
--Shadow of the Fallen
[104747]=function(result,targetName,hitValue,sourceUnitId,targetUnitId)
	if BUI.Vars.DeveloperMode then
		if result==ACTION_RESULT_EFFECT_GAINED then
			BUI.Cloudrest.Fallen=BUI.Cloudrest.Fallen+1
			d("Shadows: "..BUI.Cloudrest.Fallen)
			if BUI.OnScreen.Message[104747] then
				BUI.OnScreen.Message[104747].units=BUI.Cloudrest.Fallen
			else
				BUI.OnScreen.Notification(104747,"Shadows",nil,nil,nil,nil,BUI.Cloudrest.Fallen)
			end
		elseif result==ACTION_RESULT_EFFECT_FADED then
			d("Shadow: dead")
			BUI.Cloudrest.Fallen=BUI.Cloudrest.Fallen-1
			if BUI.Cloudrest.Fallen>0 then
				if BUI.OnScreen.Message[104747] then BUI.OnScreen.Message[104747].units=BUI.Cloudrest.Fallen end
			else
				BUI.OnScreen.Message[104747]=nil
				BUI.Cloudrest.Fallen=0
			end
		end
	end
end
}
--Boss Phase
for name,data in pairs(BUI.Phase_Timers) do
	for id,value in pairs(data) do
		if type(id)=="number" then
			CombatEventAction[id]=function()
				if data.timer<=9000 then BUI.Phase_Timers[name].timer=GetGameTimeMilliseconds()+value end
			end
		end
	end
end

local function CombatEventNotification(result,targetName,hitValue,sourceUnitId,targetUnitId,abilityId)
	local function GetPureAbilityName(abilityId)
		return string.gsub(GetAbilityName(abilityId),"%^%w+","")
	end

	local alert=(Trial_Alert_id[abilityId] and BUI.Vars.NotificationsTrial) or (World_Alert_id[abilityId] and BUI.Vars.NotificationsWorld)
	if alert then
		local phase=false
		if type(alert)=="number" then
			if alert==200 then	--RL
				if BUI.Vars.DeveloperMode or BUI.Player.isLeader then
					BUI.OnScreen.NotificationSecondary(abilityId,GetPureAbilityName(abilityId),BUI.Vars.NotificationSound_1,hitValue,sourceUnitId)
				end
				return
			elseif alert>=300 then
				phase="Primary" alert=alert-300
			elseif alert>=100 then
				phase=true alert=alert-100
			end
			if alert>=3 then hitValue=alert*1000 end
		end
		if string.gsub(targetName,"%^%w+","")==BUI.Player.name then
			BUI.OnScreen.Notification(abilityId,GetPureAbilityName(abilityId),BUI.Vars.NotificationSound_1,hitValue,sourceUnitId,(phase and "|cFF2222You!" or nil))
		elseif phase then
			targetName=BUI.GroupMembers[targetUnitId]
			if targetName or phase=="Primary" then
				BUI.OnScreen.Notification(abilityId,GetPureAbilityName(abilityId),BUI.Vars.NotificationSound_1,hitValue,sourceUnitId,BUI.Group[targetName] and BUI.Group[targetName].accname or targetName)
			else
				BUI.OnScreen.NotificationSecondary(abilityId,GetPureAbilityName(abilityId),BUI.Vars.NotificationSound_1,hitValue,sourceUnitId)
			end
		end
	end
end

local function OnCombatEvent(_,result,_,abilityName,_,_,sourceName,sourceType,targetName,_,hitValue,_,_,_,sourceUnitId,targetUnitId,abilityId)
--	d(BUI.TimeStamp().."["..abilityId.."] "..GetAbilityName(abilityId).." "..(result==ACTION_RESULT_BEGIN and "|cCCCCCC(|cCCCC00start|cCCCCCC)" or ((result==ACTION_RESULT_EFFECT_GAINED) and "|cCCCCCC(|cCC0000gain|cCCCCCC)" or ((result==ACTION_RESULT_EFFECT_GAINED_DURATION) and "(durat)" or "(other)"))).." ||"..string.sub(sourceName,1,20).."")
	if (sourceType==COMBAT_UNIT_TYPE_PLAYER or sourceType==COMBAT_UNIT_TYPE_PLAYER_PET) then return end
	if NotificationsEnabled then	--or BUI.Vars.NotificationsPvP
		if DeathResult[result] then
			if BUI.Attacker[targetUnitId] then BUI.Attacker[targetUnitId]=nil end
		elseif InterruptResult[result] then
			local id=message_map[targetUnitId]
--			if result==ACTION_RESULT_INTERRUPT and not BUI.GroupMembers[targetUnitId] then d(string.format("[%d] %s interrupted: %s",targetUnitId,targetName, tostring(not id))) end
			if id and BUI.OnScreen.Message[id] and not BUI.OnScreen.Message[id].stopped then
				local message=BUI.OnScreen.Message[id].message.." |cFFFF22Stopped|r"
				BUI.OnScreen.Message[id]={stopped=true,message=message,time=GetGameTimeMilliseconds()-BUI.Vars.NotificationsTimer+1000}
				if targetName~="" then
					CALLBACK_MANAGER:FireCallbacks("BUI_Interrupt", string.gsub(targetName,"%^%w+",""),nil)
				end
			end
			if ControlResult[result] then
				if targetName=="" then targetName=BUI.Enemy[targetUnitId] else targetName=string.gsub(targetName,"%^%w+","") end
				if targetName then
					BUI.Controlled[targetName]=GetGameTimeMilliseconds()
					BUI.Reticle.Controlled(true)
				end
			end
		elseif CombatEventAction[abilityId] then
--			targetName=BUI.GroupMembers[targetUnitId] and BUI.GroupMembers[targetUnitId] or string.gsub(targetName,"%^%w+","")
			CombatEventAction[abilityId](result,targetName,hitValue,sourceUnitId,targetUnitId)
		elseif result==ACTION_RESULT_BEGIN or result==ACTION_RESULT_EFFECT_GAINED or result==ACTION_RESULT_EFFECT_GAINED_DURATION then
			if NotificationsEnabled and BUI.inCombat then	--or BUI.Vars.NotificationsPvP
				CombatEventNotification(result,targetName,hitValue,sourceUnitId,targetUnitId,abilityId)
				if result==ACTION_RESULT_EFFECT_GAINED or result==ACTION_RESULT_EFFECT_GAINED_DURATION then
					if Control_id[abilityId] and string.gsub(targetName,"%^%w+","")==BUI.Player.name then
						local now=GetGameTimeMilliseconds()
						if BUI.CControl+5000<now then
							CALLBACK_MANAGER:FireCallbacks("BUI_CControl", Control_id[abilityId])
							BUI.CControl=now
							if Control_id_alert[abilityId] then BUI.OnScreen.Notification(18,"Crowd Control","Ability_MorphPurchased") end	--Crowd Control
						end
					end
				elseif result==ACTION_RESULT_BEGIN and Interrupt_id[abilityId] and sourceName~="" then
					local now=GetGameTimeMilliseconds()
					CALLBACK_MANAGER:FireCallbacks("BUI_Interrupt", sourceName,now+hitValue)
				end
			end
		end
	end

	if BUI.Vars.Log
	and (sourceName~="" or targetName~="" or BUI.DetailedLog or result==ACTION_RESULT_BEGIN)
	and (not BUI.GroupMembers[sourceUnitId])
	and (not IgnoreAbility[abilityId])
	and (sourceUnitId~=0 or BUI.DetailedLog or result==ACTION_RESULT_BEGIN)
--	and (sourceUnitId~=targetUnitId)
	then
		if not sourceName or sourceName=="" then sourceName=sourceUnitId else sourceName=string.gsub(sourceName,"%^%w+","") end
		if not targetName or targetName=="" then targetName=targetUnitId else targetName=string.gsub(targetName,"%^%w+","") end
		if (sourceName~=BUI.Player.name) and (not BUI.Group[sourceName]) then
			local color=(Trial_Alert_id[abilityId] or World_Alert_id[abilityId] or Control_id[abilityId]) and 1 or ((sourceUnitId==targetUnitId) and 2 or 0)
			table.insert(BUI.Log,{GetGameTimeMilliseconds(),sourceName,targetName,abilityId,result,hitValue,color})
		end
	end
end

function HornFunction(changeType,unitId)
	unitName=BUI.GroupMembers[unitId]
	if unitName then
		local unitTag=BUI.Group[unitName] and BUI.Group[unitName].tag
		if unitTag and (changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_FADED) then
--			if changeType==EFFECT_RESULT_GAINED then BUI.Buffs.HornActive=10 end
			BUI.Frames:AttributeVisual(unitTag,20,changeType==EFFECT_RESULT_GAINED)
		end
	end
end

local AlertDoT={
	[95230]={color={0,.9,0,1},count=10000},--Venom Injection (HoF)
	[90409]={color={1,.5,.6,1},count=10000},--Melting Point (HoF)
	[101101]={color={1,.5,.6,1},count=10000},--Trial by Fire (AS)
	[84221]={color={0,.9,0,1},count=10000},--Sickening Poison (Velidreth)
	[73807]={color={1,.5,.6,1},count=10000},--Lunar Flare (Rage of S'Kinrai)
	[75738]={color={1,.5,.6,1},count=10000},--Lunar Flare (S'kinrai)
	[112057]={color={1,.5,.6,1},count=10000},--Fire Gauntlet (BRP)
	[107082]={color={1,.2,.3,1},count=30000},--Baneful Mark
	[87346]={color={1,1,1,1},count=10000},--Voltaic Overload
	[103695]={color={.8,.8,1,1},count=7000},--Hoarfrost
	[106656]={color={1,.2,.3,1},count=30000},--Razorthorn
	[121726]={color={1,.5,.6,1},count=60000},--Focused Fire
	[124335]={color={1,.5,1,1},count=60000},--Frozen Prison
	[56782]={color={.8,.8,1,1},count=10000, static=true},--Magicka Bomb
	[73250]={color={1,.5,.6,1},count=10000},--Shattered (MoL)
	}

local AlertSpawn={
[99990]=function(changeType,unitId,unitName)	--Dormant (AS Felms/Lothis)
	if changeType==EFFECT_RESULT_FADED then
		BUI.OnScreen.Message[10]=nil
		BUI.OnScreen.Notification(10,string.gsub(string.gsub(unitName," the %w+",""),"Saint ","").." (Enrage)",false,180000,unitId)
	else
		BUI.OnScreen.Message[10]=nil
		BUI.OnScreen.Notification(10,string.gsub(string.gsub(unitName," the %w+",""),"Saint ","").." (Up)",false,48000,unitId)
	end
end,
[59640]=function(changeType,unitId,unitName)	--Lunar Aspect
	local unitName=BUI.GroupMembers[unitId] or string.gsub(unitName,"%^%w+","")
	if changeType==EFFECT_RESULT_GAINED and BUI.Group[unitName] then
		BUI.Group[unitName].Aspect=1
		BUI.Aspect=true
		if not inQueue then inQueue=true BUI.CallLater("SetupGroup",500,function() inQueue=false BUI.Frames:SetupGroup() end) end
	end
end,
[59639]=function(changeType,unitId,unitName)	--Shadow Aspect
	local unitName=BUI.GroupMembers[unitId] or string.gsub(unitName,"%^%w+","")
	if changeType==EFFECT_RESULT_GAINED and BUI.Group[unitName] then BUI.Group[unitName].Aspect=2 end
end,
--[104542]=true,--Hollowing Torment
--[[
[120848]=function(changeType,unitId,count)
	if changeType==EFFECT_RESULT_GAINED then
		d("Hail of Stone: "..count)
	end
end,
--]]
}
for id in pairs(BUI.Buffs.Horn) do AlertSpawn[id]=HornFunction end

local function OnEffectChanged(_, changeType, effectSlot, effectName, unitTag, startTimeSec, endTimeSec, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId)
	if AlertSpawn[abilityId] then
		AlertSpawn[abilityId](changeType,unitId,unitName)
	elseif AlertDoT[abilityId] then
		if changeType==EFFECT_RESULT_GAINED then
			if BUI.Vars.EffectVisualisation then
				ZO_HUDTelvarAlertBorderOverlay:SetEdgeColor(unpack(AlertDoT[abilityId].color))
				ZO_HUDTelvarAlertBorder:SetHidden(false) ZO_HUDTelvarAlertBorder:SetAlpha(.6)
			end
			local count=(endTimeSec>0 and not AlertDoT[abilityId].static) and (endTimeSec-startTimeSec)*1000 or AlertDoT[abilityId].count
--			d(tostring(GetAbilityName(abilityId))..", "..count)
			if not BUI.OnScreen.Message[abilityId] then
				BUI.OnScreen.Notification(abilityId,GetAbilityName(abilityId),BUI.Vars.NotificationSound_1,count)
			else
				BUI.OnScreen.Message[abilityId]["time"]=count
			end
			if abilityId==103695 then BUI.Cloudrest.Hoarfrost=GetGameTimeMilliseconds() end	--Hoarfrost
		elseif changeType==EFFECT_RESULT_FADED then
			BUI.OnScreen.Message[abilityId]=nil
			ZO_HUDTelvarAlertBorder:SetHidden(true)
		end
	end
end

function BUI.OnScreen.Initialize(disable)
	NotificationsEnabled=BUI.Vars.NotificationsTrial or BUI.Vars.NotificationsWorld
	--Custom Notifications
	if disable==nil and BUI.CustomNotifications then
		for id,value in pairs(BUI.CustomNotifications) do
			World_Alert_id[id]=value
		end
	end
	--Register events
	if not disable and BUI.Vars.Glyphs then
		EVENT_MANAGER:RegisterForEvent("BUI_OnScreen", EVENT_BOSSES_CHANGED,				OnBosses)
		EVENT_MANAGER:RegisterForEvent("BUI_OnScreen", EVENT_PLAYER_ACTIVATED,				OnBosses)
	else
		EVENT_MANAGER:UnregisterForEvent("BUI_OnScreen", EVENT_BOSSES_CHANGED)
		EVENT_MANAGER:UnregisterForEvent("BUI_OnScreen", EVENT_PLAYER_ACTIVATED)
	end
	if not disable and BUI.Vars.Log then
		CALLBACK_MANAGER:RegisterCallback("BUI_CControl", OnCrowdControl)
	else
		CALLBACK_MANAGER:UnregisterCallback("BUI_CControl")
	end
	if not disable and (BUI.Vars.NotificationsGroup or NotificationsEnabled) then	--or BUI.Vars.NotificationsPvP
--		if BUI.Vars.NotificationsGroup then EVENT_MANAGER:RegisterForUpdate("BUI_OnScreen", 500, Horn_Loop) end
		if BUI.Vars.Log or NotificationsEnabled then	--or BUI.Vars.NotificationsPvP
			if ZO_ActiveCombatTips then ZO_ActiveCombatTips:SetHidden(true) end
			if ZO_HUDTelvarAlertBorderOverlay then ZO_HUDTelvarAlertBorderOverlay:SetEdgeTexture("EsoUI/Art/HUD/UITelvarOverlayEdge.dds",2048,128) end
			for id in pairs(AlertSpawn) do
				EVENT_MANAGER:RegisterForEvent("BUI_AlertSpawn"..id, EVENT_EFFECT_CHANGED,	OnEffectChanged)
				EVENT_MANAGER:AddFilterForEvent("BUI_AlertSpawn"..id, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, id)
			end
			for id,player in pairs(AlertDoT) do
				EVENT_MANAGER:RegisterForEvent("BUI_AlertDoT"..id, EVENT_EFFECT_CHANGED,	OnEffectChanged)
				EVENT_MANAGER:AddFilterForEvent("BUI_AlertDoT"..id, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, id)
				if player then EVENT_MANAGER:AddFilterForEvent("BUI_AlertDoT"..id, EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG, "player") end
			end

			EVENT_MANAGER:RegisterForEvent("BUI_OnScreen", EVENT_DISPLAY_ACTIVE_COMBAT_TIP,	OnCombatTip)
			EVENT_MANAGER:RegisterForEvent("BUI_OnScreen", EVENT_REMOVE_ACTIVE_COMBAT_TIP,	function(_,id) if IgnoreTip[id] then return end BUI.OnScreen.Message[id]={["message"]="",["time"]=0} BUI.OnScreen.Update() end)
			EVENT_MANAGER:RegisterForEvent("BUI_OnScreen", EVENT_PLAYER_COMBAT_STATE,		OnCombatState)
			--Combat Notifications
			local filters={
					ACTION_RESULT_BEGIN,
					ACTION_RESULT_EFFECT_GAINED,
					ACTION_RESULT_EFFECT_GAINED_DURATION,
					ACTION_RESULT_EFFECT_FADED,

					ACTION_RESULT_FEARED,
					ACTION_RESULT_INTERRUPT,
					ACTION_RESULT_DIED,
					ACTION_RESULT_STUNNED,
					ACTION_RESULT_DIED_XP,
					}
			for i in pairs(filters) do
				EVENT_MANAGER:RegisterForEvent("BUI_OnScreen"..i, EVENT_COMBAT_EVENT,		OnCombatEvent)
				EVENT_MANAGER:AddFilterForEvent("BUI_OnScreen"..i, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, filters[i], REGISTER_FILTER_IS_ERROR, false)
			end
		end
		if not BUI.init.OnScreen then BUI.OnScreen.UI_Init() end
		BUI.init.OnScreen=true
		return true
	else
		if BUI.init.OnScreen then
			EVENT_MANAGER:UnregisterForUpdate("BUI_OnScreen")
			EVENT_MANAGER:UnregisterForEvent("BUI_OnScreen", EVENT_PLAYER_COMBAT_STATE)
			EVENT_MANAGER:UnregisterForEvent("BUI_OnScreen", EVENT_DISPLAY_ACTIVE_COMBAT_TIP)
			EVENT_MANAGER:UnregisterForEvent("BUI_OnScreen", EVENT_REMOVE_ACTIVE_COMBAT_TIP)
			for i=1,9 do EVENT_MANAGER:UnregisterForEvent("BUI_OnScreen"..i, EVENT_COMBAT_EVENT) end
			for id in pairs(AlertSpawn) do EVENT_MANAGER:UnregisterForEvent("BUI_AlertSpawn"..id, EVENT_EFFECT_CHANGED) end
			for id in pairs(AlertDoT) do EVENT_MANAGER:UnregisterForEvent("BUI_AlertDoT"..id, EVENT_EFFECT_CHANGED) end
			return false
		end
	end
end

--[[
/script BUI.OnScreen.Notification(103531,"Roaring Flare",nil,10000,nil,"@Gekkorus")
/script for i=1,4 do BUI_OnScreenS[i]:SetText(i.." Message") BUI_OnScreenS[i]:SetHidden(false) end
function ReceivedAspects()
	for id,data in pairs(BUI.Group) do
		if id~="members" and data.Aspect then
			d(id..": "..data.Aspect)
		end
	end
end
/script ReceivedAspects()
local function Horn_Loop()
	if BUI.BossFight and not BUI.Buffs.HornActive and BUI.inCombat and not IsUnitDead('boss1') then
		if (BUI.Buffs.HornAvailable[1]==true or BUI.Buffs.HornAvailable[2]==true) and BUI.Player.ultimate.current>=240 then
			BUI.OnScreen.Notification(3,BUI.Loc("Horn"))
		elseif BUI.ReadyHorn and BUI.Player.isLeader then
			BUI.OnScreen.Notification(3,BUI.Loc("Horn").." ("..BUI.ReadyHorn..")")
		end
	end
end

/script for i=1,130 do local n,t=GetActiveCombatTipInfo(i) d("["..i.."] "..t) end
/script d(GetActiveCombatTipInfo(100))
/script BUI_Glyph1_Bar:SetColor(1,0,0,1)
/script local anchor=(BUI.Vars.BUI_Glyphs) and BUI.Vars.BUI_Glyphs or {BOTTOMRIGHT,BOTTOMLEFT,-10,0,ZO_ActionBar_GetButton(ACTION_BAR_FIRST_UTILITY_BAR_SLOT+1).slot} d(anchor)
[57525]="Jone's Blessing",--Glyph
/script BUI.Vars.ProcSound=SOUNDS.ABILITY_ULTIMATE_READY
/script PlaySound(SOUNDS.ABILITY_ULTIMATE_READY)
--]]