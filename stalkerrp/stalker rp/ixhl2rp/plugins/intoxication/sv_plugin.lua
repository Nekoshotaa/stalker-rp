local PLUGIN = PLUGIN
local playerMeta = FindMetaTable("Player")

function playerMeta:ResetDrunkLevel()
    self:SetLocalVar("drunklevel", 0)
end

function playerMeta:IncreaseDrunkLevel(amount)
    if not isnumber(amount) then
        return
    end

    self:SetLocalVar("drunklevel", math.Clamp(self:GetLocalVar("drunklevel", 0) + amount, 0, 100))
end

function playerMeta:DecreaseDrunkLevel(amount)
    if not isnumber(amount) then
        return
    end

    self:SetLocalVar("drunklevel", math.Clamp(self:GetLocalVar("drunklevel", 0) - amount, 0, 100))
end

function PLUGIN:Think()
    self.nextThink = self.nextThink or CurTime()

    if CurTime() < self.nextThink then
        return
    end

    local recoverRate = ix.config.Get("intoxicationRecoverRate", 5)

    for _, client in ipairs(player.GetAll()) do
        local level = client:GetDrunkLevel()

        if level > 0 then
            client:SetLocalVar("drunklevel", math.Clamp(level - recoverRate, 0, 100))
        end
    end

    self.nextThink = CurTime() + ix.config.Get("intoxicationUpdateTime", 30)
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        if IsValid(client) then
            client:ResetDrunkLevel()
        end
    end)
end

function PLUGIN:PlayerSpawn(client)
    client:ResetDrunkLevel()
end