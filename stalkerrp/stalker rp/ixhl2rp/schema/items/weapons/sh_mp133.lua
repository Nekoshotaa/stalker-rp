ITEM.name = "Помповое ружье МП-133"
ITEM.description= "Гладкоствольное многозарядное ружьё МР-133 с перезаряжанием цевьём, производства ИжМех. Надёжное и удобное оружие для охоты и самообороны. Уникально в своем роде благодаря наличию затворной задержки."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_mp133_w.mdl"
ITEM.class = "tfa_anomaly_mp133"
ITEM.weaponCategory = "primary"
ITEM.price = 10200
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_mp133_w.mdl",
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
					["Arguments"] = "tfa_anomaly_mp133@@0",
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