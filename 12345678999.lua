-- Об'єднане мод-меню | Для KRNL (БЕЗ ДУБЛІВ)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Налаштування
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

-- Таблиця для збереження оригінальних розмірів хітбоксів
local originalHitboxSizes = {}

-- GUI
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "SmileModMenu"
screenGui.ResetOnSpawn = false

-- Основне меню
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 230)
frame.Position = UDim2.new(0.5, -90, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

-- Бічне меню AIM
local aimSettingsFrame = Instance.new("Frame", screenGui)
aimSettingsFrame.Size = UDim2.new(0, 200, 0, 280)
aimSettingsFrame.Position = UDim2.new(0.5, 100, 0.3, 0)
aimSettingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
aimSettingsFrame.BorderSizePixel = 0
aimSettingsFrame.Visible = false
aimSettingsFrame.Active = true

local aimSettingsCorner = Instance.new("UICorner", aimSettingsFrame)
aimSettingsCorner.CornerRadius = UDim.new(0, 12)

local aimSettingsTitle = Instance.new("TextLabel", aimSettingsFrame)
aimSettingsTitle.Size = UDim2.new(1, 0, 0, 30)
aimSettingsTitle.BackgroundTransparency = 1
aimSettingsTitle.Text = "AIM Settings"
aimSettingsTitle.Font = Enum.Font.SourceSansBold
aimSettingsTitle.TextSize = 16
aimSettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

local aimCloseButton = Instance.new("TextButton", aimSettingsFrame)
aimCloseButton.Size = UDim2.new(0.9, 0, 0, 25)
aimCloseButton.Position = UDim2.new(0.05, 0, 1, -30)
aimCloseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimCloseButton.TextColor3 = Color3.new(1,1,1)
aimCloseButton.Font = Enum.Font.SourceSansBold
aimCloseButton.TextSize = 14
aimCloseButton.Text = "Close Menu"
local aimCloseButtonCorner = Instance.new("UICorner", aimCloseButton)

local fovCircleButton = Instance.new("TextButton", aimSettingsFrame)
fovCircleButton.Size = UDim2.new(0.9, 0, 0, 30)
fovCircleButton.Position = UDim2.new(0.05, 0, 0, 40)
fovCircleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovCircleButton.TextColor3 = Color3.new(1,1,1)
fovCircleButton.Font = Enum.Font.SourceSansBold
fovCircleButton.TextSize = 16
fovCircleButton.Text = "FOV Circle: ON"
local fovCircleButtonCorner = Instance.new("UICorner", fovCircleButton)

local wallButton = Instance.new("TextButton", aimSettingsFrame)
wallButton.Size = UDim2.new(0.9, 0, 0, 30)
wallButton.Position = UDim2.new(0.05, 0, 0, 80)
wallButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
wallButton.TextColor3 = Color3.new(1,1,1)
wallButton.Font = Enum.Font.SourceSansBold
wallButton.TextSize = 16
wallButton.Text = "WallCheck: OFF"
local wallButtonCorner = Instance.new("UICorner", wallButton)

local aimFOVInputLabel = Instance.new("TextLabel", aimSettingsFrame)
aimFOVInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
aimFOVInputLabel.Position = UDim2.new(0.05, 0, 0, 120)
aimFOVInputLabel.BackgroundTransparency = 1
aimFOVInputLabel.Text = "Aim FOV:"
aimFOVInputLabel.Font = Enum.Font.SourceSansBold
aimFOVInputLabel.TextSize = 14
aimFOVInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
aimFOVInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local aimFOVInput = Instance.new("TextBox", aimSettingsFrame)
aimFOVInput.Size = UDim2.new(0.45, 0, 0, 25)
aimFOVInput.Position = UDim2.new(0.5, 0, 0, 120)
aimFOVInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
aimFOVInput.TextColor3 = Color3.new(1,1,1)
aimFOVInput.Font = Enum.Font.SourceSans
aimFOVInput.TextSize = 14
aimFOVInput.Text = "60"
local aimFOVInputCorner = Instance.new("UICorner", aimFOVInput)

local aimFOVSliderFrame = Instance.new("Frame", aimSettingsFrame)
aimFOVSliderFrame.Size = UDim2.new(0.9, 0, 0, 15)
aimFOVSliderFrame.Position = UDim2.new(0.05, 0, 0, 150)
aimFOVSliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
aimFOVSliderFrame.BorderSizePixel = 0
local aimFOVSliderCorner = Instance.new("UICorner", aimFOVSliderFrame)

local aimFOVSliderButton = Instance.new("Frame", aimFOVSliderFrame)
aimFOVSliderButton.Size = UDim2.new(0, 20, 0, 20)
aimFOVSliderButton.Position = UDim2.new(0.18, -10, 0, -2.5)
aimFOVSliderButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
aimFOVSliderButton.BorderSizePixel = 0
local aimFOVSliderButtonCorner = Instance.new("UICorner", aimFOVSliderButton)
aimFOVSliderButtonCorner.CornerRadius = UDim.new(1, 0)

-- Hitbox Settings меню (ЗІ СКРОЛОМ!)
local hitboxSettingsFrame = Instance.new("Frame", screenGui)
hitboxSettingsFrame.Size = UDim2.new(0, 200, 0, 350)
hitboxSettingsFrame.Position = UDim2.new(0.5, 100, 0.3, 0)
hitboxSettingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
hitboxSettingsFrame.BorderSizePixel = 0
hitboxSettingsFrame.Visible = false
hitboxSettingsFrame.Active = true
local hitboxSettingsCorner = Instance.new("UICorner", hitboxSettingsFrame)

local hitboxSettingsTitle = Instance.new("TextLabel", hitboxSettingsFrame)
hitboxSettingsTitle.Size = UDim2.new(1, 0, 0, 30)
hitboxSettingsTitle.BackgroundTransparency = 1
hitboxSettingsTitle.Text = "Hitbox Settings"
hitboxSettingsTitle.Font = Enum.Font.SourceSansBold
hitboxSettingsTitle.TextSize = 16
hitboxSettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

-- СКРОЛ для Hitbox Settings
local hitboxScroll = Instance.new("ScrollingFrame", hitboxSettingsFrame)
hitboxScroll.Size = UDim2.new(1, 0, 1, -65)
hitboxScroll.Position = UDim2.new(0, 0, 0, 35)
hitboxScroll.BackgroundTransparency = 1
hitboxScroll.ScrollBarThickness = 6
hitboxScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
hitboxScroll.CanvasSize = UDim2.new(0, 0, 0, 300)

local hitboxHeadButton = Instance.new("TextButton", hitboxScroll)
hitboxHeadButton.Size = UDim2.new(0.9, 0, 0, 40)
hitboxHeadButton.Position = UDim2.new(0.05, 0, 0, 10)
hitboxHeadButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
hitboxHeadButton.TextColor3 = Color3.new(1,1,1)
hitboxHeadButton.Font = Enum.Font.SourceSansBold
hitboxHeadButton.TextSize = 16
hitboxHeadButton.Text = "🎯 Head"
local hitboxHeadButtonCorner = Instance.new("UICorner", hitboxHeadButton)

local hitboxTorsoButton = Instance.new("TextButton", hitboxScroll)
hitboxTorsoButton.Size = UDim2.new(0.9, 0, 0, 40)
hitboxTorsoButton.Position = UDim2.new(0.05, 0, 0, 60)
hitboxTorsoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
hitboxTorsoButton.TextColor3 = Color3.new(1,1,1)
hitboxTorsoButton.Font = Enum.Font.SourceSansBold
hitboxTorsoButton.TextSize = 16
hitboxTorsoButton.Text = "💪 Torso"
local hitboxTorsoButtonCorner = Instance.new("UICorner", hitboxTorsoButton)

local hitboxArmsButton = Instance.new("TextButton", hitboxScroll)
hitboxArmsButton.Size = UDim2.new(0.9, 0, 0, 40)
hitboxArmsButton.Position = UDim2.new(0.05, 0, 0, 110)
hitboxArmsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
hitboxArmsButton.TextColor3 = Color3.new(1,1,1)
hitboxArmsButton.Font = Enum.Font.SourceSansBold
hitboxArmsButton.TextSize = 16
hitboxArmsButton.Text = "👐 Arms"
local hitboxArmsButtonCorner = Instance.new("UICorner", hitboxArmsButton)

local hitboxLegsButton = Instance.new("TextButton", hitboxScroll)
hitboxLegsButton.Size = UDim2.new(0.9, 0, 0, 40)
hitboxLegsButton.Position = UDim2.new(0.05, 0, 0, 160)
hitboxLegsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
hitboxLegsButton.TextColor3 = Color3.new(1,1,1)
hitboxLegsButton.Font = Enum.Font.SourceSansBold
hitboxLegsButton.TextSize = 16
hitboxLegsButton.Text = "🦵 Legs"
local hitboxLegsButtonCorner = Instance.new("UICorner", hitboxLegsButton)

-- Налаштування розміру Hitbox
local hitboxSizeLabel = Instance.new("TextLabel", hitboxScroll)
hitboxSizeLabel.Size = UDim2.new(0.4, 0, 0, 25)
hitboxSizeLabel.Position = UDim2.new(0.05, 0, 0, 210)
hitboxSizeLabel.BackgroundTransparency = 1
hitboxSizeLabel.Text = "Size:"
hitboxSizeLabel.Font = Enum.Font.SourceSansBold
hitboxSizeLabel.TextSize = 14
hitboxSizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxSizeLabel.TextXAlignment = Enum.TextXAlignment.Left

local hitboxSizeInput = Instance.new("TextBox", hitboxScroll)
hitboxSizeInput.Size = UDim2.new(0.45, 0, 0, 25)
hitboxSizeInput.Position = UDim2.new(0.5, 0, 0, 210)
hitboxSizeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hitboxSizeInput.TextColor3 = Color3.new(1,1,1)
hitboxSizeInput.Font = Enum.Font.SourceSans
hitboxSizeInput.TextSize = 14
hitboxSizeInput.Text = "20"
hitboxSizeInput.PlaceholderText = "5-50"
local hitboxSizeInputCorner = Instance.new("UICorner", hitboxSizeInput)

local hitboxCloseButton = Instance.new("TextButton", hitboxSettingsFrame)
hitboxCloseButton.Size = UDim2.new(0.9, 0, 0, 25)
hitboxCloseButton.Position = UDim2.new(0.05, 0, 1, -30)
hitboxCloseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hitboxCloseButton.TextColor3 = Color3.new(1,1,1)
hitboxCloseButton.Font = Enum.Font.SourceSansBold
hitboxCloseButton.TextSize = 14
hitboxCloseButton.Text = "Close Menu"
local hitboxCloseButtonCorner = Instance.new("UICorner", hitboxCloseButton)

-- Телепорт
local teleportFrame = Instance.new("Frame", screenGui)
teleportFrame.Size = UDim2.new(0, 200, 0, 300)
teleportFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
teleportFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
teleportFrame.BorderSizePixel = 0
teleportFrame.Visible = false
teleportFrame.Active = true
local teleportFrameCorner = Instance.new("UICorner", teleportFrame)

local teleportTitle = Instance.new("TextLabel", teleportFrame)
teleportTitle.Size = UDim2.new(1, 0, 0, 30)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Text = "Teleport to players"
teleportTitle.Font = Enum.Font.SourceSansBold
teleportTitle.TextSize = 16
teleportTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

local backButton = Instance.new("TextButton", teleportFrame)
backButton.Size = UDim2.new(0.9, 0, 0, 25)
backButton.Position = UDim2.new(0.05, 0, 1, -30)
backButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
backButton.TextColor3 = Color3.new(1,1,1)
backButton.Font = Enum.Font.SourceSansBold
backButton.TextSize = 14
backButton.Text = "← Back"
local backButtonCorner = Instance.new("UICorner", backButton)

local teleportScroll = Instance.new("ScrollingFrame", teleportFrame)
teleportScroll.Size = UDim2.new(1, 0, 1, -65)
teleportScroll.Position = UDim2.new(0, 0, 0, 35)
teleportScroll.BackgroundTransparency = 1
teleportScroll.ScrollBarThickness = 6
teleportScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

-- ScrollFrame
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, 0, 1, -60)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)

