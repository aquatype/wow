local _TOCNAME, Buffer = ...
local _ADDON_NAME, _, _ADDON_NOTES = GetAddOnInfo(_TOCNAME)


Interfaces = {}

function Interfaces.Initialize(self)
	Console:Debug('initializing Interfaces')
	Interfaces:CreateBufferFrame()
	Interfaces:CreateOptionsFrame()
end


function Interfaces:CreateBufferFrame()
	-- create highlight frame
	BufferHighlightFrame = CreateFrame('Frame', 'BufferHighlight', UIParent)
	BufferHighlightFrame:SetSize(30, 30)
	BufferHighlightFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 50)

	-- create consolidated frame
	BufferConsolidatedFrame = CreateFrame('Frame', 'BufferConsolidated', UIParent)
	BufferConsolidatedFrame:SetSize(30, 30)
	BufferConsolidatedFrame:SetPoint('TOPRIGHT', BuffFrame, 'TOPRIGHT', 0, 0)

	-- DEV: debug backdrops
	local b = {
		edgeFile = [[Interface\Buttons\WHITE8x8]],
		edgeSize = 3,
	}
	-- BuffFrame:SetBackdrop(b)
	-- BuffFrame:SetBackdropBorderColor(255, 0, 0)
	-- TemporaryEnchantFrame:SetBackdrop(b)
	-- TemporaryEnchantFrame:SetBackdropBorderColor(0, 255, 0)
	-- BufferHighlightFrame:SetBackdrop(b)
	-- BufferHighlightFrame:SetBackdropBorderColor(0, 0, 255)
	-- BufferConsolidatedFrame:SetBackdrop(b)
	-- BufferConsolidatedFrame:SetBackdropBorderColor(0, 255, 0)

	-- beautify and reposition weapon enchant frame
	for i = 1, NUM_TEMP_ENCHANT_FRAMES do
		local name = 'TempEnchant' .. i
		local button = Interfaces:BeautifyButton(name)

		if button then
			button:ClearAllPoints()

			if i == 1 then
				button:SetPoint('TOPRIGHT', BufferConsolidatedFrame, 'TOPRIGHT', 0, 0)  -- or `BuffFrame`
				-- button.SetPoint = function() end
			else
				button:SetPoint('TOPRIGHT', _G['TempEnchant1'], 'TOPLEFT', -Buffer.Config.paddingX, 0)
			end

			button:SetScript('OnShow', CheckFirstBuffButton)
			button:SetScript('OnHide', CheckFirstBuffButton)
		end
	end

end


function Interfaces:BeautifyButton(name)
	local button = _G[name]
	if not button or button._IsBeautified then return end

	if name:match('Debuff') then
		_cfg = Buffer.Config.Debuff
	elseif name:match('TempEnchant') then
		_cfg = Buffer.Config.Enchant
	else
		_cfg = Buffer.Config.Buff
	end

	-- set button size and scale
	button:SetSize(_cfg.size, _cfg.size)
	button:SetScale(_cfg.scale)

	-- set icon texture coords
	local icon = _G[name..'Icon']
	if icon then
		icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)
	end

	-- alter duration text position
	local duration = _G[name..'Duration']
	if duration then
		duration:ClearAllPoints()
		duration:SetPoint('BOTTOM', button, 'BOTTOM', 0, -2)
		duration:SetFont(_cfg.durationFont, _cfg.durationFontSize, 'THINOUTLINE')
		duration:SetShadowOffset(0, 0)
		duration:SetDrawLayer('OVERLAY')
	end

	-- alter stack count
	local count = _G[name..'Count']
	if count then
		count:ClearAllPoints()
		count:SetPoint('TOPRIGHT', button)
		count:SetFont(_cfg.countFont, _cfg.countFontSize, 'THINOUTLINE')
		count:SetShadowOffset(0, 0)
		count:SetDrawLayer('OVERLAY')
	end

	-- alter border
	local border = _G[name..'Border']
	if not border then
		border = button:CreateTexture('$parentOverlay', 'ARTWORK')
		border:SetParent(button)
		button.Border = border
	end

	border:ClearAllPoints()
	border:SetPoint('TOPRIGHT', button, 1, 1)
	border:SetPoint('BOTTOMLEFT', button, -1, -1)
	border:SetTexture(_cfg.borderTexture)
	border:SetTexCoord(0, 1, 0, 1)
	border:SetVertexColor(unpack(_cfg.borderColor))

	-- add shadow
	-- QUESTION: was '$parentBackground' on enchant frame .. any differences?
	local shadow = button:CreateTexture('$parentShadow', 'BACKGROUND')
	shadow:SetPoint('TOPRIGHT', border, 3.35, 3.35)
	shadow:SetPoint('BOTTOMLEFT', border, -3.35, -3.35)
	shadow:SetTexture(_cfg.shadowTexture)
	shadow:SetVertexColor(0, 0, 0, 1)

	button._IsBeautified = true

	return button
end


function Interfaces:SetConsolidatedButton(buff, flag)
	if flag == 1 then
		_cfg = Buffer.Config.ConsolidatedBuff
	else
		_cfg = Buffer.Config.Buff
	end

	buff.Border:SetTexture(_cfg.borderTexture)
	buff.Border:SetVertexColor(unpack(_cfg.borderColor))
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


-- export
Buffer.Interfaces = Interfaces





