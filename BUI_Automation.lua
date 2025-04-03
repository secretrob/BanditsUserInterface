local Defaults={
	DeleteMail=false,
	ConfirmLocked=false,
	JumpToLeader=false,
	GroupLeave=false,
	Books=false,
	FriendStatus=false,
	LargeGroupInvite=true,
	LargeGroupAnnoucement=true,
	FastTravel=false,
	InitialDialog=false,
	RepeatableQuests=false,
--	CovetousCountess=false,
	DarkBrotherhoodSpree=false,
--	FeedSynergy=false,
	AdvancedSynergy=false,
	BlockAnnouncement=false,
	ContainerHandler=false,
	PlayerToPlayer=false,
	BuiltInGlobalCooldown=false,
	AutoDismissPet=true,
	HousePins=4,
	}
BUI:JoinTables(BUI.Defaults,Defaults)
local lastInteractableName
local ContainerHandlerRunning,LootStolen=false,false
local Button_Fish,Button_Container
local ItemsTotal={[ITEMTYPE_FISH]=0,[ITEMTYPE_CONTAINER]=0}
local GeodeContainer={
	[134583]=1,[134623]=4,[134622]=4,[134590]=4,[134588]=5,[134591]=10,[134618]=50,	--Geode
	[87703]=5,[139665]=5,[139669]=5,	--Warriors Coffer
	[139664]=5,[87702]=5,[139668]=5,	--Mages Coffer
	[87705]=5,[87706]=5,[139666]=5,[139667]=5,	--Serpent Coffer
	[94089]=5,[139670]=5,	--Dro-m'Athra Coffer
	[138711]=5,[138712]=5,[141739]=5,[141738]=5,	--Welkynar Coffer
	[139674]=5,	--Saint's Coffer
	[139673]=5,	--Fabricant Coffer
	[151970]=5,	--Sunspire Coffer
}
local WhiteList={
	[ITEMTYPE_CONTAINER]={
	[147434]=true,	--Jubilee Gift
	[194428]=true,	--Jubilee Gift
	},
	[ITEMTYPE_FISH]={}
}
local IgnoreItemId={
[135004]=true,[135006]=true,	--Cyrodiil Assault, Defence Crates
}
local ItemTypes={
	[ITEMTYPE_CONTAINER]={
		[ITEMTYPE_CONTAINER]=true,
		[ITEMTYPE_CONTAINER_CURRENCY]=true
	},
	[ITEMTYPE_FISH]={
		[ITEMTYPE_FISH]=true
	}
}
local ConfirmationDialog={
	["CONFIRM_RETRAIT_LOCKED_ITEM"]=true,
	["CONFIRM_ENCHANT_LOCKED_ITEM"]=true,
	["CONFIRM_IMPROVE_LOCKED_ITEM"]=true,
	}

function SiegeCameraToggle()
	local setting=GetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_THIRD_PERSON_SIEGE_WEAPONRY)
	if setting=="1" then setting="0" else setting="1" end
	SetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_THIRD_PERSON_SIEGE_WEAPONRY, setting, 1)
end

local function IsItemType(slotIndex, Type)
	local itemType=GetItemType(BAG_BACKPACK, slotIndex)
	local id=GetItemId(BAG_BACKPACK, slotIndex)
--	if GeodeContainer[id] then return false end
	if ItemTypes[Type][itemType] and not IgnoreItemId[id] then
		local usable, onlyFromActionSlot=IsItemUsable(BAG_BACKPACK, slotIndex)
		return usable and not onlyFromActionSlot
			and CanInteractWithItem(BAG_BACKPACK, slotIndex)
			and (
				WhiteList[Type][id]
				or (
					GetItemQuality(BAG_BACKPACK, slotIndex)<ITEM_QUALITY_LEGENDARY
					and (
						not GeodeContainer[id]
						or GetMaxPossibleCurrency(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)-GetCurrencyAmount(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)>GeodeContainer[id])
				)
			)
	end
	return false
end

local function HaveItems(Type)
	--d("Checking inventory")
	if not(CheckInventorySpaceSilently(2) and (IsInGamepadPreferredMode() and GAMEPAD_INVENTORY_FRAGMENT or BACKPACK_MENU_BAR_LAYOUT_FRAGMENT):GetState()==SCENE_SHOWN) then return false end
	local total=0
	for i=0, GetBagSize(BAG_BACKPACK)-1 do
		if IsItemType(i, Type) then
			local _, count=GetItemInfo(BAG_BACKPACK, i)
			--d(GetItemInfo(BAG_BACKPACK, i))
			total=total+count
		end
	end
	ItemsTotal[Type]=total
	return total>0
