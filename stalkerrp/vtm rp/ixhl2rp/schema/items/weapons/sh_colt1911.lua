ITEM.name = "Colt M1911"
ITEM.description = "Классический американский пистолет .45 ACP. Мощный и надёжный. В Зоне — любимец тех, кто ценит убойность одного выстрела."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_colt1911_w.mdl"
ITEM.class = "tfa_anomaly_colt1911"
ITEM.weaponCategory = "secondary"
ITEM.price = 6800
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_colt1911_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "left thigh",
							["Name"] = "colt1911",
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
					["Arguments"] = "tfa_anomaly_colt1911@@0",
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