
if SERVER and not ix.artifactCoreInitialized then
    ix.artifactCoreInitialized = true

    local function GetArtifactItems(client)
        local char = IsValid(client) and client:GetCharacter()
        if not char then return {} end

        local inv = char:GetInventory()
        if not inv then return {} end

        local activeItems = {}

        for _, item in pairs(inv:GetItems(true) or {}) do
            if item and item.isArtifact and item:GetData("active", false) then
                activeItems[#activeItems + 1] = item
            end
        end

        return activeItems
    end

    local function GetArtifactTotals(client)
        local totals = {
            healthRegen = 0,
            radRegen = 0,
            artifactRadiation = 0,
            runSpeedMultBonus = 0,
            jumpVelocityBonus = 0,
            fallResist = 0,
            burnResist = 0,
            shockResist = 0,
            bulletResist = 0,
            bleedResist = 0
        }

        for _, item in ipairs(GetArtifactItems(client)) do
            totals.healthRegen = totals.healthRegen + (item.healthRegen or 0)
            totals.radRegen = totals.radRegen + (item.radRegen or 0)
            totals.artifactRadiation = totals.artifactRadiation + (item.artifactRadiation or 0)
            totals.runSpeedMultBonus = totals.runSpeedMultBonus + (item.runSpeedMultBonus or 0)
            totals.jumpVelocityBonus = totals.jumpVelocityBonus + (item.jumpVelocityBonus or 0)
            totals.fallResist = totals.fallResist + (item.fallResist or 0)
            totals.burnResist = totals.burnResist + (item.burnResist or 0)
            totals.shockResist = totals.shockResist + (item.shockResist or 0)
            totals.bulletResist = totals.bulletResist + (item.bulletResist or 0)
            totals.bleedResist = totals.bleedResist + (item.bleedResist or 0)
        end

        totals.fallResist = math.Clamp(totals.fallResist, 0, 0.85)
        totals.burnResist = math.Clamp(totals.burnResist, 0, 0.85)
        totals.shockResist = math.Clamp(totals.shockResist, 0, 0.85)
        totals.bulletResist = math.Clamp(totals.bulletResist, 0, 0.60)
        totals.bleedResist = math.Clamp(totals.bleedResist, 0, 0.70)

        return totals
    end

    local nextArtifactThink = 0

    hook.Add("Think", "ixArtifactCoreThink", function()
        if nextArtifactThink > CurTime() then return end
        nextArtifactThink = CurTime() + 2

        for _, client in ipairs(player.GetAll()) do
            if not IsValid(client) or not client:Alive() then continue end
            if client:GetMoveType() == MOVETYPE_NOCLIP then continue end
            if not client:GetCharacter() then continue end

            local totals = GetArtifactTotals(client)

            if totals.healthRegen > 0 and client:Health() > 0 then
                client:SetHealth(math.min(client:GetMaxHealth(), client:Health() + totals.healthRegen))
            end

            if client.addRadiation then
                local delta = totals.artifactRadiation - totals.radRegen
                if math.abs(delta) > 0 then
                    client:addRadiation(delta)
                end
            end
        end
    end)

    hook.Add("EntityTakeDamage", "ixArtifactCoreDamageResist", function(entity, dmgInfo)
        if not IsValid(entity) or not entity:IsPlayer() or not entity:Alive() then return end
        if not entity:GetCharacter() then return end

        local totals = GetArtifactTotals(entity)
        local scale = 1

        if dmgInfo:IsDamageType(DMG_BURN) or dmgInfo:IsDamageType(DMG_SLOWBURN) then
            scale = scale * (1 - totals.burnResist)
        end

        if dmgInfo:IsDamageType(DMG_SHOCK) then
            scale = scale * (1 - totals.shockResist)
        end

        if dmgInfo:IsDamageType(DMG_BULLET) then
            scale = scale * (1 - totals.bulletResist)
        end

        if dmgInfo:IsDamageType(DMG_SLASH) or dmgInfo:IsDamageType(DMG_CLUB) then
            scale = scale * (1 - totals.bleedResist)
        end

        if scale ~= 1 then
            dmgInfo:ScaleDamage(math.max(scale, 0.1))
        end
    end)

    hook.Add("GetFallDamage", "ixArtifactCoreFallResist", function(client, speed)
        if not IsValid(client) or not client:GetCharacter() then return end
        local totals = GetArtifactTotals(client)

        if totals.fallResist > 0 then
            local baseDamage = math.max(0, (speed - 580) * (100 / 444))
            return math.max(0, baseDamage * (1 - totals.fallResist))
        end
    end)

    hook.Add("Move", "ixArtifactCoreMove", function(client, mv)
        if not IsValid(client) or not client:Alive() then return end
        if not client:GetCharacter() then return end

        local totals = GetArtifactTotals(client)

        if totals.runSpeedMultBonus > 0 then
            mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * (1 + totals.runSpeedMultBonus))
            mv:SetMaxSpeed(mv:GetMaxSpeed() * (1 + totals.runSpeedMultBonus))
        end
    end)

    hook.Add("KeyPress", "ixArtifactCoreJump", function(client, key)
        if key ~= IN_JUMP then return end
        if not IsValid(client) or not client:Alive() or not client:GetCharacter() then return end
        if not client:OnGround() then return end
        if client:GetMoveType() == MOVETYPE_NOCLIP then return end

        local totals = GetArtifactTotals(client)
        if totals.jumpVelocityBonus > 0 then
            local vel = client:GetVelocity()
            client:SetVelocity(Vector(0, 0, -vel.z))
            client:SetVelocity(Vector(0, 0, totals.jumpVelocityBonus))
        end
    end)
