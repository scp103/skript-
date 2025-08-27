-- Об'єднане мод-меню (AIM + ESP + Noclip + BunnyHop + Fly + FOV + Sky) | Для KRNL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
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
local flyEnabled = false
local flySpeed = 50
local fovChangerEnabled = false
local currentFOV = 70
local skyIndex = 1 -- 1=дефолт, 2=космос, 3=місяць, 4=сонце
local charmsEnabled = false
local infiniteJumpEnabled = false

-- GUI
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "SmileModMenu"
screenGui.ResetOnSpawn = false

-- Основне меню (висота для 4 кнопок)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 230) -- Збільшив щоб було видно рівно 4 кнопки
frame.Position = UDim2.new(0.5, -90, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Додаємо округлені краї до основного фрейму
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

-- Вікно телепорту (спочатку неvidible)
local teleportFrame = Instance.new("Frame", screenGui)
teleportFrame.Size = UDim2.new(0, 200, 0, 300)
teleportFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
teleportFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
teleportFrame.BorderSizePixel = 0
teleportFrame.Visible = false
teleportFrame.Active = true

local teleportFrameCorner = Instance.new("UICorner", teleportFrame)
teleportFrameCorner.CornerRadius = UDim.new(0, 12)

-- Заголовок телепорту
local teleportTitle = Instance.new("TextLabel", teleportFrame)
teleportTitle.Size = UDim2.new(1, 0, 0, 30)
teleportTitle.Position = UDim2.new(0, 0, 0, 0)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Text = "Teleport to players"
teleportTitle.Font = Enum.Font.SourceSansBold
teleportTitle.TextSize = 16
teleportTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Кнопка "Назад"
local backButton = Instance.new("TextButton", teleportFrame)
backButton.Size = UDim2.new(0.9, 0, 0, 25)
backButton.Position = UDim2.new(0.05, 0, 1, -30)
backButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
backButton.TextColor3 = Color3.new(1,1,1)
backButton.Font = Enum.Font.SourceSansBold
backButton.TextSize = 14
backButton.Text = "← Back"

local backButtonCorner = Instance.new("UICorner", backButton)
backButtonCorner.CornerRadius = UDim.new(0, 6)

-- Скрол для списку гравців
local teleportScroll = Instance.new("ScrollingFrame", teleportFrame)
teleportScroll.Size = UDim2.new(1, 0, 1, -65)
teleportScroll.Position = UDim2.new(0, 0, 0, 35)
teleportScroll.BackgroundTransparency = 1
teleportScroll.ScrollBarThickness = 6
teleportScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
teleportScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
teleportScroll.ScrollingDirection = Enum.ScrollingDirection.Y

-- Додаємо ScrollingFrame для прокрутки основного меню
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, 0, 1, -60)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 630) -- Зменшив щоб не можна було прокручувати забагато
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Smile Mod Menu"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Кнопка Телепорт (ПЕРША)
local teleportButton = Instance.new("TextButton", scrollFrame)
teleportButton.Size = UDim2.new(0.9, 0, 0, 30)
teleportButton.Position = UDim2.new(0.05, 0, 0, 10)
teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportButton.TextColor3 = Color3.new(1,1,1)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 16
teleportButton.Text = "Teleport"

local teleportButtonCorner = Instance.new("UICorner", teleportButton)
teleportButtonCorner.CornerRadius = UDim.new(0, 8)

-- Кнопка AIM
local aimButton = Instance.new("TextButton", scrollFrame)
aimButton.Size = UDim2.new(0.9, 0, 0, 30)
aimButton.Position = UDim2.new(0.05, 0, 0, 50)
aimButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
aimButton.TextColor3 = Color3.new(1,1,1)
aimButton.Font = Enum.Font.SourceSansBold
aimButton.TextSize = 16
aimButton.Text = "AIM: OFF"

local aimButtonCorner = Instance.new("UICorner", aimButton)
aimButtonCorner.CornerRadius = UDim.new(0, 8)

