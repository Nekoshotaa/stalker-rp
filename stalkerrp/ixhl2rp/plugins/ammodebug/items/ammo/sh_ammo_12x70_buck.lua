ITEM.name = "12x70 мм Картечь"
ITEM.description = "Коробка дробовых патронов 12x70 с картечью. Подходит для ТОЗ-34, Обреза ТОЗ-66, Mossberg 590A1, Protecta, Remington 870, MP-133, Форт-500 и другого оружия с тем же ammo type."
ITEM.base = "base_ammo"
ITEM.model = "models/kek1ch/ammo_12x70_buck.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Ammo"
ITEM.ammoType = "ammo_12x70_buck"
ITEM.ammoAmount = 24
ITEM.ammoBoxText = "Стандартные дробовые патроны 12x70 с картечью."

ITEM.functions.LoadAmmo = {
    name = "Зарядить",
    tip = "useTip",
    icon = "icon16/bullet_go.png",
    OnRun = function(item)
        local client = item.player
        if (not IsValid(client)) then return false end

        local ammoID = game.GetAmmoID(item.ammoType)
        if (not ammoID or ammoID < 0) then
            client:Notify("Не найден ammoID для " .. tostring(item.ammoType))
            return false
        end

        local before = client:GetAmmoCount(ammoID)
        client:SetAmmo(before + item.ammoAmount, ammoID)
        local after = client:GetAmmoCount(ammoID)

        client:Notify("Патроны " .. item.ammoType .. ": было " .. before .. ", стало " .. after)
        client:EmitSound("items/ammo_pickup.wav", 60)
        return true
    end,
    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
