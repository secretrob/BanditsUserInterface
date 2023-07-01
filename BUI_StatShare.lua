BUI.StatShare={
	Units		={},
	}
local StatShare_Code=76
local Election_Yes,Election_No,Dice_request,Dice_roll=11,12,13,14
local groupElection_init,GroupElectionPending
local power={magicka=0,stamina=1}
local HornsLastUpdate,ColossusLastUpdate,BarriersLastUpdate,lastPing,LastUlt,LastStat=0,0,0,0,0,0
local role_color={}
local cyrodiilMapIndex=GetCyrodiilMapIndex()
local CastGroupVoteOrig=CastGroupVote
local DiceRolls
local mData={
	default={scaleX=.143,scaleY=.143,offsetX=0,offsetY=0},
	frvfrstvlt01_base={scaleX=.01,scaleY=.01,offsetX=0,offsetY=0},frvfrstvlt02_base={scaleX=.01,scaleY=.01,offsetX=0,offsetY=0},frvfrstvlt03_base={scaleX=.01,scaleY=.01,offsetX=0,offsetY=0},frvfrstvlt03_base={scaleX=.01,scaleY=.01,offsetX=0,offsetY=0},
	sunspireoverworld_base={scaleX=.02,scaleY=.02,offsetX=0,offsetY=0},
	sunspirehall001_base={scaleX=.02,scaleY=.02,offsetX=0,offsetY=0},
	}

--Coords util
function BUI.MapData()
	if not BUI.MapId or BUI.MapId=="" then return mData.default.scaleX,mData.default.scaleY end
	if mData[BUI.MapId] then return mData[BUI.MapId].scaleX,mData[BUI.MapId].scaleY end
	local pX,pY=GetMapPlayerPosition('player')
	if pX==0 and pY==0 then return mData.default.scaleX,mData.default.scaleY end

	--Select the map corner far from the player position
	local wpX=pX<0.5 and 0.915 or 0.085
	local wpY=pY<0.5 and 0.915 or 0.085
	BUI.PingMap(MAP_PIN_TYPE_PLAYER_WAYPOINT,MAP_TYPE_LOCATION_CENTERED,wpX,wpY)

	--Switch to world map so we can calculate the global map scale and offset
	if SetMapToMapListIndex(TAMRIEL_MAP_INDEX)==SET_MAP_RESULT_FAILED then
		if BUI.Vars.DeveloperMode then pl("Error: Could not switch to world map") end
		return mData.default.scaleX,mData.default.scaleY
	end
	local pX1,pY1=GetMapPlayerPosition('player')
	local wpX1,wpY1=GetMapPlayerWaypoint()

	--calculate scale and offset for all collected maps
	local scaleX,scaleY=(wpX1-pX1)/(wpX-pX),(wpY1-pY1)/(wpY-pY)
--	local offsetX,offsetY=pX1-pX*scaleX,pY1-pY*scaleY
	if BUI.Vars.DeveloperMode and (math.abs(scaleX-scaleY)>1e-3) then pl("Error: Map data for "..BUI.MapId.." might be wrong") end
	mData[BUI.MapId]={scaleX=scaleX,scaleY=scaleY,offsetX=offsetX,offsetY=offsetY}

	RemovePlayerWaypoint()
	SetMapToPlayerLocation()
	if not mData[BUI.MapId] then
		if BUI.Vars.DeveloperMode then pl("Error: Map data for "..BUI.MapId.." was not collected") end
		return mData.default.scaleX,mData.default.scaleY
	end
	return mData[BUI.MapId].scaleX,mData[BUI.MapId].scaleY
end
--[[
local function DataToCoord(b0, b1, b2, b3)
--	local scaleX,scaleY=BUI.MapData()
	local scaleX,scaleY=mData.default.scaleX,mData.default.scaleY
	b0=b0 or 0 b1=b1 or 0 b2=b2 or 0 b3=b3 or 0
	return (b0*0x100+b1)*scaleX/10000, (b2*0x100+b3)*scaleY/10000
end

local function CoordToData(x, y)
--	local scaleX,scaleY=BUI.MapData()
	local scaleX,scaleY=mData.default.scaleX,mData.default.scaleY
	x=math.floor(x/scaleX*10000+0.5)
	y=math.floor(y/scaleY*10000+0.5)
	return math.floor(x/0x100), x%0x100, math.floor(y/0x100), y%0x100
end
--]]
local function DataToCoord(d0, d1, d2, d3)
	return (d0+(d1+10)/100)/100, (d2+d3/100)/10
