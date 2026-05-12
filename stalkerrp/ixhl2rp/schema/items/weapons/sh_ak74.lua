ITEM.name = "АК-74"
ITEM.description = "Автомат Калашникова 5.45×39 мм. Классика Зоны — надёжный, неприхотливый и проверенный временем. Отличный выбор для сталкера, который хочет выжить в аномалиях и перестрелках на средних дистанциях."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_ak74.mdl"
ITEM.class = "tfa_anomaly_ak74"
ITEM.weaponCategory = "primary"
ITEM.price = 9500
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_ak74.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "ak74",
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
					["Arguments"] = "tfa_anomaly_ak74@@0",
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