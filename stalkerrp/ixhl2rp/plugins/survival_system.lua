local PLUGIN = PLUGIN

PLUGIN.name = "Survival System"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "A survival system consisting of hunger and thirst."

--[[
	Настройки скорости голода/жажды.
	Чем БОЛЬШЕ число секунд, тем МЕДЛЕННЕЕ падает параметр.
	Было: голод 120 сек, жажда 90 сек.
	Сейчас сделано мягче: голод 300 сек, жажда 240 сек.
]]
PLUGIN.hungerTickTime = 300 -- раз в 5 минут снимает hungerTickAmount
PLUGIN.thirstTickTime = 240 -- раз в 4 минуты снимает thirstTickAmount
PLUGIN.hungerTickAmount = 1
PLUGIN.thirstTickAmount = 1

-- Урон от истощения можно отключить, если поставить false.
PLUGIN.enableSurvivalDamage = true

local playerMeta = FindMetaTable("Player")

if SERVER then
	function PLUGIN:OnCharacterCreated(client, character)
		character:SetData("hunger", 100)
		character:SetData("thirst", 100)
	end

	function PLUGIN:PlayerLoadedCharacter(client, character)
		timer.Simple(0.25, function()
			if not IsValid(client) or not character then return end

			client:SetLocalVar("hunger", character:GetData("hunger", 100))
			client:SetLocalVar("thirst", character:GetData("thirst", 100))
		end)

		timer.Simple(1, function()
			if not IsValid(client) then return end

			client:UpdateThirstState()
			client:UpdateHungerState()
		end)
	end

	function PLUGIN:CharacterPreSave(character)
		local client = character:GetPlayer()

		if (IsValid(client)) then
			character:SetData("hunger", client:GetLocalVar("hunger", 100))
			character:SetData("thirst", client:GetLocalVar("thirst", 100))
		end
	end

	function playerMeta:SetHunger(amount)
		local char = self:GetCharacter()
		if not char then return end

		amount = math.Clamp(tonumber(amount) or 100, 0, 100)

		char:SetData("hunger", amount)
		self:SetLocalVar("hunger", amount)
	end

	function playerMeta:SetThirst(amount)
		local char = self:GetCharacter()
		if not char then return end

		amount = math.Clamp(tonumber(amount) or 100, 0, 100)

		char:SetData("thirst", amount)
		self:SetLocalVar("thirst", amount)
	end

	function playerMeta:TickThirst(amount)
		local char = self:GetCharacter()
		if not char then return end

		amount = tonumber(amount) or 0
		local newValue = math.Clamp(char:GetData("thirst", 100) - amount, 0, 100)

		char:SetData("thirst", newValue)
		self:SetLocalVar("thirst", newValue)
		self:UpdateThirstState()
	end

	function playerMeta:TickHunger(amount)
		local char = self:GetCharacter()
		if not char then return end

		amount = tonumber(amount) or 0
		local newValue = math.Clamp(char:GetData("hunger", 100) - amount, 0, 100)

		char:SetData("hunger", newValue)
		self:SetLocalVar("hunger", newValue)
		self:UpdateHungerState()
	end

	function playerMeta:UpdateHungerState()
		-- пока оставляем пустым, чтобы не конфликтовать с другими плагинами скорости/экипировки
	end

	function playerMeta:UpdateThirstState()
		-- пока оставляем пустым, чтобы не конфликтовать с другими плагинами скорости/экипировки
	end

	function PLUGIN:PlayerTick(ply)
		if not IsValid(ply) or not ply:Alive() then return end
		if not ply.GetCharacter or not ply:GetCharacter() then return end

		-- Голод/жажда падают по настройкам сверху.
		if ply:GetNetVar("hungertick", 0) <= CurTime() then
			ply:SetNetVar("hungertick", CurTime() + (self.hungerTickTime or 300))
			ply:TickHunger(self.hungerTickAmount or 1)
		end

		if ply:GetNetVar("thirsttick", 0) <= CurTime() then
			ply:SetNetVar("thirsttick", CurTime() + (self.thirstTickTime or 240))
			ply:TickThirst(self.thirstTickAmount or 1)
		end

		local hunger = ply:GetHunger() or 100
		local thirst = ply:GetThirst() or 100

		-- Периодический урон от истощения
		if self.enableSurvivalDamage and ply:GetNetVar("survivalDamageTick", 0) <= CurTime() then
			local damage = 0
			local nextTick = 0

			-- жажда опаснее голода
			if thirst <= 0 then
				damage = damage + 5
				nextTick = 12
			elseif thirst <= 10 then
				damage = damage + 2
				nextTick = 18
			elseif thirst <= 20 then
				damage = damage + 1
				nextTick = 25
			end

			if hunger <= 0 then
				damage = damage + 3
				nextTick = math.min(nextTick > 0 and nextTick or 999, 15)
			elseif hunger <= 10 then
				damage = damage + 1
				nextTick = math.min(nextTick > 0 and nextTick or 999, 22)
			end

			if damage > 0 then
				ply:SetNetVar("survivalDamageTick", CurTime() + nextTick)

				local info = DamageInfo()
				info:SetDamage(damage)
				info:SetAttacker(game.GetWorld())
				info:SetInflictor(game.GetWorld())
				info:SetDamageType(DMG_GENERIC)

				ply:TakeDamageInfo(info)
			end
		end
	end
