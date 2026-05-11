AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Dirty Plastic Box"
ENT.Author = "Spenser&Kek1ch / edited / rebalance"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Helix"
ENT.RenderGroup = RENDERGROUP_BOTH

local DEFAULT_DROPS = {
	"glue",
	"ducktape",
	"fire_fuel",
	"firestarter_tinder",
	"kucocktkani",
	"rope",
	"boxtabak",
	"garlic",
	"salt",
	"flour",
	"edible_mushroom",
	"mukhomor",
	"food_galets",
	"food_can_beans_custom",
	"food_condensed_milk",
	"drink_beer_flask",
	"cig_dolb",
	"cig_balboro",
	"repairkit1",
	"gasmask_filter",
	"polaroid",
	"lottery_ticket",
	"chain",
	"copper_wire",
}


local function ResolveDropPool(self)
	if istable(self.CustomDropList) and #self.CustomDropList > 0 then
		return self.CustomDropList, false
	end

	if isstring(self.CustomSpawngroup) and self.CustomSpawngroup != "" and ix.randomitems and ix.randomitems.tables and ix.randomitems.tables[self.CustomSpawngroup] then
		return self.CustomSpawngroup, true
	end

	return DEFAULT_DROPS, false
end

local function PickDrop(self)
	local pool, isWeighted = ResolveDropPool(self)

	if isWeighted then
		local itemData = ix.util.GetRandomItemFromPool(pool)

		if istable(itemData) and itemData[1] then
			return itemData[1], itemData[2] or {}
		end

		return nil, nil
	end

	if not istable(pool) or #pool < 1 then
		return nil, nil
	end

	return pool[math.random(#pool)], {}
end


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/kek1ch/dev_merger.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)

		local physObj = self:GetPhysicsObject()

		self.hp = 10
		self.IsDamaged = false

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end

		self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	end

	function ENT:GetDropPool()
		local pool = ResolveDropPool(self)
		return pool
	end

	function ENT:SpawnRandomDrop(offsetZ)
		local itemID, data = PickDrop(self)
		if not itemID then return end

		ix.item.Spawn(
			itemID,
			self:GetPos() + Vector(0, 0, offsetZ or 4),
			function(item, ent)
				item:SetData("bTemporary", true)

				if istable(data) then
					for k, v in pairs(data) do
						item:SetData(k, v)
					end
				end

				if IsValid(ent) then
					ent.bTemporary = true
				end
			end,
			AngleRand()
		)
	end

	function ENT:OnTakeDamage(dmginfo)
		if self.IsDamaged then return end

		self.hp = self.hp - dmginfo:GetDamage()
		if self.hp > 0 then return end

		self.IsDamaged = true

		self:SpawnRandomDrop(3)

		for i = 1, 3 do
			if math.random(1, 6) == 6 then
				self:SpawnRandomDrop(3 + i)
			end
		end

		self:Remove()
	end

	function ENT:SetCustomSpawngroup(custgroup)
		self.CustomSpawngroup = custgroup
	end
end

if (CLIENT) then
	function ENT:Draw()
		if LocalPlayer():GetPos():Distance(self:GetPos()) < 2048 then
			self:DrawModel()
		end
	end

	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText("Грязный пластиковый ящик")
		name:SizeToContents()

		local description = container:AddRow("description")
		description:SetText("Лёгкий пластиковый ящик. Обычно внутри что-то дешёвое, бытовое или съедобное.")
		description:SizeToContents()
	end
end
