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
-- Speed Hack Module for LogdrinosMenu (add at the end of your script)
do
    -- Debug function for troubleshooting
    local function debugMessage(msg)
        print("[SpeedHack] " .. msg)
        -- Uncomment for in-game notifications:
        -- game:GetService("StarterGui"):SetCore("SendNotification", {
        --     Title = "SpeedHack Debug",
        --     Text = msg,
        --     Duration = 2
        -- })
    end

    -- Add to content frame
    UI.speedHackFrame = createUI("Frame", {
        Name = "SpeedHackFrame",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Active = true,
        Selectable = true,
    })
    UI.speedHackFrame.LayoutOrder = 9  -- Position after jump controls
    UI.speedHackFrame.Parent = UI.contentFrame
    debugMessage("Speed frame created")

    -- Speed Hack Button
    UI.speedHackButton = createUI("TextButton", {
        Size = UDim2.new(0.9, 0, 0, 40),
        Position = UDim2.new(0.05, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(65,65,65),
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Text = "SPEED: OFF",
        AutoButtonColor = false,
        Name = "SpeedHackButton"
    })
    UI.speedHackButton.Parent = UI.speedHackFrame
    debugMessage("Speed button created")

    -- Speed Slider
    UI.speedHackSlider = createUI("Frame", {
        Size = UDim2.new(0.9, 0, 0, 4),
        Position = UDim2.new(0.05, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(80,80,80),
        BorderSizePixel = 0,
        Name = "SpeedSliderTrack"
    })
    UI.speedHackSlider.Parent = UI.speedHackFrame
    createUI("UICorner", {CornerRadius = UDim.new(1, 0), Parent = UI.speedHackSlider})
    debugMessage("Slider track created")

    -- Slider Button
    UI.speedHackSliderButton = createUI("TextButton", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 0, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(200,200,200),
        BorderSizePixel = 0,
        Text = "",
        ZIndex = 2,
        Name = "SpeedSliderButton"
    })
    UI.speedHackSliderButton.Parent = UI.speedHackSlider
    createUI("UICorner", {CornerRadius = UDim.new(1, 0), Parent = UI.speedHackSliderButton})
    debugMessage("Slider button created")

    -- Speed variables
    local speedHackEnabled = false
    local currentSpeed = 16
    local minSpeed = 16
    local maxSpeed = 500
    local humanoid = nil
    local sliderDragging = false
    local sliderInput = nil

    -- Get humanoid safely
    local function getHumanoid()
        if player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then return hum end
        end
        return nil
    end

    -- Update speed display and slider
    local function updateSpeedDisplay()
        if speedHackEnabled then
            UI.speedHackButton.Text = "SPEED: "..currentSpeed
            UI.speedHackButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            UI.speedHackButton.Text = "SPEED: OFF"
            UI.speedHackButton.BackgroundColor3 = Color3.fromRGB(65,65,65)
        end
        
        -- Update slider position
        local percentage = math.clamp((currentSpeed - minSpeed) / (maxSpeed - minSpeed), 0, 1)
        UI.speedHackSliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
        debugMessage("Display updated: "..UI.speedHackButton.Text)
    end

    -- Apply speed to character
    local function applySpeed()
        humanoid = getHumanoid()
        if humanoid then
            local targetSpeed = speedHackEnabled and currentSpeed or 16
            humanoid.WalkSpeed = targetSpeed
            debugMessage("Speed applied: "..targetSpeed)
        else
            debugMessage("Humanoid not found!")
        end
    end

    -- Toggle speed hack
    UI.speedHackButton.MouseButton1Click:Connect(function()
        speedHackEnabled = not speedHackEnabled
        updateSpeedDisplay()
        applySpeed()
        debugMessage("Toggle: "..tostring(speedHackEnabled))
    end)

    -- Slider functionality
    local function handleSliderInput(input)
        if not UI.speedHackSlider or not UI.speedHackSliderButton then 
            debugMessage("Slider elements missing!")
            return 
        end
        
        local sliderPos = UI.speedHackSlider.AbsolutePosition
        local sliderSize = UI.speedHackSlider.AbsoluteSize.X
        local buttonSize = UI.speedHackSliderButton.AbsoluteSize.X
        
        if sliderSize <= 0 then 
            debugMessage("Invalid slider size: "..sliderSize)
            return 
        end
        
        local mouseX = math.clamp(input.Position.X - sliderPos.X, 0, sliderSize)
        local percentage = mouseX / sliderSize
        currentSpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * percentage)
        speedHackEnabled = true
        
        updateSpeedDisplay()
        applySpeed()
        debugMessage("Slider: "..currentSpeed)
    end

    UI.speedHackSliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = true
            sliderInput = input
            handleSliderInput(input)
        end
    end)
    
    UI.speedHackSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = true
            sliderInput = input
            handleSliderInput(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and input == sliderInput then
            handleSliderInput(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and input == sliderInput then
            sliderDragging = false
            sliderInput = nil
        end
    end)

    -- Character handling
    player.CharacterAdded:Connect(function(character)
        debugMessage("New character detected")
        humanoid = character:WaitForChild("Humanoid", 2) or getHumanoid()
        if not humanoid then
            debugMessage("Humanoid not found in new character!")
        end
        applySpeed()
    end)

    -- Initial humanoid detection
    task.spawn(function()
        wait(1)  -- Wait for character to load
        humanoid = getHumanoid()
        if humanoid then
            debugMessage("Initial humanoid found")
            applySpeed()
        else
            debugMessage("No initial humanoid found")
        end
    end)

    -- Initial setup
    updateSpeedDisplay()
    debugMessage("Module initialized")
    
    -- Adjust main frame size
    frame.Size = UDim2.new(0, config.menuWidth, 0, config.menuHeight + 60)
end
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

