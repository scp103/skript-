-- Functions частина
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function init(G, V)

-- ========== АНТИ-ДЕТЕКТ ==========
local function genrandstr(length)
	local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local result = ""
	for i = 1, length do
		local randIndex = math.random(1, #charset)
		result = result .. charset:sub(randIndex, randIndex)
	end
	return result
end

local function encryptNames(parent)
	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("GuiObject") or child:IsA("UIBase") then
			child.Name = genrandstr(15)
			encryptNames(child)
		end
	end
end

local function startSecurity()
	while task.wait(1) do
		if G.screenGui then G.screenGui.Name = genrandstr(20) end
		if G.frame then G.frame.Name = genrandstr(18); encryptNames(G.frame) end
		if G.teleportFrame then G.teleportFrame.Name = genrandstr(18) end
		if G.aimSettingsFrame then G.aimSettingsFrame.Name = genrandstr(18) end
		if G.hitboxSettingsFrame then G.hitboxSettingsFrame.Name = genrandstr(18) end
		if G.configFrame then G.configFrame.Name = genrandstr(18) end
		if G.minimizedCircle then G.minimizedCircle.Name = genrandstr(15) end
	end
end

spawn(startSecurity)

-- ============ ЗМІННІ ============
local AimPart = "Head"
local FieldOfView = 60
local Holding = false
local WallCheckEnabled = false
local fovCircleEnabled = false
local espEnabled = false
local espObjects = {}
local bunnyHopEnabled = false
local speedHackEnabled = false
local currentSpeed = 16
local flyEnabled = false
local flySpeed = 50
local fovChangerEnabled = false
local currentFOV = 70
local skyIndex = 1
local charmsEnabled = false
local infiniteJumpEnabled = false
local chaosEnabled = false
local originalLightingSettings = {}
local chaosConnection = nil
local chaosSound = nil
local originalCameraMode = nil
local chaosSpinAngle = 0
local hitboxEnabled = false
local hitboxSize = 20
local hitboxPart = "Head"
local fullbrightEnabled = false
local godModeEnabled = false
local godModeConnection = nil
local thirdPersonEnabled = false
local thirdPersonConnection = nil
local wallHopEnabled = false
local fpsBoostEnabled = false
local originalTextureQuality = nil
local antiAfkEnabled = false
local antiAfkConnection = nil
local originalHitboxSizes = {}
local flyConnection, speedHackConnection, fovChangerConnection, noclipConnection
local bunnyHopConnection, infiniteJumpConnection
local bodyVelocity, bodyAngularVelocity
local lastClickTime = 0
local clickDelay = 0.5
local savedObjects = {}
local wallHopConnection = nil
local canWallJump = true
local savedConfigs = {}
local selectedConfig = nil

local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(0, 255, 0)
circle.Thickness = 1
circle.Radius = FieldOfView
circle.Filled = false
circle.Visible = true

-- ============ УТІЛІТИ ============
local function canClick()
	local currentTime = tick()
	if currentTime - lastClickTime < clickDelay then return false end
	lastClickTime = currentTime
	return true
end

local function showNotif(title, text, duration)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = title;
		Text = text;
		Duration = duration or 2;
	})
end

