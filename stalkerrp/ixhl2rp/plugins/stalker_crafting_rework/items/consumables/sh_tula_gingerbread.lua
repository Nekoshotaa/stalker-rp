ITEM.name = "Тульский пряник"
ITEM.description = "Тяжёлый сладкий пряник, собранный из простых лагерных запасов. Не роскошь, конечно, но на фоне обычной полевой кухни уже почти маленький праздник."
ITEM.model = "models/models/tyla.mdl"
ITEM.uniqueID = "food_tula_gingerbread"
ITEM.category = "Еда"

ITEM.width = 1
ITEM.height = 1
ITEM.price = 310
ITEM.weight = 0.25
ITEM.hunger = 20
ITEM.thirst = -2
ITEM.quantity = 1
ITEM.sound = "stalkersound/inv_eat_mutant_food.mp3"
ITEM.buffID = "buff_staminarestore"
ITEM.buffDuration = 90
ITEM.buffData = {
    amount = 1
}

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
    ix.util.PropertyDesc(tooltip, "Сладкая выпечка", Color(210, 180, 140))
    ix.util.PropertyDesc(tooltip, "+ слегка бодрит", Color(120, 200, 120))
end

ITEM.functions.Use = {
    name = "Съесть",
    icon = "icon16/cup.png",

    OnRun = function(item)
        local client = item.player
        if not IsValid(client) then
            return false
        end

        client:EmitSound(item.sound or "items/battery_pickup.wav")
        ClampNeeds(client, item.hunger or 0, item.thirst or 0)

        if client.AddBuff and item.buffID then
            client:AddBuff(item.buffID, item.buffDuration or 60, table.Copy(item.buffData or {}))
        end

        ix.chat.Send(client, "iteminternal", "ест "..item.name..".", false)
        return ConsumePortion(item)
    end,

    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
