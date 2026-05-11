ITEM.name = "СВД"
ITEM.description = "Снайперская винтовка Драгунова 7.62×54R. Легенда Зоны — дальнобойная, точная и надёжная. Для тех, кто предпочитает работать на расстоянии."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_svd_w.mdl"
ITEM.class = "tfa_anomaly_svd"
ITEM.weaponCategory = "primary"
ITEM.price = 36800
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_svd_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "svd",
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
					["Arguments"] = "tfa_anomaly_svd@@0",
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