end

local function ChangeLabel(Type)
	local name=Type==ITEMTYPE_FISH and "UI_SHORTCUT_PRIMARY" or "UI_SHORTCUT_SECONDARY"
	local control=KEYBIND_STRIP.keybinds[name]
	if control then
		control=control:GetChild(1)
		if control:GetType()==CT_LABEL then
			local text=ContainerHandlerRunning and BUI.Loc("GENERIC_Stop").." ("..BUI.Loc("GENERIC_Left")..": " or GetString(Type==ITEMTYPE_FISH and SI_KEYBIND_STRIP_FILLET_FISH or SI_KEYBIND_STRIP_OPEN_CONTAINERS).." ("
			control:SetText(text..ItemsTotal[Type]..")")
		end
	end
end

local function HandleAll(Type)
	local result=not CheckInventorySpaceSilently(2) and SI_INVENTORY_ERROR_INVENTORY_FULL or (IsInGamepadPreferredMode() and GAMEPAD_INVENTORY_FRAGMENT or BACKPACK_MENU_BAR_LAYOUT_FRAGMENT):GetState()~=SCENE_SHOWN and SI_TRADESKILLRESULT18 or false
	if result then
		ContainerHandlerRunning=false
		ZO_Alert(UI_ALERT_CATEGORY_ERROR, SOUNDS.NEGATIVE_CLICK, result)
	elseif ContainerHandlerRunning then
		local slotIndex=nil
		for i=0, GetBagSize(BAG_BACKPACK)-1 do
			if IsItemType(i, Type) then slotIndex=i break end
		end
		if slotIndex then
			local _, count=GetItemInfo(BAG_BACKPACK, slotIndex)
			if count>0 then
				EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_LOOT_ITEM_FAILED, function(eventCode, reason)
--					d("Loot reason: "..(LotResults[reason] and LotResults[reason] or ""))
					EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_LOOT_ITEM_FAILED)
					local id=GetItemId(BAG_BACKPACK, slotIndex)
					IgnoreItemId[id]=true
					if ItemsTotal[Type]<=1 then ContainerHandlerRunning=false end
				end)
				local remaining=GetItemCooldownInfo(BAG_BACKPACK, slotIndex)
				if remaining>0 then BUI.CallLater("HandleAll",remaining+50,HandleAll,Type) return end
				ContainerHandlerRunning=Type
--				KEYBIND_STRIP:UpdateKeybindButtonGroup(Type==ITEMTYPE_FISH and Button_Fish or Button_Container)

				if IsProtectedFunction("UseItem") then
					if not CallSecureProtected("UseItem", BAG_BACKPACK, slotIndex) then
						PlaySound(SOUNDS.NEGATIVE_CLICK)
						ContainerHandlerRunning=false
					end
				else
					UseItem(BAG_BACKPACK, slotIndex)
				end

				ItemsTotal[Type]=ItemsTotal[Type]-1
				ChangeLabel(Type)
				BUI.CallLater("HandleAll",(Type==ITEMTYPE_FISH and 2300 or 1300),HandleAll,Type)
			end
		else
			KEYBIND_STRIP:UpdateKeybindButtonGroup(Type==ITEMTYPE_FISH and Button_Fish or Button_Container)
			ContainerHandlerRunning=false
		end
	end
	if not ContainerHandlerRunning then
		EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_LOOT_ITEM_FAILED)
		ChangeLabel(Type)
	end
	return ContainerHandlerRunning
end

