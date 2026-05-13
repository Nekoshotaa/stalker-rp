local PLUGIN = PLUGIN

PLUGIN.name = "NPC Spawner"
PLUGIN.author = "OpenAI"
PLUGIN.description = "Spawner for ambient and mutant NPCs."

PLUGIN.spawnpoints = PLUGIN.spawnpoints or {}
PLUGIN.spawnedNPCs = PLUGIN.spawnedNPCs or {}
PLUGIN.pointCooldowns = PLUGIN.pointCooldowns or {}

ix.config.Add("spawner_enabled", true, "Включить или выключить NPC спавнер.", nil, {
	category = "NPC Spawner"
})

ix.config.Add("npc_spawnrate", 45, "Как часто спавнер пытается создать NPC.", nil, {
	data = {min = 5, max = 84600},
	category = "NPC Spawner"
})

ix.config.Add("npc_spawn_player_distance", 1400, "Минимальная дистанция от игрока до точки спавна.", nil, {
	data = {min = 128, max = 5000},
	category = "NPC Spawner"
})

ix.config.Add("npc_spawn_point_cooldown", 120, "Кулдаун одной точки после спавна.", nil, {
	data = {min = 0, max = 3600},
	category = "NPC Spawner"
})

ix.config.Add("npc_spawn_limit_total", 12, "Общий лимит живых NPC от спавнера.", nil, {
	data = {min = 1, max = 200},
	category = "NPC Spawner"
})

ix.config.Add("npc_spawn_limit_mutants", 8, "Лимит мутантов от спавнера.", nil, {
	data = {min = 1, max = 200},
	category = "NPC Spawner"
})

PLUGIN.spawngroups = {
	["default"] = {
		"npc_crow",
		"npc_pigeon",
		"npc_seagull"
	},

	-- Отдельные группы мутантов.
	-- Теперь точка спавна не выбирает "солянку" из разных видов,
	-- а всегда создаёт только конкретный тип мутанта.
	["mutant_dog"] = {
		"vj_mutant_dog"
	},

	["mutant_boar"] = {
		"vj_mutant_boar"
	},

	["mutant_cat"] = {
		"vj_mutant_cat"
	},

	["mutant_flesh"] = {
		"vj_mutant_flesh"
	},

	["mutant_izlom"] = {
		"vj_mutant_izlom"
	},

	["mutant_psevdodog"] = {
		"vj_mutant_psevdodog"
	},

	["mutant_tushkan"] = {
		"vj_mutant_tushkan"
	}
}
local function IsMutantClass(class)
	return isstring(class) and string.StartWith(class, "vj_mutant_")
end

local function CleanupSpawnedNPCs()
	for k = #PLUGIN.spawnedNPCs, 1, -1 do
		local ent = PLUGIN.spawnedNPCs[k]

		if (not IsValid(ent)) then
			table.remove(PLUGIN.spawnedNPCs, k)
		elseif (ent:Health() <= 0) then
			table.remove(PLUGIN.spawnedNPCs, k)
		end
	end
end

local function CountSpawnedMutants()
	local count = 0

	for _, ent in ipairs(PLUGIN.spawnedNPCs) do
		if IsValid(ent) and IsMutantClass(ent:GetClass()) then
			count = count + 1
		end
	end

	return count
end

local function IsPlayerNear(pos, minDistance)
	local minDistanceSqr = minDistance * minDistance

	for _, client in ipairs(player.GetAll()) do
		if not IsValid(client) then
			continue
		end

		if not client:Alive() then
			continue
		end

		if client:GetMoveType() == MOVETYPE_NOCLIP then
			continue
		end

		if client:GetPos():DistToSqr(pos) <= minDistanceSqr then
			return true
		end
	end

	return false
end

local function IsSpawnAreaBlocked(pos)
	local tr = util.TraceHull({
		start = pos + Vector(0, 0, 8),
		endpos = pos + Vector(0, 0, 8),
		mins = Vector(-18, -18, 0),
		maxs = Vector(18, 18, 72),
		mask = MASK_SOLID_BRUSHONLY
	})

	if tr.Hit then
		return true
	end

	for _, ent in ipairs(ents.FindInSphere(pos, 48)) do
		if IsValid(ent) and (ent:IsNPC() or ent:IsPlayer() or ent:GetClass() == "prop_ragdoll") then
			return true
		end
	end

	return false
