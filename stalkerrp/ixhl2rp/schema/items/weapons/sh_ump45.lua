ITEM.name = "UMP-45"
ITEM.description = "Немецкий пистолет-пулемёт под .45 ACP. Мощный, с отличной эргономикой и низкой отдачей. В Зоне встречается реже, но высоко ценится за убойность на коротких дистанциях."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_ump45_w.mdl"
ITEM.class = "tfa_anomaly_ump45"
ITEM.weaponCategory = "primary"
ITEM.price = 17500
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_ump45_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "ump45",
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
					["Arguments"] = "tfa_anomaly_ump45@@0",
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