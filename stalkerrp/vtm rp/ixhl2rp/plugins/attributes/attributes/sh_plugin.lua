local PLUGIN = PLUGIN

PLUGIN.name = "VTM Rollable Attributes"
PLUGIN.author = "Verne & Taylor / Nekoshotaa / ChatGPT"
PLUGIN.desc = "Атрибуты и проверки для VTM: Wild West хроники."

AddCSLuaFile("derma/cl_init.lua")
AddCSLuaFile("derma/rpg_menu.lua")

-- Шкала 0-100 оставлена для совместимости со старой системой Helix.
-- Условное соответствие VTM-точкам:
-- 0-20 = 1 точка, 21-40 = 2, 41-60 = 3, 61-80 = 4, 81-100 = 5.
local ATTRIBUTE_MAX_VALUE = 100
local LOCAL_ROLL_MAX = 100
local GLOBAL_ROLL_MAX = 100
local ENABLE_AUTO_PROGRESS = false -- Для ваншота лучше false. Если нужна автопрокачка от бросков — поставь true.

function PLUGIN:OnCharacterCreated(client, character)
	if IsValid(client) then
		client:Notify("Персонаж создан.")
	end
end

local function SafeLower(value)
	return string.lower(tostring(value or ""))
end

local function CleanAttributeName(value)
	local text = tostring(value or "")
	text = string.gsub(text, "%s*%b()", "") -- убирает код в скобках: "Сила (STR)" -> "Сила"
	text = string.Trim(text)
	return text
end

local function FindAttributeByInput(stat)
	if not stat then return nil, nil end

	local raw = tostring(stat)
	local lowered = SafeLower(raw)
	local cleaned = CleanAttributeName(raw)
	local cleanedLower = SafeLower(cleaned)

	for k, v in pairs(ix.attributes.list) do
		local keyName = SafeLower(k)
		local shortName = v.shortname and SafeLower(v.shortname) or nil
		local fullNameRaw = v.name and tostring(v.name) or ""
		local fullName = SafeLower(fullNameRaw)
		local fullNameClean = SafeLower(CleanAttributeName(fullNameRaw))

		if lowered == keyName or lowered == shortName or lowered == fullName or lowered == fullNameClean or cleanedLower == fullNameClean then
			return k, v
		end
	end

	return nil, nil
end

local function GetAttributeDisplayName(attrKey, attrData)
	if attrData and attrData.name then
		return attrData.name
	end

	return tostring(attrKey or "неизвестный параметр")
end

local function AutoAddExp(client, character, attr)
	if not ENABLE_AUTO_PROGRESS then return end
	if not character or not attr then return end

	local levelvalue = character:GetAttribute(attr, 0)
	local exp = character:GetData(attr, 0)

	if levelvalue >= ATTRIBUTE_MAX_VALUE then
		return
	end

	if levelvalue < 26 then
		if exp >= 50 then
			levelvalue = math.min(ATTRIBUTE_MAX_VALUE, levelvalue + math.random(4, 5))
			character:SetData(attr, 0)
			character:SetAttrib(attr, levelvalue)

			if IsValid(client) then
				client:Notify("Параметр повышен: " .. attr .. ".")
			end
		end
	elseif levelvalue < 51 then
		if exp >= 75 then
			levelvalue = math.min(ATTRIBUTE_MAX_VALUE, levelvalue + math.random(3, 4))
			character:SetData(attr, 0)
			character:SetAttrib(attr, levelvalue)

			if IsValid(client) then
				client:Notify("Параметр повышен: " .. attr .. ".")
			end
		end
	elseif levelvalue < 76 then
		if exp >= 100 then
			levelvalue = math.min(ATTRIBUTE_MAX_VALUE, levelvalue + math.random(2, 3))
			character:SetData(attr, 0)
			character:SetAttrib(attr, levelvalue)

			if IsValid(client) then
				client:Notify("Параметр повышен: " .. attr .. ".")
			end
		end
	else
		if exp >= 150 then
			levelvalue = math.min(ATTRIBUTE_MAX_VALUE, levelvalue + 1)
			character:SetData(attr, 0)
			character:SetAttrib(attr, levelvalue)

			if IsValid(client) then
				client:Notify("Параметр повышен: " .. attr .. ".")
			end
		end
	end
end

local function BuildRollText(attributeName, statvalue, roll, successrate)
	local str = "делает проверку: " .. attributeName .. " " .. statvalue ..
		" (Результат: " .. statvalue .. " + " .. roll .. " = " .. successrate .. ")"

	if roll <= 5 then
		str = str .. " [КРИТИЧЕСКИЙ ПРОВАЛ]"
	elseif roll >= 96 then
		str = str .. " [КРИТИЧЕСКАЯ УДАЧА]"
	end

	if successrate >= 175 then
		str = str .. " [Легендарно]"
	elseif successrate >= 150 then
		str = str .. " [Великолепно]"
	elseif successrate >= 125 then
		str = str .. " [Отлично]"
	elseif successrate >= 100 then
		str = str .. " [Успешно]"
	elseif successrate >= 75 then
		str = str .. " [С натяжкой]"
	elseif successrate >= 50 then
		str = str .. " [Тяжело]"
	elseif successrate >= 25 then
		str = str .. " [Провал]"
	else
		str = str .. " [Полный провал]"
	end

	return str
end

