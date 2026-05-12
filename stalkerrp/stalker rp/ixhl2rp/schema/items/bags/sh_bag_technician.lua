ITEM.name = "Рюкзак техника"
ITEM.description = "Усиленный рюкзак техника с дополнительными подсумками под инструменты и запчасти. Даёт +5 к навыку «Технические науки»."
ITEM.model = "models/kek1ch/dev_rukzak_stalker.mdl"

ITEM.price = 2800
ITEM.width = 2
ITEM.height = 2
ITEM.category = "Рюкзаки"

-- Рюкзак как стандартная сумка Helix
ITEM.isBag = true
ITEM.invWidth = 4
ITEM.invHeight = 4

-- Рюкзак как экипировка на спину
ITEM.outfitCategory = "Backpack"

ITEM.pacData = {
    [1] = {
        ["children"] = {
            [1] = {
                ["children"] = {},
                ["self"] = {
                    ["Angles"] = Angle(0, -90, 90),
                    ["Position"] = Vector(-6.8, 0, 1.5),
                    ["UniqueID"] = "bp_technician_model",
                    ["Size"] = 0.88,
                    ["Bone"] = "chest",
                    ["Model"] = "models/kek1ch/dev_rukzak_stalker.mdl",
                    ["ClassName"] = "model",
                },
            },
        },
        ["self"] = {
            ["ClassName"] = "group",
            ["UniqueID"] = "bp_technician_group",
            ["EditorExpand"] = true,
        },
    },
}

ITEM.techBonus = 5

local function ApplyTechBonus(item, client)
    if not IsValid(client) then return end

    local character = client:GetCharacter()
    if not character then return end
    if item:GetData("techApplied", false) then return end

    local current = character:GetAttribute("technical", 0)
    character:SetAttrib("technical", current + (item.techBonus or 0))
    item:SetData("techApplied", true)

    client:Notify("Рюкзак техника даёт +" .. tostring(item.techBonus or 0) .. " к навыку «Технические науки».")
end

local function RemoveTechBonus(item, client)
    if not IsValid(client) then return end

    local character = client:GetCharacter()
    if not character then return end
    if not item:GetData("techApplied", false) then return end

    local current = character:GetAttribute("technical", 0)
    character:SetAttrib("technical", math.max(current - (item.techBonus or 0), 0))
    item:SetData("techApplied", false)

    client:Notify("Бонус рюкзака техника снят.")
end

function ITEM:OnEquipped()
    local client = self.player or self:GetOwner()
    ApplyTechBonus(self, client)
end

function ITEM:OnUnEquipped()
    local client = self.player or self:GetOwner()
    RemoveTechBonus(self, client)
end

function ITEM:OnRemoved()
    local client = self.player or self:GetOwner()

    if self:GetData("equip", false) then
        RemoveTechBonus(self, client)
    end
end

ITEM.functions.Equip = {
    name = "Надеть",
    icon = "icon16/tick.png",

    OnRun = function(item)
        local client = item.player

        if not IsValid(client) then
            return false
        end

        local char = client:GetCharacter()
        if not char then
            return false
        end

        local inv = char:GetInventory()
        if not inv or item.invID ~= inv:GetID() then
            client:Notify("Рюкзак должен быть в вашем инвентаре.")
            return false
        end

        -- снимаем другой рюкзак, если он уже надет
        for _, v in pairs(inv:GetItems()) do
            if v.id ~= item.id and v.outfitCategory == "Backpack" and v:GetData("equip", false) then
                v:SetData("equip", false)
                if v.OnUnEquipped then
                    v.player = client
                    v:OnUnEquipped()
                    v.player = nil
                end
            end
        end

        item:SetData("equip", true)

        if item.OnEquipped then
            item.player = client
            item:OnEquipped()
            item.player = nil
        end

        return false
    end,

    OnCanRun = function(item)
        local client = item.player
        return not IsValid(item.entity)
            and IsValid(client)
            and item:GetData("equip", false) ~= true
            and item.invID == client:GetCharacter():GetInventory():GetID()
    end
}

ITEM.functions.Unequip = {
    name = "Снять",
    icon = "icon16/cross.png",

    OnRun = function(item)
        local client = item.player

        if not IsValid(client) then
            return false
        end

        item:SetData("equip", false)

        if item.OnUnEquipped then
            item.player = client
            item:OnUnEquipped()
            item.player = nil
        end

        return false
    end,

    OnCanRun = function(item)
        local client = item.player
        return not IsValid(item.entity)
            and IsValid(client)
            and item:GetData("equip", false) == true
            and item.invID == client:GetCharacter():GetInventory():GetID()
    end
}