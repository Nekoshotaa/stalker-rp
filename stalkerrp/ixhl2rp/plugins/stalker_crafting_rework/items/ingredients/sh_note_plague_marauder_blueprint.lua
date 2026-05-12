ITEM.name = "Записка с чертежом костюма чумного мародёра"
ITEM.description = "Смятая записка с эскизами защитного костюма и пометками о переработке старого снаряжения. Судя по пометкам, кто-то собирал комплект под работу с химией, ранами и заражённой средой."
ITEM.model = "models/akabenko/item_notens.mdl"
ITEM.uniqueID = "note_plague_marauder_blueprint"
ITEM.category = "Записки"

ITEM.width = 1
ITEM.height = 1
ITEM.price = 1200

ITEM.recipeID = "blueprint_plague_marauder"
ITEM.recipeName = "Костюм чумного мародёра"

ITEM.functions.Read = {
    name = "Изучить",
    icon = "icon16/book_open.png",

    OnRun = function(item)
        local client = item.player
        if not IsValid(client) then
            return false
        end

        local character = client:GetCharacter()
        if not character then
            return false
        end

        local craftPlugin
        for _, plugin in pairs(ix.plugin.list) do
            if (plugin.craft and plugin.craft.LearnRecipe) then
                craftPlugin = plugin
                break
            end
        end

        if not craftPlugin then
            client:Notify("Система крафта не найдена.")
            return false
        end

        if craftPlugin.craft.LearnRecipe(character, item.recipeID) then
            client:Notify("Вы изучили рецепт: " .. (item.recipeName or item.recipeID) .. ".")
            return true
        end

        client:Notify("Этот рецепт уже изучен.")
        return false
    end,

    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
