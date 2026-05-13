ITEM.name = "Солдатский берил"
ITEM.description = "Тяжёлый армейский защитный комплект, рассчитанный на бой в опасной среде. Даёт хорошую живучесть и выдержку в тяжёлых столкновениях. Повышает выносливость, устойчивость и автоматам."
ITEM.model = "models/hardbass/happy_armor_6b.mdl"
ITEM.width = 2
ITEM.height = 3
ITEM.category = "Armor"
ITEM.outfitCategory = "model"

ITEM.armorAmount = 120
ITEM.gasmask = true
ITEM.resistance = true


ITEM.damage = {
    0.90, -- bullets
    0.60, -- slash
    0.70, -- shock
    0.75, -- burn
    0.65, -- radiation
    0.70, -- acid
    0.60, -- explosive
}

ITEM.skillBoosts = {
    ["endurance"] = 10,
    ["stability"] = 10,
    ["rifle"] = 6
}