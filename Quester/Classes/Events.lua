local _TOCNAME, Quester = ...


local EventFrame = CreateFrame('Frame')


function EventFrame.Initialize(self)
	Console:Debug('initializing EventFrame')

	self:SetScript('OnEvent', function(self, event, ...)
		if self[event] then
			Console:Debug('event fired: ' .. event)
			return self[event](self, ...)
		end
	end)
end


EventFrame:RegisterEvent('ADDON_LOADED')
EventFrame:RegisterEvent('PLAYER_LOGIN')
EventFrame:RegisterEvent('GOSSIP_SHOW')
EventFrame:RegisterEvent('QUEST_GREETING')
EventFrame:RegisterEvent('QUEST_DETAIL')
EventFrame:RegisterEvent('QUEST_PROGRESS')
EventFrame:RegisterEvent('QUEST_COMPLETE')
EventFrame:RegisterEvent('ZONE_CHANGED')


function EventFrame:ADDON_LOADED(Addon)
	if (Addon ~= _TOCNAME) then return end

	local _isResetRequested = false

	if not _DB then
		_isResetRequested = true

	elseif Quester.Config._ForceReset then
		_isResetRequested = true
	end

	if _isResetRequested then
		_DB = Quester.Presets

	else
		for entity, data in pairs(Quester.Presets) do
			if not _DB[entity] then
				_DB[entity] = data
			else
				for k, v in pairs(data) do
					if not _DB[entity][k] then
						_DB[entity][k] = v
					end
				end
			end
		end
	end
end


function EventFrame:PLAYER_LOGIN()
	self:UnregisterEvent('PLAYER_LOGIN')
	Quester:ListenSlashCommand()
	Quester:SetMacro()
end


function EventFrame:GOSSIP_SHOW()
	if IsModifierKeyDown() then return end

	local numAvailableQuests = GetNumGossipAvailableQuests()
	local numActiveQuests = GetNumGossipActiveQuests()

	-- iterate active quests first
	if numActiveQuests > 0 then
		local activeQuests = {GetGossipActiveQuests()}

		for i = 1, numActiveQuests do
			local idx = (i - 1) * 5 + 1
			local title = activeQuests[idx]
			local isComplete = activeQuests[idx + 3]

			if Quester.GetQuest(title) and isComplete then
				SelectGossipActiveQuest(i)
				break
			end
		end

	-- iterate available quests
	elseif numAvailableQuests > 0 then
		local availableQuests = {GetGossipAvailableQuests()}

		for i = 1, numAvailableQuests do
			local idx = (i - 1) * 7 + 1
			local title = availableQuests[idx]
	    -- local isTrivial = availableQuests[idx + 2]
	    -- local isRepeatable = availableQuests[idx + 4]

			if Quester:GetQuest(title) then
				SelectGossipAvailableQuest(i)
				break
			end
		end

	end
end


function EventFrame:QUEST_GREETING()
	if IsModifierKeyDown() then return end

	local numAvailableQuests = GetNumAvailableQuests()
	local numActiveQuests = GetNumActiveQuests()

	-- iterate active quests first
	if numActiveQuests > 0 then
		for i = 1, numActiveQuests do
			local title, isComplete = GetActiveTitle(i)

			if Quester.GetQuest(title) and isComplete then
				SelectActiveQuest(i)
				break
			end
		end

	-- iterate available quests
	elseif numAvailableQuests > 0 then
		for i = 1, numAvailableQuests do
			local title = GetAvailableTitle(i)

			if Quester:GetQuest(title) then
				SelectAvailableQuest(i)
				break
			end
		end

	end
end


function EventFrame:QUEST_DETAIL()
	if IsModifierKeyDown() then return end

	if not QuestFrame.QuesterButton then
		Interfaces:CreateQuesterButton()
	end

	if Quester:CheckCurrentQuest() then
		AcceptQuest()
	else  -- if ( QuestIsDaily() or QuestIsWeekly() )
		QuestFrame.QuesterButton:Show()

		QuestFrame:HookScript('OnHide', function()
			QuestFrame.QuesterButton:Hide()
			QuestFrame_OnHide()
		end)

	end
end


function EventFrame:QUEST_PROGRESS()
	if IsModifierKeyDown() then return end

	if Quester:CheckCurrentQuest() and IsQuestCompletable() then
		CompleteQuest()
	-- else CloseQuest()
	end
end


function EventFrame:QUEST_COMPLETE()
	if IsModifierKeyDown() then return end

	local quest = Quester:CheckCurrentQuest()

	if quest then
		if GetNumQuestChoices() > 0 and not quest[3] then
			Console.Print('받을 보상 아이템이 설정되어 있지 않습니다.')

			-- TODO: hook quest complete button
		else
			GetQuestReward(quest[3])
		end
	end
end


function EventFrame:ZONE_CHANGED()
	Quester:SetMacro()
end


-- export
Quester.Events = EventFrame
