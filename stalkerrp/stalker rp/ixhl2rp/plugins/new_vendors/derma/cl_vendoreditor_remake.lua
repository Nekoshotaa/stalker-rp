
local PANEL = {}

local CATEGORY_ALL = "Все"
local CATEGORY_OPTIONS = {CATEGORY_ALL, "Оружие", "Боеприпасы", "Броня", "Медицина", "Еда", "Снаряжение", "Артефакты", "Прочее"}

local function GetItemDisplayName(itemTable)
	if (itemTable.GetName) then
		return itemTable:GetName()
	end

	return L(itemTable.name)
end

local function NormalizeText(value)
	return string.lower(tostring(value or ""))
end

local function GetResolvedCategory(uniqueID, itemTable, itemData)
	if (itemData and itemData.category and itemData.category != "") then
		return itemData.category
	end

	local haystack = table.concat({
		NormalizeText(uniqueID),
		NormalizeText(itemTable and itemTable.category),
		NormalizeText(itemTable and itemTable.name),
		NormalizeText(itemTable and itemTable.description),
		NormalizeText(itemTable and itemTable.base),
		NormalizeText(itemTable and itemTable.weaponCategory)
	}, " ")

	if (haystack:find("ammo", 1, true) or haystack:find("патрон", 1, true) or haystack:find("fmj", 1, true) or haystack:find("12x70", 1, true) or haystack:find("5.45", 1, true) or haystack:find("7.62", 1, true)) then
		return "Боеприпасы"
	elseif (haystack:find("weapon", 1, true) or haystack:find("оруж", 1, true) or haystack:find("rifle", 1, true) or haystack:find("pistol", 1, true)) then
		return "Оружие"
	elseif (haystack:find("armor", 1, true) or haystack:find("armour", 1, true) or haystack:find("брон", 1, true) or haystack:find("outfit", 1, true) or haystack:find("backpack", 1, true) or haystack:find("рюкзак", 1, true)) then
		return "Броня"
	elseif (haystack:find("med", 1, true) or haystack:find("апт", 1, true) or haystack:find("бинт", 1, true) or haystack:find("антирад", 1, true)) then
		return "Медицина"
	elseif (haystack:find("food", 1, true) or haystack:find("drink", 1, true) or haystack:find("еда", 1, true) or haystack:find("water", 1, true) or haystack:find("vodka", 1, true)) then
		return "Еда"
	elseif (haystack:find("artifact", 1, true) or haystack:find("артеф", 1, true) or haystack:find("anom", 1, true)) then
		return "Артефакты"
	elseif (haystack:find("tool", 1, true) or haystack:find("junk", 1, true) or haystack:find("repair", 1, true) or haystack:find("detector", 1, true) or haystack:find("хабар", 1, true)) then
		return "Снаряжение"
	end

	return "Прочее"
end

