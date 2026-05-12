ITEM.name = "Заливное"
ITEM.description = "Тяжёлая, сытная еда. Неплохо набивает желудок и делает человека устойчивее к нагрузкам."
ITEM.model = "models/props/stalcraft/kastrulyasup2.mdl"
ITEM.uniqueID = "zalivnoe"
ITEM.category = "Еда"

ITEM.width = 2
ITEM.height = 2
ITEM.price = 1500

ITEM.hunger = 35
ITEM.thirst = -5
ITEM.sound = "stalkersound/inv_eat_mutant_food.mp3"
ITEM.attribBoosts = {
    ["stb"] = 1
}

local function ClampNeeds(client, hungerDelta, thirstDelta)
    if not IsValid(client) or not client.GetCharacter or not client:GetCharacter() then
        return
    end

    if isnumber(hungerDelta) and client.GetHunger and client.SetHunger then
        client:SetHunger(math.Clamp((client:GetHunger() or 100) + hungerDelta, 0, 100))
    end

    if isnumber(thirstDelta) and client.GetThirst and client.SetThirst then
        client:SetThirst(math.Clamp((client:GetThirst() or 100) + thirstDelta, 0, 100))
    end
end

local function ResolveAttributeKey(attributeID)
    if not attributeID or attributeID == "" then
        return nil, nil
    end

    local lowered = string.lower(tostring(attributeID))

    for key, data in pairs(ix.attributes.list) do
        local keyLower = string.lower(tostring(key))
        local shortLower = data.shortname and string.lower(tostring(data.shortname)) or ""
        local nameLower = data.name and string.lower(tostring(data.name)) or ""

        if lowered == keyLower or lowered == shortLower or lowered == nameLower then
            return key, data
        end
    end

    return nil, nil
end

function ITEM:GetDescription()
    local desc = self.description or ""
    desc = desc .. "\n\nВосстанавливает голод: " .. tostring(self.hunger or 0)
    desc = desc .. "\nИзменяет жажду: " .. tostring(self.thirst or 0)
    desc = desc .. "\nДаёт постоянный бонус: +1 к устойчивости"
    return desc
end

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Еда", Color(205, 170, 125))
    ix.util.PropertyDesc(tooltip, "+1 Устойчивость", Color(120, 200, 120))
end

ITEM.functions.Use = {
    name = "Съесть",
    icon = "icon16/cup.png",

    OnRun = function(item)
        local client = item.player

        if not IsValid(client) then
            return false
        end

        local char = client:GetCharacter()
        if not char then
            return false
        end

        client:EmitSound(item.sound or "items/battery_pickup.wav")
        ClampNeeds(client, item.hunger or 0, item.thirst or 0)

        local changes = {}

        for rawID, boost in pairs(item.attribBoosts or {}) do
            boost = tonumber(boost) or 0

            if boost ~= 0 then
                local attribKey, attribData = ResolveAttributeKey(rawID)

                if attribKey then
                    local current = char:GetAttribute(attribKey, 0)
                    local newValue = math.min(current + boost, 100)

                    char:SetAttrib(attribKey, newValue)
                    table.insert(changes, ((attribData and attribData.name) or attribKey) .. " +" .. boost)
                end
            end
        end

        if #changes > 0 then
            client:Notify("Вы чувствуете себя крепче: " .. table.concat(changes, ", ") .. ".")
        end

        ix.chat.Send(client, "iteminternal", "ест " .. item.name .. ".", false)

        return true
    end,

    OnCanRun = function(item)
        return not IsValid(item.entity)
    end
}
