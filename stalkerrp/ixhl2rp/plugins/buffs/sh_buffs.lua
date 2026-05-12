-- ЗАМЕНИ ЭТИМ ФАЙЛОМ СВОЙ plugins/buffs/sh_buffs.lua
-- Это твой текущий sh_buffs.lua + новый бафф buff_epinephrine.

--[[
	PLUGIN.buffs[ << string, Buff's Unique Name>> ] = {
		name = << string, Buff's Display Name>>,
		desc = << string, Buff's Description>>,
		nodisp = << boolean, Buff's Display Factor >>,
		func = << function, Buff's Think Function >>,
		onbuffed = << function, Buff's Function that executes on buffed >>,
		ondebuffed = << function, Buff's Function that executes on debuffed >>,
	}
]]--

local PLUGIN = PLUGIN

PLUGIN.buffs["buff_slowheal"] = {
	name = "Healing",
	desc = "You're healing.",
	func = function(player, parameter)
		parameter = parameter or {}
		player.timeNextHeal = player.timeNextHeal or CurTime()

		if player.timeNextHeal < CurTime() then
			player:SetHealth(math.Clamp(player:Health() + (parameter.amount or 1), 0, player:GetMaxHealth()))
			player.timeNextHeal = CurTime() + 1
		end
	end,
}

