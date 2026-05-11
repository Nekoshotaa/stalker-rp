ITEM.name = "АПС"
ITEM.description = "Автоматический пистолет Стечкина 9×18 мм. Может вести огонь очередями. Редкий и мощный ствол — настоящий «пернач» для сталкера, который любит плотный огонь."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_aps.mdl"
ITEM.class = "tfa_anomaly_aps"
ITEM.weaponCategory = "secondary"
ITEM.price = 8900
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
							["Position"] = Vector(2.5, -4.8, 1.0),
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_aps.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "left thigh",
							["Name"] = "aps",
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
					["Arguments"] = "tfa_anomaly_aps@@0",
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