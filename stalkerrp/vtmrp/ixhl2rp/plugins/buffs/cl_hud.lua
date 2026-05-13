local PLUGIN = PLUGIN

function PLUGIN:HUDPaint()
	local client = LocalPlayer()
	if not IsValid(client) then return end

	if client:HasBuff("buff_slowheal") or client:HasBuff("buff_rapidheal") then
		ix.util.DrawBuffIcon("stalker/ui/heart.png", ScrW()*0.82, ScrH()*0.75, ScrW()*0.016, ScrH()*0.032)
	end

	if client:HasBuff("buff_staminarestore") or client:HasBuff("buff_epinephrine") then
		ix.util.DrawBuffIcon("stalker/ui/stamina.png", ScrW()*0.84, ScrH()*0.75, ScrW()*0.016, ScrH()*0.032)
	end

	if client:HasBuff("buff_radprotect") then
		ix.util.DrawBuffIcon("stalker/ui/art.png", ScrW()*0.86, ScrH()*0.715, ScrW()*0.016, ScrH()*0.032, Color(0, 255, 190))
	end

	if client:HasBuff("buff_radiationremoval") then
		ix.util.DrawBuffIcon("stalker/ui/art.png", ScrW()*0.86, ScrH()*0.75, ScrW()*0.016, ScrH()*0.032)
	end

	if client:HasBuff("debuff_radiation") then
		ix.util.DrawBuffIcon("stalker/ui/art.png", ScrW()*0.86, ScrH()*0.75, ScrW()*0.016, ScrH()*0.032, Color(255, 0, 0, 255))
	end

	if client:HasBuff("buff_psysuppress") then
		ix.util.DrawBuffIcon("stalker/ui/psy.png", ScrW()*0.94, ScrH()*0.68, ScrW()*0.016, ScrH()*0.032, Color(0, 255, 0))
	end

	if client:HasBuff("buff_psyblock") then
		ix.util.DrawBuffIcon("stalker/ui/psy.png", ScrW()*0.94, ScrH()*0.715, ScrW()*0.016, ScrH()*0.032, Color(0, 255, 190))
	end

	if client:HasBuff("buff_psyheal") then
		ix.util.DrawBuffIcon("stalker/ui/psy.png", ScrW()*0.94, ScrH()*0.75, ScrW()*0.016, ScrH()*0.032)
	end

	if client:HasBuff("debuff_psy") then
		ix.util.DrawBuffIcon("stalker/ui/psy.png", ScrW()*0.94, ScrH()*0.75, ScrW()*0.016, ScrH()*0.032, Color(255, 0, 0, 255))
	end
end