-- ============ АНІМАЦІЯ ============
RunService.RenderStepped:Connect(function(dt)
	local hue = (tick() * 0.5) % 1
	G.titleLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

task.spawn(function()
	while true do
		if G.minimizedCircle.Visible then
			local t = tick()
			G.minimizedCircle.BackgroundColor3 = Color3.new(
				0.5 + 0.5 * math.sin(t),
				0.5 + 0.5 * math.sin(t + 2),
				0.5 + 0.5 * math.sin(t + 4)
			)
		end
		task.wait(0.05)
	end
end)

-- ============ ТЕЛЕПОРТ ============
local function teleportToPlayer(targetPlayer)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
	   targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
	end
end

local function updateTeleportList()
	for _, child in pairs(G.teleportScroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	local yPos = 5
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local btn = Instance.new("TextButton", G.teleportScroll)
			btn.Size = UDim2.new(0.9, 0, 0, 30)
			btn.Position = UDim2.new(0.05, 0, 0, yPos)
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 14
			btn.Text = player.Name
			local c = Instance.new("UICorner", btn)
			btn.MouseButton1Click:Connect(function()
				if canClick() then teleportToPlayer(player) end
			end)
			yPos = yPos + 35
		end
	end
	G.teleportScroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- ============ SKY ============
local function changeSky()
	local sky = Lighting:FindFirstChildOfClass("Sky")
	if skyIndex == 1 then
		if not sky then sky = Instance.new("Sky", Lighting) end
		sky.SkyboxBk = "rbxassetid://159454299"
		sky.SkyboxDn = "rbxassetid://159454296"
		sky.SkyboxFt = "rbxassetid://159454293"
		sky.SkyboxLf = "rbxassetid://159454286"
		sky.SkyboxRt = "rbxassetid://159454300"
		sky.SkyboxUp = "rbxassetid://159454288"
		G.skyButton.Text = "Sky: Space"
		skyIndex = 2
	else
		if sky then sky:Destroy() end
		G.skyButton.Text = "Sky: Default"
		skyIndex = 1
	end
end

-- ============ CHAOS ============
local function saveLightingSettings()
	originalLightingSettings = {
		Ambient = Lighting.Ambient,
		Brightness = Lighting.Brightness,
		ColorShift_Bottom = Lighting.ColorShift_Bottom,
		ColorShift_Top = Lighting.ColorShift_Top,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		FogColor = Lighting.FogColor,
		FogEnd = Lighting.FogEnd,
		FogStart = Lighting.FogStart
	}
end

local function restoreLightingSettings()
	if originalLightingSettings.Ambient then
		Lighting.Ambient = originalLightingSettings.Ambient
		Lighting.Brightness = originalLightingSettings.Brightness
		Lighting.ColorShift_Bottom = originalLightingSettings.ColorShift_Bottom
		Lighting.ColorShift_Top = originalLightingSettings.ColorShift_Top
		Lighting.OutdoorAmbient = originalLightingSettings.OutdoorAmbient
		Lighting.FogColor = originalLightingSettings.FogColor
		Lighting.FogEnd = originalLightingSettings.FogEnd
		Lighting.FogStart = originalLightingSettings.FogStart
	end
end

local function startChaos()
	saveLightingSettings()
	originalCameraMode = LocalPlayer.CameraMode
	LocalPlayer.CameraMode = Enum.CameraMode.Classic
	chaosSound = Instance.new("Sound", workspace)
	chaosSound.SoundId = "rbxassetid://1839246711"
	chaosSound.Volume = 0.5
	chaosSound.Looped = true
	chaosSound:Play()
	chaosConnection = RunService.Heartbeat:Connect(function(dt)
		local t = tick() * 2
		Lighting.Ambient = Color3.new(math.abs(math.sin(t)), math.abs(math.sin(t+2)), math.abs(math.sin(t+4)))
		chaosSpinAngle = chaosSpinAngle + (dt * 420)
		if chaosSpinAngle >= 360 then chaosSpinAngle = 0 end
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local root = LocalPlayer.Character.HumanoidRootPart
			root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(chaosSpinAngle), 0)
		end
	end)
end

local function stopChaos()
	if chaosConnection then chaosConnection:Disconnect(); chaosConnection = nil end
	if chaosSound then chaosSound:Stop(); chaosSound:Destroy(); chaosSound = nil end
	if originalCameraMode then LocalPlayer.CameraMode = originalCameraMode end
	restoreLightingSettings()
end

-- ============ THIRD PERSON ============
local function startThirdPerson()
	LocalPlayer.CameraMode = Enum.CameraMode.Classic
	LocalPlayer.CameraMaxZoomDistance = 128
	LocalPlayer.CameraMinZoomDistance = 0.5
	thirdPersonConnection = RunService.RenderStepped:Connect(function()
		LocalPlayer.CameraMode = Enum.CameraMode.Classic
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (Camera.CFrame.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			if distance < 3 then
				local root = LocalPlayer.Character.HumanoidRootPart
				local camLook = Camera.CFrame.LookVector
				local newPos = root.Position - (camLook * 5) + Vector3.new(0, 2, 0)
				Camera.CFrame = CFrame.new(newPos, root.Position + Vector3.new(0, 2, 0))
			end
		end
	end)
end

local function stopThirdPerson()
	if thirdPersonConnection then thirdPersonConnection:Disconnect(); thirdPersonConnection = nil end
	LocalPlayer.CameraMode = Enum.CameraMode.Classic
	LocalPlayer.CameraMaxZoomDistance = 128
	LocalPlayer.CameraMinZoomDistance = 0.5
end

-- ============ WALL HOP ============
local function startWallHop()
	wallHopConnection = RunService.RenderStepped:Connect(function()
		local char = LocalPlayer.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char.HumanoidRootPart
		local ray = Ray.new(root.Position, root.CFrame.LookVector * 3)
		local hit = workspace:FindPartOnRay(ray, char)
		if hit and canWallJump then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
			canWallJump = false
			task.delay(0.4, function() canWallJump = true end)
		end
	end)
end

local function stopWallHop()
	if wallHopConnection then wallHopConnection:Disconnect(); wallHopConnection = nil end
	canWallJump = true
end

-- ============ FPS BOOST ============
local function enableFPSBoost()
	originalTextureQuality = settings():GetService("RenderSettings").QualityLevel
	settings():GetService("RenderSettings").QualityLevel = Enum.QualityLevel.Level01
	savedObjects = {}
	for _, obj in pairs(workspace:GetDescendants()) do
		local isChar = obj.Parent and obj.Parent:FindFirstChildOfClass("Humanoid")
		if not isChar then
			if obj:IsA("Decal") or obj:IsA("Texture") then
				table.insert(savedObjects, {obj=obj, type="Transparency", value=obj.Transparency})
				obj.Transparency = 1
			end
			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
				table.insert(savedObjects, {obj=obj, type="Enabled", value=obj.Enabled})
				obj.Enabled = false
			end
			if obj:IsA("MeshPart") then
				table.insert(savedObjects, {obj=obj, type="TextureID", value=obj.TextureID})
				obj.TextureID = ""
			end
			if obj:IsA("SpecialMesh") then
				table.insert(savedObjects, {obj=obj, type="TextureId", value=obj.TextureId})
				obj.TextureId = ""
			end
		end
	end
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	for _, effect in pairs(Lighting:GetChildren()) do
		if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
			table.insert(savedObjects, {obj=effect, type="Enabled", value=effect.Enabled})
			effect.Enabled = false
		end
	end
end

local function disableFPSBoost()
	if originalTextureQuality then
		settings():GetService("RenderSettings").QualityLevel = originalTextureQuality
	end
	Lighting.GlobalShadows = true
	Lighting.FogEnd = 100000
	for _, data in pairs(savedObjects) do
		if data.obj then
			if data.type == "Transparency" then data.obj.Transparency = data.value
			elseif data.type == "Enabled" then data.obj.Enabled = data.value
			elseif data.type == "TextureID" then data.obj.TextureID = data.value
			elseif data.type == "TextureId" then data.obj.TextureId = data.value end
		end
	end
	savedObjects = {}
end

-- ============ ANTI AFK ============
local function startAntiAFK()
	antiAfkConnection = RunService.Heartbeat:Connect(function()
		local VirtualUser = game:GetService("VirtualUser")
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
end

local function stopAntiAFK()
	if antiAfkConnection then antiAfkConnection:Disconnect(); antiAfkConnection = nil end
end

-- ============ FULLBRIGHT ============
local function enableFullbright()
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.GlobalShadows = false
	Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end

local function disableFullbright()
	Lighting.Brightness = 1
	Lighting.ClockTime = 12
	Lighting.GlobalShadows = true
	Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
end

-- ============ GOD MODE ============
local function startGodMode()
	local char = LocalPlayer.Character
	if not char then return end
	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then v.CanTouch = false end
	end
	godModeConnection = char.DescendantAdded:Connect(function(d)
		if godModeEnabled and d:IsA("BasePart") then d.CanTouch = false end
	end)
end

local function stopGodMode()
	if godModeConnection then godModeConnection:Disconnect(); godModeConnection = nil end
	local char = LocalPlayer.Character
	if char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanTouch = true end
		end
	end
end

-- ============ HITBOX ============
local function updateHitboxPartButtons()
	G.hitboxHeadButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	G.hitboxTorsoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	G.hitboxArmsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	G.hitboxLegsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	if hitboxPart == "Head" then G.hitboxHeadButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	elseif hitboxPart == "Torso" then G.hitboxTorsoButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	elseif hitboxPart == "Arms" then G.hitboxArmsButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	elseif hitboxPart == "Legs" then G.hitboxLegsButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) end
end

local function updateHitboxes()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local function setPartSize(part, key)
				if not part then return end
				if not originalHitboxSizes[player.Name.."_"..key] then
					originalHitboxSizes[player.Name.."_"..key] = part.Size
				end
				if hitboxEnabled then
					part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
					part.Transparency = 0.5
					part.CanCollide = false
					part.Massless = true
				else
					local orig = originalHitboxSizes[player.Name.."_"..key]
					if orig then
						part.Size = orig
						part.Transparency = 0
						part.CanCollide = false
						part.Massless = false
					end
				end
			end

			if hitboxPart == "Head" then
				setPartSize(player.Character:FindFirstChild("Head"), "Head")
			elseif hitboxPart == "Torso" then
				setPartSize(
					player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso"),
					"Torso"
				)
			elseif hitboxPart == "Arms" then
				setPartSize(player.Character:FindFirstChild("Left Arm") or player.Character:FindFirstChild("LeftUpperArm"), "LeftArm")
				setPartSize(player.Character:FindFirstChild("Right Arm") or player.Character:FindFirstChild("RightUpperArm"), "RightArm")
			elseif hitboxPart == "Legs" then
				setPartSize(player.Character:FindFirstChild("Left Leg") or player.Character:FindFirstChild("LeftUpperLeg"), "LeftLeg")
				setPartSize(player.Character:FindFirstChild("Right Leg") or player.Character:FindFirstChild("RightUpperLeg"), "RightLeg")
			end
		end
	end
end

local hitboxTimer = 0
RunService.Heartbeat:Connect(function(dt)
	if hitboxEnabled then
		hitboxTimer = hitboxTimer + dt
		if hitboxTimer >= 0.5 then
			hitboxTimer = 0
			pcall(updateHitboxes)
		end
	end
end)

-- ============ AIM ============
local function IsVisible(part)
	if not WallCheckEnabled then return true end
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	local direction = (part.Position - Camera.CFrame.Position).Unit * 500
	local result = workspace:Raycast(Camera.CFrame.Position, direction, rayParams)
	return not (result and result.Instance and not result.Instance:IsDescendantOf(part.Parent))
end

local function GetClosestPlayer()
	local closestPlayer, shortestDistance = nil, FieldOfView
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(AimPart) then
			local part = v.Character[AimPart]
			local vector, onScreen = Camera:WorldToViewportPoint(part.Position)
			if onScreen and IsVisible(part) then
				local dist = (Vector2.new(vector.X, vector.Y) - screenCenter).Magnitude
				if dist < shortestDistance then closestPlayer, shortestDistance = v, dist end
			end
		end
	end
	return closestPlayer
end

RunService.RenderStepped:Connect(function()
	if Holding then
		local target = GetClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild(AimPart) then
			local camPos = Camera.CFrame.Position
			local headPos = target.Character[AimPart].Position
			Camera.CFrame = CFrame.new(camPos, camPos + (headPos - camPos).Unit)
		end
	end
	local target = GetClosestPlayer()
	if WallCheckEnabled and target and target.Character and target.Character:FindFirstChild(AimPart) then
		circle.Color = IsVisible(target.Character[AimPart]) and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
	else
		circle.Color = Color3.fromRGB(0,255,0)
	end
	circle.Position = screenCenter
	circle.Visible = fovCircleEnabled
end)

-- ============ ESP ============
local charmsObjects = {}

local function clearESP()
	for _, esp in pairs(espObjects) do
		for _, obj in pairs(esp) do if obj and obj.Remove then obj:Remove() end end
	end
	espObjects = {}
end

local function removePlayerESP(player)
	if espObjects[player] then
		for _, obj in pairs(espObjects[player]) do if obj and obj.Remove then obj:Remove() end end
		espObjects[player] = nil
	end
end

local function createESP(p)
	if p == LocalPlayer then return end
	local box = Drawing.new("Square")
	box.Thickness = 2; box.Color = Color3.fromRGB(0,255,0); box.Filled = false; box.Transparency = 1; box.Visible = false
	local name = Drawing.new("Text")
	name.Size = 14; name.Center = true; name.Outline = true; name.Color = Color3.fromRGB(0,255,255); name.Visible = false
	local health = Drawing.new("Text")
	health.Size = 13; health.Center = true; health.Outline = true; health.Color = Color3.fromRGB(0,255,0); health.Visible = false
	local distance = Drawing.new("Text")
	distance.Size = 13; distance.Center = true; distance.Outline = true; distance.Color = Color3.fromRGB(255,255,0); distance.Visible = false
	local tracer = Drawing.new("Line")
	tracer.Thickness = 1; tracer.Color = Color3.fromRGB(255,255,255); tracer.Transparency = 0.8; tracer.Visible = false
	espObjects[p] = {Box=box, Name=name, Health=health, Distance=distance, Tracer=tracer}
end

local function clearCharms()
	for _, charm in pairs(charmsObjects) do if charm and charm.Destroy then charm:Destroy() end end
	charmsObjects = {}
end

local function createCharms(p)
	if p == LocalPlayer then return end
	if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
		local h = Instance.new("Highlight")
		h.Parent = p.Character
		h.FillColor = Color3.fromRGB(0,255,0)
		h.FillTransparency = 0.5
		h.OutlineColor = Color3.fromRGB(0,255,0)
		h.OutlineTransparency = 0
		charmsObjects[p] = h
	end
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removePlayerESP)
Players.PlayerRemoving:Connect(function(p)
	if charmsObjects[p] then charmsObjects[p]:Destroy(); charmsObjects[p] = nil end
end)

RunService.RenderStepped:Connect(function()
	if charmsEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and not charmsObjects[p] then createCharms(p) end
		end
	else
		clearCharms()
	end
end)

RunService.RenderStepped:Connect(function()
	if not espEnabled then
		for _, esp in pairs(espObjects) do
			for _, obj in pairs(esp) do if obj then obj.Visible = false end end
		end
		return
	end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local esp = espObjects[p]
			if not esp then createESP(p); esp = espObjects[p] end
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
				local root = p.Character.HumanoidRootPart
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				if hum.Health > 0 then
					local pos, visible = Camera:WorldToViewportPoint(root.Position)
					if visible and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
						local scale = math.clamp(3000/dist, 100, 300)
						local width, height = scale/2, scale
						local rayParams = RaycastParams.new()
						rayParams.FilterDescendantsInstances = {LocalPlayer.Character, p.Character}
						rayParams.FilterType = Enum.RaycastFilterType.Exclude
						local rayResult = workspace:Raycast(Camera.CFrame.Position, root.Position - Camera.CFrame.Position, rayParams)
						local canSee = not (rayResult and rayResult.Instance)
						local col = canSee and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
						esp.Box.Color = col; esp.Tracer.Color = col
						esp.Box.Size = Vector2.new(width, height)
						esp.Box.Position = Vector2.new(pos.X-width/2, pos.Y-height/1.5)
						esp.Box.Visible = true
						esp.Name.Position = Vector2.new(pos.X, pos.Y-height/1.5-15)
						esp.Name.Text = p.Name; esp.Name.Visible = true
						esp.Health.Position = Vector2.new(pos.X, pos.Y-height/1.5)
						esp.Health.Text = "HP: "..math.floor(hum.Health); esp.Health.Visible = true
						esp.Distance.Position = Vector2.new(pos.X, pos.Y+height/2+5)
						esp.Distance.Text = "Dist: "..math.floor(dist); esp.Distance.Visible = true
						esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
						esp.Tracer.To = Vector2.new(pos.X, pos.Y); esp.Tracer.Visible = true
					else
						for _, v in pairs(esp) do v.Visible = false end
					end
				else
					for _, v in pairs(esp) do v.Visible = false end
				end
			else
				for _, v in pairs(esp) do v.Visible = false end
			end
		end
	end
end)

-- ============ FLY ============
local function startFly()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local root = char.HumanoidRootPart
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
		bodyVelocity.Velocity = Vector3.new(0,0,0)
		bodyVelocity.Parent = root
		bodyAngularVelocity = Instance.new("BodyAngularVelocity")
		bodyAngularVelocity.MaxTorque = Vector3.new(4000,4000,4000)
		bodyAngularVelocity.AngularVelocity = Vector3.new(0,0,0)
		bodyAngularVelocity.Parent = root
		flyConnection = RunService.RenderStepped:Connect(function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and bodyVelocity then
				local moveVector = Vector3.new(0,0,0)
				local cam = workspace.CurrentCamera
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0,1,0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector + Vector3.new(0,-1,0) end
				bodyVelocity.Velocity = moveVector.Magnitude > 0 and moveVector.Unit * flySpeed or Vector3.new(0,0,0)
			end
		end)
	end
end

local function stopFly()
	if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
	if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
	if bodyAngularVelocity then bodyAngularVelocity:Destroy(); bodyAngularVelocity = nil end
end

-- ============ SPEED/FOV ============
local function updateSpeed()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = currentSpeed
	end
end

local function updateSlider()
	G.sliderButton.Position = UDim2.new((currentSpeed-16)/(400-16), -10, 0, -2.5)
	G.speedInput.Text = tostring(currentSpeed)
end

local function updateFOV()
	if Camera then Camera.FieldOfView = currentFOV end
end

local function updateFOVSlider()
	G.fovSliderButton.Position = UDim2.new((currentFOV-30)/(120-30), -10, 0, -2.5)
	G.fovInput.Text = tostring(currentFOV)
end

local function updateAimFOVSlider()
	G.aimFOVSliderButton.Position = UDim2.new((FieldOfView-30)/(200-30), -10, 0, -2.5)
	G.aimFOVInput.Text = tostring(FieldOfView)
	circle.Radius = FieldOfView
end

-- ============ SLIDERS ============
local draggingSlider, draggingFOVSlider, draggingAimFOVSlider = false, false, false

local function handleSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sp = G.sliderFrame.AbsolutePosition
	local ss = G.sliderFrame.AbsoluteSize
	if mouse.X >= sp.X and mouse.X <= sp.X+ss.X then
		local pct = math.clamp(mouse.X-sp.X, 0, ss.X)/ss.X
		currentSpeed = math.clamp(math.floor(16+(400-16)*pct+0.5), 16, 400)
		updateSlider()
		if speedHackEnabled then updateSpeed() end
	end
end

local function handleFOVSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sp = G.fovSliderFrame.AbsolutePosition
	local ss = G.fovSliderFrame.AbsoluteSize
	if mouse.X >= sp.X and mouse.X <= sp.X+ss.X then
		local pct = math.clamp(mouse.X-sp.X, 0, ss.X)/ss.X
		currentFOV = math.clamp(math.floor(30+(120-30)*pct+0.5), 30, 120)
		updateFOVSlider()
		if fovChangerEnabled then updateFOV() end
	end
end

local function handleAimFOVSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sp = G.aimFOVSliderFrame.AbsolutePosition
	local ss = G.aimFOVSliderFrame.AbsoluteSize
	if mouse.X >= sp.X and mouse.X <= sp.X+ss.X then
		local pct = math.clamp(mouse.X-sp.X, 0, ss.X)/ss.X
		FieldOfView = math.clamp(math.floor(30+(200-30)*pct+0.5), 30, 200)
		updateAimFOVSlider()
	end
end

G.sliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true; handleSliderInput()
	end
end)

