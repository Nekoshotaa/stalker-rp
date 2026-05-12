ITEM.name = "Обрез ТОЗ-106"
ITEM.description = "<Использует: 20x70 ММ>Укороченная версия 106-го. Лёгкий, складной, почти не занимает места в рюкзаке. Стреляет картечью — идеально, когда надо быстро зачистить комнату или аномалию."
ITEM.model = "models/weapons/comrade/w_toz106a.mdl"
ITEM.class = "tfa_st_toz106a"
ITEM.weaponCategory = "secondary"
ITEM.price = 1950
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
							["Model"] = "models/weapons/comrade/w_toz106a.mdl",
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
					["Arguments"] = "tfa_st_toz106a@@0",
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