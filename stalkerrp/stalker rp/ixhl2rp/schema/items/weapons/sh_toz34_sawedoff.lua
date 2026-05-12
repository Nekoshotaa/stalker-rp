йITEM.name = "Обрез ТОЗ-66"
ITEM.description = "Обрез двуствольного ружья ТОЗ-66 12 калибра. Короткий, убойный и простой. В Зоне — классика для ближнего боя и зачистки аномалий."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_bm16_w.mdl"
ITEM.class = "tfa_anomaly_toz34_sawedoff"
ITEM.weaponCategory = "secondary"
ITEM.price = 7500
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_bm16_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "left thigh",
							["Name"] = "toz34_sawedoff",
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
					["Arguments"] = "tfa_anomaly_toz34_sawedoff@@0",
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