end

function playerMeta:GetHunger()
	local char = self:GetCharacter()

	if (char) then
		return char:GetData("hunger", 100)
	end

	return 100
end

function playerMeta:GetThirst()
	local char = self:GetCharacter()

	if (char) then
		return char:GetData("thirst", 100)
	end

	return 100
end

function PLUGIN:AdjustStaminaOffset(client, offset)
	local hunger = client:GetHunger() or 100
	local thirst = client:GetThirst() or 100
	local penalty = 0

	-- Жажда сильнее влияет на выносливость
	if thirst <= 0 then
		penalty = penalty + 3.0
	elseif thirst <= 15 then
		penalty = penalty + 2.2
	elseif thirst <= 30 then
		penalty = penalty + 1.6
	elseif thirst <= 50 then
		penalty = penalty + 0.8
	end

	if hunger <= 0 then
		penalty = penalty + 2.0
	elseif hunger <= 15 then
		penalty = penalty + 1.5
	elseif hunger <= 30 then
		penalty = penalty + 1.0
	elseif hunger <= 50 then
		penalty = penalty + 0.5
	end

	if penalty > 0 then
		return offset - penalty
	end

	return offset
end

function PLUGIN:HUDPaint()
	local lp = LocalPlayer()
	if (not IsValid(lp)) then return end
	if (not lp.GetCharacter or not lp:GetCharacter()) then return end
	if (not lp:Alive()) then return end
	if (ix.gui.characterMenu and ix.gui.characterMenu.IsVisible and ix.gui.characterMenu:IsVisible()) then return end
	if (ix.option.Get("disablehud", false)) then return end

	local hunger = math.Clamp(lp:GetHunger() or 100, 0, 100)
	local thirst = math.Clamp(lp:GetThirst() or 100, 0, 100)
	local xThirst = ScrW() * 0.84
	local xHunger = ScrW() * 0.82
	local y = ScrH() * 0.79
	local size = 48

	if ix.util and ix.util.DrawStatusIcon then
		ix.util.DrawStatusIcon("stalker/ui/thirst.png", thirst, xThirst, y)
		ix.util.DrawStatusIcon("stalker/ui/hunger.png", hunger, xHunger, y)
		return
	end

	local thirstMat = Material("stalker/ui/thirst.png", "smooth noclamp")
	local hungerMat = Material("stalker/ui/hunger.png", "smooth noclamp")
	surface.SetDrawColor(255, 255, 255, 235)
	surface.SetMaterial(hungerMat)
	surface.DrawTexturedRect(xHunger, y, size, size)
	surface.SetMaterial(thirstMat)
	surface.DrawTexturedRect(xThirst, y, size, size)

	draw.SimpleText(math.Round(hunger) .. "%", "DermaDefaultBold", xHunger + size / 2, y + size + 2, Color(230, 220, 170, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText(math.Round(thirst) .. "%", "DermaDefaultBold", xThirst + size / 2, y + size + 2, Color(170, 220, 255, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

ix.command.Add("charsetthirst", {
	adminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.number,
	},
	OnRun = function(self, client, target, thirst)
		target = ix.util.FindPlayer(target)
		thirst = tonumber(thirst)

		if not target then
			client:Notify("Invalid Target!")
			return
		end

		target:SetThirst(thirst)

		if client == target then
			client:Notify("You have set your thirst to " .. thirst)
		else
			client:Notify("You have set " .. target:Name() .. "'s thirst to " .. thirst)
			target:Notify(client:Name() .. " has set your thirst to " .. thirst)
		end

		target:UpdateThirstState()
	end
})

ix.command.Add("charsethunger", {
	adminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.number,
	},
	OnRun = function(self, client, target, hunger)
		target = ix.util.FindPlayer(target)
		hunger = tonumber(hunger)

		if not target then
			client:Notify("Invalid Target!")
			return
		end

		target:SetHunger(hunger)

		if client == target then
			client:Notify("You have set your hunger to " .. hunger)
		else
			client:Notify("You have set " .. target:Name() .. "'s hunger to " .. hunger)
			target:Notify(client:Name() .. " has set your hunger to " .. hunger)
		end

		target:UpdateHungerState()
	end
})