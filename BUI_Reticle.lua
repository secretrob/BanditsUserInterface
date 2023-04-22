local bot_bar={
[1]={.71875,.75,.5},
[2]={.6875,.71875,.5},
[3]={.59375,.6875,1.5},
[4]={.5,.59375,1.5},
[5]={.375,.5,2},
[6]={.25,.375,2},
[7]={.125,.25,2},
[8]={0,.125,2},
taunt_w=35,
cast_w=46
}
local res_bg={
--[0]={.96875,1,.5},
[1]={.9375,.96875,.5,2},
[2]={.875,.9375,1,3},
[3]={.78125,.875,1.5,4},
--[4]={.65625,.78125,2},
[4]={.53125,.65625,2,6},
[5]={.40625,.53125,2,7},
dy=8,
w=40
}
local res_bar={
[1]={0,.0625,1,TOPLEFT,BOTTOMLEFT,BOTTOMLEFT,BOTTOM},
[2]={.0625,.125,1,TOPLEFT,BOTTOMLEFT,BOTTOMLEFT,BOTTOM},
[3]={.125,.1875,1,TOPLEFT,BOTTOMLEFT,BOTTOMLEFT,BOTTOM},
[4]={.1875,.21875,.5,TOPLEFT,LEFT,LEFT,CENTER},
[5]={.21875,.28125,1,TOPLEFT,TOPLEFT,BOTTOMLEFT,BOTTOM},
[6]={.28125,.34375,1,TOPLEFT,TOPLEFT,BOTTOMLEFT,BOTTOM},
[7]={.34375,.40625,1,TOPLEFT,TOPLEFT,BOTTOMLEFT,BOTTOM},
}
local InCombatLock,rotation_value,rotation_step=false,0,0
local ICON_SIZE=24
local CombatPet={
	--Familiar
	[zo_strformat("<<z:1>>", GetAbilityName(18602))]=true,
	--Clannfear
	["clannfear"]						=true,	--en
	["clannbann"]						=true,	--de
	["faucheclan"]						=true,	--fr
	--Volatile Familiar
	[zo_strformat("<<z:1>>", GetAbilityName(30678))]=true,
	["familier explosif"]					=true,	--fr
	--Twilight Tormentor
	[zo_strformat("<<z:1>>", GetAbilityName(30594))]=true,
	["zwielichtpeinigerin"]					=true,	--de
	["tourmenteur crépusculaire"]				=true,	--fr
	--Twilight Matriarch
	[zo_strformat("<<z:1>>", GetAbilityName(30629))]=true,
	--Bears
	[zo_strformat("<<z:1>>", GetAbilityName(94376))]=true,	--Feral Guardian
	[zo_strformat("<<z:1>>", GetAbilityName(94394))]=true,	--Eternal Guardian
	[zo_strformat("<<z:1>>", GetAbilityName(94408))]=true,	--Wild Guardian
}

function BUI.Reticle.InCombat(inCombat)
	local function SetReticleColor(color)
		ZO_ReticleContainerReticle:SetColor(unpack(color))
		ZO_ReticleContainerReticle.animation:SetEndColor(unpack(inCombat and {1,0,0,1} or {1,1,1,1}))
		ZO_ReticleContainerStealthIconStealthEye:SetColor(unpack(color))
	end

	local function InCombatLockCheck()
		local lock=(GetGameTimeMilliseconds()-BUI.Damage.last-10000)<0
		if InCombatLock~=lock then
			InCombatLock=lock
			SetReticleColor(InCombatLock and {1,0,0,1} or {1,1,.2,1})
			CALLBACK_MANAGER:FireCallbacks("BUI_InCombatLock", lock)
		end
	end

	if inCombat then
		InCombatLock=(GetGameTimeMilliseconds()-BUI.Damage.last-10000)<0
		SetReticleColor(InCombatLock and {1,0,0,1} or {1,1,.2,1})
		EVENT_MANAGER:RegisterForUpdate("BUI_InCombatLockCheck", 1000, InCombatLockCheck)
	else
		InCombatLock=false
		BUI.Damage.last=0
		SetReticleColor({1,1,1,1})
		EVENT_MANAGER:UnregisterForUpdate("BUI_InCombatLockCheck")
		CALLBACK_MANAGER:FireCallbacks("BUI_InCombatLock", false)
	end
