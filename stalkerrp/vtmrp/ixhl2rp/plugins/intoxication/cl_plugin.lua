local PLUGIN = PLUGIN

function PLUGIN:RenderScreenspaceEffects()
    local client = LocalPlayer()

    if not IsValid(client) then
        return
    end

    local drunkLevel = client:GetDrunkLevel()

    if drunkLevel <= 10 then
        return
    end

    local sharpenStrength = ix.config.Get("intoxicationSharpenStrength", 0.6)
    local contrast = math.Clamp((drunkLevel - 10) / 90, 0, 1.2)

    DrawSharpen(sharpenStrength, contrast)
end

function PLUGIN:CalcView(client, origin, angles, fov)
    if not ix.config.Get("intoxicationWobbleEnabled", true) then
        return
    end

    local drunkLevel = client:GetDrunkLevel()

    if drunkLevel < 35 then
        return
    end

    local time = CurTime()
    local intensity = math.Clamp((drunkLevel - 35) / 65, 0, 1)

    local newAngles = Angle(angles.p, angles.y, angles.r)
    newAngles.r = newAngles.r + math.sin(time * 1.2) * 1.5 * intensity
    newAngles.p = newAngles.p + math.cos(time * 0.9) * 0.6 * intensity
    newAngles.y = newAngles.y + math.sin(time * 0.7) * 0.8 * intensity

    return {
        origin = origin,
        angles = newAngles,
        fov = fov
    }
end