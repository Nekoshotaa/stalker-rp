ITEM.name = "СВТ-40"
ITEM.description = "<Использует: 7.62х54 ММ>Самозарядная винтовка Токарева под 7.62×54R. Мощная и точная, но капризная к грязи и пыли Зоны. Ценится опытными сталкерами за дальнобойность на открытых пространствах."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_svt40_w.mdl"
ITEM.class = "tfa_anomaly_svt"
ITEM.weaponCategory = "primary"
ITEM.price = 26800
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_svt40_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "svt",
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
					["Arguments"] = "tfa_anomaly_svt@@0",
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