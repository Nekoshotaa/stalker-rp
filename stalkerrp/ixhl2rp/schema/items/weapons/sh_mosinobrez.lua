ITEM.name = "Обрез Мосина"
ITEM.description = "<Использует: 7.62х54 ST Картечь>Старая винтовка, обрезанная по самые гайки. Мощный калибр 7.62, но после выстрела ствол уходит вверх. В Зоне его ценят за убойность и дешевизну."
ITEM.model = "models/weapons/comrade/w_mosina.mdl"
ITEM.class = "tfa_st_mosina"
ITEM.weaponCategory = "secondary"
ITEM.price = 3500
ITEM.width = 3
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
							["Model"] = "models/weapons/comrade/w_mosina.mdl",
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
					["Arguments"] = "tfa_st_mosina@@0",
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