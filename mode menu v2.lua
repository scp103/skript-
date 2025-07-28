-- Об'єднане мод-меню (AIM + ESP + Noclip) | Для KRNL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Налаштування
local AimPart = "Head"
local FieldOfView = 30
local Holding = false
local WallCheckEnabled = false
local espEnabled = false
local espObjects = {}

-- GUI
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "SmileModMenu"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 200)
frame.Position = UDim2.new(0.5, -90, 0.6, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎯 Smile Mod Menu"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Кнопка AIM
local aimButton = Instance.new("TextButton", frame)
aimButton.Size = UDim2.new(0.9, 0, 0, 30)
aimButton.Position = UDim2.new(0.05, 0, 0, 40)
aimButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
aimButton.TextColor3 = Color3.new(1,1,1)
aimButton.Font = Enum.Font.SourceSansBold
aimButton.TextSize = 16
aimButton.Text = "AIM: OFF"

-- Кнопка WallCheck
local wallButton = Instance.new("TextButton", frame)
wallButton.Size = UDim2.new(0.9, 0, 0, 30)
wallButton.Position = UDim2.new(0.05, 0, 0, 80)
wallButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
wallButton.TextColor3 = Color3.new(1,1,1)
wallButton.Font = Enum.Font.SourceSansBold
wallButton.TextSize = 16
wallButton.Text = "WallCheck: OFF"

-- Кнопка ESP
local espButton = Instance.new("TextButton", frame)
espButton.Size = UDim2.new(0.9, 0, 0, 30)
espButton.Position = UDim2.new(0.05, 0, 0, 120)
espButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espButton.TextColor3 = Color3.new(1,1,1)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 16
espButton.Text = "ESP: OFF"

-- Кнопка Noclip (додана)
local noclipButton = Instance.new("TextButton", frame)
noclipButton.Size = UDim2.new(0.9, 0, 0, 30)
noclipButton.Position = UDim2.new(0.05, 0, 0, 160)
noclipButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.TextSize = 16
noclipButton.Text = "Noclip: OFF"

-- Анімація кольору заголовка
local hue = 0
RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.5) % 1
	titleLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- Коло FOV
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(0, 255, 0)
circle.Thickness = 1
circle.Radius = FieldOfView
circle.Filled = false
circle.Visible = true

local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Перевірка на видимість
local function IsVisible(part)
	if not WallCheckEnabled then return true end
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	local direction = (part.Position - Camera.CFrame.Position).Unit * 500
	local result = workspace:Raycast(Camera.CFrame.Position, direction, rayParams)
	return not (result and result.Instance and not result.Instance:IsDescendantOf(part.Parent))
end

-- Найближчий гравець
local function GetClosestPlayer()
	local closestPlayer, shortestDistance
	shortestDistance = FieldOfView
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(AimPart) then
			local part = v.Character[AimPart]
			local vector, onScreen = Camera:WorldToViewportPoint(part.Position)
			if onScreen and IsVisible(part) then
				local dist = (Vector2.new(vector.X, vector.Y) - screenCenter).Magnitude
				if dist < shortestDistance then
					closestPlayer, shortestDistance = v, dist
				end
			end
		end
	end
	return closestPlayer
end

-- AIM логіка
RunService.RenderStepped:Connect(function()
	if Holding then
		local target = GetClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild(AimPart) then
			local camPos = Camera.CFrame.Position
			local headPos = target.Character[AimPart].Position
			local lookVector = (headPos - camPos).Unit
			Camera.CFrame = CFrame.new(camPos, camPos + lookVector)
		end
	end
end)

-- Коло оновлення
RunService.RenderStepped:Connect(function()
	local target = GetClosestPlayer()
	if WallCheckEnabled and target and target.Character and target.Character:FindFirstChild(AimPart) then
		local part = target.Character[AimPart]
		circle.Color = IsVisible(part) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	else
		circle.Color = Color3.fromRGB(0, 255, 0)
	end
	circle.Position = screenCenter
end)