local function ContainerHandler_Init(enable)
	if enable then
		Button_Fish={
			alignment=KEYBIND_STRIP_ALIGN_LEFT,
			{
				name=GetString(SI_KEYBIND_STRIP_FILLET_FISH),
				keybind="UI_SHORTCUT_PRIMARY",
				enabled=function()return true end,	--not ContainerHandlerRunning end,
				visible=function()return HaveItems(ITEMTYPE_FISH) end,
				order=100,
				callback=function()
					if ContainerHandlerRunning then
						ContainerHandlerRunning=false
						ChangeLabel(ITEMTYPE_FISH)
					else
						ContainerHandlerRunning=true
						HandleAll(ITEMTYPE_FISH)
					end
				end,
			},
		}

		Button_Container={
			alignment=KEYBIND_STRIP_ALIGN_LEFT,
			{
				name=GetString(SI_KEYBIND_STRIP_OPEN_CONTAINERS),
				keybind="UI_SHORTCUT_SECONDARY",
				enabled=function()return true end,	-- not ContainerHandlerRunning end,
				visible=function()return HaveItems(ITEMTYPE_CONTAINER) end,
				order=100,
				callback=function()
					if ContainerHandlerRunning then
						ContainerHandlerRunning=false
						ChangeLabel(ITEMTYPE_CONTAINER)
					else
						ContainerHandlerRunning=true
						HandleAll(ITEMTYPE_CONTAINER)
					end
				end,
			},
		}
		BACKPACK_MENU_BAR_LAYOUT_FRAGMENT:RegisterCallback("StateChange", function(oldState, newState)
			if newState==SCENE_SHOWN then
				KEYBIND_STRIP:AddKeybindButtonGroup(Button_Fish)
				KEYBIND_STRIP:AddKeybindButtonGroup(Button_Container)
				ChangeLabel(ITEMTYPE_FISH)
				ChangeLabel(ITEMTYPE_CONTAINER)
			elseif newState==SCENE_HIDING then
				KEYBIND_STRIP:RemoveKeybindButtonGroup(Button_Fish)
				KEYBIND_STRIP:RemoveKeybindButtonGroup(Button_Container)
			elseif newState==SCENE_HIDDEN then
				if ContainerHandlerRunning==ITEMTYPE_CONTAINER then LootAll() SCENE_MANAGER:Show("inventory") end
			end
		end )
	else
		BACKPACK_MENU_BAR_LAYOUT_FRAGMENT:UnregisterCallback("StateChange")
	end
end

local function SynergyHandler()
	local hooked=ZO_Synergy.OnSynergyAbilityChanged
	ZO_Synergy.OnSynergyAbilityChanged=function()
		local synergyName,iconFilename=GetSynergyInfo()
		if synergyName then
--			if synergyName=="Feed" and BUI.Vars.FeedSynergy and not IsUnitPlayer('reticleover') then return
			if BUI.Vars.AdvancedSynergy then
				if synergyName~="Welkynar's Light" and (SYNERGY.lastSynergyName=="Shed Hoarfrost" or GetGameTimeMilliseconds()-BUI.Cloudrest.Hoarfrost<2000) then return
				elseif SYNERGY.lastSynergyName=="Gateway" or SYNERGY.lastSynergyName=="Wind of the Welkynar" then return
				elseif synergyName=="Gateway" and BUI.Player.role=="Healer" then return
				elseif synergyName=="Charged Lightning" and (BUI.Player.role=="Tank" or BUI.Player.role=="Healer") then return
				end
			end
		end
		hooked(SYNERGY)
	end
end

