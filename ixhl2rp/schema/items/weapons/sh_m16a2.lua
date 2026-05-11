ITEM.name = "M16A2"
ITEM.description = "Американская штурмовая винтовка 5.56×45 мм. Точная, с хорошей эргономикой и прицельными приспособлениями. В Зоне ценится за дальность и кучность, хотя и требовательна к уходу."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_m16a2_w.mdl"
ITEM.class = "tfa_anomaly_m16a2"
ITEM.weaponCategory = "primary"
ITEM.price = 15500
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_m16a2_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "spine 2",
							["Name"] = "m16a2",
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
					["Arguments"] = "tfa_anomaly_m16a2@@0",
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