-- ESP логіка
local function clearESP()
	for _, esp in pairs(espObjects) do
		for _, obj in pairs(esp) do
			if obj and obj.Remove then obj:Remove() end
		end
	end
	espObjects = {}
end

local function createESP(p)
	if p == LocalPlayer then return end
	local box = Drawing.new("Square")
	box.Thickness = 1
	box.Color = Color3.fromRGB(0, 255, 0)
	box.Filled = false
	box.Transparency = 1
	box.Visible = false

	local name = Drawing.new("Text")
	name.Size = 14
	name.Center = true
	name.Outline = true
	name.Color = Color3.fromRGB(0, 255, 255)
	name.Visible = false

	local health = Drawing.new("Text")
	health.Size = 13
	health.Center = true
	health.Outline = true
	health.Color = Color3.fromRGB(0, 255, 0)
	health.Visible = false

	local distance = Drawing.new("Text")
	distance.Size = 13
	distance.Center = true
	distance.Outline = true
	distance.Color = Color3.fromRGB(255, 255, 0)
	distance.Visible = false

	espObjects[p] = {Box = box, Name = name, Health = health, Distance = distance}
end

for _, p in pairs(game.Players:GetPlayers()) do createESP(p) end
game.Players.PlayerAdded:Connect(createESP)

RunService.RenderStepped:Connect(function()
	if not espEnabled then clearESP() return end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local root = p.Character.HumanoidRootPart
			local head = p.Character.Head
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			local esp = espObjects[p]
			if not esp then createESP(p) esp = espObjects[p] end
			local pos, visible = Camera:WorldToViewportPoint(root.Position)
			if visible then
				local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
				local scale = math.clamp(3000 / dist, 100, 300)
				local width, height = scale / 2, scale

				esp.Box.Size = Vector2.new(width, height)
				esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 1.5)
				esp.Box.Visible = true

				esp.Name.Position = Vector2.new(pos.X, pos.Y - height / 1.5 - 15)
				esp.Name.Text = p.Name
				esp.Name.Visible = true

				esp.Health.Position = Vector2.new(pos.X, pos.Y - height / 1.5)
				esp.Health.Text = "HP: " .. math.floor(hum.Health)
				esp.Health.Visible = true

				esp.Distance.Position = Vector2.new(pos.X, pos.Y + height / 2 + 5)
				esp.Distance.Text = "Dist: " .. math.floor(dist)
				esp.Distance.Visible = true
			else
				for _, v in pairs(esp) do v.Visible = false end
			end
		end
	end
end)

-- AIM кнопка
aimButton.MouseButton1Click:Connect(function()
	Holding = not Holding
	aimButton.Text = Holding and "AIM: ON" or "AIM: OFF"
end)

-- WallCheck кнопка
wallButton.MouseButton1Click:Connect(function()
	WallCheckEnabled = not WallCheckEnabled
	wallButton.Text = WallCheckEnabled and "WallCheck: ON" or "WallCheck: OFF"
end)

-- ESP кнопка
espButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	if not espEnabled then clearESP() end
end)

-- Noclip логіка (оновлено)
local noclipEnabled = false
local noclipConnection

noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipButton.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"

	if noclipEnabled then
		noclipConnection = RunService.Stepped:Connect(function()
			if LocalPlayer.Character then
				for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
		-- Повертаємо колізію назад
		if LocalPlayer.Character then
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)
-- Кнопка "хрестик" згортання (над мод меню)
local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(1, -22, 0, -22) -- трохи зверху справа
minimizeButton.Text = "✕"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minimizeButton.BorderSizePixel = 0
minimizeButton.ZIndex = 10

-- Кнопка кружок для розгортання (зовні меню)
local minimizedCircle = Instance.new("TextButton", screenGui)
minimizedCircle.Size = UDim2.new(0, 30, 0, 30)
minimizedCircle.Position = UDim2.new(0, 300, 0, 200) -- змінюй на потрібне
minimizedCircle.Text = ""
minimizedCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
minimizedCircle.BorderSizePixel = 0
minimizedCircle.Visible = false
minimizedCircle.AutoButtonColor = false
minimizedCircle.ZIndex = 10
minimizedCircle.AnchorPoint = Vector2.new(0.5, 0.5)