function PANEL:Init()
	self:SetSize(math.min(ScrW() - 80, 980), math.min(ScrH() - 80, 900))
	self:SetTitle("Редактор торговца")
	self:MakePopup()
	self:SetSizable(false)
	self:SetDraggable(true)
	self:SetScreenLock(true)
	self:SetDeleteOnClose(true)

	self.header = self:Add("DPanel")
	self.header:Dock(TOP)
	self.header:SetTall(252)
	self.header.Paint = function(_, width, height)
		surface.SetDrawColor(14, 14, 14, 240)
		surface.DrawRect(0, 0, width, height)
		surface.SetDrawColor(180, 140, 60, 255)
		surface.DrawOutlinedRect(0, 0, width, height, 1)
	end

	self.filterBar = self:Add("DPanel")
	self.filterBar:Dock(TOP)
	self.filterBar:SetTall(104)
	self.filterBar:DockMargin(0, 6, 0, 6)
	self.filterBar.Paint = function(_, width, height)
		surface.SetDrawColor(10, 10, 10, 225)
		surface.DrawRect(0, 0, width, height)
		surface.SetDrawColor(180, 140, 60, 255)
		surface.DrawOutlinedRect(0, 0, width, height, 1)
	end

	self.search = self.filterBar:Add("DTextEntry")
	self.search:Dock(TOP)
	self.search:DockMargin(8, 8, 8, 4)
	self.search:SetPlaceholderText("Поиск по названию или uniqueID")
	self.search.OnValueChange = function()
		self:RefreshAllItems()
	end

	self.categoryFilter = self.filterBar:Add("DComboBox")
	self.categoryFilter:Dock(TOP)
	self.categoryFilter:DockMargin(8, 0, 8, 4)
	self.categoryFilter:SetValue("Фильтр категории: Все")
	for _, categoryName in ipairs(CATEGORY_OPTIONS) do
		self.categoryFilter:AddChoice(categoryName)
	end
	self.categoryFilter.OnSelect = function(_, _, value)
		self.activeCategory = value
		self:RefreshAllItems()
	end

	self.onlyConfigured = self.filterBar:Add("DCheckBoxLabel")
	self.onlyConfigured:Dock(TOP)
	self.onlyConfigured:DockMargin(8, 0, 8, 0)
	self.onlyConfigured:SetText("Показывать только настроенные товары")
	self.onlyConfigured:SizeToContents()
	self.onlyConfigured.OnChange = function()
		self:RefreshAllItems()
	end

	self.help = self.filterBar:Add("DLabel")
	self.help:Dock(BOTTOM)
	self.help:DockMargin(8, 0, 8, 6)
	self.help:SetFont("ixSmallFont")
	self.help:SetTextColor(color_white)
	self.help:SetText("ПКМ по строке — режим, цена, склад и категория.")
	self.help:SizeToContents()

	self.items = self:Add("DListView")
	self.items:Dock(FILL)
	self.items:SetMultiSelect(false)
	self.items:AddColumn("Предмет")
	self.items:AddColumn("Категория")
	self.items:AddColumn("Режим")
	self.items:AddColumn("Цена")
	self.items:AddColumn("Склад")
	self.items:SetHeaderHeight(24)

	self.lines = {}
	self.activeCategory = CATEGORY_ALL
end

