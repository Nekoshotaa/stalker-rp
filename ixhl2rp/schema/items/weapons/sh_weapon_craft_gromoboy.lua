ITEM.name = "Семистрел «Громобой»"
ITEM.description = "Семиствольное чудовище, больше похожее на оружейную ошибку, чем на нормальный ствол."
ITEM.model = "models/weapons/world_at_war/nockgun/w_nockgun.mdl"
ITEM.class = "tfa_waw_nockgun" -- ВАЖНО: если у аддона другой SWEP class, замени здесь.
ITEM.weaponCategory = "primary"
ITEM.price = 11000
ITEM.width = 4
ITEM.height = 2
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
                            ["Model"] = "models/weapons/world_at_war/nockgun/w_nockgun.mdl",
                            ["ClassName"] = "model",
                            ["EditorExpand"] = true,
                            ["UniqueID"] = "weapon_craft_gromoboy_pac_model",
                            ["Bone"] = "spine 2",
                            ["Name"] = "weapon_craft_gromoboy",
                        },
                    },
                },
                ["self"] = {
                    ["AffectChildrenOnly"] = true,
                    ["ClassName"] = "event",
                    ["UniqueID"] = "weapon_craft_gromoboy_pac_event",
                    ["Event"] = "weapon_class",
                    ["Invert"] = false,
                    ["EditorExpand"] = true,
                    ["Name"] = "weapon class find simple",
                    ["Arguments"] = "tfa_waw_nockgun@@0",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "weapon_craft_gromoboy_pac_group",
            ["EditorExpand"] = true,
        },
    },
}
