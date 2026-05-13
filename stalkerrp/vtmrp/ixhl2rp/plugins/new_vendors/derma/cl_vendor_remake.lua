
local PANEL = {}

AccessorFunc(PANEL, "money", "Money", FORCE_NUMBER)

function PANEL:Init()
	self:DockPadding(1, 1, 1, 1)
	self:SetTall(22)
	self:Dock(BOTTOM)

	self.moneyLabel = self:Add("DLabel")
	self.moneyLabel:Dock(TOP)
	self.moneyLabel:SetFont("ixGenericFont")
	self.moneyLabel:SetText("")
	self.moneyLabel:SetTextInset(6, 0)
	self.moneyLabel:SizeToContents()
	self.moneyLabel.Paint = function(_, width, height)
		surface.SetDrawColor(14, 18, 16, 235)
		surface.DrawRect(0, 0, width, height)
		surface.SetDrawColor(116, 128, 92, 255)
		surface.DrawOutlinedRect(0, 0, width, height, 1)
	end

	self.bNoBackgroundBlur = true
end

function PANEL:SetMoney(money)
	money = math.max(math.Round(tonumber(money) or 0), 0)
	self.moneyLabel:SetText(ix.currency.Get(money))
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(0, 0, 0, 0)
	surface.DrawRect(0, 0, width, height)
end

vgui.Register("ixVendorRemakeMoney", PANEL, "EditablePanel")

local function GetDisplayName(itemTable)
	if (not itemTable) then
		return "Неизвестный предмет"
	end

	if (itemTable.GetName) then
		return itemTable:GetName()
	end

	return L(itemTable.name)
end


local function GetItemIconModel(itemTable)
	if (not itemTable) then
		return nil
	end

	if (itemTable.iconCam) then
		return itemTable.model
	end

	return itemTable.model
end

local function GetOptionalMaterial(paths)
	for _, path in ipairs(paths) do
		local mat = Material(path, "smooth noclamp")
		if (mat and not mat:IsError()) then
			return mat
		end
	end
end

local function PlayOptionalSound(paths)
	for _, path in ipairs(paths) do
		if (path and path != "") then
			surface.PlaySound(path)
			return
		end
	end
end

local FRAME_MATERIAL = nil

local PANEL_BG = nil


if (CLIENT) then
	surface.CreateFont("ixVendorStamperTitle", {
		font = "DS Stamper",
		size = ScreenScale(11),
		weight = 700,
		extended = true,
		antialias = true
	})

	surface.CreateFont("ixVendorStamperBody", {
		font = "DS Stamper",
		size = ScreenScale(8),
		weight = 600,
		extended = true,
		antialias = true
	})

	surface.CreateFont("ixVendorStamperSmall", {
		font = "DS Stamper",
		size = ScreenScale(7),
		weight = 500,
		extended = true,
		antialias = true
	})
end

local UI_SOUNDS = {
	category = {
		"stalkersound/pda/pda_tip.wav",
		"stalkernekootherthing/sound/stalkersound/pda/pda_tip.wav"
	},
	close = {
		"stalkersound/pda/pda_objective.wav",
		"stalkernekootherthing/sound/stalkersound/pda/pda_objective.wav"
	},
	trade = {
		"stalkersound/items/inv_items_wpn_1.wav",
		"stalkersound/items/inv_items_wpn_1.ogg",
		"stalkernekootherthing/sound/stalkersound/items/inv_items_wpn_1.wav",
		"stalkernekootherthing/sound/stalkersound/items/inv_items_wpn_1.ogg"
	},
	focus = {
		"stalkersound/inv_ruck.wav",
		"stalkersound/inv_ruck.mp3",
		"stalkernekootherthing/sound/stalkersound/inv_ruck.wav",
		"stalkernekootherthing/sound/stalkersound/inv_ruck.mp3"
	}
}

