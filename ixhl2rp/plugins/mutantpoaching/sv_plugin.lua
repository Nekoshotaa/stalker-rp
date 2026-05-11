local PLUGIN = PLUGIN

ix.poaching = ix.poaching or {}

local POACH_DISTANCE = 110
local POACH_TIME = 5

-- === Mutant Poaching: corpse tagging & cleanup ===
-- Важно: мы НЕ создаём второй труп. Мы помечаем уже созданный движком/аддоном ragdoll,
-- чтобы он стал "poachable" (интерактивным для разделки), и добавляем очистку по времени.

if (SERVER) then
	-- Сколько секунд труп мутанта может лежать без разделки.
	-- 0 = никогда не удалять автоматически (не рекомендуется, если у вас уже есть проблема со "вечно лежащими" трупами).
	ix.config.Add(
		"mutantPoachCorpseCleanupTime",
		1200,
		"Seconds before an unpoached mutant corpse is removed (0 = never).",
		nil,
		{
			category = "Mutant Poaching",
			data = {min = 0, max = 7200, decimals = 0}
		}
	)
end

local CORPSE_CLEANUP_TIMER_PREFIX = "ix_poaching_corpse_cleanup_"

function PLUGIN:MarkPoachCorpse(ent)
	if not IsValid(ent) then return end

	-- Lua-флаги (серверные)
	ent.ixPoachCorpse = true
	ent.ixAlreadyPoached = ent.ixAlreadyPoached or false

	-- NW-флаги (для совместимости и дебага)
	ent:SetNWBool("IsMonsterCorpse", true)
	ent:SetNWBool("PoachCorpse", true)

	-- Чтобы труп не мешал как полноценный физ-проп/баррикада.
	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function PLUGIN:SchedulePoachCorpseCleanup(ent)
	if not IsValid(ent) then return end

	local lifetime = ix.config.Get("mutantPoachCorpseCleanupTime", 1200) or 0
	if lifetime <= 0 then return end
	if ent.ixAlreadyPoached then return end

	local timerID = CORPSE_CLEANUP_TIMER_PREFIX .. ent:EntIndex()
	timer.Remove(timerID)

	timer.Create(timerID, lifetime, 1, function()
		if IsValid(ent) and not ent.ixAlreadyPoached then
			ent:Remove()
		end
	end)
end


ix.poaching.MutantTable = {
	["models/monsters/izlom.mdl"] = "izlom",
	["models/monsters/zombie.mdl"] = "classiczombie",
	["models/monsters/babka.mdl"] = "classiczombie",
	["models/monsters/tushkan.mdl"] = "tushkano",
	["models/monsters/snork2.mdl"] = "snork",
	["models/monsters/psydog2.mdl"] = "pseudodog",
	["models/monsters/psydog.mdl"] = "psydog",
	["models/monsters/krovosos.mdl"] = "bloodsucker",
	["models/monsters/plot.mdl"] = "flesh",
	["models/monsters/slep_dog2.mdl"] = "dog",
	["models/monsters/slep_dog.mdl"] = "hellhound",
	["models/monsters/boar.mdl"] = "boar",
	["models/monsters/chimera2.mdl"] = "chimera",
	["models/monsters/chimera.mdl"] = "chimera",
	["models/monsters/chimera3.mdl"] = "chimera",
	["models/monsters/burer.mdl"] = "burer",
	["models/monsters/cat.mdl"] = "cat",
	["models/monsters/karlik.mdl"] = "karlik",
	["models/monsters/zanoza.mdl"] = "sprig",
	["models/monsters/controler.mdl"] = "controller",
	["models/monsters/tibet.mdl"] = "swampcontroller",
	["models/monsters/controler_big.mdl"] = "electrocontroller",
	["models/monsters/controler_fast.mdl"] = "fastcontroller",
	["models/monsters/bear.mdl"] = "bear",
	["models/monsters/skelet.mdl"] = "skeleton",
	["models/monsters/gigant3.mdl"] = "pseudogiant",
	["models/monsters/gigant.mdl"] = "pseudogiantfast",
	["models/monsters/tark.mdl"] = "tark",
	["models/monsters/vareshka.mdl"] = "vareshka",
	["models/darkmessiah/spider_regular.mdl"] = "spider",
}

