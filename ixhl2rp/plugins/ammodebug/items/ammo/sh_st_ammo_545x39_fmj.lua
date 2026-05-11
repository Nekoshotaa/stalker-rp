ITEM.name = "5.45x39 мм FMJ (ST)"
ITEM.description = "Коробка патронов 5.45x39 FMJ для ST-оружия. Подходит для АО-46 и другого оружия с тем же ammo type."
ITEM.base = "base_ammo"
ITEM.model = "models/wick/wrbstalker/anomaly/items/wick_ammo_545x39_fmj_old.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Ammo"
ITEM.ammoType = "st_ammo_545x39_fmj"
ITEM.ammoAmount = 60
ITEM.ammoBoxText = "Патроны 5.45x39 для ST-пака."

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
