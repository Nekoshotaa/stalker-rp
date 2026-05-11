ITEM.name = "CP-2 «Вереск»"
ITEM.description = "Компактный пистолет-пулемёт, сделанный на базе «Вереска». Лёгкий, быстрый, но капризный в Зоне — часто клинит от пыли и влаги. Идеально для ближнего боя и быстрого бегства."
ITEM.model = "models/weapons/comrade/w_sr2a.mdl"
ITEM.class = "tfa_st_veresk"
ITEM.weaponCategory = "secondary"
ITEM.price = 4400
ITEM.width = 2
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
							["Angles"] = Angle(45, 0, 180),
							["Position"] = Vector(5.5, -4.8, 1.0),
							["Model"] = "models/weapons/comrade/w_sr2a.mdl",
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
					["Arguments"] = "tfa_st_veresk@@0",
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