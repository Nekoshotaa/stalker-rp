ITEM.name = "АКС-74У"
ITEM.description = "Укороченный автомат Калашникова 5.45×39 мм. Идеален для ближнего боя и зачистки помещений в Зоне. Компактный, лёгкий, но с отдачей — настоящий сталкерский «коротыш»."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_ak74u.mdl"
ITEM.class = "tfa_anomaly_ak74u"
ITEM.weaponCategory = "primary"
ITEM.price = 10800
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_ak74u.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "aks74u",
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
					["Arguments"] = "tfa_anomaly_ak74u@@0",
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