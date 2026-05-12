function PLUGIN:HUDPaint()
	local lp = LocalPlayer()
	if (not IsValid(lp)) then return end
	if (not lp.GetCharacter or not lp:GetCharacter()) then return end
	if (not lp:Alive()) then return end
	if (ix.option.Get("disablehud", false)) then return end
	if (ix.gui.characterMenu and ix.gui.characterMenu.IsVisible and ix.gui.characterMenu:IsVisible()) then return end
	if (not lp.getRadiation) then return end

	local radiation = math.Clamp(lp:getRadiation() or 0, 0, 100)
	local value = 100 - radiation
	local x = ScrW() * 0.86
	local y = ScrH() * 0.79
	local size = 48

	-- fallback HUD icon without ix.util.DrawStatusIcon
	surface.SetDrawColor(255, 255, 255, 235)
	surface.SetMaterial(Material("stalker/ui/art.png", "smooth noclamp"))
	surface.DrawTexturedRect(x, y, size, size)

	draw.SimpleText(math.Round(value) .. "%", "DermaDefaultBold", x + size / 2, y + size + 2, Color(255, 230, 140, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end
