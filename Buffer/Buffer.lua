local _, Buffer = ...


local tinsert, tsort = table.insert, table.sort

local cfg = Buffer.Config

local _G = _G
local unpack = unpack

-- force abbr to english
_G.DAY_ONELETTER_ABBR = cfg.abbrDay
_G.HOUR_ONELETTER_ABBR = cfg.abbrHour
_G.MINUTE_ONELETTER_ABBR = cfg.abbrMinute
_G.SECOND_ONELETTER_ABBR = cfg.abbrSecond



local function UpdateFirstBuffButton(self)
	if not self or not self:IsShown() then return end

	self:ClearAllPoints()

	local i = BuffFrame.numEnchants
	if (i > 0) then
		self:SetPoint('TOPRIGHT', _G['TempEnchant'..i], 'TOPLEFT', -cfg.paddingX, 0)

	else
		self:SetPoint('TOPRIGHT', BuffFrame, 'TOPRIGHT', 0, 0)
		-- self:SetPoint('TOPRIGHT', TempEnchant1)
	end
end

local function CheckFirstButton()
	if (_G['BuffButton1']) then
		UpdateFirstBuffButton(_G['BuffButton1'])
	end
end



-- DEV: debug backdrops
-- local b = {
-- 	edgeFile = [[Interface\Buttons\WHITE8x8]],
-- 	edgeSize = 3,
-- }
-- BuffFrame:SetBackdrop(b)
-- BuffFrame:SetBackdropBorderColor(255, 0, 0)
--
-- TemporaryEnchantFrame:SetBackdrop(b)
-- TemporaryEnchantFrame:SetBackdropBorderColor(0, 255, 0)
--
-- BufferHighlightFrame:SetBackdrop(b)
-- BufferHighlightFrame:SetBackdropBorderColor(0, 0, 255)


hooksecurefunc('BuffFrame_UpdatePositions', function()
	-- if (CONSOLIDATED_BUFF_ROW_HEIGHT ~= 26) then
	-- 	CONSOLIDATED_BUFF_ROW_HEIGHT = 26
	-- end
end)


local function Hook_BuffFrame_UpdateAllBuffAnchors()
	local buff, previousBuff, aboveBuff, previousHighlightedBuff
	local normalBuffs, highlightedBuffs = {}, {}
	local numNormalBuffs, numHighlightedBuffs = 0, 0

	-- reposition buff frame
	-- QUESTION: rly? EVERY TIME?
	BuffFrame:ClearAllPoints()
	BuffFrame:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -cfg.offsetX, -cfg.offsetY)
	-- BuffFrame.SetPoint = function() end
	-- hooksecurefunc(BuffFrame, 'SetPoint', function(frame)
	-- 	print('hooked buffframe:setpoint triggered')
	-- 	BuffFrame:ClearAllPoints()
	-- 	BuffFrame:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -cfg.offsetX, -cfg.offsetY)
	-- end)


	-- first, iterate buffs for labelling
	for i = 1, BUFF_ACTUAL_DISPLAY do
		buffName, _, _, _, _, buffDuration = UnitAura('player', i)
		print(unpack(UnitAura('player', i)))
		print(i, buffName, buffDuration)

		if tContains(_DB.HighlightedBuffs, buffName) then
			tinsert(highlightedBuffs, {i, buffDuration})
			numHighlightedBuffs = numHighlightedBuffs + 1

		elseif string.find()

		else
			tinsert(normalBuffs, {i, buffDuration})
			numNormalBuffs = numNormalBuffs + 1
		end
	end

	-- sort buff groups by duration
	tsort(highlightedBuffs, function(a, b) return a[2] < b[2] end)
	tsort(normalBuffs, function(a, b) return a[2] < b[2] end)

	for index, i in pairs(highlightedBuffs) do
		buff = _G['BuffButton'..i[1]]
		buff:SetScale(1.25)
		buff:ClearAllPoints()

		if (index == 1) then
			buff:SetPoint('CENTER', BufferHighlightFrame, 'CENTER')
		else
			buff:SetPoint('BOTTOM', previousHighlightedBuff, 'TOP', 0, cfg.paddingY)
		end

		previousHighlightedBuff = buff
	end

	for index, i in pairs(normalBuffs) do
		buff = _G['BuffButton'..i[1]]
		buff:SetScale(1)
		buff:ClearAllPoints()

		-- if (buff.parent ~= BuffFrame) then
		-- 	buff:SetParent(BuffFrame)
		-- 	buff.parent = BuffFrame
		-- end

		-- add weapon enchants count
		totalIndex = index + BuffFrame.numEnchants

		-- if first buff button
		if (index == 1) then
			UpdateFirstBuffButton(buff)

		-- if new buff line needed
		elseif (index > 1 and mod(totalIndex, cfg.buffPerRow) == 1) then
			local anchor = (totalIndex == cfg.buffPerRow + 1) and TempEnchant1 or aboveBuff
			buff:SetPoint('TOP', anchor, 'BOTTOM', 0, -cfg.paddingY)

			aboveBuff = buff

		-- in all other case
		else
			buff:SetPoint('TOPRIGHT', previousBuff, 'TOPLEFT', -cfg.paddingX, 0)

		end

		previousBuff = buff

	end