local corner = Instance.new("UICorner", minimizedCircle)
corner.CornerRadius = UDim.new(1, 0) -- круг

-- Анімація переливу кольору кружка
task.spawn(function()
	while true do
		if minimizedCircle.Visible then
			local t = tick()
			local r = 0.5 + 0.5 * math.sin(t)
			local g = 0.5 + 0.5 * math.sin(t + 2)
			local b = 0.5 + 0.5 * math.sin(t + 4)
			minimizedCircle.BackgroundColor3 = Color3.new(r, g, b)
		end
		task.wait(0.05)
	end
end)

-- Обробник кліку на хрестик (згортання)
minimizeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	minimizeButton.Visible = false
	minimizedCircle.Visible = true
end)

-- Обробник кліку на кружок (розгортання)
minimizedCircle.MouseButton1Click:Connect(function()
	frame.Visible = true
	minimizeButton.Visible = true
	minimizedCircle.Visible = false
end)
local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

frame.Active = true

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
local UserInputService = game:GetService("UserInputService")

-- Функція drag, яку можна викликати для будь-якого UI-елемента
local function makeDraggable(frame)
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPos = nil

	frame.Active = true

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- Викликаємо для основного меню
makeDraggable(frame)

-- Викликаємо для кружка-згорнутого меню
makeDraggable(minimizedCircle)

-- Логіка drag слайдера
local dragging = false

sliderButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
	end
end)

sliderButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
-- Roblox Speed Hack GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local CoreGui = game:GetService("CoreGui")

-- Remove previous GUI if exists
if CoreGui:FindFirstChild("SpeedHackGUI") then
    CoreGui:FindFirstChild("SpeedHackGUI"):Destroy()
end

-- Create main GUI
local SpeedHackGUI = Instance.new("ScreenGui")
SpeedHackGUI.Name = "SpeedHackGUI"
SpeedHackGUI.ResetOnSpawn = false
SpeedHackGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SpeedHackGUI.Parent = CoreGui

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.5, -150, 0.7, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Selectable = true
MainFrame.Parent = SpeedHackGUI

-- Corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.15, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "SPEED HACK CONTROL"
TitleText.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0.5, -12.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Speed display
local SpeedDisplay = Instance.new("TextLabel")
SpeedDisplay.Name = "SpeedDisplay"
SpeedDisplay.Size = UDim2.new(0.8, 0, 0, 40)
SpeedDisplay.Position = UDim2.new(0.1, 0, 0.2, 0)
SpeedDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SpeedDisplay.TextColor3 = Color3.fromRGB(50, 200, 50)
SpeedDisplay.Text = "CURRENT SPEED: 16"
SpeedDisplay.TextSize = 18
SpeedDisplay.Font = Enum.Font.GothamBold
SpeedDisplay.Parent = MainFrame

local DisplayCorner = Instance.new("UICorner")
DisplayCorner.CornerRadius = UDim.new(0, 6)
DisplayCorner.Parent = SpeedDisplay

-- Slider track
local SliderTrack = Instance.new("Frame")
SliderTrack.Name = "SliderTrack"
SliderTrack.Size = UDim2.new(0.8, 0, 0, 8)
SliderTrack.Position = UDim2.new(0.1, 0, 0.5, 0)
SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = MainFrame

local TrackCorner = Instance.new("UICorner")
TrackCorner.CornerRadius = UDim.new(0, 4)
TrackCorner.Parent = SliderTrack

-- Slider button
local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 24, 0, 24)
SliderButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
SliderButton.Text = ""
SliderButton.ZIndex = 2
SliderButton.Parent = SliderTrack

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(1, 0)
ButtonCorner.Parent = SliderButton

-- Value display
local ValueDisplay = Instance.new("TextLabel")
ValueDisplay.Name = "ValueDisplay"
ValueDisplay.Size = UDim2.new(0.8, 0, 0, 20)
ValueDisplay.Position = UDim2.new(0.1, 0, 0.65, 0)
ValueDisplay.BackgroundTransparency = 1
ValueDisplay.Text = "Drag slider to adjust speed (16-500)"
ValueDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
ValueDisplay.TextSize = 12
ValueDisplay.Font = Enum.Font.Gotham
ValueDisplay.Parent = MainFrame