local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Smile Mod Menu"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Функція створення кнопки
local function createButton(text, yPos, parent)
	local btn = Instance.new("TextButton", parent or scrollFrame)
	btn.Size = UDim2.new(0.9, 0, 0, 30)
	btn.Position = UDim2.new(0.05, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.Text = text
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 8)
	return btn
end

local teleportButton = createButton("Teleport", 10)
local aimButton = createButton("AIM: OFF", 50)
aimButton.Size = UDim2.new(0.75, -5, 0, 30)

local aimSettingsOpenButton = Instance.new("TextButton", scrollFrame)
aimSettingsOpenButton.Size = UDim2.new(0.15, -5, 0, 30)
aimSettingsOpenButton.Position = UDim2.new(0.8, 0, 0, 50)
aimSettingsOpenButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
aimSettingsOpenButton.TextColor3 = Color3.new(1,1,1)
aimSettingsOpenButton.Font = Enum.Font.SourceSansBold
aimSettingsOpenButton.TextSize = 18
aimSettingsOpenButton.Text = "+"
local aimSettingsOpenButtonCorner = Instance.new("UICorner", aimSettingsOpenButton)

local espButton = createButton("ESP: OFF", 90)
local charmsButton = createButton("Charms: OFF", 130)
local infiniteJumpButton = createButton("Infinite Jump: OFF", 170)
local noclipButton = createButton("Noclip: OFF", 210)
local bunnyHopButton = createButton("BunnyHop: OFF", 250)
local skyButton = createButton("Sky: Default", 290)
local chaosButton = createButton("Chaos: OFF", 330)
local thirdPersonButton = createButton("Third Person: OFF", 370)
local wallHopButton = createButton("Wall Hop: OFF", 410)

