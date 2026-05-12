local PLUGIN = PLUGIN
PLUGIN.name = "Radiation"
PLUGIN.author = "gumlefar / patched"
PLUGIN.desc = "Radiation System"

ix.util.Include("cl_plugin.lua")

ix.char.RegisterVar("radiation", {
	field = "radiation",
	fieldType = ix.type.number,
	default = 0,
	bNoDisplay = true,
})

local playerMeta = FindMetaTable("Player")

local geigerHeavy = {
	"geiger/heavy/geiger_heavy_1.wav",
	"geiger/heavy/geiger_heavy_2.wav",
	"geiger/heavy/geiger_heavy_3.wav",
	"geiger/heavy/geiger_heavy_4.wav",
	"geiger/heavy/geiger_heavy_5.wav",
}

local geigerLight = {
	"geiger/light/geiger_light_1.wav",
	"geiger/light/geiger_light_2.wav",
	"geiger/light/geiger_light_3.wav",
	"geiger/light/geiger_light_4.wav",
	"geiger/light/geiger_light_5.wav",
}

function playerMeta:getRadiation()
	return self:GetNetVar("radiation", 0) or 0
end

function playerMeta:getRadiationPercent()
	return math.Clamp(self:getRadiation() / 100, 0, 1)
end

function playerMeta:addRadiation(amount)
	local curRadiation = self:getRadiation()
	self:SetNetVar("radiation", math.Clamp(curRadiation + (tonumber(amount) or 0), 0, 100))
end

function playerMeta:setRadiation(amount)
	self:SetNetVar("radiation", math.Clamp(tonumber(amount) or 0, 0, 100))
end

function playerMeta:hasGeiger()
	return self:GetNetVar("ixhasgeiger", false)
end

function playerMeta:getPercentageRadResist()
	local char = self:GetCharacter()
	if not char then
		return 1
	end

	local inv = char:GetInventory()
	if not inv then
		return 1
	end

	local res = 1
	local items = inv:GetItems(true)

	for _, item in pairs(items) do
		if item and item.getRadProt and item:GetData("equip") == true then
			res = res * (1 - item:getRadProt())

			if item.isBodyArmor then
				local attachments = item:GetData("attachments", item.miscSlots or {})
				for _, attachmentList in pairs(attachments) do
					if attachmentList then
						for _, attachment in pairs(attachmentList) do
							if ix.armortables and ix.armortables.attachments and ix.armortables.attachments[attachment] then
								local attachmentData = ix.armortables.attachments[attachment]
								if attachmentData.radProt then
									res = res * (1 - attachmentData.radProt)
								end
							end
						end
					end
				end
			end
		end
	end

	return math.Clamp(res, 0, 1)
end

function playerMeta:getFlatRadResist()
	local char = self:GetCharacter()
	if not char then
		return 0
	end

	local inv = char:GetInventory()
	if not inv then
		return 0
	end

	local res = 0
	local items = inv:GetItems(true)

	for _, item in pairs(items) do
		if item and item.flatRadProt and item:GetData("equip") == true then
			res = res + item.flatRadProt
		end
	end

	if ix.plugin.list["buffs"] and self.HasBuff and self:HasBuff("buff_radprotect") then
		res = res + 0.1
	end

	return res
end

function PLUGIN:EntityTakeDamage(entity, dmgInfo)
	if not (IsValid(entity) and entity:IsPlayer() and entity:Alive() and entity:GetCharacter()) then
		return
	end

	if entity:GetMoveType() == MOVETYPE_NOCLIP then
		return
	end

	if not dmgInfo:IsDamageType(DMG_RADIATION) then
		return
	end

	local radAmount = dmgInfo:GetDamage() / 10
	local percentageRadResist = entity:getPercentageRadResist()
	local flatRadResist = entity:getFlatRadResist()
	local finalRadDamage = (radAmount * percentageRadResist) - flatRadResist

	if entity:hasGeiger() then
		if finalRadDamage > 0.01 then
			entity:EmitSound(table.Random(geigerHeavy))
		elseif radAmount > 0 then
			entity:EmitSound(table.Random(geigerLight))
		end
	end

	entity:addRadiation(math.max(finalRadDamage, 0))
	dmgInfo:SetDamage(0)