local function Menu_Init()
	local warning=BUI.Loc("ReloadUiWarn1")
	local MenuOptions={
		{type="header",	param="AutomationHeader"},
		{type="checkbox",	param="DeleteMail",		warning=true},
		{type="checkbox",	param="GroupLeave",		warning=true},
		{type="checkbox",	param="Books",			warning=true},
		{type="checkbox",	param="LargeGroupInvite",	warning=true},
		{type="checkbox",	param="FastTravel",		warning=true},
		{type="checkbox",	param="InitialDialog",		warning=true},
		{type="checkbox",	param="RepeatableQuests",	warning=true},
--		{type="checkbox",	param="CovetousCountess",	warning=true},
		{type="checkbox",	param="DarkBrotherhoodSpree",	warning=true},
		{type="checkbox",	param="ContainerHandler",	warning=true},
		{type="checkbox",	param="StealthWield",		warning=true},
		{type="checkbox",	param="LootStolen",		warning=true},
		{type="checkbox",	param="ConfirmLocked"},

		{type="header",	param="BlockingsHeader"},
--		{type="checkbox",	param="FeedSynergy"},
		{type="checkbox",	param="AdvancedSynergy"},
		{type="checkbox",	param="JumpToLeader",		warning=true},
		{type="checkbox",	param="LargeGroupAnnoucement",warning=true},
		{type="checkbox",	param="FriendStatus",		warning=true},
		{type="checkbox",	param="BlockAnnouncement",	warning=true},
		{type="dropdown",	param="HousePins",		warning="ReloadUiWarn3", choices={BUI.Loc("AUTOMATION_SETTINGS_MAP_PIN_All"),BUI.Loc("AUTOMATION_SETTINGS_MAP_PIN_Owned"),BUI.Loc("AUTOMATION_SETTINGS_MAP_PIN_Unowned"),BUI.Loc("AUTOMATION_SETTINGS_MAP_PIN_Disabled")}},

		{type="header",	param="ImprovementsHeader"},
		{type="checkbox",	param="PlayerToPlayer",		warning=true},
		{type="checkbox",   param="BuiltInGlobalCooldown", warning=true},
		{type="checkbox",   param="AutoDismissPet", warning=true},
		{type="button",	name="Reload UI",func=function() SCENE_MANAGER:SetInUIMode(false) BUI.OnScreen.Notification(8, BUI.Loc("SETTINGS_ReloadingUI")) BUI.CallLater("ReloadUI",1000,ReloadUI) end},
		}
	local Options,i,var={},0,0
	for _,option in pairs(MenuOptions) do
		if not option.condition or BUI.Vars[option.condition] then
		for _,dup in pairs(option.dup and option.dup or {1}) do
			if not option.dup or (option.dup and (type(option.param)~="table" or (type(option.param)=="table" and option.param[dup]))) then
			i=i+1;Options[i]={}
			Options[i].type			=option.type
			if option.name then
				Options[i].name		=(option.icon and "|t32:32:"..option.icon.."|t " or "")..
								(option.dup and (type(option.name)=="table" and dup.." "..option.name[dup] or dup.." "..option.name) or option.name)
			else
				Options[i].name		=BUI.Loc(option.param)
			end
			if option.tooltip then
				Options[i].tooltip	=option.tooltip
			elseif option.param then
				Options[i].tooltip		=BUI.Loc(option.param.."Desc")
			end
			if option.text then
				Options[i].text		=option.text
			end
			if option.warning then
				Options[i].warning	=warning
			end
			if option.type=="slider" then
				Options[i].min		=1
				Options[i].max		=10
				Options[i].step		=1
			end
			if option.choices then
				Options[i].choices	=option.choices
			end
			if option.func then
				Options[i].func		=option.func
			end
			if option.width then
				Options[i].width		=option.width
			end
			if option.disabled then
				Options[i].disabled	=option.disabled
			end
			if option.param then
				Options[i].getFunc	=function()
					local var
					if option.dup then
						if type(option.param)=="table" then var=BUI.Vars[ option.param[dup] ]
						else var=BUI.Vars[option.param][dup] end
					else var=BUI.Vars[option.param] end
					return var
					end
				Options[i].setFunc	=function(value)
					if option.dup then
						if type(option.param)=="table" then BUI.Vars[ option.param[dup] ]=value
						else BUI.Vars[option.param][dup]=value end
					else BUI.Vars[option.param]=value end
					if option.func then local function func(value) option.func(value) end func(value) end
					end
				if option.dup then
					if type(option.param)=="table" then var=Defaults[ option.param[dup] ]
					else var=Defaults[option.param][dup] end
				else var=Defaults[option.param] end
				Options[i].default	=var
			end
			end
		end
		end
	end
	BUI.Menu.RegisterPanel("BUI_MenuAutomation",{
			type="panel",
			name="18. |t32:32:/esoui/art/treeicons/store_indexicon_bundle_up.dds|t"..BUI.Loc("AutomationHeader"),
			})
	BUI.Menu.RegisterOptions("BUI_MenuAutomation", Options)
end

function BUI.Automation_Init()
	Menu_Init()
	SynergyHandler()

