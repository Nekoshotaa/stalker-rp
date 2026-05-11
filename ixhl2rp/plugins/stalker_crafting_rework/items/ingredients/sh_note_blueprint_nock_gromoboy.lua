ITEM.name = "Записка: «Громобой»"
ITEM.description = "Безумная схема семиствольного оружия. Часть текста перечёркнута, а внизу приписка: не держать близко к лицу."
ITEM.model = "models/akabenko/item_notens.mdl"
ITEM.uniqueID = "note_blueprint_nock_gromoboy"
ITEM.category = "Записки"

ITEM.width = 1
ITEM.height = 1
ITEM.price = 2500

ITEM.recipeID = "blueprint_nock_gromoboy"
ITEM.recipeName = "Семистрел «Громобой»"

ITEM.functions.Read = {
    name = "Изучить",
    icon = "icon16/book_open.png",

    OnRun = function(item)
        local client = item.player
        if not IsValid(client) then return false end
        local character = client:GetCharacter()
        if not character then return false end

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
