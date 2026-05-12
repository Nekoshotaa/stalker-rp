RECIPE.name = "MP18 «Окопник»"
RECIPE.description = "Восстановить старый пистолет-пулемёт. Требует аккуратности, чистки и нормальных оружейных деталей."
RECIPE.model = "models/bf1/weapons/bergmann mp18-i.mdl"
RECIPE.category = "Верстак"

RECIPE.station = "workbench"
RECIPE.skill = "eng"
RECIPE.skillLevel = 20
RECIPE.blueprint = "blueprint_mp18_okopnik"
RECIPE.hiddenUntilLearned = true

RECIPE.requirements = {
    ["weapon_parts"] = 3,
    ["metal_scrap"] = 2,
    ["mp18_old_receiver"] = 1,
    ["mp18_snail_mag"] = 1,
}

RECIPE.results = {
    ["weapon_craft_okopnik"] = 1,
}
