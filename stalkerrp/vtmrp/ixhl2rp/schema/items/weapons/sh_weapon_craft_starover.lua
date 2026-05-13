ITEM.name = "Мушкет «Старовер»"
ITEM.description = "Примитивная длинная винтовка для тех, кто готов терпеть медленную перезарядку ради одного злого выстрела."
ITEM.model = "models/weapons/musket_dayr/w_blunderbuss.mdl"
ITEM.class = "musket_dayr" -- ВАЖНО: если у аддона другой SWEP class, замени здесь.
ITEM.weaponCategory = "primary"
ITEM.price = 1900
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
                            ["Model"] = "models/weapons/musket_dayr/w_blunderbuss.mdl",
                            ["ClassName"] = "model",
                            ["EditorExpand"] = true,
                            ["UniqueID"] = "weapon_craft_starover_pac_model",
                            ["Bone"] = "spine 2",
                            ["Name"] = "weapon_craft_starover",
                        },
                    },
                },
                ["self"] = {
                    ["AffectChildrenOnly"] = true,
                    ["ClassName"] = "event",
                    ["UniqueID"] = "weapon_craft_starover_pac_event",
                    ["Event"] = "weapon_class",
                    ["Invert"] = false,
                    ["EditorExpand"] = true,
                    ["Name"] = "weapon class find simple",
                    ["Arguments"] = "musket_dayr@@0",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "weapon_craft_starover_pac_group",
            ["EditorExpand"] = true,
        },
    },
}