ix.poaching.MutantParts = {
	["dog"] = {
		["meattype"] = "meat_blinddog",
		["tiers"] = {
		{threshold = 35, item = "part_blinddog"},
		{threshold = 95, item = "part_blinddog_heart"},
	},
},
	["izlom"] = {
		["meattype"] = "meat_mutant_other",
		["tiers"] = {
		{threshold = 35, item = "part_izlom"},
		{threshold = 85, item = "part_izlom_rare"},
	},
},
	["classiczombie"] = {
		["meattype"] = "meat_human",
		["parts"] = {{"part_zombie_1", 25}, {"part_zombie_2", 5}},
	},
	["tushkano"] = {
		["meattype"] = "meat_tushkano",
		["tiers"] = {
		{threshold = 35, item = "part_tushkano"},
	},
},
	["snork"] = {
		["meattype"] = "meat_snork",
		["parts"] = {{"part_snork_1", 35}, {"part_snork_2", 4}},
	},
	["pseudodog"] = {
		["meattype"] = "meat_pseudodog",
		["tiers"] = {
		{threshold = 25, item = "part_pseudodog"},
		{threshold = 45, item = "hide_pseudodog"},
	},
},
	["psydog"] = {
		["meattype"] = "meat_pseudodog",
		["tiers"] = {
		{threshold = 25, item = "part_pseudodog"},
		{threshold = 45, item = "hide_pseudodog"},
	},
},
	["bloodsucker"] = {
		["meattype"] = "meat_mutant_other",
		["tiers"] = {
		{threshold = 25, item = "part_bloodsucker"},
		{threshold = 45, item = "hide_bloodsucker"},
	},
},
	["flesh"] = {
		["meattype"] = "meat_flesh",
		["tiers"] = {
		{threshold = 25, item = "part_flesh"},
		{threshold = 55, item = "hide_flesh"},
		{threshold = 85, item = "part_flesh_rare"},
	}
},
	["boar"] = {
    ["meattype"] = "meat_boar",
    ["tiers"] = {
        {threshold = 25, item = "part_boar"},
        {threshold = 55, item = "hide_boar"},
        {threshold = 85, item = "part_boar_heart"},
    }
},
	["chimera"] = {
		["meattype"] = "meat_chimera",
		["tiers"] = {
		{threshold = 45, item = "hide_chimera"},
		{threshold = 55, item = "part_chimera"},
		{threshold = 85, item = "part_chimera_rare"},
	},
},
	["burer"] = {
		["meattype"] = "meat_mutant_other",
		["tiers"] = {
		{threshold = 35, item = "part_burer"},
		{threshold = 45, item = "hide_burer"},
	},
},
	["cat"] = {
		["meattype"] = "meat_mutant_other",
		["tiers"] = {
		{threshold = 25, item = "part_cat"},
		{threshold = 75, item = "part_cat_rare"},
	},
},
	["karlik"] = {
		["meattype"] = "meat_karlik",
		["parts"] = {{"part_karlik_1", 45}, {"part_karlik_2", 5}, {"hide_karlik", 4}},
	},
	["sprig"] = {
		["meattype"] = "meat_sprig",
		["parts"] = {{"part_sprig", 20}, {"hide_sprig", 8}},
	},
	["controller"] = {
		["meattype"] = "meat_mutant_other",
		["tiers"] = {
		{threshold = 25, item = "part_controller"},
		{threshold = 65, item = "part_controller_rare"},
		{threshold = 95, item = "part_controller_red_brain"},
	},
},
	["bear"] = {
		["meattype"] = "meat_bear",
		["parts"] = {{"part_bear", 20}, {"hide_bear", 3}},
	},
	["skeleton"] = {
		["meattype"] = "artifact_bonecluster",
		["parts"] = {{"part_skeleton", 40}},
	},
	["pseudogiant"] = {
		["meattype"] = "meat_pseudogiant",
		["parts"] = {{"part_pseudogiant", 20}, {"hide_pseudogiant", 3}},
	},
	["pseudogiantfast"] = {
		["meattype"] = "meat_pseudogiant",
		["parts"] = {{"part_pseudogiant", 25}, {"hide_pseudogiant", 5}},
	},
	["hellhound"] = {
		["meattype"] = "meat_hellhound",
		["parts"] = {{"part_hellhound", 20}, {"hide_hellhound", 3}},
	},
	["fastcontroller"] = {
		["meattype"] = "meat_controller",
		["parts"] = {{"part_controller_1", 20}, {"part_controller_2", 4}, {"hide_controller", 3}, {"artifact_moon", 1}},
	},
	["tark"] = {
		["meattype"] = "meat_tark",
		["parts"] = {{"part_tark", 20}, {"hide_tark", 3}},
	},
	["vareshka"] = {
		["meattype"] = "meat_vareshka",
		["parts"] = {{"part_vareshka", 20}, {"hide_vareshka", 3}},
	},
	["spider"] = {
		["meattype"] = "meat_spider",
		["parts"] = {{"part_spider", 20}, {"hide_spider", 8}},
	},
}