--
--
--
-- function Buffer_CreateOption()
--
-- 	local BufferOptDesc = BufferOption:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--
-- 	-- ### CONJURED FOODS
-- 	local BuffsDesc = BufferOption:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
-- 	local BuffsAddBtn = CreateFrame("Button", "BufferOptBuffsAddBtn", BufferOption, "UIPanelButtonTemplate")
-- 	local BuffsDeleteBtn = CreateFrame("Button", "BufferOptBuffsDeleteBtn", BufferOption, "UIPanelButtonTemplate")
--
-- 	BuffsDesc:SetPoint("TOPLEFT", BufferOptDesc, "BOTTOMLEFT", 0, -8)
-- 	BuffsDesc:SetText("하이라이트 표시할 버프")
-- 	BuffsDesc:SetTextColor(1, 0.82, 0)
--
-- 	if not BuffsDropDown then
-- 	   BuffsDropDown = CreateFrame("Button", "BuffsDropDown", BufferOption, "UIDropDownMenuTemplate")
-- 	end
--
-- 	BuffsDropDown:SetPoint("TOPLEFT", BuffsDesc, "BOTTOMLEFT", -22, 0)
--
-- 	local function BuffsOnClick(self)
-- 		selectedIndex = self:GetID() - 1
-- 		UIDropDownMenu_SetSelectedID(BuffsDropDown, self:GetID())
-- 		if selectedIndex == 0 then
-- 			BuffsDeleteBtn:Disable()
-- 		else
-- 			BuffsDeleteBtn:Enable()
-- 		end
-- 	end
--
-- 	local function BuffsInitialize(self, level)
-- 		local info = UIDropDownMenu_CreateInfo()
-- 		info.text = "버프 선택"
-- 		info.value = 0
-- 		info.func = BuffsOnClick
-- 		UIDropDownMenu_AddButton(info, level)
--
-- 		for i = 1, #BufferConfig.HighlightedBuffs do
-- 			info = UIDropDownMenu_CreateInfo()
-- 			info.text = BufferConfig.HighlightedBuffs[i]
-- 			info.value = i
-- 			info.func = BuffsOnClick
-- 			UIDropDownMenu_AddButton(info, level)
-- 		end
-- 	end
--
-- 	UIDropDownMenu_Initialize(BuffsDropDown, BuffsInitialize)
-- 	UIDropDownMenu_SetWidth(BuffsDropDown, 150);
-- 	UIDropDownMenu_SetButtonWidth(BuffsDropDown, 124)
-- 	UIDropDownMenu_SetSelectedID(BuffsDropDown, 1)
-- 	UIDropDownMenu_JustifyText(BuffsDropDown, "LEFT")
--
-- 	BuffsAddBtn:SetWidth(50)
-- 	BuffsAddBtn:SetHeight(25)
-- 	BuffsAddBtn:SetPoint("TOPLEFT", BuffsDropDown, "TOPRIGHT", 10, 0)
-- 	BuffsAddBtn:SetText("추가")
-- 	BuffsAddBtn:SetScript("OnEnter", function(self)
-- 		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
-- 		GameTooltip:SetText("새로운 버프를 목록에 추가합니다.")
-- 	end)
-- 	BuffsAddBtn:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
-- 	BuffsAddBtn:RegisterForClicks("AnyUp")
-- 	BuffsAddBtn:SetScript("OnClick", function()
-- 		StaticPopupDialogs["BUFFER_ADD_BUFF"] = {
-- 			text = "버프명을 입력해 주십시오.",
-- 			button1 = "추가",
-- 			button2 = "취소",
-- 			hasEditBox = true,
-- 			timeout = 0,
-- 			whileDead = true,
-- 			hideOnEscape = true,
-- 			enterClicksFirstButton = true,
--
-- 			OnShow = function (self, data)
-- 				self.button1:Disable()
-- 				self.editBox:SetText("")
-- 			end,
--
-- 			EditBoxOnTextChanged = function (self, data)
-- 				if self:GetText() ~= "" then
-- 					self:GetParent().button1:Enable()
-- 				else
-- 					self:GetParent().button1:Disable()
-- 				end
-- 			end,
--
-- 			OnAccept = function (self, data, data2)
-- 				local text = self.editBox:GetText()
-- 				table.insert(BufferConfig.HighlightedBuffs, text)
-- 			end,
-- 		}
-- 		StaticPopup_Show("BUFFER_ADD_BUFF", param)
-- 	end)
--
-- 	BuffsDeleteBtn:SetWidth(50)
-- 	BuffsDeleteBtn:SetHeight(25)
-- 	BuffsDeleteBtn:SetPoint("TOPLEFT", BuffsDropDown, "TOPRIGHT", 65, 0)
-- 	BuffsDeleteBtn:SetText("삭제")
-- 	BuffsDeleteBtn:SetScript("OnEnter", function(self)
-- 		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
-- 		GameTooltip:SetText("현재 선택된 버프를 목록에서 삭제합니다.")
-- 	end)
-- 	BuffsDeleteBtn:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
-- 	BuffsDeleteBtn:Disable()
-- 	BuffsDeleteBtn:RegisterForClicks("AnyUp")
-- 	BuffsDeleteBtn:SetScript("OnClick", function(self)
-- 		local selectedIndex = UIDropDownMenu_GetSelectedID(BuffsDropDown) - 1
-- 		disableSelections()
-- 		table.remove(BufferConfig.HighlightedBuffs, selectedIndex)
-- 		UIDropDownMenu_SetSelectedID(BuffsDropDown, 1)
-- 		self:Disable()
-- 	end)
-- end
--
-- BufferOption:Initialize()
