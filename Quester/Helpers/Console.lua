local _TOCNAME, Addon = ...


Console = {}

function Console:Print(msg)
	print('\124cffffff00' .. msg)
end


function Console:Debug(msg)
	if not Addon.Config._IsDebugMode then return end
	print('[' .. _TOCNAME .. ':DEBUG] ' .. msg)
end
