ITEM.name = "Боеприпасы"
ITEM.description = "Базовый предмет боеприпасов."
ITEM.category = "Ammo"
ITEM.model = "models/items/boxsrounds.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.ammoType = "Pistol"
ITEM.ammoAmount = 20
ITEM.ammoBoxText = "Эта коробка содержит стандартные боеприпасы."

function ITEM:GetDescription()
    return string.format(
        "%s\n\nТип патронов: %s\nКоличество: %s\n\n%s",
        self.description,
        tostring(self.ammoType or "unknown"),
        tostring(self.ammoAmount or 0),
        tostring(self.ammoBoxText or "")
    )
end

ITEM.functions.LoadAmmo = {
    name = "Зарядить",
    tip = "useTip",
    icon = "icon16/bullet_go.png",
    OnRun = function(item)
        local client = item.player

        if (not IsValid(client)) then
            return false
        end

        local ammoType = tostring(item.ammoType or "")
        local ammoAmount = tonumber(item.ammoAmount) or 0

        if (ammoType == "" or ammoAmount <= 0) then
            client:Notify("У предмета неверно заданы патроны.")
            return false
        end

        local ammoID = game.GetAmmoID(ammoType)

        if (not ammoID or ammoID < 0) then
            client:Notify("Не найден ammoID для " .. ammoType)
            return false
        end

        local before = client:GetAmmoCount(ammoID)
        client:SetAmmo(before + ammoAmount, ammoID)
        local after = client:GetAmmoCount(ammoID)

        client:Notify("Патроны " .. ammoType .. ": было " .. before .. ", стало " .. after)
        client:EmitSound("items/ammo_pickup.wav", 60)

        return true
    end,
    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}