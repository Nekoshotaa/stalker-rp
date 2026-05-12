local PLUGIN = PLUGIN

function PLUGIN:OnLoaded()
    local basePath = self.path or self.folder or ""

    if (basePath == "") then
        ErrorNoHalt("[STALKER Crafting Rework] Не удалось определить путь плагина.\n")
        return
    end

    self.craft.recipes = self.craft.recipes or {}
    self.craft.stations = self.craft.stations or {}

    self.craft.LoadFromDir(basePath.."/recipes", "recipe")
    self.craft.LoadFromDir(basePath.."/stations", "station")

    print("[STALKER Crafting Rework] Загружено рецептов: "..table.Count(self.craft.recipes))
    print("[STALKER Crafting Rework] Загружено станций: "..table.Count(self.craft.stations))
end