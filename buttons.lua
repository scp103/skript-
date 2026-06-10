-- Buttons частина
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function init(G, F)

-- ============ ОСНОВНІ КНОПКИ ============
G.teleportButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		G.frame.Visible = false
		G.aimSettingsFrame.Visible = false
		G.hitboxSettingsFrame.Visible = false
		G.teleportFrame.Visible = true
		F.updateTeleportList()
	end
end)

G.backButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		G.teleportFrame.Visible = false
		G.frame.Visible = true
	end
end)

G.aimSettingsOpenButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		G.aimSettingsFrame.Visible = not G.aimSettingsFrame.Visible
		G.hitboxSettingsFrame.Visible = false
	end
end)

G.aimCloseButton.MouseButton1Click:Connect(function()
	if F.canClick() then G.aimSettingsFrame.Visible = false end
end)

G.aimButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setHolding(not F.getHolding())
		G.aimButton.Text = F.getHolding() and "AIM: ON" or "AIM: OFF"
	end
end)

G.fovCircleButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setFovCircle(not F.getFovCircle())
		G.fovCircleButton.Text = F.getFovCircle() and "FOV Circle: ON" or "FOV Circle: OFF"
	end
end)

G.wallButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setWallCheck(not F.getWallCheck())
		G.wallButton.Text = F.getWallCheck() and "WallCheck: ON" or "WallCheck: OFF"
	end
end)

G.espButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setEsp(not F.getEsp())
		G.espButton.Text = F.getEsp() and "ESP: ON" or "ESP: OFF"
		if not F.getEsp() then F.clearESP() end
	end
end)

G.charmsButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setCharms(not F.getCharms())
		G.charmsButton.Text = F.getCharms() and "Charms: ON" or "Charms: OFF"
	end
end)

G.infiniteJumpButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setInfiniteJump(not F.getInfiniteJump())
		G.infiniteJumpButton.Text = F.getInfiniteJump() and "Infinite Jump: ON" or "Infinite Jump: OFF"
		if F.getInfiniteJump() then
			F.setInfiniteJumpConn(UserInputService.JumpRequest:Connect(function()
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				end
			end))
		else
			local conn = F.getInfiniteJumpConn()
			if conn then conn:Disconnect(); F.setInfiniteJumpConn(nil) end
		end
	end
end)

G.noclipButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		local newState = not F.getNoclip()
		F.setNoclip(newState)
		G.noclipButton.Text = newState and "Noclip: ON" or "Noclip: OFF"
	end
end)

G.bunnyHopButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setBunnyHop(not F.getBunnyHop())
		G.bunnyHopButton.Text = F.getBunnyHop() and "BunnyHop: ON" or "BunnyHop: OFF"
	end
end)

G.skyButton.MouseButton1Click:Connect(function()
	if F.canClick() then F.changeSky() end
end)

G.chaosButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setChaos(not F.getChaos())
		G.chaosButton.Text = F.getChaos() and "Chaos: ON" or "Chaos: OFF"
		if F.getChaos() then F.startChaos() else F.stopChaos() end
	end
end)

G.thirdPersonButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setThirdPerson(not F.getThirdPerson())
		G.thirdPersonButton.Text = F.getThirdPerson() and "Third Person: ON" or "Third Person: OFF"
		if F.getThirdPerson() then F.startThirdPerson() else F.stopThirdPerson() end
	end
end)

G.wallHopButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setWallHop(not F.getWallHop())
		G.wallHopButton.Text = F.getWallHop() and "Wall Hop: ON" or "Wall Hop: OFF"
		if F.getWallHop() then F.startWallHop() else F.stopWallHop() end
	end
end)

G.hitboxButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setHitbox(not F.getHitbox())
		G.hitboxButton.Text = F.getHitbox() and "Hitbox: ON" or "Hitbox: OFF"
		F.updateHitboxes()
	end
end)

G.hitboxSettingsOpenButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		G.hitboxSettingsFrame.Visible = not G.hitboxSettingsFrame.Visible
		G.aimSettingsFrame.Visible = false
	end
end)

G.hitboxCloseButton.MouseButton1Click:Connect(function()
	if F.canClick() then G.hitboxSettingsFrame.Visible = false end
end)

G.hitboxHeadButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setHitboxPart("Head")
		F.updateHitboxPartButtons()
		if F.getHitbox() then F.updateHitboxes() end
	end
end)

G.hitboxTorsoButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setHitboxPart("Torso")
		F.updateHitboxPartButtons()
		if F.getHitbox() then F.updateHitboxes() end
	end
end)

G.hitboxArmsButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setHitboxPart("Arms")
		F.updateHitboxPartButtons()
		if F.getHitbox() then F.updateHitboxes() end
	end
end)

G.hitboxLegsButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setHitboxPart("Legs")
		F.updateHitboxPartButtons()
		if F.getHitbox() then F.updateHitboxes() end
	end
end)

G.fullbrightButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setFullbright(not F.getFullbright())
		G.fullbrightButton.Text = F.getFullbright() and "Fullbright: ON" or "Fullbright: OFF"
		if F.getFullbright() then F.enableFullbright() else F.disableFullbright() end
	end