--	EVENT_MANAGER:UnregisterForEvent("KeyboardNotifications",EVENT_GUILD_DESCRIPTION_CHANGED)

	if BUI.Vars.HousePins~=4 then
		RedirectTexture("/esoui/art/icons/poi/poi_group_house_glow.dds","/BanditsUserInterface/textures/theme/blank.dds")
		if BUI.Vars.HousePins==3 or BUI.Vars.HousePins==1 then
			RedirectTexture("/esoui/art/icons/poi/poi_group_house_unowned.dds","/BanditsUserInterface/textures/theme/blank.dds")
		end
		if BUI.Vars.HousePins<=2 then
			RedirectTexture("/esoui/art/icons/poi/poi_group_house_owned.dds","/BanditsUserInterface/textures/theme/blank.dds")
		end
	end

	ZO_PreHook("ZO_Dialogs_ShowDialog",function(dialog)
		if BUI.Vars.ConfirmLocked then
			BUI.CallLater("ConfirmationDialog",10,function()
				if ConfirmationDialog[dialog] then
					ZO_Dialog1EditBox:SetText(GetString(SI_PERFORM_ACTION_CONFIRMATION))
					ZO_Dialog1EditBox:LoseFocus()
				end
			end)
		end
	end)

	if BUI.Vars.PlayerToPlayer then	--Provided by @zelenin
		local hooked=PLAYER_TO_PLAYER.AddMenuEntry
		PLAYER_TO_PLAYER.AddMenuEntry=function(self, text, ...)
			if text==GetString(SI_PLAYER_TO_PLAYER_REMOVE_GROUP) then return end
			hooked(self, text, ...)
		end
	end

	--DELETE MAIL
	ZO_Dialogs_RegisterCustomDialog("BUI_DELETE_CONFIRMATION", {
		gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC, allowShowOnNextScene=true},
		title={text=SI_PROMPT_TITLE_DELETE_MAIL_ATTACHMENTS},
		mainText=function(dialog) return {text=dialog.data.body} end,
		buttons=
			{
				{text=SI_OK,callback=function(dialog)dialog.data.confirmationCallback()end,keybind="DIALOG_PRIMARY",clickSound=SOUNDS.MAIL_ITEM_DELETED},
				{text=SI_DIALOG_CANCEL,keybind="DIALOG_NEGATIVE",clickSound=SOUNDS.DIALOG_ACCEPT}
			}
		}
	)
	if BUI.Vars.DeleteMail then
		MAIL_INBOX.Delete=function(self)
			if self.mailId then
				local dialogTextParams = { mainTextParams = { GetString(SI_DELETE_MAIL_CONFIRMATION_TEXT), }, }
				local numAttachments,attachedMoney=GetMailAttachmentInfo(self.mailId)
				if numAttachments>0 or attachedMoney>0 then
					ZO_Dialogs_ShowDialog("BUI_DELETE_CONFIRMATION", { confirmationCallback = function(...) DeleteMail(self.mailId) PlaySound(SOUNDS.MAIL_ITEM_DELETED) end, title = SI_PROMPT_TITLE_DELETE_MAIL_ATTACHMENTS, body = BUI.Loc("DeleteMailConfirm"), })
				else
					DeleteMail(self.mailId)
					PlaySound(SOUNDS.MAIL_ITEM_DELETED)
				end
			end
		end
	end

	if BUI.Vars.JumpToLeader then
		PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_UNIT_CREATED)
		PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_ZONE_UPDATE)
		PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_GROUP_MEMBER_JOINED)
		PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_LEADER_UPDATE)
		PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_GROUP_MEMBER_LEFT)
	end

	if BUI.Vars.BlockAnnouncement then
		local function OnPlayerActivated(eventCode, initial)
			if initial then
				local scene=SCENE_MANAGER:GetScene('marketAnnouncement')
				local function OnSceneStateChange(oldState, newState)
					if newState==SCENE_SHOWN then
						SCENE_MANAGER:HideCurrentScene()
						scene:UnregisterCallback('StateChange', OnSceneStateChange)
					end
				end
				scene:RegisterCallback('StateChange', OnSceneStateChange)
			end
		end
		EVENT_MANAGER:RegisterForEvent("BUI_Event_Announce",EVENT_PLAYER_ACTIVATED,OnPlayerActivated)
	end

	local BuiltInGlobalCooldownOn=false
	if BUI.Vars.BuiltInGlobalCooldown then
		if not BuiltInGlobalCooldownOn then
	    	BuiltInGlobalCooldownOn=true
	       	d(BUI.Loc("AUTOMATION_Global_Cooldown"))
	       	ZO_ActionButtons_ToggleShowGlobalCooldown()
	    end
	end

	if BUI.Vars.GroupLeave then
		GROUP_LIST["keybindStripDescriptor"][4].callback=function() GroupLeave() end
	end

	if BUI.Vars.FriendInvite then
		EVENT_MANAGER:UnregisterForEvent("KeyboardNotifications",EVENT_INCOMING_FRIEND_INVITE_ADDED)
	end

	if BUI.Vars.QuestShare then
		EVENT_MANAGER:UnregisterForEvent("KeyboardNotifications",EVENT_QUEST_SHARED)
	end

	if BUI.Vars.GuildNot then
		EVENT_MANAGER:UnregisterForEvent("KeyboardNotifications",EVENT_GUILD_MOTD_CHANGED)
		EVENT_MANAGER:UnregisterForEvent("KeyboardNotifications",EVENT_RAID_SCORE_NOTIFICATION_ADDED)
	end

	if BUI.Vars.Books then
		local LastBook=""
		local function BookHandler(eventCode,inBook)
			local action,item,_,_ ,_,_=GetGameCameraInteractableActionInfo()
			if LastBook==item and item~="Bookshelf" then
				LastBook=""
			elseif action==GetString(SI_GAMECAMERAACTIONTYPE1)	--search
				or action==GetString(SI_GAMECAMERAACTIONTYPE15)	--examine
				or item=="Bookshelf" then
				SCENE_MANAGER:ShowBaseScene()
				LastBook=item
			end
		end
		EVENT_MANAGER:RegisterForEvent("BUI_Event",EVENT_SHOW_BOOK,BookHandler)
	end

	if BUI.Vars.FriendStatus then
		EVENT_MANAGER:UnregisterForEvent("ChatRouter", EVENT_FRIEND_PLAYER_STATUS_CHANGED)
	end

	if BUI.Vars.LargeGroupInvite then
	TryGroupInviteByName=function(Name,sentFromChat,displayInvitedMessage)
		if IsPlayerInGroup(Name) then ZO_Alert(UI_ALERT_CATEGORY_ALERT,nil,SI_GROUP_ALERT_INVITE_PLAYER_ALREADY_MEMBER) return end
		if not IsUnitGroupLeader("player") and GetGroupSize()>0 then ZO_Alert(UI_ALERT_CATEGORY_ALERT,nil,GetString("SI_GROUPINVITERESPONSE",GROUP_INVITE_RESPONSE_ONLY_LEADER_CAN_INVITE)) return end
		if IsConsoleUI() then
			local function GroupInviteCallback(success)
				if success then
					GroupInviteByName(Name)
					ZO_Menu_SetLastCommandWasFromMenu(not sentFromChat)
					if displayInvitedMessage then ZO_Alert(ALERT,nil,zo_strformat(GetString("SI_GROUPINVITERESPONSE",GROUP_INVITE_RESPONSE_INVITED),ZO_FormatUserFacingName(Name))) end
				end
			end
			ZO_ConsoleAttemptInteractOrError(GroupInviteCallback,Name,ZO_PLAYER_CONSOLE_INFO_REQUEST_DONT_BLOCK,ZO_CONSOLE_CAN_COMMUNICATE_ERROR_ALERT,ZO_ID_REQUEST_TYPE_DISPLAY_NAME,displayName)
		else
			if IsIgnored(Name) then ZO_Alert(UI_ALERT_CATEGORY_ALERT,nil,SI_GROUP_ALERT_INVITE_PLAYER_BLOCKED) return end
			GroupInviteByName(Name)
			ZO_Menu_SetLastCommandWasFromMenu(not sentFromChat)
			if displayInvitedMessage then ZO_Alert(ALERT,nil,zo_strformat(GetString("SI_GROUPINVITERESPONSE",GROUP_INVITE_RESPONSE_INVITED),Name)) end
		end
	end
	end

	if BUI.Vars.LargeGroupAnnoucement then
		EVENT_MANAGER:UnregisterForEvent("ChatRouter", EVENT_GROUP_TYPE_CHANGED)
	end

	if BUI.Vars.FastTravel and not IsInGamepadPreferredMode() then
		ESO_Dialogs["RECALL_CONFIRM"]={
			gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC},
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			canQueue=true,
			updateFn=function(dialog)
