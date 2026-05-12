ITEM.name = "Дробовики: ближний гром"
ITEM.description = "Краткое руководство охотника, пережившего не одну встречу с кабаном и псевдособакой. Внутри — заметки о дистанции, отдаче и том, почему второй выстрел должен быть готов всегда. При прочтении повышает навык «Дробовики» на +1."
ITEM.model = "models/fo3/misc/bookguns.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 500
ITEM.category = "Книги навыков"

ITEM.attributeCandidates = {"shotgun", "sht", "Дробовики"}
ITEM.attributeAmount = 1
ITEM.attributeMax = 100

local function FindBookAttribute(item)
	if not ix or not ix.attributes or not ix.attributes.list then
		return nil
	end

	local candidates = item.attributeCandidates or {}

	for _, candidate in ipairs(candidates) do
		local check = string.lower(tostring(candidate))

		for id, data in pairs(ix.attributes.list) do
			local idText = string.lower(tostring(id))
			local shortText = data.shortname and string.lower(tostring(data.shortname)) or ""
			local nameText = data.name and string.lower(tostring(data.name)) or ""

			if check == idText or check == shortText or check == nameText then
				return id, data
			end
		end
	end

	return nil
end

ITEM.functions.Read = {
	name = "Прочитать",
	icon = "icon16/book_open.png",
	OnRun = function(item)
		local client = item.player

		if not IsValid(client) then
			return false
		end

		local character = client:GetCharacter()

		if not character then
			client:Notify("Персонаж не найден.")
			return false
		end

		local attributeID, attributeData = FindBookAttribute(item)

		if not attributeID then
			client:Notify("Навык для этой книги не найден. Проверьте ID атрибута в файле предмета.")
			return false
		end

		local maxValue = item.attributeMax or 100
		local amount = item.attributeAmount or 1
		local current = character:GetAttribute(attributeID, 0)

		if current >= maxValue then
			client:Notify("Навык уже достиг максимума: " .. (attributeData.name or attributeID) .. ".")
			return false
		end

		local newValue = math.min(current + amount, maxValue)
		character:SetAttrib(attributeID, newValue)
		client:Notify("Вы прочитали книгу. Навык \"" .. (attributeData.name or attributeID) .. "\" повышен на +" .. tostring(newValue - current) .. ".")

		return true
	end
}