end

local function CoordToData(x, y)
	local d0=math.floor(x*100)
	local d2=math.floor(y*10)
	return d0,math.min(math.max(math.floor((x*100-d0)*100+.5)-10,0),500),d2,math.floor((y*10-d2)*100+.5)
end

--Developers interface
function BUI.StatShare.UI_Init()
	local info	=BUI.UI.TopLevelWindow(	"BUI_StatShare",			GuiRoot,	{340,270},	{LEFT,LEFT,35,160},	false)
	info.bg	=BUI.UI.Backdrop(		"BUI_StatShare_Backdrop",	info,		"inherit",	{CENTER,CENTER,0,0},	{0,0,0,.2}, {0,0,0,.4}, nil, false)
	info.label	=BUI.UI.Label(		"BUI_StatShare_Label",		info,		"inherit",	{CENTER,CENTER,0,0},	BUI.UI.Font("standard",16,true), {1,1,1,1}, {0,0}, "", false)
	info:SetMovable(true)
	info:SetMouseEnabled(true)
	BUI.init.StatShareUI=true
end

local function UpdateUI()
	if not BUI.init.StatShareUI then return end
	local _text=""
	local h=2
	for unitTag,data in pairs(BUI.StatShare.Units) do
		local _name=GetUnitDisplayName(unitTag)
		if _name then
			if _name==GetUnitDisplayName('player') then _name="|c33CC33".._name.."|r" end
			_text=_text.._name.."|cbbbbbb"

--			if data[1] then _text=_text.." "..math.floor(data[1]*100000)/100000 end
--			if data[2] then _text=_text.." "..math.floor(data[2]*100000)/100000 end
			if data[1] and data[2] and data[1]>0 and data[2]>0 then _text=_text.." ("..table.concat({CoordToData(data[1], data[2])}, ",")..")" end

			_text=_text.."|r\n"
			h=h+1
		end
	end
	h=h*16*1.2
	BUI_StatShare_Backdrop:SetHeight(h)
	BUI_StatShare_Label:SetText(_text)
	BUI_StatShare_Label:SetHeight(h)
end

--Stats share
function BUI.StatShare.ClearStats()
	BUI.StatShare.Units={}
	for i=1,24 do
		frame=_G["BUI_RaidFrame"..i]
		if frame then
			for u=0,5 do
				if frame.UltB[u] then
					frame.UltB[u]:SetHidden(true) frame.stat:SetHidden(true)
				end
			end
		end
	end
	BUI_HornInfo_Names:SetText("")
	BUI_HornInfo_Value:SetText("")
	BUI_ColossusInfo_Names:SetText("")
	BUI_ColossusInfo_Value:SetText("")
end