local hitboxButton = createButton("Hitbox: OFF", 450)
hitboxButton.Size = UDim2.new(0.75, -5, 0, 30)

local hitboxSettingsOpenButton = Instance.new("TextButton", scrollFrame)
hitboxSettingsOpenButton.Size = UDim2.new(0.15, -5, 0, 30)
hitboxSettingsOpenButton.Position = UDim2.new(0.8, 0, 0, 450)
hitboxSettingsOpenButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
hitboxSettingsOpenButton.TextColor3 = Color3.new(1,1,1)
hitboxSettingsOpenButton.Font = Enum.Font.SourceSansBold
hitboxSettingsOpenButton.TextSize = 18
hitboxSettingsOpenButton.Text = "+"
local hitboxSettingsOpenButtonCorner = Instance.new("UICorner", hitboxSettingsOpenButton)

local fullbrightButton = createButton("Fullbright: OFF", 490)
local godModeButton = createButton("God Mode: OFF", 530)
local fpsBoostButton = createButton("FPS Boost: OFF", 570)
local antiAfkButton = createButton("Anti AFK: OFF", 610)

-- FLY секція
local flyInputLabel = Instance.new("TextLabel", scrollFrame)
flyInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
flyInputLabel.Position = UDim2.new(0.05, 0, 0, 650)
flyInputLabel.BackgroundTransparency = 1
flyInputLabel.Text = "Fly Speed:"
flyInputLabel.Font = Enum.Font.SourceSansBold
flyInputLabel.TextSize = 14
flyInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local flyInput = Instance.new("TextBox", scrollFrame)
flyInput.Size = UDim2.new(0.45, 0, 0, 25)
flyInput.Position = UDim2.new(0.5, 0, 0, 650)
flyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyInput.TextColor3 = Color3.new(1,1,1)
flyInput.Font = Enum.Font.SourceSans
flyInput.TextSize = 14
flyInput.Text = "50"
flyInput.PlaceholderText = "10-450"

local flyInputCorner = Instance.new("UICorner", flyInput)
flyInputCorner.CornerRadius = UDim.new(0, 6)

local flyButton = createButton("Fly: OFF", 680)

-- Speed секція
local speedInputLabel = Instance.new("TextLabel", scrollFrame)
speedInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
speedInputLabel.Position = UDim2.new(0.05, 0, 0, 720)
speedInputLabel.BackgroundTransparency = 1
speedInputLabel.Text = "Speed:"
speedInputLabel.Font = Enum.Font.SourceSansBold
speedInputLabel.TextSize = 14
speedInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedInput = Instance.new("TextBox", scrollFrame)
speedInput.Size = UDim2.new(0.45, 0, 0, 25)
speedInput.Position = UDim2.new(0.5, 0, 0, 720)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.Font = Enum.Font.SourceSans
speedInput.TextSize = 14
speedInput.Text = "16"
local speedInputCorner = Instance.new("UICorner", speedInput)

local sliderFrame = Instance.new("Frame", scrollFrame)
sliderFrame.Size = UDim2.new(0.9, 0, 0, 15)
sliderFrame.Position = UDim2.new(0.05, 0, 0, 750)
sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sliderFrame.BorderSizePixel = 0
local sliderCorner = Instance.new("UICorner", sliderFrame)

local sliderButton = Instance.new("Frame", sliderFrame)
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0, -2, 0, -2.5)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
sliderButton.BorderSizePixel = 0
local sliderButtonCorner = Instance.new("UICorner", sliderButton)
sliderButtonCorner.CornerRadius = UDim.new(1, 0)

