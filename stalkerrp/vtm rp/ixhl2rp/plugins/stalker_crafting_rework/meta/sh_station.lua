local PLUGIN = PLUGIN
PLUGIN.meta = PLUGIN.meta or {}

local STATION = PLUGIN.meta.station or {}
STATION.__index = STATION
STATION.name = "Неизвестная станция"
STATION.description = "Описание станции не задано."
STATION.uniqueID = "undefined"
STATION.range = 100

function STATION:GetName()
    return self.name or self.uniqueID
end

function STATION:GetDescription()
    return self.description or ""
end

function STATION:GetModel()
    return self.model
end

PLUGIN.meta.station = STATION
