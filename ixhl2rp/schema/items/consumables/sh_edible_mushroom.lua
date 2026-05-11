ITEM.name = "Съедобный гриб"
ITEM.description = "Обычный лесной гриб. Не бог весть что, но голод немного утоляет."
ITEM.model = "models/alanfa/prop/warfarerp/grib_6.mdl"
ITEM.category = "Еда"
ITEM.price = 120
ITEM.width = 1
ITEM.height = 1
ITEM.sound = "stalkersound/inv_eat.mp3"
ITEM.hunger = 6
ITEM.thirst = -1

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Лёгкий перекус", Color(200, 220, 160))
end

ITEM.functions.Use = {
    name = "Съесть",
    icon = "icon16/cup.png",
    OnRun = function(item)
        local client = item.player
        if not IsValid(client) then return false end
        client:EmitSound(item.sound or "items/battery_pickup.wav")

        if client.GetHunger and client.SetHunger then
            client:SetHunger(math.Clamp((client:GetHunger() or 100) + (item.hunger or 0), 0, 100))
        end
        if client.GetThirst and client.SetThirst then
            client:SetThirst(math.Clamp((client:GetThirst() or 100) + (item.thirst or 0), 0, 100))
        end

        ix.chat.Send(client, "iteminternal", "eats a " .. item.name .. ".", false)
        return true
    end,
    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
