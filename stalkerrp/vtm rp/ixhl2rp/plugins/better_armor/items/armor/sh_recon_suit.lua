ITEM.name = "Комбинезон разведчика"
ITEM.description = "Лёгкий и редкий комплект для скрытных вылазок, наблюдения и точной работы на дистанции. Повышает скрытность, наблюдательность и реакцию."
ITEM.model = "models/hardbass/stalker_skat9m_razgryz.mdl"
ITEM.width = 2
ITEM.height = 3
ITEM.category = "Armor"
ITEM.outfitCategory = "model"

ITEM.armorAmount = 90
ITEM.gasmask = false
ITEM.resistance = true
ITEM.replacement = "models/player/grehkovich/stalker_greh_1a_face_2.mdl"

ITEM.damage = {
    0.65, -- bullets
    0.65, -- slash
    0.75, -- shock
    0.60, -- burn
    0.60, -- radiation
    0.60, -- acid
    0.40, -- explosive
}

ITEM.skillBoosts = {
    ["stealth"] = 10,
    ["observation"] = 10,
    ["reaction"] = 8
}