end)

G.godModeButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setGodMode(not F.getGodMode())
		G.godModeButton.Text = F.getGodMode() and "God Mode: ON" or "God Mode: OFF"
		if F.getGodMode() then F.startGodMode() else F.stopGodMode() end
	end
end)

G.fpsBoostButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setFpsBoost(not F.getFpsBoost())
		G.fpsBoostButton.Text = F.getFpsBoost() and "FPS Boost: ON" or "FPS Boost: OFF"
		if F.getFpsBoost() then F.enableFPSBoost() else F.disableFPSBoost() end
	end
end)

G.antiAfkButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setAntiAfk(not F.getAntiAfk())
		G.antiAfkButton.Text = F.getAntiAfk() and "Anti AFK: ON" or "Anti AFK: OFF"
		if F.getAntiAfk() then F.startAntiAFK() else F.stopAntiAFK() end
	end
end)

G.flyButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setFly(not F.getFly())
		G.flyButton.Text = F.getFly() and "Fly: ON" or "Fly: OFF"
		if F.getFly() then F.startFly() else F.stopFly() end
	end
end)

G.speedButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setSpeed(not F.getSpeed())
		G.speedButton.Text = F.getSpeed() and "Speed: ON" or "Speed: OFF"
	end
end)

G.fovButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		F.setFovChanger(not F.getFovChanger())
		G.fovButton.Text = F.getFovChanger() and "FOV: ON" or "FOV: OFF"
	end
end)

-- ============ MINIMIZE ============
G.minimizeButton.MouseButton1Click:Connect(function()
	if F.canClick() then
		G.frame.Visible = false
		G.teleportFrame.Visible = false
		G.aimSettingsFrame.Visible = false
		G.hitboxSettingsFrame.Visible = false
		G.configFrame.Visible = false
		G.minimizedCircle.Visible = true
	end
end)

G.minimizedCircle.MouseButton1Click:Connect(function()
	if F.canClick() then
		G.frame.Visible = true
		G.minimizedCircle.Visible = false
	end
end)

-- PC Trigger
G.pcTriggerButton.MouseButton1Click:Connect(function()
    if F.canClick() then
        local newVal = not F.getPCTrigger()
        if newVal then
            -- вимикаємо мобільний якщо увімкнено
            F.setMobileTrigger(false)
            G.mobileTriggerButton.Text = "Mobile Trigger: OFF"
            G.mobileTriggerButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
        end
        F.setPCTrigger(newVal)
        G.pcTriggerButton.Text = newVal and "PC Trigger: ON" or "PC Trigger: OFF"
        G.pcTriggerButton.BackgroundColor3 = newVal and Color3.fromRGB(0,180,0) or Color3.fromRGB(40,40,40)
    end
end)

-- Mobile Trigger
G.mobileTriggerButton.MouseButton1Click:Connect(function()
    if F.canClick() then
        local newVal = not F.getMobileTrigger()
        if newVal then
            -- вимикаємо PC якщо увімкнено
            F.setPCTrigger(false)
            G.pcTriggerButton.Text = "PC Trigger: OFF"
            G.pcTriggerButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
        end
        F.setMobileTrigger(newVal)
        G.mobileTriggerButton.Text = newVal and "Mobile Trigger: ON" or "Mobile Trigger: OFF"
        G.mobileTriggerButton.BackgroundColor3 = newVal and Color3.fromRGB(0,180,0) or Color3.fromRGB(40,40,40)
		G.mobileGui.Visible = newVal
		G.mobileSpaceFrame.Visible = newVal
    end
end)

-- Val Check
G.valCheckButton.MouseButton1Click:Connect(function()
    if F.canClick() then
        F.setValCheck(not F.getValCheck())
        G.valCheckButton.Text = F.getValCheck() and "Val Check: ON" or "Val Check: OFF"
        G.valCheckButton.BackgroundColor3 = F.getValCheck() and Color3.fromRGB(0,180,0) or Color3.fromRGB(40,40,40)
    end
end)

-- Val Check відкрити список гравців
G.valCheckOpenButton.MouseButton1Click:Connect(function()
    if F.canClick() then
        local visible = not G.playerSelectFrame.Visible
        G.playerSelectFrame.Visible = visible
        if visible then F.updatePlayerSelectList() end
    end
end)

-- Val Check закрити список
G.playerSelectClose.MouseButton1Click:Connect(function()
    if F.canClick() then G.playerSelectFrame.Visible = false end
end)

G.triggerWallCheckButton.MouseButton1Click:Connect(function()
    if F.canClick() then
        F.setTriggerWallCheck(not F.getTriggerWallCheck())
        G.triggerWallCheckButton.Text = F.getTriggerWallCheck() and "Trigger WallCheck: ON" or "Trigger WallCheck: OFF"
        G.triggerWallCheckButton.BackgroundColor3 = F.getTriggerWallCheck() and Color3.fromRGB(0,180,0) or Color3.fromRGB(40,40,40)
    end
end)

end

return init