end

function BUI.Reticle.Mode(n)
	if n==1 then
		ZO_ReticleContainerReticle:SetAlpha(1)
		ZO_ReticleContainerReticle:SetTexture('EsoUI/Art/Reticle/reticleAnim.dds')
	elseif n==8 then
		ZO_ReticleContainerReticle:SetAlpha(1)
		ZO_ReticleContainerReticle:SetTexture('esoui/art/reticle/reticleanim-circle.dds')
	else
		ZO_ReticleContainerReticle:SetAlpha(.6)
		ZO_ReticleContainerReticle:SetTexture('/BanditsUserInterface/textures/reticle/reticle'.. n ..'.dds')
	end
	--Preferred target focus
	rotation_value=n==10 and 0 or (n>=5 and math.pi*.065 or math.pi*.05)
end

function BUI.Reticle.Blocking()
	local function isBlocking()
		local blocking=IsBlockActive()
		if BUI.Blocking~=blocking then
			BUI.Blocking=blocking
			CALLBACK_MANAGER:FireCallbacks("BUI_Blocking",blocking)
			BUI.Reticle.Mode(blocking and 10 or BUI.Vars.ReticleMode)
		end
	end

	if BUI.Vars.BlockIndicator then
		EVENT_MANAGER:RegisterForUpdate("BUI_Blocking", 250,isBlocking)
	else
		EVENT_MANAGER:UnregisterForUpdate("BUI_Blocking")
	end
end

function BUI.Reticle.TargetFocus(direction)
	local function PreferredTargetFocus()
		rotation_step=rotation_step+direction
		if rotation_step>5 or rotation_step<0 then
			rotation_step=rotation_step>5 and 5 or 0
			EVENT_MANAGER:UnregisterForUpdate("BUI_TargetFocus")
		else
			ZO_ReticleContainerReticle:SetTextureRotation(rotation_value*rotation_step)
		end
	end
	EVENT_MANAGER:RegisterForUpdate("BUI_TargetFocus", 15, PreferredTargetFocus)
end

function BUI.Reticle.Invul()
	if not BUI.Vars.ReticleInvul or not BUI.Vars.ReticleInvul or BUI.Group[BUI.Target.name] or CombatPet[string.lower(BUI.Target.name)] then return end
	if BUI.Target.Invul then
		BUI_InvulTarget:SetColor(1,1,.7,1)
		BUI_InvulTarget:SetHidden(false)
	elseif BUI.Target.shield.current>500 then
		BUI_InvulTarget:SetColor(.4,.4,.9,1)
		BUI_InvulTarget:SetHidden(false)
	else
		BUI_InvulTarget:SetHidden(true)
	end
end

function BUI.Reticle.Controlled(init)
	if not BUI.Vars.Controlled then return end
	if init==false then BUI_Controlled:SetText("") EVENT_MANAGER:UnregisterForUpdate("BUI_ReticleControlled") return end
	local now=GetGameTimeMilliseconds()
	if BUI.Controlled[BUI.Target.name] and BUI.Controlled[BUI.Target.name]+10000>now then
		BUI_Controlled:SetText(BUI.GetIcon("esoui/art/icons/ability_debuff_stun.dds",ICON_SIZE).." "..math.floor((BUI.Controlled[BUI.Target.name]+10000-now)/1000+.45))
		if init then EVENT_MANAGER:RegisterForUpdate("BUI_ReticleControlled", 1000, BUI.Reticle.Controlled) end
	else
		BUI.Controlled[BUI.Target.name]=nil
		BUI_Controlled:SetText("")
		EVENT_MANAGER:UnregisterForUpdate("BUI_ReticleControlled")
	end