end

local function GetRandomPointFromGroup(groupName)
	local validPoints = {}
	local cooldown = ix.config.Get("npc_spawn_point_cooldown", 120)

	for index, data in ipairs(PLUGIN.spawnpoints) do
		local pos = data[1]
		local group = data[2] or "default"
		local nextUse = PLUGIN.pointCooldowns[index] or 0

		if group == groupName and nextUse <= CurTime() then
			table.insert(validPoints, {index = index, pos = pos, group = group})
		end
	end

	if #validPoints == 0 then
		return nil
	end

	return table.Random(validPoints)
end

if SERVER then
	local nextSpawnThink = 0

	local function SpawnFromPoint(pointData)
		if not pointData then return false end

		local index = pointData.index
		local pos = pointData.pos
		local group = pointData.group or "default"
		local minPlayerDistance = ix.config.Get("npc_spawn_player_distance", 1400)
		local groupTable = PLUGIN.spawngroups[group] or PLUGIN.spawngroups["default"]

		if not istable(groupTable) or #groupTable == 0 then
			return false
		end

		if IsPlayerNear(pos, minPlayerDistance) then
			return false
		end

		if IsSpawnAreaBlocked(pos) then
			return false
		end

		local class = table.Random(groupTable)
		if not isstring(class) or class == "" then
			return false
		end

		local totalLimit = ix.config.Get("npc_spawn_limit_total", 12)
		local mutantLimit = ix.config.Get("npc_spawn_limit_mutants", 8)

		CleanupSpawnedNPCs()

		if #PLUGIN.spawnedNPCs >= totalLimit then
			return false
		end

		if IsMutantClass(class) and CountSpawnedMutants() >= mutantLimit then
			return false
		end

		local ent = ents.Create(class)
		if not IsValid(ent) then
			return false
		end

		ent:SetPos(pos + Vector(0, 0, 12))
		ent:SetAngles(Angle(0, math.random(0, 359), 0))
		ent.ixSpawner = true
		ent.ixSpawnerGroup = group
		ent.ixSpawnerIndex = index
		ent:Spawn()
		ent:Activate()

		table.insert(PLUGIN.spawnedNPCs, ent)
		PLUGIN.pointCooldowns[index] = CurTime() + ix.config.Get("npc_spawn_point_cooldown", 120)

		return true
	end

	function PLUGIN:Think()
		if not ix.config.Get("spawner_enabled", true) then return end
		if nextSpawnThink > CurTime() then return end

		nextSpawnThink = CurTime() + ix.config.Get("npc_spawnrate", 45)

		CleanupSpawnedNPCs()

		if #self.spawnpoints <= 0 then return end

		local weightedGroups = {
			"mutant_dog",
			"mutant_dog",
			"mutant_tushkan",
			"mutant_cat",
			"mutant_flesh",
			"mutant_boar",
			"mutant_psevdodog",
			"mutant_izlom",
			"default"
		}

		local chosenGroup = table.Random(weightedGroups)
		local point = GetRandomPointFromGroup(chosenGroup)

		if not point then
			local fallbackGroups = {
				"mutant_dog",
				"mutant_tushkan",
				"mutant_cat",
				"mutant_flesh",
				"mutant_boar",
				"mutant_psevdodog",
				"mutant_izlom",
				"default"
			}

			for _, groupName in ipairs(fallbackGroups) do
				point = GetRandomPointFromGroup(groupName)

				if point then
					break
				end
			end
		end

		if point then
			SpawnFromPoint(point)
		end
	end

	function PLUGIN:OnNPCKilled(npc)
		if not IsValid(npc) or not npc.ixSpawner then return end

		CleanupSpawnedNPCs()
	end

	function PLUGIN:EntityRemoved(ent)
		if not IsValid(ent) or not ent.ixSpawner then return end

		timer.Simple(0, function()
			CleanupSpawnedNPCs()
		end)
	end

	function PLUGIN:LoadData()
		self.spawnpoints = self:GetData() or {}
		self.pointCooldowns = {}
	end

	function PLUGIN:SaveData()
		self:SetData(self.spawnpoints or {})
	end