local function BuildRollColor(successrate)
	local lerpValue = math.Clamp(successrate / (ATTRIBUTE_MAX_VALUE + LOCAL_ROLL_MAX), 0, 1)

	return Color(
		Lerp(lerpValue, 175, 100),
		Lerp(lerpValue, 0, 255),
		Lerp(lerpValue, 0, 100)
	)
end

ix.command.Add("aroll", {
	description = "Локальная проверка параметра: значение + 1d100. Пример: /aroll fir или /aroll firearms.",
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, stat)
		local character = client:GetCharacter()
		if not character then
			client:Notify("Персонаж не найден.")
			return false
		end

		local internalattriname, attrData = FindAttributeByInput(stat)

		if not internalattriname or not attrData or not attrData.name then
			client:Notify("Вы указали неверный параметр. Используй короткий код вроде fir, dex, occ, rid.")
			return false
		end

		if ENABLE_AUTO_PROGRESS then
			local exp = character:GetData(internalattriname, 0) + 1
			character:SetData(internalattriname, exp)
			AutoAddExp(client, character, internalattriname)
		end

		local statvalue = character:GetAttribute(internalattriname, 0)
		local roll = math.random(1, LOCAL_ROLL_MAX)
		local successrate = statvalue + roll
		local str = BuildRollText(GetAttributeDisplayName(internalattriname, attrData), statvalue, roll, successrate)
		local color = BuildRollColor(successrate)

		ix.chat.Send(client, "aroll", str, nil, nil, {
			color = color
		})

		hook.Run("RPGRoll", client, str, internalattriname, successrate, false)
	end
})

ix.command.Add("groll", {
	description = "Глобальная проверка параметра: значение + 1d100. Пример: /groll per.",
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, stat)
		local character = client:GetCharacter()
		if not character then
			client:Notify("Персонаж не найден.")
			return false
		end

		local internalattriname, attrData = FindAttributeByInput(stat)

		if not internalattriname or not attrData or not attrData.name then
			client:Notify("Вы указали неверный параметр. Используй короткий код вроде fir, dex, occ, rid.")
			return false
		end

		if ENABLE_AUTO_PROGRESS then
			local exp = character:GetData(internalattriname, 0) + 1
			character:SetData(internalattriname, exp)
			AutoAddExp(client, character, internalattriname)
		end

		local statvalue = character:GetAttribute(internalattriname, 0)
		local roll = math.random(1, GLOBAL_ROLL_MAX)
		local successrate = statvalue + roll
		local str = BuildRollText(GetAttributeDisplayName(internalattriname, attrData), statvalue, roll, successrate)
		local color = BuildRollColor(successrate)

		ix.chat.Send(client, "globalattr", str, nil, nil, {
			color = color
		})

		hook.Run("RPGRoll", client, str, internalattriname, successrate, true)
	end
})

ix.command.Add("LevelAtt", {
	description = "Изменить уровень параметра персонажа.",
	arguments = {
		ix.type.character,
		ix.type.string,
		ix.type.number
	},
	adminOnly = true,
	OnRun = function(self, client, characterTarget, stat, level)
		local character = characterTarget
		if character == nil then
			client:Notify("Такого персонажа нет.")
			return false
		end

		local internalattriname, attrData = FindAttributeByInput(stat)

		if not internalattriname then
			client:Notify("Указан неверный параметр.")
			return false
		end

		level = math.Clamp(math.floor(level), 0, ATTRIBUTE_MAX_VALUE)
		character:SetAttrib(internalattriname, level)
		client:Notify("Параметр изменён: " .. GetAttributeDisplayName(internalattriname, attrData) .. " = " .. level .. ".")
	end
})

ix.command.Add("initiative", {
	description = "Рассчитать инициативу по VTM-логике: 1d10 + Ловкость/10 + Смекалка/10.",
	OnRun = function(self, client)
		local character = client:GetCharacter()
		if not character then
			client:Notify("Персонаж не найден.")
			return false
		end

		local dex = character:GetAttribute("dexterity", 0)
		local wits = character:GetAttribute("wits", 0)
		local bonus = math.Truncate(dex / 10) + math.Truncate(wits / 10)
		local initroll = math.random(1, 10) + bonus
		local str = "бросает инициативу: 1d10 + Ловкость/10 + Смекалка/10 = " .. initroll .. "."

		ix.chat.Send(client, "aroll", str, nil, nil, { color = Color(205, 170, 110) })
		hook.Run("RPGRoll", client, str)
	end
})

ix.chat.Register("aroll", {
	format = "** %s %s",
	color = Color(155, 111, 176),
	CanHear = (ix.config.Get("chatRange", 280) * 5),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(data.color or self.color, string.format(self.format, speaker:GetName(), text))
	end
})

ix.chat.Register("globalattr", {
	format = "%s %s",
	color = Color(255, 255, 255),
	CanHear = function(self, speaker, listener)
		return true
	end,
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		local rollColor = (data and data.color) or self.color

		chat.AddText(
			Color(120, 0, 0), "[",
			Color(255, 255, 255), "Глобальная проверка",
			Color(120, 0, 0), "] ",
			rollColor, speaker:GetName() .. " " .. text
		)
	end
})

-- Совместимость со старыми предметами/плагинами, которые могли вызывать character:setRPGValues().
-- В VTM-сборке броня/бусты STALKER пока не используются, поэтому функция безопасно ничего не делает.
local charMeta = ix.meta.character
if SERVER then
	function charMeta:setRPGValues()
		return
	end
end
