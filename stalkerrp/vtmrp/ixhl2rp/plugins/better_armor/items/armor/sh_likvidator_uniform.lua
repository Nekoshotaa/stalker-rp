ITEM.name = "Форма Ликвидатора"
ITEM.description = "Тяжёлый защитный комплект для работы в заражённых и разрушенных зонах. Не самая удобная броня, зато хорошо держит радиацию, жар и прочие радости Зоны."
ITEM.model = "models/black1dez/olr/dez_monolit_suit.mdl"
ITEM.uniqueID = "likvidator_uniform"
ITEM.width = 2
ITEM.height = 3
ITEM.category = "Armor"
ITEM.outfitCategory = "model"

ITEM.armorAmount = 75
ITEM.gasmask = true
ITEM.resistance = true
ITEM.replacement = "models/pw_force.mdl"

ITEM.damage = {
    0.40, -- bullets
    0.55, -- slash
    0.35, -- shock
    0.62, -- burn
    0.70, -- radiation
    0.58, -- acid
    0.22, -- explosive
}

ITEM.skillBoosts = {
    ["stb"] = 10,
    ["end"] = 8,
    ["sur"] = 6
}
