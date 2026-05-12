ITEM.name = "ТОЗ-34"
ITEM.description= "Широко распространённое и ничем особым не примечательное охотничье ружьё-«вертикалка». Применяется в основном новичками и на окраинах Зоны."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_toz34_w.mdl"
ITEM.class = "tfa_anomaly_toz34"
ITEM.weaponCategory = "primary"
ITEM.price = 3200
ITEM.width = 4
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_toz34_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "mossberg590",
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
					["Arguments"] = "tfa_anomaly_toz34@@0",
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