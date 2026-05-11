ITEM.name = "Сталкерская сумка"
ITEM.description = "Практичная сумка сталкера. Хороший компромисс между объёмом и компактностью."
ITEM.model = "models/wick/wrbstalker/anomaly/items/dez_sumka4.mdl"

ITEM.price = 1400
ITEM.width = 1
ITEM.height = 2
ITEM.category = "Рюкзаки"

-- Стандартная сумка Helix/контейнер
ITEM.isBag = true
ITEM.invWidth = 4
ITEM.invHeight = 3

-- Экипировка на спину
ITEM.outfitCategory = "Backpack"

ITEM.pacData = {
    [1] = {
        ["children"] = {
            [1] = {
                ["children"] = {},
                ["self"] = {
                    ["Angles"] = Angle(0, -90, 90),
                    ["Position"] = Vector(-6.0, 0, 1.4),
                    ["UniqueID"] = "bp_stalker_bag_model",
                    ["Size"] = 0.85,
                    ["Bone"] = "chest",
                    ["Model"] = "models/wick/wrbstalker/anomaly/items/dez_sumka4.mdl",
                    ["ClassName"] = "model",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "bp_stalker_bag_group",
            ["EditorExpand"] = true,
        },
    },
}
