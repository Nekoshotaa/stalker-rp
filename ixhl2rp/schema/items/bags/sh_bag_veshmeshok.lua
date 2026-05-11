ITEM.name = "Вещмешок"
ITEM.description = "Старый армейский вещмешок. Непритязательный, но вместительный и надёжный."
ITEM.model = "models/wick/wrbstalker/anomaly/items/dez_sumka7.mdl"

ITEM.price = 1100
ITEM.width = 1
ITEM.height = 2
ITEM.category = "Рюкзаки"

-- Стандартная сумка Helix/контейнер
ITEM.isBag = true
ITEM.invWidth = 3
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
                    ["Position"] = Vector(-6.2, 0, 1.4),
                    ["UniqueID"] = "bp_veshmeshok_model",
                    ["Size"] = 0.85,
                    ["Bone"] = "chest",
                    ["Model"] = "models/wick/wrbstalker/anomaly/items/dez_sumka7.mdl",
                    ["ClassName"] = "model",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "bp_veshmeshok_group",
            ["EditorExpand"] = true,
        },
    },
}
