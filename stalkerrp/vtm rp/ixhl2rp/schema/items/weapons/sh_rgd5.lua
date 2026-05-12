ITEM.name = "Граната РГД-5"
ITEM.description = "Осколочная граната РГД-5. Простая, эффективная и проверенная в Зоне. Отличный инструмент для зачистки аномалий, мутантов и укреплённых позиций."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_rgd5_w.mdl"
ITEM.class = "tfa_anomaly_rgd5"
ITEM.weaponCategory = "grenade"  -- отдельный слот, как ты просил
ITEM.price = 2800
ITEM.width = 1
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
							["Angles"] = Angle(90, 0, 0),
							["Position"] = Vector(4.5, 6.5, -3.2),
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_rgd5_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "right thigh",
							["Name"] = "rgd5",
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
					["Arguments"] = "tfa_anomaly_rgd5@@0",
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