-- Кнопка WallCheck
local wallButton = Instance.new("TextButton", scrollFrame)
wallButton.Size = UDim2.new(0.9, 0, 0, 30)
wallButton.Position = UDim2.new(0.05, 0, 0, 90)
wallButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
wallButton.TextColor3 = Color3.new(1,1,1)
wallButton.Font = Enum.Font.SourceSansBold
wallButton.TextSize = 16
wallButton.Text = "WallCheck: OFF"

local wallButtonCorner = Instance.new("UICorner", wallButton)
wallButtonCorner.CornerRadius = UDim.new(0, 8)

-- Кнопка ESP
local espButton = Instance.new("TextButton", scrollFrame)
espButton.Size = UDim2.new(0.9, 0, 0, 30)
espButton.Position = UDim2.new(0.05, 0, 0, 130)
espButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espButton.TextColor3 = Color3.new(1,1,1)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 16
espButton.Text = "ESP: OFF"

local espButtonCorner = Instance.new("UICorner", espButton)
espButtonCorner.CornerRadius = UDim.new(0, 8)

-- Кнопка Charms
local charmsButton = Instance.new("TextButton", scrollFrame)
charmsButton.Size = UDim2.new(0.9, 0, 0, 30)
charmsButton.Position = UDim2.new(0.05, 0, 0, 170)
charmsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
charmsButton.TextColor3 = Color3.new(1,1,1)
charmsButton.Font = Enum.Font.SourceSansBold
charmsButton.TextSize = 16
charmsButton.Text = "Charms: OFF"

local charmsButtonCorner = Instance.new("UICorner", charmsButton)
charmsButtonCorner.CornerRadius = UDim.new(0, 8)

-- Кнопка Infinite Jump (НОВА)
local infiniteJumpButton = Instance.new("TextButton", scrollFrame)
infiniteJumpButton.Size = UDim2.new(0.9, 0, 0, 30)
infiniteJumpButton.Position = UDim2.new(0.05, 0, 0, 210)
infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
infiniteJumpButton.TextColor3 = Color3.new(1,1,1)
infiniteJumpButton.Font = Enum.Font.SourceSansBold
infiniteJumpButton.TextSize = 16
infiniteJumpButton.Text = "Infinite Jump: OFF"

local infiniteJumpButtonCorner = Instance.new("UICorner", infiniteJumpButton)
infiniteJumpButtonCorner.CornerRadius = UDim.new(0, 8)

-- Кнопка Noclip
local noclipButton = Instance.new("TextButton", scrollFrame)
noclipButton.Size = UDim2.new(0.9, 0, 0, 30)
noclipButton.Position = UDim2.new(0.05, 0, 0, 250)
noclipButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.TextSize = 16
noclipButton.Text = "Noclip: OFF"

local noclipButtonCorner = Instance.new("UICorner", noclipButton)
noclipButtonCorner.CornerRadius = UDim.new(0, 8)

-- Кнопка BunnyHop
local bunnyHopButton = Instance.new("TextButton", scrollFrame)
bunnyHopButton.Size = UDim2.new(0.9, 0, 0, 30)
bunnyHopButton.Position = UDim2.new(0.05, 0, 0, 290)
bunnyHopButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
bunnyHopButton.TextColor3 = Color3.new(1,1,1)
bunnyHopButton.Font = Enum.Font.SourceSansBold
bunnyHopButton.TextSize = 16
bunnyHopButton.Text = "BunnyHop: OFF"

local bunnyHopButtonCorner = Instance.new("UICorner", bunnyHopButton)
bunnyHopButtonCorner.CornerRadius = UDim.new(0, 8)

-- Кнопка Sky Changer
local skyButton = Instance.new("TextButton", scrollFrame)
skyButton.Size = UDim2.new(0.9, 0, 0, 30)
skyButton.Position = UDim2.new(0.05, 0, 0, 330)
skyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
skyButton.TextColor3 = Color3.new(1,1,1)
skyButton.Font = Enum.Font.SourceSansBold
skyButton.TextSize = 16
skyButton.Text = "Sky: Default"

local skyButtonCorner = Instance.new("UICorner", skyButton)
skyButtonCorner.CornerRadius = UDim.new(0, 8)

