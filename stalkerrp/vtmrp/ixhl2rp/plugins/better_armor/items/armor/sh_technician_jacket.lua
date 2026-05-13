ITEM.name = "Куртка техника"
ITEM.description = "Переделанная рабочая куртка опытного техника. Удобна в ремонте, возне с проводкой и полевой настройке оборудования. Повышает технические науки, электронику и инженерию."
ITEM.model = "models/hardbass/st_nt_1r.mdl"
ITEM.width = 2
ITEM.height = 3
ITEM.category = "Armor"
ITEM.outfitCategory = "model"

ITEM.armorAmount = 65
ITEM.gasmask = false
ITEM.resistance = true
ITEM.replacement = "models/grehkov/stalker_greh_tech.mdl"

ITEM.damage = {
    0.30, -- bullets
    0.65, -- slash
    0.50, -- shock
    0.45, -- burn
    0.45, -- radiation
    0.45, -- acid
    0.85, -- explosive
}

ITEM.skillBoosts = {
    ["technical"] = 12,
    ["electronics"] = 10,
    ["engineering"] = 8
}