local speedButton = createButton("Speed: OFF", 780)

-- FOV секція
local fovInputLabel = Instance.new("TextLabel", scrollFrame)
fovInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
fovInputLabel.Position = UDim2.new(0.05, 0, 0, 820)
fovInputLabel.BackgroundTransparency = 1
fovInputLabel.Text = "FOV:"
fovInputLabel.Font = Enum.Font.SourceSansBold
fovInputLabel.TextSize = 14
fovInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local fovInput = Instance.new("TextBox", scrollFrame)
fovInput.Size = UDim2.new(0.45, 0, 0, 25)
fovInput.Position = UDim2.new(0.5, 0, 0, 820)
fovInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fovInput.TextColor3 = Color3.new(1,1,1)
fovInput.Font = Enum.Font.SourceSans
fovInput.TextSize = 14
fovInput.Text = "70"
local fovInputCorner = Instance.new("UICorner", fovInput)

local fovSliderFrame = Instance.new("Frame", scrollFrame)
fovSliderFrame.Size = UDim2.new(0.9, 0, 0, 15)
fovSliderFrame.Position = UDim2.new(0.05, 0, 0, 850)
fovSliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fovSliderFrame.BorderSizePixel = 0
local fovSliderCorner = Instance.new("UICorner", fovSliderFrame)

local fovSliderButton = Instance.new("Frame", fovSliderFrame)
fovSliderButton.Size = UDim2.new(0, 20, 0, 20)
fovSliderButton.Position = UDim2.new(0.44, -10, 0, -2.5)
fovSliderButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
fovSliderButton.BorderSizePixel = 0
local fovSliderButtonCorner = Instance.new("UICorner", fovSliderButton)
fovSliderButtonCorner.CornerRadius = UDim.new(1, 0)

local fovButton = createButton("FOV: OFF", 880)

-- Minimize
local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0.9, 0, 0, 25)
minimizeButton.Position = UDim2.new(0.05, 0, 1, -30)
minimizeButton.Text = "Minimize menu"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minimizeButton.BorderSizePixel = 0
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 14
local minimizeButtonCorner = Instance.new("UICorner", minimizeButton)

local minimizedCircle = Instance.new("TextButton", screenGui)
minimizedCircle.Size = UDim2.new(0, 30, 0, 30)
minimizedCircle.Position = UDim2.new(0, 300, 0, 200)
minimizedCircle.Text = ""
minimizedCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
minimizedCircle.BorderSizePixel = 0
minimizedCircle.Visible = false
minimizedCircle.AnchorPoint = Vector2.new(0.5, 0.5)
local corner = Instance.new("UICorner", minimizedCircle)
corner.CornerRadius = UDim.new(1, 0)

-- Змінні
local flyConnection, speedHackConnection, fovChangerConnection, noclipConnection
local bunnyHopConnection, infiniteJumpConnection
local bodyVelocity, bodyAngularVelocity
local lastClickTime = 0
local clickDelay = 0.5

local function canClick()
    local currentTime = tick()
    if currentTime - lastClickTime < clickDelay then return false end
    lastClickTime = currentTime
    return true
end

-- Анімація заголовка
local hue = 0
RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.5) % 1
	titleLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- FOV Circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(0, 255, 0)
circle.Thickness = 1
circle.Radius = FieldOfView
circle.Filled = false
circle.Visible = true
local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Телепорт
local function teleportToPlayer(targetPlayer)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
	   targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
	end
end

