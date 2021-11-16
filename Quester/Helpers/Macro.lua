local _, Addon = ...


Macro = {}

function Macro:Edit(body, flag)
	-- prevent hooking while combat
	if InCombatLockdown() then
		Console:Debug('combat lockdown, halt')
		return
	end

	local macro = Addon.Config.Macro
	macro.Index = GetMacroIndexByName(macro.Name)

	-- no macro found
	if macro.Index == 0 then
		if flag then
			macro.Index = CreateMacro(macro.Name, macro.Icon, macro.DefaultBody, nil)
		else
			Console:Debug('no macro found, halt')
			return
		end
	end

	EditMacro(macro.Index, macro.Name, macro.Icon, body)
end
