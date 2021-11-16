local _, Quester = ...


function Quester:Initialize()
	Quester.Events:Initialize()
	Quester.Interfaces:Initialize()
end


function Quester:ListenSlashCommand()
	SlashCmdList['QUESTER'] = Quester.SlashCommandHandler
	SLASH_QUESTER1 = '/qst'
end


function Quester:CheckCurrentQuest()
	return Quester:GetQuest(GetTitleText(), GetQuestID())
end


function Quester:GetQuest(title, id)
	if _DB.Quests[title] then  -- and ( _DB.Quests[title][1] == id ) then
		return _DB.Quests[title]
	else
		return nil
	end
end


function Quester:SetQuest()
	-- NOTE: possible break on duplicated quest title
	_DB.Quests[GetTitleText()] = {
		GetQuestID(),  -- quest id
		true,  -- is autmated
		nil,  -- reward index
	}
end


function Quester:GetMacro(zone, subZone)
	if _DB.Macros[zone] then
		return _DB.Macros[zone][subZone] or _DB.Macros[zone][zone]
	else
		return Quester.Config.Macro.DefaultBody
	end
end


function Quester:SetMacro(zone, subZone)
	local macroBody = '#showtooltip' .. '\n' .. Quester:GetMacro(zone, subZone)
	Macro:Edit(macroBody, true)
end


function Quester:SlashCommandHandler(self, cmd)
	Quester:SetMacro()
	Console:Print('오늘 수행한 일일 퀘스트의 수: ' .. GetDailyQuestsCompleted() )
end


function Quester:ButtonOnClickHandler()
	Quester:SetQuest()
	AcceptQuest()
	Console:Print('퀘스트를 자동화합니다: ' .. GetTitleText() )
end


-- init
Quester:Initialize()
