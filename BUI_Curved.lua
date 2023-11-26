--Curved frames
BUI.Curved={
	Defaults={
		CurvedFrame			=0,
		CurvedDistance		=220,
		CurvedOffset		=-100,
		CurvedHeight		=360,
		CurvedDepth			=.8,
		CurvedStatValues		=true,
		CurvedHitAnimation	=true,
--		CurvedShift
--		CurvedShiftAnimation
		}
	}
local ch,cm,cs,ct,cw,ch1,cm1,cs1,ct1,cw1,rh,rh1
local disable_hit_anim
local coords={
	--Simple
	[1]={	{.25,.375,0,1},{.375,.5,0,.5},{.375,.5,.5,1},	--Health 1 bg,2 top,3 bot
		{0,.125,0,.5},{.125,.25,0,.5},			--Primary 4 bg,5 bar
		{0,.125,.5,.853},{.125,.25,.5,.853},		--Secondary 6 bg,7 bar

		{.75,.875,0,1},{.875,1,0,.5},{.875,1,.5,1},	--Target 8 bg,9 top,10 bot
		{.5,.625,0,.5},{.625,.75,0,.5},			--Primary 11 bg,12 bar
		{.5,.625,.25,.853},{.625,.75,.5,.853},		--Secondary 13 bg,14 bar
		.03,.3							--Shift for 15 hot,16 pct
		},
	--Cone
	[2]={	{.25,.375,0,1},{.375,.5,0,.5},{.375,.5,.5,1},
		{0,.125,0,.667},{.125,.25,0,.667},
		{0,.125,.667,1},{.125,.25,.667,1},

		{.75,.875,0,1},{.875,1,0,.5},{.875,1,.5,1},
		{.5,.625,0,.667},{.625,.75,0,.667},
		{.5,.625,.667,1},{.625,.75,.667,1},
		.08,.33
		},
	--Blades
	[3]={	{.25,.375,0,1},{.375,.5,0,1},false,
		{0,.125,0,.667},{.125,.25,0,.667},
		{0,.125,.667,1},{.125,.25,.667,1},

		{.75,.875,0,1},{.875,1,0,1},false,
		{.5,.625,0,.667},{.625,.75,0,.667},
		{.5,.625,.667,1},{.625,.75,.667,1},
		.26,.58
		},
}
BUI:JoinTables(BUI.Defaults,BUI.Curved.Defaults)
local theme_color
local CurvedFrameFadeDelay
local DecayStep,Attributes=1/50,{player={health={cur=1,target=1},magicka={cur=1,target=1},stamina={cur=1,target=1}},reticleover={health={cur=1,target=1}}}

