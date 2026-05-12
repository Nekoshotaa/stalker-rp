ITEM.name = "5.45x39 мм FMJ"
ITEM.description = "Коробка автоматных патронов 5.45x39 FMJ. Подходит для AN-94, АКС-74У, АК-74 и другого оружия с тем же ammo type."
ITEM.base = "base_ammo"
ITEM.model = "models/kek1ch/ammo_545x39_fmj.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Ammo"
ITEM.ammoType = "ammo_545x39_fmj"
ITEM.ammoAmount = 60
ITEM.ammoBoxText = "Стандартные автоматные патроны 5.45x39."

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
