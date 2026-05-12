ITEM.name = "Armor"
ITEM.description = "An Armor Base."
ITEM.category = "Armor"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.armorAmount = 1
ITEM.resiAmount = 1
ITEM.height = 1
ITEM.outfitCategory = "model"
ITEM.gasmask = false
ITEM.resistance = false
ITEM.pacData = {}
ITEM.damage = {1, 1, 1, 1, 1, 1, 1}
ITEM.skillBoosts = {}

function ITEM:GetDescription()
	if (self.entity) then
		return L(self.description)
	else
        return L(self.description .. "\n \nСопротивление: \n  Пуленепробиваемый: " .. (self.damage[1]) .. "\n  Потрошение: " .. (self.damage[2]) .. "\n  Электричество: " .. (self.damage[3]) .. "\n  Горение: " .. (self.damage[4]) .. "\n  Радиация: " .. (self.damage[5]) .. "\n  Химическая: " .. (self.damage[6]) .. "\n  Шок: " .. (self.damage[7]))
	end
end

local function armorPlayer(client, target, amount)
	hook.Run("OnPlayerArmor", client, target, amount)

	if (IsValid(client) and IsValid(target) and client:Alive() and target:Alive()) then
		target:SetArmor(amount)
	end
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

function ITEM:RemoveOutfit(client)
	local character = client:GetCharacter()
			
	client:SetNetVar("gasmask", false)
	client:SetNetVar("resistance", false)

	armorPlayer(client, client, 0)

	self:SetData("equip", false)
	if (character:GetData("oldModel" .. self.outfitCategory)) then
		character:SetModel(character:GetData("oldModel" .. self.outfitCategory))
		character:SetData("oldModel" .. self.outfitCategory, nil)
	end

	if (self.newSkin) then
		if (character:GetData("oldSkin" .. self.outfitCategory)) then
			client:SetSkin(character:GetData("oldSkin" .. self.outfitCategory))
			character:SetData("oldSkin" .. self.outfitCategory, nil)
		else
			client:SetSkin(0)
		end
	end

	for k, _ in pairs(self.bodyGroups or {}) do
		local index = client:FindBodygroupByName(k)

		if (index > -1) then
			client:SetBodygroup(index, 0)

			local groups = character:GetData("groups" .. self.outfitCategory, {})

			if (groups[index]) then
				groups[index] = nil
				character:SetData("groups" .. self.outfitCategory, groups)
			end
		end
	end

	if (self.skillBoosts) then
		for skillID, _ in pairs(self.skillBoosts) do
			local baseValue = character:GetData("base_" .. skillID, 0)
			character:SetAttrib(skillID, baseValue)
			character:SetData("base_" .. skillID, nil)
		end
	end

	for k, _ in pairs(self:GetData("outfitAttachments", {})) do
		self:RemoveAttachment(k, client)
	end

	self:OnUnequipped()
end

function ITEM:AddAttachment(id)
	local attachments = self:GetData("outfitAttachments", {})
	attachments[id] = true

	self:SetData("outfitAttachments", attachments)
end

function ITEM:RemoveAttachment(id, client)
	local item = ix.item.instances[id]
	local attachments = self:GetData("outfitAttachments", {})

	if (item and attachments[id]) then
		item:OnDetached(client)
	end

	attachments[id] = nil
	self:SetData("outfitAttachments", attachments)
end

ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
		item:RemoveOutfit(item:GetOwner())
		armorPlayer(item.player, item.player, 0)
	end
end)

ITEM.functions.EquipUn = {
	name = "Снять",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		local client = item.player
		
		armorPlayer(client, client, 0)
		item:RemoveOutfit(client)
		
		client:SetNetVar("gasmask", false)
		client:SetNetVar("resistance", false)
		
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.Equip = {
	name = "Оборудовать одежду",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		local client = item.player
		local char = client:GetCharacter()
		local items = char:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (itemTable and itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
					client:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
					return false
				end
			end
		end

		item:SetData("equip", true)
		client:SetNetVar("gasmask", item.gasmask == true)
		client:SetNetVar("resistance", item.resistance == true)
		
		client:SetNWFloat("dmg_bullet", item.damage[1])
		client:SetNWFloat("dmg_slash", item.damage[2])
		client:SetNWFloat("dmg_shock", item.damage[3])
		client:SetNWFloat("dmg_burn", item.damage[4])
		client:SetNWFloat("dmg_radiation", item.damage[5])
		client:SetNWFloat("dmg_acid", item.damage[6])
		client:SetNWFloat("dmg_explosive", item.damage[7])
		
		client:EmitSound("snd_jack_clothequip.wav", 80)
		armorPlayer(client, client, item.armorAmount)

		if (type(item.OnGetReplacement) == "function") then
			char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, client:GetModel()))
			char:SetModel(item:OnGetReplacement())
		elseif (item.replacement or item.replacements) then
			char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, client:GetModel()))

			if (type(item.replacements) == "table") then
				if (#item.replacements == 2 and type(item.replacements[1]) == "string") then
					char:SetModel(client:GetModel():gsub(item.replacements[1], item.replacements[2]))
				else
					for _, v in ipairs(item.replacements) do
						char:SetModel(client:GetModel():gsub(v[1], v[2]))
					end
				end
			else
				char:SetModel(item.replacement or item.replacements)
			end
		end

		if (item.newSkin) then
			char:SetData("oldSkin" .. item.outfitCategory, client:GetSkin())
			client:SetSkin(item.newSkin)
		end

		if (item.bodyGroups) then
			local groups = {}

			for k, value in pairs(item.bodyGroups) do
				local index = client:FindBodygroupByName(k)

				if (index > -1) then
					groups[index] = value
				end
			end

			local newGroups = char:GetData("groups", {})

			for index, value in pairs(groups) do
				newGroups[index] = value
				client:SetBodygroup(index, value)
			end

			if (table.Count(newGroups) > 0) then
				char:SetData("groups", newGroups)
			end
		end

		if (item.skillBoosts) then
			for skillID, boostValue in pairs(item.skillBoosts) do
				local currentValue = char:GetAttribute(skillID, 0)
				char:SetData("base_" .. skillID, currentValue)
				char:SetAttrib(skillID, currentValue + boostValue)
			end
		end

		item:OnEquipped()
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and item:CanEquipOutfit() and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		return false
	end

	return true
end

function ITEM:OnRemoved()
	if (self.invID != 0 and self:GetData("equip")) then
		self.player = self:GetOwner()
		self:RemoveOutfit(self.player)
		self.player = nil
	end
end

function ITEM:OnEquipped()
end

function ITEM:OnUnequipped()
end

function ITEM:CanEquipOutfit()
	return true
end
