ITEM.name = "Броня ЧОПовская"
ITEM.description = "Как минимум вы так думайте, достаточно неплохо сделанная и подшитая броня... иностранная... что она тут делает? Если присмотрится, то можно найти инициалы <.....девател...группа"
ITEM.model = "models/black1dez/olr/dez_eco_old_suit.mdl"
ITEM.width = 2
ITEM.height = 3
ITEM.price = 4500
ITEM.category = "Armor"
ITEM.outfitCategory = "model"
ITEM.replacement = "models/arachnit/residentevil7/notahero/characters/umbrella_soldier/umbrella_soldier_ragdoll.mdl"

ITEM.armorAmount = 65
ITEM.gasmask = false
ITEM.resistance = true


ITEM.damage = {
    0.85, -- bullets
    0.70, -- slash
    0.75, -- shock
    0.40, -- burn
    0.40, -- radiation
    0.40, -- acid
    0.50, -- explosive
}

ITEM.skillBoosts = {
    ["melee"] = 10,
    ["pistols"] = 10,
    ["reaction"] = 5,
	["stability"] = 5
}