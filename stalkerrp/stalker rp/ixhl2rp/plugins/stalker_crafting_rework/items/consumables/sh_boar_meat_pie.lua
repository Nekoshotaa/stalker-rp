ITEM.name = "Мясной пирог из мяса кабана"
ITEM.description = "Горячий мясной пирог, приготовленный на полевой печи. Хорошо насыщает и бодрит тело после тяжёлого перехода."
ITEM.model = "models/props/stalcraft/kotelokfood2.mdl"
ITEM.uniqueID = "food_boar_meat_pie"
ITEM.category = "Еда"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 320
ITEM.weight = 0.5
ITEM.hunger = 35
ITEM.thirst = -2
ITEM.quantity = 1
ITEM.sound = "stalkersound/inv_eat_mutant_food.mp3"
ITEM.buffID = "buff_staminarestore"
ITEM.buffDuration = 180
ITEM.buffData = {
    amount = 2
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

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Сытная еда", Color(205, 170, 125))
    ix.util.PropertyDesc(tooltip, "+ временное восстановление выносливости", Color(120, 200, 120))
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
        return true
    end,

    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
