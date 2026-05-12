ITEM.name = "Лёгкий подсумок"
ITEM.description = "Лёгкий подсумок для мелочей и расходников. Почти не занимает места на себе."
ITEM.model = "models/wick/wrbstalker/anomaly/items/dez_upgr_o_1.mdl"

ITEM.price = 450
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Рюкзаки"

-- Стандартная сумка Helix/контейнер
ITEM.isBag = true
ITEM.invWidth = 2
ITEM.invHeight = 1

-- Экипировка на спину
ITEM.outfitCategory = "Backpack"

ITEM.pacData = {
    [1] = {
        ["children"] = {
            [1] = {
                ["children"] = {},
                ["self"] = {
                    ["Angles"] = Angle(0, -90, 90),
                    ["Position"] = Vector(-4.8, 0, 0.8),
                    ["UniqueID"] = "bp_light_pouch_model",
                    ["Size"] = 0.75,
                    ["Bone"] = "chest",
                    ["Model"] = "models/wick/wrbstalker/anomaly/items/dez_upgr_o_1.mdl",
                    ["ClassName"] = "model",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "bp_light_pouch_group",
            ["EditorExpand"] = true,
        },
    },
}
