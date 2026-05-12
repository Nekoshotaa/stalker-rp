ITEM.name = "Геркулес"
ITEM.description = "Сильный стимулятор, повышающий выносливость и помогающий не свалиться от усталости в долгой вылазке."
ITEM.model = "models/wick/wrbstalker/cop/newmodels/items/wick_hercules.mdl"
ITEM.price = 1700
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Медицина"
ITEM.sound = "stalkersound/inv_pills.mp3"
ITEM.quantity = 1
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
    local text = self.description

    if (self.quantity or 1) > 1 then
        text = text .. "\n\nОсталось использований: " .. getUses(self)
    end

    return text
end

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Стимулятор выносливости", Color(240, 200, 80))
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
        if client.AddBuff then
            client:AddBuff("buff_staminarestore", 45, { amount = 2 })
        end
        clampNeeds(client, -4, -2)
        ix.chat.Send(client, "iteminternal", "использует " .. string.lower(item.name) .. ".", false)

        return consumeUse(item)
    end,
    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
