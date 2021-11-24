local _, Buffer = ...


local cfg = Buffer.Config
-- local _G = _G
-- local unpack = unpack


function Buffer:Initialize()
	Buffer.Events:Initialize()
	Buffer.Interfaces:Initialize()
end


function Buffer:ListenSlashCommand()
	SlashCmdList['BUFFER'] = Buffer.SlashCommandHandler
	SLASH_BUFFER1 = '/buffer'
end

-- force abbr to english
_G.DAY_ONELETTER_ABBR = cfg.abbrDay
_G.HOUR_ONELETTER_ABBR = cfg.abbrHour
_G.MINUTE_ONELETTER_ABBR = cfg.abbrMinute
_G.SECOND_ONELETTER_ABBR = cfg.abbrSecond



function Buffer:SlashCommandHandler(self, cmd)
	Console:Print('이야오!')
end


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
		buffName, _, _, _, _, buffDuration, _, _, _, buffId = UnitAura('player', i)

		if tContains(_BufferDB.HighlightedBuffs, buffName) then
			table.insert(highlightedBuffs, {i, buffDuration})
			numHighlightedBuffs = numHighlightedBuffs + 1

		else
			local isConsolidated = tContains(_BufferDB.ConsolidatedBuffs, buffName) and 1 or 0
			table.insert(normalBuffs, {i, buffDuration, isConsolidated})
			numNormalBuffs = numNormalBuffs + 1
		end
	end

	-- sort buff groups by duration
	table.sort(highlightedBuffs, function(a, b) return a[2] < b[2] end)
	table.sort(normalBuffs, function(a, b) return a[2] < b[2] end)
	-- table.sort(normalBuffs, function(a, b)
	-- 	if a[3] < b[3] then
	-- 		return a[2] > b[2]
	-- 	else
	-- 		return a[2] < b[2]
	-- 	end
	-- end)

	for index, i in pairs(highlightedBuffs) do
		buff = _G['BuffButton'..i[1]]
		buff:SetScale(1.1)
		buff:ClearAllPoints()

		if (index == 1) then
			buff:SetPoint('CENTER', BufferHighlightFrame, 'CENTER')
		else
			buff:SetPoint('BOTTOM', previousHighlightedBuff, 'TOP', 0, cfg.paddingY)
		end

		previousHighlightedBuff = buff
	end

	for index, buffInfo in pairs(normalBuffs) do
		buff = _G['BuffButton'..buffInfo[1]]
		buff:SetScale(1)
		buff:ClearAllPoints()

		-- make consolidated
		Buffer.Interfaces:SetConsolidatedButton(buff, buffInfo[3])

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



local function Buffer_HookAuraButtonUpdate(self, index)
	Buffer.Interfaces:BeautifyButton(self .. index)
end




hooksecurefunc('BuffFrame_UpdateAllBuffAnchors', Hook_BuffFrame_UpdateAllBuffAnchors)
hooksecurefunc('DebuffButton_UpdateAnchors', Hook_DebuffButton_UpdateAnchors)
hooksecurefunc('AuraButton_Update', Buffer_HookAuraButtonUpdate)



Buffer:Initialize()