-- FLY секція (ПРОСТИЙ РЕЖИМ - без кнопок управління)
-- Поле для введення швидкості польоту
local flyInputLabel = Instance.new("TextLabel", scrollFrame)
flyInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
flyInputLabel.Position = UDim2.new(0.05, 0, 0, 370)
flyInputLabel.BackgroundTransparency = 1
flyInputLabel.Text = "Fly Speed:"
flyInputLabel.Font = Enum.Font.SourceSansBold
flyInputLabel.TextSize = 14
flyInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local flyInput = Instance.new("TextBox", scrollFrame)
flyInput.Size = UDim2.new(0.45, 0, 0, 25)
flyInput.Position = UDim2.new(0.5, 0, 0, 370)
flyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyInput.TextColor3 = Color3.new(1,1,1)
flyInput.Font = Enum.Font.SourceSans
flyInput.TextSize = 14
flyInput.Text = "50"
flyInput.PlaceholderText = "10-150"

local flyInputCorner = Instance.new("UICorner", flyInput)
flyInputCorner.CornerRadius = UDim.new(0, 6)

-- Кнопка Fly ON/OFF
local flyButton = Instance.new("TextButton", scrollFrame)
flyButton.Size = UDim2.new(0.9, 0, 0, 30)
flyButton.Position = UDim2.new(0.05, 0, 0, 400)
flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 16
flyButton.Text = "Fly: OFF"

local flyButtonCorner = Instance.new("UICorner", flyButton)
flyButtonCorner.CornerRadius = UDim.new(0, 8)

-- Speed Hack секція
local speedInputLabel = Instance.new("TextLabel", scrollFrame)
speedInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
speedInputLabel.Position = UDim2.new(0.05, 0, 0, 440)
speedInputLabel.BackgroundTransparency = 1
speedInputLabel.Text = "Speed:"
speedInputLabel.Font = Enum.Font.SourceSansBold
speedInputLabel.TextSize = 14
speedInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedInput = Instance.new("TextBox", scrollFrame)
speedInput.Size = UDim2.new(0.45, 0, 0, 25)
speedInput.Position = UDim2.new(0.5, 0, 0, 440)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.Font = Enum.Font.SourceSans
speedInput.TextSize = 14
speedInput.Text = "16"
speedInput.PlaceholderText = "16-400"

local speedInputCorner = Instance.new("UICorner", speedInput)
speedInputCorner.CornerRadius = UDim.new(0, 6)

-- Слайдер для швидкості
local sliderFrame = Instance.new("Frame", scrollFrame)
sliderFrame.Size = UDim2.new(0.9, 0, 0, 15)
sliderFrame.Position = UDim2.new(0.05, 0, 0, 470)
sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sliderFrame.BorderSizePixel = 0

local sliderCorner = Instance.new("UICorner", sliderFrame)
sliderCorner.CornerRadius = UDim.new(0, 8)

local sliderButton = Instance.new("Frame", sliderFrame)
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0, -2, 0, -2.5)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
sliderButton.BorderSizePixel = 0

local sliderButtonCorner = Instance.new("UICorner", sliderButton)
sliderButtonCorner.CornerRadius = UDim.new(1, 0)

-- Кнопка Speed Hack ON/OFF
local speedButton = Instance.new("TextButton", scrollFrame)
speedButton.Size = UDim2.new(0.9, 0, 0, 30)
speedButton.Position = UDim2.new(0.05, 0, 0, 500)
speedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Font = Enum.Font.SourceSansBold
speedButton.TextSize = 16
speedButton.Text = "Speed: OFF"

local speedButtonCorner = Instance.new("UICorner", speedButton)
speedButtonCorner.CornerRadius = UDim.new(0, 8)

-- FOV Changer секція
local fovInputLabel = Instance.new("TextLabel", scrollFrame)
fovInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
fovInputLabel.Position = UDim2.new(0.05, 0, 0, 540)
fovInputLabel.BackgroundTransparency = 1
fovInputLabel.Text = "FOV:"
fovInputLabel.Font = Enum.Font.SourceSansBold
fovInputLabel.TextSize = 14
fovInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local fovInput = Instance.new("TextBox", scrollFrame)
fovInput.Size = UDim2.new(0.45, 0, 0, 25)
fovInput.Position = UDim2.new(0.5, 0, 0, 540)
fovInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fovInput.TextColor3 = Color3.new(1,1,1)
fovInput.Font = Enum.Font.SourceSans
fovInput.TextSize = 14
fovInput.Text = "70"
fovInput.PlaceholderText = "30-120"