local function UpdateStats()
	if not BUI.Vars.RaidFrames then return end
	if not BUI.Vars.StatShare then BUI.StatShare.ClearStats() return end
	local now=GetGameTimeMilliseconds()
	local groupStats,members,tankStats,tanks=0,0,0,0
	local horns,colossus,barriers={},{},{}
	BUI.ReadyHorn=false
	for unitTag,data in pairs(BUI.StatShare.Units) do
		local _ult,_power,_stat,_received=data[1],data[2],data[3],data[4]
		local frame=BUI.Group[unitTag] and BUI.Group[unitTag].frame
		if frame then
			if _received+6000<now then
				frame.stat:SetHidden(true)
				if BUI.Vars.StatShareUlt<3 then
					frame.UltB[0]:SetHidden(true)
					BUI.StatShare.Units[unitTag]=nil
				end
			else
				--Update shared stat
				frame.stat:SetHidden(false)
				frame.stat.bar:SetWidth(math.min(_stat/100,1)*(frame.stat.width-4))
				local stat=_power%2
				if stat==0 then frame.stat.bar:SetColor(unpack(BUI.Vars.FrameMagickaColor)) else frame.stat.bar:SetColor(unpack(BUI.Vars.FrameStaminaColor)) end
				--Update shared ult
				local _colossus=_power-stat==8
				local _horn=not _colossus and _power>=4
				local _barrier=_power-stat==2 or _power-stat==6
				local _color=(_ult<24 or not _horn) and "|cEEEEEE" or "|c22FF22"
				if BUI.Vars.StatShareUlt<3 and not GroupElectionPending then
					local _hide=(BUI.Vars.StatShareUlt==3 or (BUI.Vars.StatShareUlt==2 and not _horn))
					frame.UltB[0]:SetHidden(_hide)
					if not _hide then
						if _horn then frame.UltB[0]:SetCenterColor(1,1,1,1) else frame.UltB[0]:SetCenterColor(1,1,1,0) end
						frame.UltB[0]:SetCenterTexture(_horn and "/esoui/art/icons/ability_ava_003_a.dds" or nil)
						frame.UltL[0]:SetText(_color.._ult*10 .."|r")
					end
				end
				if BUI.Group[unitTag] then
					--Group and Tanks total stats
					if BUI.Group[unitTag].role~="Healer" and BUI.Group[unitTag].role~="Tank" then
						members=members+1
						groupStats=groupStats+_stat
					elseif BUI.Group[unitTag].role=="Tank" then
						tanks=tanks+1
						tankStats=tankStats+_stat
					end
					local name_color=BUI.Group[unitTag].accname==BUI.Player.accname and "|c22FF22" or role_color[BUI.Group[unitTag].role]
					local reduction=(BUI.Group[unitTag].class==6 and .96 or BUI.Group[unitTag].class==2 and .85 or 1)	--Templar, Sorc
					--Horn info
					if _horn then
						local cost=250*reduction
						table.insert(horns,{
						i=BUI.Group[unitTag].index,
						name_color=name_color,
						name=BUI.Group[unitTag].accname,
						ult_color=_color,
						ult_cur=_ult*10,
						ult_pct=math.min(math.floor(_ult*10/cost*100),100)
						})
					end
					--Major Vulnerability info
					if _colossus then
						local cost=225
						table.insert(colossus,{
						i=BUI.Group[unitTag].index,
						name_color=name_color,
						name=BUI.Group[unitTag].accname,
						ult_color=_ult<22 and "|cEEEEEE" or "|c22FF22",
						ult_cur=_ult*10,
						ult_pct=math.min(math.floor(_ult*10/cost*100),100)
						})
					end
					--Barrier info
					if _barrier then
						local cost=200*reduction
						table.insert(barriers,{
						i=BUI.Group[unitTag].index,
						name_color=name_color,
						name=BUI.Group[unitTag].accname,
						ult_color=_ult<22 and "|cEEEEEE" or "|c22FF22",
						ult_cur=_ult*10,
						ult_pct=math.min(math.floor(_ult*10/cost*100),100)
						})
					end
				end
			end
		else
			BUI.StatShare.Units[unitTag]=nil
		end
	end
	--Horn info
	if BUI.Vars.UltimateOrder~=3 then
		if #horns>0 and (BUI.Vars.UltimateOrder==1 or (BUI.Vars.UltimateOrder==2 and (BUI.Buffs.HornAvailable[1] or BUI.Buffs.HornAvailable[2] or BUI.Player.isLeader))) then
			BUI_HornInfo_Bar:SetWidth(BUI_HornInfo_Bar.width*math.floor((BUI.Buffs.HornActive or 0)/3)/10)
			local names,values="  Horn\n",(BUI.Buffs.HornActive and math.floor(BUI.Buffs.HornActive).."s\n" or "|cEE2222No|r\n")
			table.sort(horns, function(x,y) return x.ult_cur==y.ult_cur and x.i<y.i or x.ult_cur>y.ult_cur end)
			for _,data in ipairs(horns) do
				names=names..data.name_color..string.sub(data.name,0,12).."|r\n"
				values=values..data.ult_color..data.ult_pct.."|r%\n"
			end
			BUI_HornInfo_Names:SetText(names)
			BUI_HornInfo_Value:SetText(values)
			BUI_HornInfo:SetHeight(BUI_HornInfo.row*(#horns+2))
			HornsLastUpdate=now
		elseif HornsLastUpdate+6000<now then
			BUI_HornInfo_Bar:SetWidth(0) BUI_HornInfo_Names:SetText("") BUI_HornInfo_Value:SetText("") BUI_HornInfo:SetHeight(0)
		end
		local colossus_duration=0
		if #colossus>0 and (BUI.Vars.UltimateOrder==1 or (BUI.Vars.UltimateOrder==2 and (BUI.Buffs.ColossusAvailable[1] or BUI.Buffs.ColossusAvailable[2] or BUI.Player.isLeader))) then
			colossus_duration=math.max((BUI.Buffs.MajorVulnerabilityActive or 0)-now/1000,0)
			BUI_ColossusInfo_Bar:SetWidth(BUI_ColossusInfo_Bar.width*colossus_duration/20)
			local names,values="  Vulnerability CD\n",(colossus_duration>0 and math.floor(colossus_duration).."s\n" or "|cEE2222No|r\n")
			table.sort(colossus, function(x,y) return x.ult_cur==y.ult_cur and x.i<y.i or x.ult_cur>y.ult_cur end)
			for _,data in ipairs(colossus) do
				names=names..data.name_color..string.sub(data.name,0,12).."|r\n"
				values=values..data.ult_color..data.ult_pct.."|r%\n"
			end
			BUI_ColossusInfo_Names:SetText(names)
			BUI_ColossusInfo_Value:SetText(values)
			BUI_ColossusInfo:SetHeight(BUI_ColossusInfo.row*(#colossus+2))
			ColossusLastUpdate=now
		elseif ColossusLastUpdate+6000<now then
			BUI_ColossusInfo_Bar:SetWidth(0) BUI_ColossusInfo_Names:SetText("") BUI_ColossusInfo_Value:SetText("") BUI_ColossusInfo:SetHeight(0)
		end
		if #barriers>0 and (BUI.Vars.UltimateOrder==1 or (BUI.Vars.UltimateOrder==2 and (BUI.Buffs.BarrierAvailable[1] or BUI.Buffs.BarrierAvailable[2] or BUI.Player.isLeader))) then
			duration=math.max((BUI.Buffs.BarrierActive or 0)-now/1000,0)
			BUI_BarrierInfo_Bar:SetWidth(BUI_BarrierInfo_Bar.width*duration/30)
			local names,values="  Barrier\n",(duration>0 and math.floor(duration).."s\n" or "|cEE2222No|r\n")
			table.sort(barriers, function(x,y) return x.ult_cur==y.ult_cur and x.i<y.i or x.ult_cur>y.ult_cur end)
			for _,data in ipairs(barriers) do
				names=names..data.name_color..string.sub(data.name,0,12).."|r\n"
				values=values..data.ult_color..data.ult_pct.."|r%\n"
			end
			BUI_BarrierInfo_Names:SetText(names)
			BUI_BarrierInfo_Value:SetText(values)
			BUI_BarrierInfo:SetHeight(BUI_BarrierInfo.row*(#barriers+1))
			BarriersLastUpdate=now
		elseif BarriersLastUpdate+6000<now then
			BUI_BarrierInfo_Bar:SetWidth(0) BUI_BarrierInfo_Names:SetText("") BUI_BarrierInfo_Value:SetText("") BUI_BarrierInfo:SetHeight(0)
		end
	end
	--Notifications
	if BUI.Vars.NotificationsGroup and BUI.inCombat then
		if BUI.BossFight and not IsUnitDead('boss1') then
			if #horns>0 and horns[1].ult_pct==100 and (not BUI.Buffs.HornActive or BUI.Buffs.HornActive<3) then
				if BUI.Player.accname==horns[1].name then
					BUI.OnScreen.Notification(3,BUI.Loc("Horn"))
					CALLBACK_MANAGER:FireCallbacks("BUI_Horn")
				elseif BUI.Player.isLeader then
					BUI.OnScreen.NotificationSecondary(3,BUI.Loc("Horn").." ("..horns[1].name..")")
				end
			end
			if #colossus>0 and colossus[1].ult_pct==100 and colossus_duration==0 then
				if BUI.Player.accname==horns[1].name then
					BUI.OnScreen.Notification(3,BUI.Loc("Colossus"))
					CALLBACK_MANAGER:FireCallbacks("BUI_Colossus")
				elseif BUI.Player.isLeader then
					BUI.OnScreen.NotificationSecondary(3,BUI.Loc("Colossus").." ("..horns[1].name..")")
				end
			end
		end
		if BUI.Player.role=="Healer" and (members>0 or tanks>0) then
			groupStats=groupStats/members
			tankStats=tankStats/tanks
			if groupStats>0 and groupStats<30 then
				BUI.OnScreen.NotificationSecondary(1,BUI.Loc("GroupNeedOrbs"))
			end
			if tankStats>0 and tankStats<30 then
				BUI.OnScreen.NotificationSecondary(2,BUI.Loc("TankNeedShard"))
			end
		end
	end
end

local function SendPing()
	if not BUI.Vars.StatShare then return end
	--Compute player statistics
	local _now=GetGameTimeMilliseconds()
	local _ult	=math.floor(BUI.Player["ultimate"].current/10+.5)+.5
	local _stat	=math.min(BUI.Player[BUI.MainPower].pct*100,99)
	if LastUlt~=_ult or LastStat~=_stat or lastPing+4500<_now then
		local _horn=(BUI.Buffs.HornAvailable[1] or BUI.Buffs.HornAvailable[2]) and 4 or 0
		local _colossus=(BUI.Buffs.ColossusAvailable[1] or BUI.Buffs.ColossusAvailable[2]) and 8 or 0
		local _barrier=_colossus==0 and (BUI.Buffs.BarrierAvailable[1] or BUI.Buffs.BarrierAvailable[2]) and 2 or 0
		local _power=power[BUI.MainPower] or 0
		--Send the ping
		BUI.PingMap(MAP_PIN_TYPE_PING,MAP_TYPE_LOCATION_CENTERED,DataToCoord(StatShare_Code,_ult,_power+_barrier+(_horn>0 and _horn or _colossus),_stat))
--		BUI.CallLater("PingMap",250,function() BUI.PingMap(MAP_PIN_TYPE_PING,MAP_TYPE_LOCATION_CENTERED,0,0) end)
		lastPing=_now
		LastUlt=_ult
		LastStat=_stat
	end
end

local function ClearVotes(force)
	if not force and not GroupElectionPending then return end
	GroupElectionPending=nil
	for i=1,24 do
		frame=_G["BUI_RaidFrame"..i]
		if frame and frame.UltB[0] then
			frame.UltB[0]:SetHidden(true)
		end
	end
end

--Events
local PingEventAction={
	[0]=function(unitTag,_ult,_power,_stat)	--Stats share
		if string.sub(unitTag, 0, 5)=="group" then
			BUI.StatShare.Units[unitTag]={_ult,_power,_stat,GetGameTimeMilliseconds()}
			if BUI.Group[unitTag] then BUI.Group[unitTag].power=(_power==1 or _power==6) and 1 or 2 end
			UpdateUI()
		end
	end,
	[1]=function(unitTag,_,code)	--Come to the crown
		if code==7 and BUI.Vars.NotificationsGroup and IsUnitGroupLeader(unitTag) then
			BUI.OnScreen.Notification(77,"Come to the crown",BUI.Vars.NotificationSound_1)
		end
	end,
	[2]=function(unitTag,_,code)	--Start fight
		if code==7 and BUI.Vars.NotificationsGroup and IsUnitGroupLeader(unitTag) then
			BUI.OnScreen.Notification(78,"Start fight",BUI.Vars.NotificationSound_1)
		end
	end,
	[3]=function(unitTag,_,code)	--Wipe
		if code==7 and BUI.Vars.NotificationsGroup and IsUnitGroupLeader(unitTag) then
			if BUI.OnScreen.Message[79] then BUI.OnScreen.Message[79].members=nil return end
			local DeadMembers=0
			for i=1,BUI.Group.members do
				if IsUnitDead(GetGroupUnitTagByIndex(i)) then DeadMembers=DeadMembers+1 end
			end
			BUI.OnScreen.Notification(79,"Wipe",BUI.Vars.NotificationSound_1,nil,nil,nil,BUI.Group.members-DeadMembers)
		end
	end,
	[4]=function(unitTag,_,code)	--Break 2
		if code==7 and BUI.Vars.NotificationsGroup and IsUnitGroupLeader(unitTag) then
			if BUI.OnScreen.Message[80] then BUI.OnScreen.Message[80].count=nil else BUI.OnScreen.Notification(80,"Break",nil,2*60000) end
		end
	end,
	[5]=function(unitTag,_,code)	--Break 5
		if code==7 and BUI.Vars.NotificationsGroup and IsUnitGroupLeader(unitTag) then
			if BUI.OnScreen.Message[80] then BUI.OnScreen.Message[80].count=nil else BUI.OnScreen.Notification(80,"Break",nil,5*60000) end
		end
	end,
	[6]=function(unitTag,_,code)	--Break 10
		if code==7 and BUI.Vars.NotificationsGroup and IsUnitGroupLeader(unitTag) then
			if BUI.OnScreen.Message[80] then BUI.OnScreen.Message[80].count=nil else BUI.OnScreen.Notification(80,"Break",nil,10*60000) end
		end
	end,
--[[
	[7]=function(unitTag,_,code)	--Place marker 1
--		if code==7 and BUI.Vars.NotificationsGroup and IsUnitGroupLeader(unitTag) then
			BUI.PlaceMarker(1)
--		end
	end,
--]]
	[Election_Yes]=function(unitTag,_,code)	--Election Yes
		if code==7 and GroupElectionPending then
			local frame=BUI.Group[unitTag] and BUI.Group[unitTag].frame
			if frame then
				frame.UltB[0]:SetCenterColor(.1,1,.1,1)
				frame.UltB[0]:SetCenterTexture("/esoui/art/cadwell/check.dds")
				frame.UltB[0]:SetHidden(false)
				frame.UltL[0]:SetText("")
				BUI.GroupSynergy[BUI.Group[unitTag].index]=nil
			end
			GroupElectionPending=GroupElectionPending+1
			if GroupElectionPending>=BUI.Group.members then
				BUI.OnScreen.Message[8]=nil
				BUI.CallLater("ClearVotes",5000,ClearVotes)
			end
		end
	end,
	[Election_No]=function(unitTag,_,code)	--Election No
		if code==7 and GroupElectionPending then
			local frame=BUI.Group[unitTag] and BUI.Group[unitTag].frame
			if frame then
				frame.UltB[0]:SetCenterColor(1,.2,.2,1)
				frame.UltB[0]:SetCenterTexture("/esoui/art/cadwell/check.dds")
				frame.UltB[0]:SetHidden(false)
				frame.UltL[0]:SetText("")
				BUI.GroupSynergy[BUI.Group[unitTag].index]=nil
				d(GetString(SI_GROUP_ELECTION_READY_CHECK_NOTIFICATION_HEADER)..": "..BUI.Group[unitTag].accname.." is not ready")
			end
		end
	end,
	[Dice_request]=function(unitTag,value,code,dice)	--Dice request
--		d(unitTag..", "..value ..", "..code..", "..dice)
		if code==7 and BUI.Group[unitTag] and not DiceRolls then
			DiceRolls={[0]={unitTag=unitTag,dice=dice,value=value}}
			BUI.PingMap(MAP_PIN_TYPE_PING,MAP_TYPE_LOCATION_CENTERED,(StatShare_Code+Dice_roll+.5)/100,.701+math.random(98)/1000)
			BUI.CallLater("DiceRequest",2000,function()
				local data={}
				local max=0
				for u=1,BUI.Group.members do
					local unitTag	=GetGroupUnitTagByIndex(u)
					for i in pairs(DiceRolls) do
						if DiceRolls[i].unitTag==unitTag then
							local dice=math.abs(DiceRolls[i].dice-DiceRolls[0].dice)
							table.insert(data,{unitTag=DiceRolls[i].unitTag,dice=dice})
							unitTag=nil
							if dice>max then max=dice end
						end
					end
					if unitTag and DiceRolls[0].unitTag==BUI.Player.groupTag then
						local dice=math.abs(math.random(98)-DiceRolls[0].dice)
						table.insert(data,{unitTag=unitTag,dice=dice,added=true})
						if dice>max then max=dice end
					end
				end
				table.sort(data,function(a,b) return a.dice>b.dice end)
				max=max+math.floor(math.random(value)/value*2)
				local t="Dice "..value.." rolls:"
				for i=1,#data do
					local dice=math.floor((value-1)*data[i].dice/max)+1
					local accname=BUI.Group[data[i].unitTag].accname or "Unknown"
					t=t.." "..(data[i].added and "|cAAAAAA"..accname..": "..dice.."|r" or accname..": "..dice)
				end
				d(t)
				DiceRolls=nil
			end)
		end
	end,
	[Dice_roll]=function(unitTag,_,code,dice)	--Group members dice rolls
		if code==7 and BUI.Group[unitTag] and DiceRolls then
--			d(BUI.Group[unitTag].accname.." rolls: "..dice)
			table.insert(DiceRolls,{unitTag=unitTag,dice=dice})
		end
	end,
}

function BUI.StatShare.OnPing(eventCode, pingEventType, pingType, unitTag, offsetX, offsetY, isOwner)
	if pingType==MAP_PIN_TYPE_PING and pingEventType==PING_EVENT_ADDED then
		local _code,_ult,_power,_stat=CoordToData(offsetX, offsetY)
		if _code>=74 and _code<=90 then
			if BUI.g_mapPinManager then BUI.g_mapPinManager:RemovePins("pings", MAP_PIN_TYPE_PING, unitTag) end
			_code=_code-StatShare_Code
			if PingEventAction[_code] then PingEventAction[_code](unitTag,_ult,_power,_stat) end
--			UpdateUI()
		end
	end
end

--Initialization
local function SwitchLMP(enable)
	local LMP=LibStub and LibStub("LibMapPing", true)
	if LMP then
		if enable then
			if not LMP:IsPingSuppressed(MAP_PIN_TYPE_PING, 'player') then LMP:UnsuppressPing(MAP_PIN_TYPE_PING,'player') end
			for i=1,24 do
				if not LMP:IsPingSuppressed(MAP_PIN_TYPE_PING, 'group'..i) then LMP:UnsuppressPing(MAP_PIN_TYPE_PING,'group'..i) end
			end
		else
--			LMP.Unload()
			if not LMP:IsPingSuppressed(MAP_PIN_TYPE_PING, 'player') then LMP:SuppressPing(MAP_PIN_TYPE_PING,'player') end
			for i=1,24 do
				if not LMP:IsPingSuppressed(MAP_PIN_TYPE_PING, 'group'..i) then LMP:SuppressPing(MAP_PIN_TYPE_PING,'group'..i) end
			end
--[[
			if not LMP:IsPingMuted(MAP_PIN_TYPE_PING, 'player') then LMP:MutePing(MAP_PIN_TYPE_PING,'player') end
			for i=1,24 do
				if not LMP:IsPingMuted(MAP_PIN_TYPE_PING, 'group'..i) then LMP:MutePing(MAP_PIN_TYPE_PING,'group'..i) end
			end
--]]
		end
	end
end

function BUI.StatShare.GroupElection()
	SLASH_COMMANDS["/dice"]=function(value)
		if not DiceRolls then
			if IsUnitGrouped('player') then
				value=tonumber(value)
				value=value or 20
				if value<6 or value>64 then d("/dice [6-64]") return end
				local dice=math.random(98)
				BUI.PingMap(MAP_PIN_TYPE_PING,MAP_TYPE_LOCATION_CENTERED,(StatShare_Code+Dice_request)/100+(value+10)/10000,.701+dice/1000)
				a("Dice roll request was sent.")
			else
				a(GetString(SI_GROUPELECTIONFAILURE8))
			end
		else
			a(GetString(SI_GROUPELECTIONFAILURE5))
		end
	end

	if BUI.Vars.RaidFrames and BUI.Vars.GroupElection then
		CastGroupVote=function(vote)
			if vote==GROUP_VOTE_CHOICE_FOR then
				BUI.PingMap(MAP_PIN_TYPE_PING,MAP_TYPE_LOCATION_CENTERED,(StatShare_Code+Election_Yes+.5)/100,.75)
			elseif vote==GROUP_VOTE_CHOICE_AGAINST then
				BUI.PingMap(MAP_PIN_TYPE_PING,MAP_TYPE_LOCATION_CENTERED,(StatShare_Code+Election_No+.5)/100,.75)
			end
			CastGroupVoteOrig(vote)
		end

		local function ShowVotes()
			if GroupElectionPending then return end
			for i=1,24 do
				frame=_G["BUI_RaidFrame"..i]
				if frame and frame.UltB[0] then
					frame.UltB[0]:SetCenterColor(.1,1,.1,1)
					frame.UltB[0]:SetCenterTexture("/esoui/art/cadwell/check.dds")
					frame.UltB[0]:SetHidden(false)
					frame.UltL[0]:SetText("")
				end
			end
		end
		EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_GROUP_ELECTION_FAILED, function(_,reason)
			BUI.OnScreen.Message[8]=nil
			BUI.CallLater("ClearVotes",5000,ClearVotes)
		end)
		EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_GROUP_ELECTION_NOTIFICATION_ADDED, function(eventCode)
			local _,_,descriptor=GetGroupElectionInfo()
			if descriptor=="[ZO_READY_CHECK]" then
				ClearVotes(true)
				GroupElectionPending=0
				if BUI.Vars.NotificationsGroup then
					BUI.OnScreen.Notification(8,GetString(SI_GROUP_ELECTION_READY_CHECK_NOTIFICATION_HEADER),nil,65000)
				end
			end
		end)
		EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_GROUP_ELECTION_REQUESTED, function(_,descriptor)
			if descriptor=="[ZO_READY_CHECK]" then
				BUI.CallLater("PingMap",1000,function()
					BUI.PingMap(MAP_PIN_TYPE_PING,MAP_TYPE_LOCATION_CENTERED,(StatShare_Code+Election_Yes+.5)/100,.75)
				end)
				ClearVotes(true)
				GroupElectionPending=0
				if BUI.Vars.NotificationsGroup then
					BUI.OnScreen.Notification(8,GetString(SI_GROUP_ELECTION_READY_CHECK_NOTIFICATION_HEADER),nil,65000)
				end
			end
		end)
		EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_GROUP_ELECTION_RESULT, function(_,result,descriptor)
			if descriptor=="[ZO_READY_CHECK]" then
				BUI.OnScreen.Message[8]=nil
				if result==GROUP_ELECTION_RESULT_ELECTION_WON then ShowVotes() end
				BUI.CallLater("ClearVotes",5000,ClearVotes)
			end
		end)
		groupElection_init=true
	elseif groupElection_init then
		CastGroupVote=CastGroupVoteOrig
		EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_GROUP_ELECTION_FAILED)
		EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_GROUP_ELECTION_NOTIFICATION_ADDED)
		EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_GROUP_ELECTION_REQUESTED)
		EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_GROUP_ELECTION_RESULT)
	end