local function GetPoachItemData(uniqueID, knifetier)
	local data = {
		tier = knifetier or 0
	}

	if ix.util and ix.util.GetMutantMeatWeight then
		data.weight = ix.util.GetMutantMeatWeight(uniqueID, knifetier or 0)
	else
		local itemTable = ix.item.list[uniqueID]
		data.weight = itemTable and itemTable.weight or 0.1
	end

	return data
end

local function BuildPoachLoot(mutantTable)
    if not mutantTable then return {} end

    local loot = {}
    local roll = math.random(1, 100)

    if mutantTable.meattype then
        table.insert(loot, mutantTable.meattype)
    end

    if mutantTable.tiers then
        for _, tierData in ipairs(mutantTable.tiers) do
            if roll >= tierData.threshold then
                table.insert(loot, tierData.item)
            end
        end
    elseif mutantTable.parts then
        -- fallback для старых мутантов, которых ты ещё не переделал
        for _, partData in pairs(mutantTable.parts) do
            if math.random(0, 100) < partData[2] then
                table.insert(loot, partData[1])
            end
        end
    end

    return loot, roll
end

local function ClearPoachState(client)
	if not IsValid(client) then return end

	client:SetNetVar("IsPoaching", false)
	client:SetAction()
	client.ixPoachEntity = nil
end

function PLUGIN:InterruptPoaching(client, entity)
	if not IsValid(client) then return end

	entity = IsValid(entity) and entity or client.ixPoachEntity

	ClearPoachState(client)

	if IsValid(entity) then
		entity:SetNetVar("beingSkinned", false)
		entity:StopSound("stalkersound/inv_mutant_loot_animal.ogg")
	end
end

function PLUGIN:IsPoachCorpse(entity)
	if not IsValid(entity) then return false end

	local model = entity:GetModel()
	if not model or not ix.poaching.MutantTable[model] then
		return false
	end

	if entity.ixAlreadyPoached then
		return false
	end

	if entity.ixPoachCorpse then
		return true
	end

	if entity:GetNWBool("IsMonsterCorpse", false) then
		return true
	end

	if entity:GetNWBool("PoachCorpse", false) then
		return true
	end

	local class = entity:GetClass()

	if class == "stalker_monster_corpse" then return true end
	if class == "monster_corpse" then return true end
	if class == "npc_mutant_corpse" then return true end
	if class == "monstercorpse" then return true end

	if entity.IsRagdoll and entity:IsRagdoll() then
		return entity.ixPoachCorpse or entity:GetNWBool("IsMonsterCorpse", false) or entity:GetNWBool("PoachCorpse", false)
	end

	if entity.GetDead and entity:GetDead() then
		return true
	end

	return false
end

function PLUGIN:IsValidPoachTarget(client, entity)
	if not IsValid(client) or not IsValid(entity) then return false end
	if not self:IsPoachCorpse(entity) then return false end
	if entity:GetPos():Distance(client:GetPos()) > POACH_DISTANCE then return false end

	return true
end

function PLUGIN:GetPoachKnife(client)
	local char = client:GetCharacter()
	if not char then return nil end

	local inv = char:GetInventory()
	if not inv then return nil end

	local activeWeapon = client:GetActiveWeapon()
	local activeClass = IsValid(activeWeapon) and activeWeapon:GetClass() or nil

	for _, item in pairs(inv:GetItems()) do
		if item.isPoachKnife then
			if item:GetData("equip") then
				return item
			end

			if activeClass and item.class == activeClass then
				return item
			end
		end
	end

	return nil
end

function PLUGIN:CreatePoachCorpse(npc)
	if not IsValid(npc) then return nil end
	if npc.ixPoachCorpseCreated then return nil end

	local model = npc:GetModel()
	if not model or not ix.poaching.MutantTable[model] then return nil end

	npc.ixPoachCorpseCreated = true

	local ragdoll = ents.Create("prop_ragdoll")
	if not IsValid(ragdoll) then
		print("[POACHING DEBUG] ОШИБКА: не удалось создать prop_ragdoll!")
		return nil
	end

	ragdoll:SetModel(model)
	ragdoll:SetPos(npc:GetPos())
	ragdoll:SetAngles(npc:GetAngles())

	if npc:GetSkin() then
		ragdoll:SetSkin(npc:GetSkin())
	end

	for i = 0, (npc:GetNumBodyGroups() or 0) - 1 do
		ragdoll:SetBodygroup(i, npc:GetBodygroup(i))
	end

	ragdoll:Spawn()
	ragdoll:Activate()

	local vel = npc.GetVelocity and npc:GetVelocity() or vector_origin
	local physCount = ragdoll:GetPhysicsObjectCount()

	for i = 0, physCount - 1 do
		local phys = ragdoll:GetPhysicsObjectNum(i)

		if IsValid(phys) then
			local bone = ragdoll:TranslatePhysBoneToBone(i)

			if bone and bone >= 0 then
				local pos, ang = npc:GetBonePosition(bone)

				if pos and pos ~= vector_origin then
					phys:SetPos(pos)
				end

				if ang then
					phys:SetAngles(ang)
				end
			end

			phys:SetVelocity(vel)
		end
	end

	ragdoll.ixPoachCorpse = true
	ragdoll.ixAlreadyPoached = false
	ragdoll:SetNWBool("IsMonsterCorpse", true)
	ragdoll:SetNWBool("PoachCorpse", true)
	ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	print("[POACHING DEBUG] ✅ Создан corpse-ragdoll: " .. tostring(model))

	return ragdoll