function PANEL:Setup()
	local entity = self.entity
	if (not IsValid(entity)) then
		self:Close()
		return
	end

	self:Center()

	self.name = self.header:Add("DTextEntry")
	self.name:Dock(TOP)
	self.name:DockMargin(6, 6, 6, 0)
	self.name:SetText(entity:GetDisplayName())
	self.name.OnEnter = function(this)
		if (entity:GetDisplayName() != this:GetText()) then
			self:updateVendor("name", this:GetText())
		end
	end

	self.description = self.header:Add("DTextEntry")
	self.description:Dock(TOP)
	self.description:DockMargin(6, 4, 6, 0)
	self.description:SetText(entity:GetDescription())
	self.description.OnEnter = function(this)
		if (entity:GetDescription() != this:GetText()) then
			self:updateVendor("description", this:GetText())
		end
	end

	self.model = self.header:Add("DTextEntry")
	self.model:Dock(TOP)
	self.model:DockMargin(6, 4, 6, 0)
	self.model:SetText(entity:GetModel())
	self.model.OnEnter = function(this)
		if (entity:GetModel():lower() != this:GetText():lower()) then
			self:updateVendor("model", this:GetText():lower())
		end
	end

	local useMoney = tonumber(entity.money) != nil

	self.money = self.header:Add("DTextEntry")
	self.money:Dock(TOP)
	self.money:DockMargin(6, 4, 6, 0)
	self.money:SetText(not useMoney and "∞" or tostring(entity.money))
	self.money:SetDisabled(not useMoney)
	self.money:SetEnabled(useMoney)
	self.money:SetNumeric(true)
	self.money.OnEnter = function(this)
		local value = tonumber(this:GetText()) or entity.money
		if (value == entity.money) then
			return
		end
		self:updateVendor("money", value)
	end

	self.bubble = self.header:Add("DCheckBoxLabel")
	self.bubble:Dock(TOP)
	self.bubble:DockMargin(6, 6, 6, 0)
	self.bubble:SetText(L"vendorNoBubble")
	self.bubble:SetValue(entity:GetNoBubble() and 1 or 0)
	self.bubble:SizeToContents()
	self.bubble.OnChange = function(this, value)
		if (this.noSend) then
			this.noSend = nil
			return
		end
		self:updateVendor("bubble", value)
	end

	self.useMoney = self.header:Add("DCheckBoxLabel")
	self.useMoney:Dock(TOP)
	self.useMoney:DockMargin(6, 2, 6, 0)
	self.useMoney:SetText(L"vendorUseMoney")
	self.useMoney:SetChecked(useMoney)
	self.useMoney:SizeToContents()
	self.useMoney.OnChange = function()
		self:updateVendor("useMoney")
	end

	self.sellScale = self.header:Add("DNumSlider")
	self.sellScale:Dock(TOP)
	self.sellScale:DockMargin(6, 4, 6, 0)
	self.sellScale:SetText(L"vendorSellScale")
	self.sellScale.Label:SetTextColor(color_white)
	self.sellScale.TextArea:SetTextColor(color_white)
	self.sellScale:SetDecimals(1)
	self.sellScale.noSend = true
	self.sellScale:SetValue(entity.scale or 0.5)
	self.sellScale.OnValueChanged = function(this)
		if (this.noSend) then
			this.noSend = nil
			return
		end
		timer.Create("ixVendorScaleEditor" .. tostring(self), 0.4, 1, function()
			if (IsValid(self) and IsValid(self.sellScale) and IsValid(self.entity)) then
				local value = self.sellScale:GetValue()
				if (value != self.entity.scale) then
					self:updateVendor("scale", value)
				end
			end
		end)
	end

	self.faction = self.header:Add("DButton")
	self.faction:Dock(TOP)
	self.faction:DockMargin(6, 4, 6, 0)
	self.faction:SetText("Доступ по фракциям / классам")
	self.faction.DoClick = function()
		if (IsValid(ix.gui.editorFaction)) then
			ix.gui.editorFaction:Remove()
		end
		ix.gui.editorFaction = vgui.Create("ixVendorFactionEditor")
		ix.gui.editorFaction.updateVendor = function(_, key, value)
			self:updateVendor(key, value)
		end
		ix.gui.editorFaction.entity = entity
		ix.gui.editorFaction:Setup()
	end

	self.inventory = self.header:Add("DButton")
	self.inventory:Dock(TOP)
	self.inventory:DockMargin(6, 4, 6, 6)
	self.inventory:SetText("Размер инвентаря")
	self.inventory.DoClick = function()
		if (IsValid(ix.gui.editorInventory)) then
			ix.gui.editorInventory:Remove()
		end
		ix.gui.editorInventory = vgui.Create("ixVendorInventoryEditor")
		ix.gui.editorInventory.updateVendor = function(_, key, value)
			self:updateVendor(key, value)
		end
		ix.gui.editorInventory.entity = entity
		ix.gui.editorInventory:Setup()
	end

	self.items.OnRowRightClick = function(_, _, line)
		self:OpenItemMenu(line.item)
	end

	self:RefreshAllItems()
end

function PANEL:ShouldShowItem(uniqueID, itemTable)
	if (not IsValid(self.entity)) then
		return false
	end

	if (self.onlyConfigured:GetChecked() and not (self.entity.items[uniqueID] and self.entity.items[uniqueID][VENDOR.MODE])) then
		return false
	end

	local itemCategory = GetResolvedCategory(uniqueID, itemTable, self.entity.items[uniqueID])
	if (self.activeCategory != CATEGORY_ALL and itemCategory != self.activeCategory) then
		return false
	end

	local search = string.Trim(string.lower(self.search:GetValue() or ""))
	if (search == "") then
		return true
	end

	local itemName = string.lower(GetItemDisplayName(itemTable) or "")
	local itemID = string.lower(uniqueID or "")
	local categoryName = string.lower(itemCategory or "")
	return itemName:find(search, 1, true) != nil or itemID:find(search, 1, true) != nil or categoryName:find(search, 1, true) != nil
end