local fovInputCorner = Instance.new("UICorner", fovInput)
fovInputCorner.CornerRadius = UDim.new(0, 6)

-- Слайдер для FOV
local fovSliderFrame = Instance.new("Frame", scrollFrame)
fovSliderFrame.Size = UDim2.new(0.9, 0, 0, 15)
fovSliderFrame.Position = UDim2.new(0.05, 0, 0, 570)
fovSliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fovSliderFrame.BorderSizePixel = 0

local fovSliderCorner = Instance.new("UICorner", fovSliderFrame)
fovSliderCorner.CornerRadius = UDim.new(0, 8)

local fovSliderButton = Instance.new("Frame", fovSliderFrame)
fovSliderButton.Size = UDim2.new(0, 20, 0, 20)
fovSliderButton.Position = UDim2.new(0.44, -10, 0, -2.5) -- 70/120*0.66 приблизно
fovSliderButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
fovSliderButton.BorderSizePixel = 0

local fovSliderButtonCorner = Instance.new("UICorner", fovSliderButton)
fovSliderButtonCorner.CornerRadius = UDim.new(1, 0)

-- Кнопка FOV Changer ON/OFF
local fovButton = Instance.new("TextButton", scrollFrame)
fovButton.Size = UDim2.new(0.9, 0, 0, 30)
fovButton.Position = UDim2.new(0.05, 0, 0, 600)
fovButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovButton.TextColor3 = Color3.new(1,1,1)
fovButton.Font = Enum.Font.SourceSansBold
fovButton.TextSize = 16
fovButton.Text = "👁️ FOV: OFF"

local fovButtonCorner = Instance.new("UICorner", fovButton)
fovButtonCorner.CornerRadius = UDim.new(0, 8)

-- Кнопка згортання (знизу)
local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0.9, 0, 0, 25)
minimizeButton.Position = UDim2.new(0.05, 0, 1, -30)
minimizeButton.Text = "Minimize menu"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minimizeButton.BorderSizePixel = 0
minimizeButton.ZIndex = 10
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 14

local minimizeButtonCorner = Instance.new("UICorner", minimizeButton)
minimizeButtonCorner.CornerRadius = UDim.new(0, 8)

-- Кнопка кружок для розгортання
local minimizedCircle = Instance.new("TextButton", screenGui)
minimizedCircle.Size = UDim2.new(0, 30, 0, 30)
minimizedCircle.Position = UDim2.new(0, 300, 0, 200)
minimizedCircle.Text = ""
minimizedCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
minimizedCircle.BorderSizePixel = 0
minimizedCircle.Visible = false
minimizedCircle.AutoButtonColor = false
minimizedCircle.ZIndex = 10
minimizedCircle.AnchorPoint = Vector2.new(0.5, 0.5)

local corner = Instance.new("UICorner", minimizedCircle)
corner.CornerRadius = UDim.new(1, 0)

-- Змінні для системи
local flyConnection
local speedHackConnection
local fovChangerConnection
local noclipConnection
local bunnyHopConnection
local infiniteJumpConnection
local bodyVelocity
local bodyAngularVelocity
local flyUpPressed = false
local flyDownPressed = false

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

-- Функція телепорту до гравця
local function teleportToPlayer(targetPlayer)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
	   targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
	end
end