end

function PLUGIN:PlayerButtonDown(client, key)
	if key ~= KEY_F then return end
	if client:GetNetVar("IsPoaching") ~= true then return end

	self:InterruptPoaching(client)
end

function PLUGIN:KeyPress(client, key)
	if not IsValid(client) or not client:Alive() then return end
	if not client:GetCharacter() then return end

	local hit = client:GetEyeTraceNoCursor()
	local entity = IsValid(hit.Entity) and hit.Entity or nil

	if client:GetNetVar("IsPoaching") == true and key ~= IN_USE then
		self:InterruptPoaching(client)
		return
	end

	if key ~= IN_USE then return end
	if not self:IsValidPoachTarget(client, entity) then return end

	local mutant = ix.poaching.MutantTable[entity:GetModel()]
	if not mutant then return end

	local knifeItem = self:GetPoachKnife(client)

	if knifeItem then
		self:OpenPoachMenu(client, mutant, knifeItem, entity)
	else
		client:Notify("Нужен нож для разделки мутантов.")
	end
end

function PLUGIN:OpenPoachMenu(client, mutant, knifeItem, entity)
	local weapon = client:GetActiveWeapon()

	if IsValid(weapon) then
		local class = weapon:GetClass()

		if class and class:find("cw_") and weapon.isReloading and weapon:isReloading() then
			client:Notify("Нельзя разделывать во время перезарядки!")
			return
		end
	end

	local char = client:GetCharacter()
	if not char then return end

	local inv = char:GetInventory()
	if not inv then return end

	if not knifeItem or not knifeItem.uniqueID then return end
	if not inv:HasItem(knifeItem.uniqueID) then
		client:Notify("Нож для разделки не найден в инвентаре.")
		return
	end

	if not IsValid(entity) or not self:IsValidPoachTarget(client, entity) then
		return
	end

	if entity.ixAlreadyPoached then
		client:Notify("Этот труп уже разделан.")
		return
	end

	if entity:GetNetVar("beingSkinned", false) then
		client:Notify("Этого мутанта уже разделывает кто-то другой!")
		return
	end

	local mutantTable = ix.poaching.MutantParts[mutant]
	if not mutantTable then
		client:Notify("Для этого мутанта не прописан лут.")
		return
	end

	local knifetier = knifeItem.knifetier or 0
	local loot, roll = BuildPoachLoot(mutantTable)

	entity:SetNetVar("beingSkinned", true)
	entity:EmitSound("stalkersound/inv_mutant_loot_animal.ogg", 60)

	client.ixPoachEntity = entity
	client:SetNetVar("IsPoaching", true)
	client:SetAction("Разделывание...", POACH_TIME)

	client:DoStaredAction(entity, function()
		if not IsValid(client) or not client:GetCharacter() then
			if IsValid(entity) then
				entity:SetNetVar("beingSkinned", false)
				entity:StopSound("stalkersound/inv_mutant_loot_animal.ogg")
			end
			return
		end

		if not IsValid(entity) then
			ClearPoachState(client)
			return
		end

		if entity.ixAlreadyPoached then
			ClearPoachState(client)
			return
		end

		local position = client:GetItemDropPos()

		entity.ixAlreadyPoached = true
		entity:SetNetVar("beingSkinned", false)
		entity:StopSound("stalkersound/inv_mutant_loot_animal.ogg")

		for _, uniqueID in pairs(loot) do
			local data = GetPoachItemData(uniqueID, knifetier)

			if not inv:Add(uniqueID, 1, data) then
				ix.item.Spawn(uniqueID, position, function(item, ent)
					if IsValid(ent) then
						ent.bTemporary = true
					end
				end, AngleRand(), data)

				position = position + Vector(0, 0, 5)
				client:Notify("В инвентаре нет места, предметы выброшены на землю.")
			end
		end

		if IsValid(entity) then
			entity:Remove()
		end

		ClearPoachState(client)

		if ix.weight and ix.weight.Update then
			ix.weight.Update(client:GetCharacter())
		end
	end, POACH_TIME, function()
		if IsValid(entity) then
			entity:SetNetVar("beingSkinned", false)
			entity:StopSound("stalkersound/inv_mutant_loot_animal.ogg")
		end

		if IsValid(client) then
			ClearPoachState(client)
			client:Notify("Разделка прервана.")
		end
	end, POACH_DISTANCE)
