local PLUGIN = PLUGIN

PLUGIN.name = "Container Item Spawner"
PLUGIN.author = "gumlefar + cleanup edit + rebalance"
PLUGIN.desc = "Spawns items in containers using weighted loot tables."

ix.config.Add("containerSpawnChanceFlat", 18, "Base percent chance to spawn items in containers.", nil, {
    data = {min = 0, max = 100},
    category = "Containers"
})

ix.config.Add("containerSpawnChanceScaling", 3, "Extra spawn chance per player.", nil, {
    data = {min = 0, max = 10},
    category = "Containers"
})

ix.config.Add("containerSpawnRate", 900, "Seconds between each spawn attempt.", nil, {
    data = {min = 60, max = 43200},
    category = "Containers"
})

ix.config.Add("containerSpawnMaxItems", 4, "Max spawned items allowed in a single container.", nil, {
    data = {min = 1, max = 10},
    category = "Containers"
})

ix.config.Add("containerSpawnMaxItemsPerRun", 6, "Max items spawned globally per cycle.", nil, {
    data = {min = 1, max = 50},
    category = "Containers"
})

if SERVER then
    local nextSpawnTime = 1

    local rareCategories = {
        ["loot_mixed_high"] = true,
        ["loot_tools"] = true,
        ["loot_documents"] = true
    }

    function PLUGIN:CanSpawnItemInContainer(container, inventory, category)
        if (!IsValid(container)) then return false end
        if (!inventory) then return false end
        if (!category or category == "") then return false end
        if (!ix.randomitems or !ix.randomitems.tables) then return false end
        if (!ix.randomitems.tables[category]) then return false end
        return true
    end

    function PLUGIN:GetSpawnChanceForContainer(container, inventory, category, baseChance)
        local chance = baseChance
        local itemCount = table.Count(inventory:GetItems() or {})
        local invW, invH = inventory:GetSize()
        local capacity = math.max((invW or 1) * (invH or 1), 1)

        if (itemCount == 0) then
            chance = chance + 12
        elseif (itemCount == 1) then
            chance = chance + 4
        elseif (itemCount >= 3) then
            chance = chance - 10
        end

        if (capacity <= 6) then
            chance = chance - 5
        elseif (capacity >= 20) then
            chance = chance + 4
        end

        if (rareCategories[category]) then
            chance = chance - 8
        end

        return math.Clamp(chance, 5, 75)
    end

    function PLUGIN:TrySpawnIntoContainer(container)
        if (!IsValid(container)) then return false end

        local category = container:GetSpawnCategory()
        local inventory = container:GetInventory()

        if (!self:CanSpawnItemInContainer(container, inventory, category)) then
            return false
        end

        local items = inventory:GetItems() or {}
        local itemCount = table.Count(items)
        local maxItemsPerContainer = ix.config.Get("containerSpawnMaxItems", 4)

        if (itemCount >= maxItemsPerContainer) then
            return false
        end

        local itemData = ix.util.GetRandomItemFromPool(category)
        if (!itemData or !itemData[1]) then
            return false
        end

        local uniqueID = itemData[1]
        local data = itemData[2] or {}

        if (!ix.item.list or !ix.item.list[uniqueID]) then
            return false
        end

        local itemTable = ix.item.list[uniqueID]
        local itemWidth = itemTable.width or 1
        local itemHeight = itemTable.height or 1

        local x, y = inventory:FindEmptySlot(itemWidth, itemHeight)
        if (!x or !y) then
            return false
        end

        local result = inventory:Add(uniqueID, 1, data, x, y)
        if (result == false) then
            return false
        end

        return true
    end

    function PLUGIN:Think()
        if (nextSpawnTime > CurTime()) then
            return
        end

        local rate = ix.config.Get("containerSpawnRate", 1200)
        nextSpawnTime = CurTime() + rate

        local spawnedThisRun = 0
        local maxPerRun = ix.config.Get("containerSpawnMaxItemsPerRun", 6)
        local playerCount = player.GetCount()
        local baseChance = ix.config.Get("containerSpawnChanceFlat", 18) + (ix.config.Get("containerSpawnChanceScaling", 3) * playerCount)

        local containers = ents.FindByClass("ix_container")
        table.Shuffle(containers)

        for _, container in ipairs(containers) do
            if (spawnedThisRun >= maxPerRun) then
                break
            end

            if (!IsValid(container)) then
                continue
            end

            local category = container:GetSpawnCategory()
            local inventory = container:GetInventory()

            if (!self:CanSpawnItemInContainer(container, inventory, category)) then
                continue
            end

            local chance = self:GetSpawnChanceForContainer(container, inventory, category, baseChance)
            local roll = math.random(100)

            if (roll > chance) then
                continue
            end

            if (self:TrySpawnIntoContainer(container)) then
                spawnedThisRun = spawnedThisRun + 1
            end
        end
    end
end

ix.command.Add("containerspawnadd", {
    adminOnly = true,
    arguments = {
        ix.type.string
    },
    OnRun = function(self, client, spawngroup)
        local trace = client:GetEyeTraceNoCursor()
        local ent = trace.Entity

        if (IsValid(ent) and ent:GetClass() == "ix_container") then
            ent:SetSpawnCategory(spawngroup)
            client:Notify("Категория спавна установлена: " .. spawngroup)
        else
            client:NotifyLocalized("invalid", "Entity")
        end
    end
})

ix.command.Add("containerspawnremove", {
    adminOnly = true,
    OnRun = function(self, client)
        local trace = client:GetEyeTraceNoCursor()
        local ent = trace.Entity

        if (IsValid(ent) and ent:GetClass() == "ix_container") then
            ent:SetSpawnCategory("")
            client:Notify("Категория спавна очищена.")
        else
            client:NotifyLocalized("invalid", "Entity")
        end
    end
})
