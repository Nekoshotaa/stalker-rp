ITEM.name = "ПП-91 «Кедр»"
ITEM.description = "<Использует: 9х18 ST>Маленький, но злой пистолет-пулемёт под 9x18. В Зоне его любят за компактность и скорострельность. Только не жди от него точности на дистанции — это оружие для тесных коридоров и внезапных стычек."
ITEM.model = "models/weapons/comrade/w_kedr.mdl"
ITEM.class = "tfa_st_kedr"
ITEM.weaponCategory = "secondary"
ITEM.price = 3200
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
							["Model"] = "models/weapons/comrade/w_kedr.mdl",
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
					["Arguments"] = "tfa_st_kedr@@0",
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