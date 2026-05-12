local PLUGIN = PLUGIN
PLUGIN.name = "Artifact Attribute Bonuses"
PLUGIN.author = "OpenAI"
PLUGIN.desc = "Applies passive attribute bonuses and radiation from special active artifacts."

if CLIENT then
    return
end

local APPLY_INTERVAL = 2
local ATTRIBUTE_MAX_VALUE = 100
local nextThink = 0

local function isAttributeArtifactActive(item)
    return item
        and item.isAttributeArtifact
        and item:GetData("active", false) == true
        and item:GetData("equip", false) == true
end

local function getInventoryItems(client)
    local char = IsValid(client) and client:GetCharacter() or nil
    if not char then return nil, nil end

    local inv = char:GetInventory()
    if not inv then return char, nil end

    return char, inv:GetItems(true)
end

local function resolveAttributeID(input)
    if not input then return nil end

    local lowered = string.lower(tostring(input))

    for k, v in pairs(ix.attributes.list or {}) do
        local keyName = string.lower(tostring(k))
        local shortName = v.shortname and string.lower(tostring(v.shortname)) or nil
        local fullName = v.name and string.lower(tostring(v.name)) or nil

        if lowered == keyName or lowered == shortName or lowered == fullName then
            return k
        end
    end

    return nil
end

local function clearBonuses(client, char)
    local oldBonuses = client.ixArtifactAttribBonuses or {}
    if table.IsEmpty(oldBonuses) then
        return
    end

    for attrID, oldBonus in pairs(oldBonuses) do
        if oldBonus ~= 0 then
            local current = char:GetAttribute(attrID, 0)
            local base = math.Clamp(current - oldBonus, 0, ATTRIBUTE_MAX_VALUE)
            char:SetAttrib(attrID, base)
        end
    end

    client.ixArtifactAttribBonuses = {}
end

local function applyBonuses(client, char, totals)
    local oldBonuses = client.ixArtifactAttribBonuses or {}
    local newBonuses = {}
    local processed = {}

    for attrID, oldBonus in pairs(oldBonuses) do
        local newBonus = totals[attrID] or 0
        local current = char:GetAttribute(attrID, 0)
        local base = math.Clamp(current - oldBonus, 0, ATTRIBUTE_MAX_VALUE)
        char:SetAttrib(attrID, math.Clamp(base + newBonus, 0, ATTRIBUTE_MAX_VALUE))
        processed[attrID] = true

        if newBonus ~= 0 then
            newBonuses[attrID] = newBonus
        end
    end

    for attrID, newBonus in pairs(totals) do
        if not processed[attrID] then
            local current = char:GetAttribute(attrID, 0)
            char:SetAttrib(attrID, math.Clamp(current + newBonus, 0, ATTRIBUTE_MAX_VALUE))

            if newBonus ~= 0 then
                newBonuses[attrID] = newBonus
            end
        end
    end

    client.ixArtifactAttribBonuses = newBonuses
end

function PLUGIN:Think()
    if nextThink > CurTime() then
        return
    end

    nextThink = CurTime() + APPLY_INTERVAL

    for _, client in ipairs(player.GetAll()) do
        if not IsValid(client) then
            continue
        end

        local char, items = getInventoryItems(client)
        if not char or not items then
            if char then
                clearBonuses(client, char)
            end
            continue
        end

        local totals = {}
        local radiation = 0

        for _, item in pairs(items) do
            if isAttributeArtifactActive(item) then
                if istable(item.attribBoosts) then
                    for rawAttrID, amount in pairs(item.attribBoosts) do
                        local attrID = resolveAttributeID(rawAttrID)

                        if attrID then
                            totals[attrID] = (totals[attrID] or 0) + math.floor(tonumber(amount) or 0)
                        else
                            print("[artifactattribs] Unknown attribute ID/shortname in item '" .. tostring(item.uniqueID or item.name or "unknown") .. "': " .. tostring(rawAttrID))
                        end
                    end
                end

                radiation = radiation + math.max(tonumber(item.artifactRadiation) or 0, 0)
            end
        end

        applyBonuses(client, char, totals)

        if radiation > 0 and client.addRadiation and client:Alive() and client:GetMoveType() ~= MOVETYPE_NOCLIP then
            client:addRadiation(radiation)
        end
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    client.ixArtifactAttribBonuses = {}
end

function PLUGIN:CharacterPreSave(character)
    local client = character and character.GetPlayer and character:GetPlayer() or nil
    if IsValid(client) then
        clearBonuses(client, character)
    end
end

function PLUGIN:PlayerDisconnected(client)
    local char = client:GetCharacter()
    if char then
        clearBonuses(client, char)
    end
end
