PLUGIN.name = "RP Chat Command"
PLUGIN.author = "Ты"
PLUGIN.description = "Команда /rp через систему чатов Helix."

-- Радиус RP-сообщения (в юнитах Source)
local RP_RADIUS = 900000

ix.chat.Register("rp", {
    prefix = {"/rp"},
    description = "Отправить RP-действие.",
    indicator = "chatPerforming",

    -- Важно: первый аргумент self!
    CanHear = function(self, speaker, listener)
        if not (IsValid(speaker) and IsValid(listener)) then
            return false
        end

        return speaker:GetPos():DistToSqr(listener:GetPos()) <= RP_RADIUS * RP_RADIUS
    end,

    -- Тоже с self первым аргументом
    OnChatAdd = function(self, speaker, text, anonymous, data)
        if not IsValid(speaker) then return end

        local nameColor = Color(0, 150, 255)   -- синий для ника
        local textColor = Color(210, 50, 30) -- светло-серый для текста

        chat.AddText(
            Color(0, 150, 255), "[RP] ",
            nameColor, speaker:Name() .. ": ",
            textColor, text
        )
    end
})
