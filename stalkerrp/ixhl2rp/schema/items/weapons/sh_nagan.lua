ITEM.name = "Наган Старый"
ITEM.description = "<Использует: 7.62х38 Наган>Довоенный револьвер с длинным стволом. Надёжный, как старый друг. В Зоне такие ещё встречаются у ветеранов — патроны дешёвые, а отдача терпимая."
ITEM.model = "models/weapons/comrade/w_nagan.mdl"
ITEM.class = "tfa_st_nagan"
ITEM.weaponCategory = "secondary"
ITEM.price = 850
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
							["Model"] = "models/weapons/comrade/w_nagan.mdl",
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
					["Arguments"] = "tfa_st_nagan@@0",
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