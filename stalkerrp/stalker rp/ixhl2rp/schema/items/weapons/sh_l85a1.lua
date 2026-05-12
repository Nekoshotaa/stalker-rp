ITEM.name = "L85A1"
ITEM.description = "Британская штурмовая винтовка 5.56×45 мм. Компактная, с встроенной оптикой и высокой точностью. В Зоне встречается редко, но ценится сталкерами за удобство и надёжность в сырой среде."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_l85_w.mdl"
ITEM.class = "tfa_anomaly_l85"
ITEM.weaponCategory = "primary"
ITEM.price = 13800
ITEM.width = 4
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_l85_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "l85a1",
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
					["Arguments"] = "tfa_anomaly_l85@@0",
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