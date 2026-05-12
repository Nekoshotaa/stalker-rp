ITEM.name = "ПП-19-01 «Витязь»"
ITEM.description = "Пистолет-пулемёт под 9×19 мм на базе АК. Высокая надёжность, удобство и совместимость с магазинами. Отличный сталкерский ПП для ближнего боя в любой части Зоны."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_vityaz_w.mdl"
ITEM.class = "tfa_anomaly_vityaz"
ITEM.weaponCategory = "primary"
ITEM.price = 15500
ITEM.width = 3
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_vityaz_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "vityaz",
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
					["Arguments"] = "tfa_anomaly_vityaz@@0",
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