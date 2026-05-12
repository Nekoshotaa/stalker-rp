ITEM.name = "Geiger Counter"
ITEM.description = "A personal geiger counter that measures local radiation levels."
ITEM.model = "models/lostsignalproject/items/devices/geiger.mdl"
ITEM.category = "Electronics"

ITEM.width = 1
ITEM.height = 1
ITEM.price = 650
ITEM.flatweight = 0.460

ITEM.isGeiger = true

ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(0, 0, 200),
	ang = Angle(90, 0, -180),
	fov = 2.1,
}

ITEM.equipIcon = ix.util.GetMaterial("materials/vgui/ui/stalker/misc/equip.png")

if CLIENT then
	function ITEM:PaintOver(item, w, h)
		surface.SetDrawColor(item:GetData("equip") and Color(110, 255, 110) or Color(255, 110, 110))
		surface.SetMaterial(item.equipIcon)
		surface.DrawTexturedRect(w - 23, h - 23, 19, 19)
	end
end

function ITEM:PopulateTooltip(tooltip)
	if not self.entity then
		ix.util.PropertyDesc2(tooltip, "Geiger Counter", Color(64, 224, 208), Material("vgui/ui/stalker/weaponupgrades/handling.png"))
	end
end

ITEM.functions.Equip = {
	name = "Attach to Belt",
	tip = "useTip",
	icon = "icon16/stalker/equip.png",
	sound = "stalkersound/inv_dozimetr.ogg",
	OnRun = function(item)
		item:Equip(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		return not IsValid(item.entity)
			and IsValid(client)
			and item:GetData("equip") ~= true
			and hook.Run("CanPlayerUnequipItem", client, item) ~= false
			and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.EquipUn = {
	name = "Detach from Belt",
	tip = "equipTip",
	icon = "icon16/stalker/unequip.png",
	OnRun = function(item)
		item:UnEquip(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		return not IsValid(item.entity)
			and IsValid(client)
			and item:GetData("equip") == true
			and hook.Run("CanPlayerUnequipItem", client, item) ~= false
			and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

function ITEM:Equip(client)
	local char = client:GetCharacter()
	if not char then return false end

	local inv = char:GetInventory()
	if not inv then return false end

	for _, item in pairs(inv:GetItems()) do
		if item.id ~= self.id and item.isGeiger == true and item:GetData("equip") then
			client:Notify("You are already equipping a geiger counter detector.")
			return false
		end
	end

	self:SetData("equip", true)
	self.player = client
	self:OnLoadout()

	return false
end

function ITEM:UnEquip(client)
	self:SetData("equip", false)
	client = IsValid(client) and client or self.player

	if IsValid(client) then
		client:SetNetVar("ixhasgeiger", false)
		client:SetData("ixhasgeiger", false)
	end

	return false
end

ITEM:Hook("drop", function(item)
	item:UnEquip(item.player)
end)

function ITEM:OnLoadout()
	if self:GetData("equip", false) and IsValid(self.player) then
		self.player:SetNetVar("ixhasgeiger", true)
		self.player:SetData("ixhasgeiger", true)
	end
end
