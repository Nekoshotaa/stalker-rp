ITEM.name = "7.62x54 мм 7Н1 (ST)"
ITEM.description = "Коробка винтовочных патронов 7.62x54 7Н1 для ST-оружия. Подходит для MP-44 и другого оружия с тем же ammo type."
ITEM.base = "base_ammo"
ITEM.model = "models/wick/wrbstalker/anomaly/items/wick_ammo_762x54_7h1_old.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Ammo"
ITEM.ammoType = "st_ammo_762x54_7h1"
ITEM.ammoAmount = 40
ITEM.ammoBoxText = "Винтовочные патроны 7.62x54 для ST-пака."

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