-- Функція оновлення списку гравців в телепорті
local function updateTeleportList()
	-- Очищаємо старі кнопки
	for _, child in pairs(teleportScroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	local yPos = 5
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local playerButton = Instance.new("TextButton", teleportScroll)
			playerButton.Size = UDim2.new(0.9, 0, 0, 30)
			playerButton.Position = UDim2.new(0.05, 0, 0, yPos)
			playerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			playerButton.TextColor3 = Color3.new(1,1,1)
			playerButton.Font = Enum.Font.SourceSans
			playerButton.TextSize = 14
			playerButton.Text = player.Name
			
			local playerButtonCorner = Instance.new("UICorner", playerButton)
			playerButtonCorner.CornerRadius = UDim.new(0, 6)
			
			-- Обробка кліку (БЕЗ закриття меню)
			playerButton.MouseButton1Click:Connect(function()
				teleportToPlayer(player)
				-- НЕ закриваємо меню телепорту
			end)
			
			yPos = yPos + 35
		end
	end
	
	-- Оновлюємо розмір канваса
	teleportScroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- Sky Changer функція (ТІЛЬКИ ДЕФОЛТ І КОСМОС)
local function changeSky()
	local sky = Lighting:FindFirstChildOfClass("Sky")
	
	if skyIndex == 1 then -- Default -> Space
		if not sky then
			sky = Instance.new("Sky", Lighting)
		end
		sky.SkyboxBk = "rbxassetid://159454299"
		sky.SkyboxDn = "rbxassetid://159454296"
		sky.SkyboxFt = "rbxassetid://159454293"
		sky.SkyboxLf = "rbxassetid://159454286"
		sky.SkyboxRt = "rbxassetid://159454300"
		sky.SkyboxUp = "rbxassetid://159454288"
		skyButton.Text = "Sky: Space"
		skyIndex = 2
	elseif skyIndex == 2 then -- Space -> Default
		if sky then
			sky:Destroy()
		end
		skyButton.Text = "Sky: Default"
		skyIndex = 1
	end
end

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

	local tracer = Drawing.new("Line")
	tracer.Thickness = 1
	tracer.Color = Color3.fromRGB(255, 255, 255)
	tracer.Transparency = 0.8
	tracer.Visible = false

	espObjects[p] = {Box = box, Name = name, Health = health, Distance = distance, Tracer = tracer}
end

-- Charms логіка (зелені підсвічування)
local charmsObjects = {}

local function clearCharms()
	for _, charm in pairs(charmsObjects) do
		if charm and charm.Destroy then charm:Destroy() end
	end
	charmsObjects = {}
end

local function removePlayerCharms(player)
	if charmsObjects[player] then
		if charmsObjects[player].Destroy then charmsObjects[player]:Destroy() end
		charmsObjects[player] = nil
	end
end

local function createCharms(p)
	if p == LocalPlayer then return end
	if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
		local highlight = Instance.new("Highlight")
		highlight.Parent = p.Character
		highlight.FillColor = Color3.fromRGB(0, 255, 0)
		highlight.FillTransparency = 0.5
		highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
		highlight.OutlineTransparency = 0
		charmsObjects[p] = highlight
	end
end

-- Створюємо ESP для всіх гравців
for _, p in pairs(game.Players:GetPlayers()) do createESP(p) end

-- Додаємо ESP коли гравець заходить
game.Players.PlayerAdded:Connect(createESP)

-- Видаляємо ESP коли гравець виходить
game.Players.PlayerRemoving:Connect(removePlayerESP)

-- Видаляємо Charms коли гравець виходить
game.Players.PlayerRemoving:Connect(removePlayerCharms)

RunService.RenderStepped:Connect(function()
	if not espEnabled then 
		for _, esp in pairs(espObjects) do
			for _, obj in pairs(esp) do
				if obj then obj.Visible = false end
			end
		end
		return 
	end
	
	for player, esp in pairs(espObjects) do
		if not Players:FindFirstChild(player.Name) then
			removePlayerESP(player)
		end
	end
	
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local esp = espObjects[p]
			if not esp then 
				createESP(p) 
				esp = espObjects[p] 
			end
			
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
				local root = p.Character.HumanoidRootPart
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				
				if hum.Health > 0 then
					local pos, visible = Camera:WorldToViewportPoint(root.Position)
					if visible and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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

						local screenBottom = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
						esp.Tracer.From = screenBottom
						esp.Tracer.To = Vector2.new(pos.X, pos.Y)
						esp.Tracer.Visible = true
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

-- Charms оновлення
RunService.RenderStepped:Connect(function()
	if charmsEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and not charmsObjects[p] then
				createCharms(p)
			end
		end
	else
		clearCharms()
	end
end)

-- Функції оновлення
local function updateSpeed()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = currentSpeed
	end
end

local function updateSlider()
	local percentage = (currentSpeed - 16) / (400 - 16)
	sliderButton.Position = UDim2.new(percentage, -10, 0, -2.5)
	speedInput.Text = tostring(currentSpeed)
end

local function updateFOV()
	if LocalPlayer.Character and Camera then
		Camera.FieldOfView = currentFOV
	end
end

local function updateFOVSlider()
	local percentage = (currentFOV - 30) / (120 - 30) -- Виправлено діапазон FOV
	fovSliderButton.Position = UDim2.new(percentage, -10, 0, -2.5)
	fovInput.Text = tostring(currentFOV)
end

-- Fly функції (ПРОСТИЙ РЕЖИМ - тиснув і летиш)
local function startFly()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local root = char.HumanoidRootPart
		
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = root
		
		bodyAngularVelocity = Instance.new("BodyAngularVelocity")
		bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
		bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
		bodyAngularVelocity.Parent = root
		
		flyConnection = RunService.RenderStepped:Connect(function()
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") and bodyVelocity then
				local root = char.HumanoidRootPart
				local camera = workspace.CurrentCamera
				local moveVector = Vector3.new(0, 0, 0)
				
				-- Автоматичне керування - летиш у напрямку камери
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					moveVector = moveVector + camera.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					moveVector = moveVector - camera.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					moveVector = moveVector - camera.CFrame.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					moveVector = moveVector + camera.CFrame.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					moveVector = moveVector + Vector3.new(0, 1, 0)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
					moveVector = moveVector + Vector3.new(0, -1, 0)
				end
				
				-- Якщо на телефоні та немає клавіш - просто летиш вперед
				if moveVector.Magnitude == 0 and UserInputService.TouchEnabled then
					moveVector = camera.CFrame.LookVector
				end
				
				if moveVector.Magnitude > 0 then
					bodyVelocity.Velocity = moveVector.Unit * flySpeed
				else
					bodyVelocity.Velocity = Vector3.new(0, 0, 0)
				end
			end
		end)
	end
end

local function stopFly()
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	if bodyAngularVelocity then
		bodyAngularVelocity:Destroy()
		bodyAngularVelocity = nil
	end
end

-- Логіка слайдерів
local function handleSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sliderPos = sliderFrame.AbsolutePosition
	local sliderSize = sliderFrame.AbsoluteSize
	
	if mouse.X >= sliderPos.X and mouse.X <= sliderPos.X + sliderSize.X then
		local relativeX = math.clamp(mouse.X - sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX / sliderSize.X
		currentSpeed = math.floor(16 + (400 - 16) * percentage + 0.5)
		currentSpeed = math.clamp(currentSpeed, 16, 400)
		updateSlider()
		if speedHackEnabled then updateSpeed() end
	end
end

local function handleFOVSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sliderPos = fovSliderFrame.AbsolutePosition
	local sliderSize = fovSliderFrame.AbsoluteSize
	
	if mouse.X >= sliderPos.X and mouse.X <= sliderPos.X + sliderSize.X then
		local relativeX = math.clamp(mouse.X - sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX / sliderSize.X
		currentFOV = math.floor(30 + (120 - 30) * percentage + 0.5) -- Виправлено діапазон
		currentFOV = math.clamp(currentFOV, 30, 120)
		updateFOVSlider()
		if fovChangerEnabled then updateFOV() end
	end
end

-- Слайдери обробка
local draggingSlider = false
local draggingFOVSlider = false

sliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		handleSliderInput()
	end
end)

fovSliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFOVSlider = true
		handleFOVSliderInput()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = false
		draggingFOVSlider = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		handleSliderInput()
	elseif draggingFOVSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		handleFOVSliderInput()
	end
end)

-- Обробка текстових полів
speedInput.FocusLost:Connect(function()
	local inputSpeed = tonumber(speedInput.Text)
	if inputSpeed and inputSpeed >= 16 and inputSpeed <= 400 then
		currentSpeed = inputSpeed
		updateSlider()
		if speedHackEnabled then updateSpeed() end
	else
		speedInput.Text = tostring(currentSpeed)
	end
end)

flyInput.FocusLost:Connect(function()
	local inputSpeed = tonumber(flyInput.Text)
	if inputSpeed and inputSpeed >= 10 and inputSpeed <= 150 then
		flySpeed = inputSpeed
	else
		flyInput.Text = tostring(flySpeed)
	end
end)

fovInput.FocusLost:Connect(function()
	local inputFOV = tonumber(fovInput.Text)
	if inputFOV and inputFOV >= 30 and inputFOV <= 120 then -- Виправлено діапазон
		currentFOV = inputFOV
		updateFOVSlider()
		if fovChangerEnabled then updateFOV() end
	else
		fovInput.Text = tostring(currentFOV)
	end
end)

-- Кнопки керування польотом
-- (ВИДАЛЕНО - тепер просте керування)

-- Кнопки обробка
teleportButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	teleportFrame.Visible = true
	updateTeleportList()
end)

backButton.MouseButton1Click:Connect(function()
	teleportFrame.Visible = false
	frame.Visible = true
end)

aimButton.MouseButton1Click:Connect(function()
	Holding = not Holding
	aimButton.Text = Holding and "AIM: ON" or "AIM: OFF"
end)

wallButton.MouseButton1Click:Connect(function()
	WallCheckEnabled = not WallCheckEnabled
	wallButton.Text = WallCheckEnabled and "WallCheck: ON" or "WallCheck: OFF"
end)

espButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	if not espEnabled then clearESP() end
end)

