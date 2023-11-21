local version=1.4
if BUI and BUI.UI and BUI.UI.version>=version then return end
BUI=BUI or {}
BUI.UI={version=version}
local number=1
local base=BUI.name=="BanditsUserInterface"

local fonts={
	standard		="$(MEDIUM_FONT)",
	esobold			="$(BOLD_FONT)",
	antique			="EsoUI/Common/Fonts/ProseAntiquePSMT.otf",
	handwritten		="EsoUI/Common/Fonts/Handwritten_Bold.otf",
	trajan			="EsoUI/Common/Fonts/TrajanPro-Regular.otf",
	futura			="EsoUI/Common/Fonts/FuturaStd-CondensedLight.otf",
	futurabold		="EsoUI/Common/Fonts/FuturaStd-Condensed.otf",
	gamepad_medium	="EsoUI/Common/Fonts/FTN57.otf",
	gamepad_bold	="EsoUI/Common/Fonts/FTN87.otf",
}
--	/script BUI_PlayerFrame_HealthCurrent:SetFont(BUI.UI.Font("/EsoUI/Common/Fonts/FTN57.otf",17,true))

local function Chain(object)
	--Setup the metatable
	local T={}
	setmetatable(T, {__index=function(self, func)
		--Know when to stop chaining
		if func=="__END" then return object end
		--Otherwise, add the method to the parent object
		return function(self, ...)
			assert(object[func], func .. " missing in object")
			object[func](object, ...)
			return self
		end
	end})
	--Return the metatable
	return T
end

--Controls
function BUI.UI.TopLevelWindow(name, parent, dims, anchor, hidden)
	--Validate arguments
	if name==nil or name=="" then return end
	parent=(parent==nil) and GuiRoot or parent
	if #dims~=2 then return end
	if #anchor<4 then return end
	hidden=(hidden==nil) and false or hidden

	--Create the window
	local window=_G[name] or WINDOW_MANAGER:CreateTopLevelWindow(name)

	--Apply properties
	window:SetDimensions(dims[1], dims[2])
	window:ClearAnchors()
	window:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
	window:SetHidden(hidden)
	return window
end

function BUI.UI.Control(name, parent, dims, anchor, hidden)
	--Validate arguments
--	if name==nil or name=="" then return end
--	if #anchor<4 then return end
	local point=parent
	if anchor[5] then if type(anchor[5])=="function" then point=anchor[5]() else point=anchor[5] end end
	if not parent then parent=GuiRoot point=GuiRoot end
	if dims=="inherit" or #dims~=2 then dims={parent:GetWidth(), parent:GetHeight()} end
	hidden=hidden==nil and false or hidden

	--Create the control
	local control=_G[name] or WINDOW_MANAGER:CreateControl(name, parent, CT_CONTROL)

	--Apply properties
	control:SetDimensions(dims[1], dims[2])
	control:ClearAnchors()
	control:SetAnchor(anchor[1], point, anchor[2], anchor[3], anchor[4])
	control:SetParent(parent)
	control:SetHidden(hidden)
	return control
end

function BUI.UI.Backdrop(name, parent, dims, anchor, center, edge, tex, hidden)
	--Validate arguments
