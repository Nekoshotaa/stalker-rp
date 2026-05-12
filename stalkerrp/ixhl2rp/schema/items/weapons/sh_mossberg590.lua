ITEM.name = "Моссберг 590"
ITEM.description = "Надёжный помповый дробовик 12-го калибра. Простая, грубая и выносливая конструкция делает его отличным выбором для ближнего боя, зачистки помещений и вылазок в опасные районы."
ITEM.category = "Оружие"
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_mossberg590_w.mdl"
ITEM.class = "tfa_anomaly_mossberg590"
ITEM.weaponCategory = "primary"
ITEM.price = 8200
ITEM.width = 3
ITEM.height = 1
ITEM.isWeapon = true


ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
					[1] = {
						["children"] = {},
						["self"] = {
							["Angles"] = Angle(120, 0, 180),
							["Position"] = Vector(10.5, -1.8, 10.0),
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_mossberg590_w.mdl",
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
					["Arguments"] = "tfa_anomaly_mossberg590@@0",
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