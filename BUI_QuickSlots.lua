local QUICKSLOTMAP		={4,3,2,1,8,7,6,5}
local QUICKSLOTS			={[4]=1,[3]=2,[2]=3,[1]=4,[8]=5,[7]=6,[6]=7,[5]=8}
local QUICKSLOT_FRAGMENT	=ZO_FadeSceneFragment:New(ZO_QuickSlot)
local DefaultQuickSlot		=ZO_ActionBar_GetButton(ACTION_BAR_FIRST_NORMAL_SLOT_INDEX+1)
local ActionBarWidth,EffectSlot

local function GetKeyBind(i)
	local keyname="BUI_QUICKSLOT_"..i
	local modifier=""
	local l,c,a=GetActionIndicesFromName(keyname)
	local key,m1,m2,m3,m4=GetActionBindingInfo(l,c,a,1)
	if key~=KEY_INVALID then
		local mod={
		ZO_Keybindings_DoesKeyMatchAnyModifiers(KEY_SHIFT,m1,m2,m3,m4),
		ZO_Keybindings_DoesKeyMatchAnyModifiers(KEY_CTRL,m1,m2,m3,m4),
		ZO_Keybindings_DoesKeyMatchAnyModifiers(KEY_ALT,m1,m2,m3,m4),
		}
		if mod[1] then modifier=modifier.."Shift+" end
		if mod[2] then modifier=modifier.."CTRL+" end
		if mod[3] then modifier=modifier.."ALT+" end
		return modifier..GetKeyName(key)
	else return i end
end

local function RemoveEffect()
	if EffectSlot and DefaultQuickSlot.procLoop then
		DefaultQuickSlot.procLoopTimeline:Stop() DefaultQuickSlot.procLoop:SetHidden(true)
	end
	EffectSlot=nil
end

local function AddEffect()
	if not DefaultQuickSlot.procLoop then
		DefaultQuickSlot.procLoop=WINDOW_MANAGER:CreateControl("$(parent)LoopAnim", DefaultQuickSlot.slot, CT_TEXTURE)
		DefaultQuickSlot.procLoop:SetAnchor(TOPLEFT,DefaultQuickSlot.slot,TOPLEFT,3,3)
		DefaultQuickSlot.procLoop:SetAnchor(BOTTOMRIGHT,DefaultQuickSlot.slot,BOTTOMRIGHT,-3,-3)
		DefaultQuickSlot.procLoop:SetTexture("EsoUI/Art/ActionBar/abilityHighlight_mage_med.dds") 
		DefaultQuickSlot.procLoop:SetDrawTier(DT_HIGH)
		DefaultQuickSlot.procLoopTimeline=ANIMATION_MANAGER:CreateTimelineFromVirtual("BUI_ProcReadyLoop", DefaultQuickSlot.procLoop)
	end
	DefaultQuickSlot.procLoopTimeline:PlayFromStart() DefaultQuickSlot.procLoop:SetHidden(false)
	BUI.CallLater("RemoveEffect",3000,RemoveEffect)
end

local function OnSlotAbilityUsed(_,slot)
	d(slot)
	if slot<9 or slot>16 then return end
	local remain,duration=GetSlotCooldownInfo(_slot,HOTBAR_CATEGORY_QUICKSLOT_WHEEL)
	EffectSlot=slot
	d(remain,duration)
	AddEffect()
end

local function OnSlotChanged()
	for i=1,BUI.Vars.QuickSlotsShow do BUI_QuickSlots[i].status:SetHidden(true) end
	local slot=GetCurrentQuickslot()
--	pl("Selected quickslot: "..tostring(slot))
	local i=QUICKSLOTS[slot]
	if i and i<=BUI.Vars.QuickSlotsShow then
		BUI_QuickSlots[i].status:SetHidden(false)
		BUI_QuickSlots[i].count:SetText(GetSlotItemCount(slot,HOTBAR_CATEGORY_QUICKSLOT_WHEEL))
	end
	if EffectSlot and slot~=EffectSlot then RemoveEffect() end
