local PLUGIN = PLUGIN

PLUGIN.craft = PLUGIN.craft or {}
PLUGIN.craft.recipes = PLUGIN.craft.recipes or {}
PLUGIN.craft.stations = PLUGIN.craft.stations or {}
PLUGIN.craft.knownDataKey = "knownCraftRecipes"

function PLUGIN.craft.LoadFromDir(directory, pathType)
    for _, fileName in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
        local uniqueID = fileName:sub(4, -5)

        if (pathType == "recipe") then
            RECIPE = setmetatable({
                uniqueID = uniqueID
            }, PLUGIN.meta.recipe)
                ix.util.Include(directory.."/"..fileName, "shared")
                PLUGIN.craft.recipes[uniqueID] = RECIPE
            RECIPE = nil
        elseif (pathType == "station") then
            STATION = setmetatable({
                uniqueID = uniqueID
            }, PLUGIN.meta.station)
                ix.util.Include(directory.."/"..fileName, "shared")

                if (!scripted_ents.Get("ix_station_"..uniqueID)) then
                    local baseEntity = table.Copy(scripted_ents.Get("ix_station"))
                    baseEntity.PrintName = STATION.name
                    baseEntity.uniqueID = uniqueID
                    baseEntity.Spawnable = true
                    baseEntity.AdminOnly = true
                    baseEntity.Model = STATION.model
                    scripted_ents.Register(baseEntity, "ix_station_"..uniqueID)
                end

                PLUGIN.craft.stations[uniqueID] = STATION
            STATION = nil
        end
    end
end

function PLUGIN.craft.ResolveAttributeKey(attributeID)
    if (!attributeID or attributeID == "") then
        return nil
    end

    if (ix.attributes.list[attributeID]) then
        return attributeID
    end

    local lowered = string.lower(attributeID)

    for key, data in pairs(ix.attributes.list) do
        local keyLower = string.lower(tostring(key))
        local nameLower = data.name and string.lower(tostring(data.name)) or ""
        local shortLower = data.shortname and string.lower(tostring(data.shortname)) or ""

        if (lowered == keyLower or lowered == nameLower or lowered == shortLower) then
            return key
        end
    end

    return attributeID
end

function PLUGIN.craft.GetCategories(client)
    local categories = {}

    for uniqueID, recipeTable in pairs(PLUGIN.craft.recipes) do
        if (istable(recipeTable) and ((isfunction(recipeTable.OnCanSee) and recipeTable:OnCanSee(client)) or !isfunction(recipeTable.OnCanSee))) then
            local category = recipeTable.category or "Крафт"
            categories[category] = categories[category] or {}
            table.insert(categories[category], uniqueID)
        end
    end

    return categories
end

function PLUGIN.craft.GetStationEntityClass(stationID)
    return "ix_station_"..stationID
end

function PLUGIN.craft.IsNearStation(client, stationID)
    if (!stationID or stationID == "") then
        return true
    end

    local stationTable = PLUGIN.craft.stations[stationID]
    if (!stationTable) then
        return false
    end

    local range = tonumber(stationTable.range) or 100
    local maxDistance = range * range
    local className = PLUGIN.craft.GetStationEntityClass(stationID)

    for _, entity in ipairs(ents.FindByClass(className)) do
        if (IsValid(entity) and client:GetPos():DistToSqr(entity:GetPos()) <= maxDistance) then
            return true
        end
    end

    return false
end

function PLUGIN.craft.GetKnownRecipes(character)
    if (!character) then
        return {}
    end

    return character:GetData(PLUGIN.craft.knownDataKey, {}) or {}
end

function PLUGIN.craft.KnowsRecipe(character, blueprintID)
    if (!blueprintID or blueprintID == "") then
        return true
    end

    local knownRecipes = PLUGIN.craft.GetKnownRecipes(character)
    return knownRecipes[blueprintID] == true
end

function PLUGIN.craft.LearnRecipe(character, blueprintID)
    if (!character or !blueprintID or blueprintID == "") then
        return false
    end

    local knownRecipes = PLUGIN.craft.GetKnownRecipes(character)

    if (knownRecipes[blueprintID]) then
        return false
    end

    knownRecipes[blueprintID] = true
    character:SetData(PLUGIN.craft.knownDataKey, knownRecipes)
    return true
end

