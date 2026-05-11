ITEM.name = "Фольксштурмгевер «Последний рубеж»"
ITEM.description = "Грубая винтовка военного времени, возвращённая к жизни, деталями и грубой подгонкой."
ITEM.model = "models/weapons/w_ww2_volkssturmgewehr.mdl"
ITEM.class = "tfa_ww2_volkssturmgewehr" -- ВАЖНО: если у аддона другой SWEP class, замени здесь.
ITEM.weaponCategory = "primary"
ITEM.price = 6800
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
                            ["Model"] = "models/weapons/w_ww2_volkssturmgewehr.mdl",
                            ["ClassName"] = "model",
                            ["EditorExpand"] = true,
                            ["UniqueID"] = "weapon_craft_last_line_pac_model",
                            ["Bone"] = "spine 2",
                            ["Name"] = "weapon_craft_last_line",
                        },
                    },
                },
                ["self"] = {
                    ["AffectChildrenOnly"] = true,
                    ["ClassName"] = "event",
                    ["UniqueID"] = "weapon_craft_last_line_pac_event",
                    ["Event"] = "weapon_class",
                    ["Invert"] = false,
                    ["EditorExpand"] = true,
                    ["Name"] = "weapon class find simple",
                    ["Arguments"] = "tfa_ww2_volkssturmgewehr@@0",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "weapon_craft_last_line_pac_group",
            ["EditorExpand"] = true,
        },
    },
}
