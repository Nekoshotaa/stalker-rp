ITEM.name = "ИЖ-43"
ITEM.description = "<Использует: 16х70 ММ>Двуствольный охотничий дробовик ИЖ-43. Старый, но проверенный временем. В Зоне его ценят за убойную силу в упор и простоту — два выстрела, и можно бежать дальше."
ITEM.model = "models/weapons/comrade/w_izh.mdl"
ITEM.class = "tfa_st_izh"
ITEM.weaponCategory = "primary"
ITEM.price = 3800
ITEM.width = 4
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
							["Model"] = "models/weapons/comrade/w_izh.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "izh",
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
					["Arguments"] = "tfa_st_izh@@0",
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