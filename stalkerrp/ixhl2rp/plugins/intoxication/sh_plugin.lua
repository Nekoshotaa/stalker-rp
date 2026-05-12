local PLUGIN = PLUGIN
PLUGIN.name = "Intoxication"
PLUGIN.author = "armdupe* / edited"
PLUGIN.description = "Soft intoxication system for alcohol items."

local playerMeta = FindMetaTable("Player")

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

function playerMeta:GetDrunkLevel()
    return self:GetLocalVar("drunklevel", 0)
end

ix.config.Add("intoxicationUpdateTime", 30, "How many seconds between sobriety updates.", nil, {
    data = {
        min = 1,
        max = 120
    },
    category = "intoxication"
})

ix.config.Add("intoxicationRecoverRate", 5, "How much drunk level is removed per update.", nil, {
    data = {
        min = 1,
        max = 100
    },
    category = "intoxication"
})

ix.config.Add("intoxicationSharpenStrength", 0.6, "Screen sharpen strength at high intoxication.", nil, {
    data = {
        min = 0,
        max = 3
    },
    category = "intoxication"
})

ix.config.Add("intoxicationWobbleEnabled", true, "Enable light view wobble when heavily intoxicated.", nil, {
    category = "intoxication"
})