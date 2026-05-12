local PLUGIN = PLUGIN

PLUGIN.name = "Ammo Debug"
PLUGIN.author = "OpenAI"
PLUGIN.description = "Adds a debug command for weapon ammo types and ammo item support."

ix.command.Add("DebugAmmo", {
    description = "Показывает тип патронов активного оружия.",
    adminOnly = false,
    OnRun = function(self, client)
        local wep = client:GetActiveWeapon()

        if (not IsValid(wep)) then
            client:Notify("Нет активного оружия.")
            return
        end

        local ammoID = wep:GetPrimaryAmmoType()
        local ammoName = "unknown"

        if (ammoID and ammoID >= 0) then
            ammoName = game.GetAmmoName(ammoID) or "unknown"
        end

        print("===== ix_debugammo =====")
        print("Weapon class: " .. tostring(wep:GetClass()))
        print("PrintName: " .. tostring(wep.PrintName or "unknown"))
        print("Primary ammo ID: " .. tostring(ammoID))
        print("Primary ammo name: " .. tostring(ammoName))
        print("Clip1: " .. tostring(wep:Clip1()))

        if (ammoID and ammoID >= 0) then
            print("Reserve ammo: " .. tostring(client:GetAmmoCount(ammoID)))
        else
            print("Reserve ammo: unknown")
        end

        if (wep.Primary) then
            print("SWEP Primary.Ammo: " .. tostring(wep.Primary.Ammo))
            print("SWEP Primary.ClipSize: " .. tostring(wep.Primary.ClipSize))
            print("SWEP Primary.DefaultClip: " .. tostring(wep.Primary.DefaultClip))
        end

        print("========================")
        client:Notify("Данные о патронах выведены в консоль сервера.")
    end
})


ix.command.Add("GiveTestAmmo", {
    description = "Выдаёт тестовые патроны для активного оружия.",
    adminOnly = false,
    arguments = {
        ix.type.number
    },
    OnRun = function(self, client, amount)
        local wep = client:GetActiveWeapon()

        if (not IsValid(wep)) then
            client:Notify("Нет активного оружия.")
            return
        end

        local ammoID = wep:GetPrimaryAmmoType()
        local ammoName = (ammoID and ammoID >= 0) and (game.GetAmmoName(ammoID) or "unknown") or "unknown"

        if (ammoID == nil or ammoID < 0 or ammoName == "unknown") then
            client:Notify("Не удалось определить ammo type.")
            return
        end

        local before = client:GetAmmoCount(ammoID)
        client:SetAmmo(before + amount, ammoID)
        local after = client:GetAmmoCount(ammoID)

        print("===== GiveTestAmmo =====")
        print("Weapon: " .. tostring(wep:GetClass()))
        print("Ammo ID: " .. tostring(ammoID))
        print("Ammo Name: " .. tostring(ammoName))
        print("Before: " .. tostring(before))
        print("After: " .. tostring(after))
        print("========================")

        client:Notify("Патроны " .. ammoName .. ": было " .. before .. ", стало " .. after)
    end
})