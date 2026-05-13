ITEM.base = "base_weapons"

ITEM.name = "Охотничий нож"
ITEM.description = "Охотничий нож. Подходит как оружие ближнего боя и инструмент для разделки."
ITEM.longdesc = "Охотничий нож из пакета Anomaly. Можно использовать в ближнем бою, а также для разделки туш мутантов."
ITEM.model = "models/flaymi/anomaly/weapons/w_models/wpn_knife_hunting_w.mdl"
ITEM.category = "Knife"

ITEM.width = 2
ITEM.height = 1
ITEM.price = 450
ITEM.weight = 0.850
ITEM.repairCost = ITEM.price / 100 * 1

ITEM.class = "tfa_anomaly_knife_hunting"
ITEM.weaponCategory = "knife"
ITEM.canAttach = false

ITEM.isPoachKnife = true
ITEM.knifetier = 0

ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(0, 20, 4),
	ang = Angle(0, 270, -115),
	fov = 45,
}

ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
					[1] = {
						["children"] = {},
						["self"] = {
							["Angles"] = Angle(0, 80, 90),
							["Position"] = Vector(4, 1, -4),
							["Model"] = "models/flaymi/anomaly/weapons/w_models/wpn_knife_hunting_w.mdl",
							["ClassName"] = "model",
							["EditorExpand"] = true,
							["UniqueID"] = "knife_hunting_model",
							["Bone"] = "right thigh",
							["Name"] = "hunting knife",
						},
					},
				},
				["self"] = {
					["AffectChildrenOnly"] = true,
					["ClassName"] = "event",
					["UniqueID"] = "knife_hunting_event",
					["Event"] = "weapon_class",
					["Invert"] = false,
					["EditorExpand"] = true,
					["Name"] = "weapon class find simple\"@@1\"",
					["Arguments"] = "tfa_anomaly_knife_hunting@@0",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "knife_hunting_group",
			["EditorExpand"] = true,
		},
	},
}

function ITEM:PopulateTooltipIndividual(tooltip)
	ix.util.PropertyDesc(tooltip, "Ближний бой", Color(64, 224, 208))
	ix.util.PropertyDesc(tooltip, "Инструмент для разделки", Color(64, 224, 208))
end