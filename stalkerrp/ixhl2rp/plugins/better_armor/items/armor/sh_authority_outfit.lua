ITEM.name = "Одежда Авторитета"
ITEM.description = "Дорогой и приметный комплект, который носят те, кто привык давить не только словом, но и присутствием. Повышает авторитет, лидерство и убеждение."
ITEM.model = "models/hardbass/stalker_bandit_2_b_razgryz.mdl"
ITEM.width = 2
ITEM.height = 3
ITEM.category = "Armor"
ITEM.outfitCategory = "model"

ITEM.armorAmount = 80
ITEM.gasmask = false
ITEM.resistance = true
ITEM.replacement = "models/grehkov/shturmank.mdl"

ITEM.damage = {
    0.40, -- bullets
    0.40, -- slash
    0.45, -- shock
    0.40, -- burn
    0.40, -- radiation
    0.40, -- acid
    0.45, -- explosive
}

ITEM.skillBoosts = {
    ["authority"] = 10,
    ["leadership"] = 8,
    ["persuasion"] = 8
}