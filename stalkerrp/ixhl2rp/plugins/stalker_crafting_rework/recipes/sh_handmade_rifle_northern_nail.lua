RECIPE.name = "Самодельная винтовка «Северный Гвоздь»"
RECIPE.description = "Восстановить самодельную однозарядную винтовку из кустарного ствола, ударного замка и простых оружейных расходников."
RECIPE.model = "models/weapons/handmaderifle/w_handmaderifle.mdl"
RECIPE.category = "Верстак"

RECIPE.station = "workbench"
RECIPE.skill = "eng"
RECIPE.skillLevel = 25
RECIPE.blueprint = "blueprint_northern_nail"
RECIPE.hiddenUntilLearned = true

RECIPE.requirements = {
    ["northern_long_pipe_barrel"] = 1,
    ["northern_homemade_lock"] = 1,
    ["weapon_parts"] = 3,
    ["wood_scrap"] = 2,
    ["glue"] = 1,
    ["weapon_clearkit"] = 1,
}

RECIPE.results = {
    ["weapon_craft_northern_nail"] = 1,
}
