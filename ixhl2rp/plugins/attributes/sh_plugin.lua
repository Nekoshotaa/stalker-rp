local PLUGIN = PLUGIN
PLUGIN.name = "Rollable Stats"
PLUGIN.author = "Verne & Taylor"
PLUGIN.desc = "Stats used for rolling in various situations."

AddCSLuaFile("derma/cl_init.lua")
AddCSLuaFile("derma/rpg_menu.lua")

local ATTRIBUTE_MAX_VALUE = 100
local LOCAL_ROLL_MAX = 100
local GLOBAL_ROLL_MAX = 100

function PLUGIN:OnCharacterCreated(client, character)
	-- Не сбрасываем атрибуты при создании персонажа.
	-- Это сохраняет очки, которые игрок распределил в меню создания.
	if IsValid(client) then
		client:Notify("Персонаж создан.")
	end
end

local function FindAttributeByInput(stat)
	if not stat then return nil, nil end

	local lowered = string.lower(tostring(stat))

	for k, v in pairs(ix.attributes.list) do
		local keyName = string.lower(tostring(k))
		local shortName = v.shortname and string.lower(tostring(v.shortname)) or nil
		local fullName = v.name and string.lower(tostring(v.name)) or nil

		if lowered == keyName or lowered == shortName or lowered == fullName then
			return k, v
		end
	end

	return nil, nil
end

local function AutoAddExp(client, character, attr)
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
				client:Notify("Ваш уровень навыка \"" .. attr .. "\" повышен.")
			end
		end
	elseif levelvalue < 51 then
		if exp >= 75 then
			levelvalue = math.min(ATTRIBUTE_MAX_VALUE, levelvalue + math.random(3, 4))
			character:SetData(attr, 0)
			character:SetAttrib(attr, levelvalue)

			if IsValid(client) then
				client:Notify("Ваш уровень навыка \"" .. attr .. "\" повышен.")
			end
		end
	elseif levelvalue < 76 then
		if exp >= 100 then
			levelvalue = math.min(ATTRIBUTE_MAX_VALUE, levelvalue + math.random(2, 3))
			character:SetData(attr, 0)
			character:SetAttrib(attr, levelvalue)

			if IsValid(client) then
				client:Notify("Ваш уровень навыка \"" .. attr .. "\" повышен.")
			end
		end
	else
		if exp >= 150 then
			levelvalue = math.min(ATTRIBUTE_MAX_VALUE, levelvalue + 1)
			character:SetData(attr, 0)
			character:SetAttrib(attr, levelvalue)

			if IsValid(client) then
				client:Notify("Ваш уровень навыка \"" .. attr .. "\" повышен.")
			end
		end
	end
end

local function BuildRollText(attributeName, statvalue, roll, successrate)
	local str = "использует навык " .. attributeName .. " " .. statvalue ..
		" (Результат: " .. statvalue .. " + " .. roll .. " = " .. successrate .. ")"

	if successrate <= 10 then
		str = str .. " [Never gonna give you up!]"
	elseif successrate >= 96 then
		str = str .. " [Великолепно!]"
	elseif successrate >= 86 then
		str = str .. " [Отлично]"
	elseif successrate >= 76 then
		str = str .. " [Превосходно]"
	elseif successrate >= 66 then
		str = str .. " [Легко]"
	elseif successrate >= 56 then
		str = str .. " [Хорошо]"
	elseif successrate >= 46 then
		str = str .. " [Нормально]"
	elseif successrate >= 36 then
		str = str .. " [С натяжкой]"
	elseif successrate >= 26 then
		str = str .. " [Тяжело]"
	elseif successrate >= 16 then
		str = str .. " [Невозможно]"
	elseif successrate >= 11 then
		str = str .. " [Провал!]"
	else
		str = str .. " [Pizdec!]"
	end

	if roll >= 96 then
		str = str .. " [КРИТ. УДАЧА!]"
	elseif roll <= 5 then
		str = str .. " [КРИТ. ПРОВАЛ!]"
	end

	return str
end

local function BuildRollColor(successrate)
	local lerpValue = math.Clamp(successrate / ATTRIBUTE_MAX_VALUE, 0, 1)

	return Color(
		Lerp(lerpValue, 175, 100),
		Lerp(lerpValue, 0, 255),
		Lerp(lerpValue, 0, 100)
	)
end

ix.command.Add("aroll", {
	description = "Бросок навыка: атрибут + 1d100.",
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
			client:Notify("Вы указали неверный атрибут/навык.")
			return false
		end

		local exp = character:GetData(internalattriname, 0) + 1
		character:SetData(internalattriname, exp)
		AutoAddExp(client, character, internalattriname)

		local statvalue = character:GetAttribute(internalattriname, 0)
		local roll = math.random(1, LOCAL_ROLL_MAX)
		local successrate = statvalue + roll
		local str = BuildRollText(attrData.name, statvalue, roll, successrate)
		local color = BuildRollColor(successrate)

		ix.chat.Send(client, "aroll", str, nil, nil, {
			color = color
		})

		hook.Run("RPGRoll", client, str, internalattriname, successrate, false)
	end
})