end

function BUI.Reticle.LeaderArrow()
	local texture=BUI_LeaderBar
	local width=72
	local scaleX,scaleY=BUI.MapData()
	if not texture then
		texture=WINDOW_MANAGER:CreateControl("BUI_LeaderBar", ZO_ReticleContainerReticle, CT_TEXTURE)
		texture:SetDimensions(width,width/3*2)
		texture:ClearAnchors()
		texture:SetAnchor(BOTTOM,ZO_ReticleContainerReticle,CENTER,0,0)
		texture:SetTexture('/BanditsUserInterface/textures/reticle/arrow_bar.dds')
		texture:SetAlpha(.8)
	end
	texture:SetHidden(true)
	EVENT_MANAGER:UnregisterForUpdate("BUI_OnScreen_LeaderBar")

	local function NormalizeAngle(angle)
		if angle>math.pi then return angle-2*math.pi end
		if angle<-math.pi then return angle+2*math.pi end
		return angle
	end

	local function LeaderBar()
		texture:SetHidden(true)
		local tX, tY, _, inCurrentMap=GetMapPlayerPosition(BUI.GroupLeader)
		if inCurrentMap then
			local pX, pY=GetMapPlayerPosition("player")
			local dist=math.min(math.sqrt(((pX-tX)*scaleX^2)^2+((pY-tY)*scaleY^2)^2)*1000,.5)
--			BUI_TauntTimer:SetText(math.floor(dist*100))
			if dist>.03 then
				local angle=NormalizeAngle(math.atan2(pX-tX,pY-tY)-NormalizeAngle(GetPlayerCameraHeading()))
				texture:SetTextureCoords(dist/2,1-dist/2,0,1)
				texture:SetWidth(width*(1-dist))
				texture:SetTextureRotation(angle,.5,1)
				texture:SetHidden(false)
			end
		end
	end

	if BUI.Vars.LeaderArrow and IsUnitGrouped('player') and BUI.GroupLeader and not BUI.Player.isLeader then
		EVENT_MANAGER:RegisterForUpdate("BUI_OnScreen_LeaderBar", 40, LeaderBar)
	end
end

function BUI.Reticle.SpeedBoost()
	if BUI.Vars.ReticleBoost then
		local now=GetGameTimeMilliseconds()
		if BUI.Mounted and BUI.Gallop and BUI.Gallop>now then
			BUI_ReticleBoost:SetHidden(false)
		elseif not BUI.Mounted and BUI.Expedition and BUI.Expedition>now then
			BUI_ReticleBoost:SetHidden(false)
		else
			BUI_ReticleBoost:SetHidden(true)
		end
	end
end

local function UI_Init()
	local width=64
	--Impactful hit animation
	local texture=ZO_ReticleContainerReticle
	local animation, timeline=CreateSimpleAnimation(ANIMATION_COLOR,texture,0)
	animation:SetEndColor(1,0,0,1)
	animation:SetStartColor(1,1,1,.5)
	animation:SetEasingFunction(ZO_EaseOutQuadratic)
	animation:SetDuration(750)
	timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
	texture.timeline=timeline
	texture.animation=animation
	--Root container
	local container=_G["BUI_Reticle"]
	if not container then
		container=WINDOW_MANAGER:CreateControl("BUI_Reticle",ZO_ReticleContainer,CT_CONTROL)
		container:ClearAnchors()
		container:SetAnchor(CENTER,ZO_ReticleContainer,CENTER,0,0)
		container:SetDimensions(width,width)
		container:SetAlpha(.6)
	end
	--Speed boost
	local boost=BUI_ReticleBoost or WINDOW_MANAGER:CreateControl("BUI_ReticleBoost", container, CT_TEXTURE)
	boost:SetDimensions(32,16)
	boost:ClearAnchors()
	boost:SetAnchor(TOP,container,BOTTOM,0,0)
	boost:SetTexture('/BanditsUserInterface/textures/reticle/boost.dds')
	boost:SetHidden(true)
	--Reticle invulnerable info
	local invul=BUI_InvulTarget or WINDOW_MANAGER:CreateControl("BUI_InvulTarget", container, CT_TEXTURE)	--ZO_TargetUnitFramereticleoverUnwaveringOverlayContainer
	invul:SetDimensions(64,64)
	invul:ClearAnchors()
	invul:SetAnchor(CENTER,container,CENTER,0,0)
	invul:SetTexture('/BanditsUserInterface/textures/reticle/circle_bar.dds')
	invul:SetColor(1,1,.7,1)