--				if not IsInGamepadPreferredMode() then
					FastTravelToNode(dialog.data.nodeIndex)
--					SCENE_MANAGER:ShowBaseScene()
					ZO_Dialogs_ReleaseDialog("RECALL_CONFIRM")
					SCENE_MANAGER:SetInUIMode(false)
--				end
			end
		}
		ESO_Dialogs["FAST_TRAVEL_CONFIRM"]={
			gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC},
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			canQueue=true,
			updateFn=function(dialog)
--				if not IsInGamepadPreferredMode() then
					FastTravelToNode(dialog.data.nodeIndex)
					ZO_Dialogs_ReleaseDialog("FAST_TRAVEL_CONFIRM")
					SCENE_MANAGER:SetInUIMode(false)
--				end
			end
		}
	end

	if BUI.Vars.InitialDialog or BUI.Vars.RepeatableQuests then
		local UndauntedNPCname={["Maj al-Ragath"]=true,["Glirion the Redbeard"]=true,["Urgarlag Chief-bane"]=true,["Bolgrul"]=true}
		local QuestNPCname={
		["Cardea Gallus"]=true,	--Fighters guild
		["Alvur Baren"]=true,	--Mages guild
--		["Maj al-Ragath"]=true,["Glirion the Redbeard"]=true,["Urgarlag Chief-bane"]=true,["Bolgrul"]=true,	--Undaunted
		["Zahari"]=true,["Battlereeve Tanerline"]=true,["Nisuzi"]=true,["Ri'hirr"]=true,	--Elsweyr
		["Jee-Lar"]=true,["Bolu"]=true,["Varo Hosidias"]=true,["Tuwul"]=true,	--Murkmire
		["Razgurug"]=true,["Clockwork Facilitator"]=true,["Novice Holli"]=true,["Bursar of Tributes"]=true,	--Clockwork City
		["Justiciar Tanorian"]=true,["Justiciar Farowel"]=true,	--Summerset
		["Traylan Omoril"]=true,["Beleru Omoril"]=true,["Dredase-Hlarar"]=true,["Valga Celatus"]=true,	--Vivec City
		["Huntmaster Sorim-Nakar"]=true,["Numani-Rasi"]=true,	--Ald'ruhn
		["Arzorag"]=true,["Guruzug"]=true,["Nednor"]=true,["Sonolia Muspidius"]=true,["Bagrugbesh"]=true,["Menninia"]=true,["Ushang the Untamed"]=true,["Arushna"]=true,["Thazeg"]=true,	--Wrothgar
		["Spencer Rye"]=true,["Reacquisition Board"]=true,["Fa'ren-dar"]=true,["Heist Board"]=true,	--Thieves Guild
		["Elam Drals"]=true,	--Dark Brotherhood	["Speaker Terenus"]=true,
		["Bounty Board"]=true,["Laronen"]=true,["Finia Sele"]=true,["Codus ap Dugal"]=true,	--Gold Coast
		}
		local BursarOfTributes={["Armor"]=true,["ed wi"]=true,["ures."]=true,["our f"]=true}
		local dialog_step=0
		local function EndQuestDialog()
			EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_QUEST_OFFERED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_QUEST_REMOVED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_QUEST_ADDED)
			EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_QUEST_COMPLETE_DIALOG)
