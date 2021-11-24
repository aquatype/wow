local _, Buffer = ...


Preset = {
	HighlightedBuffs = {
		-- raid buffs
		'격노의 토템',
		'피의 욕망',
		'영웅심',
		-- items
		'파괴',
		'전투의 북소리',
		'은빛 초승달의 축복',
		'검은무쇠단 파이프',
		'비전 에너지',
		-- tier sets
		'암흑불길',
		-- warlock
		'반발력',
		-- mage
		'정신 집중',
		'얼음 핏줄',
		'냉정',
		-- heals
		'재생',
		'피어나는 생명',
		'회복',
		'소생',
	},

	ConsolidatedBuffs = {
		'포만감',
		'* 영약',
		'* 비약',
		-- warlock
		'마의 갑옷',
		'불타는 소원', -- 18789
		'어둠의 손길', -- 18791
		-- mage
		'마법사 갑옷',
		'마법 증폭',
	}
}


-- export
Buffer.Presets = Preset