local function updateTeleportList()
	for _, child in pairs(teleportScroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
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
			
			playerButton.MouseButton1Click:Connect(function()
				if canClick() then teleportToPlayer(player) end
			end)
			
			yPos = yPos + 35
		end
	end
	teleportScroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- Sky Changer
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
		skyButton.Text = "Sky: Space"
		skyIndex = 2
	else
		if sky then sky:Destroy() end
		skyButton.Text = "Sky: Default"
		skyIndex = 1
	end
end

-- Chaos Mode
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

-- Third Person
local function startThirdPerson()
	LocalPlayer.CameraMode = Enum.CameraMode.Classic
	LocalPlayer.CameraMaxZoomDistance = 128
	LocalPlayer.CameraMinZoomDistance = 0.5
	
	thirdPersonConnection = RunService.RenderStepped:Connect(function()
		LocalPlayer.CameraMode = Enum.CameraMode.Classic
		
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (Camera.CFrame.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			
			-- Якщо камера ДУЖЕ близько (менше 3) - трохи відсуваємо
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
	if thirdPersonConnection then
		thirdPersonConnection:Disconnect()
		thirdPersonConnection = nil
	end
	
	-- Просто відновлюємо налаштування, БЕЗ примусового повернення камери
	LocalPlayer.CameraMode = Enum.CameraMode.Classic
	LocalPlayer.CameraMaxZoomDistance = 128
	LocalPlayer.CameraMinZoomDistance = 0.5
end

-- Wall Hop
local canWallJump = true
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

-- FPS Boost
local savedObjects = {}

local function enableFPSBoost()
	originalTextureQuality = settings():GetService("RenderSettings").QualityLevel
	settings():GetService("RenderSettings").QualityLevel = Enum.QualityLevel.Level01
	
	savedObjects = {}
	
	for _, obj in pairs(workspace:GetDescendants()) do
		local isCharacterPart = obj.Parent and obj.Parent:FindFirstChildOfClass("Humanoid")
		if not isCharacterPart then
			if obj:IsA("Decal") or obj:IsA("Texture") then 
				table.insert(savedObjects, {obj = obj, type = "Transparency", value = obj.Transparency})
				obj.Transparency = 1
			end
			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then 
				table.insert(savedObjects, {obj = obj, type = "Enabled", value = obj.Enabled})
				obj.Enabled = false
			end
			if obj:IsA("MeshPart") then 
				table.insert(savedObjects, {obj = obj, type = "TextureID", value = obj.TextureID})
				obj.TextureID = ""
			end
			if obj:IsA("SpecialMesh") then 
				table.insert(savedObjects, {obj = obj, type = "TextureId", value = obj.TextureId})
				obj.TextureId = ""
			end
		end
	end
	
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	for _, effect in pairs(Lighting:GetChildren()) do
		if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
			table.insert(savedObjects, {obj = effect, type = "Enabled", value = effect.Enabled})
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
	
	-- Повертаємо все збережене
	for _, data in pairs(savedObjects) do
		if data.obj then
			if data.type == "Transparency" then
				data.obj.Transparency = data.value
			elseif data.type == "Enabled" then
				data.obj.Enabled = data.value
			elseif data.type == "TextureID" then
				data.obj.TextureID = data.value
			elseif data.type == "TextureId" then
				data.obj.TextureId = data.value
			end
		end
	end
	
	savedObjects = {}
end

-- Anti AFK
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

-- Fullbright
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

-- ✅ ВИПРАВЛЕНА ФУНКЦІЯ HITBOX (з підтримкою всіх частин тіла!)
local function updateHitboxes()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local targetPart = nil
			
			-- Вибираємо потрібну частину тіла
			if hitboxPart == "Head" then
				targetPart = player.Character:FindFirstChild("Head")
			elseif hitboxPart == "Torso" then
				targetPart = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
			elseif hitboxPart == "Arms" then
				-- Збільшуємо обидві руки
				local leftArm = player.Character:FindFirstChild("Left Arm") or player.Character:FindFirstChild("LeftUpperArm")
				local rightArm = player.Character:FindFirstChild("Right Arm") or player.Character:FindFirstChild("RightUpperArm")
				
				if leftArm then
					if not originalHitboxSizes[player.Name .. "_LeftArm"] then
						originalHitboxSizes[player.Name .. "_LeftArm"] = leftArm.Size
					end
					if hitboxEnabled then
						if leftArm.Size ~= Vector3.new(hitboxSize, hitboxSize, hitboxSize) then
							leftArm.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
							leftArm.Transparency = 0.5
							leftArm.CanCollide = false
						end
					else
						if originalHitboxSizes[player.Name .. "_LeftArm"] and leftArm.Size ~= originalHitboxSizes[player.Name .. "_LeftArm"] then
							leftArm.Size = originalHitboxSizes[player.Name .. "_LeftArm"]
							leftArm.Transparency = 0
						end
					end
				end
				
				if rightArm then
					if not originalHitboxSizes[player.Name .. "_RightArm"] then
						originalHitboxSizes[player.Name .. "_RightArm"] = rightArm.Size
					end
					if hitboxEnabled then
						if rightArm.Size ~= Vector3.new(hitboxSize, hitboxSize, hitboxSize) then
							rightArm.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
							rightArm.Transparency = 0.5
							rightArm.CanCollide = false
						end
					else
						if originalHitboxSizes[player.Name .. "_RightArm"] and rightArm.Size ~= originalHitboxSizes[player.Name .. "_RightArm"] then
							rightArm.Size = originalHitboxSizes[player.Name .. "_RightArm"]
							rightArm.Transparency = 0
						end
					end
				end
				
			elseif hitboxPart == "Legs" then
				-- Збільшуємо обидві ноги
				local leftLeg = player.Character:FindFirstChild("Left Leg") or player.Character:FindFirstChild("LeftUpperLeg")
				local rightLeg = player.Character:FindFirstChild("Right Leg") or player.Character:FindFirstChild("RightUpperLeg")
				
				if leftLeg then
					if not originalHitboxSizes[player.Name .. "_LeftLeg"] then
						originalHitboxSizes[player.Name .. "_LeftLeg"] = leftLeg.Size
					end
					if hitboxEnabled then
						if leftLeg.Size ~= Vector3.new(hitboxSize, hitboxSize, hitboxSize) then
							leftLeg.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
							leftLeg.Transparency = 0.5
							leftLeg.CanCollide = false
						end
					else
						if originalHitboxSizes[player.Name .. "_LeftLeg"] and leftLeg.Size ~= originalHitboxSizes[player.Name .. "_LeftLeg"] then
							leftLeg.Size = originalHitboxSizes[player.Name .. "_LeftLeg"]
							leftLeg.Transparency = 0
						end
					end
				end
				
				if rightLeg then
					if not originalHitboxSizes[player.Name .. "_RightLeg"] then
						originalHitboxSizes[player.Name .. "_RightLeg"] = rightLeg.Size
					end
					if hitboxEnabled then
						if rightLeg.Size ~= Vector3.new(hitboxSize, hitboxSize, hitboxSize) then
							rightLeg.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
							rightLeg.Transparency = 0.5
							rightLeg.CanCollide = false
						end
					else
						if originalHitboxSizes[player.Name .. "_RightLeg"] and rightLeg.Size ~= originalHitboxSizes[player.Name .. "_RightLeg"] then
							rightLeg.Size = originalHitboxSizes[player.Name .. "_RightLeg"]
							rightLeg.Transparency = 0
						end
					end
				end
			end
			
			-- Обробка Head/Torso
			if targetPart and (hitboxPart == "Head" or hitboxPart == "Torso") then
				if not originalHitboxSizes[player.Name .. "_" .. hitboxPart] then
					originalHitboxSizes[player.Name .. "_" .. hitboxPart] = targetPart.Size
				end
				
				if hitboxEnabled then
					if targetPart.Size ~= Vector3.new(hitboxSize, hitboxSize, hitboxSize) then
						targetPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
						targetPart.Transparency = 0.5
						targetPart.CanCollide = false
						targetPart.Massless = true
					end
				else
					if originalHitboxSizes[player.Name .. "_" .. hitboxPart] and targetPart.Size ~= originalHitboxSizes[player.Name .. "_" .. hitboxPart] then
						targetPart.Size = originalHitboxSizes[player.Name .. "_" .. hitboxPart]
						targetPart.Transparency = 0
						targetPart.CanCollide = false
						targetPart.Massless = false
					end
				end
			end
		end
	end
end

-- Функція оновлення кнопок вибору частини тіла
local function updateHitboxPartButtons()
	hitboxHeadButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	hitboxTorsoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	hitboxArmsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	hitboxLegsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	
	if hitboxPart == "Head" then 
		hitboxHeadButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	elseif hitboxPart == "Torso" then 
		hitboxTorsoButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	elseif hitboxPart == "Arms" then 
		hitboxArmsButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	elseif hitboxPart == "Legs" then 
		hitboxLegsButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	end
end

-- God Mode
local function startGodMode()
	godModeConnection = RunService.Heartbeat:Connect(function()
		if LocalPlayer.Character then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
		end
	end)
end

local function stopGodMode()
	if godModeConnection then godModeConnection:Disconnect(); godModeConnection = nil end
end

-- AIM
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
				if dist < shortestDistance then
					closestPlayer, shortestDistance = v, dist
				end
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
end)

RunService.RenderStepped:Connect(function()
	local target = GetClosestPlayer()
	if WallCheckEnabled and target and target.Character and target.Character:FindFirstChild(AimPart) then
		circle.Color = IsVisible(target.Character[AimPart]) and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
	else
		circle.Color = Color3.fromRGB(0,255,0)
	end
	circle.Position = screenCenter
	circle.Visible = fovCircleEnabled
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

-- Charms логіка
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

game.Players.PlayerAdded:Connect(createESP)
game.Players.PlayerRemoving:Connect(removePlayerESP)
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

RunService.RenderStepped:Connect(function()
	if charmsEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and not charmsObjects[p] then createCharms(p) end
		end
	else
		clearCharms()
	end
end)

-- ✅ ОПТИМІЗОВАНЕ оновлення Hitbox (БЕЗ постійних змін = БЕЗ ФРІЗУ!)
local hitboxUpdateTimer = 0
RunService.Heartbeat:Connect(function(dt)
	if hitboxEnabled then
		hitboxUpdateTimer = hitboxUpdateTimer + dt
		-- Оновлюємо РІДШЕ (кожні 0.5 секунди замість кожного кадру)
		if hitboxUpdateTimer >= 0.5 then
			hitboxUpdateTimer = 0
			pcall(updateHitboxes)
		end
	end
end)

-- Fly функції
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

-- Speed/FOV functions
local function updateSpeed()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = currentSpeed
	end
end

local function updateSlider()
	local percentage = (currentSpeed-16)/(400-16)
	sliderButton.Position = UDim2.new(percentage,-10,0,-2.5)
	speedInput.Text = tostring(currentSpeed)
end

local function updateFOV()
	if Camera then Camera.FieldOfView = currentFOV end
end

local function updateFOVSlider()
	local percentage = (currentFOV-30)/(120-30)
	fovSliderButton.Position = UDim2.new(percentage,-10,0,-2.5)
	fovInput.Text = tostring(currentFOV)
end

local function updateAimFOVSlider()
	local percentage = (FieldOfView-30)/(200-30)
	aimFOVSliderButton.Position = UDim2.new(percentage,-10,0,-2.5)
	aimFOVInput.Text = tostring(FieldOfView)
	circle.Radius = FieldOfView
end

-- Sliders
local draggingSlider, draggingFOVSlider, draggingAimFOVSlider = false, false, false

local function handleSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sliderPos = sliderFrame.AbsolutePosition
	local sliderSize = sliderFrame.AbsoluteSize
	if mouse.X >= sliderPos.X and mouse.X <= sliderPos.X+sliderSize.X then
		local relativeX = math.clamp(mouse.X-sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX/sliderSize.X
		currentSpeed = math.floor(16+(400-16)*percentage+0.5)
		currentSpeed = math.clamp(currentSpeed, 16, 400)
		updateSlider()
		if speedHackEnabled then updateSpeed() end
	end
end

local function handleFOVSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sliderPos = fovSliderFrame.AbsolutePosition
	local sliderSize = fovSliderFrame.AbsoluteSize
	if mouse.X >= sliderPos.X and mouse.X <= sliderPos.X+sliderSize.X then
		local relativeX = math.clamp(mouse.X-sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX/sliderSize.X
		currentFOV = math.floor(30+(120-30)*percentage+0.5)
		currentFOV = math.clamp(currentFOV, 30, 120)
		updateFOVSlider()
		if fovChangerEnabled then updateFOV() end
	end
end

local function handleAimFOVSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sliderPos = aimFOVSliderFrame.AbsolutePosition
	local sliderSize = aimFOVSliderFrame.AbsoluteSize
	if mouse.X >= sliderPos.X and mouse.X <= sliderPos.X+sliderSize.X then
		local relativeX = math.clamp(mouse.X-sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX/sliderSize.X
		FieldOfView = math.floor(30+(200-30)*percentage+0.5)
		FieldOfView = math.clamp(FieldOfView, 30, 200)
		updateAimFOVSlider()
	end
end

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

aimFOVSliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingAimFOVSlider = true
		handleAimFOVSliderInput()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider, draggingFOVSlider, draggingAimFOVSlider = false, false, false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		handleSliderInput()
	elseif draggingFOVSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		handleFOVSliderInput()
	elseif draggingAimFOVSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		handleAimFOVSliderInput()
	end
end)

-- Text inputs
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
	if inputSpeed and inputSpeed >= 10 and inputSpeed <= 450 then
		flySpeed = inputSpeed
	else
		flyInput.Text = tostring(flySpeed)
	end
end)

fovInput.FocusLost:Connect(function()
	local inputFOV = tonumber(fovInput.Text)
	if inputFOV and inputFOV >= 30 and inputFOV <= 120 then
		currentFOV = inputFOV
		updateFOVSlider()
		if fovChangerEnabled then updateFOV() end
	else
		fovInput.Text = tostring(currentFOV)
	end
end)

aimFOVInput.FocusLost:Connect(function()
	local inputFOV = tonumber(aimFOVInput.Text)
	if inputFOV and inputFOV >= 30 and inputFOV <= 200 then
		FieldOfView = inputFOV
		updateAimFOVSlider()
	else
		aimFOVInput.Text = tostring(FieldOfView)
	end
end)

hitboxSizeInput.FocusLost:Connect(function()
	local inputSize = tonumber(hitboxSizeInput.Text)
	if inputSize and inputSize >= 5 and inputSize <= 50 then
		hitboxSize = inputSize
		if hitboxEnabled then updateHitboxes() end
	else
		hitboxSizeInput.Text = tostring(hitboxSize)
	end
end)

-- BUTTONS
teleportButton.MouseButton1Click:Connect(function()
	if canClick() then
		frame.Visible = false
		aimSettingsFrame.Visible = false
		hitboxSettingsFrame.Visible = false
		teleportFrame.Visible = true
		updateTeleportList()
	end
end)

backButton.MouseButton1Click:Connect(function()
	if canClick() then
		teleportFrame.Visible = false
		frame.Visible = true
	end
end)

aimSettingsOpenButton.MouseButton1Click:Connect(function()
	if canClick() then
		aimSettingsFrame.Visible = not aimSettingsFrame.Visible
		hitboxSettingsFrame.Visible = false
	end
end)

aimCloseButton.MouseButton1Click:Connect(function()
	if canClick() then aimSettingsFrame.Visible = false end
end)

aimButton.MouseButton1Click:Connect(function()
	if canClick() then
		Holding = not Holding
		aimButton.Text = Holding and "AIM: ON" or "AIM: OFF"
	end
end)

fovCircleButton.MouseButton1Click:Connect(function()
	if canClick() then
		fovCircleEnabled = not fovCircleEnabled
		fovCircleButton.Text = fovCircleEnabled and "FOV Circle: ON" or "FOV Circle: OFF"
	end
end)

wallButton.MouseButton1Click:Connect(function()
	if canClick() then
		WallCheckEnabled = not WallCheckEnabled
		wallButton.Text = WallCheckEnabled and "WallCheck: ON" or "WallCheck: OFF"
	end
end)

espButton.MouseButton1Click:Connect(function()
	if canClick() then
		espEnabled = not espEnabled
		espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
		if not espEnabled then clearESP() end
	end
end)

charmsButton.MouseButton1Click:Connect(function()
	if canClick() then
		charmsEnabled = not charmsEnabled
		charmsButton.Text = charmsEnabled and "Charms: ON" or "Charms: OFF"
		if not charmsEnabled then clearCharms() end
	end
end)

infiniteJumpButton.MouseButton1Click:Connect(function()
	if canClick() then
		infiniteJumpEnabled = not infiniteJumpEnabled
		infiniteJumpButton.Text = infiniteJumpEnabled and "Infinite Jump: ON" or "Infinite Jump: OFF"
		if infiniteJumpEnabled then
			infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				end
			end)
		else
			if infiniteJumpConnection then infiniteJumpConnection:Disconnect(); infiniteJumpConnection = nil end
		end
	end
end)

noclipButton.MouseButton1Click:Connect(function()
	if canClick() then
		local noclipEnabled = not (noclipConnection ~= nil)
		noclipButton.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
		if noclipEnabled then
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
	end
end)

bunnyHopButton.MouseButton1Click:Connect(function()
	if canClick() then
		bunnyHopEnabled = not bunnyHopEnabled
		bunnyHopButton.Text = bunnyHopEnabled and "BunnyHop: ON" or "BunnyHop: OFF"
		if bunnyHopEnabled then
			bunnyHopConnection = RunService.RenderStepped:Connect(function()
				local char = LocalPlayer.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					hum.WalkSpeed = 100
					hum.JumpPower = 35
					if hum.FloorMaterial ~= Enum.Material.Air then hum:ChangeState("Jumping") end
				end
			end)
		else
			if bunnyHopConnection then bunnyHopConnection:Disconnect(); bunnyHopConnection = nil end
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedHackEnabled and currentSpeed or 16
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
			end
		end
	end
end)

skyButton.MouseButton1Click:Connect(function()
	if canClick() then changeSky() end
end)

chaosButton.MouseButton1Click:Connect(function()
	if canClick() then
		chaosEnabled = not chaosEnabled
		chaosButton.Text = chaosEnabled and "Chaos: ON" or "Chaos: OFF"
		if chaosEnabled then startChaos() else stopChaos() end
	end
end)

-- Кнопка Third Person
thirdPersonButton.MouseButton1Click:Connect(function()
	if canClick() then
		thirdPersonEnabled = not thirdPersonEnabled
		thirdPersonButton.Text = thirdPersonEnabled and "Third Person: ON" or "Third Person: OFF"
		
		if thirdPersonEnabled then
			startThirdPerson()
		else
			stopThirdPerson()
		end
	end
end)

wallHopButton.MouseButton1Click:Connect(function()
	if canClick() then
		wallHopEnabled = not wallHopEnabled
		wallHopButton.Text = wallHopEnabled and "Wall Hop: ON" or "Wall Hop: OFF"
		if wallHopEnabled then startWallHop() else stopWallHop() end
	end
end)

flyButton.MouseButton1Click:Connect(function()
	if canClick() then
		flyEnabled = not flyEnabled
		flyButton.Text = flyEnabled and "Fly: ON" or "Fly: OFF"

		if flyEnabled then
			startFly()
		else
			stopFly()
		end
	end
end)

speedButton.MouseButton1Click:Connect(function()
	if canClick() then
		speedHackEnabled = not speedHackEnabled
		speedButton.Text = speedHackEnabled and "Speed: ON" or "Speed: OFF"
		if speedHackEnabled then
			speedHackConnection = RunService.RenderStepped:Connect(updateSpeed)
		else
			if speedHackConnection then speedHackConnection:Disconnect(); speedHackConnection = nil end
			if not bunnyHopEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
			end
		end
	end
end)

fovButton.MouseButton1Click:Connect(function()
	if canClick() then
		fovChangerEnabled = not fovChangerEnabled
		fovButton.Text = fovChangerEnabled and "FOV: ON" or "FOV: OFF"
		if fovChangerEnabled then
			fovChangerConnection = RunService.RenderStepped:Connect(updateFOV)
		else
			if fovChangerConnection then fovChangerConnection:Disconnect(); fovChangerConnection = nil end
			if Camera then Camera.FieldOfView = 70 end
		end
	end
end)

hitboxButton.MouseButton1Click:Connect(function()
	if canClick() then
		hitboxEnabled = not hitboxEnabled
		hitboxButton.Text = hitboxEnabled and "Hitbox: ON" or "Hitbox: OFF"
		updateHitboxes()
	end
end)

hitboxSettingsOpenButton.MouseButton1Click:Connect(function()
	if canClick() then
		hitboxSettingsFrame.Visible = not hitboxSettingsFrame.Visible
		aimSettingsFrame.Visible = false
	end
end)

hitboxCloseButton.MouseButton1Click:Connect(function()
	if canClick() then hitboxSettingsFrame.Visible = false end
end)

hitboxHeadButton.MouseButton1Click:Connect(function()
	if canClick() then
		hitboxPart = "Head"
		updateHitboxPartButtons()
		if hitboxEnabled then updateHitboxes() end
	end
end)

hitboxTorsoButton.MouseButton1Click:Connect(function()
	if canClick() then
		hitboxPart = "Torso"
		updateHitboxPartButtons()
		if hitboxEnabled then updateHitboxes() end
	end
end)

hitboxArmsButton.MouseButton1Click:Connect(function()
	if canClick() then
		hitboxPart = "Arms"
		updateHitboxPartButtons()
		if hitboxEnabled then updateHitboxes() end
	end
end)

hitboxLegsButton.MouseButton1Click:Connect(function()
	if canClick() then
		hitboxPart = "Legs"
		updateHitboxPartButtons()
		if hitboxEnabled then updateHitboxes() end
	end
end)

fullbrightButton.MouseButton1Click:Connect(function()
	if canClick() then
		fullbrightEnabled = not fullbrightEnabled
		fullbrightButton.Text = fullbrightEnabled and "Fullbright: ON" or "Fullbright: OFF"
		if fullbrightEnabled then enableFullbright() else disableFullbright() end
	end
end)

godModeButton.MouseButton1Click:Connect(function()
	if canClick() then
		godModeEnabled = not godModeEnabled
		godModeButton.Text = godModeEnabled and "God Mode: ON" or "God Mode: OFF"
		if godModeEnabled then startGodMode() else stopGodMode() end
	end
end)

fpsBoostButton.MouseButton1Click:Connect(function()
	if canClick() then
		fpsBoostEnabled = not fpsBoostEnabled
		fpsBoostButton.Text = fpsBoostEnabled and "FPS Boost: ON" or "FPS Boost: OFF"
		if fpsBoostEnabled then enableFPSBoost() else disableFPSBoost() end
	end
end)

antiAfkButton.MouseButton1Click:Connect(function()
	if canClick() then
		antiAfkEnabled = not antiAfkEnabled
		antiAfkButton.Text = antiAfkEnabled and "Anti AFK: ON" or "Anti AFK: OFF"
		if antiAfkEnabled then startAntiAFK() else stopAntiAFK() end
	end
end)

-- Init
updateSlider()
updateFOVSlider()
updateAimFOVSlider()

-- Circle animation
task.spawn(function()
	while true do
		if minimizedCircle.Visible then
			local t = tick()
			minimizedCircle.BackgroundColor3 = Color3.new(
				0.5 + 0.5 * math.sin(t),
				0.5 + 0.5 * math.sin(t + 2),
				0.5 + 0.5 * math.sin(t + 4)
			)
		end
		task.wait(0.05)
	end
end)

-- Minimize
minimizeButton.MouseButton1Click:Connect(function()
	if canClick() then
		frame.Visible = false
		teleportFrame.Visible = false
		aimSettingsFrame.Visible = false
		hitboxSettingsFrame.Visible = false
		minimizedCircle.Visible = true
	end
end)

minimizedCircle.MouseButton1Click:Connect(function()
	if canClick() then
		frame.Visible = true
		minimizedCircle.Visible = false
	end
end)

-- Drag (ОПТИМІЗОВАНИЙ БЕЗ ДУБЛІВ!)
local function makeDraggable(frame, dragHandle)
	local dragging, dragStart, startPos = false, nil, nil
	local handle = dragHandle or frame
	
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if not draggingSlider and not draggingFOVSlider and not draggingAimFOVSlider then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position
			end
		end
	end)
	
	handle.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	handle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDraggable(frame, titleLabel)
makeDraggable(teleportFrame, teleportTitle)
makeDraggable(minimizedCircle)
makeDraggable(aimSettingsFrame, aimSettingsTitle)
makeDraggable(hitboxSettingsFrame, hitboxSettingsTitle)

-- ✅ ПОВІДОМЛЕННЯ З DISCORD ЛОГО
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "😊 Smile Mod Menu";
	Text = "Successfully loaded!";
	Duration = 1;
	Icon = "rbxassetid://6031094678";
})

task.wait(1)

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "💬 Discord Server";
	Text = "discord.gg/2M8g79zkk";
	Duration = 5;
	Icon = "rbxassetid://6031094678";
})

print("✅ Smile Mod Menu завантажено! (skript loaded)")
