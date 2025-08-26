-- Об'єднане мод-меню (AIM + ESP + Noclip + BunnyHop) | Для KRNL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Налаштування
local AimPart = "Head"
local FieldOfView = 60
local Holding = false
local WallCheckEnabled = false
local espEnabled = false
local espObjects = {}
local bunnyHopEnabled = false
local speedHackEnabled = false
local currentSpeed = 16

-- GUI
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "SmileModMenu"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 320) -- Збільшив висоту для слайдера
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

-- Кнопка Noclip
local noclipButton = Instance.new("TextButton", frame)
noclipButton.Size = UDim2.new(0.9, 0, 0, 30)
noclipButton.Position = UDim2.new(0.05, 0, 0, 160)
noclipButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.TextSize = 16
noclipButton.Text = "Noclip: OFF"

-- Кнопка BunnyHop (НОВА)
local bunnyHopButton = Instance.new("TextButton", frame)
bunnyHopButton.Size = UDim2.new(0.9, 0, 0, 30)
bunnyHopButton.Position = UDim2.new(0.05, 0, 0, 200)
bunnyHopButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
bunnyHopButton.TextColor3 = Color3.new(1,1,1)
bunnyHopButton.Font = Enum.Font.SourceSansBold
bunnyHopButton.TextSize = 16
bunnyHopButton.Text = "BunnyHop: OFF"

-- Speed Hack секція
-- Поле для введення швидкості
local speedInputLabel = Instance.new("TextLabel", frame)
speedInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
speedInputLabel.Position = UDim2.new(0.05, 0, 0, 240)
speedInputLabel.BackgroundTransparency = 1
speedInputLabel.Text = "Speed:"
speedInputLabel.Font = Enum.Font.SourceSansBold
speedInputLabel.TextSize = 14
speedInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedInput = Instance.new("TextBox", frame)
speedInput.Size = UDim2.new(0.45, 0, 0, 25)
speedInput.Position = UDim2.new(0.5, 0, 0, 240)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.Font = Enum.Font.SourceSans
speedInput.TextSize = 14
speedInput.Text = "16"
speedInput.PlaceholderText = "16-400"

-- Слайдер для швидкості
local sliderFrame = Instance.new("Frame", frame)
sliderFrame.Size = UDim2.new(0.9, 0, 0, 20)
sliderFrame.Position = UDim2.new(0.05, 0, 0, 270)
sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sliderFrame.BorderSizePixel = 0

local sliderButton = Instance.new("TextButton", sliderFrame)
sliderButton.Size = UDim2.new(0, 15, 1, 0)
sliderButton.Position = UDim2.new(0, 0, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0

-- Кнопка Speed Hack ON/OFF
local speedButton = Instance.new("TextButton", frame)
speedButton.Size = UDim2.new(0.9, 0, 0, 25)
speedButton.Position = UDim2.new(0.05, 0, 0, 295)
speedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Font = Enum.Font.SourceSansBold
speedButton.TextSize = 16
speedButton.Text = "Speed: OFF"

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

local function removePlayerESP(player)
	if espObjects[player] then
		for _, obj in pairs(espObjects[player]) do
			if obj and obj.Remove then obj:Remove() end
		end
		espObjects[player] = nil
	end
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

	-- Додаємо трейсер (лінія)
	local tracer = Drawing.new("Line")
	tracer.Thickness = 1
	tracer.Color = Color3.fromRGB(255, 255, 255)
	tracer.Transparency = 0.8
	tracer.Visible = false

	espObjects[p] = {Box = box, Name = name, Health = health, Distance = distance, Tracer = tracer}
end

-- Створюємо ESP для всіх гравців
for _, p in pairs(game.Players:GetPlayers()) do createESP(p) end

-- Додаємо ESP коли гравець заходить
game.Players.PlayerAdded:Connect(createESP)

-- Видаляємо ESP коли гравець виходить
game.Players.PlayerRemoving:Connect(removePlayerESP)

RunService.RenderStepped:Connect(function()
	if not espEnabled then 
		-- Ховаємо всі ESP але не видаляємо
		for _, esp in pairs(espObjects) do
			for _, obj in pairs(esp) do
				if obj then obj.Visible = false end
			end
		end
		return 
	end
	
	-- Перевіряємо які гравці ще в грі і чистимо зайві ESP
	for player, esp in pairs(espObjects) do
		if not Players:FindFirstChild(player.Name) then
			-- Гравець вийшов з гри, видаляємо його ESP
			removePlayerESP(player)
		end
	end
	
	-- Оновлюємо ESP для активних гравців
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local esp = espObjects[p]
			if not esp then 
				createESP(p) 
				esp = espObjects[p] 
			end
			
			-- Перевіряємо чи є характер і чи він живий
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
				local root = p.Character.HumanoidRootPart
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				
				-- Перевіряємо чи гравець живий
				if hum.Health > 0 then
					local pos, visible = Camera:WorldToViewportPoint(root.Position)
					if visible and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
						local scale = math.clamp(3000 / dist, 100, 300)
						local width, height = scale / 2, scale

						-- Оновлюємо бокс
						esp.Box.Size = Vector2.new(width, height)
						esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 1.5)
						esp.Box.Visible = true

						-- Оновлюємо ім'я
						esp.Name.Position = Vector2.new(pos.X, pos.Y - height / 1.5 - 15)
						esp.Name.Text = p.Name
						esp.Name.Visible = true

						-- Оновлюємо здоров'я
						esp.Health.Position = Vector2.new(pos.X, pos.Y - height / 1.5)
						esp.Health.Text = "HP: " .. math.floor(hum.Health)
						esp.Health.Visible = true

						-- Оновлюємо дистанцію
						esp.Distance.Position = Vector2.new(pos.X, pos.Y + height / 2 + 5)
						esp.Distance.Text = "Dist: " .. math.floor(dist)
						esp.Distance.Visible = true

						-- Оновлюємо трейсер (лінія з низу екрану до гравця)
						local screenBottom = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
						esp.Tracer.From = screenBottom
						esp.Tracer.To = Vector2.new(pos.X, pos.Y)
						esp.Tracer.Visible = true
					else
						-- Гравець поза екраном - ховаємо ESP
						for _, v in pairs(esp) do v.Visible = false end
					end
				else
					-- Гравець мертвий - ховаємо ESP
					for _, v in pairs(esp) do v.Visible = false end
				end
			else
				-- Немає характера або він респавниться - ховаємо ESP
				for _, v in pairs(esp) do v.Visible = false end
			end
		end
	end
end)

