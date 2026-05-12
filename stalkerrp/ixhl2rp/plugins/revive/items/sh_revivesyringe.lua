ITEM.name = "Набор для поднятия на ноги"
ITEM.model = "models/illusion/eftcontainers/grizzly.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.description = "Необходимый травматологический набор, для поднятия товарища на ноги."
ITEM.price = 800


ITEM.functions.use = {
	name = "Поднять",
	icon = "icon16/stalker/unlock.png",
	OnRun = function(item)
		local client = item.player
		if not IsValid(client) then return false end

		local plugin = ix.plugin.list["revive"]
		if not plugin then
			client:Notify("Плагин revive не найден.")
			return false
		end

		local trace = client:GetEyeTraceNoCursor()
		local entity = trace.Entity

		if not IsValid(entity) or entity:GetClass() ~= "prop_ragdoll" or not entity.isDeadBody then
			client:Notify("Смотрите на тело без сознания.")
			return false
		end

		local ok, err = plugin:UseReviveItem(client, entity, 25, function()
			if item and item.Remove then
				item:Remove()
			end
		end)

		if not ok then
			client:Notify(err or "Не удалось использовать шприц.")
			return false
		end

		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		local char = IsValid(client) and client:GetCharacter()

		return not IsValid(item.entity)
			and item:GetData("stashcoordinates", nil) == nil
			and char
			and item.invID == char:GetInventory():GetID()
	end
}