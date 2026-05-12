ITEM.name = "ОЦ-33 «Пернач»"
ITEM.description = "Пистолет-пулемёт ОЦ-33 под 9×18 мм. Высокая скорострельность и ёмкий магазин. В Зоне ценится за плотный огонь на коротких дистанциях и удобство ношения."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_oc33_w.mdl"
ITEM.class = "tfa_anomaly_oc33"
ITEM.weaponCategory = "secondary"
ITEM.price = 9500
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_oc33_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "left thigh",
							["Name"] = "oc33",
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
					["Arguments"] = "tfa_anomaly_oc33@@0",
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