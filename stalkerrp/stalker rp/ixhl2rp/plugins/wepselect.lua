PLUGIN.name = "Weapon Select"
PLUGIN.author = "gumlefar"
PLUGIN.description = "A reworked nutscript-style weapon select."

if (CLIENT) then
	PLUGIN.index = PLUGIN.index or 1
	PLUGIN.deltaIndex = PLUGIN.deltaIndex or PLUGIN.index
	PLUGIN.infoAlpha = PLUGIN.infoAlpha or 0
	PLUGIN.alpha = PLUGIN.alpha or 0
	PLUGIN.alphaDelta = PLUGIN.alphaDelta or PLUGIN.alpha
	PLUGIN.fadeTime = PLUGIN.fadeTime or 0

	function PLUGIN:LoadFonts(font, genericFont)
		surface.CreateFont("ixWeaponSelectFont", {
			font = font,
			size = ScreenScale(8),
			extended = true,
			weight = 500
		})
	end

	function PLUGIN:HUDShouldDraw(name)
		if (name == "CHudWeaponSelection") then
			return false
		end
	end

	function PLUGIN:GetSafeWeaponName(weapon)
		if (!IsValid(weapon)) then
			return "NONE"
		end

		local weaponName = weapon.GetPrintName and weapon:GetPrintName() or nil
		weaponName = weaponName or weapon.PrintName or weapon:GetClass() or "NONE"
		weaponName = tostring(weaponName)

		if (weaponName:sub(1, 1) == "#") then
			weaponName = language.GetPhrase(weaponName) or weaponName
		end

		if (weaponName.utf8upper) then
			weaponName = weaponName:utf8upper()
		else
			weaponName = string.upper(weaponName)
		end

		return weaponName
	end

	function PLUGIN:HUDPaint()
		local client = LocalPlayer()
		if (!IsValid(client) or !client:Alive()) then
			self.alpha = 0
			return
		end

		local frameTime = FrameTime()
		self.alphaDelta = Lerp(frameTime * 100, self.alphaDelta, self.alpha)

		local fraction = self.alphaDelta
		if (fraction <= 0.01) then
			return
		end

		local weapons, weaponCount = self:GetWeaponTable(client:GetWeapons())
		if (weaponCount <= 0) then
			self.alpha = 0
			return
		end

		self.index = math.Clamp(self.index or 1, 1, math.max(weaponCount, 1))
		self.deltaIndex = Lerp(frameTime * 12, self.deltaIndex or self.index, self.index)

		local x = ScrW() * 0.5
		local y = ScrH() * 0.5
		local shiftX = ScrW() * 0.02

		for i = 1, weaponCount do
			local color = ColorAlpha(i == self.index and ix.config.Get("color") or color_white, 255)
			local weapon = weapons[i]
			local weaponName = "[" .. i .. "] " .. self:GetSafeWeaponName(weapon)
			local selectedOffset = (i == self.index) and 15 or 5

			ix.util.DrawText(
				weaponName,
				selectedOffset + shiftX,
				ScrH() / 3 + (draw.GetFontHeight("ixWeaponSelectFont") * 1.5 * i),
				color,
				0,
				1,
				"ixWeaponSelectFont"
			)
		end

		if (self.fadeTime < CurTime() and self.alpha > 0) then
			self.alpha = 0
		end
	end

	function PLUGIN:OnIndexChanged(weapon)
		self.alpha = 1
		self.fadeTime = CurTime() + 5
		self.markup = nil

		local source, pitch = hook.Run("WeaponCycleSound")
		LocalPlayer():EmitSound(source or "common/talk.wav", 50, pitch or 180)
	end

	function PLUGIN:SelectFirstValidWeapon(weapons)
		for _, weapon in ipairs(weapons) do
			if (IsValid(weapon)) then
				LocalPlayer():EmitSound(hook.Run("WeaponSelectSound", weapon) or "stalkersound/inv_ruck.mp3", 75, 100, 0.5)
				input.SelectWeapon(weapon)
				return true
			end
		end

		return false
	end

	function PLUGIN:PlayerBindPress(client, bind, pressed)
		bind = string.lower(bind or "")

		if (!pressed or (!bind:find("invprev") and !bind:find("invnext") and !bind:find("slot") and !bind:find("attack"))) then
			return
		end

		local currentWeapon = client:GetActiveWeapon()
		local hasValidWeapon = IsValid(currentWeapon)
		local bTool = false

		if (client:InVehicle() or (hasValidWeapon and currentWeapon:GetClass() == "weapon_physgun" and client:KeyDown(IN_ATTACK))) then
			return
		end

		if (hasValidWeapon and currentWeapon:GetClass() == "gmod_tool") then
			local tool = client.GetTool and client:GetTool() or nil
			bTool = tool and (tool.Scroll != nil)
		end

		local weapons, weaponCount = self:GetWeaponTable(client:GetWeapons())
		if (weaponCount <= 0) then
			return
		end

		if (bind:find("invnext") and !bTool) then
			local oldIndex = self.index
			self.index = math.min((self.index or 1) + 1, weaponCount)

			if (self.alpha == 0 or oldIndex != self.index) then
				self:OnIndexChanged(weapons[self.index])
			end

			return true
		elseif (bind:find("invprev") and !bTool) then
			local oldIndex = self.index
			self.index = math.max((self.index or 1) - 1, 1)

			if (self.alpha == 0 or oldIndex != self.index) then
				self:OnIndexChanged(weapons[self.index])
			end

			return true
		elseif (bind:find("slot")) then
			self.index = math.Clamp(tonumber(bind:match("slot(%d)")) or 1, 1, weaponCount)
			self:OnIndexChanged(weapons[self.index])

			return true
		elseif (bind:find("attack") and self.alpha > 0) then
			local weapon = weapons[self.index]

			if (IsValid(weapon)) then
				LocalPlayer():EmitSound(hook.Run("WeaponSelectSound", weapon) or "stalkersound/inv_ruck.mp3", 75, 100, 0.5)
				input.SelectWeapon(weapon)
			else
				self:SelectFirstValidWeapon(weapons)
			end

			self.alpha = 0
			return true
		elseif (bind:find("attack") and !(self.alpha > 0)) then
			local activeWeapon = client:GetActiveWeapon()

			if (client:Alive() and IsValid(activeWeapon) and !client:IsWepRaised() and activeWeapon:GetClass() != "ix_hands") then
				net.Start("ixRequestWeaponRaise")
				net.SendToServer()
			end
		end
	end

	function PLUGIN:Think()
		local client = LocalPlayer()
		if (!IsValid(client) or !client:Alive()) then
			self.alpha = 0
		end
	end

	function PLUGIN:ScoreboardShow()
		self.alpha = 0
	end

	function PLUGIN:ShouldPopulateEntityInfo(entity)
		if (self.alpha > 0) then
			return false
		end
	end

	function PLUGIN:GetWeaponTable(weaponTable)
		local weapons = {}

		local ENGINE_SLOT_KNIFE = 1
		local ENGINE_SLOT_SECONDARY = 2
		local ENGINE_SLOT_PRIMARY = 3
		local ENGINE_SLOT_MISC = 4
		local handsSlot = 5
		local extraSlot = 6

		for i = 1, #weaponTable do
			local weapon = weaponTable[i]
			if (!IsValid(weapon)) then
				continue
			end

			if (weapon:GetClass() == "ix_hands") then
				weapons[handsSlot] = weapon
			elseif (weapon.Slot == ENGINE_SLOT_PRIMARY) then
				weapons[1] = weapon
			elseif (weapon.Slot == ENGINE_SLOT_SECONDARY) then
				weapons[2] = weapon
			elseif (weapon.Slot == ENGINE_SLOT_KNIFE) then
				weapons[3] = weapon
			elseif (weapon.Slot == ENGINE_SLOT_MISC) then
				weapons[4] = weapon
			else
				weapons[extraSlot] = weapon
				extraSlot = extraSlot + 1
			end
		end

		local compactWeapons = {}
		for i = 1, extraSlot - 1 do
			if (IsValid(weapons[i])) then
				table.insert(compactWeapons, weapons[i])
			end
		end

		return compactWeapons, #compactWeapons
	end
end

if (SERVER) then
	util.AddNetworkString("ixRequestWeaponRaise")

	net.Receive("ixRequestWeaponRaise", function(len, client)
		if (!IsValid(client) or !client:Alive()) then
			return
		end

		local activeWeapon = client:GetActiveWeapon()
		if (!IsValid(activeWeapon)) then
			return
		end

		if (client:IsRestricted() or client:InVehicle() or client:IsWepRaised() or activeWeapon:GetClass() == "ix_hands") then
			return
		end

		client:SetWepRaised(true)
		timer.Simple(0.25, function()
			if (IsValid(client) and client:Alive()) then
				client:SetNetVar("canShoot", true)
			end
		end)
	end)
end
