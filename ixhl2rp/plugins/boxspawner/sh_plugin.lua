local PLUGIN = PLUGIN

PLUGIN.name = "BoxSpawner"
PLUGIN.author = "gumlefar / edited"
PLUGIN.desc = "Spawns breakable loot containers at set locations"

PLUGIN.boxpoints = PLUGIN.boxpoints or {}

-- Быстрый тестовый таймер: раз в 90 секунд
PLUGIN.spawnrate = 90

-- Не спавнить рядом с игроками
PLUGIN.saferadius = 768

PLUGIN.boxtypes = {
	"ix_entbox",
	"ix_wood_entbox",
	"ix_paper_entbox",
}

PLUGIN.smallboxtypes = {
	"ix_entbox",
}

PLUGIN.bigboxtypes = {
	"ix_wood_entbox",
	"ix_paper_entbox",
}

ix.config.Add("boxSpawnerThreshold", 12, "How many loot containers should the controller keep on the map.", nil, {
	data = {min = 0, max = 100},
	category = "Spawning"
})

if SERVER then
	local nextSpawnTime = 1

	local function isClear(position)
		local currentents = ents.FindInSphere(position, PLUGIN.saferadius)

		for _, ent in pairs(currentents) do
			if IsValid(ent) and ent:IsPlayer() then
				return false
			end
		end

		local nearby = ents.FindInSphere(position, 32)

		for _, ent in pairs(nearby) do
			if not IsValid(ent) then continue end

			local class = ent:GetClass()

			if string.find(class, "entbox", 1, true) or string.find(class, "ix_item", 1, true) then
				return false
			end
		end

		return true
	end

	function PLUGIN:GetNumBoxes()
		local count = 0

		for _, className in pairs(self.boxtypes) do
			count = count + #ents.FindByClass(className)
		end

		return count
	end

	function PLUGIN:SpawnSingleBox(spawnData)
		if not istable(spawnData) then return false end

		local pos = spawnData[1]
		local boxTypeIndex = spawnData[2] or 1
		local customgroup = spawnData[3] or nil

		if not isvector(pos) then return false end
		if not isClear(pos) then return false end

		local boxtype

		if boxTypeIndex == 2 then
			boxtype = self.bigboxtypes[math.random(#self.bigboxtypes)]
		else
			boxtype = self.smallboxtypes[math.random(#self.smallboxtypes)]
		end

		if not boxtype then return false end

		local box = ents.Create(boxtype)
		if not IsValid(box) then return false end

		box.CustomSpawngroup = customgroup
		box:SetPos(pos)
		box:Spawn()
		box:PhysWake()

		return true
	end

	function PLUGIN:spawnBoxes(forceAmount)
		local maxBoxes = ix.config.Get("boxSpawnerThreshold", 12)
		local currentBoxes = self:GetNumBoxes()

		if currentBoxes >= maxBoxes then return end
		if not self.boxpoints or #self.boxpoints < 1 then return end

		local spawnLimit = forceAmount or math.random(1, 2)
		local spawned = 0

		for _, point in RandomPairs(self.boxpoints) do
			if currentBoxes >= maxBoxes then break end
			if spawned >= spawnLimit then break end

			if self:SpawnSingleBox(point) then
				currentBoxes = currentBoxes + 1
				spawned = spawned + 1
			end
		end
	end

	function PLUGIN:LoadData()
		self.boxpoints = self:GetData() or {}
	end

	function PLUGIN:SaveData()
		self:SetData(self.boxpoints)
	end

	function PLUGIN:Think()
		if nextSpawnTime > CurTime() then return end

		nextSpawnTime = CurTime() + self.spawnrate

		if self:GetNumBoxes() >= ix.config.Get("boxSpawnerThreshold", 12) then
			return
		end

		self:spawnBoxes()
	end
else
	netstream.Hook("nut_DisplaySpawnPoints", function(data)
		for _, v in pairs(data) do
			local emitter = ParticleEmitter(v[1])
			if not emitter then continue end

			local glow = emitter:Add("sprites/glow04_noz", v[1])
			if glow then
				glow:SetVelocity(Vector(0, 0, 1))
				glow:SetDieTime(10)
				glow:SetStartAlpha(255)
				glow:SetEndAlpha(255)
				glow:SetStartSize(64)
				glow:SetEndSize(64)
				glow:SetColor(255, 186, 50)
				glow:SetAirResistance(300)
			end

			emitter:Finish()
		end
	end)
end

ix.command.Add("boxspawnadd", {
	description = "Add a container spawn point where you are looking.",
	superAdminOnly = true,
	arguments = {
		ix.type.number,
		bit.bor(ix.type.string, ix.type.optional)
	},
	OnRun = function(self, client, boxtype, customgroup)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal * 5

		boxtype = boxtype or 1
		customgroup = customgroup or nil

		table.insert(PLUGIN.boxpoints, {hitpos, boxtype, customgroup})
		PLUGIN:SaveData()

		if customgroup then
			client:Notify("Container spawn point added. Type: " .. tostring(boxtype) .. ", group: " .. customgroup)
		else
			client:Notify("Container spawn point added. Type: " .. tostring(boxtype))
		end
	end
})

ix.command.Add("boxspawnremove", {
	description = "Remove container spawn points near where you are looking.",
	superAdminOnly = true,
	arguments = {
		bit.bor(ix.type.number, ix.type.optional)
	},
	OnRun = function(self, client, range)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal * 32
		range = tonumber(range) or 128

		local removed = 0

		for k, v in pairs(PLUGIN.boxpoints) do
			if isvector(v[1]) and v[1]:Distance(hitpos) <= range then
				PLUGIN.boxpoints[k] = nil
				removed = removed + 1
			end
		end

		if removed > 0 then
			PLUGIN:SaveData()
		end

		client:Notify(removed .. " container spawn point(s) removed.")
	end
})

ix.command.Add("boxspawndisplay", {
	description = "Display all container spawn points for 10 seconds.",
	adminOnly = true,
	OnRun = function(self, client)
		if SERVER then
			netstream.Start(client, "nut_DisplaySpawnPoints", PLUGIN.boxpoints)
			client:Notify("Displayed all container spawn points for 10 seconds.")
		end
	end
})

ix.command.Add("boxspawnforce", {
	description = "Force-spawn 1-2 containers immediately.",
	adminOnly = true,
	OnRun = function(self, client)
		if SERVER then
			PLUGIN:spawnBoxes(2)
			client:Notify("Forced container spawn.")
		end
	end
})

ix.command.Add("boxspawnclearall", {
	description = "Remove all saved container spawn points.",
	superAdminOnly = true,
	OnRun = function(self, client)
		PLUGIN.boxpoints = {}
		PLUGIN:SaveData()
		client:Notify("All container spawn points have been cleared.")
	end
})