G.fovSliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFOVSlider = true; handleFOVSliderInput()
	end
end)

G.aimFOVSliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingAimFOVSlider = true; handleAimFOVSliderInput()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider, draggingFOVSlider, draggingAimFOVSlider = false, false, false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then handleSliderInput()
	elseif draggingFOVSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then handleFOVSliderInput()
	elseif draggingAimFOVSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then handleAimFOVSliderInput()
	end
end)

-- ============ TEXT INPUTS ============
G.speedInput.FocusLost:Connect(function()
	local v = tonumber(G.speedInput.Text)
	if v and v >= 16 and v <= 400 then currentSpeed = v; updateSlider(); if speedHackEnabled then updateSpeed() end
	else G.speedInput.Text = tostring(currentSpeed) end
end)

G.flyInput.FocusLost:Connect(function()
	local v = tonumber(G.flyInput.Text)
	if v and v >= 10 and v <= 450 then flySpeed = v
	else G.flyInput.Text = tostring(flySpeed) end
end)

G.fovInput.FocusLost:Connect(function()
	local v = tonumber(G.fovInput.Text)
	if v and v >= 30 and v <= 120 then currentFOV = v; updateFOVSlider(); if fovChangerEnabled then updateFOV() end
	else G.fovInput.Text = tostring(currentFOV) end
end)

