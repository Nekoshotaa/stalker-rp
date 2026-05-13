PLUGIN.name = "Extra Commands"
PLUGIN.author = "Luna / cleaned"
PLUGIN.desc = "Minimal useful admin commands."

local function sendColoredGlobal(color, text)
	for _, client in ipairs(player.GetAll()) do
		if IsValid(client) then
			netstream.Start(client, "ixExtraCommandsColoredText", color, text)
		end
	end
end

if SERVER then
	util.AddNetworkString("ixExtraCommandsColoredText")
else
	netstream.Hook("ixExtraCommandsColoredText", function(color, text)
		chat.AddText(color, text)
	end)
end

ix.command.Add("advert", {
	description = "Отправить оранжевое объявление без префикса.",
	arguments = ix.type.text,
	adminOnly = true,
	OnRun = function(self, client, text)
		if SERVER then
			sendColoredGlobal(Color(255, 170, 70), text)
		end
	end
})

ix.command.Add("notice", {
	description = "Отправить синее объявление без префикса.",
	arguments = ix.type.text,
	adminOnly = true,
	OnRun = function(self, client, text)
		if SERVER then
			sendColoredGlobal(Color(90, 170, 255), text)
		end
	end
})

ix.command.Add("alert", {
	description = "Отправить красное объявление без префикса.",
	arguments = ix.type.text,
	adminOnly = true,
	OnRun = function(self, client, text)
		if SERVER then
			sendColoredGlobal(Color(255, 90, 90), text)
		end
	end
})

ix.command.Add("clearitems", {
	adminOnly = true,
	alias = {"removeitems", "cleanitems"},
	OnRun = function(self, client)
		for _, ent in ipairs(ents.FindByClass("ix_item")) do
			if IsValid(ent) then
				ent:Remove()
			end
		end

		client:Notify("All items have been cleaned up from the map.")
	end
})

ix.command.Add("clearnpcs", {
	adminOnly = true,
	alias = {"removenpcs", "cleannpcs"},
	OnRun = function(self, client)
		for _, ent in ipairs(ents.GetAll()) do
			if IsValid(ent) and (
				ent:IsNPC()
				or baseclass.Get(ent:GetClass()).Base == "base_nextbot"
				or baseclass.Get(ent:GetClass()).Base == "nz_base"
				or baseclass.Get(ent:GetClass()).Base == "nz_risen"
			) and not IsFriendEntityName(ent:GetClass()) then
				ent:Remove()
			end
		end

		client:Notify("All NPCs and Nextbots have been cleaned up from the map.")
	end
})

ix.command.Add("spawnitem", {
	description = "Spawns an item where you look",
	adminOnly = true,
	arguments = {
		ix.type.string,
	},
	OnRun = function(self, client, itemIDToSpawn)
		if not (IsValid(client) and client:GetChar()) then
			return
		end

		local uniqueID = string.lower(itemIDToSpawn)

		if not ix.item.list[uniqueID] then
			for k, v in SortedPairs(ix.item.list) do
				if ix.util.StringMatches(v.name, uniqueID) then
					uniqueID = k
					break
				end
			end
		end

		if not ix.item.list[uniqueID] then
			client:Notify("No item exists with this unique ID.")
			return
		end

		local aimPos = client:GetEyeTraceNoCursor().HitPos
		aimPos:Add(Vector(0, 0, 10))
		ix.item.Spawn(uniqueID, aimPos)
	end
})

ix.command.Add("CharResetValues", {
	adminOnly = true,
	description = "Resets character values such as hunger, thirst, psyhealth, hp, etc.",
	arguments = {bit.bor(ix.type.string, ix.type.optional)},
	OnRun = function(self, client, target)
		if not target or target == "" then
			target = client:GetCharacter():GetName()
		end

		local foundTarget = ix.util.FindPlayer(target)

		if not foundTarget then
			client:Notify("Invalid Target!")
			return
		end

		foundTarget:SetPsyHealth(100)
		foundTarget:SetHunger(100)
		foundTarget:SetThirst(100)
		foundTarget:setRadiation(0)
		foundTarget:SetHealth(100)
		foundTarget:SetLocalVar("stm", 100)
		foundTarget:ResetDrunkLevel()

		if client == foundTarget then
			client:Notify("You have reset your character values")
		else
			client:Notify("You have reset " .. foundTarget:Name() .. "'s character values")
			foundTarget:Notify(client:Name() .. " has reset your character values")
		end

		foundTarget:UpdatePsyHealthState(foundTarget)
		foundTarget:UpdateHungerState(foundTarget)
		foundTarget:UpdateThirstState(foundTarget)
	end
})

ix.command.Add("clearinv", {
	description = "Removes all the items in the target characters inventory.",
	adminOnly = true,
	arguments = {
		ix.type.character
	},
	OnRun = function(self, client, character)
		if character then
			for _, item in pairs(character:GetInventory():GetItems()) do
				item:Remove()
			end

			client:Notify("The inventory of " .. character:GetName() .. " has been cleared.")
			ix.weight.Update(character)
			client:Notify("Weight of " .. character:GetName() .. " has been set to 0.")
		end
	end
})

ix.command.Add("plytogglehidden", {
	description = "Hides the given player from being displayed on the scoreboard.",
	adminOnly = true,
	arguments = {
		ix.type.player
	},
	OnRun = function(self, client, target)
		if target then
			if target:GetNetVar("scoreboardhidden", false) then
				target:SetNetVar("scoreboardhidden", false)
				client:Notify(target:GetName() .. " is now displayed on the scoreboard.")
			else
				target:SetNetVar("scoreboardhidden", true)
				client:Notify(target:GetName() .. " has been hidden on the scoreboard.")
			end
		end
	end
})

function PLUGIN:ShouldShowPlayerOnScoreboard(client)
	if client:GetNetVar("scoreboardhidden", false) == true then
		return false
	end
end