end

local c_type={
[MOUSE_CONTENT_ACTION]="ACTION",
[MOUSE_CONTENT_COLLECTIBLE]="COLLECTIBLE",
[MOUSE_CONTENT_EMPTY]="EMPTY",
[MOUSE_CONTENT_EQUIPPED_ITEM]="EQUIPPED_ITEM",
[MOUSE_CONTENT_INVENTORY_ITEM]="INVENTORY_ITEM",
[MOUSE_CONTENT_QUEST_ITEM]="QUEST_ITEM",
[MOUSE_CONTENT_STORE_BUYBACK_ITEM]="BUYBACK_ITEM",
[MOUSE_CONTENT_STORE_ITEM]="STORE_ITEM",
[MOUSE_CONTENT_TRADE_ITEM]="TRADE_ITEM",
}

local function SlotsUpdate()
	for i=1,8 do
		slot=BUI_QuickSlots[i]
		if slot then
			local texture=GetSlotTexture(slot.slot,HOTBAR_CATEGORY_QUICKSLOT_WHEEL)
			slot.icon:SetTexture(texture)
			slot.icon:SetHidden(texture=="")
			slot.icon:SetDrawTier(DT_HIGH)
			slot.icon:SetDrawLayer(DL_CONTROLS)
			slot.count:SetText(GetSlotItemCount(slot.slot,HOTBAR_CATEGORY_QUICKSLOT_WHEEL))
		end
	end
end

local function OnReceiveDrag(self)
	ClearCursor()
	PlaySound('Tablet_PageTurn')
	if DragData then
		if DragData.cursorType==MOUSE_CONTENT_INVENTORY_ITEM then
			CallSecureProtected('SelectSlotItem', DragData.param1, DragData.param2, self.slot)
		elseif DragData.cursorType==MOUSE_CONTENT_COLLECTIBLE then
			CallSecureProtected('SelectSlotSimpleAction', ACTION_TYPE_COLLECTIBLE, DragData.param1, self.slot)
		elseif cursorType==MOUSE_CONTENT_QUEST_ITEM then
			CallSecureProtected('SelectSlotSimpleAction', ACTION_TYPE_QUEST_ITEM, DragData.param1, self.slot)
		end
		BUI.CallLater("SlotsUpdate",250,SlotsUpdate)
	end
end
--	/script CallSecureProtected('PickupCollectible',300)
local function OnCursorPickup(self, cursorType, param1, param2)
--	d(c_type[cursorType],param1,param2)
	if cursorType==MOUSE_CONTENT_INVENTORY_ITEM or cursorType==MOUSE_CONTENT_COLLECTIBLE or cursorType==MOUSE_CONTENT_QUEST_ITEM then
		DragData={cursorType=cursorType,param1=param1,param2=param2}
	end
end

function BUI.QuickSlots.Update(theme,slots,parent)
	slots=slots or BUI.Vars.QuickSlotsShow
	parent=parent or QuickslotButton	--DefaultQuickSlot.slot
	local theme_color=BUI.Vars.Theme==6 and {1,204/255,248/255,1} or BUI.Vars.Theme==7 and BUI.Vars.AdvancedThemeColor or BUI.Vars.Theme>3 and BUI.Vars.CustomEdgeColor or {1,1,1,1}
	if theme then
		for i=1,slots do
			BUI_QuickSlots[i].edge:SetTexture(BUI.abilityframe)
			BUI_QuickSlots[i].edge:SetColor(unpack(theme_color))
		end
		return
	end
	local space		=2
	local h		=DefaultQuickSlot.slot:GetHeight()*(slots%2/2+.5)-space*(1-slots%2)/2
	local height	=h*(2-slots%2)+space*(1-slots%2)
	local width		=(h+space)*(slots%2/2+.5)*slots
