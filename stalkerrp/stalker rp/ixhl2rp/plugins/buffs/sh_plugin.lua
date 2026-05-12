local PLUGIN = PLUGIN
PLUGIN.name = "Buffs and Debuffs"
PLUGIN.author = "Black Tea (NS 1.0), Neon (NS 1.1), verne (Helix)"
PLUGIN.desc = "Sometimes, You get sick or high. DrunkyBlur by Spy."
PLUGIN.buffs = PLUGIN.buffs or {}

local playerMeta = FindMetaTable("Player")

ix.util.Include("sh_buffs.lua")
ix.util.Include("sh_buffhooks.lua")
-- cl_hud.lua intentionally not included for now.

function playerMeta:GetBuffs()
	return self:GetNetVar("buffs") or {}
end

function playerMeta:HasBuff(strBuff)
	local buffs = self:GetNetVar("buffs")

	if buffs == nil then
		return false
	end

	return buffs[strBuff] or false
end

function PLUGIN:GetBuff(strBuff)
	return self.buffs[strBuff]
end

if SERVER then
	function playerMeta:AddBuff(strBuff, intDuration, parameter)
		if not isstring(strBuff) or strBuff == "" then
			return false
		end

		local tblBuffInfo = PLUGIN.buffs[strBuff]
		if not tblBuffInfo then
			return false
		end

		parameter = istable(parameter) and parameter or {}
		intDuration = tonumber(intDuration) or 0

		local expireTime = CurTime() + intDuration
		if intDuration < 0 then
			expireTime = math.huge
		end

		local tblBuffs = self:GetNetVar("buffs") or {}
		local alreadyHadBuff = tblBuffs[strBuff] ~= nil

		if tblBuffInfo.onbuffed and not alreadyHadBuff then
			tblBuffInfo.onbuffed(self, parameter)
		end

		tblBuffs[strBuff] = {expireTime, parameter}
		self:SetNetVar("buffs", tblBuffs)

		hook.Call("OnBuffed", GAMEMODE, self, strBuff, intDuration, parameter)
		return true
	end

	function playerMeta:RemoveBuff(strBuff, parameter)
		if not isstring(strBuff) or strBuff == "" then
			return false
		end

		local tblBuffs = self:GetNetVar("buffs") or {}
		local existingData = tblBuffs[strBuff]
		if not existingData then
			return false
		end

		local tblBuffInfo = PLUGIN.buffs[strBuff]
		local buffParameter = parameter
		if not istable(buffParameter) then
			buffParameter = istable(existingData[2]) and existingData[2] or {}
		end

		if tblBuffInfo and tblBuffInfo.ondebuffed then
			tblBuffInfo.ondebuffed(self, buffParameter)
		end

		tblBuffs[strBuff] = nil
		self:SetNetVar("buffs", tblBuffs)

		hook.Call("OnDebuffed", GAMEMODE, self, strBuff, buffParameter)
		return true
	end

	function PLUGIN:PlayerSpawn(client)
		client:SetNetVar("buffs", {})
	end

	function PLUGIN:Think()
		for _, client in ipairs(player.GetAll()) do
			if not (IsValid(client) and client:Alive()) then
				continue
			end

			local tblBuffs = client:GetNetVar("buffs") or {}

			for name, dat in pairs(tblBuffs) do
				local tblBuffInfo = self.buffs[name]

				if not istable(dat) then
					client:RemoveBuff(name)
					continue
				end

				if tblBuffInfo and tblBuffInfo.func then
					tblBuffInfo.func(client, istable(dat[2]) and dat[2] or {})
				end

				if tonumber(dat[1]) and dat[1] < CurTime() then
					client:RemoveBuff(name, dat[2])
				end
			end
		end
	end
else
	function PLUGIN:Think()
		for _, client in ipairs(player.GetAll()) do
			if not (IsValid(client) and client:Alive()) then
				continue
			end

			local tblBuffs = client:GetNetVar("buffs") or {}

			for name, dat in pairs(tblBuffs) do
				local tblBuffInfo = self.buffs[name]

				if tblBuffInfo and tblBuffInfo.cl_func then
					tblBuffInfo.cl_func(client, istable(dat) and (istable(dat[2]) and dat[2] or {}) or {})
				end
			end
		end
	end
end
