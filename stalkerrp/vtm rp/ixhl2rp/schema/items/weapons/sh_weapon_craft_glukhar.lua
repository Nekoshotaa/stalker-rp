ITEM.name = "Пугач «Глухарь»"
ITEM.description = "<Использует: дробовой/12x70 патрон> Кустарный короткий пугач, собранный из оружейного хлама и грубой фурнитуры. Вблизи опасен, дальше — скорее пугает звуком, чем точностью."
ITEM.model = "models/weapons/dayr/popgun/w_popgun_dayr.mdl"
ITEM.class = "popgun_dayr" -- ВАЖНО: если у аддона другой SWEP class, замени здесь.
ITEM.weaponCategory = "secondary"
ITEM.price = 1400
ITEM.width = 2
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
                            ["Model"] = "models/weapons/dayr/popgun/w_popgun_dayr.mdl",
                            ["ClassName"] = "model",
                            ["EditorExpand"] = true,
                            ["UniqueID"] = "weapon_craft_glukhar_pac_model",
                            ["Bone"] = "spine 2",
                            ["Name"] = "weapon_craft_glukhar",
                        },
                    },
                },
                ["self"] = {
                    ["AffectChildrenOnly"] = true,
                    ["ClassName"] = "event",
                    ["UniqueID"] = "weapon_craft_glukhar_pac_event",
                    ["Event"] = "weapon_class",
                    ["Invert"] = false,
                    ["EditorExpand"] = true,
                    ["Name"] = "weapon class find simple",
                    ["Arguments"] = "popgun_dayr@@0",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "weapon_craft_glukhar_pac_group",
            ["EditorExpand"] = true,
        },
    },
}
