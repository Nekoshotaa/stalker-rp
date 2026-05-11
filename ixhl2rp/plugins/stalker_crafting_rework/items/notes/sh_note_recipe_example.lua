ITEM.name = "Потрёпанная записка с рецептом"
ITEM.description = "На бумаге кривым почерком записан пример изучаемого рецепта. Можно использовать как шаблон для будущих рецептов."
ITEM.model = "models/props_lab/bindergraylabel01b.mdl"
ITEM.category = "Записки"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 50
ITEM.recipeID = "example_recipe_id"
ITEM.recipeName = "Пример рецепта"

ITEM.functions.Read = {
    name = "Изучить",
    icon = "icon16/book_open.png",

    OnRun = function(item)
        local client = item.player
        if (!IsValid(client)) then
            return false
        end

        local character = client:GetCharacter()
        if (!character) then
            return false
        end

        local craftPlugin
        for _, plugin in pairs(ix.plugin.list) do
            if (plugin.craft and plugin.craft.LearnRecipe) then
                craftPlugin = plugin
                break
            end
        end

        if (!craftPlugin) then
            client:Notify("Система крафта не найдена.")
            return false
        end

        if (craftPlugin.craft.LearnRecipe(character, item.recipeID)) then
            client:Notify("Вы изучили рецепт: "..(item.recipeName or item.recipeID)..".")
            return true
        end

        client:Notify("Этот рецепт уже изучен.")
        return false
    end,

    OnCanRun = function(item)
        return !IsValid(item.entity)
    end
}
