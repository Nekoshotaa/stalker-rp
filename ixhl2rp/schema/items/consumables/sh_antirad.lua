ITEM.name = "Антирад"
ITEM.description = "Распространённый препарат для снижения последствий радиационного заражения."
ITEM.model = "models/wick/wrbstalker/anomaly/items/wick_dev_antirad.mdl"
ITEM.category = "Медицина"
ITEM.price = 1800
ITEM.width = 1
ITEM.height = 1
ITEM.sound = "stalkersound/inv_pills.mp3"
ITEM.quantity = 2
ITEM.radremove = 18
ITEM.radprotect = {duration = 45, amount = 0.08}

function ITEM:GetDescription()
    local uses = self:GetData("uses", self.quantity or 1)
    return self.description .. "\n\nОсталось доз: " .. uses
end

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Радиационная защита", Color(100, 255, 140))
end

ITEM.functions.Use = {
    name = "Использовать",
    icon = "icon16/pill.png",
    OnRun = function(item)
        local client = item.player
        if not IsValid(client) then return false end

        if client.EmitSound then
            client:EmitSound(item.sound or "items/battery_pickup.wav")
        end

        if client.addRadiation then
            client:addRadiation(-(item.radremove or 0))
        end

        if client.AddBuff and item.radprotect then
            client:AddBuff("buff_radprotect", item.radprotect.duration, {amount = item.radprotect.amount})
        end

        ix.chat.Send(client, "iteminternal", "uses their " .. item.name .. ".", false)

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
