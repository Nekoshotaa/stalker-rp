RECIPE.name = "Фольксштурмгевер «Последний рубеж»"
RECIPE.description = "Собрать грубую военную винтовку из редкой ствольной коробки, затворного узла и набора оружейных расходников."
RECIPE.model = "models/weapons/w_ww2_volkssturmgewehr.mdl"
RECIPE.category = "Оружейный крафт"

RECIPE.station = "workbench"
RECIPE.skill = "eng"
RECIPE.skillLevel = 25
RECIPE.blueprint = "blueprint_volks_last_line"
RECIPE.hiddenUntilLearned = true

RECIPE.requirements = {
    ["volks_rough_receiver"] = 1,
    ["volks_bolt_group"] = 1,
    ["weapon_parts"] = 5,
    ["metal_scrap"] = 3,
}

RECIPE.results = {
    ["weapon_craft_last_line"] = 1,
}