local function UI_Init()
	local c=type(BUI.Vars.CurvedFrame)~="number" and 1 or BUI.Vars.CurvedFrame
	local fs=BUI.Vars.FrameFontSize
	local distance=BUI.inMenu and 100 or BUI.Vars.CurvedDistance
	local w,h,w1=distance*2,BUI.Vars.CurvedHeight,64*BUI.Vars.CurvedDepth
	local wh,ws=22*BUI.Vars.CurvedDepth,22*BUI.Vars.CurvedDepth
	local space=5
	local texture="/BanditsUserInterface/textures/curved/Curved"..c..".dds"
	local half=coords[c][3] and .5 or 1
	local ui	=BUI.UI.Control("BUI_Curved",	BanditsUI,	{w,h},	{CENTER,CENTER,0,BUI.Vars.CurvedOffset}, false)
	--Shift animation
	ui.shift	=BUI.UI.Texture("BUI_Curved_Shift", ui, {w1*2,h}, {LEFT,LEFT,0,0}, "/BanditsUserInterface/textures/curved/Shift.dds", true, {0,0})
	if BUI.MainPower=="magicka" then
		ui.shift:SetGradientColors(2,cs[1],cs[2],cs[3],cs[4],cm[1],cm[2],cm[3],cm[4])
	else
		ui.shift:SetGradientColors(2,cm[1],cm[2],cm[3],cm[4],cs[1],cs[2],cs[3],cs[4])
	end
	ui.shift:SetAlpha(.8)
	--Player
	ui.health	=BUI.UI.Texture("BUI_Curved_HealthBg", ui, {w1,h}, {LEFT,LEFT,0,0}, texture, false, {0,0}, coords[c][1])
	ui.health:SetColor(unpack(theme_color))
	ui.health.hot=BUI.UI.Texture("BUI_Curved_HealthHoT", ui.health, {wh,wh/2}, {LEFT,LEFT,w1*coords[c][15]-wh*.2,wh}, '/BanditsUserInterface/textures/regen_sm.dds', true, {1,2})
	ui.health.hot:SetTextureRotation(math.pi*.5)
	ui.health.dot=BUI.UI.Texture("BUI_Curved_HealthDoT", ui.health, {wh,wh/2}, {LEFT,LEFT,w1*coords[c][15]-wh*.2,-wh}, '/BanditsUserInterface/textures/regen_sm.dds', true, {1,2})
	ui.health.dot:SetTextureRotation(math.pi*1.5)
	if BUI.Vars.CurvedStatValues then
			BUI.UI.Line("BUI_Curved_HealthLine", ui, {fs*3,0}, {LEFT,LEFT,w1*coords[c][16],0}, theme_color, 2)
	ui.health.cur=BUI.UI.Label("BUI_Curved_HealthCur", ui, {fs*6,fs*1.5}, {BOTTOMLEFT,LEFT,w1*coords[c][16],0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,0}, BUI.DisplayNumber(BUI.Player.health.current/1000, 1).."k", false)
	ui.health.pct=BUI.UI.Label("BUI_Curved_HealthPct", ui, {fs*3,fs*1.5}, {TOPLEFT,LEFT,w1*coords[c][16],0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {0,2}, math.floor(BUI.Player.health.pct*100).."%", false)
	else
		if BUI_Curved_HealthLine then BUI_Curved_HealthLine:SetHidden(true) end
		if BUI_Curved_HealthCur then BUI_Curved_HealthCur:SetHidden(true) end
		if BUI_Curved_HealthPct then BUI_Curved_HealthPct:SetHidden(true) end
	end
	local coord=coords[c][2]
	local delta=math.abs(coord[3]-coord[4])
	ui.health.top={
		[1]	=BUI.UI.Texture("BUI_Curved_HealthTop1", ui, {w1,h*delta}, {BOTTOMLEFT,(delta==1 and BOTTOMLEFT or LEFT),0,0}, texture, false, {1,0}, coord),
		[2]	=BUI.UI.Texture("BUI_Curved_HealthTop2", ui, {w1,h*delta}, {BOTTOMLEFT,(delta==1 and BOTTOMLEFT or LEFT),0,0}, texture, false, {0,1}, coord),
		[3]	=BUI.UI.Texture("BUI_Curved_HealthTop3", ui, {w1,h*delta}, {BOTTOMLEFT,(delta==1 and BOTTOMLEFT or LEFT),0,0}, texture, true, {1,1}, coord),
		[4]	=BUI.UI.Texture("BUI_Curved_HealthTop4", ui, {w1,h*delta}, {BOTTOMLEFT,(delta==1 and BOTTOMLEFT or LEFT),0,0}, texture, true, {1,1}, coord),
		coord=coord
		}
	ui.health.top[1]:SetGradientColors(2,ch[1],ch[2],ch[3],ch[4],ch1[1],ch1[2],ch1[3],ch1[4])
	ui.health.top[2]:SetColor(ch[1],ch[2],ch[3],.4)
	ui.health.top[3]:SetGradientColors(2,cw[1],cw[2],cw[3],cw[4],cw1[1],cw1[2],cw1[3],cw1[4])
	ui.health.top[3]:SetAlpha(.4)
	ui.health.top[4]:SetGradientColors(2,ct[1],ct[2],ct[3],ct[4],ct1[1],ct1[2],ct1[3],ct1[4])
	ui.health.top[4]:SetAlpha(ct[4])
	local coord=coords[c][3]
	if coord then
		local delta=math.abs(coord[3]-coord[4])
		ui.health.bot={
		[1]	=BUI.UI.Texture("BUI_Curved_HealthBot1", ui, {w1,h*delta}, {TOPLEFT,(delta==1 and TOPLEFT or LEFT),0,0}, texture, false, {1,0}, coord),
		[2]	=BUI.UI.Texture("BUI_Curved_HealthBot2", ui, {w1,h*delta}, {TOPLEFT,(delta==1 and TOPLEFT or LEFT),0,0}, texture, false, {0,1}, coord),
		[3]	=BUI.UI.Texture("BUI_Curved_HealthBot3", ui, {w1,h*delta}, {TOPLEFT,(delta==1 and TOPLEFT or LEFT),0,0}, texture, true, {1,1}, coord),
		[4]	=BUI.UI.Texture("BUI_Curved_HealthBot4", ui, {w1,h*delta}, {TOPLEFT,(delta==1 and TOPLEFT or LEFT),0,0}, texture, true, {1,1}, coord),
		coord=coord
		}
		ui.health.bot[1]:SetGradientColors(2,ch1[1],ch1[2],ch1[3],ch1[4],ch[1],ch[2],ch[3],ch[4])
		ui.health.bot[2]:SetColor(ch[1],ch[2],ch[3],.4)
		ui.health.bot[3]:SetGradientColors(2,cw1[1],cw1[2],cw1[3],cw1[4],cw[1],cw[2],cw[3],cw[4])
		ui.health.bot[3]:SetAlpha(.4)
		ui.health.bot[4]:SetGradientColors(2,ct1[1],ct1[2],ct1[3],ct1[4],ct[1],ct[2],ct[3],ct[4])
		ui.health.bot[4]:SetAlpha(ct[4])
	else
		ui.health.bot=nil
		if BUI_Curved_HealthBot1 then BUI_Curved_HealthBot1:SetHidden(true) end
		if BUI_Curved_HealthBot2 then BUI_Curved_HealthBot2:SetHidden(true) end
		if BUI_Curved_HealthBot3 then BUI_Curved_HealthBot3:SetHidden(true) end
		if BUI_Curved_HealthBot4 then BUI_Curved_HealthBot4:SetHidden(true) end
	end
	Attributes.player.health.frame=ui.health

	--Target
	local target	=BUI.UI.Control("BUI_CurvedTarget",	BanditsUI,	{w,h},	{CENTER,CENTER,0,BUI.Vars.CurvedOffset}, true)
	ui.target		=BUI.UI.Texture("BUI_Curved_TargetBg", target, {w1,h}, {RIGHT,RIGHT,0,0}, texture, false, {0,0}, coords[c][8])
	ui.target:SetColor(unpack(theme_color))
	ui.target.hot=BUI.UI.Texture("BUI_Curved_TargetHoT", ui.target, {wh,wh/2}, {RIGHT,RIGHT,-w1*coords[c][15]+wh*.2,wh}, '/BanditsUserInterface/textures/regen_sm.dds', true, {1,2})
	ui.target.hot:SetTextureRotation(math.pi*.5)
	ui.target.dot=BUI.UI.Texture("BUI_Curved_TargetDoT", ui.target, {wh,wh/2}, {RIGHT,RIGHT,-w1*coords[c][15]+wh*.2,-wh}, '/BanditsUserInterface/textures/regen_sm.dds', true, {1,2})
	ui.target.dot:SetTextureRotation(math.pi*1.5)
	ui.target.dif	=BUI.UI.Texture("BUI_Curved_Dif", target, {fs*1.5,fs*1.5}, {TOPRIGHT,TOPRIGHT,0,0}, GetClassIcon(1), not BUI.inMenu)
	ui.target.rank	=BUI.UI.Texture("BUI_Curved_Rank", target, {fs*1.5,fs*1.5}, {TOPRIGHT,TOPRIGHT,0,fs*1.5}, GetAvARankIcon(1), not BUI.inMenu)
	ui.target.execute	=BUI.UI.Texture("BUI_Curved_Execute", target, {fs*1.5,fs*1.5}, {RIGHT,RIGHT,-w1*coords[c][16]-(BUI.Vars.CurvedStatValues and fs*3 or 0),0}, '/esoui/art/icons/mapkey/mapkey_groupboss.dds', true)
	if BUI.Vars.CurvedStatValues then
			BUI.UI.Line("BUI_Curved_TargetLine", target, {-fs*3,0}, {LEFT,RIGHT,-w1*coords[c][16],0}, theme_color, 2)
	ui.target.cur=BUI.UI.Label("BUI_Curved_TargetCur", target, {fs*6,fs*1.5}, {BOTTOMRIGHT,RIGHT,-w1*coords[c][16],0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {2,0}, 'Health', false)
	ui.target.pct=BUI.UI.Label("BUI_Curved_TargetPct", target, {fs*3,fs*1.5}, {TOPRIGHT,RIGHT,-w1*coords[c][16],0}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {2,2}, 'pct', false)
	else
		if BUI_Curved_TargetLine then BUI_Curved_TargetLine:SetHidden(true) end
		if BUI_Curved_TargetCur then BUI_Curved_TargetCur:SetHidden(true) end
		if BUI_Curved_TargetPct then BUI_Curved_TargetPct:SetHidden(true) end
	end
	local coord=coords[c][9]
	local delta=math.abs(coord[3]-coord[4])
	ui.target.bot={
		[1]	=BUI.UI.Texture("BUI_Curved_TargetBot1", target, {w1,h*delta}, {BOTTOMRIGHT,(delta==1 and BOTTOMRIGHT or RIGHT),0,0}, texture, false, {1,0}, coord),
		[2]	=BUI.UI.Texture("BUI_Curved_TargetBot2", target, {w1,h*delta}, {BOTTOMRIGHT,(delta==1 and BOTTOMRIGHT or RIGHT),0,0}, texture, false, {0,1}, coord),
		[3]	=BUI.UI.Texture("BUI_Curved_TargetBot3", target, {w1,h*delta}, {BOTTOMRIGHT,(delta==1 and BOTTOMRIGHT or RIGHT),0,0}, texture, true, {1,1}, coord),
		[4]	=BUI.UI.Texture("BUI_Curved_TargetBot4", target, {w1,h*delta}, {BOTTOMRIGHT,(delta==1 and BOTTOMRIGHT or RIGHT),0,0}, texture, true, {1,1}, coord),
		coord=coord
		}
	ui.target.bot[1]:SetGradientColors(2,ch[1],ch[2],ch[3],ch[4],ch1[1],ch1[2],ch1[3],ch1[4])
	ui.target.bot[2]:SetColor(ch[1],ch[2],ch[3],.4)
	ui.target.bot[3]:SetGradientColors(2,cw[1],cw[2],cw[3],cw[4],cw1[1],cw1[2],cw1[3],cw1[4])
	ui.target.bot[3]:SetAlpha(.4)
	ui.target.bot[4]:SetGradientColors(2,ct[1],ct[2],ct[3],ct[4],ct1[1],ct1[2],ct1[3],ct1[4])
	ui.target.bot[4]:SetAlpha(ct[4])
	local coord=coords[c][10]
	if coord then
		local delta=math.abs(coord[3]-coord[4])
		ui.target.top={
		[1]	=BUI.UI.Texture("BUI_Curved_TargetTop1", target, {w1,h*delta}, {TOPRIGHT,(delta==1 and TOPRIGHT or RIGHT),0,0}, texture, false, {1,0}, coord),
		[2]	=BUI.UI.Texture("BUI_Curved_TargetTop2", target, {w1,h*delta}, {TOPRIGHT,(delta==1 and TOPRIGHT or RIGHT),0,0}, texture, false, {0,1}, coord),
		[3]	=BUI.UI.Texture("BUI_Curved_TargetTop3", target, {w1,h*delta}, {TOPRIGHT,(delta==1 and TOPRIGHT or RIGHT),0,0}, texture, true, {1,1}, coord),
		[4]	=BUI.UI.Texture("BUI_Curved_TargetTop4", target, {w1,h*delta}, {TOPRIGHT,(delta==1 and TOPRIGHT or RIGHT),0,0}, texture, true, {1,1}, coord),
		coord=coord
		}
		ui.target.top[1]:SetGradientColors(2,ch1[1],ch1[2],ch1[3],ch1[4],ch[1],ch[2],ch[3],ch[4])
		ui.target.top[2]:SetColor(ch[1],ch[2],ch[3],.4)
		ui.target.top[3]:SetGradientColors(2,cw1[1],cw1[2],cw1[3],cw1[4],cw[1],cw[2],cw[3],cw[4])
		ui.target.top[3]:SetAlpha(.4)
		ui.target.top[4]:SetGradientColors(2,ct1[1],ct1[2],ct1[3],ct1[4],ct[1],ct[2],ct[3],ct[4])
		ui.target.top[4]:SetAlpha(ct[4])
	else
		ui.target.top=nil
		if BUI_Curved_TargetTop1 then BUI_Curved_TargetTop1:SetHidden(true) end
		if BUI_Curved_TargetTop2 then BUI_Curved_TargetTop2:SetHidden(true) end
		if BUI_Curved_TargetTop3 then BUI_Curved_TargetTop3:SetHidden(true) end
		if BUI_Curved_TargetTop4 then BUI_Curved_TargetTop4:SetHidden(true) end
	end
	Attributes.reticleover.health.frame=ui.target

	--Attributes
	ui.attr={
		l	=BUI.UI.Control("BUI_Curved_PrimL",		ui,	{w,h},	{CENTER,CENTER,0,0}, true),
		r	=BUI.UI.Control("BUI_Curved_PrimR",		ui,	{w,h},	{CENTER,CENTER,0,0}, true),
		primar=true
		}
	--Primary bar
		--Left
	ui.attr.l.primar={}
	local coord=coords[c][4] local delta=math.abs(coord[3]-coord[4])
	ui.attr.l.primar.bg=BUI.UI.Texture("BUI_Curved_PrimLBg",	ui.attr.l, {w1,h*delta}, {BOTTOMLEFT,BOTTOMLEFT,-ws,-h*(1-delta)}, texture, false, 0, coord)
	ui.attr.l.primar.bg:SetColor(unpack(theme_color))
	local coord=coords[c][5] local delta=math.abs(coord[3]-coord[4])
	ui.attr.l.primar.top={
		[1]	=BUI.UI.Texture("BUI_Curved_PrimLTop1",	ui.attr.l, {w1,h*delta}, {BOTTOMLEFT,BOTTOMLEFT,-ws,-h*(1-delta)}, texture, false, 2, coord),
		[2]	=BUI.UI.Texture("BUI_Curved_PrimLTop2",	ui.attr.l, {w1,h*delta}, {BOTTOMLEFT,BOTTOMLEFT,-ws,-h*(1-delta)}, texture, false, 1, coord),
		coord=coord
		}
		--Right
	ui.attr.r.primar={}
	local coord=coords[c][11] local delta=math.abs(coord[3]-coord[4])
	ui.attr.r.primar.bg=BUI.UI.Texture("BUI_Curved_PrimRBg",	ui.attr.r, {w1,h*delta}, {BOTTOMRIGHT,BOTTOMRIGHT,0,-h*(1-delta)}, texture, false, 0, coord)
	ui.attr.r.primar.bg:SetColor(unpack(theme_color))
	local coord=coords[c][12] local delta=math.abs(coord[3]-coord[4])
	ui.attr.r.primar.top={
		[1]	=BUI.UI.Texture("BUI_Curved_PrimRTop1",	ui.attr.r, {w1,h*delta}, {BOTTOMRIGHT,BOTTOMRIGHT,0,-h*(1-delta)}, texture, false, 2, coord),
		[2]	=BUI.UI.Texture("BUI_Curved_PrimRTop2",	ui.attr.r, {w1,h*delta}, {BOTTOMRIGHT,BOTTOMRIGHT,0,-h*(1-delta)}, texture, false, 1, coord),
		coord=coord
		}

	--Secondary bar
		--Left
	ui.attr.l.second={}
	local coord=coords[c][6] local delta=math.abs(coord[3]-coord[4])
	ui.attr.l.second.bg=BUI.UI.Texture("BUI_Curved_SecondLBg",	ui.attr.l, {w1,h*delta}, {TOPLEFT,TOPLEFT,-ws,h*coord[3]}, texture, false, 0, coord)
	ui.attr.l.second.bg:SetColor(unpack(theme_color))
	local coord=coords[c][7] local delta=math.abs(coord[3]-coord[4])
	ui.attr.l.second.top={
		[1]	=BUI.UI.Texture("BUI_Curved_SecondLTop1",	ui.attr.l, {w1,h*delta}, {TOPLEFT,TOPLEFT,-ws,h*coord[3]}, texture, false, 2, coord),
		[2]	=BUI.UI.Texture("BUI_Curved_SecondLTop2",	ui.attr.l, {w1,h*delta}, {TOPLEFT,TOPLEFT,-ws,h*coord[3]}, texture, false, 1, coord),
		coord=coord
		}
		--Right
	ui.attr.r.second={}
	local coord=coords[c][13] local delta=math.abs(coord[3]-coord[4])
	ui.attr.r.second.bg=BUI.UI.Texture("BUI_Curved_SecondRBg",	ui.attr.r, {w1,h*delta}, {TOPRIGHT,TOPRIGHT,0,h*coord[3]}, texture, false, 0, coord)
	ui.attr.r.second.bg:SetColor(unpack(theme_color))
	local coord=coords[c][14] local delta=math.abs(coord[3]-coord[4])
	ui.attr.r.second.top={
		[1]	=BUI.UI.Texture("BUI_Curved_SecondRTop1",	ui.attr.r, {w1,h*delta}, {TOPRIGHT,TOPRIGHT,0,h*coord[3]}, texture, false, 2, coord),
		[2]	=BUI.UI.Texture("BUI_Curved_SecondRTop2",	ui.attr.r, {w1,h*delta}, {TOPRIGHT,TOPRIGHT,0,h*coord[3]}, texture, false, 1, coord),
		coord=coord
		}

	--Set attribute colors
	for _,side in pairs({"l","r"}) do
		if BUI.MainPower=="magicka" then
			ui.attr[side].primar.top[1]:SetGradientColors(2,cm[1],cm[2],cm[3],cm[4],cm1[1],cm1[2],cm1[3],cm1[4])
			ui.attr[side].second.top[1]:SetGradientColors(2,cs1[1],cs1[2],cs1[3],cs1[4],cs[1],cs[2],cs[3],cs[4])
			ui.attr[side].primar.top[2]:SetColor(cm[1],cm[2],cm[3],.4)
			ui.attr[side].second.top[2]:SetColor(cs[1],cs[2],cs[3],.4)
			Attributes.player.magicka.frame=ui.attr.l.primar
			Attributes.player.stamina.frame=ui.attr.l.second
		else
			ui.attr[side].primar.top[1]:SetGradientColors(2,cs[1],cs[2],cs[3],cs[4],cs1[1],cs1[2],cs1[3],cs1[4])
			ui.attr[side].second.top[1]:SetGradientColors(2,cm1[1],cm1[2],cm1[3],cm1[4],cm[1],cm[2],cm[3],cm[4])
			ui.attr[side].primar.top[2]:SetColor(cs[1],cs[2],cs[3],.4)
			ui.attr[side].second.top[2]:SetColor(cm[1],cm[2],cm[3],.4)
			Attributes.player.stamina.frame=ui.attr.l.primar
			Attributes.player.magicka.frame=ui.attr.l.second
		end
	end

	--Stat values lables
	if BUI.Vars.CurvedStatValues then
		local primar_value=BUI.DisplayNumber(BUI.Player[BUI.MainPower].current/1000, 1).."k"
		local second_value=BUI.DisplayNumber(BUI.Player[BUI.SecondaryPower].current/1000, 1).."k"
			BUI.UI.Line("BUI_Curved_StatLineL", ui.attr.l.primar.bg, {-fs*3,0}, {RIGHT,BOTTOMLEFT,0,0}, theme_color, 2)
	ui.attr.l.primar.cur=BUI.UI.Label("BUI_Curved_PrimarLCur", ui.attr.l, {fs*4,fs*1.5}, {BOTTOMRIGHT,BOTTOMLEFT,0,0,ui.attr.l.primar.bg}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {2,0}, primar_value)
	ui.attr.l.second.cur=BUI.UI.Label("BUI_Curved_SecondLCur", ui.attr.l, {fs*4,fs*1.5}, {TOPRIGHT,BOTTOMLEFT,0,0,ui.attr.l.primar.bg}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {2,2}, second_value)
			BUI.UI.Line("BUI_Curved_StatLineR", ui.attr.r.primar.bg, {-fs*3,0}, {RIGHT,BOTTOMRIGHT,-w1*coords[c][16],0}, theme_color, 2)
	ui.attr.r.primar.cur=BUI.UI.Label("BUI_Curved_PrimarRCur", ui.attr.r, {fs*4,fs*1.5}, {BOTTOMRIGHT,BOTTORIGHT,-w1*coords[c][16]*(1+coords[c][6][4]-.5),0,ui.attr.r.primar.bg}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {2,0}, primar_value)
	ui.attr.r.second.cur=BUI.UI.Label("BUI_Curved_SecondRCur", ui.attr.r, {fs*4,fs*1.5}, {TOPRIGHT,BOTTOMRIGHT,-w1*coords[c][16]*(1+coords[c][6][4]-.5),0,ui.attr.r.primar.bg}, BUI.UI.Font(BUI.Vars.FrameFont1,fs,true), nil, {2,2}, second_value)
	else
		if BUI_Curved_StatLineL then BUI_Curved_StatLineL:SetHidden(true) end
		if BUI_Curved_PrimarLCur then BUI_Curved_PrimarLCur:SetHidden(true) end
		if BUI_Curved_SecondLCur then BUI_Curved_SecondLCur:SetHidden(true) end
		if BUI_Curved_StatLineR then BUI_Curved_StatLineR:SetHidden(true) end
		if BUI_Curved_PrimarRCur then BUI_Curved_PrimarRCur:SetHidden(true) end
		if BUI_Curved_SecondRCur then BUI_Curved_SecondRCur:SetHidden(true) end
	end

	--Alt bar
	local coord=coords[c][6] local delta=math.abs(.667-coord[4])
	ui.alt	=BUI.UI.Texture("BUI_Curved_Alt", ui, {w1,h*delta}, {TOPLEFT,TOPLEFT,ws,h*.667}, texture, true, 0, {coord[1],coord[2],.667,coord[4]})
	ui.alt:SetColor(unpack(theme_color))
	local delta=coords[c][15]+(coords[c][16]-coords[c][15])/2
	ui.icon	=BUI.UI.Texture("BUI_Curved_AltIcon", ui.alt, {fs*1.5,fs*1.5}, {BOTTOMLEFT,TOPLEFT,w1*delta-fs*.75,0},"/esoui/art/icons/mapkey/mapkey_stables.dds")
	local coord=coords[c][7] local delta=math.abs(.667-coord[4])
	ui.alt.top={
		[1]	=BUI.UI.Texture("BUI_Curved_AltTop1", ui.alt, {w1,h*delta}, {TOPLEFT,TOPLEFT,ws,h*.667,ui}, texture, false, 2, {coord[1],coord[2],.667,coord[4]}),
--		[2]	=BUI.UI.Texture("BUI_Curved_AltTop2", ui.alt, {w1,h*delta}, {TOPLEFT,TOPLEFT,ws,h*.667,ui}, texture, false, 1, {coord[1],coord[2],.667,coord[4]}),
		coord={coord[1],coord[2],.667,coord[4]}
		}
	ui.alt.top[1]:SetColor(cs[1],cs[2],cs[3],cs[4])
--	ui.alt.top[2]:SetColor(cs[1],cs[2],cs[3],.4)

	--Dots control
	if BUI.Vars.Actions or BUI.Vars.ProcAnimation then
	local h=16*BUI.Vars.CurvedDepth
	local bar	=BUI.UI.Control("BUI_CurvedFrame_Dots",		ui,	{h,h*5+4},	{BOTTOMLEFT,LEFT,w1*coords[c][16]+4,-fs*1.5-4},	true)
	for i=1,5 do
		bar[i]=BUI.UI.Texture("BUI_CurvedFrame_Dots"..i,	bar,	{h,h},		{BOTTOM,BOTTOM,(i-1)*(c==2.2 and 1 or 3)*BUI.Vars.CurvedDepth,-(i-1)*h-3},	"")
		bar[i]:SetDrawLayer(3) bar[i]:SetColor(unpack(theme_color))
	end
	end

--	ui:SetScale(BUI.Vars.CurvedScale)
	ui:SetAlpha(BUI.Vars.FramesFade and 0 or BUI.Vars.FrameOpacityOut/100)
	target:SetAlpha(BUI.Vars.FramesFade and 0 or BUI.Vars.FrameOpacityOut/100)
end

local function ChangeAttribute(frame,pct,bar)
	local h=BUI.Vars.CurvedHeight
	bar=bar or 1
	for _,n in pairs({"top","bot"}) do
		if frame[n] then
			local c=frame[n].coord
			local delta=math.abs(c[3]-c[4])
			if c[3]==0 then
				frame[n][bar]:SetTextureCoords(c[1],c[2],c[4]-delta*pct,c[4])
			else
				frame[n][bar]:SetTextureCoords(c[1],c[2],c[3],c[3]+delta*pct)
			end
			frame[n][bar]:SetHeight(h*delta*pct)
			frame[n][bar]:SetHidden(pct<=.02)
		end
	end
end

--Animation
local function AttributeDecay()
	local count=0
	for unitTag,data in pairs(Attributes) do
		for attribute,value in pairs(data) do
			if value.cur<value.target then
				value.cur=value.target
			else
				value.cur=value.cur-DecayStep
				ChangeAttribute(value.frame,value.cur,2)
				count=count+1
			end
		end
	end
	if count==0 then EVENT_MANAGER:UnregisterForUpdate("BUI_CurvedAttributeDecay") end
end

function BUI.Curved.Regen(unitTag,unitAttributeVisual,powerType,duration)
	local regenType,attrType,distance
	if unitAttributeVisual==ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER then regenType="hot" distance=-BUI.Vars.CurvedHeight/5
	elseif unitAttributeVisual==ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER then regenType="dot" distance=BUI.Vars.CurvedHeight/5 end
--	d(tostring(unitTag).." "..tostring(regenType)..": "..tostring(duration))

	local control=BUI_Curved[unitTag=="player" and "health" or "target"][regenType]
	if control==nil then return end
	if duration<0 then
		if control.timeline then control.timeline:Stop() end
		control:SetAlpha(0)
		return
	end
	--Does the animation need to be set up from scratch?
	if control.animation==nil then
		local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY=control:GetAnchor()
		--Create an vertical sliding animation
		local animation, timeline=CreateSimpleAnimation(ANIMATION_TRANSLATE,control,0)
		animation:SetTranslateOffsets(offsetX, offsetY, offsetX, offsetY+distance) animation:SetDuration(duration*3/4)
		--Fade alpha coming in
		local fadeIn=timeline:InsertAnimation(ANIMATION_ALPHA,control,0)
		fadeIn:SetAlphaValues(.20,.75) fadeIn:SetDuration(duration/4) fadeIn:SetEasingFunction(ZO_EaseOutQuadratic)
		--Fade alpha going out
		local fadeOut=timeline:InsertAnimation(ANIMATION_ALPHA,control,duration*1/2)
		fadeOut:SetAlphaValues(.75,.20) fadeOut:SetDuration(duration/4) fadeIn:SetEasingFunction(ZO_EaseOutQuadratic)
		--Add an extra delay at the end
		local fadeOut=timeline:InsertAnimation(ANIMATION_ALPHA,control,duration*3/4) fadeOut:SetAlphaValues(0,0) fadeOut:SetDuration(duration/4)
		--Assign the timeline
		control.animation=animation control.timeline=timeline
	end
	--Maybe stop the animation
	if (duration==0 and control.animation:IsPlaying()) then
		control.timeline:SetPlaybackLoopsRemaining(1)
	else
		control:SetHidden(false)
		control.timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, 4) control.timeline:PlayFromStart()
	end
end

local function PlayHitAnimation(frame,step)
	if disable_hit_anim then return end
	frame.step=step or 1
	local function HitAnimation()
		local s=frame.step
		for i,n in pairs({"top","bot"}) do
			if frame[n] then
				if i==1 then
					frame[n][1]:SetGradientColors(2,ch1[1]+rh1[1]*s,ch1[2]+rh1[2]*s,ch1[3]+rh1[3]*s,ch1[4],ch[1]+rh[1]*s,ch[2]+rh[2]*s,ch[3]+rh[3]*s,ch[4])
				else
					frame[n][1]:SetGradientColors(2,ch[1]+rh[1]*s,ch[2]+rh[2]*s,ch[3]+rh[3]*s,ch[4],ch1[1]+rh1[1]*s,ch1[2]+rh1[2]*s,ch1[3]+rh1[3]*s,ch1[4])
				end
			end
		end
		if s<=0 then
			EVENT_MANAGER:UnregisterForUpdate("BUI_CurvedHitAnimation")
		end
		frame.step=frame.step-.1
	end
	EVENT_MANAGER:RegisterForUpdate("BUI_CurvedHitAnimation", 50, HitAnimation)
end

local function PlayShiftAnimation(side)
	if not BUI.Vars.CurvedShiftAnimation or not BUI.Vars.CurvedShift then return end
	local step=0
	local w=(BUI.inMenu and 100-32*BUI.Vars.CurvedDepth or BUI.Vars.CurvedDistance)*2
	local function ShiftAnimation()
		BUI_Curved.shift:SetTextureCoords(.5*side+1/16*step,.5*side+1/16*(step+1),0,1)
		BUI_Curved.shift:ClearAnchors()
		BUI_Curved.shift:SetAnchor(LEFT,BUI_Curved,LEFT,(w/8)*(side==0 and step or 6-step),0)
		BUI_Curved.shift:SetHidden(false)
		step=step+1
		if step>7 then
			EVENT_MANAGER:UnregisterForUpdate("BUI_CurvedShiftAnimation")
			BUI_Curved.shift:SetHidden(true)
		end
	end
	EVENT_MANAGER:RegisterForUpdate("BUI_CurvedShiftAnimation", 15, ShiftAnimation)
end

--Bars
local function FramesFadeCheck(pct)
	if pct then
		if BUI.Vars.FramesFade and not BUI.inMenu then
			if BUI.inCombat or BUI.Player.health.pct<.99 or BUI.Player.magicka.pct<.99 or BUI.Player.stamina.pct<.99 or pct<.99 then
				if BUI_Curved:GetAlpha()<.05 then BUI.Frames.Fade(BUI_Curved, false) end
			elseif not CurvedFrameFadeDelay and BUI_Curved:GetAlpha()>.05 then
				CurvedFrameFadeDelay=true
				BUI.CallLater("Curved_FramesFade",1500,function()
					CurvedFrameFadeDelay=false
					if not(BUI.inCombat or BUI.Player.health.pct<.95 or BUI.Player.magicka.pct<.95 or BUI.Player.stamina.pct<.95 or pct<.95) then
						BUI.Frames.Fade(BUI_Curved,true)
					end
				end)
			end
		end
	else
		if BUI.Vars.FramesFade and not(BUI.Player.health.pct<.95 or BUI.Player.magicka.pct<.95 or BUI.Player.stamina.pct<.95) then
			if not CurvedFrameFadeDelay and BUI_Curved:GetAlpha()>.05 then
				BUI.Frames.Fade(BUI_Curved,true)
			end
		end
	end
end

function BUI.Curved.Attribute(unitTag, attribute, powerValue, powerMax, pct, shieldValue, traumaValue)
	local frame=Attributes[unitTag] and Attributes[unitTag][attribute] and Attributes[unitTag][attribute].frame
	if not frame then return end

	--Frame fade
	if unitTag=='player' and Attributes[unitTag][attribute].cur~=pct then
		FramesFadeCheck(pct)
	end

	--Decay animation
	if Attributes[unitTag][attribute].cur>pct then
		Attributes[unitTag][attribute].target=pct
		EVENT_MANAGER:RegisterForUpdate("BUI_CurvedAttributeDecay", 50, AttributeDecay)
		if pct>0 and Attributes[unitTag][attribute].cur-pct>.25 and attribute=="health" then
			PlayHitAnimation(frame)
		end
	else
		Attributes[unitTag][attribute].cur=pct
		Attributes[unitTag][attribute].target=pct
	end

	ChangeAttribute(frame,pct)
	if frame.cur then
		local preText=((shieldValue>0 or traumaValue>0) and " [" or "")
		local postText=((shieldValue>0 or traumaValue>0) and "]" or "")
		local shield=((attribute=="health" and shieldValue and shieldValue>0) and BUI.DisplayNumber(shieldValue/1000).."k" or "")
		local trauma=((attribute=="health" and traumaValue and traumaValue>0) and "-"..BUI.DisplayNumber(traumaValue/1000).."k" or "")
		frame.cur:SetText(BUI.DisplayNumber(powerValue/1000, 1).."k"..preText..shield..trauma..postText)
	end
	if frame.pct then frame.pct:SetText(pct*100 .."%") end
end

function BUI.Curved.Shield(unitTag,value,pct,health,traumaValue)
	local frame=Attributes[unitTag] and Attributes[unitTag].health and Attributes[unitTag].health.frame	
	if frame then
		if frame.cur then
			local preText=((value>0 or traumaValue>0) and " [" or "")
			local postText=((value>0 or traumaValue>0) and "]" or "")
			local shield=(value>0 and BUI.DisplayNumber(value/1000).."k" or "")
			local trauma=(traumaValue>0 and "-"..BUI.DisplayNumber(traumaValue/1000).."k" or "")
			frame.cur:SetText(BUI.DisplayNumber(health/1000, 1).."k"..preText..shield..trauma..postText)
		end
		ChangeAttribute(frame,pct,3)
	end
end

function BUI.Curved.Trauma(unitTag,value,pct,health,shieldValue)
	local frame=Attributes[unitTag] and Attributes[unitTag].health and Attributes[unitTag].health.frame
	if frame then
		if frame.cur then
			local preText=((value>0 or shieldValue>0) and " [" or "")
			local postText=((value>0 or shieldValue>0) and "]" or "")
			local shield=(shieldValue>0 and BUI.DisplayNumber(shieldValue/1000).."k" or "")
			local trauma=(value>0 and "-"..BUI.DisplayNumber(value/1000).."k" or "")
			frame.cur:SetText(BUI.DisplayNumber(health/1000, 1).."k"..preText..shield..trauma..postText)
		end
		ChangeAttribute(frame,pct,4)
	end
end

function BUI.Curved.Target(show)
	if show then
		local powerValue, powerMax=GetUnitPower('reticleover', POWERTYPE_HEALTH)
		local pct=powerValue/powerMax
		if powerMax>1 then
			Attributes.reticleover.health.cur=pct
			Attributes.reticleover.health.target=pct
--			ChangeAttribute(Attributes.reticleover.health.frame,pct)
			BUI.Frames.Fade(BUI_CurvedTarget,false)
			local icon,rank
			if IsUnitPlayer('reticleover') then
				icon=GetClassIcon(GetUnitClassId('reticleover'))
				rank=GetAvARankIcon(GetUnitAvARank('reticleover'))
			elseif BUI.Target.difficulty==2 then
				icon="/esoui/art/lfg/lfg_normaldungeon_down.dds"
			elseif BUI.Target.difficulty>=3 then
				icon="/esoui/art/unitframes/target_veteranrank_icon.dds"
			end
			--Boss edge color
			if BUI.Target.difficulty==MONSTER_DIFFICULTY_DEADLY then
				BUI_Curved_Rank:SetColor(1,.2,.2,1)
			else
				BUI_Curved_Rank:SetColor(1,1,1,1)
			end
			BUI_Curved_Dif:SetTexture(rank) BUI_Curved_Dif:SetHidden(rank==nil)
			BUI_Curved_Rank:SetTexture(icon) BUI_Curved_Rank:SetHidden(icon==nil)
			PlayHitAnimation(BUI_Curved.target,0)	--Stop animation
		end
	else
		BUI.Frames.Fade(BUI_CurvedTarget,true)
	end
	BUI.Curved.Regen('reticleover',3,nil,-1) BUI.Curved.Regen('reticleover',4,nil,-1)
end

function BUI.Curved.Alt(show,pct,icon,color)
	BUI_Curved_Alt:SetHidden(not show)
	if show then
		if icon then
			BUI_Curved_AltIcon:SetTexture(icon)
		end
		if color then
			BUI_Curved_Alt.top[1]:SetColor(unpack(color))
--			BUI_Curved_Alt.top[2]:SetColor(color[1],color[2],color[3],.4)
		end
		ChangeAttribute(BUI_Curved_Alt,pct)

		FramesFadeCheck(pct)
	else
		FramesFadeCheck()
	end
end

--Events
function BUI.Curved.OnCombatState(inCombat,init)
	local side="l"
	if inCombat then
		BUI_Curved.attr.r:SetHidden(true)
		if not init then PlayShiftAnimation(1) end
	else
		if BUI.Vars.CurvedShift then
			side="r"
			if not init then PlayShiftAnimation(0) end
			BUI_Curved.attr.l:SetHidden(true)
		else
			BUI_Curved.attr.r:SetHidden(true)
		end
		BUI.Curved.Target(false)
		FramesFadeCheck()
	end
	BUI_Curved.attr[side]:SetHidden(false)

	if BUI.MainPower=="magicka" then
		Attributes.player.magicka.frame=BUI_Curved.attr[side].primar
		Attributes.player.stamina.frame=BUI_Curved.attr[side].second
	else
		Attributes.player.stamina.frame=BUI_Curved.attr[side].primar
		Attributes.player.magicka.frame=BUI_Curved.attr[side].second
	end
	ChangeAttribute(Attributes.player.magicka.frame,Attributes.player.magicka.cur)
	ChangeAttribute(Attributes.player.stamina.frame,Attributes.player.stamina.cur)
end

function BUI.Curved.Initialize()	--Initialisation
	if BUI.Vars.CurvedFrame==0 then
		if BUI_Curved then BUI_Curved:SetHidden(true) BUI_CurvedTarget:SetHidden(true) end
		return
	end
	theme_color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.CustomEdgeColor
	ch,cm,cs,cw,ct=BUI.Vars.FrameHealthColor,BUI.Vars.FrameMagickaColor,BUI.Vars.FrameStaminaColor,BUI.Vars.FrameShieldColor,BUI.Vars.FrameTraumaColor
	ch1,cm1,cs1,cw1,ct1=BUI.Vars.FrameHealthColor1,BUI.Vars.FrameMagickaColor1,BUI.Vars.FrameStaminaColor1,BUI.Vars.FrameShieldColor1,BUI.Vars.FrameTraumaColor1
	rh,rh1={1-ch[1],1-ch[2],1-ch[3],1-ch[4]},{1-ch1[1],1-ch1[2],1-ch1[3],1-ch1[4]}
	disable_hit_anim=not BUI.Vars.CurvedHitAnimation
	UI_Init()
	BUI.Curved.OnCombatState(false,true)
--	if BUI.init.Frames then BUI.Frames.Fade(BUI_Curved, true) end
end

--[[
function BUI.Frames:TimedAttributeFade(attribute)

	if attribute=="health" then
		if BUI.Player[attribute].pct==1 then
			BUI.Frames:BUI.Frames.Fade(BUI_CurvedFrame_PlayerHealth,true)
		end
	elseif attribute=="magicka" then
		if BUI.Player[attribute].pct==1 then
			BUI.Frames:BUI.Frames.Fade(BUI_CurvedFrame_PlayerMagicka,true)
		end
	elseif attribute=="stamina" then
		if BUI.Player[attribute].pct==1 then
			BUI.Frames:BUI.Frames.Fade(BUI_CurvedFrame_PlayerStamina,true)
		end
	elseif attribute=="magicka+stamina" then
		if BUI.Player["magicka"].pct==1 and BUI.Player["stamina"].pct==1 then
			BUI.Frames:BUI.Frames.Fade(BUI_CurvedFrame_PlayerMagicka,true)
			BUI.Frames:BUI.Frames.Fade(BUI_CurvedFrame_PlayerStamina,true)
		end
	end
end
--]]