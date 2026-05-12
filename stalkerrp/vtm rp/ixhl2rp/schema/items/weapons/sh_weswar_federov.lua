ITEM.name = "Автомат Фёдорова"
ITEM.description = "Слишком редкое и слишком позднее оружие для обычного Дикого Запада. Лучше использовать как уникальный трофей, анахроничную реликвию или вещь из странной хроники."
ITEM.model = "models/bf1/weapons/w_fedorov_avtomat.mdl"
ITEM.class = "weswar_federov"
ITEM.weaponCategory = "primary"
ITEM.price = 520
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
							["Model"] = "models/bf1/weapons/w_fedorov_avtomat.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "weswar_federov",
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
					["Arguments"] = "weswar_federov@@0",
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