end

-- Создание корректного corpse-ragdoll после реальной смерти NPC
-- Помечаем serverside ragdoll, который создаёт движок/аддон, чтобы он стал poachable.
hook.Add("CreateEntityRagdoll", "ix_poaching_MarkMutantRagdoll", function(owner, ragdoll)
	if not IsValid(owner) or not IsValid(ragdoll) then return end
	if not owner:IsNPC() then return end

	local model = owner:GetModel()
	if not model or not ix.poaching.MutantTable[model] then return end

	PLUGIN:MarkPoachCorpse(ragdoll)
	PLUGIN:SchedulePoachCorpseCleanup(ragdoll)
end)

-- Резерв: если какой-то аддон создаёт труп не сразу или не через стандартный ragdoll-путь,
-- пробуем "подхватить" ближайший труп в следующий тик, НЕ создавая новый.
hook.Add("OnNPCKilled", "ix_poaching_TagExistingCorpseOnDeath", function(npc, attacker, inflictor)
	if not IsValid(npc) then return end
	if not npc:IsNPC() then return end

	local model = npc:GetModel()
	if not model or not ix.poaching.MutantTable[model] then return end

	local pos = npc:GetPos()

	timer.Simple(0, function()
		-- npc к этому моменту может быть уже удалён движком, поэтому работаем только с pos/model.
		for _, ent in ipairs(ents.FindInSphere(pos, 96)) do
			if IsValid(ent) and ent ~= npc and ent:GetModel() == model then
				-- В первую очередь берём ragdoll (это и будет "родной" труп в большинстве случаев).
				if ent:IsRagdoll() then
					PLUGIN:MarkPoachCorpse(ent)
					PLUGIN:SchedulePoachCorpseCleanup(ent)
					return
				end

				-- Если у вас есть нестандартные классы трупов от аддонов, они уже частично поддержаны IsPoachCorpse,
				-- но мы всё равно можем проставить флаги/очистку для единообразия.
				local class = ent:GetClass()
				if class == "stalker_monster_corpse" or class == "monster_corpse"
				or class == "npc_mutant_corpse" or class == "monstercorpse" then
					PLUGIN:MarkPoachCorpse(ent)
					PLUGIN:SchedulePoachCorpseCleanup(ent)
					return
				end
			end
		end
	end)
end)


-- Если во время разделки труп исчез - аккуратно прерываем процесс
hook.Add("EntityRemoved", "ix_poaching_StopIfCorpseRemoved", function(ent)
	if not IsValid(ent) then return end
	if not ent.ixPoachCorpse and not ent:GetNWBool("PoachCorpse", false) and not ent:GetNWBool("IsMonsterCorpse", false) then
		return
	end

	for _, client in ipairs(player.GetAll()) do
		if client.ixPoachEntity == ent then
			PLUGIN:InterruptPoaching(client, ent)
		end
	end
end)

concommand.Add("ix_debug_corpse", function(client)
	if not IsValid(client) then return end

	local tr = client:GetEyeTraceNoCursor()
	local ent = tr.Entity

	if not IsValid(ent) then
		client:Notify("Нет сущности перед глазами.")
		return
	end

	print("===== ix_debug_corpse =====")
	print("CLASS: " .. tostring(ent:GetClass()))
	print("MODEL: " .. tostring(ent:GetModel()))
	print("IS RAGDOLL: " .. tostring(ent:IsRagdoll()))
	print("NPC: " .. tostring(ent:IsNPC()))
	print("NW IsMonsterCorpse: " .. tostring(ent:GetNWBool("IsMonsterCorpse", false)))
	print("NW PoachCorpse: " .. tostring(ent:GetNWBool("PoachCorpse", false)))
	print("Lua ixPoachCorpse: " .. tostring(ent.ixPoachCorpse))
	print("Lua ixAlreadyPoached: " .. tostring(ent.ixAlreadyPoached))
	print("===========================")

	client:Notify("Данные сущности выведены в консоль сервера.")
end)