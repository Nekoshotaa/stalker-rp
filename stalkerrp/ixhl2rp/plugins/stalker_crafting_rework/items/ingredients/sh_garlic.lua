ITEM.name = "Чеснок"
ITEM.description = "Пучок крепкого чеснока. Сам по себе не особо сытный, но отлично подходит для готовки."
ITEM.model = "models/props/stalcraft/chesnok.mdl"
ITEM.uniqueID = "garlic"
ITEM.category = "Ингредиенты"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 90
ITEM.weight = 0.1
ITEM.hunger = 2
ITEM.thirst = -1
ITEM.sound = "stalkersound/inv_eat.mp3"

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

local function HasEquippedPlagueSuit(client)
    local char = client:GetCharacter()
    if not char then
        return false
    end

    local inv = char:GetInventory()
    if not inv then
        return false
    end

    for _, item in pairs(inv:GetItems()) do
        if item.uniqueID == "plague_marauder_suit" and item:GetData("equip", false) == true then
            return true
        end
    end

    return false
end

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Ингредиент", Color(180, 210, 140))
    ix.util.PropertyDesc(tooltip, "Можно съесть", Color(210, 180, 140))
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

        if HasEquippedPlagueSuit(client) then
            client:SetHealth(math.min(client:Health() + 5, client:GetMaxHealth()))
            client:Notify("Чеснок бодрит организм. Вы восстановили 5 здоровья.")
        end

        ix.chat.Send(client, "iteminternal", "ест "..item.name..".", false)
        return true
    end,

    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
