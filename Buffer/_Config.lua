local _, Addon = ...


Addon.Config = {
	_IsDebugMode = true,
	_ForceReset = false,

	Buff = {
		size = 32,
		scale = 1,
		durationFont = 'Fonts\\ARIALN.TTF',
		durationFontSize = 12,
		countFont = 'Fonts\\ARIALN.TTF',
		countFontSize = 14,
		borderColor = {0.75, 0.75, 0.75},
		borderTexture = 'Interface\\AddOns\\Buffer\\Textures\\Border',
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
	},

	shadowTexture = 'Interface\\AddOns\\Buffer\\Textures\\Shadow',

	offsetX = 24,
	offsetY = 24,
	paddingX = 7,
	paddingY = 7,

	buffPerRow = 10,

	-- durationFont = 'Fonts\\ARIALN.TTF',
	-- countFont = 'Fonts\\ARIALN.TTF',

	abbrDay = '|cffffffff%dd|r',
	abbrHour = '|cffffffff%dh|r',
	abbrMinute = '|cffffffff%dm|r',
	abbrSecond = '|cffffffff%ds|r',
}
