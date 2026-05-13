ITEM.name = 'Болеутоляющая химия'
ITEM.description = 'Флакон мутной аптекарской смеси. Притупляет боль, разгоняет кровь и заставляет тело двигаться, даже когда разум уже просит остановиться.'
ITEM.model = 'models/fnv/clutter/health/psychochem01.mdl'
ITEM.price = 650
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Медицина"
ITEM.sound = 'items/medshot4.wav'
ITEM.quantity = 1
ITEM.heal = 12

local function clampNeeds(client, hungerDelta, thirstDelta)
    if not IsValid(client) or not client.GetCharacter then return end

    if hungerDelta and client.GetHunger and client.SetHunger then
        client:SetHunger(math.Clamp((client:GetHunger() or 100) + hungerDelta, 0, 100))
    end

    if thirstDelta and client.GetThirst and client.SetThirst then
        client:SetThirst(math.Clamp((client:GetThirst() or 100) + thirstDelta, 0, 100))
    end
end

local function getUses(item)
    return item:GetData("uses", item.quantity or 1)
end

local function consumeUse(item)
    local uses = math.max(getUses(item) - 1, 0)

    if uses <= 0 then
        return true
    end

    item:SetData("uses", uses)
    return false
end

function ITEM:GetDescription()
    local text = self.description or ""

    if (self.quantity or 1) > 1 then
        text = text .. "\n\nОсталось использований: " .. getUses(self)
    end

    return text
end

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Болеутоляющее", Color(180, 220, 240))
end

ITEM.functions.Use = {
    name = "Использовать",
    icon = "icon16/pill.png",
    OnRun = function(item)
        local client = item.player

        if not IsValid(client) then
            return false
        end

        client:EmitSound(item.sound or "items/medshot4.wav")
        client:SetHealth(math.Clamp(client:Health() + (item.heal or 0), 0, client:GetMaxHealth()))
        if client.AddBuff then
            client:AddBuff("buff_staminarestore", 25, { amount = 1 })
            client:AddBuff("buff_slowheal", 10, { amount = 1 })
        end
        clampNeeds(client, -4, -3)
        ix.chat.Send(client, "iteminternal", "использует " .. string.lower(item.name) .. ".", false)

        return consumeUse(item)
    end,
    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