local CATEGORY_ALL = "Все"
local CATEGORY_ORDER = {CATEGORY_ALL, "Оружие", "Боеприпасы", "Броня", "Медицина", "Еда", "Прочее"}

local CATEGORY_KEYWORDS = {
	["Боеприпасы"] = {"ammo", "патрон", "картеч", "buck", "slug", "fmj", "hp", "ap", "9x", "5.45", "5.56", "7.62", "7.92", "12x70", "20x70", "pulka", "bullet"},
	["Оружие"] = {"weapon", "оруж", "rifle", "pistol", "shotgun", "smg", "sniper", "gun", "карабин", "автомат", "пистолет", "руж", "винтов"},
	["Броня"] = {"armor", "armour", "брон", "outfit", "одеж", "helmet", "шлем", "vest", "костюм", "suit", "backpack", "рюкзак", "gasmask", "filter"},
	["Медицина"] = {"med", "апт", "бинт", "drug", "medical", "medicine", "stim", "антирад", "syringe", "first aid", "medkit", "pill"},
	["Еда"] = {"food", "drink", "еда", "пить", "consumable", "water", "vodka", "консерв", "bread", "choco", "колбас", "бобы", "бутер", "энергетик"},
	["Прочее"] = {"tool", "junk", "craft", "material", "loot", "хабар", "инстру", "матер", "repair", "detector", "dosimeter", "parts", "wire", "scrap", "rope", "glue", "radio", "artifact", "артеф", "anom", "аномал", "battery", "капля", "медуза", "stone blood", "night star", "flash"}
}

local function NormalizeText(value)
	return string.lower(tostring(value or ""))
end

local function GetResolvedCategory(uniqueID, itemTable, itemData)
	if (itemData and itemData.category and itemData.category != "") then
		return itemData.category
	end

	if (itemTable and itemTable.vendorCategory and itemTable.vendorCategory != "") then
		return itemTable.vendorCategory
	end

	local categoryText = NormalizeText(itemTable and itemTable.category)
	if (categoryText != "") then
		if (categoryText:find("ammo", 1, true) or categoryText:find("патрон", 1, true)) then
			return "Боеприпасы"
		elseif (categoryText:find("weapon", 1, true) or categoryText:find("оруж", 1, true)) then
			return "Оружие"
		elseif (categoryText:find("armor", 1, true) or categoryText:find("armour", 1, true) or categoryText:find("брон", 1, true) or categoryText:find("outfit", 1, true)) then
			return "Броня"
		elseif (categoryText:find("med", 1, true) or categoryText:find("мед", 1, true)) then
			return "Медицина"
		elseif (categoryText:find("food", 1, true) or categoryText:find("drink", 1, true) or categoryText:find("еда", 1, true)) then
			return "Еда"
		elseif (categoryText:find("artifact", 1, true) or categoryText:find("артеф", 1, true)) then
			return "Прочее"
		elseif (categoryText:find("tool", 1, true) or categoryText:find("junk", 1, true) or categoryText:find("misc", 1, true) or categoryText:find("suppl", 1, true)) then
			return "Прочее"
		end
	end

	local haystack = table.concat({
		NormalizeText(uniqueID),
		NormalizeText(itemTable and itemTable.category),
		NormalizeText(itemTable and itemTable.name),
		NormalizeText(itemTable and itemTable.description),
		NormalizeText(itemTable and itemTable.base),
		NormalizeText(itemTable and itemTable.weaponCategory),
		NormalizeText(itemTable and itemTable.model)
	}, " ")

	for categoryName, keywords in pairs(CATEGORY_KEYWORDS) do
		for _, keyword in ipairs(keywords) do
			if (haystack:find(NormalizeText(keyword), 1, true)) then
				return categoryName
			end
		end
	end

	return "Прочее"
end

