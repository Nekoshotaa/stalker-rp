PLUGIN.name = "Revive"
PLUGIN.author = "OpenAI"
PLUGIN.description = "Downed / revive system with corpse timer and revive protection."

ix.temp = ix.temp or {}
ix.temp.Corpses = ix.temp.Corpses or {}

ix.config.Add("reviveOn", true, "If true revive mode will be active.", nil, {
	category = "Revive"
})

ix.config.Add("reviveRessurrectionTime", 3, "How long it takes to revive someone.", nil, {
	data = {min = 1, max = 60},
	category = "Revive"
})

ix.config.Add("reviveProtectionTime", 3, "How long revived players are protected after standing up.", nil, {
	data = {min = 0, max = 20},
	category = "Revive"
})

ix.config.Add("reviveDistance", 110, "Maximum distance to revive a body.", nil, {
	data = {min = 32, max = 256},
	category = "Revive"
})

local playerMeta = FindMetaTable("Player")

function playerMeta:IsDowned()
	local corpse = ix.temp and ix.temp.Corpses and ix.temp.Corpses[self]
	return IsValid(corpse) and corpse.isDeadBody
end

function playerMeta:GetDownedCorpse()
	local corpse = ix.temp and ix.temp.Corpses and ix.temp.Corpses[self]
	if IsValid(corpse) and corpse.isDeadBody then
		return corpse
	end
end

