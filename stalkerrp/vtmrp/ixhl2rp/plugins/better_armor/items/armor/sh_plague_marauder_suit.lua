ITEM.name = "Костюм чумного мародёра"
ITEM.description = "Редкий защитный комплект, собранный из старых фильтрующих элементов, плотной ткани и переработанной защиты. Хорошо подходит тем, кто привык работать с грязью, ранами, химией и закрытыми дверями."
ITEM.model = "models/black1dez/olr/dez_strelok_suit.mdl"
ITEM.uniqueID = "plague_marauder_suit"
ITEM.width = 2
ITEM.height = 3
ITEM.category = "Armor"
ITEM.outfitCategory = "model"

ITEM.armorAmount = 68
ITEM.gasmask = true
ITEM.resistance = true
ITEM.replacement = "models/fortnite/plague.mdl"

ITEM.damage = {
    0.38, -- bullets
    0.50, -- slash
    0.42, -- shock
    0.48, -- burn
    0.55, -- radiation
    0.62, -- acid
    0.18, -- explosive
}

ITEM.skillBoosts = {
    ["medicine"] = 10,
    ["chemistry"] = 8,
    ["lockpicking"] = 4
}