-- BunnyHop логіка (НОВА)
local bunnyHopConnection

-- Speed Hack логіка
local speedHackConnection

-- Функція оновлення швидкості
local function updateSpeed()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = currentSpeed
	end
end

-- Функція оновлення слайдера
local function updateSlider()
	local percentage = (currentSpeed - 16) / (400 - 16)
	sliderButton.Position = UDim2.new(percentage, -7, 0, 0)
	speedInput.Text = tostring(currentSpeed)
end

-- Слайдер логіка
local dragging = false
UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local mousePos = UserInputService:GetMouseLocation()
		local sliderPos = sliderFrame.AbsolutePosition
		local sliderSize = sliderFrame.AbsoluteSize
		
		if mousePos.X >= sliderPos.X and mousePos.X <= sliderPos.X + sliderSize.X and
		   mousePos.Y >= sliderPos.Y and mousePos.Y <= sliderPos.Y + sliderSize.Y then
			dragging = true
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local mousePos = UserInputService:GetMouseLocation()
		local sliderPos = sliderFrame.AbsolutePosition
		local sliderSize = sliderFrame.AbsoluteSize
		
		local relativeX = mousePos.X - sliderPos.X
		local percentage = math.clamp(relativeX / sliderSize.X, 0, 1)
		
		currentSpeed = math.floor(16 + (400 - 16) * percentage)
		updateSlider()
		
		if speedHackEnabled then
			updateSpeed()
		end
	end
end)

-- Обробка введення в текстове поле
speedInput.FocusLost:Connect(function()
	local inputSpeed = tonumber(speedInput.Text)
	if inputSpeed and inputSpeed >= 16 and inputSpeed <= 400 then
		currentSpeed = inputSpeed
		updateSlider()
		if speedHackEnabled then
			updateSpeed()
		end
	else
		speedInput.Text = tostring(currentSpeed)
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

-- Noclip логіка
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

-- BunnyHop кнопка (НОВА)
bunnyHopButton.MouseButton1Click:Connect(function()
	bunnyHopEnabled = not bunnyHopEnabled
	bunnyHopButton.Text = bunnyHopEnabled and "BunnyHop: ON" or "BunnyHop: OFF"

	if bunnyHopEnabled then
		bunnyHopConnection = RunService.RenderStepped:Connect(function()
			local char = LocalPlayer.Character
			if char and char:FindFirstChildOfClass("Humanoid") then
				local hum = char:FindFirstChildOfClass("Humanoid")
				hum.WalkSpeed = 100
				hum.JumpPower = 35
				if hum.FloorMaterial ~= Enum.Material.Air then
					hum:ChangeState("Jumping")
				end
			end
		end)
	else
		if bunnyHopConnection then
			bunnyHopConnection:Disconnect()
			bunnyHopConnection = nil
		end
		-- Повертаємо звичайну швидкість
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedHackEnabled and currentSpeed or 16
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
		end
	end
end)

-- Speed Hack кнопка (НОВА)
speedButton.MouseButton1Click:Connect(function()
	speedHackEnabled = not speedHackEnabled
	speedButton.Text = speedHackEnabled and "Speed: ON" or "Speed: OFF"

	if speedHackEnabled then
		speedHackConnection = RunService.RenderStepped:Connect(function()
			updateSpeed()
		end)
	else
		if speedHackConnection then
			speedHackConnection:Disconnect()
			speedHackConnection = nil
		end
		-- Повертаємо звичайну швидкість якщо BunnyHop не активний
		if not bunnyHopEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
		end
	end
end)

-- Ініціалізуємо слайдер
updateSlider()

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
