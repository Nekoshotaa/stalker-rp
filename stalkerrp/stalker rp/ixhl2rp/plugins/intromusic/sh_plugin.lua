local PLUGIN = PLUGIN

PLUGIN.name = "Intro Music"
PLUGIN.description = "Plays music on character load."
PLUGIN.author = "Riggs"
PLUGIN.schema = "HL2 RP"
PLUGIN.license = [[
Copyright 2026 Riggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

PLUGIN.introMusic = {
    ["hl1"] = {
        name = "fotograf",
        citizenMusic = {
            "other/anecdote_mauvais_fotograf.ogg",
        },
    },
}

ix.lang.AddTable("english", {
    optIntroMusic = "Intro Music",
    optdIntroMusic = "What type of music should play once you load in a character?",
})

ix.option.Add("introMusic", ix.type.array, "hl1", {
    category = PLUGIN.name,
    bNetworked = true,
    populate = function()
        local entries = {}

        for k, v in pairs(PLUGIN.introMusic) do
            entries[k] = v.name
        end

        return entries
    end
})

ix.util.Include("sv_plugin.lua")
