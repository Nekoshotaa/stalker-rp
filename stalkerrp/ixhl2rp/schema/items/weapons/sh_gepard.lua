ITEM.name = "ПП «Гепард»"
ITEM.description = "<Использует: 9x19 ST>Редкий зверь — пистолет-пулемёт с высокой скорострельностью. Говорят, его делали на заказ для военных ещё до Второй Катастрофы. В руках опытного сталкера превращается в мясорубку на короткой дистанции."
ITEM.model = "models/weapons/comrade/w_gepard.mdl"
ITEM.class = "tfa_st_gepard"
ITEM.weaponCategory = "secondary"
ITEM.price = 2200
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
							["Angles"] = Angle(45, 0, 180),
							["Position"] = Vector(5.5, -4.8, 1.0),
							["Model"] = "models/weapons/comrade/w_gepard.mdl",
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
					["Arguments"] = "tfa_st_gepard@@0",
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