-- Control buttons
local ApplyButton = Instance.new("TextButton")
ApplyButton.Name = "ApplyButton"
ApplyButton.Size = UDim2.new(0.35, 0, 0, 30)
ApplyButton.Position = UDim2.new(0.1, 0, 0.85, -30)
ApplyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
ApplyButton.TextColor3 = Color3.new(1, 1, 1)
ApplyButton.Text = "APPLY"
ApplyButton.TextSize = 14
ApplyButton.Font = Enum.Font.GothamBold
ApplyButton.Parent = MainFrame

local ResetButton = Instance.new("TextButton")
ResetButton.Name = "ResetButton"
ResetButton.Size = UDim2.new(0.35, 0, 0, 30)
ResetButton.Position = UDim2.new(0.55, 0, 0.85, -30)
ResetButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ResetButton.TextColor3 = Color3.new(1, 1, 1)
ResetButton.Text = "RESET"
ResetButton.TextSize = 14
ResetButton.Font = Enum.Font.GothamBold
ResetButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ApplyButton
ButtonCorner:Clone().Parent = ResetButton

-- Speed variables
local speedHackEnabled = false
local currentSpeed = 16
local minSpeed = 16
local maxSpeed = 500
local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")

-- Update speed display
local function updateSpeedDisplay()
    SpeedDisplay.Text = "CURRENT SPEED: " .. currentSpeed
    ValueDisplay.Text = "Drag slider to adjust speed ("..minSpeed.."-"..maxSpeed..")"
    
    -- Update slider position
    local percentage = (currentSpeed - minSpeed) / (maxSpeed - minSpeed)
    SliderButton.Position = UDim2.new(percentage, -12, 0.5, -12)
end

-- Apply speed to character
local function applySpeed()
    if humanoid then
        humanoid.WalkSpeed = currentSpeed
    end
end

-- Reset to default
local function resetSpeed()
    currentSpeed = 16
    updateSpeedDisplay()
    applySpeed()
end

-- Toggle speed hack
local function toggleSpeedHack()
    speedHackEnabled = not speedHackEnabled
    if speedHackEnabled then
        ApplyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        ApplyButton.Text = "ACTIVE"
    else
        ApplyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        ApplyButton.Text = "APPLY"
    end
    applySpeed()
end

-- Dragging functionality
local dragging = false
local dragInput
local dragStart
local startPos

-- Make GUI draggable
local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                     startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Slider functionality
SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = SliderButton.Position
    end
end)

SliderButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

SliderButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local mouseX = Mouse.X - SliderTrack.AbsolutePosition.X
        local percentage = math.clamp(mouseX / SliderTrack.AbsoluteSize.X, 0, 1)
        currentSpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * percentage)
        
        updateSpeedDisplay()
        
        -- Apply immediately if speed hack is active
        if speedHackEnabled then
            applySpeed()
        end
    end
end)

-- Button functionality
ApplyButton.MouseButton1Click:Connect(toggleSpeedHack)
ResetButton.MouseButton1Click:Connect(resetSpeed)
CloseButton.MouseButton1Click:Connect(function()
    SpeedHackGUI:Destroy()
    resetSpeed()
end)

-- Handle character changes
Player.CharacterAdded:Connect(function(character)
    humanoid = character:WaitForChild("Humanoid")
    applySpeed()
end)

-- Initial setup
updateSpeedDisplay()

-- Smooth opening animation
MainFrame.Size = UDim2.new(0, 300, 0, 0)
MainFrame.Visible = true

local openTween = TweenService:Create(
    MainFrame,
    TweenInfo.new(0.4, Enum.EasingStyle.Quint),
    {Size = UDim2.new(0, 300, 0, 180)}
)
openTween:Play()

-- Initial humanoid check
if humanoid then
    applySpeed()
end

