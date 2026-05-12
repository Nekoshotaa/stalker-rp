ITEM.name = "СКС-45"
ITEM.description = "<Использует: 7.62х39 ММ>Самозарядный карабин Симонова под 7.62×39 мм. Простой, надёжный и лёгкий. Классика Зоны — идеально подходит для средних дистанций и вылазок в аномальные поля."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_svt40_w.mdl"
ITEM.class = "tfa_anomaly_sks"
ITEM.weaponCategory = "primary"
ITEM.price = 13300
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_svt40_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "sks",
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
					["Arguments"] = "tfa_anomaly_sks@@0",
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