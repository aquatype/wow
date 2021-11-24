local _, Addon = ...


Addon.Config = {
	_IsDebugMode = true,
	_ForceReset = true,

	Buff = {
		size = 32,
		scale = 1,
		durationFont = 'Fonts\\ARIALN.TTF',
		durationFontSize = 12,
		countFont = 'Fonts\\ARIALN.TTF',
		countFontSize = 14,
		borderColor = {0.75, 0.75, 0.75},
		borderTexture = 'Interface\\AddOns\\Buffer\\Textures\\Border',
		shadowTexture = 'Interface\\AddOns\\Buffer\\Textures\\Shadow',
	},

	Debuff = {
		size = 32,
		scale = 1,
		durationFont = 'Fonts\\ARIALN.TTF',
		durationFontSize = 12,
		countFont = 'Fonts\\ARIALN.TTF',
		countFontSize = 14,
		borderColor = {0.75, 0.75, 0.75},
		borderTexture = 'Interface\\AddOns\\Buffer\\Textures\\ColorableBorder',
		shadowTexture = 'Interface\\AddOns\\Buffer\\Textures\\Shadow',
	},

	ConsolidatedBuff = {
		size = 32,
		scale = 1,
		durationFont = 'Fonts\\ARIALN.TTF',
		durationFontSize = 12,
		countFont = 'Fonts\\ARIALN.TTF',
		countFontSize = 14,
		borderColor = {0.9, 0.8, 0.5},
		borderTexture = 'Interface\\AddOns\\Buffer\\Textures\\ColorableBorder',
		shadowTexture = 'Interface\\AddOns\\Buffer\\Textures\\Shadow',
	},

	Enchant = {
		size = 32,
		scale = 1,
		durationFont = 'Fonts\\ARIALN.TTF',
		durationFontSize = 12,
		countFont = 'Fonts\\ARIALN.TTF',
		countFontSize = 14,
		borderColor = {0.9, 0.25, 0.9},
		borderTexture = 'Interface\\AddOns\\Buffer\\Textures\\ColorableBorder',
		shadowTexture = 'Interface\\AddOns\\Buffer\\Textures\\Shadow',
	},

	offsetX = 24,
	offsetY = 24,
	paddingX = 7,
	paddingY = 7,

	buffPerRow = 10,

	abbrDay = '|cffffffff%dd|r',
	abbrHour = '|cffffffff%dh|r',
	abbrMinute = '|cffffffff%dm|r',
	abbrSecond = '|cffffffff%ds|r',
}
