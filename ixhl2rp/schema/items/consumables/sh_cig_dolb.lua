ITEM.name = "Сигареты <Долб>"
ITEM.description = "Дешёвые и едкие сигареты. Берут в основном из-за цены."
ITEM.model = "models/wick/wrbstalker/anomaly/items/wick_drink_cigar3.mdl"
ITEM.category = "Табак"
ITEM.price = 350
ITEM.width = 1
ITEM.height = 1
ITEM.sound = "stalkersound/inv_smoke.mp3"
ITEM.quantity = 6
ITEM.stressrelief = {duration = 8, amount = 1}

function ITEM:GetDescription()
    local uses = self:GetData("uses", self.quantity or 1)
    return self.description .. "\n\nОсталось сигарет: " .. uses
end

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Дешёвый табак", Color(160, 160, 160))
end

ITEM.functions.Use = {
    name = "Закурить",
    icon = "icon16/fire.png",
    OnRun = function(item)
        local client = item.player
        if not IsValid(client) then return false end
        client:EmitSound(item.sound or "items/battery_pickup.wav")

        if client.AddBuff and item.stressrelief then
            client:AddBuff("buff_staminarestore", item.stressrelief.duration, {amount = item.stressrelief.amount})
        end

        ix.chat.Send(client, "iteminternal", "lights up a " .. item.name .. ".", false)

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