end

ITEM.isArtifact = true
ITEM.category = "Артефакты"
ITEM.flag = "A"
ITEM.width = 1
ITEM.height = 1

function ITEM:getRadProt()
    return self.radProtPercent or 0
end

if CLIENT then
    local activeIcon = Material("vgui/ui/stalker/misc/equip.png")

    function ITEM:PaintOver(item, w, h)
        if item:GetData("active", false) then
            surface.SetDrawColor(110, 255, 110, 255)
            surface.SetMaterial(activeIcon)
            surface.DrawTexturedRect(w - 23, h - 23, 19, 19)
        end
    end
end

function ITEM:OnInstanced(invID, x, y)
    if self:GetData("active", false) and self:GetData("equip", nil) == nil then
        self:SetData("equip", true)
    end
end

local function deactivateArtifact(item, client, silent)
    if not item:GetData("active", false) then return false end

    item:SetData("active", false)
    item:SetData("equip", false)

    if IsValid(client) and not silent then
        client:Notify("Ты деактивировал артефакт: " .. item.name .. ".")
    end

    return false
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

        item:SetData("active", true)
        item:SetData("equip", true)
        client:Notify("Ты активировал артефакт: " .. item.name .. ".")
        return false
    end,
    OnCanRun = function(item)
        local client = item.player
        return not IsValid(item.entity) and IsValid(client) and client:GetCharacter()
            and item.invID == client:GetCharacter():GetInventory():GetID()
            and not item:GetData("active", false)
    end
}

ITEM.functions.Deactivate = {
    name = "Деактивировать",
    tip = "useTip",
    icon = "icon16/cancel.png",
    OnRun = function(item)
        return deactivateArtifact(item, item.player, false)
    end,
    OnCanRun = function(item)
        local client = item.player
        return not IsValid(item.entity) and IsValid(client) and client:GetCharacter()
            and item.invID == client:GetCharacter():GetInventory():GetID()
            and item:GetData("active", false)
    end
}

ITEM:Hook("drop", function(item)
    deactivateArtifact(item, item.player, true)
end)

ITEM.name = "Чёрная капля"
ITEM.description = "Тяжёлый тёмный артефакт. Делает тело выносливее и лучше держит удар, но ощутимо фонит."
ITEM.longdesc = "Редкий и капризный артефакт для тех, кто готов терпеть побочный радиационный фон ради выживаемости."
ITEM.model = "models/wick/wrbstalker/shoc/items/artefacts/wick_artefact_blackdrip_2.mdl"
ITEM.price = 9300
ITEM.healthRegen = 1
ITEM.bulletResist = 0.12
ITEM.bleedResist = 0.2
ITEM.artifactRadiation = 0.28

function ITEM:PopulateTooltipIndividual(tooltip)
    ix.util.PropertyDesc(tooltip, "Артефакт", Color(64, 224, 208))

    if self.flatRadProt and self.flatRadProt > 0 then
        ix.util.PropertyDesc(tooltip, "Защита от радиации: +" .. math.floor(self.flatRadProt * 100) .. "%", Color(110, 255, 110))
    end

    if self.radProtPercent and self.radProtPercent > 0 then
        ix.util.PropertyDesc(tooltip, "Снижение набора радиации: +" .. math.floor(self.radProtPercent * 100) .. "%", Color(110, 255, 110))
    end

    if self.radRegen and self.radRegen > 0 then
        ix.util.PropertyDesc(tooltip, "Вывод радиации: +" .. self.radRegen .. " / тик", Color(110, 255, 110))
    end

    if self.healthRegen and self.healthRegen > 0 then
        ix.util.PropertyDesc(tooltip, "Регенерация: +" .. self.healthRegen .. " HP / тик", Color(110, 255, 110))
    end

    if self.burnResist and self.burnResist > 0 then
        ix.util.PropertyDesc(tooltip, "Защита от ожогов: +" .. math.floor(self.burnResist * 100) .. "%", Color(110, 255, 110))
    end

    if self.shockResist and self.shockResist > 0 then
        ix.util.PropertyDesc(tooltip, "Защита от электричества: +" .. math.floor(self.shockResist * 100) .. "%", Color(110, 255, 110))
    end

    if self.bulletResist and self.bulletResist > 0 then
        ix.util.PropertyDesc(tooltip, "Смягчение пулевого урона: +" .. math.floor(self.bulletResist * 100) .. "%", Color(110, 255, 110))
    end

    if self.bleedResist and self.bleedResist > 0 then
        ix.util.PropertyDesc(tooltip, "Смягчение рваных ран: +" .. math.floor(self.bleedResist * 100) .. "%", Color(110, 255, 110))
    end

    if self.fallResist and self.fallResist > 0 then
        ix.util.PropertyDesc(tooltip, "Снижение урона от падения: +" .. math.floor(self.fallResist * 100) .. "%", Color(110, 255, 110))
    end

    if self.runSpeedMultBonus and self.runSpeedMultBonus > 0 then
        ix.util.PropertyDesc(tooltip, "Скорость: +" .. math.floor(self.runSpeedMultBonus * 100) .. "%", Color(110, 255, 110))
    end

    if self.jumpVelocityBonus and self.jumpVelocityBonus > 0 then
        ix.util.PropertyDesc(tooltip, "Прыжок: +" .. self.jumpVelocityBonus, Color(110, 255, 110))
    end

    if self.artifactRadiation and self.artifactRadiation > 0 then
        ix.util.PropertyDesc(tooltip, "Собственный радиационный фон: +" .. self.artifactRadiation .. " / тик", Color(255, 160, 110))
    end
end
