local Localization={
	en={
		AUTHOR=string.format("%s: <<X:1>>", GetString(SI_ADDON_MANAGER_AUTHOR)),
		AUTHORLINE=string.format("%s", GetString(SI_ADD_ON_AUTHOR_LINE)),
		CREATOR="|c4B8BFEHoft|r",
		VERSIONBY="|c8000ffsecretrob|r",
		VERSION="Version: <<X:1>>",
		WEBSITE="Visit Website",
		PANEL_INFO_FONT="$(CHAT_FONT)|14|soft-shadow-thin",
	},
	it={
		VERSION="Versione: <<X:1>>",
		WEBSITE="Visita il Sitoweb",
	},
	fr={
		WEBSITE="Visiter le site Web",
	},
	de={
		WEBSITE="Webseite besuchen",
	},
	ru={
		VERSION="Версия: <<X:1>>",
		WEBSITE="Посетить сайт",
		PANEL_INFO_FONT="$(BUI_MEDIUM_FONT)|$(KB_14)|soft-shadow-thin"
	},
	es={
		VERSION="Versión: <<X:1>>",
		WEBSITE="Visita la página web",
	},
	jp={
		WEBSITE="ウェブサイトを見る",
	},
	zh={
		VERSION="版本: <<X:1>>",
		WEBSITE="访问网站",
		PANEL_INFO_FONT="EsoZh/fonts/univers57.otf|14|soft-shadow-thin",
	},
	pl={
		VERSION="Wersja: <<X:1>>",
		WEBSITE="Odwiedź stronę",
	},
	br={ -- provided by mlsevero
		VERSION="Versao: <<X:1>>",
		WEBSITE="Visite o Website",
	},
}
local lang=GetCVar("language.2") if not Localization[lang] then lang="en" end
local Loc={}
for param,value in pairs(Localization.en) do Loc[param]=Localization[lang][param] or value end
local Menu,Panels,PanelIndex,Options=nil,{},0,{}
local icon_m_size=24
local font_bold="$(BOLD_FONT)|$(KB_18)|soft-shadow-thick"
--Menu
local function PopulateMenu(control)
	local entryList=ZO_ScrollList_GetDataList(control)
	ZO_ScrollList_Clear(control)
	for i, data in ipairs(Panels) do
		data.sortIndex=i
		entryList[i]=ZO_ScrollList_CreateDataEntry(1, data)
	end
	ZO_ScrollList_Commit(control)
	ZO_ScrollList_SelectData(control, Panels[1], nil)
--	ScrollDataIntoView(control, selectedData)
end

local function CreateMenuList(name, parent)
	local list=WINDOW_MANAGER:CreateControlFromVirtual(name, parent, "ZO_ScrollList")

	local function listRow_OnMouseDown(self, button)
		if button==1 then
			local data=ZO_ScrollList_GetData(self)
			ZO_ScrollList_SelectData(list, data, self)
		end
	end

	local function listRow_Select(previouslySelectedData, selectedData, reselectingDuringRebuild)
		if not reselectingDuringRebuild then
			if previouslySelectedData then
				previouslySelectedData.panel:SetHidden(true)
			end
			if selectedData then
				selectedData.panel:SetHidden(false)
				PlaySound(SOUNDS.MENU_SUBCATEGORY_SELECTION)
			end
		end
	end

	local function listRow_Setup(control, data)
		control:SetText(data.name)
		control:SetSelected(not data.panel:IsHidden())
	end

	ZO_ScrollList_AddDataType(list, 1, "ZO_SelectableLabel", 28, listRow_Setup)
	ZO_ScrollList_EnableSelection(list, "ZO_ThinListHighlight", listRow_Select)

	local addonDataType=ZO_ScrollList_GetDataTypeTable(list, 1)
	local listRow_CreateRaw=addonDataType.pool.m_Factory

	local function listRow_Create(pool)
		local control=listRow_CreateRaw(pool)
		control:SetHandler("OnMouseDown", listRow_OnMouseDown)
		control:SetHeight(28)
		control:SetFont(font_bold)
		control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
		control:SetVerticalAlignment(TEXT_ALIGN_CENTER)
		control:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)
		return control
	end

	addonDataType.pool.m_Factory=listRow_Create

	return list
end

