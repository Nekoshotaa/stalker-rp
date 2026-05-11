ITEM.name = "Самодельная винтовка «Северный Гвоздь»"
ITEM.description = "Однозарядная самодельная винтовка из старой трубы, деревянной основы и упрямства."
ITEM.model = "models/weapons/handmaderifle/w_handmaderifle.mdl"
ITEM.class = "tfa_dayr_handmaderifle" -- ВАЖНО: если у аддона другой SWEP class, замени здесь.
ITEM.weaponCategory = "primary"
ITEM.price = 2900
ITEM.width = 3
ITEM.height = 1
ITEM.isWeapon = true
ITEM.category = "Уникальное оружие"

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
                            ["Model"] = "models/weapons/w_snip_scout.mdl",
                            ["ClassName"] = "model",
                            ["EditorExpand"] = true,
                            ["UniqueID"] = "weapon_craft_northern_nail_pac_model",
                            ["Bone"] = "spine 2",
                            ["Name"] = "weapon_craft_northern_nail",
                        },
                    },
                },
                ["self"] = {
                    ["AffectChildrenOnly"] = true,
                    ["ClassName"] = "event",
                    ["UniqueID"] = "weapon_craft_northern_nail_pac_event",
                    ["Event"] = "weapon_class",
                    ["Invert"] = false,
                    ["EditorExpand"] = true,
                    ["Name"] = "weapon class find simple",
                    ["Arguments"] = "tfa_dayr_handmaderifle@@0",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "weapon_craft_northern_nail_pac_group",
            ["EditorExpand"] = true,
        },
    },
}