G.aimFOVInput.FocusLost:Connect(function()
	local v = tonumber(G.aimFOVInput.Text)
	if v and v >= 30 and v <= 200 then FieldOfView = v; updateAimFOVSlider()
	else G.aimFOVInput.Text = tostring(FieldOfView) end
end)

G.hitboxSizeInput.FocusLost:Connect(function()
	local v = tonumber(G.hitboxSizeInput.Text)
	if v and v >= 5 and v <= 50 then hitboxSize = v; if hitboxEnabled then updateHitboxes() end
	else G.hitboxSizeInput.Text = tostring(hitboxSize) end
end)

-- ============ CONFIG СИСТЕМА ============
local function getCurrentConfig()
	return {
		aimEnabled = Holding,
		fovCircle = fovCircleEnabled,
		wallCheck = WallCheckEnabled,
		aimFOV = FieldOfView,
		espEnabled = espEnabled,
		charmsEnabled = charmsEnabled,
		infiniteJump = infiniteJumpEnabled,
		noclip = (noclipConnection ~= nil),
		bunnyHop = bunnyHopEnabled,
		chaos = chaosEnabled,
		thirdPerson = thirdPersonEnabled,
		wallHop = wallHopEnabled,
		hitboxEnabled = hitboxEnabled,
		hitboxPart = hitboxPart,
		hitboxSize = hitboxSize,
		fullbright = fullbrightEnabled,
		godMode = godModeEnabled,
		fpsBoost = fpsBoostEnabled,
		antiAfk = antiAfkEnabled,
		flySpeed = flySpeed,
		speed = currentSpeed,
		fov = currentFOV,
	}
