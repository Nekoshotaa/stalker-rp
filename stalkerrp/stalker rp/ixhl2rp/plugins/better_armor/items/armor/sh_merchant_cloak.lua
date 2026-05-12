ITEM.name = "Плащ торговца"
ITEM.description = "Редкий плащ человека, который умеет выживать не силой, а связями, языком и выгодной сделкой. Повышает торговлю, убеждение и обман."
ITEM.model = "models/hardbass/stalker_soldier_9.mdl"
ITEM.width = 2
ITEM.height = 3
ITEM.category = "Armor"
ITEM.outfitCategory = "model"

ITEM.armorAmount = 60
ITEM.gasmask = false
ITEM.resistance = true
ITEM.replacement = "models/player/axelnoir/resident_evil_4/bio4/em/em18/merchanto_pm.mdl"

ITEM.damage = {
    0.45, -- bullets
    0.60, -- slash
    0.50, -- shock
    0.30, -- burn
    0.40, -- radiation
    0.45, -- acid
    0.20, -- explosive
}

ITEM.skillBoosts = {
    ["trade"] = 12,
    ["persuasion"] = 8,
    ["deception"] = 8
}