else
	netstream.Hook("ixDisplayNPCSpawnPoints", function(data)
		for _, v in ipairs(data or {}) do
			local pos = v[1]
			local emitter = ParticleEmitter(pos)

			if emitter then
				local glow = emitter:Add("sprites/glow04_noz", pos)
				if glow then
					glow:SetVelocity(Vector(0, 0, 1))
					glow:SetDieTime(10)
					glow:SetStartAlpha(255)
					glow:SetEndAlpha(255)
					glow:SetStartSize(48)
					glow:SetEndSize(48)
					glow:SetColor(255, 80, 80)
					glow:SetAirResistance(300)
				end

				emitter:Finish()
			end
		end
	end)
end

ix.command.Add("npcspawnadd", {
	adminOnly = true,
	syntax = "<group>",
	arguments = {ix.type.text},
	OnRun = function(self, client, groupName)
		local trace = client:GetEyeTraceNoCursor()
		local hitPos = trace.HitPos + trace.HitNormal * 5
		local group = groupName or "default"

		if not PLUGIN.spawngroups[group] then
			client:Notify("Группа '" .. tostring(group) .. "' не найдена.")
			return
		end

		table.insert(PLUGIN.spawnpoints, {hitPos, group})
		PLUGIN:SaveData()

		client:Notify("Точка спавна добавлена. Группа: " .. group)
	end
})

ix.command.Add("npcspawnremove", {
	adminOnly = true,
	syntax = "[radius]",
	arguments = {bit.bor(ix.type.number, ix.type.optional)},
	OnRun = function(self, client, radius)
		local trace = client:GetEyeTraceNoCursor()
		local hitPos = trace.HitPos + trace.HitNormal * 5
		local removeRadius = math.max(tonumber(radius) or 128, 1)
		local removed = 0

		for i = #PLUGIN.spawnpoints, 1, -1 do
			local data = PLUGIN.spawnpoints[i]
			local pos = data[1]

			if pos:DistToSqr(hitPos) <= (removeRadius * removeRadius) then
				table.remove(PLUGIN.spawnpoints, i)
				removed = removed + 1
			end
		end

		PLUGIN:SaveData()
		client:Notify("Удалено точек спавна: " .. removed)
	end
})

ix.command.Add("npcspawndisplay", {
	adminOnly = true,
	OnRun = function(self, client)
		if SERVER then
			netstream.Start(client, "ixDisplayNPCSpawnPoints", PLUGIN.spawnpoints or {})
			client:Notify("Точки спавна показаны на 10 секунд.")
		end
	end
})

ix.command.Add("npcspawntoggle", {
	adminOnly = true,
	OnRun = function(self, client)
		local enabled = ix.config.Get("spawner_enabled", true)
		ix.config.Set("spawner_enabled", not enabled)

		if enabled then
			client:Notify("NPC спавнер выключен.")
		else
			client:Notify("NPC спавнер включён.")
		end
	end
})

ix.command.Add("npcspawngroups", {
	adminOnly = true,
	OnRun = function(self, client)
		local groups = {}

		for groupName, npcList in pairs(PLUGIN.spawngroups) do
			table.insert(groups, groupName .. " (" .. #npcList .. ")")
		end

		table.sort(groups)
		client:Notify("Группы: " .. table.concat(groups, ", "))
	end
})

ix.command.Add("npcspawnclear", {
	adminOnly = true,
	OnRun = function(self, client)
		local removed = 0

		for i = #PLUGIN.spawnedNPCs, 1, -1 do
			local ent = PLUGIN.spawnedNPCs[i]

			if IsValid(ent) then
				ent:Remove()
				removed = removed + 1
			end

			table.remove(PLUGIN.spawnedNPCs, i)
		end

		client:Notify("Удалено заспавненных NPC: " .. removed)
	end
})