end

function BUI.StatShare.Initialize(disable)
	for _,role in pairs({"Tank","Healer","Damage"}) do role_color[role]="|c"..BUI.ColorString(unpack(BUI.Vars["Frame"..role.."Color"])) end
	BUI.StatShare.GroupElection()
	BUI.g_mapPinManager=ZO_WorldMap_GetPinManager()
--	HodorReflexes.modules.share.IsEnabled()
	if not disable and BUI.Vars.StatShare then
		--Hide pings on the world map
		ZO_PreHook(ZO_MapPin, 'ShouldShowPin', function(self) return self.m_PinType==MAP_PIN_TYPE_PING end)
		--Hide pins on the compass
		COMPASS.container:SetAlphaDropoffBehavior(MAP_PIN_TYPE_PING,0,0,0,0)
--		RedirectTexture("/esoui/art/mappins/mapping.dds","/BanditsUserInterface/textures/theme/blank.dds")
		EVENT_MANAGER:RegisterForUpdate("BUI_StatShare", 1000, function()
				if IsUnitGrouped('player') and GetCurrentMapIndex()~=cyrodiilMapIndex then
					SendPing() UpdateStats()
				end
			end)
--		EVENT_MANAGER:RegisterForEvent("BUI_StatShare", EVENT_PLAYER_ACTIVATED, function() BUI.CallLater("SwitchLMP",1000,SwitchLMP,false) end)
		SOUNDS.MAP_PING=SOUNDS.NONE
		SOUNDS.MAP_PING_REMOVE=SOUNDS.NONE
		BUI.init.StatShare=true
		return true
	else
		EVENT_MANAGER:UnregisterForUpdate("BUI_StatShare")
