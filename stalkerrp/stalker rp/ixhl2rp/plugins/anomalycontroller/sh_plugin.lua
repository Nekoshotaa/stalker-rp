local PLUGIN = PLUGIN
PLUGIN.name = "Anomaly Controller"
PLUGIN.author = "gumlefar"
PLUGIN.desc = "Allows for randomly spawning anomaly entities"

PLUGIN.anomalydefs = PLUGIN.anomalydefs or {}
PLUGIN.anomalypoints = PLUGIN.anomalypoints or {}

ix.util.Include("sh_anomalydefs.lua")

ix.config.Add("artifactSpawnerThreshold", 6, "How many artifacts the anomaly spawner should keep the map populated with.", nil, {
	data = {min = 0, max = 50},
	category = "Spawning"
})

ix.config.Add("artifactSpawnerRate", 600, "How often the anomaly spawner attempts to create artifacts.", nil, {
	data = {min = 15, max = 3000},
	category = "Spawning"
})

ix.config.Add("artifactSpawnerChance", 8, "Chance for each anomaly field to try spawning an artifact each cycle.", nil, {
	data = {min = 0, max = 100},
	category = "Spawning"
})

ix.config.Add("artifactPointCooldown", 1500, "Cooldown in seconds before the same anomaly point can spawn another artifact.", nil, {
	data = {min = 60, max = 7200},
	category = "Spawning"
})

ix.config.Add("artifactPointNearbyLimit", 1, "Maximum number of temporary artifacts allowed near a single anomaly point.", nil, {
	data = {min = 0, max = 10},
	category = "Spawning"
})

ix.config.Add("artifactPointNearbyRadius", 256, "Radius used to count nearby temporary artifacts for a point.", nil, {
	data = {min = 64, max = 1024},
	category = "Spawning"
})

ix.config.Add("artifactPlayerBlockRadius", 300, "Do not spawn artifacts if a living player is this close to the point.", nil, {
	data = {min = 0, max = 2048},
	category = "Spawning"
})

ix.config.Add("artifactLifetime", 3000, "How long temporary artifacts stay on the map before being cleaned up.", nil, {
	data = {min = 0, max = 21600},
	category = "Spawning"
})

function PLUGIN:GetMapPoints()
	local map = game.GetMap()
	self.anomalypoints = self.anomalypoints or {}
	self.anomalypoints[map] = self.anomalypoints[map] or {}
	return self.anomalypoints[map]
end

function PLUGIN:GetAnomalyDefsByName()
	local defs = {}

	for i = 1, #self.anomalydefs do
		local data = self.anomalydefs[i]
		if istable(data) and isstring(data.entityname) and data.entityname ~= "" then
			defs[string.lower(data.entityname)] = data
		end
	end

	return defs
end

function PLUGIN:GetAnomalyNameList()
	local names = {}

	for i = 1, #self.anomalydefs do
		local data = self.anomalydefs[i]
		if istable(data) and isstring(data.entityname) and data.entityname ~= "" then
			table.insert(names, data.entityname)
		end
	end

	table.sort(names)
	return names
end

function PLUGIN:IsLegacyMaskFormat(value)
	if not isstring(value) then
		return false
	end

	return string.match(value, "^[01]+$") ~= nil
end

function PLUGIN:ParseAnomalySelection(input)
	if istable(input) then
		local selected = {}
		for _, name in ipairs(input) do
			if isstring(name) and name ~= "" then
				table.insert(selected, string.lower(string.Trim(name)))
			end
		end
		return selected
	end

	if not isstring(input) then
		return {}
	end

	local trimmed = string.Trim(input)
	if trimmed == "" then
		return {}
	end

	if string.lower(trimmed) == "all" then
		local selected = {}
		for i = 1, #self.anomalydefs do
			local data = self.anomalydefs[i]
			if istable(data) and isstring(data.entityname) and data.entityname ~= "" then
				table.insert(selected, string.lower(data.entityname))
			end
		end
		return selected
	end

	if self:IsLegacyMaskFormat(trimmed) then
		return trimmed
	end

	local selected = {}
	for token in string.gmatch(trimmed, "[^,]+") do
		local name = string.lower(string.Trim(token))
		if name ~= "" then
			table.insert(selected, name)
		end
	end

	return selected
end

function PLUGIN:GetSelectedAnomalies(rawSelection)
	local selectedAnoms = {}

	if self:IsLegacyMaskFormat(rawSelection) then
		for i = 1, #self.anomalydefs do
			if string.sub(rawSelection, i, i) == "1" and self.anomalydefs[i] then
				table.insert(selectedAnoms, self.anomalydefs[i])
			end
		end
		return selectedAnoms
	end

	if not istable(rawSelection) then
		return selectedAnoms
	end

	local defsByName = self:GetAnomalyDefsByName()
	local alreadyAdded = {}

	for _, rawName in ipairs(rawSelection) do
		local name = string.lower(string.Trim(tostring(rawName)))
		local data = defsByName[name]
		if data and not alreadyAdded[name] then
			table.insert(selectedAnoms, data)
			alreadyAdded[name] = true
		end
	end

	return selectedAnoms
