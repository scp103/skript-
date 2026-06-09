-- Keybinds частина
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function init(G, F)
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end

			-- ` (під Escape) - відкрити Config систему
if input.KeyCode == Enum.KeyCode.BackQuote then
	if G.configFrame.Visible then
		G.configFrame.Visible = false
		G.frame.Visible = true
	else
		G.frame.Visible = false
		G.teleportFrame.Visible = false
		G.aimSettingsFrame.Visible = false
		G.hitboxSettingsFrame.Visible = false
		G.minimizedCircle.Visible = false
		G.configFrame.Visible = true
	end
end

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

		-- F8 - Noclip ON/OFF
		if input.KeyCode == Enum.KeyCode.F8 then
			F.setNoclip(not F.getNoclip())
			G.noclipButton.Text = F.getNoclip() and "Noclip: ON" or "Noclip: OFF"
			F.showNotif("Noclip", F.getNoclip() and "✅ Enabled" or "❌ Disabled", 2)
		end

		-- F9 - Fly ON/OFF
		if input.KeyCode == Enum.KeyCode.F9 then
			F.setFly(not F.getFly())
			G.flyButton.Text = F.getFly() and "Fly: ON" or "Fly: OFF"
			if F.getFly() then F.startFly() else F.stopFly() end
			F.showNotif("Fly", F.getFly() and "✅ Enabled" or "❌ Disabled", 2)
		end

		-- F10 - Speed ON/OFF
		if input.KeyCode == Enum.KeyCode.F10 then
			F.setSpeed(not F.getSpeed())
			G.speedButton.Text = F.getSpeed() and "Speed: ON" or "Speed: OFF"
			F.showNotif("Speed", F.getSpeed() and "✅ Enabled" or "❌ Disabled", 2)
		end

		-- F11 - Fullbright ON/OFF
		if input.KeyCode == Enum.KeyCode.F11 then
			F.setFullbright(not F.getFullbright())
			G.fullbrightButton.Text = F.getFullbright() and "Fullbright: ON" or "Fullbright: OFF"
			if F.getFullbright() then F.enableFullbright() else F.disableFullbright() end
			F.showNotif("Fullbright", F.getFullbright() and "✅ Enabled" or "❌ Disabled", 2)
		end

		-- PageUp - BunnyHop ON/OFF
		if input.KeyCode == Enum.KeyCode.PageUp then
			F.setBunnyHop(not F.getBunnyHop())
			G.bunnyHopButton.Text = F.getBunnyHop() and "BunnyHop: ON" or "BunnyHop: OFF"
			F.showNotif("BunnyHop", F.getBunnyHop() and "✅ Enabled" or "❌ Disabled", 2)
		end

			
		-- PageDown - Infinite Jump ON/OFF
		if input.KeyCode == Enum.KeyCode.PageDown then
			local ijs = game:GetService("UserInputService")
			F.setInfiniteJump(not F.getInfiniteJump())
			G.infiniteJumpButton.Text = F.getInfiniteJump() and "Infinite Jump: ON" or "Infinite Jump: OFF"
			if F.getInfiniteJump() then
				local conn = game:GetService("UserInputService").JumpRequest:Connect(function()
					if F.getInfiniteJump() then
						local char = game:GetService("Players").LocalPlayer.Character
						if char and char:FindFirstChildOfClass("Humanoid") then
							char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
						end
					end
				end)
				F.setInfiniteJumpConn(conn)
			else
				local conn = F.getInfiniteJumpConn()
				if conn then conn:Disconnect() end
				F.setInfiniteJumpConn(nil)
			end
			F.showNotif("Infinite Jump", F.getInfiniteJump() and "✅ Enabled" or "❌ Disabled", 2)
		end
	end)
end

return init