if CLIENT then
	surface.CreateFont("ixReviveText", {
		font = "Trebuchet MS",
		size = 24,
		weight = 700,
		antialias = true
	})

	surface.CreateFont("ixReviveTextSmall", {
		font = "Trebuchet MS",
		size = 18,
		weight = 500,
		antialias = true
	})

	hook.Add("HUDPaint", "ixRevive.DrawDeadPlayers", function()
		local client = LocalPlayer()
		if not IsValid(client) then return end
		if not client.GetCharacter or not client:GetCharacter() then return end

		for _, ragdoll in ipairs(ents.FindByClass("prop_ragdoll")) do
			if not (IsValid(ragdoll) and ragdoll.isDeadBody) then
				continue
			end

			if ragdoll.player == client then
				continue
			end

			if client:GetPos():Distance(ragdoll:GetPos()) > 512 then
				continue
			end

			local screenPos = (ragdoll:GetPos() + Vector(0, 0, 40)):ToScreen()
			local timeLeft = math.max(0, math.ceil((ragdoll:GetNWFloat("Time", CurTime())) - CurTime()))
			local nameText = IsValid(ragdoll.player) and ragdoll.player:Name() or "Неизвестный"
			local stateText = "Без сознания"
			local timerText = "До смерти: " .. timeLeft .. " сек."

			draw.SimpleTextOutlined(stateText, "ixReviveText", screenPos.x, screenPos.y - 18, Color(220, 90, 90), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			draw.SimpleTextOutlined(nameText, "ixReviveTextSmall", screenPos.x, screenPos.y + 2, Color(240, 240, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			draw.SimpleTextOutlined(timerText, "ixReviveTextSmall", screenPos.x, screenPos.y + 22, Color(255, 230, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		end
	end)

	netstream.Hook("ix_DeadBody", function(index)
		local ragdoll = Entity(index)

		if IsValid(ragdoll) then
			ragdoll.isDeadBody = true

			if ix.pac then
				ragdoll.RenderOverride = function()
					ragdoll.objCache = ragdoll:GetNetVar("player")
					ragdoll:DrawModel()
					hook.Run("DrawPlayerRagdoll", ragdoll)
				end
			end
		end
	end)

	function PLUGIN:PlayerButtonDown(ply, button)
		if not IsFirstTimePredicted() then return end
		if button ~= KEY_SPACE then return end
		if LocalPlayer():Alive() then return end

		timer.Simple(2.5, function()
			if IsValid(LocalPlayer()) and not LocalPlayer():Alive() and input.IsKeyDown(KEY_SPACE) then
				net.Start("ix_PleaseKillMe")
				net.SendToServer()
			end
		end)
	end
else
	util.AddNetworkString("ix_PleaseKillMe")

	local function FindSafeRevivePosition(client, corpse)
		if not IsValid(client) or not IsValid(corpse) then return end

		local basePos = corpse:GetPos() + Vector(0, 0, 8)
		client:SetPos(basePos)

		if not client:IsStuck() then
			return basePos
		end

		local positions = ix.util.FindEmptySpace(client, {corpse, client}) or {}

		for _, pos in ipairs(positions) do
			client:SetPos(pos)

			if not client:IsStuck() then
				return pos
			end
		end

		client:SetPos(basePos + Vector(0, 0, 16))
		return client:GetPos()
	end

	local function ApplyReviveProtection(client)
		if not IsValid(client) then return end

		local protectionTime = ix.config.Get("reviveProtectionTime", 3)
		if protectionTime <= 0 then return end

		client:SetNetVar("reviveProtectedUntil", CurTime() + protectionTime)

		timer.Simple(protectionTime, function()
			if IsValid(client) then
				client:SetNetVar("reviveProtectedUntil", nil)
			end
		end)
	end

	local function RevivePlayer(target, healer, health)
		if not IsValid(target) then return false, "Игрок не найден." end

		local corpse = target:GetDownedCorpse()
		if not IsValid(corpse) then
			return false, "Цель не находится без сознания."
		end

		target:UnSpectate()
		target:SetNetVar("resurrected", true)
		target:SetNetVar("deathTime", nil)
		target:Spawn()
		target:SetHealth(math.max(1, math.Round(health or 25)))

		FindSafeRevivePosition(target, corpse)
		ApplyReviveProtection(target)

		if IsValid(healer) and healer ~= target then
			healer:Notify("Вы подняли " .. target:Name() .. ".")
			target:Notify("Вас поднял " .. healer:Name() .. ".")
		elseif healer == target then
			target:Notify("Вы пришли в себя.")
		else
			target:Notify("Вы были подняты.")
		end

		return true
	end

	function PLUGIN:EntityTakeDamage(entity, dmgInfo)
		if not IsValid(entity) or not entity:IsPlayer() then return end

		local protectedUntil = entity:GetNetVar("reviveProtectedUntil", 0)
		if protectedUntil > CurTime() then
			dmgInfo:SetDamage(0)
			return true
		end
	end

	function PLUGIN:PlayerDisconnected(client)
		local corpse = client:GetDownedCorpse()

		if IsValid(corpse) then
			corpse:Remove()
		end

		ix.temp.Corpses[client] = nil
	end

	function PLUGIN:PlayerSpawn(client)
		client:UnSpectate()

		if not client:GetCharacter() then
			return
		end

		local corpse = client:GetDownedCorpse()

		if IsValid(corpse) then
			if not client:GetNetVar("resurrected") then
				hook.Run("DoDeathDrop", client, corpse:GetPos())
			end

			corpse:Remove()
			ix.temp.Corpses[client] = nil
			client:SetNetVar("resurrected", false)
		end
	end

	function PLUGIN:DoPlayerDeath(client, attacker, dmgInfo)
		if not ix.config.Get("reviveOn", true) then return end
		if not client:GetCharacter() then return end

		local oldCorpse = client:GetDownedCorpse()
		if IsValid(oldCorpse) then
			oldCorpse:Remove()
		end

		local corpse = ents.Create("prop_ragdoll")
		if not IsValid(corpse) then return end

		corpse:SetPos(client:GetPos())
		corpse:SetAngles(client:GetAngles())
		corpse:SetModel(client:GetModel())
		corpse:SetSkin(client:GetSkin())

		for _, group in pairs(client:GetBodyGroups()) do
			local current = client:GetBodygroup(group.id)
			corpse:SetBodygroup(group.id, current)
		end

		corpse:Spawn()
		corpse:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		corpse:SetNetVar("player", client)
		corpse:SetNWFloat("Time", CurTime() + ix.config.Get("spawnTime", 60))
		corpse:SetNWBool("Body", true)

		local phys = corpse:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceCenter(client:GetVelocity() * 15)
		end

		corpse.player = client
		corpse.isDeadBody = true

		ix.temp.Corpses[client] = corpse

		timer.Simple(0.2, function()
			if IsValid(corpse) then
				netstream.Start(nil, "ix_DeadBody", corpse:EntIndex())
			end
		end)

		client:Spectate(OBS_MODE_CHASE)
		client:SpectateEntity(corpse)
		client:Notify("Вы без сознания. До обычного респавна: " .. math.Round(ix.config.Get("spawnTime", 10)) .. " сек.")

		timer.Simple(0.01, function()
			local ragdoll = client:GetRagdollEntity()

			if IsValid(ragdoll) then
				ragdoll:Remove()
			end
		end)
	end

	net.Receive("ix_PleaseKillMe", function(_, client)
		if not IsValid(client) then return end
		if client:Alive() then return end

		client:SetNetVar("deathTime", CurTime())
	end)

	ix.command.Add("charrevive", {
		adminOnly = true,
		alias = {"revive", "resurrect"},
		description = "Поднять игрока из состояния без сознания и выдать ему HP. По умолчанию 25 HP.",
		arguments = {ix.type.string, bit.bor(ix.type.number, ix.type.optional)},
		OnRun = function(self, client, targetName, health)
			local target = ix.util.FindPlayer(targetName)
			if not IsValid(target) then
				return client:Notify("Цель не найдена.")
			end

			health = math.Round(tonumber(health) or 25)
			if health < 1 then
				return client:Notify("HP должно быть больше 0.")
			end

			local success, err = RevivePlayer(target, client, health)
			if not success then
				return client:Notify(err or "Не удалось поднять игрока.")
			end

			if target ~= client then
				client:Notify("Вы подняли " .. target:Name() .. ".")
			end
		end
	})

	function PLUGIN:CanPlayerUseReviveItem(healer, corpse)
		if not IsValid(healer) or not healer:IsPlayer() then
			return false, "Неверный игрок."
		end

		if not IsValid(corpse) or corpse:GetClass() ~= "prop_ragdoll" or not corpse.isDeadBody then
			return false, "Это не тело без сознания."
		end

		if healer:GetPos():Distance(corpse:GetPos()) > ix.config.Get("reviveDistance", 110) then
			return false, "Вы слишком далеко."
		end

		local target = corpse.player
		if not IsValid(target) then
			return false, "Нельзя поднять тело вышедшего игрока."
		end

		return true, target
	end

	function PLUGIN:UseReviveItem(healer, corpse, health, onComplete)
		local allowed, result = self:CanPlayerUseReviveItem(healer, corpse)
		if not allowed then
			return false, result
		end

		local target = result
		local reviveTime = ix.config.Get("reviveRessurrectionTime", 3)

		healer:SetAction("Поднимает игрока...", reviveTime)

		healer:DoStaredAction(corpse, function()
			if not IsValid(healer) then return end

			local stillAllowed, check = self:CanPlayerUseReviveItem(healer, corpse)
			if not stillAllowed then
				healer:Notify(check or "Поднять не удалось.")
				return
			end

			local success, err = RevivePlayer(target, healer, health or 25)
			if not success then
				healer:Notify(err or "Не удалось поднять игрока.")
				return
			end

			if isfunction(onComplete) then
				onComplete()
			end
		end, reviveTime, function()
			if IsValid(healer) then
				healer:SetAction()
				healer:Notify("Подъём прерван.")
			end
		end)

		return true
	end
end