end

if SERVER then
	local spawntime = 1

	local function getPointCooldownKey(pointIndex)
		return "artifactCooldown_" .. tostring(pointIndex)
	end

	function PLUGIN:Think()
		local points = self:GetMapPoints()
		if table.IsEmpty(points) then return end

		self:CleanupTemporaryArtifacts()

		if spawntime > CurTime() then return end

		spawntime = CurTime() + ix.config.Get("artifactSpawnerRate", 600)
		self:trySpawnArtifacts()
	end

	function PLUGIN:CleanupTemporaryArtifacts()
		local lifetime = ix.config.Get("artifactLifetime", 3000)
		if lifetime <= 0 then
			return
		end

		for _, ent in ipairs(ents.FindByClass("ix_item")) do
			if IsValid(ent) and ent.bTemporary and ent.bArtifact then
				local spawnedAt = ent.ixArtifactSpawnedAt or ent:GetNW2Float("ixArtifactSpawnedAt", 0)
				if spawnedAt > 0 and (spawnedAt + lifetime) <= CurTime() then
					ent:Remove()
				end
			end
		end
	end

	function PLUGIN:IsPlayerTooClose(position)
		local blockRadius = ix.config.Get("artifactPlayerBlockRadius", 300)
		if blockRadius <= 0 then
			return false
		end

		for _, client in ipairs(player.GetAll()) do
			if IsValid(client) and client:Alive() and client:GetMoveType() ~= MOVETYPE_NOCLIP then
				if client:GetPos():Distance(position) <= blockRadius then
					return true
				end
			end
		end

		return false
	end

	function PLUGIN:GetNumSpawnedArtifacts()
		local n = 0
		for _, ent in ipairs(ents.FindByClass("ix_item")) do
			if IsValid(ent) and ent.bTemporary and ent.bArtifact then
				n = n + 1
			end
		end
		return n
	end

	function PLUGIN:GetNumArtifactsNearPoint(position, radius)
		local n = 0
		radius = radius or ix.config.Get("artifactPointNearbyRadius", 256)

		for _, ent in ipairs(ents.FindInSphere(position, radius)) do
			if IsValid(ent) and ent:GetClass() == "ix_item" and ent.bTemporary and ent.bArtifact then
				n = n + 1
			end
		end

		return n
	end

	function PLUGIN:GetNearestAnomalyDefForPoint(point)
		if not istable(point) or not point[1] then
			return nil
		end

		local pointPos = point[1]
		local bestDistance = math.huge
		local bestDef

		for _, ent in ipairs(ents.FindInSphere(pointPos, math.max(point[2] or 128, 256))) do
			if IsValid(ent) and string.sub(ent:GetClass(), 1, 5) == "anom_" then
				for i = 1, #self.anomalydefs do
					local def = self.anomalydefs[i]
					if def and def.entityname == ent:GetClass() then
						local dist = ent:GetPos():Distance(pointPos)
						if dist < bestDistance then
							bestDistance = dist
							bestDef = def
						end
						break
					end
				end
			end
		end

		return bestDef
	end

	function PLUGIN:SelectArtifactFromDef(anomalyDef)
		if not istable(anomalyDef) then
			return nil
		end

		local rand = math.random(100)
		local pool

		if rand <= 70 then
			pool = anomalyDef.commonArtifacts or {}
		elseif rand <= 94 then
			pool = anomalyDef.rareArtifacts or {}
		else
			pool = anomalyDef.veryRareArtifacts or {}
		end

		if not istable(pool) or #pool == 0 then
			return nil
		end

		return table.Random(pool)
	end

	function PLUGIN:CanSpawnArtifactAtPoint(pointIndex, point)
		if not istable(point) or not point[1] then
			return false
		end

		if self:GetNumSpawnedArtifacts() >= ix.config.Get("artifactSpawnerThreshold", 6) then
			return false
		end

		local cooldownKey = getPointCooldownKey(pointIndex)
		point[4] = point[4] or {}
		local nextSpawnTime = point[4][cooldownKey] or 0
		if nextSpawnTime > CurTime() then
			return false
		end

		if self:IsPlayerTooClose(point[1]) then
			return false
		end

		local nearbyLimit = ix.config.Get("artifactPointNearbyLimit", 1)
		if nearbyLimit >= 0 and self:GetNumArtifactsNearPoint(point[1], ix.config.Get("artifactPointNearbyRadius", 256)) > nearbyLimit - 1 then
			return false
		end

		local trace = util.TraceHull({
			start = point[1],
			endpos = point[1] + Vector(0, 0, -64),
			mins = Vector(-32, -32, 0),
			maxs = Vector(32, 32, 32)
		})

		if IsValid(trace.Entity) and trace.Entity:GetClass() ~= "ix_storage" then
			return false
		end

		return true
	end

	function PLUGIN:trySpawnArtifacts()
		local points = self:GetMapPoints()

		for pointIndex, point in pairs(points) do
			if not self:CanSpawnArtifactAtPoint(pointIndex, point) then
				continue
			end

			if math.random(100) > ix.config.Get("artifactSpawnerChance", 8) then
				continue
			end

			if self:spawnArtifacts(pointIndex, point) then
				if self:GetNumSpawnedArtifacts() >= ix.config.Get("artifactSpawnerThreshold", 6) then
					return
				end
			end
		end
	end

	function PLUGIN:spawnArtifacts(pointIndex, point)
		if not istable(point) or not point[1] then
			return false
		end

		local anomalyDef = self:GetNearestAnomalyDefForPoint(point)
		if not anomalyDef then
			return false
		end

		local uniqueID = self:SelectArtifactFromDef(anomalyDef)
		if not uniqueID then
			return false
		end

		local spawnPos = point[1] + Vector(math.Rand(-8, 8), math.Rand(-8, 8), 20)
		local cooldownKey = getPointCooldownKey(pointIndex)
		point[4] = point[4] or {}

		ix.item.Spawn(uniqueID, spawnPos, function(item, ent)
			if item then
				item:SetData("bTemporary", true)
			end

			if IsValid(ent) then
				ent.bTemporary = true
				ent.bArtifact = true
				ent.ixArtifactSpawnedAt = CurTime()
				ent:SetNW2Float("ixArtifactSpawnedAt", ent.ixArtifactSpawnedAt)
			end

			point[4][cooldownKey] = CurTime() + ix.config.Get("artifactPointCooldown", 1500)
		end, AngleRand(), {})

		return true
	end

	function PLUGIN:cleanAnomalies()
		for _, ent in pairs(ents.GetAll()) do
			if IsValid(ent) and string.sub(ent:GetClass(), 1, 5) == "anom_" then
				ent:Remove()
			end
		end
	end

	function PLUGIN:spawnAnomalies()
		if CurTime() > 5 then
			spawntime = 1
		end

		local points = self:GetMapPoints()

		for k, point in pairs(points) do
			if not istable(point) or not point[1] or not point[2] or not point[3] then
				print("[AnomalyController] Invalid anomaly point #" .. tostring(k))
				continue
			end

			local selectedAnoms = self:GetSelectedAnomalies(point[3])

			if #selectedAnoms == 0 then
				print("[AnomalyController] Spawn point #" .. tostring(k) .. " has no valid anomaly definitions.")
				continue
			end

			local entity = table.Random(selectedAnoms)
			if not entity or not entity.entityname or not entity.interval or entity.interval <= 0 then
				print("[AnomalyController] Invalid anomaly selected at point #" .. tostring(k))
				continue
			end

			for i = 1, math.max(1, math.ceil(point[2] / entity.interval)) do
				local position = self:GetSpawnLocation(point[1], point[2])
				local trace = util.TraceHull({
					start = position,
					endpos = position,
					mins = Vector(-16, -16, 0),
					maxs = Vector(16, 16, 71)
				})

				if IsValid(trace.Entity) then
					continue
				end

				local spawnedent = ents.Create(entity.entityname)
				if not IsValid(spawnedent) then
					print("[AnomalyController] Failed to create entity: " .. tostring(entity.entityname))
					continue
				end

				spawnedent:SetPos(position)
				spawnedent:Spawn()
				spawnedent:DropToFloor()
			end
		end
	end

	function PLUGIN:LoadData()
		self.anomalypoints = self:GetData() or {}
		self:GetMapPoints()

		self:cleanAnomalies()
		self:spawnAnomalies()
	end

	function PLUGIN:SaveData()
		self:SetData(self.anomalypoints)
	end

	function PLUGIN:GetSpawnLocation(pos, radius)
		local tracegood = false
		local teleres
		local tracecnt = 0

		local firstTrace = util.TraceLine({
			start = pos + Vector(0, 0, 64),
			endpos = pos + Vector(0, 0, 512),
			mask = MASK_ALL,
			ignoreworld = false
		})

		repeat
			local trace = util.TraceHull({
				start = firstTrace.HitPos - Vector(0, 0, 64),
				endpos = pos + Vector(math.random(-radius, radius), math.random(-radius, radius), -400),
				mins = Vector(-32, -32, 0),
				maxs = Vector(32, 32, 64),
				mask = MASK_ALL,
				ignoreworld = false
			})

			if not trace.HitSky then
				tracegood = true
				teleres = trace.HitPos + (trace.HitNormal * 32)
			end

			tracecnt = tracecnt + 1

			if tracecnt > 50 then
				tracegood = true
				teleres = pos + Vector(0, 0, 64)
			end
		until tracegood

		return teleres
	end
