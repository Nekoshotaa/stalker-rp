ITEM.name = "Напиток <Пахомий>"
ITEM.description = "Подозрительный наркотический напиток кустарного происхождения. Даёт всплеск бодрости, но бьёт по голове."
ITEM.model = "models/wick/wrbstalker/anomaly/items/wick_drink_crow.mdl"
ITEM.category = "Наркотики"
ITEM.price = 2400
ITEM.width = 1
ITEM.height = 2
ITEM.sound = "stalkersound/inv_flask.mp3"
ITEM.quantity = 2
ITEM.thirst = 12
ITEM.alcohol = 25
ITEM.stamina = {duration = 30, amount = 3}
ITEM.psy = {duration = 35, amount = 0.12}

function ITEM:GetDescription()
    local uses = self:GetData("uses", self.quantity or 1)
    return self.description .. "\n\nОсталось доз: " .. uses
end

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Наркотический напиток", Color(200, 120, 255))
end

ITEM.functions.Use = {
    name = "Выпить",
    icon = "icon16/drink.png",
    OnRun = function(item)
        local client = item.player
        if not IsValid(client) then return false end
        client:EmitSound(item.sound or "items/battery_pickup.wav")

        if client.GetThirst and client.SetThirst then
            client:SetThirst(math.Clamp((client:GetThirst() or 100) + (item.thirst or 0), 0, 100))
        end
        if client.IncreaseDrunkLevel then
            client:IncreaseDrunkLevel(item.alcohol or 0)
        end
        if client.AddBuff and item.stamina then
            client:AddBuff("buff_staminarestore", item.stamina.duration, {amount = item.stamina.amount})
        end
        if client.AddBuff and item.psy then
            client:AddBuff("buff_psyblock", item.psy.duration, {amount = item.psy.amount})
        end

        ix.chat.Send(client, "iteminternal", "drinks some of their " .. item.name .. ".", false)

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
