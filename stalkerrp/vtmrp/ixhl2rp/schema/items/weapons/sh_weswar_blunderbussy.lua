ITEM.name = "Бландербасс"
ITEM.description = "Старое раструбное оружие, грубое и почти театральное. Вблизи оно превращает разговор в облако дыма, дроби и паники."
ITEM.model = "models/weapons/tfa_codww2/blunderbuss/w_blunderbuss.mdl"
ITEM.class = "weswar_blunderbussy"
ITEM.weaponCategory = "primary"
ITEM.price = 170
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
							["Model"] = "models/weapons/tfa_codww2/blunderbuss/w_blunderbuss.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "weswar_blunderbussy",
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
					["Arguments"] = "weswar_blunderbussy@@0",
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