else
	netstream.Hook("ix_DisplayAnomalyPoints", function(data)
		for _, point in pairs(data or {}) do
			if not istable(point) or not point[1] then
				continue
			end

			local emitter = ParticleEmitter(point[1])
			if not emitter then
				continue
			end

			local smoke = emitter:Add("sprites/glow04_noz", point[1])
			if smoke then
				smoke:SetVelocity(Vector(0, 0, 1))
				smoke:SetDieTime(10)
				smoke:SetStartAlpha(255)
				smoke:SetEndAlpha(255)
				smoke:SetStartSize(64)
				smoke:SetEndSize(64)
				smoke:SetColor(255, 186, 50)
				smoke:SetAirResistance(300)
			end

			emitter:Finish()
		end
	end)
end

ix.command.Add("anomalyadd", {
	superAdminOnly = true,
	arguments = {
		ix.type.number,
		ix.type.string
	},
	OnRun = function(self, client, radius, anomalies)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal * 5
		radius = radius or 128
		anomalies = anomalies or "all"

		if not isnumber(radius) or radius < 0 then
			return "@invalidArg", 2
		end

		local selection = PLUGIN:ParseAnomalySelection(anomalies)
		local selectedAnoms = PLUGIN:GetSelectedAnomalies(selection)

		if istable(selection) and #selectedAnoms == 0 then
			return "No valid anomaly names found. Use /anomalylist to see available anomalies."
		end

		table.insert(PLUGIN:GetMapPoints(), {hitpos, radius, selection, {}})
		PLUGIN:SaveData()

		if PLUGIN:IsLegacyMaskFormat(selection) then
			client:Notify("Anomaly point successfully added with legacy mask format.")
		else
			client:Notify("Anomaly point successfully added.")
		end
	end
})