PLUGIN.buffs["buff_rapidheal"] = {
	name = "Healing",
	desc = "You're healing.",
	func = function(player, parameter)
		parameter = parameter or {}
		player.timeNextFastHeal = player.timeNextFastHeal or CurTime()

		if player.timeNextFastHeal < CurTime() then
			player:SetHealth(math.Clamp(player:Health() + (parameter.amount or 1), 0, player:GetMaxHealth()))
			player.timeNextFastHeal = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs["buff_staminarestore"] = {
	name = "Energy",
	desc = "You're restoring energy faster.",
	func = function(player, parameter)
		parameter = parameter or {}
		player.timeNextTickStam = player.timeNextTickStam or CurTime()

		if player.timeNextTickStam < CurTime() then
			player:SetLocalVar("stm", math.min(player:GetLocalVar("stm", 100) + (parameter.amount or 1), 100))
			player.timeNextTickStam = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs["buff_epinephrine"] = {
	name = "Epinephrine",
	desc = "You feel a violent burst of speed and energy.",
	func = function(player, parameter)
		-- Passive buff. Speed is applied in onbuffed.
	end,
	onbuffed = function(player, parameter)
		parameter = parameter or {}
		parameter.oldWalk = parameter.oldWalk or player:GetWalkSpeed()
		parameter.oldRun = parameter.oldRun or player:GetRunSpeed()
		parameter.walkBoost = parameter.walkBoost or 20
		parameter.runBoost = parameter.runBoost or 30

		player:SetWalkSpeed(parameter.oldWalk + parameter.walkBoost)
		player:SetRunSpeed(parameter.oldRun + parameter.runBoost)
	end,
	ondebuffed = function(player, parameter)
		parameter = parameter or {}
		if parameter.oldWalk then
			player:SetWalkSpeed(parameter.oldWalk)
		end
		if parameter.oldRun then
			player:SetRunSpeed(parameter.oldRun)
		end
	end,
}

PLUGIN.buffs["buff_radiationremoval"] = {
	name = "Antirad",
	desc = "You're becoming less radioactive.",
	func = function(player, parameter)
		parameter = parameter or {}
		player.timeNextTickRadRem = player.timeNextTickRadRem or CurTime()

		if player.timeNextTickRadRem < CurTime() then
			if isfunction(player.addRadiation) then
				player:addRadiation(-(parameter.amount or 1))
			end

			player.timeNextTickRadRem = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs["buff_psyheal"] = {
	name = "Psyheal",
	desc = "Your mind is clearing up.",
	func = function(player, parameter)
		parameter = parameter or {}
		player.timeNextTickPsyHeal = player.timeNextTickPsyHeal or CurTime()

		if player.timeNextTickPsyHeal < CurTime() then
			if isfunction(player.HealPsyHealth) then
				player:HealPsyHealth(parameter.amount or 1)
			end

			player.timeNextTickPsyHeal = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs["buff_radprotect"] = {
	name = "Radiation Protection",
	desc = "You're protected from radiation.",
	func = function(player, parameter)
		-- Passive buff. The actual effect is usually consumed elsewhere via HasBuff().
	end,
}

PLUGIN.buffs["buff_psysuppress"] = {
	name = "Psy Suppression",
	desc = "Psychic effects are suppressed.",
	func = function(player, parameter)
		-- Passive buff.
	end,
	onbuffed = function(player, parameter)
		player:SetNWBool("ix_psysuppressed", true)
	end,
	ondebuffed = function(player, parameter)
		player:SetNWBool("ix_psysuppressed", false)
	end,
}

PLUGIN.buffs["buff_psyblock"] = {
	name = "Psyblock",
	desc = "You're protected from psychic attacks.",
	func = function(player, parameter)
		-- Passive buff.
	end,
	onbuffed = function(player, parameter)
		parameter = parameter or {}
		player:SetNWFloat("ixflatpsyres", player:GetNWFloat("ixflatpsyres", 0) + (parameter.amount or 0))
	end,
	ondebuffed = function(player, parameter)
		parameter = parameter or {}
		player:SetNWFloat("ixflatpsyres", player:GetNWFloat("ixflatpsyres", 0) - (parameter.amount or 0))
	end,
}

PLUGIN.buffs["debuff_radiation"] = {
	name = "Radiation",
	desc = "You're becoming radioactive.",
	func = function(player, parameter)
		parameter = parameter or {}
		player.timeNextTickRad = player.timeNextTickRad or CurTime()

		if player.timeNextTickRad < CurTime() then
			if isfunction(player.addRadiation) then
				player:addRadiation(parameter.amount or 1)
			end

			player.timeNextTickRad = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs["debuff_psy"] = {
	name = "Psychic",
	desc = "You're becoming less sane.",
	func = function(player, parameter)
		parameter = parameter or {}
		player.timeNextTickPsyDmg = player.timeNextTickPsyDmg or CurTime()

		if player.timeNextTickPsyDmg < CurTime() then
			if isfunction(player.DamagePsyHealth) then
				player:DamagePsyHealth(parameter.amount or 1)
			end

			player.timeNextTickPsyDmg = CurTime() + 0.5
		end
	end,
}

PLUGIN.buffs["buff_hijump"] = {
	name = "High Jump",
	desc = "You can jump high.",
	func = function(player, parameter)
		-- Passive buff.
	end,
	onbuffed = function(player, parameter)
		parameter = parameter or {}
		local jumpval = ix.config.Get("jumpPower", 160) or 160
		if IsValid(player) and player.GetJumpPower then
			jumpval = player:GetJumpPower() > 0 and player:GetJumpPower() or jumpval
		end
		player:SetJumpPower(jumpval + (parameter.amount or 0))
	end,
	ondebuffed = function(player, parameter)
		local jumpval = ix.config.Get("jumpPower", 160) or 160
		player:SetJumpPower(jumpval)
	end,
}

PLUGIN.buffs["buff_lightningsprint"] = {
	name = "Lightning Sprint",
	desc = "You move quickly, but at what cost?",
	func = function(player, parameter)
		parameter = parameter or {}
		player.timeNextTickSpdDmg = player.timeNextTickSpdDmg or CurTime()

		if player:GetNetVar("brth", false) or player:Health() <= 10 then
			player:RemoveBuff("buff_lightningsprint")
			return
		end

		if player.timeNextTickSpdDmg < CurTime() then
			player:SetHealth(math.max(player:Health() - (parameter.dps or 1), 1))
			player:EmitSound("anomaly/electra_blast1.mp3", 70, 180)
			ParticleEffect("myasorubka_activated", player:GetPos(), Angle(0, 0, 0))
			player.timeNextTickSpdDmg = CurTime() + 1
		end
	end,
	onbuffed = function(player, parameter)
		if player:GetNetVar("brth", false) or player:Health() <= 10 then
			player:RemoveBuff("buff_lightningsprint")
			return
		end

		timer.Simple(0, function()
			if not IsValid(player) then return end
			local character = player:GetCharacter()
			if character and ix.weight and ix.weight.Update then
				ix.weight.Update(character)
			end
		end)
	end,
	ondebuffed = function(player, parameter)
		timer.Simple(0, function()
			if not IsValid(player) then return end
			local character = player:GetCharacter()
			if character and ix.weight and ix.weight.Update then
				ix.weight.Update(character)
			end
		end)
	end,
}