function PANEL:RefreshAllItems()
	if (not IsValid(self.entity) or not IsValid(self.items)) then
		return
	end

	self.items:Clear()
	self.lines = {}

	for uniqueID, itemTable in SortedPairs(ix.item.list) do
		if (self:ShouldShowItem(uniqueID, itemTable)) then
			local mode = self.entity.items[uniqueID] and self.entity.items[uniqueID][VENDOR.MODE]
			local current, max = self.entity:GetStock(uniqueID)
			local line = self.items:AddLine(
				GetItemDisplayName(itemTable),
				GetResolvedCategory(uniqueID, itemTable, self.entity.items[uniqueID]),
				mode and L(VENDOR_TEXT[mode]) or L"none",
				self.entity:GetPrice(uniqueID),
				max and (current .. "/" .. max) or "-"
			)
			line.item = uniqueID
			self.lines[uniqueID] = line
		end
	end
end

function PANEL:OpenItemMenu(uniqueID)
	if (not IsValid(self.entity)) then
		return
	end

	local entity = self.entity
	local itemTable = ix.item.list[uniqueID]
	if (not itemTable) then
		return
	end

	local menu = DermaMenu()
	local modeMenu, modePanel = menu:AddSubMenu(L"mode")
	modePanel:SetImage("icon16/key.png")
	modeMenu:AddOption(L"none", function()
		self:updateVendor("mode", {uniqueID, nil})
	end):SetImage("icon16/cog_error.png")
	modeMenu:AddOption(L"vendorBoth", function()
		self:updateVendor("mode", {uniqueID, VENDOR.SELLANDBUY})
	end):SetImage("icon16/cog.png")
	modeMenu:AddOption(L"vendorBuy", function()
		self:updateVendor("mode", {uniqueID, VENDOR.BUYONLY})
	end):SetImage("icon16/cog_delete.png")
	modeMenu:AddOption(L"vendorSell", function()
		self:updateVendor("mode", {uniqueID, VENDOR.SELLONLY})
	end):SetImage("icon16/cog_add.png")

	local categoryMenu, categoryPanel = menu:AddSubMenu("Категория")
	categoryPanel:SetImage("icon16/tag_blue.png")
	categoryMenu:AddOption("Авто (по названию/описанию)", function()
		self:updateVendor("category", {uniqueID, nil})
	end):SetImage("icon16/arrow_refresh.png")
	for _, categoryName in ipairs(CATEGORY_OPTIONS) do
		if (categoryName != CATEGORY_ALL) then
			categoryMenu:AddOption(categoryName, function()
				self:updateVendor("category", {uniqueID, categoryName})
			end):SetImage("icon16/tag_blue_add.png")
		end
	end

	menu:AddOption(L"price", function()
		Derma_StringRequest(
			GetItemDisplayName(itemTable),
			L"vendorPriceReq",
			entity:GetPrice(uniqueID),
			function(text)
				text = tonumber(text)
				if (text == itemTable.price) then
					text = nil
				end
				self:updateVendor("price", {uniqueID, text})
			end
		)
	end):SetImage("icon16/coins.png")

	local stockMenu, stockPanel = menu:AddSubMenu(L"stock")
	stockPanel:SetImage("icon16/table.png")
	stockMenu:AddOption(L"disable", function()
		self:updateVendor("stockDisable", uniqueID)
	end):SetImage("icon16/table_delete.png")
	stockMenu:AddOption(L"edit", function()
		local _, max = entity:GetStock(uniqueID)
		Derma_StringRequest(
			GetItemDisplayName(itemTable),
			L"vendorStockReq",
			max or 1,
			function(text)
				self:updateVendor("stockMax", {uniqueID, text})
			end
		)
	end):SetImage("icon16/table_edit.png")
	stockMenu:AddOption(L"vendorEditCurStock", function()
		Derma_StringRequest(
			GetItemDisplayName(itemTable),
			L"vendorStockCurReq",
			entity:GetStock(uniqueID) or 0,
			function(text)
				self:updateVendor("stock", {uniqueID, text})
			end
		)
	end):SetImage("icon16/table_edit.png")

	menu:Open()
end

function PANEL:OnRemove()
	if (IsValid(ix.gui.editorFaction)) then
		ix.gui.editorFaction:Remove()
	end
	if (IsValid(ix.gui.editorInventory)) then
		ix.gui.editorInventory:Remove()
	end
end

function PANEL:updateVendor(key, value)
	net.Start("ixVendorRemakeEdit")
		net.WriteString(key)
		net.WriteType(value)
	net.SendToServer()
end

vgui.Register("ixVendorRemakeEditor", PANEL, "DFrame")
