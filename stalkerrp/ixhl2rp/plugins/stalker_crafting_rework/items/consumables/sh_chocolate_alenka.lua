ITEM.name = "Шоколадка «Алёнка»"
ITEM.description = "Сладкая плитка шоколада, чудом не исчезнувшая в чьём-то рюкзаке ещё на подходе к лагерю. Хороша и сама по себе, и как редкий ингредиент для выпечки."
ITEM.model = "models/models/alenka.mdl"
ITEM.uniqueID = "chocolate_alenka"
ITEM.category = "Ингредиенты"

ITEM.width = 1
ITEM.height = 1
ITEM.price = 140
ITEM.weight = 0.1
ITEM.hunger = 8
ITEM.thirst = -1
ITEM.sound = "stalkersound/inv_eat_mutant_food.mp3"


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
        ix.chat.Send(client, "iteminternal", "ест "..item.name..".", false)
        return true
    end,

    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
