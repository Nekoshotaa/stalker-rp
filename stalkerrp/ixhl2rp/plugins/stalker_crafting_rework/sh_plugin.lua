local PLUGIN = PLUGIN

PLUGIN.name = "STALKER Crafting Rework"
PLUGIN.author = "OpenAI"
PLUGIN.description = "Переработанный крафт для STALKER/Helix: без tools, с навыками, станциями и изучаемыми рецептами."

-- Сначала мета и язык
ix.util.Include("languages/sh_russian.lua", "shared")
ix.util.Include("meta/sh_recipe.lua", "shared")
ix.util.Include("meta/sh_station.lua", "shared")

-- Потом shared-логика
ix.util.Include("sh_crafting.lua", "shared")
ix.util.Include("sh_hooks.lua", "shared")

-- Потом client
ix.util.Include("cl_hooks.lua", "client")
ix.util.Include("cl_crafting.lua", "client")