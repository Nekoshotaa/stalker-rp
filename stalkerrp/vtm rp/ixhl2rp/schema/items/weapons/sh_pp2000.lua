ITEM.name = "ПП-2000"
ITEM.description = "Современный пистолет-пулемёт под 9×19 мм. Компактный, с низкой отдачей и высокой скорострельностью. Отличный выбор для ближнего боя в тесных коридорах и аномальных убежищах."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_pp2000_w.mdl"
ITEM.class = "tfa_anomaly_pp2000"
ITEM.weaponCategory = "primary"
ITEM.price = 10900
ITEM.width = 2
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_pp2000_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "pp2000",
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
					["Arguments"] = "tfa_anomaly_pp2000@@0",
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