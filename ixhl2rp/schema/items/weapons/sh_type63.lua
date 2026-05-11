ITEM.name = "Тип 63"
ITEM.description = "Китайская самозарядная винтовка под 7.62×39 мм. Надёжная копия СКС, неприхотливая в условиях Зоны. Хороший выбор для сталкера, которому нужна дальнобойность и простота обслуживания."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_type63_w.mdl"
ITEM.class = "tfa_anomaly_type63"
ITEM.weaponCategory = "primary"
ITEM.price = 15500
ITEM.width = 5
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_type63_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "type63",
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
					["Arguments"] = "tfa_anomaly_type63@@0",
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