end

if CLIENT then
	function PLUGIN:RenderScreenspaceEffects()
		local client = LocalPlayer()
		if not IsValid(client) or not client:GetCharacter() or not client:Alive() then
			return
		end

		local radiation = client:getRadiation()
		if radiation <= 20 then
			return
		end

		local frac = math.Clamp((radiation - 20) / 80, 0, 1)
		local warmFrac = math.Clamp((radiation - 35) / 65, 0, 1)

		DrawColorModify({
			["$pp_colour_addr"] = 0.03 * warmFrac,
			["$pp_colour_addg"] = 0.02 * warmFrac,
			["$pp_colour_addb"] = -0.01 * warmFrac,
			["$pp_colour_brightness"] = -0.02 * frac,
			["$pp_colour_contrast"] = 1 - (0.05 * frac),
			["$pp_colour_colour"] = 1 - (0.18 * frac),
			["$pp_colour_mulr"] = 0.02 * warmFrac,
			["$pp_colour_mulg"] = 0.012 * warmFrac,
			["$pp_colour_mulb"] = 0,
		})

		if radiation > 45 and radiation < 75 then
			DrawMotionBlur(0.1, 0.25, 0.01)
		elseif radiation >= 75 then
			DrawMotionBlur(0.1, 0.55, 0.01)
		end
	end
else
	function PLUGIN:CharacterPreSave(character)
		local client = character and character:GetPlayer()
		local savedRads = 0

		if IsValid(client) then
			savedRads = math.Clamp(client:getRadiation(), 0, 100)
		elseif character.GetRadiation then
			savedRads = math.Clamp(character:GetRadiation() or 0, 0, 100)
		end

		character:SetRadiation(savedRads)
	end

	function PLUGIN:PostPlayerLoadout(client)
		local char = client:GetCharacter()
		if not char then
			return
		end

		client:SetNetVar("radiation", math.Clamp(char:GetRadiation() or 0, 0, 100))
		client:SetNetVar("ixhasgeiger", client:GetData("ixhasgeiger", false) == true)
	end

	function PLUGIN:PlayerDeath(client)
		client.resetRads = true
	end

	function PLUGIN:PlayerSpawn(client)
		if client.resetRads then
			local newValue = math.min(44, client:GetNetVar("radiation", 0))
			client:SetNetVar("radiation", newValue)

			local char = client:GetCharacter()
			if char then
				char:SetRadiation(newValue)
			end

			client.resetRads = false
		end
	end

	local thinkTime = 0
	local damageTime = 0

	function PLUGIN:Think()
		if thinkTime < CurTime() then
			for _, client in ipairs(player.GetAll()) do
				if client:GetNetVar("radiation", 0) >= 100 and client:Alive() then
					client:Kill()
					ix.log.Add(client, "playerDeath", "radiation")
				end
			end

			thinkTime = CurTime() + 0.5
		end

		if damageTime < CurTime() then
			for _, client in ipairs(player.GetAll()) do
				if client:Alive() then
					local radiation = client:GetNetVar("radiation", 0)

					if radiation > 45 and radiation < 75 then
						client:addRadiation(-0.5)
						client:SetHealth(math.max(client:Health() - 1, 0))
						if client:Health() <= 0 then
							client:Kill()
						end
					elseif radiation >= 75 then
						client:addRadiation(-0.5)
						client:SetHealth(math.max(client:Health() - 2, 0))
						if client:Health() <= 0 then
							client:Kill()
						end
					end
				end
			end

			damageTime = CurTime() + 5
		end
	end
end

ix.command.Add("charsetradiation", {
	adminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.number,
	},
	OnRun = function(self, client, target, radiation)
		local foundTarget = ix.util.FindPlayer(target)
		local amount = tonumber(radiation) or 0

		if not IsValid(foundTarget) then
			return "Target player not found."
		end

		foundTarget:setRadiation(amount)

		if client == foundTarget then
			client:Notify("You have set your radiation to " .. amount)
		else
			client:Notify("You have set " .. foundTarget:Name() .. "'s radiation to " .. amount)
			foundTarget:Notify(client:Name() .. " has set your radiation to " .. amount)
		end
	end
})