--	invul:SetDrawLayer(1)
	invul:SetHidden(true)
	--Controlled
	BUI.UI.Label("BUI_Controlled",	container,	{ICON_SIZE*4,ICON_SIZE},	{BOTTOM,CENTER,0,-46},	BUI.UI.Font("esobold",ICON_SIZE), nil, {1,1}, "")
	--Taunt timer
	local fs	=16
	BUI.UI.Label("BUI_TauntTimer",	container,	{fs*1.5,fs},	{CENTER,CENTER,0,-1},	BUI.UI.Font("esobold",fs), nil, {1,1}, "")
	--Taunt bar
	local bar=BUI_Reticle_Taunt
	if not bar then
		bar=WINDOW_MANAGER:CreateControl("BUI_Reticle_Taunt",container,CT_TEXTURE)
		bar:SetAnchor(TOP,container,CENTER,0,0)
		bar:SetTexture('/BanditsUserInterface/textures/reticle/bot_bar.dds')
		bar:SetHidden(true)
--		bar:SetDrawLayer(2)
	end
	--Cast bar
	local bar=BUI_Reticle_Cast
	if not bar then
		bar=WINDOW_MANAGER:CreateControl("BUI_Reticle_Cast",container,CT_TEXTURE)
		bar:SetAnchor(TOP,container,CENTER,0,0)
		bar:SetTexture('/BanditsUserInterface/textures/reticle/bot_bar.dds')
		bar:SetHidden(true)
--		bar:SetColor(.3,.3,.9,1)
--		bar:SetDrawLayer(2)
	end
	--Target resistance
	BUI.UI.Label("BUI_Reticle_Resist_Text",	container,	{fs*3.5,24*4},	{BOTTOMLEFT,BOTTOMRIGHT,0,-1},	BUI.UI.Font("esobold",fs), nil, {2,0}, "", false)
	--Target right bar
	local bar=BUI_Reticle_Right
	if not bar then
		bar=WINDOW_MANAGER:CreateControl("BUI_Reticle_Right",container,CT_TEXTURE)
		bar:SetAnchor(TOPLEFT,container,BOTTOM,0,res_bg.dy)
		bar:SetTexture('/BanditsUserInterface/textures/reticle/res_bar.dds')
		bar:SetTextureRotation(math.pi/2,0,0)
		bar:SetHidden(true)
		bar:SetDrawLayer(1)
	end
	for i=1,7 do
		bar[i]=WINDOW_MANAGER:CreateControl(nil,bar,CT_TEXTURE)
		bar[i]:SetAnchor(res_bar[i][4],bar,res_bar[i][5],0,res_bar[i][5]==2 and -res_bg.w-res_bg.w*.25 or -res_bg.w)
		bar[i]:SetTexture('/BanditsUserInterface/textures/reticle/res_bar.dds')
		bar[i]:SetTextureCoords(res_bar[i][1],res_bar[i][2],0,1)
		bar[i]:SetDimensions(res_bg.w*res_bar[i][3],res_bg.w)
		bar[i]:SetTextureRotation(math.pi/2,0,0)
		bar[i]:SetHidden(true)
		bar[i]:SetDrawLayer(2)
	end
	--Target left bar
	local bar=BUI_Reticle_Left
	if not bar then
		bar=WINDOW_MANAGER:CreateControl("BUI_Reticle_Left",container,CT_CONTROL)
		bar:ClearAnchors()
		bar:SetAnchor(CENTER,container,CENTER,0,0)
		bar:SetDimensions(width,width)
		bar:SetHidden(true)
	end
	for i=3,7 do
		local b=8-i
		bar[b]=WINDOW_MANAGER:CreateControl(nil,bar,CT_TEXTURE)
		bar[b]:SetAnchor(res_bar[i][6],bar,res_bar[i][7],0,i<4 and res_bg.dy-res_bg.w or res_bar[i][5]==2 and res_bg.w*.25 or res_bg.dy)
		bar[b]:SetTexture('/BanditsUserInterface/textures/reticle/res_bar.dds')
		bar[b]:SetTextureCoords(res_bar[i][1],res_bar[i][2],0,1)
		bar[b]:SetDimensions(res_bg.w*res_bar[i][3],res_bg.w)
		bar[b]:SetTextureRotation(-math.pi/2,0,0)
		bar[b]:SetColor(.7,.2,.9,1)
		bar[b]:SetDrawLayer(2)
	end
	BUI.init.Reticle=true
