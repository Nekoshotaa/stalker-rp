ITEM.name = "Форт-500"
ITEM.description= "<Использует: 12x70 Картечь>Украинское помповое гладкоствольное ружье 12-го калибра"
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_fort500500_w.mdl"
ITEM.class = "tfa_anomaly_fort500"
ITEM.weaponCategory = "primary"
ITEM.price = 5200
ITEM.width = 3
ITEM.height = 1




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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_fort500500_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "fort500",
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
					["Name"] = "weapon class find simple\"@@1\"",
					["Arguments"] = "tfa_anomaly_fort500@@0",
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