ix.command.Add("groll", {
	description = "Глобальный бросок навыка: атрибут + 1d100.",
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
			client:Notify("Вы указали неверный атрибут/навык.")
			return false
		end

		local exp = character:GetData(internalattriname, 0) + 1
		character:SetData(internalattriname, exp)
		AutoAddExp(client, character, internalattriname)

		local statvalue = character:GetAttribute(internalattriname, 0)
		local roll = math.random(1, GLOBAL_ROLL_MAX)
		local successrate = statvalue + roll
		local str = BuildRollText(attrData.name, statvalue, roll, successrate)
		local color = BuildRollColor(successrate)

		ix.chat.Send(client, "globalattr", str, nil, nil, {
			color = color
		})

		hook.Run("RPGRoll", client, str, internalattriname, successrate, true)
	end
})

ix.command.Add("LevelAtt", {
	description = "Изменить уровень атрибута персонажа.",
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

		local internalattriname = FindAttributeByInput(stat)

		if not internalattriname then
			client:Notify("Указан неверный атрибут.")
			return false
		end

		level = math.Clamp(math.floor(level), 0, ATTRIBUTE_MAX_VALUE)
		character:SetAttrib(internalattriname, level)
		client:Notify("Атрибуту выдан новый уровень.")
	end
})

ix.command.Add("initiative", {
	description = "Рассчитать инициативу.",
	OnRun = function(self, client)
		local character = client:GetCharacter()
		if not character then
			client:Notify("Персонаж не найден.")
			return false
		end

		local agi = character:GetAttribute("agility", 0)
		local agibonus = math.Truncate(agi / 10)
		local initroll = math.random(1, 10) + agibonus
		local str = "rolled an initiative of " .. initroll .. "."

		ix.chat.Send(client, "rollstat", str, nil, nil)
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
			Color(255, 70, 70), "[",
			Color(255, 255, 255), "Global Attribute",
			Color(255, 70, 70), "] ",
			rollColor, speaker:GetName() .. " " .. text
		)
	end
})

local charMeta = ix.meta.character

if SERVER then
	function charMeta:setRPGValues()
		local inventory = self:GetInventory()
		local head = 0
		local body = 0
		local limb = 0
		local endboost = 0
		local agiboost = 0
		local strboost = 0
		local perboost = 0

		if self:GetData("boosted", false) == false then
			self:SetData("endorig", self:GetAttribute("endurance", 0))
			self:SetData("agiorig", self:GetAttribute("agility", 0))
			self:SetData("strorig", self:GetAttribute("strength", 0))
			self:SetData("perorig", self:GetAttribute("perception", 0))
		end

		if inventory then
			local items = inventory:GetItems()

			for _, item in pairs(items) do
				if item:GetData("equip") == true then
					if item:GetData("head") then
						for _, tab in pairs(item:GetData("head")) do
							head = head + (tab.amount or 0)
						end
					end

					if item:GetData("body") then
						for _, tab in pairs(item:GetData("body")) do
							body = body + (tab.amount or 0)
						end
					end

					if item:GetData("limb") then
						for _, tab in pairs(item:GetData("limb")) do
							limb = limb + (tab.amount or 0)
						end
					end

					if item:GetData("end") then
						for _, tab in pairs(item:GetData("end")) do
							endboost = endboost + (tab.amount or 0)
						end
					end

					if item:GetData("agi") then
						for _, tab in pairs(item:GetData("agi")) do
							agiboost = agiboost + (tab.amount or 0)
						end
					end

					if item:GetData("str") then
						for _, tab in pairs(item:GetData("str")) do
							strboost = strboost + (tab.amount or 0)
						end
					end

					if item:GetData("per") then
						for _, tab in pairs(item:GetData("per")) do
							perboost = perboost + (tab.amount or 0)
						end
					end

					if item.ballisticrpglevels then
						if item.ballisticrpglevels["head"] then
							head = head + tonumber(item.ballisticrpglevels["head"])
						end

						if item.ballisticrpglevels["body"] then
							body = body + tonumber(item.ballisticrpglevels["body"])
						end

						if item.ballisticrpglevels["limb"] then
							limb = limb + tonumber(item.ballisticrpglevels["limb"])
						end
					end
				end
			end

			self:SetData("boosted", (endboost > 0 or agiboost > 0 or strboost > 0 or perboost > 0))

			self:SetAttrib("endurance", (self:GetData("endorig", self:GetAttribute("endurance", 0)) + endboost))
			self:SetAttrib("agility", (self:GetData("agiorig", self:GetAttribute("agility", 0)) + agiboost))
			self:SetAttrib("strength", (self:GetData("strorig", self:GetAttribute("strength", 0)) + strboost))
			self:SetAttrib("perception", (self:GetData("perorig", self:GetAttribute("perception", 0)) + perboost))

			local endur = math.Truncate(self:GetAttribute("endurance", 0) / 10)

			head = head + endur
			body = body + endur
			limb = limb + endur

			self:SetAttrib("armorpointshead", head)
			self:SetAttrib("armorpointsbody", body)
			self:SetAttrib("armorpointslimb", limb)
		end
	end
end