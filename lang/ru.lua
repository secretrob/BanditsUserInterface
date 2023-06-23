--RUSSIAN LANGUAGE LOCALIZATION
local on,off	="Включено","Выключено"
local lmb,rmb,mmb='|t16:16:/BanditsUserInterface/textures/lmb.dds|t','|t16:16:/BanditsUserInterface/textures/rmb.dds|t','|t16:16:/BanditsUserInterface/textures/mmb.dds|t'
local AlignValues	={[8]="Лево",[128]="Центр",[2]="Право"}
local default="[По умолчанию: "
local TauntTimerValues	={"Progress bar","Bar and number","Number only","Disabled"}
local ReticleResistValues	={"Current value","Detailed info","Disabled"}
local CastBarValues	={"Any ability","Cast time ability","Disabled"}

--KEYBINDINGS
ZO_CreateStringId("SI_BINDING_NAME_DISPLAY_DAMAGE_REPORT_WINDOW",	"Показать отчет боя")
ZO_CreateStringId("SI_BINDING_NAME_POST_DAMAGE_RESULTS_TO_CHAT",	"Вывести в чат результаты боя")
ZO_CreateStringId("SI_BINDING_NAME_RESET_FIGHT",			"Сбросить текущий бой")
ZO_CreateStringId("SI_BINDING_NAME_SHOW_LOG",				"Показать записи о бое")
ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_MINIMAP",			"Включить/Выключить Миникарту")
ZO_CreateStringId("SI_BINDING_NAME_REGROUPER_REINVITE",		"Собрать запомненную группу")
ZO_CreateStringId("SI_BINDING_NAME_REGROUPER_REGROUP",		"Пересобрать группу")
ZO_CreateStringId("SI_BINDING_NAME_BUI_QUICKSLOT_NEXT",		"Следующий слот")
ZO_CreateStringId("SI_BINDING_NAME_BUI_QUICKSLOT_PREV",		"Предыдущий слот")
for i=1,8 do ZO_CreateStringId("SI_BINDING_NAME_BUI_QUICKSLOT_"..i,	"Быстрый слот "..i) end
for i=1,6 do ZO_CreateStringId("SI_BINDING_NAME_BUI_CUSTOMSLOT_"..i,	"Пользовательский слот "..i) end

