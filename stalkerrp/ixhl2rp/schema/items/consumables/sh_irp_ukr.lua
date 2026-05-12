ITEM.name = "Украинский ИРП"
ITEM.description = "Полноценный полевой рацион. Сытно, надолго и без изысков."
ITEM.model = "models/wick/wrbstalker/cop/newmodels/items/wick_irp_ukr.mdl"
ITEM.category = "Еда"
ITEM.price = 2200
ITEM.width = 2
ITEM.height = 2
ITEM.sound = "stalkersound/inv_eat_paket.mp3"
ITEM.quantity = 3
ITEM.hunger = 22
ITEM.thirst = 4
ITEM.stamina = {duration = 20, amount = 2}

function ITEM:GetDescription()
    local uses = self:GetData("uses", self.quantity or 1)
    return self.description .. "\n\nОсталось порций: " .. uses
end

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Полевой рацион", Color(210, 210, 160))
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

        ix.chat.Send(client, "iteminternal", "eats some of their " .. item.name .. ".", false)

        local uses = item:GetData("uses", item.quantity or 1) - 1
        if uses > 0 then
            item:SetData("uses", uses)
            return false
        end
        return true
    end,
    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
