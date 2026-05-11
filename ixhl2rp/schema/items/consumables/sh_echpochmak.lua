ITEM.name = "Хачапури"
ITEM.description = "Сытная сырная выпечка. Теплая и всё ещё хороша."
ITEM.model = "models/zapravka/echpochmak.mdl"
ITEM.category = "Еда"
ITEM.price = 420
ITEM.width = 1
ITEM.height = 1
ITEM.sound = "stalkersound/inv_eat.mp3"
ITEM.hunger = 18
ITEM.thirst = -2
ITEM.stamina = {duration = 10, amount = 1}

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Сытная выпечка", Color(230, 210, 160))
end

ITEM.functions.Use = {
    name = "Съесть",
    icon = "icon16/cup.png",
    OnRun = function(item)
        local client = item.player
        if not IsValid(client) then return false end
        client:EmitSound(item.sound or "items/battery_pickup.wav")

        if client.GetHunger and client.SetHunger then
            client:SetHunger(math.Clamp((client:GetHunger() or 100) + (item.hunger or 0), 0, 100))
        end
        if client.GetThirst and client.SetThirst then
            client:SetThirst(math.Clamp((client:GetThirst() or 100) + (item.thirst or 0), 0, 100))
        end
        if client.AddBuff and item.stamina then
            client:AddBuff("buff_staminarestore", item.stamina.duration, {amount = item.stamina.amount})
        end

        ix.chat.Send(client, "iteminternal", "eats their " .. item.name .. ".", false)
        return true
    end,
    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
