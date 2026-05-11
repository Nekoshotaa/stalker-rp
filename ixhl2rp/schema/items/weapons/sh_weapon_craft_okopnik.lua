ITEM.name = "MP18 «Окопник»"
ITEM.description = "Старый пистолет-пулемёт, восстановленный на сталкерском верстаке. Тяжёлый, странный, но опасный в тесноте."
ITEM.model = "models/bf1/weapons/bergmann mp18-i.mdl"
ITEM.class = "weapon_mp18_beckman" -- ВАЖНО: если у аддона другой SWEP class, замени здесь.
ITEM.weaponCategory = "primary"
ITEM.price = 5200
ITEM.width = 3
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
                            ["Model"] = "models/bf1/weapons/bergmann mp18-i.mdl",
                            ["ClassName"] = "model",
                            ["EditorExpand"] = true,
                            ["UniqueID"] = "weapon_craft_okopnik_pac_model",
                            ["Bone"] = "spine 2",
                            ["Name"] = "weapon_craft_okopnik",
                        },
                    },
                },
                ["self"] = {
                    ["AffectChildrenOnly"] = true,
                    ["ClassName"] = "event",
                    ["UniqueID"] = "weapon_craft_okopnik_pac_event",
                    ["Event"] = "weapon_class",
                    ["Invert"] = false,
                    ["EditorExpand"] = true,
                    ["Name"] = "weapon class find simple",
                    ["Arguments"] = "weapon_mp18_beckman@@0",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "weapon_craft_okopnik_pac_group",
            ["EditorExpand"] = true,
        },
    },
}
