ITEM.name = "12x70 мм Картечь"
ITEM.description = "Коробка дробовых патронов 12x70 с картечью. Подходит для ружей, использующих боеприпас st_ammo_12x70_buck."
ITEM.base = "base_ammo"
ITEM.model = "models/wick/wrbstalker/anomaly/items/wick_ammo_12x76_zhekan.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Ammo"

-- Отдельный калибр/тип патронов для ST/TFA оружия.
ITEM.ammoType = "st_ammo_12x70_buck"
ITEM.ammoAmount = 16
ITEM.ammoBoxText = "Патроны 12 калибра с картечью для охотничьих и боевых ружей."

ITEM.functions.LoadAmmo = {
    name = "Зарядить",
    tip = "useTip",
    icon = "icon16/bullet_go.png",
    OnRun = function(item)
        local client = item.player
        if (not IsValid(client)) then return false end

        local ammoType = item.ammoType or "st_ammo_12x70_buck"
        local ammoID = game.GetAmmoID(ammoType)

        if (not ammoID or ammoID < 0) then
            client:Notify("Не найден ammoID для " .. tostring(ammoType))
            return false
        end

        local amount = tonumber(item.ammoAmount) or 16
        local before = client:GetAmmoCount(ammoID)

        client:SetAmmo(before + amount, ammoID)

        local after = client:GetAmmoCount(ammoID)
        client:Notify("Патроны " .. ammoType .. ": было " .. before .. ", стало " .. after)
        client:EmitSound("items/ammo_pickup.wav", 60)

        return true
    end,
    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