ix.command.Add("anomalyremove", {
	superAdminOnly = true,
	arguments = {
		ix.type.number
	},
	OnRun = function(self, client, range)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal * 5
		range = range or 128
		local mt = 0
		local points = PLUGIN:GetMapPoints()

		for k, v in pairs(points) do
			if istable(v) and v[1] then
				local distance = v[1]:Distance(hitpos)
				if distance <= tonumber(range) then
					points[k] = nil
					mt = mt + 1
				end
			end
		end

		if mt > 0 then
			PLUGIN:SaveData()
			client:Notify(mt .. " anomaly locations has been removed.")
		else
			client:Notify("No anomaly spawn points found at location.")
		end
	end
})

ix.command.Add("anomalydisplay", {
	adminOnly = true,
	OnRun = function(self, client)
		if SERVER then
			netstream.Start(client, "ix_DisplayAnomalyPoints", PLUGIN:GetMapPoints())
			client:Notify("Displayed all points for 10 seconds.")
		end
	end
})

ix.command.Add("anomalyentremove", {
	adminOnly = true,
	arguments = {
		ix.type.number
	},
	OnRun = function(self, client, range)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal * 5
		range = range or 128
		local mt = 0

		for _, ent in pairs(ents.FindInSphere(hitpos, range)) do
			if IsValid(ent) and string.sub(ent:GetClass(), 1, 5) == "anom_" then
				ent:Remove()
				mt = mt + 1
			end
		end

		if mt > 0 then
			client:Notify("Removed " .. mt .. " anomalies.")
		else
			client:Notify("No anomalies found at location.")
		end
	end
})

ix.command.Add("anomalylist", {
	adminOnly = true,
	OnRun = function(self, client)
		local names = PLUGIN:GetAnomalyNameList()

		if #names == 0 then
			client:Notify("No anomaly definitions loaded.")
			return
		end

		client:Notify("Available anomalies: " .. table.concat(names, ", "))
		print("[AnomalyController] Available anomalies: " .. table.concat(names, ", "))
	end
})

ix.command.Add("cleananomalies", {
	adminOnly = true,
	OnRun = function(self, client)
		ix.plugin.list["anomalycontroller"]:cleanAnomalies()
		client:Notify("All anomalies have been cleaned up from the map.")
	end
})

ix.command.Add("spawnanomalies", {
	adminOnly = true,
	OnRun = function(self, client)
		ix.plugin.list["anomalycontroller"]:spawnAnomalies()
		client:Notify("Spawned anomalies on points (if any).")
	end
})