end

function BUI.Reticle.TauntTimer(timer)
	if BUI.Vars.TauntTimer>1 then BUI_TauntTimer:SetText(timer>0 and (timer<=3 and "|cFF2222" or "|c22FF22")..timer.."|r" or "") end
	if BUI.Vars.TauntTimer<3 then
		timer=math.floor(timer/2+.5)
		if timer<=0 then
			BUI_Reticle_Taunt:SetHidden(true)
		else
			BUI_Reticle_Taunt:SetDimensions(bot_bar.taunt_w*bot_bar[timer][3],bot_bar.taunt_w)
			BUI_Reticle_Taunt:SetTextureCoords(bot_bar[timer][1],bot_bar[timer][2],0,1)
			if timer<=2 then BUI_Reticle_Taunt:SetColor(.8,.2,.2,1) else BUI_Reticle_Taunt:SetColor(.2,.9,.3,1) end
			BUI_Reticle_Taunt:SetHidden(false)
		end
	end
end

function BUI.Reticle.CrusherTimer(timer)
	if timer==0 then
		BUI_Reticle_Left:SetHidden(true)
	else
		BUI_Reticle_Left:SetHidden(false)
		for i=1,5 do
			BUI_Reticle_Left[i]:SetHidden(i>timer)
		end
	end
end

function BUI.Reticle.CastBar(duration)
	if BUI.Vars.CastBar==2 and duration==1000 then return end
--	local start=GetGameTimeMilliseconds()
	local timer=duration
	local delta=duration/8.5
	local tick=tick or 0
	if duration==500 then
		if tick>0 then return end
		BUI_Reticle_Cast:SetColor(.8,.8,.9,1)
	else
		BUI_Reticle_Cast:SetColor(.3,.3,.9,1)
	end
	local function Update()
		tick=math.floor(timer/delta)
		if tick==0 then
			BUI_Reticle_Cast:SetHidden(true)
--			d(GetGameTimeMilliseconds()-start)
		else
			BUI_Reticle_Cast:SetDimensions(bot_bar.cast_w*bot_bar[tick][3],bot_bar.cast_w)
			BUI_Reticle_Cast:SetTextureCoords(bot_bar[tick][1],bot_bar[tick][2],0,1)
			BUI_Reticle_Cast:SetHidden(false)
			timer=timer-delta
			BUI.CallLater("ReticleCastBar",delta,Update)
		end
	end
	Update()
