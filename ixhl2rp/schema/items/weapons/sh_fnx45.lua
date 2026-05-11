ITEM.name = "FNX-45 <Тактичный>"
ITEM.description = "<Использует: 45 ACP>Разработаны на заказ пистолет, использующийся иностранными спец-службами и службами охраны, откуда он в таком месте?"
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_fnx45_w.mdl"
ITEM.class = "tfa_anomaly_fnx45"
ITEM.weaponCategory = "secondary"
ITEM.price = 4200
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
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_fnx45_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "3421542291",
							["Bone"] = "left thigh",
							["Name"] = "pm",
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
					["Arguments"] = "tfa_anomaly_fnx45@@0",
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