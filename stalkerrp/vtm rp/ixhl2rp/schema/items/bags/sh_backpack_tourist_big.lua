ITEM.name = "Большой рюкзак туриста"
ITEM.description = "Просторный туристический рюкзак для длительных вылазок. Даёт много дополнительного места для припасов и находок."
ITEM.model = "models/kek1ch/dev_rukzak_turist.mdl"

ITEM.price = 2200
ITEM.width = 2
ITEM.height = 2
ITEM.category = "Рюкзаки"

-- Стандартная сумка Helix/контейнер
ITEM.isBag = true
ITEM.invWidth = 5
ITEM.invHeight = 4

-- Экипировка на спину
ITEM.outfitCategory = "Backpack"

ITEM.pacData = {
    [1] = {
        ["children"] = {
            [1] = {
                ["children"] = {},
                ["self"] = {
                    ["Angles"] = Angle(0, -90, 90),
                    ["Position"] = Vector(-7.2, 0, 1.6),
                    ["UniqueID"] = "bp_tourist_big_model",
                    ["Size"] = 0.9,
                    ["Bone"] = "chest",
                    ["Model"] = "models/kek1ch/dev_rukzak_turist.mdl",
                    ["ClassName"] = "model",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "bp_tourist_big_group",
            ["EditorExpand"] = true,
        },
    },
}
