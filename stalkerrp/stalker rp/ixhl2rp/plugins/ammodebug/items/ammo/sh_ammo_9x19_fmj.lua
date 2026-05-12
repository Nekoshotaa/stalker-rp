ITEM.name = "9x19 мм FMJ"
ITEM.description = "Коробка патронов 9x19 FMJ. Подходит для ПП-2000, ПП-19-01 «Витязь» и другого оружия под 9x19."
ITEM.base = "base_ammo"
ITEM.model = "models/kek1ch/ammo_9x19_fmj.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Ammo"
ITEM.ammoType = "ammo_9x19_fmj"
ITEM.ammoAmount = 36
ITEM.ammoBoxText = "Стандартные патроны 9x19."

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
