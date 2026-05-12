ITEM.name = "Remington870"
ITEM.description= "Легендарное американское помповое ружьё 12-го калибра. Известное высокой надежностью, стальной ствольной коробкой и универсальностью."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_remington870_w.mdl"
ITEM.class = "tfa_anomaly_remington870"
ITEM.weaponCategory = "primary"
ITEM.price = 12400
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_remington870_w.mdl",
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
					["Arguments"] = "tfa_anomaly_remington870@@0",
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