--			d("Quest handler: done")
			EndInteraction(INTERACTION_CONVERSATION)
			dialog_step=0
		end
		local function HandleChatterBegin(eventCode, optionCount)
			local optionString,optionType=GetChatterOption(1)
			local _, name=GetGameCameraInteractableActionInfo()
--			d(name.." ["..optionType.."] "..optionString)
			if BUI.Vars.RepeatableQuests
			and (optionType==CHATTER_START_TALK or optionType==CHATTER_TALK_CHOICE or optionType==CHATTER_START_NEW_QUEST_BESTOWAL or optionType==CHATTER_START_COMPLETE_QUEST or optionType==CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS)
			and QuestNPCname[name] then
--				d("Start quest dialog")
				if optionType==CHATTER_START_NEW_QUEST_BESTOWAL then
--					d("NEW_QUEST_BESTOWAL Step: "..dialog_step)
					if name~="Bursar of Tributes" or BursarOfTributes[string.sub(GetOfferedQuestInfo(),121,125)] then
						EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_QUEST_OFFERED, AcceptOfferedQuest)
						EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_QUEST_ADDED, EndQuestDialog)
					end
					if dialog_step==0 then BUI.CallLater("ChatterBegin",250,HandleChatterBegin) end
					dialog_step=dialog_step+1
				elseif optionType==CHATTER_START_COMPLETE_QUEST then
					EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_QUEST_COMPLETE_DIALOG, CompleteQuest)
					EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_QUEST_REMOVED, EndQuestDialog)
				elseif optionType==CHATTER_START_TALK then
--					d("START_TALK")
					BUI.CallLater("ChatterBegin",250,HandleChatterBegin)
				elseif optionType==CHATTER_TALK_CHOICE or optionType==CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS then
--					d("TALK_CHOICE")
					BUI.CallLater("CompleteQuest",250,CompleteQuest)
					EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_QUEST_REMOVED, EndQuestDialog)
				end
				SelectChatterOption(1)
			elseif BUI.Vars.InitialDialog then
				if	(optionType==CHATTER_START_BANK and select(2,GetChatterOption(2))~=CHATTER_START_GUILDBANK)
				or	(optionType==CHATTER_START_SHOP and not UndauntedNPCname[name])
				or	(optionType==CHATTER_START_NEW_QUEST_BESTOWAL or optionType==CHATTER_START_COMPLETE_QUEST)
				or	(optionType==CHATTER_GOODBYE)
				or	(optionType==3400 and select(2,GetChatterOption(2))~=3902)
				then SelectChatterOption(1)
--				elseif (optionType==CHATTER_START_TALK and select(2,GetChatterOption(2))==CHATTER_START_SHOP) then SelectChatterOption(2)
				elseif (select(2,GetChatterOption(2))==3902) then SelectChatterOption(2)
				end
			end
		end

		EVENT_MANAGER:RegisterForEvent("BUI_Event",EVENT_CHATTER_BEGIN,HandleChatterBegin)
	end
--	/script local _, name=GetGameCameraInteractableActionInfo() StartChatInput("[\""..name.."\"]=true,")
--	/script StartChatInput(string.sub(GetOfferedQuestInfo(),5,12))
	if BUI.Vars.CovetousCountess or BUI.Vars.DarkBrotherhoodSpree then
		local lastInteractableName
		SecurePostHook(FISHING_MANAGER or INTERACTIVE_WHEEL_MANAGER, "StartInteraction", function() local _, name=GetGameCameraInteractableActionInfo() lastInteractableName=name end)