--	local parent	=slots==9 and ZO_SharedRightPanelBackground or ZO_ActionBar1
	local anchor	=slots==9 and {TOPLEFT,parent,BOTTOMLEFT,80,40} or {TOPRIGHT,parent,TOPLEFT,-20,0}
	local ui		=BUI_QuickSlots
	if ui then ui:SetParent(parent) else ui=WINDOW_MANAGER:CreateControl("BUI_QuickSlots", parent, CT_CONTROL) end
	ui:SetDimensions(width,height)
	ui:ClearAnchors()
	ui:SetAnchor(unpack(anchor))
	ui:SetHidden(not BUI.Vars.QuickSlots)
	if BUI.Vars.QuickSlots then
		for i=1,math.min(slots,8) do
			local row=(slots%2==1 or (slots%2==0 and i<=slots/2)) and 0 or h+space
			local col=(slots%2==1 or (slots%2==0 and i<=slots/2)) and (i-1)*(h+space) or (i-slots/2-1)*(h+space)
			ui[i]=BUI.UI.Control("BUI_QuickSlot"..i, ui, {h,h}, {TOPLEFT,TOPLEFT,col,row})
			ui[i].bg	=BUI.UI.Texture("BUI_QuickSlot"..i.."Bg", ui[i], {h,h}, {TOPLEFT,TOPLEFT,0,0}, "/EsoUI/Art/ActionBar/abilityInset.dds", false, 0)
			ui[i].edge	=BUI.UI.Texture("BUI_QuickSlot"..i.."Edge", ui[i], {h,h}, {TOPLEFT,TOPLEFT,0,0}, BUI.abilityframe, false, 2)
			ui[i].edge:SetColor(unpack(theme_color))
			local texture=GetSlotTexture(QUICKSLOTMAP[i],HOTBAR_CATEGORY_QUICKSLOT_WHEEL)
			ui[i].icon		=BUI.UI.Texture("BUI_QuickSlot"..i.."Icon", ui[i], {h-space,h-space}, {TOPLEFT,TOPLEFT,space/2,space/2}, texture, texture=="", 1)
			ui[i].status	=BUI.UI.Texture("BUI_QuickSlot"..i.."Status", ui[i], {h-space,h-space}, {TOPLEFT,TOPLEFT,space/2,space/2}, "/EsoUI/Art/ActionBar/ActionSlot_toggledon.dds", true, 2)
			ui[i].over		=BUI.UI.Texture("BUI_QuickSlot"..i.."DropCallout", ui[i], {h-space,h-space}, {TOPLEFT,TOPLEFT,space/2,space/2}, "/EsoUI/Art/ActionBar/actionBar_mouseOver.dds", true, 2)
			ui[i].count		=BUI.UI.Label("BUI_QuickSlot"..i.."Count", ui[i].icon, {h-space*2,h*.4}, {BOTTOMLEFT,BOTTOMLEFT,0,-space}, BUI.UI.Font("esobold",h*.4,true), nil, {2,1}, GetSlotItemCount(QUICKSLOTMAP[i],HOTBAR_CATEGORY_QUICKSLOT_WHEEL))
			ui[i].key		=BUI.UI.Label("BUI_QuickSlot"..i.."Key", ui[i], {h,13}, {TOPLEFT,BOTTOMLEFT,0,0}, "ZoFontGameSmall", nil, {1,1}, GetKeyBind(i),slots%2==0)
			ui[i].slot=QUICKSLOTMAP[i]
			ui[i]:SetDrawTier(DT_HIGH)
			ui[i]:SetDrawLayer(DL_CONTROLS)
			ui[i]:SetMouseEnabled(true)
			ui[i]:SetHandler("OnMouseDown", function(self,button)
				if button==1 then SetCurrentQuickslot(self.slot)
				elseif button==2 then PlaySound('Tablet_PageTurn') CallSecureProtected('ClearSlot',self.slot) BUI.CallLater("SlotsUpdate",500,SlotsUpdate)
				end
			end)
			ui[i]:SetHandler("OnMouseEnter", function(self)
				self.over:SetHidden(false)
				local link=GetSlotItemLink(self.slot)
				if link and link~="" then
					self.tooltip=ItemTooltip
					InitializeTooltip(self.tooltip,self,BOTTOM,0,-5,TOP)
					self.tooltip:SetLink(link)
					ZO_ItemTooltip_ClearCondition(self.tooltip)
					ZO_ItemTooltip_ClearCharges(self.tooltip)
				end
			end)
			ui[i]:SetHandler("OnMouseExit", function(self)
				self.over:SetHidden(true)
				if self.tooltip then ClearTooltip(self.tooltip) self.tooltip=nil end
			end)
			ui[i]:SetHandler('OnReceiveDrag',OnReceiveDrag)
		end
		for i=slots+1,8 do
			if ui[i] then ui[i]:SetHidden(true) end
		end

		OnSlotChanged()
	end
