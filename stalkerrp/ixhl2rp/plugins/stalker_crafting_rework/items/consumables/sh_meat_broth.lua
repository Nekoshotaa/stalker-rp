ITEM.name = "Мясной бульон"
ITEM.description = "Густой солоноватый бульон, сваренный из мяса плоти. Не самое красивое варево, зато горячее, сытное и отлично подходит как основа для более серьёзных блюд."
ITEM.model = "models/models/kvas.mdl"
ITEM.uniqueID = "meat_broth"
ITEM.category = "Еда"

ITEM.width = 1
ITEM.height = 1
ITEM.price = 140
ITEM.weight = 0.4

ITEM.hunger = 14
ITEM.thirst = 6
ITEM.quantity = 2
ITEM.isDrink = true
ITEM.sound = "stalkersound/inv_drink_flask.mp3"

local function ClampNeeds(client, hungerDelta, thirstDelta)
    if not IsValid(client) or not client.GetCharacter or not client:GetCharacter() then
        return
    end

    if isnumber(hungerDelta) and client.GetHunger and client.SetHunger then
        client:SetHunger(math.Clamp((client:GetHunger() or 100) + hungerDelta, 0, 100))
    end

    if isnumber(thirstDelta) and client.GetThirst and client.SetThirst then
        client:SetThirst(math.Clamp((client:GetThirst() or 100) + thirstDelta, 0, 100))
    end
end

local function ConsumePortion(item)
    local maxUses = math.max(tonumber(item.quantity) or 1, 1)
    local usesLeft = tonumber(item:GetData("uses", maxUses)) or maxUses
    usesLeft = math.Clamp(usesLeft - 1, 0, maxUses)

    if usesLeft <= 0 then
        item:SetData("uses", nil)
        return true
    end

    item:SetData("uses", usesLeft)
    return false
end

function ITEM:GetDescription()
    local desc = self.description or ""
    local maxUses = math.max(tonumber(self.quantity) or 1, 1)

    if maxUses > 1 then
        local usesLeft = tonumber(self:GetData("uses", maxUses)) or maxUses
        desc = desc .. "\n\nОсталось порций: " .. usesLeft .. "/" .. maxUses
    end

    return desc
end

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Горячая еда", Color(205, 170, 125))
    ix.util.PropertyDesc(tooltip, "Кулинарная основа", Color(180, 210, 140))
end

ITEM.functions.Use = {
    name = "Выпить",
    icon = "icon16/cup.png",

    OnRun = function(item)
        local client = item.player

        if not IsValid(client) then
            return false
        end

        client:EmitSound(item.sound or "items/battery_pickup.wav")
        ClampNeeds(client, item.hunger or 0, item.thirst or 0)
        ix.chat.Send(client, "iteminternal", "пьёт "..item.name..".", false)

        return ConsumePortion(item)
    end,

    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
