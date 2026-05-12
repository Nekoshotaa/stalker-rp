ITEM.name = "Сумка маленькая"
ITEM.description = "Небольшая сумка для самого необходимого. Не заменит полноценный рюкзак, но добавит немного полезного места."
ITEM.model = "models/wick/wrbstalker/anomaly/items/dez_sumka6.mdl"

ITEM.price = 700
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Рюкзаки"

-- Стандартная сумка Helix/контейнер
ITEM.isBag = true
ITEM.invWidth = 2
ITEM.invHeight = 2

-- Экипировка на спину
ITEM.outfitCategory = "Backpack"

ITEM.pacData = {
    [1] = {
        ["children"] = {
            [1] = {
                ["children"] = {},
                ["self"] = {
                    ["Angles"] = Angle(0, -90, 90),
                    ["Position"] = Vector(-5.8, 0, 1.2),
                    ["UniqueID"] = "bp_small_bag_model",
                    ["Size"] = 0.8,
                    ["Bone"] = "chest",
                    ["Model"] = "models/wick/wrbstalker/anomaly/items/dez_sumka6.mdl",
                    ["ClassName"] = "model",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "bp_small_bag_group",
            ["EditorExpand"] = true,
        },
    },
}
