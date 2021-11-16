local _TOCNAME, Quester = ...
local _ADDON_NAME, _, _ADDON_NOTES = GetAddOnInfo(_TOCNAME)


Interfaces = {}

function Interfaces.Initialize(self)
	Console:Debug('initializing Interfaces')
	Interfaces:CreateOptionsFrame()
end


function Interfaces:CreateOptionsFrame()
	local OptionsFrame = CreateFrame('Frame', nil, UIParent)
	OptionsFrame.name = _ADDON_NAME

	local Title = OptionsFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	Title:SetPoint('TOPLEFT', 16, -16)
	Title:SetText(_ADDON_NAME)

	local Description = OptionsFrame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	Description:SetHeight(35)
	Description:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 0, -8)
	Description:SetPoint('RIGHT', OptionsFrame, -8, 0)
	Description:SetNonSpaceWrap(true)
	Description:SetJustifyH('LEFT')
	Description:SetJustifyV('TOP')
	Description:SetText(_ADDON_NOTES)

	-- append
	InterfaceOptions_AddCategory(OptionsFrame)
end


function Interfaces:CreateQuesterButton()
	local QuesterButton = CreateFrame('Button', nil, QuestFrame, 'UIPanelButtonTemplate')
	QuesterButton:SetWidth(77)
	QuesterButton:SetHeight(22)
	QuesterButton:SetPoint('TOPLEFT', QuestFrameAcceptButton, 'TOPRIGHT', 0, 0)
	QuesterButton:SetText('자동화')
	QuesterButton:RegisterForClicks('AnyUp')
	QuesterButton:SetScript('OnClick', Quester.ButtonOnClickHandler)

	QuestFrame.QuesterButton = QuesterButton
end

-- export
Quester.Interfaces = Interfaces
