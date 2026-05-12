ITEM.name = "МР-443 «Грач»"
ITEM.description = "Пистолет МР-443 под 9×19 мм. Современный российский ствол с высокой ёмкостью магазина. Надёжный спутник для ближнего боя в Зоне."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_grach_w.mdl"
ITEM.class = "tfa_anomaly_grach"
ITEM.weaponCategory = "secondary"
ITEM.price = 8100
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
							["Angles"] = Angle(45, 0, 0),
							["Position"] = Vector(4.5, 6.5, -3.2),
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_grach_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "left thigh",
							["Name"] = "grach",
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
					["Arguments"] = "tfa_anomaly_grach@@0",
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