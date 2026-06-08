-- Keybinds частина
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function init(G, F)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- INSERT - Закрити/Відкрити меню
	if input.KeyCode == Enum.KeyCode.Insert then
		if G.frame.Visible or G.teleportFrame.Visible or G.aimSettingsFrame.Visible or G.hitboxSettingsFrame.Visible then
			G.frame.Visible = false
			G.teleportFrame.Visible = false
			G.aimSettingsFrame.Visible = false
			G.hitboxSettingsFrame.Visible = false
			G.minimizedCircle.Visible = true
		else
			G.frame.Visible = true
			G.minimizedCircle.Visible = false
		end
	end
	
	-- END - Hitbox ON/OFF
	if input.KeyCode == Enum.KeyCode.End then
		local hitbox = F.getHitbox()
		F.setHitbox(not hitbox)
		G.hitboxButton.Text = F.getHitbox() and "Hitbox: ON" or "Hitbox: OFF"
		F.updateHitboxes()
		F.showNotif("Hitbox", F.getHitbox() and "✅ Enabled" or "❌ Disabled", 2)
	end
	
	-- DELETE - AIM ON/OFF
	if input.KeyCode == Enum.KeyCode.Delete then
		F.setHolding(not F.getHolding())
		G.aimButton.Text = F.getHolding() and "AIM: ON" or "AIM: OFF"
		F.showNotif("AIM", F.getHolding() and "✅ Enabled" or "❌ Disabled", 2)
	end
	
	-- F5 - ESP ON/OFF
	if input.KeyCode == Enum.KeyCode.F5 then
		F.setEsp(not F.getEsp())
		G.espButton.Text = F.getEsp() and "ESP: ON" or "ESP: OFF"
		if not F.getEsp() then F.clearESP() end
		F.showNotif("ESP", F.getEsp() and "✅ Enabled" or "❌ Disabled", 2)
	end
	
	-- F6 - Third Person ON/OFF
	if input.KeyCode == Enum.KeyCode.F6 then
		F.setThirdPerson(not F.getThirdPerson())
		G.thirdPersonButton.Text = F.getThirdPerson() and "Third Person: ON" or "Third Person: OFF"
		if F.getThirdPerson() then F.startThirdPerson() else F.stopThirdPerson() end
		F.showNotif("Third Person", F.getThirdPerson() and "✅ Enabled" or "❌ Disabled", 2)
	end
	
	-- F7 - Chaos ON/OFF
	if input.KeyCode == Enum.KeyCode.F7 then
		F.setChaos(not F.getChaos())
		G.chaosButton.Text = F.getChaos() and "Chaos: ON" or "Chaos: OFF"
		if F.getChaos() then F.startChaos() else F.stopChaos() end
		F.showNotif("Chaos", F.getChaos() and "✅ Enabled" or "❌ Disabled", 2)
	end
end)

end

return init
