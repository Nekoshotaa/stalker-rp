ITEM.name = "ОЦ-02 «Кипарис»"
ITEM.description = "Пистолет-пулемёт под 9×18 мм. Компактный и тихий, созданный для спецподразделений. В Зоне ценится за скрытность и удобство в городских руинах."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_kiparis_w.mdl"
ITEM.class = "tfa_anomaly_kiparis"
ITEM.weaponCategory = "primary"
ITEM.price = 8620
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
							["Angles"] = Angle(180, 0, 180),
							["Position"] = Vector(5.5, -4.8, 1.0),
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_kiparis_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "kiparis",
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
					["Arguments"] = "tfa_anomaly_kiparis@@0",
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