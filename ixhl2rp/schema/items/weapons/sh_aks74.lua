ITEM.name = "АКС-74"
ITEM.description = "Складной вариант АК-74 под 5.45×39 мм. Компактнее предшественника, удобен для вылазок в тесные помещения и аномальные зоны. Надёжность Калашникова никуда не делась."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_aks74_w.mdl"
ITEM.class = "tfa_anomaly_aks74"
ITEM.weaponCategory = "primary"
ITEM.price = 12200
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_aks74_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "aks74",
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
					["Arguments"] = "tfa_anomaly_aks74@@0",
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