end

function BUI.QuickSlots.SelectQuickSlot(slotId)
	if QUICKSLOT_FRAGMENT:IsShowing() then return end
	SetCurrentQuickslot(QUICKSLOTMAP[slotId])
	PlaySound("Click_Positive")
end

function BUI.QuickSlots.SelectQuickSlotNext(_next)
	local _slot=QUICKSLOTS[GetCurrentQuickslot()]+_next
	if _slot>8 then _slot=1 elseif _slot<1 then _slot=8 end
	BUI.QuickSlots.SelectQuickSlot(_slot)
end

function BUI.QuickSlots:Initialize()
	if BUI.init.QuickSlots then
		BUI.QuickSlots.Update()
		if not BUI.Vars.QuickSlots then
			BUI.init.QuickSlots=false
--			QUICKSLOT_FRAGMENT:UnregisterCallback("StateChange")
			EVENT_MANAGER:UnregisterForEvent("BUI_QS_Ivent", EVENT_ACTIVE_QUICKSLOT_CHANGED)
			return
		end
	end
	if BUI.Vars.QuickSlots then
--		ActionBarWidth=ZO_ActionBar1:GetWidth()
		BUI.QuickSlots.Update()
		BUI.init.QuickSlots=true
--[[
		QUICKSLOT_FRAGMENT:RegisterCallback("StateChange", function(oldState, newState)
			if BUI.init.QuickSlots then if newState==SCENE_SHOWING or newState==SCENE_HIDING then BUI.QuickSlots.Update() end end
		end)
--]]
--		EVENT_MANAGER:RegisterForEvent("BUI_QS_Event", EVENT_ACTION_SLOTS_FULL_UPDATE,	OnActionSlotsUpdated)
--		EVENT_MANAGER:RegisterForEvent("BUI_QS_Event", EVENT_ACTION_SLOT_UPDATED,		OnActionSlotsUpdate)
		EVENT_MANAGER:RegisterForEvent("BUI_QS_Event", EVENT_ACTIVE_QUICKSLOT_CHANGED,	OnSlotChanged)
		for _,frame in pairs({ZO_QuickSlot,ZO_QuickSlot_Keyboard_TopLevel,ZO_PlayerInventory}) do
		ZO_PreHookHandler(frame,'OnShow',	function()
			if BUI.Vars.QuickSlotsInventory and not IsPlayerInteractingWithObject() then
				BUI.QuickSlots.Update(nil,9,frame)
				EVENT_MANAGER:RegisterForEvent('BUI_QS_Event', EVENT_CURSOR_PICKUP, OnCursorPickup)
				EVENT_MANAGER:RegisterForEvent('BUI_QS_Event', EVENT_CURSOR_DROPPED, function()DragData={}end)
			end
		end)
		ZO_PreHookHandler(frame,'OnHide',	function()
			BUI.QuickSlots.Update()
			EVENT_MANAGER:UnregisterForEvent('BUI_QS_Event', EVENT_CURSOR_PICKUP)
			EVENT_MANAGER:UnregisterForEvent('BUI_QS_Event', EVENT_CURSOR_DROPPED)
		end)
		end
	end
end