--	if (name==nil or name=="") then return end
	parent=(parent==nil) and GuiRoot or parent
	if (dims=="inherit" or #dims~=2) then dims={parent:GetWidth(), parent:GetHeight()} end
	if (#anchor~=4 and #anchor~=5) then return end
	center=(center~=nil and #center==4) and center or {0,0,0,0.4}
	edge=(edge~=nil and #edge==4) and edge or {0,0,0,1}
	hidden=(hidden==nil) and false or hidden

	--Create the backdrop
	local backdrop=_G[name]
	if (backdrop==nil) then backdrop=WINDOW_MANAGER:CreateControl(name, parent, CT_BACKDROP) end

	--Apply properties
	local backdrop=Chain(backdrop)
		:SetDimensions(dims[1], dims[2])
		:ClearAnchors()
		:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
		:SetCenterColor(center[1], center[2], center[3], center[4])
		:SetEdgeColor(edge[1], edge[2], edge[3], edge[4])
		:SetEdgeTexture("",8,2,2)
		:SetHidden(hidden)
		:SetCenterTexture(tex)
	.__END
	return backdrop
end

function BUI.UI.Label(name, parent, dims, anchor, font, color, align, text, hidden)
	--Validate arguments
--	if (name==nil or name=="") then return end
	parent=(parent==nil) and GuiRoot or parent
	if (#anchor~=4 and #anchor~=5) then return end
	font	=(font==nil) and "ZoFontGame" or font
	color	=(color~=nil and #color==4) and color or {1,1,1,1}
	align	=(align~=nil and #align==2) and align or {0,0}
	hidden=(hidden==nil) and false or hidden

	--Create the label
	local label=_G[name] or WINDOW_MANAGER:CreateControl(name, parent, CT_LABEL)

	if dims then label:SetDimensions(dims[1], dims[2]) end
	label:ClearAnchors()
	label:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
	label:SetFont(font)
	label:SetColor(unpack(color))
	label:SetHorizontalAlignment(align[1])
	label:SetVerticalAlignment(align[2])
	label:SetText(text)
	label:SetHidden(hidden)
	return label
end

function BUI.UI.Statusbar(name, parent, dims, anchor, color, tex, hidden)
	--Validate arguments
	if (name==nil or name=="") then return end
	parent=(parent==nil) and GuiRoot or parent
	if (dims=="inherit" or #dims~=2) then dims={parent:GetWidth(), parent:GetHeight()} end
	if (#anchor~=4 and #anchor~=5) then return end
	color=(color~=nil and #color==4) and color or {1, 1, 1, 1}
	hidden=(hidden==nil) and false or hidden
	--Create the status bar
	local bar=_G[name]
	if (bar==nil) then bar=WINDOW_MANAGER:CreateControl(name, parent, CT_STATUSBAR) end
	--Apply properties
	local bar=Chain(bar)
		:SetDimensions(dims[1], dims[2])
		:ClearAnchors()
		:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
		:SetColor(color[1], color[2], color[3], color[4])
		:SetHidden(hidden)
		:SetTexture(tex)
	.__END
	return bar
end

function BUI.UI.Texture(name, parent, dims, anchor, tex, hidden, layers, coords)
	--Validate arguments
--	if (name==nil or name=="") then return end
	if parent==nil then return end
	if (dims=="inherit" or #dims~=2) then dims={parent:GetWidth(), parent:GetHeight()} end
	if (#anchor~=4 and #anchor~=5) then return end
	if (tex==nil) then tex='/esoui/art/icons/icon_missing.dds' end
	hidden=(hidden==nil) and false or hidden

	--Create texture
	local texture=_G[name] or WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)

	--Apply properties
	local texture=Chain(texture)
		:SetDimensions(dims[1], dims[2])
		:ClearAnchors()
		:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
		:SetTexture(tex)
		:SetHidden(hidden)
	.__END

	if layers then
		local layer=layers
		if type(layers)=="table" then
			layer=layers[2]
			texture:SetDrawTier(layers[1])
		end
		texture:SetDrawLayer(layer)
	end
	if coords then texture:SetTextureCoords(unpack(coords)) end
	return texture
end

function BUI.UI.Line(name, parent, dims, anchor, color, thickness, hidden)
	--Validate arguments
	if not name then name="BUI_UnnamedFrame"..number number=number+1 end
	parent=parent or GuiRoot
	if (dims=="inherit" or #dims~=2) then dims={parent:GetWidth(), parent:GetHeight()} end
	if (#anchor~=4 and #anchor~=5) then return end
	color=(color~=nil and #color==4) and color or {1, 1, 1, 1}
	hidden=(hidden==nil) and false or hidden
	--Create the line
	local control=_G[name] or WINDOW_MANAGER:CreateControl(name, parent, CT_LINE)
	--Apply properties
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
	control:SetAnchor(BOTTOMRIGHT, #anchor==5 and anchor[5] or parent, anchor[2], anchor[3]+dims[1], anchor[4]+dims[2])
	control:SetColor(unpack(color))
	control:SetThickness(thickness)
	control:SetHidden(hidden)
	return control
end

function BUI.UI.Path(name, parent, anchors, color, thickness, hidden)
	--Validate arguments
	parent=(parent==nil) and GuiRoot or parent
	color=(color~=nil and #color==4) and color or {1, 1, 1, 1}
	hidden=(hidden==nil) and false or hidden
	--Create the line
	for i=1, #anchors-1 do
		name="BUI_UnnamedFrame"..number number=number+1
		local control=_G[name]
		if (control==nil) then control=WINDOW_MANAGER:CreateControl(name, parent, CT_LINE) end
		--Apply properties
		control:ClearAnchors()
		control:SetAnchor(TOPLEFT, anchors[i][1],anchors[i][2],anchors[i][3],anchors[i][4])
		control:SetAnchor(BOTTOMRIGHT, anchors[i+1][1],anchors[i+1][2],anchors[i+1][3],anchors[i+1][4])
		control:SetColor(unpack(color))
		control:SetThickness(thickness)
		control:SetHidden(hidden)
	end
end

function BUI.UI.Scroll(parent)
	--Validate arguments
	if parent==nil then return end
	local name=parent:GetName().."_ScrollContainer"
	local container=_G[name]
	if container==nil then container=WINDOW_MANAGER:CreateControlFromVirtual(name, parent, "ZO_ScrollContainer") end
	--Apply properties
	container:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
	container:SetAnchor(BOTTOMRIGHT, parent, BOTTOMRIGHT, 0, 0)
	parent.scroll=GetControl(container, "ScrollChild")
	parent.scroll:SetResizeToFitPadding(0, 0)
	return parent.scroll
end

--Interactive elements
function BUI.UI.Button(name, parent, dims, anchor, state, font, align, normal, pressed, mouseover, hidden)
	--Validate arguments
	if (name==nil or name=="") then return end
	parent=(parent==nil) and GuiRoot or parent
	if (dims=="inherit" or #dims~=2) then dims={parent:GetWidth(), parent:GetHeight()} end
	if (#anchor~=4 and #anchor~=5) then return end
	state=(state~=nil) and state or BSTATE_NORMAL
	font=(font==nil) and "ZoFontGame" or font
	align=(align~=nil and #align==2) and align or {1, 1}
	normal=(normal~=nil and #normal==4) and normal or {1, 1, 1, 1}
	pressed=(pressed~=nil and #pressed==4) and pressed or {1, 1, 1, 1}
	mouseover=(mouseover~=nil and #mouseover==4) and mouseover or {1, 1, 1, 1}
	hidden=(hidden==nil) and false or hidden

	--Create the button
	local button=_G[name]
	if (button==nil) then button=WINDOW_MANAGER:CreateControl(name, parent, CT_BUTTON) end

	--Apply properties
	local button=Chain(button)
		:SetDimensions(dims[1], dims[2])
		:ClearAnchors()
		:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
		:SetState(state)
		:SetFont(font)
		:SetNormalFontColor(normal[1], normal[2], normal[3], normal[4])
		:SetPressedFontColor(pressed[1], pressed[2], pressed[3], pressed[4])
		:SetMouseOverFontColor(mouseover[1], mouseover[2], mouseover[3], mouseover[4])
		:SetHorizontalAlignment(align[1])
		:SetVerticalAlignment(align[2])
		:SetHidden(hidden)
	.__END
	return button
end

function BUI.UI.SimpleButton(name, parent, dims, anchor, tex, hidden, func, tooltip)
	local coords,rotation
	--Validate arguments
	hidden=(hidden==nil) and false or hidden
--	if name==nil or name=="" then return end
	if parent==nil then return end
	if dims=="inherit" or #dims~=2 then dims={parent:GetWidth(), parent:GetHeight()} end
	if #anchor~=4 and #anchor~=5 then return end
	if tex==nil then tex="/esoui/art/icons/icon_missing.dds"
	elseif tex=="copy" then tex="/esoui/art/tutorial/gamepad/gp_inventory_icon_quickslot.dds"
	elseif tex=="paste" then tex="/esoui/art/tutorial/gamepad/gp_inventory_icon_quickslot.dds" rotation=math.pi
	elseif type(tex)=="number" then
		if tex==0 then
			coords={0,.125,0,1}
			rotation=math.pi
		else
			coords={.125*(tex-1),.125*tex,0,1}
		end
		tex="/BanditsUserInterface/textures/buttons.dds"
	end

	--Create button
	local button=_G[name] or WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)
	button:SetDimensions(dims[1], dims[2])
	button:ClearAnchors()
	button:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
	button:SetTexture(tex)
	button:SetHidden(hidden)
	button:SetColor(.6,.57,.46,1)
	button:SetDrawTier(DT_HIGH)
	button:SetDrawLayer(DL_CONTROLS)
	button:SetMouseEnabled(true)
	button:SetHandler("OnMouseEnter", function(self)
		self.over=true
		self:SetColor(.9,.9,.8,1)
		if tooltip then ZO_Tooltips_ShowTextTooltip(self, BOTTOM, (type(tooltip)=="string" and tooltip or tooltip())) end
	end)
	button:SetHandler("OnMouseExit", function(self)
		self.over=nil
		local color=self.disabled and {.1,.1,0,1} or {.6,.57,.46,1}
		self:SetColor(unpack(color))
		if tooltip then ZO_Tooltips_HideTextTooltip() end
	end)
	button:SetHandler("OnMouseDown", function(self, button, ctrl, alt, shift)PlaySound("Click") if func and self.disabled~=true then func(self, button, ctrl, alt, shift) end end)
	button.SetDisabled=function(self,value)self.disabled=value local color=self.disabled and {.1,.1,0,1} or {.6,.57,.46,1} self:SetColor(unpack(color)) end
	if coords then button:SetTextureCoords(unpack(coords)) end
	if rotation then button:SetTextureRotation(rotation) end

	return button
end

function BUI.UI.SlideBox(name, parent, dims, anchor, value, func, tooltip, tex, hidden)
	--Validate arguments
	hidden=(hidden==nil) and false or hidden
--	if name==nil or name=="" then return end
	if parent==nil then return end
	if dims=="inherit" or #dims~=2 then dims={parent:GetWidth(), parent:GetHeight()} end
	if #anchor~=4 and #anchor~=5 then return end
	tex=tex or "/esoui/art/icons/mapkey/mapkey_groupmember.dds"

	--Create checkbox
	local checkbox=_G[name] or WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)
	checkbox:SetDimensions(dims[1], dims[2])
	checkbox:ClearAnchors()
	checkbox:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
	checkbox:SetTexture(tex)
	checkbox:SetHidden(hidden)
	checkbox:SetColor(.6,.57,.46,1)
	checkbox:SetDrawTier(DT_HIGH)
	checkbox:SetDrawLayer(DL_CONTROLS)
	checkbox:SetMouseEnabled(true)
	checkbox:SetHandler("OnMouseEnter", function(self)
		self:SetColor(.9,.9,.8,1)
		if tooltip then ZO_Tooltips_ShowTextTooltip(self, BOTTOM, (type(tooltip)=="string" and tooltip or tooltip())) end
	end)
	checkbox:SetHandler("OnMouseExit", function(self)
		local color=self.disabled and {.1,.1,0,1} or {.6,.57,.46,1}
		self:SetColor(unpack(color))
		if tooltip then ZO_Tooltips_HideTextTooltip() end
	end)
	checkbox:SetHandler("OnMouseDown", function(self)PlaySound("Click") if not self.disabled then self.value=not self.value self:UpdateValue() func(self,self.value) end end)
	checkbox.SetDisabled=function(self,value)self.disabled=value local color=self.disabled and {.3,.3,.3,1} or {.6,.57,.46,1} self:SetColor(unpack(color)) end
	checkbox.UpdateValue=function(self) self:SetTextureRotation(self.value and 0 or math.pi) end
	checkbox.value=value
	checkbox:UpdateValue()
	return button
end

function BUI.UI.CheckBox(name, parent, dims, anchor, value, func, tooltip, hidden, tex)
	local coords,rotation
	local color_norm,color_on,color_off={.6,.57,.46,1},{.2,1,.2,1},{.3,.3,.2,1}
	--Validate arguments
	hidden=(hidden==nil) and false or hidden
--	if name==nil or name=="" then return end
	if parent==nil then return end
	if dims=="inherit" or #dims~=2 then dims={parent:GetWidth(), parent:GetHeight()} end
	if #anchor~=4 and #anchor~=5 then return end

	--Create checkbox
	local control=_G[name] or WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)
	control:SetDimensions(dims[1], dims[2])
	control:ClearAnchors()
	control:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
	control:SetTexture(tex or "/BanditsUserInterface/textures/buttons.dds")
	control:SetHidden(hidden)
	control:SetColor(unpack(color_norm))
	control:SetMouseEnabled(true)
	control:SetDrawTier(DT_HIGH)
	control:SetDrawLayer(DL_CONTROLS)
	control:SetHandler("OnMouseEnter", function(self)
--		d(type(self.value)..": "..tostring(self.value))
		if not self.disabled then
			self:SetColor(.9,.9,.8,1)
			if tooltip then ZO_Tooltips_ShowTextTooltip(self, BOTTOM, (type(tooltip)=="string" and tooltip or tooltip())) end
		end
	end)
	control:SetHandler("OnMouseExit", function(self)
		local color=self.disabled and color_off or tex and self.value and color_on or color_norm
		self:SetColor(unpack(color))
		if tooltip then ZO_Tooltips_HideTextTooltip() end
	end)
	control:SetHandler("OnMouseDown", function(self,button,ctrl,alt,shift)PlaySound("Click") if not self.disabled then
		self.value=not self.value
		self:UpdateValue() func(self.value,shift)
		end
	end)
	control.UpdateValue=function(self,value)
		if value~=nil then self.value=value end
		if tex then
			local color=self.value and color_on or color_norm
			self:SetColor(unpack(color))
		else
			if base then
				if self.value then self:SetTextureCoords(.625,.75,0,1) else self:SetTextureCoords(.5,.625,0,1) end
			else
				if self.value then self:SetTexture("esoui/art/cadwell/checkboxicon_checked.dds") else self:SetTexture("esoui/art/cadwell/checkboxicon_unchecked.dds") end
			end
		end
		self:UpdateParent()
	end
	control.SetDisabled=function(self,value)
		self.disabled=value
		local color=self.disabled and color_off or tex and self.value and color_on or color_norm
		self:SetColor(unpack(color))
		if value then self:UpdateValue(false) end
	end
	control.UpdateParent=function(self)
		if parent:GetType()==CT_LABEL then
			local color=self.disabled and {.3,.3,.3,1} or self.value and {.8,.8,.6,1} or {.5,.5,.4,1}
			parent:SetColor(unpack(color))
		end
	end
	control.value=value
	control:UpdateValue()
	return control
end

function BUI.UI.Slider(name, parent, dims, anchor, hidden, func, MinMaxStep, textedit, funcUpdate)
	local minValue=MinMaxStep[1] or 0
	local maxValue=MinMaxStep[2] or 100
	local Step=MinMaxStep[3] or 1
	local fs=18
	if textedit==nil then textedit=true end
	local edit_w=textedit and 50 or 0
	local control=BUI.UI.Control(name, parent, {dims[1]-edit_w-5,dims[2]}, anchor, hidden)
	control.slider=WINDOW_MANAGER:CreateControl(nil, control, CT_SLIDER)
	local slider=control.slider
	slider:SetAnchor(TOPLEFT)
	slider:SetHeight(14)
	slider:SetAnchor(TOPRIGHT)
	slider:SetMouseEnabled(true)
	slider:SetOrientation(ORIENTATION_HORIZONTAL)
	slider:SetValueStep(Step)
	--put nil for highlighted texture file path, and what look to be texture coords
	slider:SetThumbTexture("EsoUI\\Art\\Miscellaneous\\scrollbox_elevator.dds", "EsoUI\\Art\\Miscellaneous\\scrollbox_elevator_disabled.dds", nil, 8, 16)
	slider:SetMinMax(minValue, maxValue)
--	slider:SetHandler("OnMouseEnter", function() ZO_Options_OnMouseEnter(control) end)
--	slider:SetHandler("OnMouseExit", function() ZO_Options_OnMouseExit(control) end)
	--Backdop
	slider.bg=WINDOW_MANAGER:CreateControl(nil, slider, CT_BACKDROP)
	local bg=slider.bg
	bg:SetCenterColor(0, 0, 0)
	bg:SetAnchor(TOPLEFT, slider, TOPLEFT, 0, 4)
	bg:SetAnchor(BOTTOMRIGHT, slider, BOTTOMRIGHT, 0, -4)
	bg:SetEdgeTexture("EsoUI\\Art\\Tooltips\\UI-SliderBackdrop.dds", 32, 4) 
	--minText
	control.minText=WINDOW_MANAGER:CreateControl(nil, slider, CT_LABEL)
	control.minText:SetFont("ZoFontGameSmall")
	control.minText:SetAnchor(TOPLEFT, slider, BOTTOMLEFT,0,-7)
	control.minText:SetText(minValue)
	--maxText
	control.maxText=WINDOW_MANAGER:CreateControl(nil, slider, CT_LABEL)
	control.maxText:SetFont("ZoFontGameSmall")
	control.maxText:SetAnchor(TOPRIGHT, slider, BOTTOMRIGHT,0,-7)
	control.maxText:SetText(maxValue)
	--TextEdit
	local slidervalue
	if textedit then
		control.slidervalueBG=WINDOW_MANAGER:CreateControlFromVirtual(nil, control, "ZO_EditBackdrop")
		control.slidervalueBG:SetDimensions(edit_w, fs)
		control.slidervalueBG:SetAnchor(LEFT, control, RIGHT, 5, 0)
		control.slidervalue=WINDOW_MANAGER:CreateControlFromVirtual(nil, control.slidervalueBG, "ZO_DefaultEditForBackdrop")
		slidervalue=control.slidervalue
		slidervalue:ClearAnchors()
		slidervalue:SetAnchor(TOPLEFT, control.slidervalueBG, TOPLEFT, 3, 1)
		slidervalue:SetAnchor(BOTTOMRIGHT, control.slidervalueBG, BOTTOMRIGHT, -3, -1)
		slidervalue:SetTextType(TEXT_TYPE_NUMERIC)
		slidervalue:SetFont(BUI.UI.Font("standard",fs-2,true))
	end

	local isHandlingChange=false
	local function HandleValueChanged(value)
		if isHandlingChange then return end
		isHandlingChange=true slider:SetValue(value)
		if textedit then slidervalue:SetText(math.floor(value*10)/10) end
		if funcUpdate then funcUpdate(value) end
		isHandlingChange=false
	end

	if textedit then
--		slidervalue:SetHandler("OnEscape", function(self) HandleValueChanged(getFunc()) self:LoseFocus() end)
		slidervalue:SetHandler("OnEnter", function(self) self:LoseFocus() end)
		slidervalue:SetHandler("OnFocusLost", function(self) local value=tonumber(self:GetText()) control:UpdateValue(value) func(value) end)
		slidervalue:SetHandler("OnTextChanged", function(self)
			local input=self:GetText()
			if(#input>1 and not input:sub(-1):match("[0-9]")) then return end
			local value=tonumber(input)
			if value then HandleValueChanged(value) end
		end)
	end

	slider:SetHandler("OnValueChanged", function(self, value, eventReason)
		if eventReason==EVENT_REASON_SOFTWARE then return end
		HandleValueChanged(value)
	end)
	slider:SetHandler("OnSliderReleased", function(self, value)
		control:UpdateValue(value) func(value)
	end)

	control.UpdateValue=function(self,value)
		self.slider:SetValue(value)
		if textedit then self.slidervalue:SetText(math.floor(value*10)/10) end
		self.value=value
	end
	control.SetDisabled=function(self,value)
		self.disabled=value
		self.slider:SetMouseEnabled(not value)
		self.slidervalue:SetMouseEnabled(not value)
		self:SetAlpha(value and .5 or 1)
		self:UpdateParent()
	end
	control.UpdateParent=function(self)
		if parent:GetType()==CT_LABEL then
			local color=self.disabled and {.3,.3,.3,1} or {.8,.8,.6,1}
			parent:SetColor(unpack(color))
		end
	end
	return control
end

function BUI.UI.ComboBox(name, parent, dims, anchor, array, val, fun, hidden, scroll)
	--Validate arguments
	if (name==nil or name=="") then return end
	parent=(parent==nil) and GuiRoot or parent
	if (dims=="inherit" or #dims~=2) then dims={parent:GetWidth(), parent:GetHeight()} end
	if (#anchor~=4 and #anchor~=5) then return end
	hidden=(hidden==nil) and false or hidden
	--Create the control	
	local control=_G[name] or WINDOW_MANAGER:CreateControlFromVirtual(name, parent, "ZO_ComboBox")
	control:GetNamedChild("BGMungeOverlay"):SetHidden(true)
	--Apply properties
	control:SetDimensions(dims[1], dims[2])
	control:ClearAnchors()
	control:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
	control:SetHidden(hidden)
	control.m_comboBox:SetSortsItems(false)
	control.m_comboBox.m_dropdown:SetParent(control:GetOwningWindow()) --temp fix
	local fs=math.min(18,dims[2]-8)
	control.m_comboBox:SetFont(BUI.UI.Font("standard",fs,false))
	if scroll and #array>20 then
		control.m_comboBox:SetHeight(math.min(control.m_comboBox:GetEntryTemplateHeightWithSpacing()*#array-control.m_comboBox.m_spacing+ZO_SCROLLABLE_COMBO_BOX_LIST_PADDING_Y*2,400))
	end
	local largestEntryWidth=0
	--Set values
	control.UpdateValues=function(self,array,index)
		local comboBox=self.m_comboBox
		if array then
			comboBox:ClearItems()
			for i, v in pairs(array) do
				local entry=comboBox:CreateItemEntry(v, function()
					control.value=i
					fun(i,v)
					self:UpdateParent()
				end)
				entry.id=i
				local entryWidth=GetStringWidthScaled(ZoFontHeader3, v, 1, SPACE_INTERFACE)
				if entryWidth > largestEntryWidth then
					largestEntryWidth = entryWidth
				end
				comboBox:AddItem(entry, ZO_COMBOBOX_SUPRESS_UPDATE)
			end
		end
		comboBox:SelectItemByIndex(index, true)
		control.value=index
		self:UpdateParent()
	end
	control.SetDisabled=function(self,value)
		self.disabled=value
		self:SetMouseEnabled(not value)
		self:GetNamedChild("OpenDropdown"):SetMouseEnabled(not value)
		self:SetAlpha(value and .5 or 1)
		self:UpdateParent()
	end
	control.UpdateParent=function(self)
		if parent:GetType()==CT_LABEL then
			local color=self.disabled and {.3,.3,.3,1} or array[control.value]=="Disabled" and {.5,.5,.4,1} or {.8,.8,.6,1}
			parent:SetColor(unpack(color))
		end
	end

	local index=type(val)=="function" and val() or val
	if type(index)=="string" then
		control.array={}
		for i,value in pairs(array) do
			control.array[value]=i
		end
		index=control.array[index]
	end

	control:UpdateValues(array,index)
	control.m_comboBox.m_containerWidth=largestEntryWidth + 5
	if( control.m_comboBox.m_containerWidth < dims[1] ) then
		control.m_comboBox.m_containerWidth=dims[1]
	end

	return control
end

function BUI.UI.TextBox(name, parent, dims, anchor, chars, val, fun, hidden)
	--Validate arguments
--	if (name==nil or name=="") then return end
	parent=(parent==nil) and GuiRoot or parent
	if (dims=="inherit" or #dims~=2) then dims={parent:GetWidth(), parent:GetHeight()} end
	if (#anchor~=4 and #anchor~=5) then return end
	hidden=(hidden==nil) and false or hidden
	local text=val and (type(val)=="number" or type(val)=="string") and val or type(val)=="function" and val() or ""

	--Create the control
	local control=_G[name]
	if (control==nil) then
		control=WINDOW_MANAGER:CreateControl(name, parent, CT_EDITBOX)
		control.bg=WINDOW_MANAGER:CreateControlFromVirtual(nil, control, "ZO_EditBackdrop_Gamepad")
		control.eb=WINDOW_MANAGER:CreateControlFromVirtual(nil, control, "ZO_DefaultEditForBackdrop")
	end
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
	control:SetAnchor(BOTTOMRIGHT, #anchor==5 and anchor[5] or parent, anchor[2], anchor[3]+dims[1], anchor[4]+dims[2])
	control:SetHidden(hidden)
	control.bg:ClearAnchors()
	control.bg:SetAnchorFill()
	control.eb:ClearAnchors()
	control.eb:SetAnchorFill()
	control.eb:SetMaxInputChars(chars)
	if fun then control.eb:SetHandler("OnFocusLost", function(self) fun(self:GetText()) end) end
	control.SetDisabled=function(self,value)
		self.disabled=value
		self.eb:SetMouseEnabled(not value)
		self:SetAlpha(value and .5 or 1)
		self:UpdateParent()
	end
	control.UpdateParent=function(self)
		if parent:GetType()==CT_LABEL then
			local color=self.disabled and {.3,.3,.3,1} or {.8,.8,.6,1}
			parent:SetColor(unpack(color))
		end
	end

	control.eb:SetText(text)
	return control
end

function BUI.UI.ColorPicker(name, parent, dims, anchor, val, fun, hidden)
	--Validate arguments
	if parent==nil then return end
	if (#anchor~=4 and #anchor~=5) then return end
	hidden=(hidden==nil) and false or hidden

	local control=_G[name] or WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)
	control:SetDimensions(36,18)
	control:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3]+2, anchor[4]+2)
	control:SetTexture("")
	control:SetDrawLayer(2)

	control.border=WINDOW_MANAGER:CreateControl(nil, parent, CT_TEXTURE)
	control.border:SetTexture("/EsoUI/Art/ChatWindow/chatOptions_bgColSwatch_frame.dds")
	control.border:SetTextureCoords(0, .625, 0, .8125)
	control.border:SetDimensions(40, 22)
	control.border:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])

	local function ColorPickerCallback(r,g,b,a)
		control:UpdateValue(r,g,b,a)
		if fun then fun(r,g,b,a) end
	end

	control:SetMouseEnabled(true)
	control:SetHandler("OnMouseUp", function(self, button, upInside)
		if upInside then
			local r,g,b,a=val()
			if IsInGamepadPreferredMode() then
				COLOR_PICKER_GAMEPAD:Show(ColorPickerCallback,r,g,b,a,name)
			else
				COLOR_PICKER:Show(ColorPickerCallback,r,g,b,a,name)
			end
		end
	end)
	control.UpdateValue=function(self,r,g,b,a)
		if r and g and b then self.color={r,g,b,a or 1} end
		local color=self.disabled and {.2,.2,.2,1} or self.color
		self:SetColor(unpack(color))
	end
	control.SetDisabled=function(self,value)
		self.disabled=value
		self:SetMouseEnabled(not value)
		self.border:SetAlpha(value and .5 or 1)
		self:UpdateParent()
		self:UpdateValue()
	end
	control.UpdateParent=function(self)
		if parent.label and parent.label:GetType()==CT_LABEL then
			local color=self.disabled and {.3,.3,.3,1} or {.8,.8,.6,1}
			parent.label:SetColor(unpack(color))
		end
	end

	local r,g,b,a=val()
	control:UpdateValue(r,g,b,a)
	return control
end

--Functions
function BUI.UI.Font(font, size, shadow, outline)
	local font=fonts[font] or font
	local size=size or 14
	local shadow=shadow and '|soft-shadow-thick' or ''
	if outline then shadow='|thick-outline' end
	return font..'|'..size..shadow
end

function BUI.UI.Expires(control)	--Animation
	if control==nil or BUI.move then return end
	--Create animation
	if control.timeline==nil then
		local animation, timeline=CreateSimpleAnimation(ANIMATION_SCALE,control,0)
		animation:SetScaleValues(1, 1.3) animation:SetDuration(300)
		control.animation=animation control.timeline=timeline
		control.timeline:SetPlaybackType(ANIMATION_PLAYBACK_PING_PONG,1)
	end
	--Bail if an animation is already playing
	if control.timeline:IsPlaying() then return end
	--Otherwise perform the appropriate animation
	control.timeline:PlayFromStart()
end

function BUI.DisplayNumber(number,places)
	--Determine thousands and decimal format
	local thousands=BUI.language=="en" and "," or "."
	local decimal=BUI.language=="en" and "." or ","
	--If no places were passed assume zero
	places=places or 0
	local output=0
	--If the number is less than 1000
	if number<1000 then
		output=string.format("%."..places.."f",number)
		output=string.gsub(output,"%.",decimal)
	--Greater than 1000 with decimals
	elseif number>=1000 and places>0 then
		output=string.format("%."..places.."f",number)
		local left, right=zo_strsplit("%.",output), ""
		left=FormatIntegerWithDigitGrouping(left,thousands)
		output=left .. decimal .. right
	--Greater than 1000 no decimals
	else
		output=FormatIntegerWithDigitGrouping(number,thousands)
	end
	--Return the output
	return output
end

function BUI.ColorString(r,g,b,a)
	a=a or 1
	local rgb={math.min(r,1)*255*a, math.min(g,1)*255*a, math.min(b,1)*255*a}
	local hexstring=""
	for _,value in pairs(rgb) do
		local hex=""
		while value>0 do
			local index=math.fmod(value,16)+1
			value=math.floor(value/16)
			hex=string.sub("0123456789ABCDEF",index,index)..hex
		end
		if(string.len(hex)==0) then hex="00" elseif(string.len(hex)==1) then hex="0"..hex end
		hexstring=hexstring..hex
	end
	return hexstring
end

function BUI.GetIcon(texture,size)
	return string.format("|t%d:%d:%s|t",size,size,texture)
end

function BUI.TimeStamp(now)
	now=now or GetGameTimeMilliseconds()
	local _time=math.floor(now/1000)
	local _ms=tostring(math.floor((now-_time*1000)/10)).."0" for i=1,2 do if string.len(_ms)<3 then _ms="0".._ms end end
	local _timestamp=(_time<60 and _time or ZO_FormatTime(_time ,SI_TIME_FORMAT_TIMESTAMP))..".".._ms
	return _timestamp.."|cCCCCCC "
end

function BUI.CallLater(name,ms,func,opt1,opt2)
	if ms then
		EVENT_MANAGER:RegisterForUpdate("CallLater_"..name, ms,
		function()
			EVENT_MANAGER:UnregisterForUpdate("CallLater_"..name)
			func(opt1,opt2)
		end)
	else
		EVENT_MANAGER:UnregisterForUpdate("CallLater_"..name)
	end
end