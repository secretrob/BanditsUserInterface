--REGROOPER
BUI.RG={}
local GroupMembers={}
local loop_count=0

function BUI.RG_Save()
	local groupSize=GetGroupSize()
	if groupSize<=1 then
		a("You are not in a group")
		return
	end
	GroupMembers={}
	for i=1, groupSize, 1 do
		local name=GetUnitDisplayName(GetGroupUnitTagByIndex(i))
		if name~=BUI.Player.accname then
			table.insert(GroupMembers, name)
		end
	end
	if #GroupMembers>0 then
		a("Group saved")
		BUI.Vars.LastGroupMembers=GroupMembers
	end
end

function BUI.RG_Disband()
	if IsUnitGroupLeader('player') and not DoesGroupModificationRequireVote() then
		GroupDisband()
	else
		GroupLeave()
	end
end

function BUI.RG_ReGroup()
	if GetGroupSize()>1 then
		BUI.RG_Save()
		GroupDisband()
	else
		a("You are not in a group")
		return
	end
	loop_count=0
	BUI.CallLater("ReInvite",3000,function() BUI.RG_ReInvite_loop() end)
end

function BUI.RG_ReInvite_loop()
	--Wait for goup disbanded
	if GetGroupSize()>1 and loop_count<8 then
		loop_count=loop_count+1
		BUI.CallLater("ReInvite",500,function() BUI.RG_ReInvite_loop() end)
	else
		BUI.RG_ReInvite()
	end
end

function BUI.RG_ReInvite()
	if #GroupMembers<=0 and #BUI.Vars.LastGroupMembers>0 then
		GroupMembers=BUI.Vars.LastGroupMembers
	end
	if #GroupMembers<=0 then
		a("Saved group list is empty")
		return
	end
	d("Regrouping:")
	for i,name in pairs(GroupMembers) do
		if not IsPlayerInGroup(name) then
			GroupInviteByName(name)
			d(i..". "..name)
		end
	end
end

--Show last group members
function BUI.RG_ListGroup()
	if #GroupMembers<=0 and #BUI.Vars.LastGroupMembers>0 then
		GroupMembers=BUI.Vars.LastGroupMembers
	end
	if #GroupMembers<=0 then
		a("Saved group list is empty")
		return
	end
	d("Saved group members:")
	for i,name in pairs(GroupMembers) do
		d(i..". "..name)
	end
end

--Clear the last saved player names from the arrays and settings
function BUI.RG_Clear(where)
	local done=false
	where=where or 1
	if where==3 then
		if #GroupMembers>0 then
			GroupMembers={}
			a("Saved group list is cleared")
			done=true
		end
		if #BUI.Vars.LastGroupMembers>0 then
			BUI.Vars.LastGroupMembers={}
			a("Removed last player names from SavedVariables")
			done=true
		end
	elseif where==2 then
		if #BUI.Vars.LastGroupMembers>0 then
			BUI.Vars.LastGroupMembers={}
			a("Removed last player names from SavedVariables")
			done=true
		end
	elseif where==1 then
		if #GroupMembers>0 then
			GroupMembers={}
			a("Saved group list is cleared")
			done=true
		end
	end

	if not done then
		a("Saved group list is empty")
	end
end

--Add a name to the last saved players list
function BUI.RG_Add(nameParts)
	local noCharName=false
	if nameParts~=nil and #nameParts==2 then
		--Build the name from the 2nd arguments from the chat, to skip 1st one ("add")
		local playerName=nameParts[2]
		if playerName~="" then
			if playerName==GetUnitName("player") then
				a("You cannot add yourself to the saved group list")
			return
		end
		local alreadyIn=false
			local playersLastInGroup={}
		if #GroupMembers>0 then
			playersLastInGroup=groupMembers
		elseif #BUI.Vars.LastGroupMembers>0 then
			playersLastInGroup=BUI.Vars.LastGroupMember
		end
		if #playersLastInGroup>0 then
				for i=1, #playersLastInGroup, 1 do
					if playersLastInGroup[i]==playerName then
					alreadyIn=true
					break
				end
				end
			end
			if not alreadyIn then
				table.insert(GroupMembers, playerName)
				BUI.Vars.LastGroupMembers=GroupMembers
				d("Added player [" .. playerName .. "] to the saved group list")
			else
				d("Player [" .. playerName .. "] was already in saved group list")
			end
		else
		 	noCharName=true
		end
	else
		noCharName=true
	end
	if noCharName then
		d("No character name specified. Syntax: /rg add <character name>")
	end
end

--Chat slash commands handler
function BUI.RG_ChatCommand(command)
	--Parse the arguments string
	local cmd_options={}
	local searchResult={ string.match(command, "^(%S*)%s*(.-)$") }
	local noLowerCase=false
	for i,v in pairs(searchResult) do
		if (v~=nil and v~="") then
		if noLowerCase then
				cmd_options[i]=v
		else
				cmd_options[i]=string.lower(v)
		 	end
		if i==1 and v=="add" then
				noLowerCase=true
			end
		end
	end

	if not(command=="" or #cmd_options==0 or cmd_options==nil) then
		if cmd_options[1]=="help" then
			d("[Regrouper] - Available chat commands:")
			d("- help: Show this list of chat commands")
			d("- save: Save the current group")
			d("- disband: Disband your current group")
			d("- regroup: Regroup with the last players")
			d("- list: List the last players in your group")
			d("- invite: Invite saved list to group")
			d("- add <name>: Add the player <name> to the last saved player names")
		elseif cmd_options[1]=="list" then
			BUI.RG_ListGroup()
		elseif cmd_options[1]=="save" then
			BUI.RG_Save()
		elseif cmd_options[1]=="disband" then
			BUI.RG_Disband()
		elseif cmd_options[1]=="regroup" then
			BUI.RG_ReGroup()
		elseif cmd_options[1]=="invite" then
			BUI.RG_ReInvite()
		elseif cmd_options[1]=="add" and cmd_options[2]~="" then
			BUI.RG_Add(cmd_options)
		end
	end
end

function BUI.RG_GoToLeader()
	if GetGroupSize()<=1 then return end
	d("- Jump to Group Leader")
	JumpToGroupLeader()
end

function BUI.RG:Initialize()
	--Define new chat command
	SLASH_COMMANDS["/regrouper"]=BUI.RG_ChatCommand
	SLASH_COMMANDS["/rg"]=BUI.RG_ChatCommand
end

