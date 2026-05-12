local PLUGIN = PLUGIN
PLUGIN.name = "Better Armor"
PLUGIN.author = "Subleader and Alexgrist (Outfit base used)"
PLUGIN.desc = "Compatible with bad air and localized damage, plus it adds damage resistance"

ix.util.Include("cl_plugin.lua")

function PLUGIN:EntityTakeDamage(target, dmginfo)
	if (target:IsPlayer() and target:GetNetVar("resistance") == true) then
		if (dmginfo:IsDamageType(DMG_BULLET)) then
			dmginfo:ScaleDamage(target:GetNWFloat("dmg_bullet", 1))
		elseif (dmginfo:IsDamageType(DMG_SLASH)) then
			dmginfo:ScaleDamage(target:GetNWFloat("dmg_slash", 1))
		elseif (dmginfo:IsDamageType(DMG_SHOCK)) then
			dmginfo:ScaleDamage(target:GetNWFloat("dmg_shock", 1))
		elseif (dmginfo:IsDamageType(DMG_BURN)) then
			dmginfo:ScaleDamage(target:GetNWFloat("dmg_burn", 1))
		elseif (dmginfo:IsDamageType(DMG_RADIATION)) then
			dmginfo:ScaleDamage(target:GetNWFloat("dmg_radiation", 1))
		elseif (dmginfo:IsDamageType(DMG_ACID)) then
			dmginfo:ScaleDamage(target:GetNWFloat("dmg_acid", 1))
		elseif (dmginfo:IsExplosionDamage()) then
			dmginfo:ScaleDamage(target:GetNWFloat("dmg_explosive", 1))
		end
	end
end

ix.command.Add("Gasmask", {
	description = "Wear or unwear your gasmask.",
	adminOnly = false,
	OnRun = function(self, client)
		local character = client:GetCharacter()
		local inventory = character and character:GetInventory()
		if not inventory then return end

		for _, v in pairs(inventory:GetItems()) do
			if (v.base == "base_armor") and v:GetData("equip") and (v.gasmask == true) then
				if client:GetNetVar("gasmask") then
					client:SetNetVar("gasmask", false)
					client:Notify("Вы сняли противогаз.")
				else
					client:SetNetVar("gasmask", true)
					client:Notify("Вы надели противогаз.")
				end
				return
			end
		end

		client:Notify("На вас нет надетой брони с противогазом.")
	end
})
