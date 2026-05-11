
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Артефакты"
ITEM.flag = "A"
ITEM.isArtifact = true
ITEM.isAttributeArtifact = true

ITEM.equipIcon = ix.util.GetMaterial("materials/vgui/ui/stalker/misc/equip.png")

if CLIENT then
    function ITEM:PaintOver(item, w, h)
        if item:GetData("active", false) then
            surface.SetDrawColor(110, 255, 110, 255)
            surface.SetMaterial(item.equipIcon)
            surface.DrawTexturedRect(w - 23, h - 23, 19, 19)
        end
    end
end

local function DeactivateArtifact(item, client, silent)
    item:SetData("active", false)
    item:SetData("equip", false)

    if IsValid(client) and not silent then
        client:Notify("Ты деактивировал артефакт: " .. item.name .. ".")
    end

    return false
end

local function HasAnotherSpecialArtifactActive(item, client)
    local char = IsValid(client) and client:GetCharacter() or nil
    local inv = char and char:GetInventory() or nil
    if not inv then return false end

    for _, other in pairs(inv:GetItems(true) or {}) do
        if other
            and other.id ~= item.id
            and other.isAttributeArtifact
            and other:GetData("active", false) == true then
            return true, other
        end
    end

    return false, nil
end

ITEM.functions.Activate = {
    name = "Активировать",
    tip = "useTip",
    icon = "icon16/lightning.png",
    OnRun = function(item)
        local client = item.player
        if not IsValid(client) then return false end

        if item:GetData("active", false) then
            client:Notify("Этот артефакт уже активирован.")
            return false
        end

        local hasOther, other = HasAnotherSpecialArtifactActive(item, client)
        if hasOther then
            client:Notify("Сначала деактивируй другой особый артефакт: " .. (other.name or "неизвестный"))
            return false
        end

        item:SetData("active", true)
        item:SetData("equip", true)
        client:Notify("Ты активировал артефакт: " .. item.name .. ".")
        return false
    end,
    OnCanRun = function(item)
        local client = item.player
        return not IsValid(item.entity)
            and IsValid(client)
            and client:GetCharacter()
            and item.invID == client:GetCharacter():GetInventory():GetID()
            and not item:GetData("active", false)
    end
}

ITEM.functions.Deactivate = {
    name = "Деактивировать",
    tip = "useTip",
    icon = "icon16/cancel.png",
    OnRun = function(item)
        return DeactivateArtifact(item, item.player, false)
    end,
    OnCanRun = function(item)
        local client = item.player
        return not IsValid(item.entity)
            and IsValid(client)
            and client:GetCharacter()
            and item.invID == client:GetCharacter():GetInventory():GetID()
            and item:GetData("active", false)
    end
}

ITEM:Hook("drop", function(item)
    DeactivateArtifact(item, item.player, true)
end)

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Особый артефакт", Color(180, 120, 255))

    if istable(self.attribBoosts) then
        for attrID, amount in pairs(self.attribBoosts) do
            local attrData = ix.attributes.list and ix.attributes.list[attrID]
            local attrName = attrData and attrData.name or attrID
            ix.util.PropertyDesc(tooltip, attrName .. ": +" .. tostring(amount), Color(110, 255, 110))
        end
    end

    if self.artifactRadiation and self.artifactRadiation > 0 then
        ix.util.PropertyDesc(tooltip, "Собственный радиационный фон: +" .. tostring(self.artifactRadiation) .. " / тик", Color(255, 160, 110))
    end
end

ITEM.name = "Череп Томми Бричерсона"
ITEM.description = "Зловещий артефакт, похожий на иссохший череп. Рядом с ним слова звучат тяжелее, а взгляды становятся неуютными."
ITEM.longdesc = "Говорят, если долго смотреть в пустые глазницы, начинает казаться, что артефакт смотрит в ответ. Даёт носителю жуткую весомость в глазах окружающих, но ощутимо фонит."
ITEM.model = "models/wick/anarchycell/items/artefacts/builds/anarchycell_dead_head.mdl"
ITEM.price = 26500
ITEM.artifactRadiation = 0.55
ITEM.attribBoosts = {
	["aut"] = 5,
}
