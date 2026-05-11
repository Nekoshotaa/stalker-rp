ITEM.name = "АПБ"
ITEM.description = "<Использует: 9х18 ST>Стечкин с прикладом и глушителем. Редкая штука — автоматический пистолет, который можно носить скрытно. В Зоне им пользуются те, кто любит работать тихо."
ITEM.model = "models/weapons/comrade/w_apb.mdl"
ITEM.class = "tfa_st_apb"
ITEM.weaponCategory = "secondary"
ITEM.price = 2600
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
							["Model"] = "models/weapons/comrade/w_apb.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "left thigh",
							["Name"] = "fort",
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
					["Arguments"] = "tfa_st_apb@@0",
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