local function SettingsWindow_Init()
	local ui	=BUI.UI.TopLevelWindow("BUI_SettingsWindow", GuiRoot, {1010,914}, {LEFT,LEFT,245,0}, true)
	Menu=ui
	ui.bgLeft		=BUI.UI.Texture("$(parent)_bgLeft", ui, {1024,1024}, {TOPLEFT,TOPLEFT,0,0}, "EsoUI/Art/Miscellaneous/centerscreen_left.dds", false, DL_BACKGROUND)
	ui.bgLeft:SetExcludeFromResizeToFitExtents(true)
	ui.bgRight	=BUI.UI.Texture("$(parent)_bgRight", ui, {64,1024}, {TOPLEFT,TOPRIGHT,0,0,ui.bgLeft}, "EsoUI/Art/Miscellaneous/centerscreen_right.dds", false, DL_BACKGROUND)
	ui.bgRight:SetExcludeFromResizeToFitExtents(true)
	ui.underlayLeft	=BUI.UI.Texture("$(parent)_underlayLeft", ui, {256,1024}, {TOPLEFT,TOPLEFT,0,0}, "EsoUI/Art/Miscellaneous/centerscreen_indexArea_left.dds", false, DL_BACKGROUND)
	ui.underlayLeft:SetExcludeFromResizeToFitExtents(true)
	ui.underlayRight	=BUI.UI.Texture("$(parent)_underlayRight", ui, {128,1024}, {TOPLEFT,TOPRIGHT,0,0,ui.underlayLeft}, "EsoUI/Art/Miscellaneous/centerscreen_indexArea_right.dds", false, DL_BACKGROUND)
	ui.underlayRight:SetExcludeFromResizeToFitExtents(true)
	ui.logo	=BUI.UI.Texture("$(parent)_logo", ui, {100,100}, {TOPRIGHT,TOPRIGHT,-20,60}, "/BanditsUserInterface/textures/Bandits_logo.dds", false, DL_BACKGROUND)
	ui.title	=BUI.UI.Label("$(parent)_title", ui, {1010,30}, {TOPLEFT,TOPLEFT,65,70}, "ZoFontWinH1", nil, nil, BUI.DisplayName)
	ui.title:SetModifyTextType(MODIFY_TEXT_TYPE_UPPERCASE)
	ui.divider	=WINDOW_MANAGER:CreateControlFromVirtual("$(parent)_divider", ui, "ZO_Options_Divider")
	ui.divider:SetAnchor(TOPLEFT, nil, TOPLEFT, 65, 108)
	ui.menu	=BUI.UI.Control("$(parent)_menu", ui, {285,665}, {TOPLEFT,TOPLEFT,65,160})
	ui.menu=CreateMenuList("$(parent)AddonList", ui)
	ui.menu:SetAnchor(TOPLEFT, nil, TOPLEFT, 65, 160)
	ui.menu:SetDimensions(285, 665)
	ui.panel	=BUI.UI.Control("$(parent)_panel", ui, {645,675}, {TOPLEFT,TOPLEFT,365,120})
	--Website info
	ui.website=WINDOW_MANAGER:CreateControl("$(parent)Website", ui, CT_BUTTON)
	ui.website:SetClickSound("Click")
	ui.website:SetFont(Loc["PANEL_INFO_FONT"])
	ui.website:SetNormalFontColor(ZO_ColorDef:New("5959D5"):UnpackRGBA())
	ui.website:SetMouseOverFontColor(ZO_ColorDef:New("B8B8D3"):UnpackRGBA())
	ui.website:SetAnchor(TOPRIGHT, nil, TOPRIGHT, -125, 80)
	ui.website:SetText(Loc["WEBSITE"])
	ui.website:SetDimensions(ui.website:GetLabelControl():GetTextDimensions())
	ui.website:SetHandler("OnClicked",function(self)RequestOpenUnsafeURL(BUI.URL)end)
	--Author info
	local ver=tostring(BUI.Version) local l=string.len(ver) while l<5 do ver=ver.."0" l=string.len(ver) end
	ui.info	=BUI.UI.Label("$(parent)_info", ui, {645,14}, {TOPRIGHT,TOPLEFT,-10,0,ui.website}, Loc["PANEL_INFO_FONT"], nil, {2,0}, zo_strformat(Loc["AUTHOR"], Loc["CREATOR"]).."  "..zo_strformat(Loc["VERSION"], ver).."  "..zo_strformat(Loc["AUTHORLINE"], Loc["VERSIONBY"]))
	--Dialogs
	ui.default=WINDOW_MANAGER:CreateControlFromVirtual("$(parent)_default", ui, "ZO_DialogButton")
	ZO_KeybindButtonTemplate_Setup(ui.default, "OPTIONS_LOAD_DEFAULTS", HandleLoadDefaultsPressed, GetString(SI_OPTIONS_DEFAULTS))
	ui.default:SetAnchor(TOPLEFT, ui.panel, BOTTOMLEFT, 0, 2)
	ui.default:SetHidden(true)
	ui.apply=WINDOW_MANAGER:CreateControlFromVirtual("$(parent)_apply", ui, "ZO_DialogButton")
	ZO_KeybindButtonTemplate_Setup(ui.apply, "OPTIONS_APPLY_CHANGES", HandleReloadUIPressed, GetString(SI_ADDON_MANAGER_RELOAD))
	ui.apply:SetAnchor(TOPRIGHT, ui.panel, BOTTOMRIGHT, 0, 2)
	ui.apply:SetHidden(true)
	--Scene
	local scene=ZO_FadeSceneFragment:New(ui, true, 100)
	scene:RegisterCallback("StateChange", function(oldState, newState)
		if(newState==SCENE_FRAGMENT_SHOWN) then
			PushActionLayerByName("OptionsWindow")
--			InitKeybindActions()
--			OpenCurrentPanel()
		elseif(newState==SCENE_FRAGMENT_HIDDEN) then
--			CloseCurrentPanel()
			RemoveActionLayerByName("OptionsWindow")
--			ShowReloadDialogIfNeeded()
		end
	end)
	--Settings menu entry
	ui.id=KEYBOARD_OPTIONS.currentPanelId
	local data={
		id=ui.id,
		name=BUI.ShortName,
		longname=BUI.DisplayName,
		callback=function()
			SCENE_MANAGER:AddFragment(scene)
--			KEYBOARD_OPTIONS:ChangePanels(ui.id)
			if not ui.init then
				table.sort(Panels, function(a, b) return a.name<b.name end)
				PopulateMenu(ui.menu)
				ui.init=true
			end
		end,
		unselectedCallback=function()
			SCENE_MANAGER:RemoveFragment(scene)
			if SetCameraOptionsPreviewModeEnabled then
				SetCameraOptionsPreviewModeEnabled(false)
			end
		end
	}
	KEYBOARD_OPTIONS.currentPanelId=ui.id+1
	KEYBOARD_OPTIONS.panelNames[ui.id]=data.name
	ZO_GameMenu_AddSettingPanel(data)
	--Highlight
	ui.highlight=BUI.UI.Texture("$(parent)_highlight", ui, {(645-20)/3*2,26}, {TOPLEFT,TOPLEFT,0,0}, "esoui/art/miscellaneous/listitem_highlight.dds",true,nil,{0,1,0,.625})
