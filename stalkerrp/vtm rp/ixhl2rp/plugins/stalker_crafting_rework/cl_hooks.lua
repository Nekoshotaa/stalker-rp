local PLUGIN = PLUGIN

function PLUGIN:BuildCraftingMenu()
    return !table.IsEmpty(self.craft.GetCategories(LocalPlayer()))
end

function PLUGIN:PopulateRecipeTooltip(tooltip, recipe)
    local client = LocalPlayer()
    local character = client:GetCharacter()
    local canCraft, failString, a, b, c, d = recipe:OnCanCraft(client)

    local name = tooltip:AddRow("name")
    name:SetImportant()
    name:SetText((recipe.category or L("CraftCategoryDefault"))..": "..recipe:GetName())
    name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
    name:SizeToContents()

    local difficulty = tooltip:AddRow("difficulty")
    difficulty:SetText(L("CraftDifficulty")..": "..recipe:GetDifficultyName())
    difficulty:SetBackgroundColor(Color(90, 90, 140))
    difficulty:SizeToContents()

    local description = tooltip:AddRow("description")
    description:SetText(recipe:GetDescription())
    description:SizeToContents()

    if (recipe.station) then
        local stationTable = PLUGIN.craft.stations[recipe.station]
        local stationName = stationTable and stationTable:GetName() or recipe.station
        local stationRow = tooltip:AddRow("station")
        stationRow:SetText(L("CraftNeedStation")..": "..stationName)
        stationRow:SetBackgroundColor(PLUGIN.craft.IsNearStation(client, recipe.station) and Color(60, 120, 60) or Color(120, 60, 60))
        stationRow:SizeToContents()
    end

    if (recipe.skill) then
        local resolvedSkill = PLUGIN.craft.ResolveAttributeKey(recipe.skill)
        local skillRow = tooltip:AddRow("skill")
        local skillName = PLUGIN.craft.GetAttributeDisplayName(recipe.skill)
        local requiredLevel = tonumber(recipe.skillLevel) or 0
        local currentLevel = character and character:GetAttribute(resolvedSkill, 0) or 0

        skillRow:SetText(string.format("%s: %s (%d/%d)", L("CraftNeedSkill"), skillName, currentLevel, requiredLevel))
        skillRow:SetBackgroundColor(currentLevel >= requiredLevel and Color(60, 120, 60) or Color(120, 60, 60))
        skillRow:SizeToContents()
    else
        local skillRow = tooltip:AddRow("skill")
        skillRow:SetText(L("CraftNoSkillRequired"))
        skillRow:SetBackgroundColor(Color(70, 70, 70))
        skillRow:SizeToContents()
    end

    if (recipe.blueprint) then
        local knowsRecipe = character and PLUGIN.craft.KnowsRecipe(character, recipe.blueprint)
        local blueprintRow = tooltip:AddRow("blueprint")
        blueprintRow:SetText(L("CraftBlueprint")..": "..(knowsRecipe and L("CraftLearned") or L("CraftNotLearned")))
        blueprintRow:SetBackgroundColor(knowsRecipe and Color(60, 120, 60) or Color(70, 90, 150))
        blueprintRow:SizeToContents()
    end

    local requirements = tooltip:AddRow("requirements")
    requirements:SetText(L("CraftRequirements"))
    requirements:SetBackgroundColor(Color(25, 150, 150))
    requirements:SizeToContents()

    local requirementString = {}
    for uniqueID, amount in pairs(recipe.requirements or {}) do
        local itemTable = ix.item.Get(uniqueID)
        local itemName = itemTable and itemTable.name or uniqueID
        table.insert(requirementString, amount.."x "..itemName)
    end

    if (#requirementString > 0) then
        local requirementList = tooltip:AddRow("ingredientList")
        requirementList:SetText("- "..table.concat(requirementString, ", "))
        requirementList:SizeToContents()
    end

    local result = tooltip:AddRow("result")
    result:SetText(L("CraftResults"))
    result:SetBackgroundColor(derma.GetColor("Warning", tooltip))
    result:SizeToContents()

    local resultString = {}
    for uniqueID, amount in pairs(recipe.results or {}) do
        local itemTable = ix.item.Get(uniqueID)
        local itemName = itemTable and itemTable.name or uniqueID
        table.insert(resultString, amount.."x "..itemName)
    end

    if (#resultString > 0) then
        local resultList = tooltip:AddRow("resultList")
        resultList:SetText("- "..table.concat(resultString, ", "))
        resultList:SizeToContents()
    end

    if (!canCraft and failString) then
        local errorRow = tooltip:AddRow("errorRow")
        if (failString:sub(1, 1) == "@") then
            failString = L(failString:sub(2), a, b, c, d)
        end
        errorRow:SetText(failString)
        errorRow:SetBackgroundColor(Color(190, 50, 50))
        errorRow:SizeToContents()
    end
end

function PLUGIN:PopulateStationTooltip(tooltip, station)
    local name = tooltip:AddRow("name")
    name:SetImportant()
    name:SetText(station:GetName())
    name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
    name:SizeToContents()

    local description = tooltip:AddRow("description")
    description:SetText(station:GetDescription())
    description:SizeToContents()
end