BUI.Localization.ru={
--TOOLTIPS
MiniMeterDPSToolTip=	lmb	.." Показать отчет боя\n"
					..	rmb	.." Вывести в чат результаты боя\n"
					..	mmb	.." Сбросить текущий бой",
MiniMeterHPSToolTip=	lmb	.." Показать помощник Хила",
MiniMeterGDPSToolTip1=	lmb	.." Вывести в чат групповой ДПС",
MiniMeterGDPSToolTip2=	rmb	.." Вывести в чат групповой ДПС",
GroupSectionDpsToolTip=	lmb	.." Показать ДПС членов группы\n"
					..	rmb	.." Вывести в чат групповой ДПС",
GroupSectionRergouperToolTip=	lmb	.." Пересобрать группу\n"
					..	rmb	.." Запомнить текущую группу\n"
					..	mmb	.." Вывести в чат список группы",
GroupSectionResetup=	lmb	..' Переинициализировать интерфейс группы',
GroupSectionDisband=	lmb	..' Распустить группу',

HelperToolTip=
	"Продолжительность теста: 1 мин\n"
	.."\n"
	.."Требуется:\n"
	.."Поддерживать на себе перечисленные бафы\n"
	.."Поддерживать на манекене перечисленные дебафы\n"
	.."Использовать на манекене перечисленные умения\n"
	.."\n"
	.."Для начала теста атакуйте манекен.",

--UI texts
MiniMap_Label	="Мини карта",
PF_Label	="Панель Игрока",
TF_Label	="Панель Цели",
GF_Label	="Панель Группы",
RF_Label	="Панель Группы",
BF_Label	="Панель Боссов",
NotP_Label	="Важные оповещения",
NotS_Label	="Второстепенные оповещения",
Dead	="Мертв",
Offline	="Отключен",
PBuffsLabel	="Бафы Игрока",
CBuffsLabel	="Дополнит. бафы",
SBuffsLabel	="Откат синергий",
PasBuffsLabel	="П\nа\nс\nс\nи\nв\nк\nи",
TBuffsLabel	="Бафы Цели",
GroupDPS	="ДПС группы",
Apply		="Применить",
Delete	="Удалить",
Save		="Сохранить",

--Damage Report UI
DReport	="Отчёт боя",
RTracker	="Rotation Tracker",
HReport	="Отчёт исцеления",
PReport	="Полученные ресурсы",
IReport	="Полученнывй урон",
NoDamage	="Нет данных боя!",
AllTargets	="Все цели",
Ability	="Умение",
Crit	="Крит",
Average	="Сред",
Max	="Макс",
Hit	="Удары",
Damage	="Урон",
Healing	="Хил",
Power	="Ресурс",
DPS	="DPS",
HPS	="HPS",
NoDPSToReport	="Нет данных ДПС группы!",
NoDamageToReport	="Нет данных боя!",
ReportDesc	="|t22:27:/esoui/art/chatwindow/chat_notification_up.dds|t Вывести ДПС в чат\n|t22:22:/esoui/art/tutorial/smithing_rightarrow_up.dds|t Показать бафы цели\n|t22:22:/esoui/art/buttons/pointsplus_up.dds|t Показать урон по цели\n  |c33BB33v|r  Наложено игроком",
ReportEinfo	="Экипировка",
ReportPBHeader	="Бафы игрока",
ReportTBHeader	="Бафы цели",
ReportBuffHeader	="Баф",
ReportTimeHeader	="Время ",
ReportTargetName	="Имя цели",
ReportTotalDamage	="Всего урона",
ReportCount	="Ударов",
ReportTotal	="Всего",
Boss	="Босс",

--Notifications
GroupNeedOrbs	="Группе нужны Орбы!",
TankNeedShard	="Танку нужно Копье!",
Horn	="Горн!",
GroupMemberDead	="мертв!",
GroupMemberLeave	="покинул группу",
You	="Ты ",
Food	="Нужно поесть",
Resurrecting	=" воскрешают",

--Buffs dialog
BuffsAddFail	="Попытка добавить баф: неверное название бафа или id",
BuffsAdd	="Вы уверены что готовы добавить\n<<1>> в <<2>>",
BuffsAdded	="<<1>> добавлен в <<2>>",
BuffsRemove	="Вы уверены что готовы убрать\n<<1>> из <<2>>",

--MENU -------------------------------
--Warnings
ReloadUiWarn	="Результат изменений этой настройки будет виден после перезагрузки интерфейса",
ReloadUiWarn1	="Эта настройка потребует перезагрузки интерфейса",
ReloadUiWarn2	="Некоторые изменения будут применены после перезагрузки интерфейса",
PerformanceWarn	="Эта опция может снизить производительность",
--Reset
Reset	="Сброс настроек",
ResetDesc	="Сброс всех настроек аддона на стандартные.",
ResetPositions	="Сброс позиций",
ResetPositionsDesc	="Восстанавливает стандартные позиции элементов интерфейса.",
FramesReset	="Сброс настроек",
FramesResetDesc	="Сброс настроек панелей игрока, цели и группы на стандартные.",
CurvedReset	="Сброс настроек",
CurvedResetDesc	="Сброс настроек изогнутых панелей на стандартные.",
ColorsReset	="Сброс настроек",
ColorsResetDesc	="Сброс настроек цветов, шрифтов и пр. на стандартные.",
StatsReset	="Сброс настроек",
StatsResetDesc	="Сброс настроек статистики боя на стандартные.",
BuffsReset	="Сброс настроек",
BuffsResetDesc	="Сброс настроек бафов на стандартные.",
ActionsReset	="Сброс настроек",
ActionsResetDesc	="Сброс настроек на стандартные",
MinimapReset	="Сброс настроек",
MinimapResetDesc	="Сброс настроек миникарты на стандартные.",

--Headers
MiscHeader	="Основные настройки",
MiscHeader1	="Дополнительно",
PlayerHeader	="Настройки Игрока",
CurvedHeader	="Изогнутые фреймы",
GroupHeader	="Настройки Группы",
StatShareHeader	="Атрибуты группы",
TargetHeader	="Настройки Цели",
ActionsHeader	="Тайминги Умений",
BuffsHeader	="Настройки Бафов",
MinimapHeader	="Миникарта",
ReticleHeader	="Настройки Прицела",
NotificationsHeader	="Оповещения",
NotificationsCombatHeader	="Боевые оповещения",
ColorsHeader	="Настройки элементов",
QuickSlotsHeader	="Слоты быстрого доступа",
GroupRolesHeader	="Роли в группе",
StatHeader	="Статистика боя",
ZoomHeader	="Настройки масштаба",
PinColorsHeader	="Цвета маркеров карты",
AdvancedHeader	="Дополнительные настройки",
AttributeColors	="Цвета атрибутов",

--CustomBar
CustomBarHeader	="Панель действий",
CustomBar		="Панель включена",
LeaderCommands	="Команды лидера",
CustomCommands	="Пользовательские действия",
TextureFilename	="Файл значка",
SlashCommand	="Слэш команда",

--SidePanel
PanelHeader	="Боковая панель",
PanelEnable	="Панель включена",
PanelAllowOther	="Кнопки сторонних адд-онов",
PanelSettings	="Настройки Бандитского Интерфейса",
PanelStatistics	="Статистика боя",
PanelHealerHelper	="Помощник \"Лекаря\"",
PanelGearManager	="Кнопка Gear Manager-а",
PanelMinimap	="Включить/Выключить Миникарту",
PanelCompass=	"3D Компас",
PanelLeaderArrow	="Направление к лидеру группы",
PanelDismissPets	="Отозвать боевых питомцев",
PanelSubSampling	="Переключатель SubSampling quality",
PanelVanishPlayers	="Режим \"Каджита\"",
PanelVeteranDifficulty	="Сложность подземелий",
PanelLFG_Role	="Роль в группе",
PanelBanker	="Ассистент: Банкир",
PanelBankerDesc="Покупается в магазине",
PanelTrader	="Ассистент: Торговец",
PanelTraderDesc="Покупается в магазине",
PanelSmuggler	="Ассистент: Скупщик",
PanelSmugglerDesc="Доступно вместе с DLC гильдии воров",
PanelArmorer	="Ассистент: Оружейник",
PanelArmorerDesc="Покупается в магазине",
PanelRagpicker	="Ассистент: Старьевщик",
PanelRagpickerDesc="Покупается в магазине",
PanelEvent	="Кнопка текущего ивента",
PanelWPamA	="Кнопки адд-она WPamA",
PanelTeleporter	="Кнопки \"телепортера\"",
PanelTeleporterDesc="Доступно при установленном дополнении Chat Tab Selector",

--Minimap
Minimap	="Миникарта",
MinimapDesc	=default..(BUI.MiniMap.Defaults.MiniMap and on or off).."]",
MiniMapDimensions	="Размер Миникарты",
MiniMapDimensionsDesc	=default..BUI.MiniMap.Defaults.MiniMapDimensions.."]",
PinScale	="Размер объектов на Миникарте (%)",
PinScaleDesc	=default..BUI.MiniMap.Defaults.PinScale.."%]",
MinimapTitle	="Название местности",
MinimapTitleDesc	=default..(BUI.MiniMap.Defaults.MiniMapTitle and on or off).."]",
ZoomZone	="Зона",
ZoomZoneDesc	=default..BUI.MiniMap.Defaults.ZoomZone.."%]",
ZoomSubZone	="Подзона",
ZoomSubZoneDesc	=default..BUI.MiniMap.Defaults.ZoomSubZone.."%]",
ZoomDungeon	="Подземелье",
ZoomDungeonDesc	=default..BUI.MiniMap.Defaults.ZoomDungeon.."%]",
ZoomCyrodiil	="Сиродиил",
ZoomCyrodiilDesc	=default..BUI.MiniMap.Defaults.ZoomCyrodiil.."%]",
ZoomImperialsewer	="Имперская канализация",
ZoomImperialsewerDesc	=default..BUI.MiniMap.Defaults.ZoomImperialsewer.."%]",
ZoomImperialCity	="Имперский город",
ZoomImperialCityDesc	=default..BUI.MiniMap.Defaults.ZoomImperialCity.."%]",
ZoomMountRatio	="Верхом",
ZoomMountRatioDesc	="Отдаление карты если верхом.\n"..default..BUI.MiniMap.Defaults.ZoomMountRatio.."%]",
ZoomGlobal	="Обычная карта",
ZoomGlobalDesc	="При открытии обычной карты устанавливает заданный масштаб.\n"..default..BUI.MiniMap.Defaults.ZoomGlobal.."%]",

--Reticle
LeaderArrow	="1. Направление к лидеру группы (beta)",
LeaderArrowDesc	="Стрелка, которая показывает где и как далеко лидер группы.\n"..default..(BUI.Defaults.LeaderArrow and on or off).."]",
InCombatReticle	="2. Прицел в бою",
InCombatReticleDesc	="В бою прицел становится красным.\n"..default..(BUI.Defaults.InCombatReticle and on or off).."]",
PreferredTarget	="3. Фокусировка на приоритетную цель",
PreferredTargetDesc	="Прицел изменяется если наведен на цель выбранную как приоритетная.\n"..default..(BUI.Defaults.PreferredTarget and on or off).."]",
ReticleDpS	="4. Текущий ДПС возле прицела",
ReticleDpSDesc	="(работает только со включенным \"Миниметром\")\n"..default..(BUI.Defaults.ReticleDpS and on or off).."]",
ReticleInvul	="5. Информация о неуязвимости",
ReticleInvulDesc	=default..(BUI.Defaults.ReticleInvul and on or off).."]",
CrusherTimer	="6. Танк: Крашер таймер",
CrusherTimerDesc	="(работает только если включен модуль бафов цели).\n"..default..(BUI.Defaults.CrusherTimer and on or off).."]",
TauntTimer	="7. Танк: Таунт таймер",
TauntTimerValues	=TauntTimerValues,
TauntTimerDesc	="(работает только если включен модуль бафов цели).\n"..default..TauntTimerValues[BUI.Defaults.TauntTimer].."]",
ReticleResist	="8. Сопротивление цели",
ReticleResistValues	=ReticleResistValues,
ReticleResistDesc	="Показывает значение сопротивления цели возле прицела (works only when target buffs are enabled).\n"..default..ReticleResistValues[BUI.Defaults.ReticleResist].."]",
CastBar	="9. Панель времени каста",
CastBarValues	=CastBarValues,
CastBarDesc	="(работает только со включенными \"Таймингами Умений\").\n"..default..CastBarValues[BUI.Defaults.CastBar].."]",
SwapIndicator	="10. Время смены оружия",
SwapIndicatorDesc	="(работает только со включенными \"Таймингами Умений\").\n"..default..CastBarValues[BUI.Defaults.CastBar].."]",
ImpactAnimation	="11. Анимация сотрясающего удара",
ImpactAnimationDesc	=default..(BUI.Defaults.ImpactAnimation and on or off).."]",
ReticleMode	="12. Внешний вид прицела",
ReticleBoost	="13. Индикатор ускорения",
BlockIndicator	="14. Индикатор блокирования",

--QuickSlots
QuickSlots	="Быстрые слоты",
QuickSlotsDesc	=default..(BUI.Defaults.QuickSlots and on or off).."]",
QuickSlotsShow	="Количество быстрых слотов",
QuickSlotsShowDesc	="(Четное количество будет расположено в два ряда).\n"..default..BUI.Defaults.QuickSlotsShow.."]",
QuickSlotsInventory	="Показывать в инвентаре",
QuickSlotsInventoryDesc	="Показывать слоты быстрого доступа при открытии инвентаря.\n"..default..(BUI.Defaults.QuickSlotsInventory and on or off),

--Notifications
NotificationFood		="Оповещение о еде",
NotificationFoodDesc	=default..(BUI.Defaults.NotificationFood and on or off).."]",
NotificationsGroup	="Оповещения группы",
NotificationsGroupDesc	='Интеллектуальный модуль. Оповещает хила если таку нужна стамина, группа проседает по ресурсам. Оповещает группу если упал танк или хил. Если идет бой с боссом, нет горна а у игрока на панели есть горн и хватает ультимета то он получит напоминание что пора "дудеть"\n'..default..(BUI.Defaults.NotificationsGroup and on or off).."]",
OnScreenPriorDeath	="Оповещать о смерти только хила и танка",
OnScreenPriorDeathDesc	=default..(BUI.Defaults.OnScreenPriorDeath and on or off).."]",
NotificationsWorld	="Боевые оповещения (Общие)",
NotificationsWorldDesc	='Боевые оповещения в открытом мире и данжах: "Uppercut", "Meteor", "Taking Aim", "Poison", итд.\n'..default..(BUI.Defaults.NotificationsWorld and on or off).."]",
NotificationsTrial	="Боевые оповещения (Триалы)",
NotificationsTrialDesc	=default..(BUI.Defaults.NotificationsTrial and on or off).."]",
EffectVisualisation	="Визуализация эффектов",
EffectVisualisationDesc	='Кромка экрана становится зеленой при отравлении, синей при заморозке, светлой при перегрузке, сереневой при \"Beneful mark\" и коричневой при кровотечении, горении\n'..default..(BUI.Defaults.EffectVisualisation and on or off).."]",
NotificationsSize	="Размер шрифта",
NotificationsSizeDesc	=default..BUI.Defaults.NotificationsSize.."]",
NotificationsTimer	="Время задержки",
NotificationsTimerDesc	=default..BUI.Defaults.NotificationsTimer.."]",
NotificationSound_1	="Звук важных оповещений",
NotificationSound_2	="Звук второстепенных оповещений",

--Misc options
ChangeLanguage	="Смена языка",
ChangeLanguageWarn	="Изменение этой настройки вызовет перезагрузку интерфейса!",
Theme	="Тема интерфейса",
Move	="Двигать элементы",
MoveDesc	="Режим перемещения элементов интерфейса.",
PlayerStatSection	="Окно персонажа: доп. информация",
PlayerStatSectionDesc	="Добавляет: penetration, crit damage bonus, block cost, block mitigation info to player attributes section",
PvPmode	="Режим ПвП",
PvPmodeDesc	="При входе в ПвП локацию автоматически отключает: Статистику боя, Боевые оповещения и Шаринг ресурсов",
ChampionHelper	="Модернизация интерфейса \"чемпионки\"",
ChampionHelperDesc	="Содержит предустановки различных типов \"чемпионки\". Позволяет сохранять и восстанавливать собственные.\n"..default..(BUI.Defaults.ChampionHelper and on or off).."]",

--Player frame
PlayerFrame	="Панель Игрока",
PlayerFrameDesc	="Стиль панелей атрибутов игрока",
PlayerFrameWarn	="Выбор стандартных панелей, если они ранее были выключены автоматически произведет перезагрузку интерфейса!",
DefaultPlayerFrames	="Включить стандартные фреймы",
DefaultPlayerFramesDesc	=default..(BUI.Defaults.DefaultPlayerFrames and on or off).."]",
DefaultPlayerFramesWarn	="Включение этой настройки незамедлительно перезагрузит интерфейс!",
RepositionFrames	="Собрать стандартные фреймы в пирамидку",
RepositionFramesDesc	=default..(BUI.Defaults.RepositionFrames and on or off).."]",
RepositionFramesWarn	="Выключение этой настройки незамедлительно перезагрузит интерфейс!",
FramesTexture	="Текстура фреймов",
FramesTextureDesc	=default..BUI.Defaults.FramesTexture.."]",
FramesBorder	="Внешний вид",
FramesBorderDesc	=default..BUI.Defaults.FramesBorder.."]",
FrameHorisontal	="Расположить горизонтально",
FrameHorisontalDesc	="Переключение между классическим раположением атрибутов один над другим или по горизонтали.\n"..default..(BUI.Defaults.FrameHorisontal and "Horisontal" or "Vertical").."]",
FramePercents	="Показывать проценты",
FramePercentsDesc	=default..(BUI.Defaults.FramePercents and on or off).."]",
FrameShowMax	="Включить максимальные значения",
FrameShowMaxDesc	="Показывает максимальные значения атрибутов.\n"..default..(BUI.Defaults.FrameShowMax and on or off).."]",
DecimalValues	="Десятичные значения",
DecimalValuesDesc	=default..(BUI.Defaults.DecimalValues and on or off).."]",
FrameWidth	="Ширина",
FrameWidthDesc	="Задает ширину панелей атрибутов.\n"..default..BUI.Defaults.FrameWidth.."]",
FrameHeight	="Высота",
FrameHeightDesc	="Задает высоту панелей атрибутов.\n"..default..BUI.Defaults.FrameHeight.."]",
EnableNameplate	="Надпись с именем игрока",
EnableNameplateDesc	="Показывает имя игрока над панелью здоровья.\n"..default..(BUI.Defaults.EnableNameplate and on or off).."]",
FoodBuff	="Отображение бонуса еды",
FoodBuffDesc	="Менять длинну панелей атрибутов на основании бонусов еды.\n"..default..(BUI.Defaults.FoodBuff and on or off),
EnableXPBar	="Включить панель опыта",
EnableXPBarDesc	="Панель опыта/выносливости ездового/целостности осадки/времени в форме верфольфа.\n"..default..(BUI.Defaults.EnableXPBar and on or off).."]",
DodgeFatigue	="Панель усталости",
DodgeFatigueDesc	="Показывает время в течении которого кувырок обойдется вдвое дороже.\n"..default..(BUI.Defaults.DodgeFatigue and on or off).."]",
FramesFade	="Авто скрытие",
--FramesFadeDesc	="Auto hide players attributes when it is full and player is out of combat.\n"..default..(BUI.Defaults.FramesFade and on or off).."]",

--Target frame
TargetFrame	="Дополнительный Фрейм цели",
TargetFrameDesc	="Включает представленную аддоном панель цели.\n"..default..(BUI.Defaults.TargetFrame and on or off).."]",
DefaultTargetFrame	="Стандартная панель цели",
DefaultTargetFrameDesc	="Здесь ее можно отключить.\n"..default..(BUI.Defaults.DefaultTargetFrame and on or off).."]",
DefaultTargetFrameText	="Модификация стандартной панели",
DefaultTargetFrameTextDesc	="Добавляет проценты здоровья, значок стадии \"добивания\"",
TargetWidth	="Ширина",
--TargetWidthDesc	="Set the width of target frames.\n"..default..BUI.Defaults.TargetWidth.."]",
TargetHeight	="Высота",
--TargetHeightDesc	="Set the height of target frames.\n"..default..BUI.Defaults.TargetHeight.."]",
TargetFramePercents	="Показывать проценты",
TargetFramePercentsDesc	=default..(BUI.Defaults.TargetFramePercents and on or off).."]",
ExecuteThreshold	="Порог добивания",
ExecuteThresholdDesc	="Задает процент перехода на стадию добивания. Используется на панели цели. Установка в нулевое значение отключает оповещения.\n"..default..BUI.Defaults.ExecuteThreshold.."]",
ExecuteSound	="Звук добивания",
ExecuteSoundDesc	="При достижении цели порога добивания прозвучит звук что цель \"сломлена\".\n"..default..(BUI.Defaults.ExecuteSound and on or off).."]",
BossFrame	="Дополнительная панель боссов",
BossFrameDesc	="Когда появляется босс то возникает дополнительная панель с его/их здоровьем"..default..(BUI.Defaults.BossFrame and on or off).."]",
BossWidth	="Ширина",
--BossWidthDesc	="Set the width of bosses frames.\n"..default..BUI.Defaults.BossWidth.."]",
BossHeight	="Высота",
--BossHeightDesc	="Set the height of bosses frames.\n"..default..BUI.Defaults.BossHeight.."]",

Attackers	="Противники",
AttackersDesc	="Показывает имена нападающих и наносимый ими урон.\n"..default..(BUI.Defaults.Attackers and on or off).."]",
AttackersWidth	="Ширина",
AttackersWidthDesc	=default..BUI.Defaults.AttackersWidth.."]",
AttackersHeight	="Высота",
AttackersHeightDesc	=default..BUI.Defaults.AttackersHeight.."]",

--Fonts
FrameFont1	="Основной шрифт",
FrameFont1Desc	="Выбор основного шрифта текста на панелях атрибутов.\n"..default..BUI.TranslateFont(BUI.Defaults.FrameFont1).."]",
FrameFont2	="Дополнительный шрифт",
FrameFont2Desc	="Выбор дополнительного шрифта текста на панелях атрибутов.\n"..default..BUI.TranslateFont(BUI.Defaults.FrameFont2).."]",
FrameFontSize	="Размер шрифта",
FrameFontSizeDesc	="Изменение размера шрифта текста на панелях атрибутов.\n"..default..BUI.Defaults.FrameFontSize.."]",
FrameOpacityIn	="Прозрачность в бою",
FrameOpacityInDesc	="Устанавливает уровень прозрачности панелей в бою. Чем меньше значение тем прозрачнее панели.\n"..default..BUI.Defaults.FrameOpacityIn.."]",
FrameOpacityOut	="Прозрачность вне боя",
FrameOpacityOutDesc	="Устанавливает уровень прозрачности панелей вне боя. Чем меньше значение тем прозрачнее панели.\n"..default..BUI.Defaults.FrameOpacityOut.."]",

--Colors
SelfColor	="Дифференциация игрока в группе цветом",
SelfColorDesc	="Цвет имени игрока в группе будет отличаться от остальных.\n"..default..(BUI.Defaults.SelfColor and on or off).."]",

CustomEdgeColor	="Цвет \"custom\" темы",
CustomEdgeColorDesc	="Цвет границ элементов игрового интерфейса.\n"..default..BUI.TranslateColor(BUI.Defaults.CustomEdgeColor).."]",
AdvancedThemeColor	="Цвет \"advanced\" темы",
AdvancedThemeColorDesc	="Цвет элементов игрового интерфейса в режиме \"advanced\".\n"..default..BUI.TranslateColor(BUI.Defaults.AdvancedThemeColor).."]",

FrameHealthColor	="Цвет атрибута здоровья",
FrameHealthColorDesc	=default..BUI.TranslateColor(BUI.Defaults.FrameHealthColor).."]",
FrameMagickaColor	="Цвет атрибута маны",
FrameMagickaColorDesc	=default..BUI.TranslateColor(BUI.Defaults.FrameMagickaColor).."]",
FrameStaminaColor	="Цвет атрибута стамины",
FrameStaminaColorDesc	=default..BUI.TranslateColor(BUI.Defaults.FrameStaminaColor).."]",
FrameShieldColor	="Цвет панели щита",
FrameShieldColorDesc	=default..BUI.TranslateColor(BUI.Defaults.FrameShieldColor).."]",
SameColors	="Cброс градиента",

ColorRoles	="Цвета по роли в группе",
ColorRolesDesc	="Для каждой роли используются отдельные цвета панелей.\n"..default..(BUI.Defaults.ColorRoles and on or off).."]",
FrameTankColor	="Цвет роли танка",
FrameTankColorDesc	="Задает цвет панели игрока с ролью танка в группе.\n"..default..BUI.TranslateColor(BUI.Defaults.FrameTankColor).."]",
FrameHealerColor	="Цвет роли лекаря",
FrameHealerColorDesc	="Задает цвет панели игрока с ролью хила в группе.\n"..default..BUI.TranslateColor(BUI.Defaults.FrameHealerColor).."]",
FrameDamageColor	="Цвет роли дамагера",
FrameDamageColorDesc	="Задает цвет панели игрока с ролью ДД в группе.\n"..default..BUI.TranslateColor(BUI.Defaults.FrameDamageColor).."]",

--Group frame
RaidFrames	="Включить панель группы",
RaidFramesDesc	="Заменяет стандартные панели группы/рейда.\n"..default..(BUI.Defaults.RaidFrames and on or off).."]",
RaidCompact	="Компактный режим",
RaidCompactDesc	="(Бафы группы и ДПС будут отключены чтоб панели можно было \"сдвинуть\").\n"..default..(BUI.Defaults.RaidCompact and on or off).."]",
GroupAnimation	="Анимация состояний",
GroupAnimationDesc	="Включает анимацию состояний пополнения/убывания здоровья.\n"..default..(BUI.Defaults.GroupAnimation and on or off).."]",
GroupBuffs	="Бафы группы",
GroupBuffsDesc	="Включает значки базовых эффектов членов группы.\n"..default..(BUI.Defaults.GroupBuffs and on or off).."]",
GroupDeathSound	="Звук смерти члена группы",
--GroupDeathSoundDesc	="При смерти сопартийца прозвучит оповещение.\n"..default..(BUI.Defaults.GroupDeathSound and on or off).."]",
RaidLevels	="Показывать уровни",
RaidLevelsDesc	=default..(BUI.Defaults.RaidLevels and on or off).."]",
RaidColumnSize	="Размер столбца в рейде",
RaidColumnSizeDesc	="Колличество панелей игроков в столбце.\n"..default..BUI.Defaults.RaidColumnSize.."]",
RaidWidth	="Ширина панелей группы",
RaidWidthDesc	=default..BUI.Defaults.RaidWidth.."]",
RaidHeight	="Высота панелей группы",
RaidHeightDesc	=default..BUI.Defaults.RaidHeight.."]",
RaidFontSize	="Размер шрифта панелей группы",
RaidFontSizeDesc	=default..BUI.Defaults.RaidFontSize.."]",
RaidStatValue	="Цифровые значения",
SmallGroupScale	="Увеличение для малой группы",
SmallGroupScaleDesc	="Увеличение размера панелей для малой группы.\n"..default..BUI.Defaults.SmallGroupScale.."%]",
LargeRaidScale	="Уменьшение для рейда",
LargeRaidScaleDesc	="Уменьшение размера панелей для большого рейда.\n"..default..BUI.Defaults.LargeRaidScale.."%]",
FrameNameFormat	="Формат имени",
FrameNameFormatValues	={"Name","@AccName","Name@AccName"},
--Stats share
StatShare	="Передавать свои атрибуты",
StatShareDesc	="Показывать группе свои текущие значения основного атрибута и набранный ультимейт.\n"..default..(BUI.Defaults.StatShare and on or off).."]",
StatShareUlt	="Показывать ультимейты группы",
StatShareUltDesc	="Специфическая функция, которая добавляет к панелям группы лишний хлам.\n"..default..(BUI.Defaults.StatShareUlt and on or off).."]",
UltimateOrder	="Панель очередности ультимейт",
UltimateOrderDesc	="Показывает очередность Горнов и Коллосов в группе.\n"..default..select(BUI.Defaults.UltimateOrder,"Enabled","Auto","Disabled").."]",
--Group synergy
GroupSynergy	="Откаты синергий",
GroupSynergyDesc	="Показывает откаты синергий членов группы.\n"..default..select(BUI.Defaults.GroupSynergy,"All","Tanks","Disabled").."]",
GroupSynergyCount	="Количество отображаемых синергий",
GroupSynergyCountDesc	=default..BUI.Defaults.GroupSynergyCount.."]",
--Group leader
GroupLeaderHeader	="Лидер группы",
MarkerLeader	="Маркер лидера группы",
MarkerSize		="Размер маркера",

--Curved Frames
CurvedFrame	="Стиль изогнутых панелей",
CurvedFrameDesc	=default..BUI.Defaults.CurvedFrame.."]",
CurvedDistance	="Расстояние от центра",
CurvedDistanceDesc	=default..BUI.Defaults.CurvedDistance.."]",
CurvedDistanceWarn	="Во время настройки через меню эффект не может быть показан так как фреймы перемещены",
CurvedOffset	="Вертикальное смещение",
CurvedOffsetDesc	=default..BUI.Defaults.CurvedOffset.."]",
CurvedHeight	="Длинна",
CurvedHeightDesc	=default..BUI.Defaults.CurvedHeight.."]",
CurvedDepth	="Ширина и изгиб",
CurvedDepthDesc	=default..BUI.Defaults.CurvedDepth*100 .."]",
CurvedStatValues	="Значения атрибутов",
CurvedStatValuesDesc	=default..(BUI.Defaults.CurvedStatValues and on or off).."]",

--Damage Report Menu
StatMiniHeader	="Миниметр",
StatsMiniMeter	="Показывать Миниметр",
StatsMiniMeterDesc	=default..(BUI.Defaults.StatsMiniMeter and on or off).."]",
MiniMeterAplha	="Прозрачность Миниметра",
MiniMeterAplhaDesc	=default..BUI.Defaults.MiniMeterAplha*100 .."]",
StatsMiniHealing	="Показывать на Миниметре ХПС",
StatsMiniHealingDesc	=default..(BUI.Defaults.StatsMiniHealing and on or off).."]",
StatsMiniGroupDps	="Показывать на Миниметре групповой ДПС",
StatsMiniGroupDpsDesc	=default..(BUI.Defaults.StatsMiniGroupDps and on or off).."]",
StatsMiniSpeed	="Показывать на Миниметре скорость ротации",
StatsMiniSpeedDesc	=default..(BUI.Defaults.StatsMiniSpeed and on or off).."]",

StatsUpdateDPS	="Передавать свой ДПС",
StatsUpdateDPSDesc	=default..(BUI.Defaults.StatsUpdateDPS and on or off).."]",
StatsGroupDPS	="ДПС на панелях группы",
StatsGroupDPSDesc	="В конце боя показывает ДПС членов группы на их панелях секции группы (не доступно в компактном режиме).\n"..default..(BUI.Defaults.StatsGroupDPS and on or off).."]",
StatsGroupDPSframe	="ДПС на отдельной панели",
StatsGroupDPSframeDesc	="Показывать ДПС членов группы на отдельной панели.\n"..default..(BUI.Defaults.StatsGroupDPSframe and on or off).."]",

StatsSplitElements	="Разделять элементальный урон",
StatsSplitElementsDesc	="Урон от ударов посохом, умения Force Shock а так же от Ilambris будут разложены на типы элементов.\n"..default..(BUI.Defaults.StatsSplitElements and on or off).."]",

StatsBuffs	="Включить бафы игрока и целей в отчет",
StatsBuffsDesc	="Добавляет в отчет две дополнительные области с бафами/дебафами игрока и целей. Если выключено то эти данные попросту не собираются.\n"..default..(BUI.Defaults.StatsBuffs and on or off).."]",

Log	="Запись боя",
LogDesc	="(утилита разработчика)\nUsed as detailed death recap or as developers info about game mechanics. Works with enabled statistics and notifications modules.\nBind key in controls settings.\n"..default..(BUI.Defaults.Log and on or off).."]",

--Buffs
PlayerBuffs	="Показывать бафы игрока",
PlayerBuffsDesc	="Все единовременные, пассивные, долговременные эффекты и состояния выводятся на одну панель. Те что получены извне будут в зеленой рамочке, отрицательные эффекты в красной.\n"..default..(BUI.Defaults.PlayerBuffs and on or off).."]",
BuffsOtherHide	="Скрывать эффекты полученные не от игрока",
BuffsOtherHideDesc	="На цели не будут отображаться эффекты бафов и дебафов которые не накладывал сам игрок но будут отображаться такие важные бафы/дебафы как Дерйн, Алкош и т.д.\n"..default..(BUI.Defaults.BuffsOtherHide and on or off).."]",
BuffsImportant	="Выделять важные эффекты",
BuffsImportantDesc	="Значки важных эффектов (Horn, Drain, Taunt и пр.) а так же срабатывания сетов (Moondancer, BSW, SPC, Alcosh и пр.) будут иметь увеличенный размер.\n"..default..(BUI.Defaults.BuffsImportant and on or off).."]",
MinimumDuration	="Минимальная длительность",
MinimumDurationDesc	=default..BUI.Defaults.MinimumDuration.."]",
BuffsActions	="Дублировать в бафы значки Умений",
BuffsActionsDesc	=default..(BUI.Defaults.BuffsActions and on or off).."]",
PlayerBuffsAlign	="Ориентация бафов игрока",
PlayerBuffsAlignDesc	=default..AlignValues[BUI.Defaults.PlayerBuffsAlign].."]",
TargetBuffsAlign	="Ориентация бафов цели",
TargetBuffsAlignDesc	=default..AlignValues[BUI.Defaults.TargetBuffsAlign].."]",
PlayerBuffSize	="Размер значков бафов игрока",
PlayerBuffSizeDesc	=default..BUI.Defaults.PlayerBuffSize.."]",

TargetBuffs	="Показывать бафы цели",
TargetBuffsDesc	=default..(BUI.Defaults.TargetBuffs and on or off).."]",
TargetBuffSize	="Размер значков бафов цели",
TargetBuffSizeDesc	=default..BUI.Defaults.TargetBuffSize.."]",

BuffsPassives	="Единовременные эффекты",
BuffsPassivesDesc	=default..(BUI.Defaults.BuffsPassives and on or off).."]",
PassiveProgress	="Включить панели прогресса",
PassiveProgressDesc	=default..(BUI.Defaults.PassiveProgress and on or off).."]",
PassivePWidth	="Ширина панелей прогресса",
PassivePWidthDesc	=default..BUI.Defaults.PassivePWidth.."]",
PassivePSide	="Сторона панелей прогресса",
PassivePSideDesc	=default..BUI.Defaults.PassivePSide.."]",
PassiveOakFilter="Скрыть баффы Oakensoul",
PassiveOakFilterDesc=default..(BUI.Defaults.PassiveOakFilter and on or off).."]",

BlackListHeader	="Черный список",
EnableBlackList	="Применять к бафам черный список",
EnableBlackListDesc	=default..(BUI.Defaults.EnableBlackList and on or off).."]",
BlackListAdd	="Добавить в черный список",
BlackListAddDesc	="Введите точное название бафа (с соблюдением регистра) или его id.\nТак же можно добавлять бафы правым щелчком мыши по ним в панели бафов.",
BlackListDel	="Убрать из черного списка",
BlackListDelDesc	="Выберите баф который нужно убрать из черного списка",
PassiveBuffSize	="Размер значков пассивных бафов",
PassiveBuffSizeDesc	=default..BUI.Defaults.PassiveBuffSize.."]",

CustomBuffsHeader	="Дополнительная панель бафов",
EnableCustomBuffs	="Включить дополнительную панель",
EnableCustomBuffsDesc	=default..(BUI.Defaults.EnableCustomBuffs and on or off).."]",
CustomBuffsAdd	="Добавить баф",
CustomBuffsAddDesc	="Введите точное название бафа (с соблюдением регистра) или его id. Так же можно добавлять бафы левым щелчком мыши по ним в панели бафов.",
CustomBuffsDel	="Убрать баф",
CustomBuffsDelDesc	="Выберите баф который нужно убрать из дополнительной панели.",
CustomBuffsDirection	="Положение панели",
CustomBuffsDirectionDesc	=default..BUI.Defaults.CustomBuffsDirection.."]",
CustomBuffsProgress	="Включить панели прогресса",
CustomBuffsProgressDesc	="Добавляет к бафам дополнительной панели прогресс бары. Доступно только при вертикальной ориентации.\n"..default..(BUI.Defaults.CustomBuffsProgress and on or off).."]",
CustomBuffsPWidth	="Ширина панелей прогресса",
CustomBuffsPWidthDesc	=default..BUI.Defaults.CustomBuffsPWidth.."]",
CustomBuffsPSide	="Сторона панелей прогресса",
CustomBuffsPSideDesc	=default..BUI.Defaults.CustomBuffsPSide.."]",
CustomBuffSize	="Размер значков",
CustomBuffSizeDesc	=default..BUI.Defaults.CustomBuffSize.."]",

SynergyCdHeader	="Панель синергий",
EnableSynergyCd	="Панель синергий",
EnableSynergyCdDesc	=default..(BUI.Defaults.EnableSynergyCd and on or off).."]",
SynergyCdDirection	="Положение панели",
SynergyCdDirectionDesc	=default..BUI.Defaults.SynergyCdDirection.."]",
SynergyCdProgress	="Включить панели прогресса",
SynergyCdProgressDesc	="Доступно только при вертикальной ориентации.\n"..default..(BUI.Defaults.SynergyCdProgress and on or off).."]",
SynergyCdPWidth	="Ширина панелей прогресса",
SynergyCdPWidthDesc	=default..BUI.Defaults.SynergyCdPWidth.."]",
SynergyCdPSide	="Сторона панелей прогресса",
SynergyCdPSideDesc	=default..BUI.Defaults.SynergyCdPSide.."]",
SynergyCdSize	="Размер значков",
SynergyCdSizeDesc	=default..BUI.Defaults.SynergyCdSize.."]",

--Widgets
WidgetsHeader	="Виджеты",
EnableWidgets	="Включить Виджеты",
EnableWidgetsDesc	=default..(BUI.Defaults.EnableWidgets and on or off).."]",
WidgetsSize	="Размер Виджетов",
WidgetsSizeDesc	=default..BUI.Defaults.WidgetsSize.."]",
WidgetsAdd	="Добавить Виджет",
WidgetsAddDesc	="Введите точное название бафа (с соблюдением регистра) или его id. Так же можно добавлять бафы щелчком колеса мыши по ним в панели бафов",
WidgetsProgress	="Панель прогресса",
WidgetsPWidth	="Ширина панелей прогресса",
WidgetsPWidthDesc	=default..BUI.Defaults.WidgetsPWidth.."]",
WidgetsMultiTarget	="Несколько целей",
WidgetsSelfEffects	="Только эффекты игрока",
WidgetsAlwaysShow	="Показывать всегда",
WidgetsCombine	="Дополнительный эффект",
WidgetsCombineDesc	="Тут можно указать ID или название дополнительного эффекта.\nДля сброса нужно ввести пустое значение",
WidgetPotion	="Виджет отката банки",
WidgetPotionDesc	="Показывает значок банки при недостатке ресурсов и если банка доступна к использованию.\n"..default..(BUI.Defaults.WidgetPotion and on or off).."]",
WidgetsPSide	="Сторона панели прогресса",
WidgetsCooldownDesc	="Тут можно задать собственный период (в милисекундах).\nДля сброса нужно ввести пустое значение.",
WidgetsManage	="Управление виджетами",
WidgetsReset	="Сброс расположения",
WidgetsAbility	="Способности",
WidgetsAbilityDesc	="\"Тайминги умений\" должны быть включены",
WidgetsBuff		="Недавние бафы",
WidgetsBuffDesc	="Damage statistics buffs должны быть включены",
WidgetsCustom	="Вручную",

--Actions
Actions	="Включить тайминги умений",
ActionsDesc	=default..(BUI.Defaults.Actions and on or off).."]",
ActionsPrecise	="Режим точности",
ActionsPreciseDesc	="В режиме точности тайминги запускаются когда использованное умение вступает в силу.\n"..default..(BUI.Defaults.ActionsPrecise and on or off).."]",
ProcAnimation	="Анимация включившихся умений",
ProcAnimationDesc	='Анимация "готовности" для Crystal Fragments, Assasins will, Blastbones\n'..default..(BUI.Defaults.ProcAnimation and on or off).."]",
ProcSound	="Звук включившихся умений",
UseSwapPanel	="Показывать вторую панель",
UseSwapPanelDesc	=default..(BUI.Defaults.UseSwapPanel and on or off).."]",
HideSwapPanel	="Скрывать неактивные умения",
HideSwapPanelDesc	=default..(BUI.Defaults.UseSwapPanel and on or off),
ExpiresAnimation	="Анимация истечения действия",
ExpiresAnimationDesc	=default..(BUI.Defaults.ExpiresAnimation and on or off).."]",
ActionsFontSize	="Размер шрифта",
ActionsFontSizeDesc	=default..BUI.Defaults.ActionsFontSize.."]",

--Automation
AutoConfirm	="Автозапуск",
UndauntedDaily	="сегодня",
UndauntedQuest	="Задание",
UndauntedDone	="Готово",
AutomationHeader	="Автоматизация",
ReloadUiWarn1	="Изменение этой настройки требует перезагрузки интерфейса.",
Teleporter	="Телепортер",
TeleporterDesc	="Кнопки \"телепортера\" надстройки ChatTabSelector.",
DeleteMail	="Удаление пустых писем",
DeleteMailDesc	="Отключает диалог подтверждения при удалении пустых писем.",
JumpToLeader	="Телепортация к лидеру",
JumpToLeaderDesc	="Отключает приглашение портоваться к лидеру группы.",
GroupLeave	="Покидание группы",
GroupLeaveDesc	="Отключает диалог подтверждения при выходе из группы.",
Books	="Авто закрытие книг",
BooksDesc	="Если книгу все же нужно прочесть то откройте ее повторно.",
LargeGroupInvite	="Увеличение группы до большой",
LargeGroupInviteDesc	="Отключает диалог подтверждения при приглашении 5-го члена группы.",
LargeGroupAnnoucement	="Сообщение о большой группе",
LargeGroupAnnoucementDesc	="Отключает сообщение в чате о том что ваша группа большая/маленькая.",
FriendStatus	="Статусы друзей",
FriendStatusDesc	="Отключает сообщения в чате о том что друг вошел/вышел.",
FastTravel	="Телепортация без подтверждения",
FastTravelDesc	="Отключает диалог подтверждения при телепортации через \"дорожное святилище\".",
InitialDialog	="Начальный диалог с NPC",
InitialDialogDesc	="Пропускает начальный диалог при взятии квеста, торговле, открытии банка.",
RepeatableQuests	="Повторяемые задания",
RepeatableQuestsDesc	="Автоматически брать/сдавать повторяемые задания.",
CovetousCountess	="Гильдия воров: Covetous Countess",
CovetousCountessDesc	="Пропуск квестов с низкой наградой.",
DarkBrotherhoodSpree	="Темное братство: Spree сontracts",
DarkBrotherhoodSpreeDesc	="Пропуск квестов с низкой наградой. Не работает: автору в лом всё переделывать под новый перевод.",
--FeedSynergy	="Синергия вампира",
--FeedSynergyDesc	="Отключает синергию вампира для удобного использования \"клинка горя\".",
AdvancedSynergy	="Контроль синергий",
AdvancedSynergyDesc	="Отключает \"Charged Lightning\"(Атронаха) для танков и хилов.\nКлаудрест: Автоматически отклоняет синергии которые могут помешать входу в портал или сбросить с себя \"Shed Hoarfrost\"(лёд), если они возникли непосредственно перед необходимостью активировать более приоритетную синергию.\n"..default..(BUI.Defaults.AdvancedSynergy and on or off).."]",
BlockAnnouncement	="Блокировка рекламы",
BlockAnnouncementDesc	="Отключает рекламу при входе в игру.",
ContainerHandler	="Открытие контейнеров",
ContainerHandlerDesc	="Добавляет в инвентарь функции для автоматической чистки рыбы и открытия всех контейнеров.",
StealthWield	="Подготовка оружия в \"стелсе\"",
StealthWieldDesc	="Автоматически доставать оружие когда игрок крадется.",
LootStolen	="Кража из контейнеров",
LootStolenDesc	="Автоматически производит кражу если игрока никто не видит.",
UndauntedPledges	="Маркировка заданий Неустрашимых",
UndauntedPledgesDesc	="Выделяет цветом данжи в окне подбора группы для которых взят квест от Неустрашимых. Добавляет отметки о полученных достижениях.",
CollapseNormalDungeon	="Свернуть обычные подземелья",
CollapseNormalDungeonDesc	="Свернуть обычные подземелья во время окна поиска подземелий.\nДоступно, только если включен режим Неустрашимых.",
ConfirmLocked	="Авто подтверждения",
ConfirmLockedDesc	="Вставляет текст \"CONFIRM\" в диалог подтвержения трансмутации/улучшения/зачарования заблокированных предметов.",
PlayerToPlayer	="Радиальное меню взаимодействий",
PlayerToPlayerDesc	="Убирает опцию \"Исключить из группы\" из радиального меню взаимодействия с членом группы (сделано чтоб предотвратить возможность ненамеренного исключения членов группы при попытке воскрешения).",
BuiltInGlobalCooldown="Активировать встроенный глобальный кулдаун",
BuiltInGlobalCooldownDesc="Устанавливает встроенное глобальное время восстановления при входе в систему.",
ActFinderButton	="Выбрать активные задания",

Meters_Header	="Датчики",
Meter_Speed	="Скорость",
Meter_SpeedDesc	="Показывает скорость передвижения игрока.",
Meter_Power	="Сила",
Meter_PowerDesc	="Показывает силу оружия или заклинаний игрока.",
Meter_Crit	="Крит",
Meter_CritDesc	="Показывает шанс крита оружия или заклинаний игрока.",
Meter_Exp	="Опыт",
Meter_ExpDesc	="Показывает прогресс уровня игрока.",
Meter_DPS	="ДПС",
Meter_DPSDesc	="Показывает урон в секунду.",
Meter_Criminal	="Преступник",
Meter_CriminalDesc	="Показывает время в течении которого за поимку игрока назначена награда, время в течении которого с игроком не станут говорить неигровые персонажи.",
Meter_Scale	="Размер датчиков",
}