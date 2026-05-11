local PLUGIN = PLUGIN

function PLUGIN:RenderScreenspaceEffects()
	local warning = {
		"avoxgaming/gas_mask/gas_mask_light/gas_mask_light_breath1.wav",
		"avoxgaming/gas_mask/gas_mask_light/gas_mask_light_breath2.wav",
		"avoxgaming/gas_mask/gas_mask_light/gas_mask_light_breath3.wav",
		"avoxgaming/gas_mask/gas_mask_light/gas_mask_light_breath4.wav",
		"avoxgaming/gas_mask/gas_mask_light/gas_mask_light_breath5.wav"
	}

	local warningHeavy = {
		"avoxgaming/gas_mask/gas_mask_middle/gas_mask_middle_breath1.wav",
		"avoxgaming/gas_mask/gas_mask_middle/gas_mask_middle_breath2.wav",
		"avoxgaming/gas_mask/gas_mask_middle/gas_mask_middle_breath3.wav",
		"avoxgaming/gas_mask/gas_mask_middle/gas_mask_middle_breath4.wav",
		"avoxgaming/gas_mask/gas_mask_middle/gas_mask_middle_breath5.wav"
	}

	if (LocalPlayer():GetNetVar("gasmask") == true) then
		DrawMaterialOverlay("morganicism/metroredux/gasmask/metromask1", 0.2)

		if not LocalPlayer().enresp then
			LocalPlayer().enresp = true
			local duration = 3.5

			if LocalPlayer():KeyDown(IN_BULLRUSH) then
				surface.PlaySound(warningHeavy[math.random(1, #warningHeavy)])
				duration = 2.5
			else
				surface.PlaySound(warning[math.random(1, #warning)])
			end

			timer.Simple(duration, function()
				if IsValid(LocalPlayer()) then
					LocalPlayer().enresp = false
				end
			end)
		end
	else
		LocalPlayer().enresp = false
	end
end
