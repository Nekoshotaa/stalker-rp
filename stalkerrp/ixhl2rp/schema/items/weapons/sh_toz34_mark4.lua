ITEM.name = "ТОЗ-34 «Зубр»"
ITEM.description = "<Использует: 12х70 Картечь>Модифицированная двустволка ТОЗ-34 с оптическим прицелом и улучшенным затвором. Мощная и точная на средних дистанциях — настоящий «зубр» для сталкера в аномальных полях."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_toz34_mark4_w.mdl"
ITEM.class = "tfa_anomaly_toz34_mark4"
ITEM.weaponCategory = "primary"
ITEM.price = 27500
ITEM.width = 5
ITEM.height = 2
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
							["Angles"] = Angle(180, 0, 180),
							["Position"] = Vector(5.5, -4.8, 1.0),
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_toz34_mark4_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "toz34_mark4",
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
					["Arguments"] = "tfa_anomaly_toz34_mark4@@0",
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