end

function BUI.Menu.Open()
--	SCENE_MANAGER:SetInUIMode(false)
	local function SettingsMenu()
		local gameMenu=ZO_GameMenu_InGame.gameMenu.headerControls[GetString(SI_GAME_MENU_SETTINGS)]
		if gameMenu then
			local children=gameMenu:GetChildren()
			for i=1, (children and #children or 0) do
				local child=children[i]
				local data=child:GetData()
				if data and data.id==BUI_SettingsWindow.id then
					child:GetTree():SelectNode(child)
					break
				end
			end
		end
	end

	if SCENE_MANAGER:GetScene("gameMenuInGame"):GetState()==SCENE_SHOWN then
		SettingsMenu()
	else
		SCENE_MANAGER:CallWhen("gameMenuInGame", SCENE_SHOWN, SettingsMenu)
		SCENE_MANAGER:Show("gameMenuInGame")
	end
end

--Options
function BUI.Menu.UpdateOptions(panel)
	if Options[panel]==nil then return end
	local function Update(data)
		if data.frame.control then
			local value=data.getFunc and data.getFunc() or nil
			if data.frame.control.UpdateValue then
				data.frame.control:UpdateValue(value)
			elseif data.frame.control.UpdateValues then
--				d(data.frame.control:GetName().." value:"..tostring(value))
				data.frame.control:UpdateValues(nil,value)
			end
		elseif data.frame.color then
			local r,g,b,a=data.getFunc()
			data.frame.color:UpdateValue(r,g,b,a)
			if data.frame.color2 then
				local r2,g2,b2,a2=data.getFunc2()
				data.frame.color2:UpdateValue(r2,g2,b2,a2)
				if data.frame.SetColors then
					data.frame.SetColors(data.frame,data.getFunc,data.getFunc2)
				end
			end
		end
	end

	for i,data in pairs(Options[panel]) do
		if data.frame then
			Update(data)
		elseif data.controls then
			for _,sub_data in pairs(data.controls) do
				if sub_data.frame then Update(sub_data) end
			end
		end
	end
end

local function CheckDisabledOptions(panel)
	if not Options[panel] then return end
	local function Update(data)
		local disabled=data.disabled and data.disabled()
		if data.frame.color then
			data.frame.color:SetDisabled(disabled)
			if data.frame.color2 then
				data.frame.color2:SetDisabled(disabled)
				data.frame:SetColors(disabled and function() return .2,.2,.2,1 end or data.getFunc, disabled and function() return .2,.2,.2,1 end or data.getFunc2)
			end
		elseif data.frame.control then
			if data.frame.control.SetDisabled then
				data.frame.control:SetDisabled(disabled)
			end
		elseif data.frame.label then
			local color=disabled and {.3,.3,.3,1} or {.8,.8,.6,1}
			data.frame.label:SetColor(unpack(color))
		end
	end

	for i,data in pairs(Options[panel]) do
		if data.frame then
			Update(data)
		elseif data.controls then
			for _,sub_data in pairs(data.controls) do
				if sub_data.frame then Update(sub_data) end
			end
		end
	end
end

local function CreateOptions(parent,options,panel,submenu)
	local w,h=645-20,26
	local space=5
	local h1=h+space
	local anchor={TOPLEFT,TOPLEFT,0,0,parent}
	local highlight=BUI_SettingsWindow.highlight
	for i,data in pairs(options) do
		local frame
		local func=function(...) data.setFunc(...) CheckDisabledOptions(panel) end
		local name=data.name and (data.icon and zo_iconFormat(data.icon,icon_m_size,icon_m_size).." " or "")
			..(BUI.Localization[BUI.language] and BUI.Localization[BUI.language][data.name] or BUI.Localization.en[data.name] or data.name)	--"|cEE3333"..data.name.."|r")
		local tooltip=(data.tooltip and data.tooltip~="") and data.tooltip or data.name and (BUI.Localization[BUI.language] and BUI.Localization[BUI.language][data.name.."Desc"] or BUI.Localization.en[data.name.."Desc"]) or nil
		if data.type=="header" then
			frame=BUI.UI.Backdrop("$(parent)_Header"..i, parent, {w,h}, anchor, {.4,.4,.4,.3}, {0,0,0,0})
			frame.label=BUI.UI.Label("$(parent)_Label", frame, {w,h}, {TOPLEFT,TOPLEFT,0,0}, font_bold, {.8,.8,.6,1}, {1,1}, name)
			frame.label:SetModifyTextType(MODIFY_TEXT_TYPE_UPPERCASE)
			anchor={TOPLEFT,BOTTOMLEFT,0,space,frame}
		elseif data.type=="checkbox" then
			frame=BUI.UI.Control("$(parent)_Check"..i, parent, {w,h}, anchor)
			frame.label=BUI.UI.Label("$(parent)_Label", frame, {w/3*2,h}, {TOPLEFT,TOPLEFT,0,0}, font_bold, {.8,.8,.6,1}, {0,1}, name)
			frame.control=BUI.UI.CheckBox("$(parent)_CheckBox", frame.label, {h,h}, {TOPLEFT,TOPRIGHT,0,0}, data.getFunc(),func, tooltip)
			anchor={TOPLEFT,BOTTOMLEFT,0,space,frame}
		elseif data.type=="button" then
			frame=BUI.UI.Control("$(parent)_Frame"..i, parent, {w,h}, anchor)
			button=WINDOW_MANAGER:CreateControlFromVirtual(data.reference or "$(parent)_Button", frame, "ZO_DefaultButton")
			button:SetWidth(180, 28)
			button:SetFont(font_bold)
			button:SetText(name)
			button:SetAnchor(TOP,frame,TOP,0,0)
			button:SetClickSound("Click")
			button:SetHandler("OnClicked", data.func)
			anchor={TOPLEFT,BOTTOMLEFT,0,space,frame}
		elseif data.type=="dropdown" then
			frame=BUI.UI.Control("$(parent)_Drop"..i, parent, {w,h}, anchor)
			frame.label=BUI.UI.Label("$(parent)_Label", frame, {w/3*2,h}, {TOPLEFT,TOPLEFT,0,0}, font_bold, {.8,.8,.6,1}, {0,1}, name)
			frame.control=BUI.UI.ComboBox(data.reference or "$(parent)_DropBox", frame.label, {w/3,28}, {TOPLEFT,TOPRIGHT,0,0}, data.choices, data.getFunc(),func,false,data.scrollable)
			anchor={TOPLEFT,BOTTOMLEFT,0,space,frame}
		elseif data.type=="editbox" then
			frame=BUI.UI.Control("$(parent)_Edit"..i, parent, {w,h}, anchor)
			frame.label=BUI.UI.Label("$(parent)_Label", frame, {w/3*2,h}, {TOPLEFT,TOPLEFT,0,0}, font_bold, {.8,.8,.6,1}, {0,1}, name)
			frame.control=BUI.UI.TextBox("$(parent)_EditBox", frame.label, {w/3,h}, {TOPLEFT,TOPRIGHT,0,0}, 30, data.getFunc,func)
			anchor={TOPLEFT,BOTTOMLEFT,0,space,frame}
		elseif data.type=="colorpicker" then
			frame=BUI.UI.Control("$(parent)_Color"..i, parent, {w,h}, anchor)
			frame.label=BUI.UI.Label("$(parent)_Label", frame, {w/3*2,h}, {TOPLEFT,TOPLEFT,0,0}, font_bold, {.8,.8,.6,1}, {0,1}, name)
			frame.color=BUI.UI.ColorPicker("$(parent)_ColorPick", frame, {40,22}, {TOPLEFT,TOPLEFT,w/3*2,0}, data.getFunc,func)
			anchor={TOPLEFT,BOTTOMLEFT,0,space,frame}
		elseif data.type=="gradient" then
			frame=BUI.UI.Control("$(parent)_Color"..i, parent, {w,h}, anchor)
			frame.SetColors=function(self,func,func2)
				local r,g,b,a=func()
				local r2,g2,b2,a2=func2()
				self.bar:SetGradientColors(r,g,b,a or 1,r2,g2,b2,a2 or 1)
			end
			frame.label=BUI.UI.Label("$(parent)_Label", frame, {w/3*2,h}, {TOPLEFT,TOPLEFT,0,0}, font_bold, {.8,.8,.6,1}, {0,1}, name)
			frame.bar=BUI.UI.Statusbar("$(parent)_Bar", frame, {w/3-80,16}, {TOPLEFT,TOPLEFT,w/3*2+40,3})
			frame.color=BUI.UI.ColorPicker("$(parent)_ColorPick1", frame, {40,22}, {TOPLEFT,TOPLEFT,w/3*2,0}, data.getFunc,function(...) data.setFunc(...) frame.SetColors(frame,data.getFunc,data.getFunc2) end)
			frame.color2=BUI.UI.ColorPicker("$(parent)_ColorPick2", frame, {40,22}, {TOPLEFT,TOPLEFT,w-40,0}, data.getFunc2,function(...) data.setFunc2(...) frame.SetColors(frame,data.getFunc,data.getFunc2) end)
			frame:SetColors(data.getFunc,data.getFunc2)
			anchor={TOPLEFT,BOTTOMLEFT,0,space,frame}
		elseif data.type=="slider" then
			frame=BUI.UI.Control("$(parent)_Slider"..i, parent, {w,h}, anchor)
			frame.label=BUI.UI.Label("$(parent)_Label", frame, {w/3*2,h}, {TOPLEFT,TOPLEFT,0,0}, font_bold, {.8,.8,.6,1}, {0,1}, name)
			frame.control=BUI.UI.Slider("$(parent)_Slider", frame.label, {w/3,h}, {TOPLEFT,TOPRIGHT,0,0}, false,func, {data.min,data.max,data.step},true)
			frame.control:UpdateValue(data.getFunc())
			anchor={TOPLEFT,BOTTOMLEFT,0,space,frame}
		elseif data.type=="texture" then
			frame=BUI.UI.Control("$(parent)_Frame"..i, parent, {w,data.dimensions[2]}, anchor)
			frame.texture=BUI.UI.Texture("$(parent)_Texture", frame, data.dimensions, {TOP,TOP,0,0}, data.texture)
			anchor={TOPLEFT,BOTTOMLEFT,0,space,frame}
		elseif data.type=="submenu" then
			local frame=BUI.UI.Control("$(parent)_Sub"..i, parent, {w,h}, anchor)
			frame.header=BUI.UI.Backdrop("$(parent)_Bg", frame, {w,h}, {TOPLEFT,TOPLEFT,0,0}, {.4,.4,.4,.3}, {0,0,0,0})
			frame.label=BUI.UI.Label("$(parent)_Label", frame, {w,h}, {TOPLEFT,TOPLEFT,0,0}, font_bold, {.8,.8,.6,1}, {1,1}, name)
			frame.label:SetModifyTextType(MODIFY_TEXT_TYPE_UPPERCASE)
			frame.total=#data.controls
			frame.content=BUI.UI.Control("$(parent)_Content", frame, {w,h1*frame.total}, {TOPLEFT,TOPLEFT,0,h1}, true)
			frame.control=BUI.UI.SlideBox(nil, frame.header, {22,22}, {RIGHT,RIGHT,-20,0}, true, function(self,value)
				frame:SetHeight(value and h or h1*(frame.total+1))
				frame.content:SetHidden(value)
			end)
			CreateOptions(frame.content,data.controls,panel,true)
			anchor={TOPLEFT,BOTTOMLEFT,0,space,frame}
		end
		if frame then
			if frame.label and data.type~="header" and data.type~="submenu" then
				frame:SetMouseEnabled(true)
				frame:SetHandler("OnMouseEnter", function(self)
					highlight:ClearAnchors()
					highlight:SetAnchor(LEFT,self,LEFT,0,0)
					highlight:SetHidden(false)
					if tooltip then ZO_Tooltips_ShowTextTooltip(self,BOTTOM,tooltip) end
				end)
				frame:SetHandler("OnMouseExit", function() highlight:SetHidden(true) ZO_Tooltips_HideTextTooltip() end)
			end
			if data.warning then
				local warn=BUI.UI.Texture(nil, frame, {h,h}, {LEFT,LEFT,w/3*2-h,0}, "esoui/art/miscellaneous/eso_icon_warning.dds")
				warn:SetMouseEnabled(true)
				warn:SetHandler("OnMouseEnter", function(self)
					ZO_Tooltips_ShowTextTooltip(self,TOP,type(data.warning)=="string" and (BUI.Localization[BUI.language] and BUI.Localization[BUI.language][data.warning] or BUI.Localization.en[data.warning]) or BUI.Loc("ReloadUiWarn1"))
				end)
				warn:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
			end
			options[i].frame=frame
		end
	end
	if not submenu then CheckDisabledOptions(panel) end