end

-- move deduffs
local function Hook_DebuffButton_UpdateAnchors(self, index)
	local numNormalBuffs = BUFF_ACTUAL_DISPLAY + BuffFrame.numEnchants

	local rowSpacing
	local debuffSpace = cfg.Buff.size + cfg.paddingY
	local numRows = ceil(numNormalBuffs/cfg.buffPerRow)

	if (numRows and numRows > 1) then
		rowSpacing = -numRows * debuffSpace
	else
		rowSpacing = -debuffSpace
	end

	local buff = _G[self..index]
	buff:ClearAllPoints()

	if (index == 1) then
		buff:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, rowSpacing)
	elseif (index >= 2 and mod(index, cfg.buffPerRow) == 1) then
		buff:SetPoint('TOP', _G[self..(index-cfg.buffPerRow)], 'BOTTOM', 0, -cfg.paddingY)
	else
		buff:SetPoint('TOPRIGHT', _G[self..(index-1)], 'TOPLEFT', -cfg.paddingX, 0)
	end
end




function Buffer:MakeOver(name, borderColor)
	local button = _G[name]
	if not button or button._IsBeautified then return end

	print('new button detected, making up ', name)

	if name:match('Debuff') then
		_cfg = cfg.Debuff
	elseif name:match('TempEnchant') then
		_cfg = cfg.Enchant
	else
		_cfg = cfg.Buff
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
		print('no border on frame, creating:', name)
		border = button:CreateTexture('$parentOverlay', 'ARTWORK')
		border:SetParent(button)
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
	shadow:SetTexture(cfg.shadowTexture)
	shadow:SetVertexColor(0, 0, 0, 1)

	button._IsBeautified = true

	return button
end




local function Buffer_HookAuraButtonUpdate(self, index)
	Buffer:MakeOver(self .. index)
end



function Buffer.Initiate()

	-- create highlight frame
	local BufferHighlightFrame = CreateFrame('Frame', 'BufferHighlight', UIParent)
	BufferHighlightFrame:SetSize(30, 30)
	BufferHighlightFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 100)

	-- create consolidated frame
	local BufferConsolidatedFrame = CreateFrame('Frame', 'BufferConsolidated', UIParent)
	BufferConsolidatedFrame:SetSize(30, 30)
	BufferConsolidatedFrame:SetPoint('TOPRIGHT', BuffFrame, 'TOPRIGHT', 0, 0)

	-- beautify and reposition weapon enchant frame
	for i = 1, NUM_TEMP_ENCHANT_FRAMES do
		local name = 'TempEnchant' .. i
		local button = Buffer:MakeOver(name)

		if button then
			button:ClearAllPoints()

			if i == 1 then
				button:SetPoint('TOPRIGHT', BufferConsolidatedFrame, 'TOPRIGHT', 0, 0)  -- or `BuffFrame`
				-- button.SetPoint = function() end
			else
				button:SetPoint('TOPRIGHT', _G['TempEnchant1'], 'TOPLEFT', -cfg.paddingX, 0)
			end

			button:SetScript('OnShow', CheckFirstBuffButton)
			button:SetScript('OnHide', CheckFirstBuffButton)
	end
end



hooksecurefunc('BuffFrame_UpdateAllBuffAnchors', Hook_BuffFrame_UpdateAllBuffAnchors)
hooksecurefunc('DebuffButton_UpdateAnchors', Hook_DebuffButton_UpdateAnchors)
hooksecurefunc('AuraButton_Update', Buffer_HookAuraButtonUpdate)



Buffer:Initiate()
