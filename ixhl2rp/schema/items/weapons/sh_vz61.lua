ITEM.name = "Skorpion vz.61"
ITEM.description = "Чешский пистолет-пулемёт под .32 ACP. Компактный, с высокой скорострельностью. Идеален для скрытных операций и зачистки помещений в Зоне."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_vz61_w.mdl"
ITEM.class = "tfa_anomaly_vz61"
ITEM.weaponCategory = "secondary"
ITEM.price = 9400
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
							["Angles"] = Angle(45, 0, 0),
							["Position"] = Vector(4.5, 6.5, -3.2),
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_vz61_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "left thigh",
							["Name"] = "vz61",
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
					["Arguments"] = "tfa_anomaly_vz61@@0",
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