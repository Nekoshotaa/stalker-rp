RECIPE.name = "Восстановление ПП «Гепард»"
RECIPE.description = "Восстановить редкий ПП «Гепард» из повреждённого корпуса, специального узла и набора оружейных деталей."
RECIPE.model = "models/weapons/comrade/w_gepard.mdl"
RECIPE.category = "Верстак"

RECIPE.station = "workbench"
RECIPE.skill = "tec"
RECIPE.skillLevel = 25
RECIPE.blueprint = "blueprint_gepard_restore"
RECIPE.hiddenUntilLearned = true

RECIPE.requirements = {
    ["gepard_broken_receiver"] = 1,
    ["gepard_bolt_group"] = 1,
    ["weapon_parts"] = 6
}

RECIPE.results = {
    ["gepard"] = 1
}