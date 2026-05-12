ITEM.name = "Самопал"
ITEM.description = "<Использует: Пульки для Самопала>Оружие изготовлено из деревянной рукоятки и куска металлической трубки диаметром 15 мм. Сбоку приделан механизм воспламенения, состоящий из батарейки и нескольких конденсаторов, дающих искру. Эта ненадежная и небезопасная штуковина приспособлена для стрельбы самодельными пороховыми патронами, в которых в качестве пуль используются подшипники. Из-за слабой баллистики пули точность низкая."
ITEM.model = "models/weapons/comrade/w_samopal.mdl"
ITEM.class = "tfa_st_samopal"
ITEM.weaponCategory = "secondary"
ITEM.price = 750
ITEM.width = 2
ITEM.height = 1
ITEM.isWeapon = true
ITEM.category = "Оружие"

ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
					[1] = {
						["children"] = {},
						["self"] = {
							["Angles"] = Angle(45, 0, 180),
							["Position"] = Vector(5.5, -4.8, 1.0),
							["Model"] = "models/weapons/comrade/w_samopal.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "left thigh",
							["Name"] = "fort",
						},
					},
				},
				["self"] = {
					["AffectChildrenOnly"] = true,
					["ClassName"] = "event",
					["UniqueID"] = "1234641242",
					["Event"] = "weapon_class",
					["Invert"] = false,
					["EditorExpand"] = true,
					["Name"] = "weapon class find simple",
					["Arguments"] = "tfa_st_samopal@@0",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "1442432348",
			["EditorExpand"] = true,
		},
	},
}