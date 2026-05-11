local PLUGIN = PLUGIN
PLUGIN.meta = PLUGIN.meta or {}

local RECIPE = PLUGIN.meta.recipe or {}
RECIPE.__index = RECIPE
RECIPE.name = "undefined"
RECIPE.description = "undefined"
RECIPE.uniqueID = "undefined"
RECIPE.category = "Крафт"
RECIPE.station = nil
RECIPE.skill = nil
RECIPE.skillLevel = 0
RECIPE.blueprint = nil
RECIPE.hiddenUntilLearned = false
RECIPE.requirements = RECIPE.requirements or {}
RECIPE.results = RECIPE.results or {}

function RECIPE:GetName()
    return self.name
end

function RECIPE:GetDescription()
    return self.description
end

function RECIPE:GetSkin()
    return self.skin
end

function RECIPE:GetModel()
    return self.model
end

function RECIPE:GetDifficultyName()
    if (self.blueprint) then
        return L("CraftDifficultyHard")
    elseif (self.skill and self.station) then
        return L("CraftDifficultyMedium")
    end

    return L("CraftDifficultyEasy")
end

function RECIPE:PreHook(name, func)
    self.preHooks = self.preHooks or {}
    self.preHooks[name] = func
end

function RECIPE:PostHook(name, func)
    self.postHooks = self.postHooks or {}
    self.postHooks[name] = func
end

function RECIPE:RunHook(storageName, hookName, client)
    if (!self[storageName] or !self[storageName][hookName]) then
        return nil
    end

    return self[storageName][hookName](self, client)
end

function RECIPE:OnCanSee(client)
    local character = client:GetCharacter()
    if (!character) then
        return false
    end

    local preResult = self:RunHook("preHooks", "OnCanSee", client)
    if (preResult != nil) then
        return preResult
    end

    if (self.flag and !character:HasFlags(self.flag)) then
        return false
    end

    if (self.blueprint and self.hiddenUntilLearned and !PLUGIN.craft.KnowsRecipe(character, self.blueprint)) then
        return false
    end

    local postResult = self:RunHook("postHooks", "OnCanSee", client)
    if (postResult != nil) then
        return postResult
    end

    return true
end

function RECIPE:OnCanCraft(client)
    local character = client:GetCharacter()
    if (!character) then
        return false
    end

    local result = self:RunHook("preHooks", "OnCanCraft", client)
    if (result != nil) then
        return result
    end

    local inventory = character:GetInventory()
    if (!inventory) then
        return false
    end

    if (self.flag and !character:HasFlags(self.flag)) then
        return false, "@CraftMissingFlag", self.flag
    end

    if (self.blueprint and !PLUGIN.craft.KnowsRecipe(character, self.blueprint)) then
        return false, "@CraftRecipeUnknown"
    end

    if (self.station and !PLUGIN.craft.IsNearStation(client, self.station)) then
        local stationTable = PLUGIN.craft.stations[self.station]
        local stationName = stationTable and stationTable:GetName() or self.station
        return false, "@CraftNeedStationNearby", stationName
    end

    if (self.skill) then
        local resolvedSkill = PLUGIN.craft.ResolveAttributeKey(self.skill)
        local requiredLevel = tonumber(self.skillLevel) or 0
        local currentLevel = character:GetAttribute(resolvedSkill, 0)

        if (currentLevel < requiredLevel) then
            return false, "@CraftSkillTooLow", PLUGIN.craft.GetAttributeDisplayName(self.skill), requiredLevel
        end
    end

    local missingItems = {}

    for uniqueID, amount in pairs(self.requirements or {}) do
        if (inventory:GetItemCount(uniqueID) < amount) then
            local itemTable = ix.item.Get(uniqueID)
            table.insert(missingItems, (itemTable and itemTable.name or uniqueID).." x"..amount)
        end
    end

    if (#missingItems > 0) then
        return false, "@CraftMissingItem", table.concat(missingItems, ", ")
    end

    local postResult = self:RunHook("postHooks", "OnCanCraft", client)
    if (postResult != nil) then
        return postResult
    end

    return true
end

if (SERVER) then
    function RECIPE:OnCraft(client)
        local canCraft, failText, a, b, c, d = self:OnCanCraft(client)
        if (!canCraft) then
            return false, failText, a, b, c, d
        end

        local preResult = self:RunHook("preHooks", "OnCraft", client)
        if (preResult != nil) then
            return preResult
        end

        local character = client:GetCharacter()
        local inventory = character:GetInventory()
        local removedCounts = {}

        for _, item in pairs(inventory:GetItems()) do
            local uniqueID = item.uniqueID
            local needed = self.requirements[uniqueID]

            if (needed) then
                removedCounts[uniqueID] = removedCounts[uniqueID] or 0

                if (removedCounts[uniqueID] < needed) then
                    item:Remove()
                    removedCounts[uniqueID] = removedCounts[uniqueID] + 1
                end
            end
        end

        for uniqueID, amount in pairs(self.results or {}) do
            for _ = 1, amount do
                if (!inventory:Add(uniqueID)) then
                    ix.item.Spawn(uniqueID, client)
                end
            end
        end

        local postResult = self:RunHook("postHooks", "OnCraft", client)
        if (postResult != nil) then
            return postResult
        end

        return true, "@CraftSuccess", self:GetName()
    end
end

PLUGIN.meta.recipe = RECIPE