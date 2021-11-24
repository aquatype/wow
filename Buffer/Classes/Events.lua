local _TOCNAME, Buffer = ...


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


function EventFrame:ADDON_LOADED(Addon)
	if (Addon ~= _TOCNAME) then return end

	local _isResetRequested = false

	if not _DB then
		Console:Debug('DB is empty')
		_isResetRequested = true
	elseif Buffer.Config._ForceReset then
		Console:Debug('DB exists but force-flag detected')
		_isResetRequested = true
	end

	if _isResetRequested then
		Console:Debug('resetting DB')
		_DB = Buffer.Presets
	else
		Console:Debug('updating DB')
		for entity, data in pairs(Buffer.Presets) do
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
	Buffer:ListenSlashCommand()
end


-- export
Buffer.Events = EventFrame