charmsButton.MouseButton1Click:Connect(function()
	charmsEnabled = not charmsEnabled
	charmsButton.Text = charmsEnabled and "Charms: ON" or "Charms: OFF"
	if not charmsEnabled then clearCharms() end
end)

charmsButton.MouseButton1Click:Connect(function()
	charmsEnabled = not charmsEnabled
	charmsButton.Text = charmsEnabled and "Charms: ON" or "Charms: OFF"
	if not charmsEnabled then clearCharms() end
end)

-- Infinite Jump кнопка (НОВА)
infiniteJumpButton.MouseButton1Click:Connect(function()
	infiniteJumpEnabled = not infiniteJumpEnabled
	infiniteJumpButton.Text = infiniteJumpEnabled and "Infinite Jump: ON" or "Infinite Jump: OFF"

	if infiniteJumpEnabled then
		infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
			end
		end)
	else
		if infiniteJumpConnection then
			infiniteJumpConnection:Disconnect()
			infiniteJumpConnection = nil
		end
	end
end)

noclipButton.MouseButton1Click:Connect(function()
	local noclipEnabled = not (noclipConnection ~= nil)
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
		if LocalPlayer.Character then
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)

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
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedHackEnabled and currentSpeed or 16
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
		end
	end
end)

skyButton.MouseButton1Click:Connect(function()
	changeSky()
end)

flyButton.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyButton.Text = flyEnabled and "Fly: ON" or "Fly: OFF"

	if flyEnabled then
		startFly()
	else
		stopFly()
	end
end)

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
		if not bunnyHopEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
		end
	end
end)

fovButton.MouseButton1Click:Connect(function()
	fovChangerEnabled = not fovChangerEnabled
	fovButton.Text = fovChangerEnabled and "FOV: ON" or "FOV: OFF"

	if fovChangerEnabled then
		fovChangerConnection = RunService.RenderStepped:Connect(function()
			updateFOV()
		end)
	else
		if fovChangerConnection then
			fovChangerConnection:Disconnect()
			fovChangerConnection = nil
		end
		if Camera then
			Camera.FieldOfView = 70 -- Default value
		end
	end
end)

-- Ініціалізація
updateSlider()
updateFOVSlider()

-- Анімація кружка
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

-- Згортання/розгортання
minimizeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	teleportFrame.Visible = false
	minimizedCircle.Visible = true
end)

minimizedCircle.MouseButton1Click:Connect(function()
	frame.Visible = true
	minimizedCircle.Visible = false
end)

-- Драг функція
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

makeDraggable(frame)
makeDraggable(teleportFrame)
makeDraggable(minimizedCircle)