--		EVENT_MANAGER:UnregisterForEvent("BUI_StatShare", EVENT_PLAYER_ACTIVATED)
--		SwitchLMP(true)
		SOUNDS.MAP_PING="Map_Ping"
		SOUNDS.MAP_PING_REMOVE="Map_Ping_Remove"
		UpdateStats()
		BUI.init.StatShare=false
		if BUI.Vars.StatShare then return false end
	end
end

--[[
/script BUI.SendData(76,10,5,50)
function BUI.SendData(d0,d1,d2,d3)
	BUI.PingMap(MAP_PIN_TYPE_PLAYER_WAYPOINT,MAP_TYPE_LOCATION_CENTERED,DataToCoord(d0,d1,d2,d3))
	local function GetData()
		local x,y=GetMapPlayerWaypoint()
		d(table.concat({CoordToData(x,y)}, ", "))
	end
	BUI.CallLater("GetData",1000,GetData)
end
/script d("|c"..BUI.ColorString(unpack(BUI.Vars["FrameHealerColor"])).."FFF|r")
/script local LMP=LibStub("LibMapPing", true) d((LMP) and "LMP on" or "LMP off")
/script BUI.StatShare:LMP(false)
/script if BUI_StatShare then BUI_StatShare:SetHidden(not BUI_StatShare:IsHidden()) else BUI.StatShare.UI_Init() end
/script x1,y1=GetMapPlayerPosition('player') BUI.CallLater("MapPosition",2000,function() x2,y2=GetMapPlayerPosition('player') StartChatInput("["..GetCurrentMapZoneIndex().."]="..x2-x1) end)
/script BUI.PingMap(136, 1, 1 / 2^16, 1 / 2^16) StartChatInput(table.concat({GetMapPlayerWaypoint()}, ","))
/script SendPing() BUI.CallLater("UpdateStats",200,UpdateStats)
/script local LMP=LibStub("LibMapPing") LMP.Unload() LMP:MutePing(MAP_PIN_TYPE_PING,'player') for i=1,24 do LMP:MutePing(MAP_PIN_TYPE_PING,'group'..i) end
/script BUI.PingMap(MAP_PIN_TYPE_PING, MAP_TYPE_LOCATION_CENTERED, 0, 0)
--]]