function PLUGIN.craft.ForgetRecipe(character, blueprintID)
    if (!character or !blueprintID or blueprintID == "") then
        return false
    end

    local knownRecipes = PLUGIN.craft.GetKnownRecipes(character)

    if (!knownRecipes[blueprintID]) then
        return false
    end

    knownRecipes[blueprintID] = nil
    character:SetData(PLUGIN.craft.knownDataKey, knownRecipes)
    return true
end

function PLUGIN.craft.GetAttributeDisplayName(attributeID)
    local resolved = PLUGIN.craft.ResolveAttributeKey(attributeID)
    local attributeTable = resolved and ix.attributes.list[resolved] or nil
    return attributeTable and attributeTable.name or attributeID
end

function PLUGIN.craft.FindByName(recipeName)
    if (!recipeName or recipeName == "") then
        return nil
    end

    local lowered = string.lower(recipeName)

    for uniqueID, recipeTable in pairs(PLUGIN.craft.recipes) do
        local translatedName = recipeTable:GetName()
        if (isstring(translatedName) and string.find(string.lower(translatedName), lowered, 1, true)) then
            return uniqueID
        end
    end

    return nil
end

if (SERVER) then
    util.AddNetworkString("ixCraftRecipe")
    util.AddNetworkString("ixCraftRefresh")

    function PLUGIN.craft.CraftRecipe(client, uniqueID)
        local recipeTable = PLUGIN.craft.recipes[uniqueID]
        if (!recipeTable) then
            return false
        end

        local canCraft, failText, a, b, c, d = recipeTable:OnCanCraft(client)
        if (!canCraft) then
            if (failText) then
                if (failText:sub(1, 1) == "@") then
                    failText = L(failText:sub(2), client, a, b, c, d)
                end
                client:Notify(failText)
            end

            return false
        end

        local success, resultText, e, f, g, h = recipeTable:OnCraft(client)
        if (resultText) then
            if (resultText:sub(1, 1) == "@") then
                resultText = L(resultText:sub(2), client, e, f, g, h)
            end
            client:Notify(resultText)
        end

        return success
    end

    net.Receive("ixCraftRecipe", function(_, client)
        local uniqueID = net.ReadString()
        PLUGIN.craft.CraftRecipe(client, uniqueID)

        timer.Simple(0.1, function()
            if (!IsValid(client)) then
                return
            end

            net.Start("ixCraftRefresh")
            net.Send(client)
        end)
    end)
end

do
    local COMMAND = {}
    COMMAND.arguments = ix.type.string
    COMMAND.description = "@cmdCraftRecipe"

    function COMMAND:OnRun(client, recipeName)
        local uniqueID = PLUGIN.craft.FindByName(recipeName)
        if (!uniqueID) then
            return "Рецепт не найден."
        end

        return PLUGIN.craft.CraftRecipe(client, uniqueID)
    end

    ix.command.Add("CraftRecipe", COMMAND)
end

do
    local COMMAND = {}
    COMMAND.description = "Выдать персонажу знание рецепта."
    COMMAND.arguments = {ix.type.character, ix.type.string}
    COMMAND.adminOnly = true

    function COMMAND:OnRun(client, target, blueprintID)
        if (PLUGIN.craft.LearnRecipe(target, blueprintID)) then
            client:Notify("Рецепт изучен: "..blueprintID)
            if (target.GetPlayer and IsValid(target:GetPlayer())) then
                target:GetPlayer():Notify("Вы изучили рецепт: "..blueprintID)
            end
            return
        end

        return "Персонаж уже знает этот рецепт или указан неверный ID."
    end

    ix.command.Add("CraftLearn", COMMAND)
end

do
    local COMMAND = {}
    COMMAND.description = "Забрать у персонажа знание рецепта."
    COMMAND.arguments = {ix.type.character, ix.type.string}
    COMMAND.adminOnly = true

    function COMMAND:OnRun(client, target, blueprintID)
        if (PLUGIN.craft.ForgetRecipe(target, blueprintID)) then
            client:Notify("Рецепт удалён: "..blueprintID)
            if (target.GetPlayer and IsValid(target:GetPlayer())) then
                target:GetPlayer():Notify("Вы забыли рецепт: "..blueprintID)
            end
            return
        end

        return "У персонажа нет этого рецепта или указан неверный ID."
    end

    ix.command.Add("CraftForget", COMMAND)
end