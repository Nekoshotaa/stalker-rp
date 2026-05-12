ITEM.name = "Обрез ТОЗ-34"
ITEM.description = "Обрез двуствольного ружья ТОЗ-34 12 калибра. Грубый, мощный и очень короткий. Идеален для тех, кто предпочитает один выстрел — один труп."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_bm16_w.mdl"
ITEM.class = "tfa_anomaly_bm16"
ITEM.weaponCategory = "secondary"
ITEM.price = 6200
ITEM.width = 3
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_bm16_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "left thigh",
							["Name"] = "bm16",
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
					["Arguments"] = "tfa_anomaly_bm16@@0",
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