end

local function updateConfigList()
	for _, child in pairs(G.configScroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	local yPos = 5
	for name, _ in pairs(savedConfigs) do
		local btn = Instance.new("TextButton", G.configScroll)
		btn.Size = UDim2.new(0.95, 0, 0, 35)
		btn.Position = UDim2.new(0.025, 0, 0, yPos)
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 14
		btn.Text = name
		local c = Instance.new("UICorner", btn)
		btn.MouseButton1Click:Connect(function()
			for _, b in pairs(G.configScroll:GetChildren()) do
				if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end
			end
			btn.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
			selectedConfig = name
			G.configNameInput.Text = name
		end)
		yPos = yPos + 40
	end
	G.configScroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

local function applyConfig(config)
	-- AIM
	Holding = config.aimEnabled
	G.aimButton.Text = Holding and "AIM: ON" or "AIM: OFF"
	-- FOV Circle
	fovCircleEnabled = config.fovCircle
	G.fovCircleButton.Text = fovCircleEnabled and "FOV Circle: ON" or "FOV Circle: OFF"
	-- WallCheck
	WallCheckEnabled = config.wallCheck
	G.wallButton.Text = WallCheckEnabled and "WallCheck: ON" or "WallCheck: OFF"
	-- Aim FOV
	FieldOfView = config.aimFOV
	updateAimFOVSlider()
	-- ESP
	espEnabled = config.espEnabled
	G.espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	-- Charms
	charmsEnabled = config.charmsEnabled
	G.charmsButton.Text = charmsEnabled and "Charms: ON" or "Charms: OFF"
	-- Infinite Jump
	infiniteJumpEnabled = config.infiniteJump
	G.infiniteJumpButton.Text = infiniteJumpEnabled and "Infinite Jump: ON" or "Infinite Jump: OFF"
	-- BunnyHop
	bunnyHopEnabled = config.bunnyHop
	G.bunnyHopButton.Text = bunnyHopEnabled and "BunnyHop: ON" or "BunnyHop: OFF"
	-- Hitbox
	hitboxEnabled = config.hitboxEnabled
	hitboxPart = config.hitboxPart
	hitboxSize = config.hitboxSize
	G.hitboxButton.Text = hitboxEnabled and "Hitbox: ON" or "Hitbox: OFF"
	G.hitboxSizeInput.Text = tostring(hitboxSize)
	updateHitboxPartButtons()
	-- Fullbright
	fullbrightEnabled = config.fullbright
	G.fullbrightButton.Text = fullbrightEnabled and "Fullbright: ON" or "Fullbright: OFF"
	if fullbrightEnabled then enableFullbright() else disableFullbright() end
	-- Speed/FOV
	currentSpeed = config.speed
	updateSlider()
	currentFOV = config.fov
	updateFOVSlider()
	flySpeed = config.flySpeed
	G.flyInput.Text = tostring(flySpeed)
	showNotif("✅ Config", "Loaded: "..selectedConfig, 2)
end

-- Config кнопки
G.configButton.MouseButton1Click:Connect(function()
	if canClick() then
		G.frame.Visible = false
		G.aimSettingsFrame.Visible = false
		G.hitboxSettingsFrame.Visible = false
		G.configFrame.Visible = true
		updateConfigList()
	end
end)

G.configBackButton.MouseButton1Click:Connect(function()
	if canClick() then
		G.configFrame.Visible = false
		G.frame.Visible = true
	end
end)

G.saveConfigButton.MouseButton1Click:Connect(function()
	if canClick() then
		local name = G.configNameInput.Text
		if name ~= "" then
			savedConfigs[name] = getCurrentConfig()
			updateConfigList()
			showNotif("💾 Config", "Saved: "..name, 2)
		end
	end
end)

G.loadConfigButton.MouseButton1Click:Connect(function()
	if canClick() then
		local name = G.configNameInput.Text ~= "" and G.configNameInput.Text or selectedConfig
		if name and savedConfigs[name] then
			selectedConfig = name
			applyConfig(savedConfigs[name])
		end
	end
end)

G.deleteConfigButton.MouseButton1Click:Connect(function()
	if canClick() then
		if selectedConfig and savedConfigs[selectedConfig] then
			savedConfigs[selectedConfig] = nil
			selectedConfig = nil
			G.configNameInput.Text = ""
			updateConfigList()
			showNotif("🗑️ Config", "Deleted!", 2)
		end
	end
end)

-- ============ DRAG ============
local function makeDraggable(frame, dragHandle)
	local dragging, dragStart, startPos = false, nil, nil
	local handle = dragHandle or frame
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if not draggingSlider and not draggingFOVSlider and not draggingAimFOVSlider then
				dragging = true; dragStart = input.Position; startPos = frame.Position
			end
		end
	end)
	handle.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
		end
	end)
	handle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDraggable(G.frame, G.titleLabel)
