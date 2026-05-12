ITEM.name = "Набор для восстановления брони"
ITEM.model = Model("models/superstimulator.mdl")
ITEM.description = "Этот предмет больше не используется, потому что механика прочности брони отключена."
ITEM.category = "Броня"

ITEM.functions.Repair = {
    name = "Не используется",
    icon = "icon16/cancel.png",
    OnRun = function(item)
        item.player:Notify("Механика прочности отключена. Этот предмет больше не нужен.")
        return false
    end,
    OnCanRun = function(item)
        return false
    end
}