local function DrawTechPanel(x, y, width, height, title)
	if (FRAME_MATERIAL and not FRAME_MATERIAL:IsError()) then
		surface.SetMaterial(FRAME_MATERIAL)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(x, y, width, height)
	else
		surface.SetDrawColor(16, 20, 18, 240)
		surface.DrawRect(x, y, width, height)
		surface.SetDrawColor(116, 128, 92, 255)
		surface.DrawOutlinedRect(x, y, width, height, 1)
	end

	-- only light inner tint so the frame stays visible
	surface.SetDrawColor(6, 10, 8, 120)
	surface.DrawRect(x + 8, y + 34, width - 16, height - 42)

	draw.SimpleText(title or "", "ixVendorStamperTitle", x + 16, y + 15, Color(205, 210, 190), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

DEFINE_BASECLASS("DFrame")
PANEL = {}
AccessorFunc(PANEL, "fadeTime", "FadeTime", FORCE_NUMBER)

function PANEL:Init()
	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self:SetSizable(false)
	self:SetScreenLock(true)
	self:SetDeleteOnClose(true)
	self:SetFadeTime(0.15)
	self:SetAlpha(0)
	self:AlphaTo(255, self:GetFadeTime())

	self.activeCategory = CATEGORY_ALL
	self.catalogRows = {}
	self.selectedUniqueID = nil
	self.nextInfoUpdate = 0

	self.catalogPanel = self:Add("DPanel")
	self.catalogPanel.Paint = function(_, width, height)
		DrawTechPanel(0, 0, width, height, self.entity and self.entity:GetDisplayName() or "ТОВАРЫ")
	end

	self.headerPanel = self.catalogPanel:Add("DPanel")
	self.headerPanel:Dock(TOP)
	self.headerPanel:SetTall(40)
	self.headerPanel:DockMargin(8, 34, 8, 0)
	self.headerPanel.Paint = nil

	self.closeButton = self.headerPanel:Add("DButton")
	self.closeButton:Dock(RIGHT)
	self.closeButton:SetWide(34)
	self.closeButton:SetText("X")
	self.closeButton:SetFont("ixVendorStamperTitle")
	self.closeButton.DoClick = function()
		PlayOptionalSound(UI_SOUNDS.close)
		self:CloseVendorWindow()
	end
	self.closeButton.Paint = function(_, width, height)
		surface.SetDrawColor(30, 20, 20, 240)
		surface.DrawRect(0, 0, width, height)
		surface.SetDrawColor(116, 128, 92, 255)
		surface.DrawOutlinedRect(0, 0, width, height, 1)
	end

	self.categoryPanel = self.catalogPanel:Add("DScrollPanel")
	self.categoryPanel:Dock(TOP)
	self.categoryPanel:SetTall(34)
	self.categoryPanel:DockMargin(8, 6, 8, 0)

	self.categoryButtons = {}
	for _, categoryName in ipairs(CATEGORY_ORDER) do
		local button = self.categoryPanel:Add("DButton")
		button:Dock(LEFT)
		button:DockMargin(0, 0, 6, 0)
		button:SetWide(categoryName == CATEGORY_ALL and 58 or 96)
		button:SetText(categoryName)
		button:SetFont("ixVendorStamperSmall")
		button.DoClick = function()
			self.activeCategory = categoryName
			self:RefreshCategoryButtons()
			self:RefreshCatalog()
			PlayOptionalSound(UI_SOUNDS.category)
		end
		button.Paint = function(_, width, height)
			local active = self.activeCategory == categoryName
			surface.SetDrawColor(active and Color(120, 95, 40, 240) or Color(18, 22, 20, 230))
			surface.DrawRect(0, 0, width, height)
			surface.SetDrawColor(116, 128, 92, 255)
			surface.DrawOutlinedRect(0, 0, width, height, 1)
		end
		self.categoryButtons[#self.categoryButtons + 1] = button
	end

	self.catalogScroll = self.catalogPanel:Add("DScrollPanel")
	self.catalogScroll:Dock(FILL)
	self.catalogScroll:DockMargin(8, 8, 8, 0)

	self.infoPanel = self.catalogPanel:Add("DPanel")
	self.infoPanel:Dock(BOTTOM)
	self.infoPanel:SetTall(170)
	self.infoPanel:DockMargin(8, 8, 8, 8)
	self.infoPanel.Paint = function(_, width, height)
		surface.SetDrawColor(5, 5, 5, 215)
		surface.DrawRect(0, 0, width, height)
		surface.SetDrawColor(116, 128, 92, 255)
		surface.DrawOutlinedRect(0, 0, width, height, 1)
		surface.SetDrawColor(116, 128, 92, 75)
		surface.DrawRect(0, 0, width, 28)
		draw.SimpleText("ИНФОРМАЦИЯ", "ixVendorStamperTitle", 12, 14, Color(205, 210, 190), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	self.selectedTitle = self.infoPanel:Add("DLabel")
	self.selectedTitle:Dock(TOP)
	self.selectedTitle:DockMargin(12, 34, 12, 4)
	self.selectedTitle:SetFont("ixVendorStamperTitle")
	self.selectedTitle:SetTextColor(Color(215, 220, 205))
	self.selectedTitle:SetWrap(false)
	self.selectedTitle:SetAutoStretchVertical(false)
	self.selectedTitle:SetText("Выбери товар слева")

	self.selectedMeta = self.infoPanel:Add("DLabel")
	self.selectedMeta:Dock(TOP)
	self.selectedMeta:DockMargin(12, 0, 12, 4)
	self.selectedMeta:SetFont("ixVendorStamperSmall")
	self.selectedMeta:SetTextColor(Color(155, 170, 150))
	self.selectedMeta:SetWrap(true)
	self.selectedMeta:SetAutoStretchVertical(true)
	self.selectedMeta:SetContentAlignment(7)
	self.selectedMeta:SetText("")

	self.infoText = self.infoPanel:Add("DLabel")
	self.infoText:Dock(FILL)
	self.infoText:DockMargin(12, 2, 12, 10)
	self.infoText:SetFont("ixVendorStamperBody")
	self.infoText:SetTextColor(Color(215, 220, 205))
	self.infoText:SetWrap(true)
	self.infoText:SetAutoStretchVertical(true)
	self.infoText:SetContentAlignment(7)
	self.infoText:SetText("")

	ix.gui.inv1 = self:Add("ixInventory")
	ix.gui.inv1.bNoBackgroundBlur = true
	ix.gui.inv1:ShowCloseButton(false)
	ix.gui.inv1:SetTitle("РЮКЗАК")

	self.localMoney = ix.gui.inv1:Add("ixVendorRemakeMoney")
	self.localMoney:SetVisible(false)

	self:RefreshCategoryButtons()
	ix.gui.inv1:MakePopup()
end

function PANEL:CloseVendorWindow()
	net.Start("ixVendorRemakeClose")
	net.SendToServer()
	self:Remove()
end

function PANEL:RefreshCategoryButtons()
	for _, button in ipairs(self.categoryButtons or {}) do
		button:SetTextColor(self.activeCategory == button:GetText() and Color(255, 235, 180) or Color(220, 220, 220))
	end
end

function PANEL:ShouldShowCatalogItem(uniqueID, itemTable, data)
	if (not data) then
		return false
	end

	local mode = data[VENDOR.MODE]
	if (mode != VENDOR.SELLANDBUY and mode != VENDOR.SELLONLY) then
		return false
	end

	if (self.activeCategory != CATEGORY_ALL and GetResolvedCategory(uniqueID, itemTable, data) != self.activeCategory) then
		return false
	end

	return true
end

function PANEL:SetSelectedItem(uniqueID)
	if (self.selectedUniqueID != uniqueID) then
		PlayOptionalSound(UI_SOUNDS.focus)
	end
	self.selectedUniqueID = uniqueID
	self:UpdateInfoText()
	for _, row in ipairs(self.catalogRows or {}) do
		if (IsValid(row)) then
			row:InvalidateLayout(true)
		end
	end
end

function PANEL:CreateCatalogRow(uniqueID, itemTable, data)
	local row = self.catalogScroll:Add("DButton")
	row:Dock(TOP)
	row:SetTall(72)
	row:DockMargin(0, 0, 0, 6)
	row:SetText("")
	row.uniqueID = uniqueID

	row.icon = row:Add("SpawnIcon")
	row.icon:Dock(LEFT)
	row.icon:SetWide(64)
	row.icon:DockMargin(6, 6, 8, 6)
	row.icon:SetMouseInputEnabled(false)
	row.icon:SetKeyboardInputEnabled(false)
	local iconModel = GetItemIconModel(itemTable)
	if (iconModel and iconModel != "") then
		row.icon:SetModel(iconModel)
	end

	row.OnCursorEntered = function()
		self.selectedUniqueID = uniqueID
		self:UpdateInfoText()
		row.hovered = true
		PlayOptionalSound(UI_SOUNDS.category)
		row:InvalidateLayout(true)
	end
	row.OnCursorExited = function()
		row.hovered = false
		row:InvalidateLayout(true)
	end
	row.Paint = function(_, width, height)
		local selected = self.selectedUniqueID == uniqueID
		local stockCurrent, stockMax = self.entity:GetStock(uniqueID)
		local bgColor = selected and Color(34, 42, 34, 245) or (row.hovered and Color(24, 28, 24, 235) or Color(14, 18, 16, 235))
		surface.SetDrawColor(bgColor)
		surface.DrawRect(0, 0, width, height)
		surface.SetDrawColor(selected and Color(220, 185, 90, 255) or Color(116, 128, 92, 255))
		surface.DrawOutlinedRect(0, 0, width, height, selected and 2 or 1)

		local textX = 84
		draw.SimpleText(GetDisplayName(itemTable), "ixVendorStamperTitle", textX, 22, Color(215, 220, 205), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		local priceText = "Цена: " .. ix.currency.Get(self.entity:GetPrice(uniqueID, false))
		draw.SimpleText(priceText, "ixVendorStamperBody", width - 14, 22, Color(215, 220, 205), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

		local stockText = stockMax and ("Склад: " .. tostring(stockCurrent) .. "/" .. tostring(stockMax)) or "Склад: ∞"
		draw.SimpleText(stockText, "ixVendorStamperSmall", width - 14, 48, Color(170, 170, 170), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
	row.DoClick = function()
		self:SetSelectedItem(uniqueID)
		self:BuyItem(uniqueID)
	end
	row.DoRightClick = function()
		self:SetSelectedItem(uniqueID)
		local menu = DermaMenu()
		menu:AddOption("Купить", function()
			PlayOptionalSound(UI_SOUNDS.trade)
			self:BuyItem(uniqueID)
		end):SetImage("icon16/cart_put.png")
		menu:Open()
	end

	self.catalogRows[#self.catalogRows + 1] = row
end

function PANEL:RefreshCatalog()
	if (not IsValid(self.entity) or not IsValid(self.catalogScroll)) then
		return
	end

	self.catalogScroll:Clear()
	self.catalogRows = {}

	local sorted = {}
	for uniqueID, data in pairs(self.entity.items or {}) do
		local itemTable = ix.item.list[uniqueID]
		if (itemTable and self:ShouldShowCatalogItem(uniqueID, itemTable, data)) then
			sorted[#sorted + 1] = {uniqueID = uniqueID, itemTable = itemTable, data = data}
		end
	end

	table.sort(sorted, function(a, b)
		return GetDisplayName(a.itemTable) < GetDisplayName(b.itemTable)
	end)

	for _, entry in ipairs(sorted) do
		self:CreateCatalogRow(entry.uniqueID, entry.itemTable, entry.data)
	end

	if (#sorted > 0) then
		local stillExists = false
		for _, entry in ipairs(sorted) do
			if (entry.uniqueID == self.selectedUniqueID) then
				stillExists = true
				break
			end
		end

		if (not stillExists) then
			self.selectedUniqueID = sorted[1].uniqueID
		end
	else
		self.selectedUniqueID = nil
		local empty = self.catalogScroll:Add("DLabel")
		empty:Dock(TOP)
		empty:SetTall(48)
		empty:SetFont("ixMediumLightFont")
		empty:SetTextColor(Color(155, 170, 150))
		empty:SetContentAlignment(5)
		empty:SetText("В этой категории сейчас нет товаров.")
	end

	self:UpdateInfoText()
end

function PANEL:BuyItem(uniqueID)
	if (not IsValid(self.entity)) then
		return
	end

	local vendorInventory = self.entity:GetInventory()
	if (not vendorInventory) then
		LocalPlayer():Notify("Инвентарь торговца не найден.")
		return
	end

	local items = vendorInventory:GetItemsByUniqueID(uniqueID, true)
	local itemObject = items and items[1]
	if (not itemObject or not itemObject.id) then
		LocalPlayer():Notify("Этот товар сейчас недоступен для покупки.")
		return
	end

	PlayOptionalSound(UI_SOUNDS.trade)
	net.Start("ixVendorRemakeTrade")
		net.WriteUInt(itemObject.id, 32)
		net.WriteBool(false)
	net.SendToServer()
end

function PANEL:SetLocalInventory(inventory)
	if (IsValid(ix.gui.inv1) and not IsValid(ix.gui.menu)) then
		ix.gui.inv1:SetInventory(inventory)
		self:LayoutPanels()
	end
end

function PANEL:SetLocalMoney(money)
	if (not self.localMoney:IsVisible()) then
		self.localMoney:SetVisible(true)
		ix.gui.inv1:SetTall(ix.gui.inv1:GetTall() + self.localMoney:GetTall() + 2)
	end

	self.localMoney:SetMoney(money)
	self:UpdateInfoText()
	self:LayoutPanels()
end

function PANEL:SetVendorTitle(title)
	self.vendorTitle = title or "ТОВАРЫ"
end

function PANEL:SetVendorInventory(inventory)
	self.vendorInventory = inventory
	if (inventory) then
		ix.gui["inv" .. inventory:GetID()] = nil
	end
	self:RefreshCatalog()
	self:LayoutPanels()
end

function PANEL:SetVendorMoney(money)
	self.vendorMoneyValue = money
	self:UpdateInfoText()
end

function PANEL:UpdateInfoText()
	if (not IsValid(self.infoText) or not IsValid(self.selectedTitle) or not IsValid(self.selectedMeta)) then
		return
	end

	local entity = self.entity
	local character = LocalPlayer():GetCharacter()
	if (not IsValid(entity) or not character) then
		self.selectedTitle:SetText("Нет данных")
		self.selectedMeta:SetText("")
		self.infoText:SetText("Нет данных о торговце.")
		return
	end

	local description = entity:GetDescription()
	if (description == nil or description == "") then
		description = "Торг, обмен и скупка хабара."
	end

	local generalLines = {
		description,
		"",
		"Ваши деньги: " .. ix.currency.Get(character:GetMoney() or 0),
		"Деньги торговца: " .. ((entity.money != nil) and ix.currency.Get(entity.money) or "∞"),
		"",
		"ЛКМ по товару — купить.",
		"ПКМ по предмету в рюкзаке — продать.",
		"Кнопка X сверху справа — закрыть окно."
	}

	if (self.selectedUniqueID) then
		local uniqueID = self.selectedUniqueID
		local itemTable = ix.item.list[uniqueID]
		local itemData = entity.items[uniqueID]
		if (itemTable and itemData) then
			local categoryName = GetResolvedCategory(uniqueID, itemTable, itemData)
			local stockCurrent, stockMax = entity:GetStock(uniqueID)
			self.selectedTitle:SetText(GetDisplayName(itemTable))
			self.selectedMeta:SetText(string.format("Категория: %s   |   Цена покупки: %s   |   Цена продажи: %s   |   Склад: %s", categoryName, ix.currency.Get(entity:GetPrice(uniqueID, false)), ix.currency.Get(entity:GetPrice(uniqueID, true)), stockMax and (tostring(stockCurrent) .. "/" .. tostring(stockMax)) or "∞"))

			local itemDesc = itemTable.description or "Без описания."
			local extra = {}
			if (itemTable.width and itemTable.height) then
				extra[#extra + 1] = string.format("Размер: %sx%s", tostring(itemTable.width), tostring(itemTable.height))
			end
			if (itemTable.weight) then
				extra[#extra + 1] = "Вес: " .. tostring(itemTable.weight)
			end
			extra[#extra + 1] = "uniqueID: " .. tostring(uniqueID)
			self.infoText:SetText(itemDesc .. "\n\n" .. table.concat(extra, "\n") .. "\n\n" .. table.concat(generalLines, "\n"))
			return
		end
	end

	self.selectedTitle:SetText("Выбери товар слева")
	self.selectedMeta:SetText("Выбери товар, чтобы увидеть цену и описание.")
	self.infoText:SetText(table.concat(generalLines, "\n"))
end

function PANEL:LayoutPanels()
	if (not IsValid(self.catalogPanel) or not IsValid(ix.gui.inv1)) then
		return
	end

	local rightWidth = ix.gui.inv1:GetWide()
	local rightHeight = ix.gui.inv1:GetTall()
	local catalogWidth = math.Clamp(math.floor(self:GetWide() * 0.42), 540, 780)
	local catalogHeight = math.Clamp(self:GetTall() - 110, 560, self:GetTall() - 40)
	local gap = 26
	local totalWidth = catalogWidth + gap + rightWidth
	local startX = math.max(18, math.floor((self:GetWide() - totalWidth) * 0.5))
	local centerY = math.floor(self:GetTall() * 0.5)

	self.catalogPanel:SetSize(catalogWidth, catalogHeight)
	self.catalogPanel:SetPos(startX, centerY - math.floor(catalogHeight * 0.5))
	ix.gui.inv1:SetPos(startX + catalogWidth + gap, centerY - math.floor(rightHeight * 0.5))
end

function PANEL:Paint(width, height)
	ix.util.DrawBlurAt(0, 0, width, height)
	surface.SetDrawColor(10, 14, 12, 210)
	surface.DrawRect(0, 0, width, height)

	for y = 0, height, 6 do
		surface.SetDrawColor(180, 140, 60, 18)
		surface.DrawLine(0, y, width, y)
	end

	for _, child in ipairs(self:GetChildren()) do
		child:PaintManual()
	end
end

function PANEL:OnChildAdded(panel)
	panel:SetPaintedManually(true)
end

function PANEL:Think()
	local entity = self.entity
	if (not IsValid(entity)) then
		self:Remove()
		return
	end

	if ((self.nextInfoUpdate or 0) < CurTime()) then
		self:UpdateInfoText()
		self.nextInfoUpdate = CurTime() + 0.25
	end
end

function PANEL:Remove()
	self:SetAlpha(255)
	self:AlphaTo(0, self:GetFadeTime(), 0, function()
		if (IsValid(self)) then
			BaseClass.Remove(self)
		end
	end)
end

function PANEL:OnRemove()
	if (IsValid(ix.gui.inv1)) then
		ix.gui.inv1:Remove()
	end
end

vgui.Register("ixVendorRemakeView", PANEL, "DFrame")
