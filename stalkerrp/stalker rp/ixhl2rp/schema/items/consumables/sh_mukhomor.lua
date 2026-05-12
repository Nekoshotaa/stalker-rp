ITEM.name = "Мухомор"
ITEM.description = "Яркий гриб с сомнительной пищевой ценностью. Есть его — плохая идея, но сталкеры всё равно экспериментируют."
ITEM.model = "models/alanfa/prop/warfarerp/grib_4.mdl"
ITEM.category = "Еда"
ITEM.price = 90
ITEM.width = 1
ITEM.height = 1
ITEM.sound = "stalkersound/inv_eat.mp3"
ITEM.hunger = 3
ITEM.thirst = -2
ITEM.alcohol = 8

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Сомнительная еда", Color(255, 180, 120))
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
        if client.IncreaseDrunkLevel then
            client:IncreaseDrunkLevel(item.alcohol or 0)
        end

        ix.chat.Send(client, "iteminternal", "eats a " .. item.name .. ".", false)
        return true
    end,
    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