end

function BUI.Menu.RegisterOptions(name, data)
	Options[name]=data
end

--Panel
local function TogglePanel(panel)
	if Menu.current and Menu.current~=panel then
		Menu.current:SetHidden(true)
	end
	Menu.current=panel

	--refresh visible rows to reflect panel IsHidden status
	ZO_ScrollList_RefreshVisible(Menu.menu)

	if not panel.init and Options[panel.name] then
		CreateOptions(panel.scroll,Options[panel.name],panel.name)
		panel.init=true
	end
end

function BUI.Menu.RegisterPanel(name, data)
	local panel=BUI.UI.Control(name, BUI_SettingsWindow.panel, {645,675}, {TOPLEFT,TOPLEFT,0,0}, true)
	panel.name=name
	panel.data=data

	panel.label=WINDOW_MANAGER:CreateControlFromVirtual(nil, panel, "ZO_Options_SectionTitleLabel")
	panel.label:SetAnchor(TOPLEFT, panel, TOPLEFT, 0, 4)
	panel.label:SetText(data.displayName or data.name)

	local container=WINDOW_MANAGER:CreateControlFromVirtual("$(parent)_Scroll", panel, "ZO_ScrollContainer")
	container:SetAnchor(TOPLEFT, panel, TOPLEFT, 0, 50)
	container:SetAnchor(BOTTOMRIGHT, panel, BOTTOMRIGHT, 0, 0)
	panel.scroll=GetControl(container, "ScrollChild")
	panel.scroll:SetResizeToFitPadding(0,0)

	panel:SetHandler("OnShow", function(self)
		TogglePanel(self)
		BUI.Menu.UpdateOptions(self.name)
		CheckDisabledOptions(self.name)
	end)
	table.insert(Panels, {panel=panel,name=data.name})
	return panel
end

function BUI.Menu.Init()
	SettingsWindow_Init()
	BUI.InternalMenu=true
end