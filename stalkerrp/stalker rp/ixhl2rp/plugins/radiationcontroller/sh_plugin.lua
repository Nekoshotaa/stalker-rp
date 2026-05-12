local PLUGIN = PLUGIN
PLUGIN.name = "Radiation Controller"
PLUGIN.author = "verne / patched"
PLUGIN.desc = "Allows for randomly spawning radiation entities"

PLUGIN.radiationdefs = PLUGIN.radiationdefs or {}
PLUGIN.radiationpoints = PLUGIN.radiationpoints or {}

ix.util.Include("sh_radiationdefs.lua")

if SERVER then
	function PLUGIN:cleanRadiation()
		for _, ent in ipairs(ents.GetAll()) do
			if IsValid(ent) and string.StartWith(ent:GetClass(), "rad_") then
				ent:Remove()
			end
		end
	end

	function PLUGIN:spawnRadiation()
		for _, pointData in pairs(self.radiationpoints) do
			local position = pointData[1]
			local mask = tostring(pointData[2] or "")
			local selectedRadiation = {}

			if isvector(position) then
				for i = 1, #self.radiationdefs do
					if string.sub(mask, i, i) == "1" and self.radiationdefs[i] then
						table.insert(selectedRadiation, self.radiationdefs[i])
					end
				end

				local entity = #selectedRadiation > 0 and table.Random(selectedRadiation) or nil
				if not entity or entity.name == "Nil" or not entity.entityname then
					continue
				end

				local trace = util.TraceHull({
					start = position,
					endpos = position,
					mins = Vector(-16, -16, 0),
					maxs = Vector(16, 16, 71),
				})

				if IsValid(trace.Entity) then
					continue
				end

				local spawned = ents.Create(entity.entityname)
				if not IsValid(spawned) then
					continue
				end

				spawned:SetPos(position)
				spawned:Spawn()
			end
		end
	end

	function PLUGIN:LoadData()
		self.radiationpoints = self:GetData() or {}
		self:cleanRadiation()
		self:spawnRadiation()
	end

	function PLUGIN:SaveData()
		self:SetData(self.radiationpoints)
	end
else
	netstream.Hook("ix_DisplayRadiationPoints", function(data)
		for _, pointData in pairs(data or {}) do
			if not pointData[1] then continue end

			local emitter = ParticleEmitter(pointData[1])
			if not emitter then continue end

			local smoke = emitter:Add("sprites/glow04_noz", pointData[1])
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

ix.command.Add("radiationadd", {
	superAdminOnly = true,
	arguments = {ix.type.string},
	OnRun = function(self, client, radiation)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal * 5
		table.insert(PLUGIN.radiationpoints, {hitpos, radiation or "11111"})
		client:Notify("Radiation point successfully added")
	end
})

ix.command.Add("radiationremove", {
	superAdminOnly = true,
	arguments = {ix.type.number},
	OnRun = function(self, client, range)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal * 5
		range = tonumber(range) or 128
		local removed = 0

		for k, pointData in pairs(PLUGIN.radiationpoints) do
			if pointData[1] and pointData[1]:Distance(hitpos) <= range then
				PLUGIN.radiationpoints[k] = nil
				removed = removed + 1
			end
		end

		if removed > 0 then
			client:Notify(removed .. " radiation locations have been removed.")
		else
			client:Notify("No radiation spawn points found at location.")
		end
	end
})

ix.command.Add("radiationdisplay", {
	adminOnly = true,
	OnRun = function(self, client)
		if SERVER then
			netstream.Start(client, "ix_DisplayRadiationPoints", PLUGIN.radiationpoints)
			client:Notify("Displayed all points for 10 secs.")
		end
	end
})

ix.command.Add("radiationentremove", {
	adminOnly = true,
	arguments = {ix.type.number},
	OnRun = function(self, client, range)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal * 5
		range = tonumber(range) or 128
		local removed = 0

		for _, ent in pairs(ents.FindInSphere(hitpos, range)) do
			if IsValid(ent) and string.StartWith(ent:GetClass(), "rad_") then
				ent:Remove()
				removed = removed + 1
			end
		end

		if removed > 0 then
			client:Notify("Removed " .. removed .. " radiation entities.")
		else
			client:Notify("No radiation entities found at location.")
		end
	end
})
