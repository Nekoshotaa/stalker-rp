ITEM.name = "Винтовка Мосина"
ITEM.description = "<Использует: 7.62х54 ММ>Легендарная трёхлинейка под 7.62×54R. Простая, как лом, и такая же надёжная. В Зоне до сих пор используется — дальнобойная и мощная, хоть и устаревшая."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_mosin_w.mdl"
ITEM.class = "tfa_anomaly_mosin"
ITEM.weaponCategory = "primary"
ITEM.price = 10200
ITEM.width = 5
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
							["Angles"] = Angle(180, 0, 180),
							["Position"] = Vector(5.5, -4.8, 1.0),
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_mosin_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "mosin",
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
					["Arguments"] = "tfa_anomaly_mosin@@0",
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