---		ZO_PreHook(FISHING_MANAGER, "StartInteraction", function() local _, name=GetGameCameraInteractableActionInfo() lastInteractableName=name end)
--		local tipBoard={["Tip Board"]=true,["Brett für Aufträge"]=true,["Tableau des tuyaux"]=true,["Доска объявлений"]=true,}
		local contractBook={["Marked for Death"]=true,}
--		local CovetousDialog={["eemed th"]=true,["e new fa"]=true,["ochgesch"]=true,["s gibt e"]=true,["Voleurs "]=true,["De la bl"]=true,["овые"]=true}
		local nonSpreeDialog={["'d think"]=true,[" Queen h"]=true,["re's a b"]=true,["en Ayren"]=true,["as passi"]=true,["re is a "]=true,["annot ab"]=true,[" Spinner"]=true,["e and Jo"]=true,["g Aerada"]=true,[" don't t"]=true,["re's a t"]=true,["spouse b"]=true,["more Tha"]=true,["ry day I"]=true,[" of the "]=true,["e fool k"]=true,["kwasten "]=true,["ave a cu"]=true,["s one se"]=true,["en-ja is"]=true,["dbeats. "]=true,["ls of Ju"]=true,["re are s"]=true,["ave been"]=true,[" Stone O"]=true,[" cheerin"]=true,[" at peak"]=true,["e been d"]=true,["m positi"]=true,["py hides"]=true,["an't tol"]=true,[" being m"]=true,["oward hi"]=true,["prey has"]=true,["se Dorel"]=true,["advancem"]=true,["t the be"]=true,["se who s"]=true,["ealous b"]=true,["agitator"]=true,["re's an "]=true,["m forced"]=true,[" seeds o"]=true,["eek to g"]=true,["elers ma"]=true,["kin dish"]=true,[" careles"]=true,["lorious "]=true,["rect the"]=true,["eally ca"]=true,["people m"]=true,["lover—fo"]=true,["losed ar"]=true,["re is a "]=true,["rine dut"]=true,["n the Da"]=true,[" losing "]=true,["d slaugh"]=true,[" milk-dr"]=true,[" suspici"]=true,}
		local function OverwritePopulateChatterOption(interaction)
			local PopulateChatterOption=interaction.PopulateChatterOption
			interaction.PopulateChatterOption=function(self, index, fun, txt, type, ...)
				local ZoneId=GetZoneId(GetUnitZoneIndex("player"))
--				if (BUI.Vars.CovetousCountess and tipBoard[lastInteractableName] and ZoneId==821 and not CovetousDialog[string.sub(GetOfferedQuestInfo(),5,12)])
				if (BUI.Vars.DarkBrotherhoodSpree and contractBook[lastInteractableName] and ZoneId==826 and nonSpreeDialog[string.sub(GetOfferedQuestInfo(),5,12)])
				then
					EndInteraction(INTERACTION_QUEST)
					ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, BUI.Loc("AUTOMATION_Quest_Low_Reward"))
					return
				end
				PopulateChatterOption(self, index, fun, txt, type, ...)
--				if tipBoard[lastInteractableName] then lastInteractableName=nil end
			end
		end
		OverwritePopulateChatterOption(GAMEPAD_INTERACTION)
		OverwritePopulateChatterOption(INTERACTION)
	end

	--ContainerHandler
	ContainerHandler_Init(BUI.Vars.ContainerHandler)

	if BUI.Vars.StealthWield or BUI.Vars.LootStolen then
		EVENT_MANAGER:RegisterForEvent("BUI_Event",EVENT_STEALTH_STATE_CHANGED,function(_,unitTag,stealthState)
			if unitTag=='player' then
				if stealthState<2 then
					if BUI.Vars.LootStolen and LootStolen and (not BUI.BladeOfWoe or BUI.BladeOfWoe+2000<GetGameTimeMilliseconds()) then LootStolen=false SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT_STOLEN, "0") end
				elseif stealthState>2 then
					if BUI.Vars.LootStolen and not LootStolen then LootStolen=true SetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT_STOLEN, "1") end
					if BUI.Vars.StealthWield and ArePlayerWeaponsSheathed() then
						local action=GetGameCameraInteractableActionInfo()
						if action==nil then TogglePlayerWield() end
					end
				end
			end
		end)
	end

	CHAT_SYSTEM.maxContainerWidth,CHAT_SYSTEM.maxContainerHeight=GuiRoot:GetDimensions()
end