end
--[[
function BUI.Reticle.Preview()
	if not BUI_Reticle_BG or BUI_Reticle_BG:IsHidden() then
		BUI.UI.Backdrop(	"BUI_Reticle_BG",	ZO_ReticleContainer,	{128,128},	{CENTER,CENTER,0,0},	{0,0,0,1}, {0,0,0,1})
		BUI_Reticle_BG:SetDrawTier(0)
		ZO_ReticleContainer:SetDrawTier(1)
		BUI_ArrowCircle:SetHidden(false)
		BUI.Reticle.LeaderArrow()
		BUI_LeaderBar:SetHidden(false)
		BUI_LeaderBar:SetTextureRotation(math.pi*1.95,.5,1)
		BUI_ArrowBar:SetTextureRotation(math.pi/3.5,.5,1) BUI_ArrowBar:SetHidden(false)
		BUI_ArrowBar:SetTextureCoords(.4/2,1-.4/2,0,1)
		BUI_ArrowBar:SetWidth(60*(1-.4))
		BUI_InvulTarget:SetHidden(false)
		BUI.Reticle.TauntTimer(15)
		BUI.Reticle.TargetResist(4,9000,3000)
		BUI_Reticle_Right[7]:SetHidden(false)
		BUI_Reticle_Cast:SetDimensions(bot_bar.cast_w*bot_bar[8][3],bot_bar.cast_w)
		BUI_Reticle_Cast:SetTextureCoords(bot_bar[8][1],bot_bar[8][2],0,1)
		BUI_Reticle_Cast:SetHidden(false)
		BUI.Reticle.CrusherTimer(3)
		BUI_ReticleDpS:SetText("40K")
		BUI_ReticleBoost:SetHidden(false)
	else
		if BUI_Reticle_BG then BUI_Reticle_BG:SetHidden(true) end
		BUI_ArrowCircle:SetHidden(true)
		if BUI_LeaderBar then BUI_LeaderBar:SetHidden(true) end
		BUI_ArrowBar:SetHidden(true)
		BUI_InvulTarget:SetHidden(true)
		BUI.Reticle.TauntTimer(0)
		BUI.Reticle.TargetResist(0)
		BUI_Reticle_Cast:SetHidden(true)
		BUI.Reticle.CrusherTimer(0)
		BUI_ReticleDpS:SetText("")
		BUI_ReticleBoost:SetHidden(true)
	end
end
--]]
function BUI.Reticle.TargetResist(resist,own,debuff,text)
	if resist==0 then
		BUI_Reticle_Right:SetHidden(true)
		BUI_Reticle_Resist_Text:SetText("")
	else
		if text then BUI_Reticle_Resist_Text:SetText(text) end
		BUI_Reticle_Right:SetDimensions(res_bg.w*res_bg[resist][3],res_bg.w)
		BUI_Reticle_Right:SetTextureCoords(res_bg[resist][1],res_bg[resist][2],0,1)
		BUI_Reticle_Right:SetHidden(false)

		local penetr=math.ceil((own+debuff)/3050)
		own=math.ceil(own/3050)
		for i=1,7 do
			BUI_Reticle_Right[i]:SetHidden(penetr<i)
			if i>res_bg[resist][4] then
				BUI_Reticle_Right[i]:SetColor(.8,.2,.2,1)
			else
				if i>own then
					BUI_Reticle_Right[i]:SetColor(.7,.2,.9,1)
				else
					BUI_Reticle_Right[i]:SetColor(1,1,1,1)
				end
			end
		end

	end
end

function BUI.Reticle.Initialize()
	if not BUI.init.Reticle then UI_Init() end
	--Impactful hit animation
	if BUI.Vars.InCombatReticle or not BUI.Vars.ImpactAnimation then
		RETICLE.control:UnregisterForEvent(EVENT_IMPACTFUL_HIT)
		if BUI.Vars.ImpactAnimation then
			EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_IMPACTFUL_HIT, function() ZO_ReticleContainerReticle.timeline:PlayFromStart() end)
		else
			EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_IMPACTFUL_HIT)
		end
	end
	--Reticle mode
	BUI.Reticle.Mode(BUI.Vars.ReticleMode)
	--Blocking
	BUI.Reticle.Blocking()
end