makeDraggable(G.teleportFrame, G.teleportTitle)
makeDraggable(G.minimizedCircle)
makeDraggable(G.aimSettingsFrame, G.aimSettingsTitle)
makeDraggable(G.hitboxSettingsFrame, G.hitboxSettingsTitle)
makeDraggable(G.configFrame, G.configTitle)

-- Init sliders
updateSlider()
updateFOVSlider()
updateAimFOVSlider()

-- Повертаємо всі функції для buttons.lua
return {
	canClick = canClick,
	showNotif = showNotif,
	updateTeleportList = updateTeleportList,
	changeSky = changeSky,
	startChaos = startChaos,
	stopChaos = stopChaos,
	startThirdPerson = startThirdPerson,
	stopThirdPerson = stopThirdPerson,
	startWallHop = startWallHop,
	stopWallHop = stopWallHop,
	enableFPSBoost = enableFPSBoost,
	disableFPSBoost = disableFPSBoost,
	startAntiAFK = startAntiAFK,
	stopAntiAFK = stopAntiAFK,
	enableFullbright = enableFullbright,
	disableFullbright = disableFullbright,
	startGodMode = startGodMode,
	stopGodMode = stopGodMode,
	updateHitboxes = updateHitboxes,
	updateHitboxPartButtons = updateHitboxPartButtons,
	startFly = startFly,
	stopFly = stopFly,
	updateSpeed = updateSpeed,
	updateFOV = updateFOV,
	clearESP = clearESP,
	-- Стан
	getHolding = function() return Holding end,
	setHolding = function(v) Holding = v end,
	getFovCircle = function() return fovCircleEnabled end,
	setFovCircle = function(v) fovCircleEnabled = v end,
	getWallCheck = function() return WallCheckEnabled end,
	setWallCheck = function(v) WallCheckEnabled = v end,
	getEsp = function() return espEnabled end,
	setEsp = function(v) espEnabled = v end,
	getCharms = function() return charmsEnabled end,
	setCharms = function(v) charmsEnabled = v end,
	getInfiniteJump = function() return infiniteJumpEnabled end,
	setInfiniteJump = function(v) infiniteJumpEnabled = v end,
	getNoclip = function() return noclipConnection ~= nil end,
	setNoclip = function(v)
		if v then
			noclipConnection = RunService.Stepped:Connect(function()
				if LocalPlayer.Character then
					for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
						if part:IsA("BasePart") then part.CanCollide = false end
					end
				end
			end)
		else
			if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
			if LocalPlayer.Character then
				for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = true end
				end
			end
		end
	end,
	getBunnyHop = function() return bunnyHopEnabled end,
	setBunnyHop = function(v)
		bunnyHopEnabled = v
		if v then
			bunnyHopConnection = RunService.RenderStepped:Connect(function()
				local char = LocalPlayer.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					hum.WalkSpeed = 100; hum.JumpPower = 35
					if hum.FloorMaterial ~= Enum.Material.Air then hum:ChangeState("Jumping") end
				end
			end)
		else
			if bunnyHopConnection then bunnyHopConnection:Disconnect(); bunnyHopConnection = nil end
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
			end
		end
	end,
	getChaos = function() return chaosEnabled end,
	setChaos = function(v) chaosEnabled = v end,
	getThirdPerson = function() return thirdPersonEnabled end,
	setThirdPerson = function(v) thirdPersonEnabled = v end,
	getWallHop = function() return wallHopEnabled end,
	setWallHop = function(v) wallHopEnabled = v end,
	getHitbox = function() return hitboxEnabled end,
	setHitbox = function(v) hitboxEnabled = v end,
	getHitboxPart = function() return hitboxPart end,
	setHitboxPart = function(v) hitboxPart = v end,
	getFullbright = function() return fullbrightEnabled end,
	setFullbright = function(v) fullbrightEnabled = v end,
	getGodMode = function() return godModeEnabled end,
	setGodMode = function(v) godModeEnabled = v end,
	getFpsBoost = function() return fpsBoostEnabled end,
	setFpsBoost = function(v) fpsBoostEnabled = v end,
	getAntiAfk = function() return antiAfkEnabled end,
	setAntiAfk = function(v) antiAfkEnabled = v end,
	getFly = function() return flyEnabled end,
	setFly = function(v) flyEnabled = v end,
	getSpeed = function() return speedHackEnabled end,
	setSpeed = function(v)
		speedHackEnabled = v
		if v then
			speedHackConnection = RunService.RenderStepped:Connect(updateSpeed)
		else
			if speedHackConnection then speedHackConnection:Disconnect(); speedHackConnection = nil end
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
			end
		end
	end,
	getFovChanger = function() return fovChangerEnabled end,
	setFovChanger = function(v)
		fovChangerEnabled = v
		if v then
			fovChangerConnection = RunService.RenderStepped:Connect(updateFOV)
		else
			if fovChangerConnection then fovChangerConnection:Disconnect(); fovChangerConnection = nil end
			if Camera then Camera.FieldOfView = 70 end
		end
	end,
	getInfiniteJumpConn = function() return infiniteJumpConnection end,
	setInfiniteJumpConn = function(v) infiniteJumpConnection = v end,
}
end

return init
