-- GUI частина
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CoreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "SmileModMenu"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 99999
screenGui.IgnoreGuiInset = true

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 230)
frame.Position = UDim2.new(0.5, -90, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

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

local hitboxScroll = Instance.new("ScrollingFrame", hitboxSettingsFrame)
hitboxScroll.Size = UDim2.new(1, 0, 1, -65)
hitboxScroll.Position = UDim2.new(0, 0, 0, 35)
hitboxScroll.BackgroundTransparency = 1
hitboxScroll.ScrollBarThickness = 6
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
local configButton = createButton("⚙️ Config", 650)

local flyInputLabel = Instance.new("TextLabel", scrollFrame)
flyInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
flyInputLabel.Position = UDim2.new(0.05, 0, 0, 695)
flyInputLabel.BackgroundTransparency = 1
flyInputLabel.Text = "Fly Speed:"
flyInputLabel.Font = Enum.Font.SourceSansBold
flyInputLabel.TextSize = 14
flyInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local flyInput = Instance.new("TextBox", scrollFrame)
flyInput.Size = UDim2.new(0.45, 0, 0, 25)
flyInput.Position = UDim2.new(0.5, 0, 0, 695)
flyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyInput.TextColor3 = Color3.new(1,1,1)
flyInput.Font = Enum.Font.SourceSans
flyInput.TextSize = 14
flyInput.Text = "50"
local flyInputCorner = Instance.new("UICorner", flyInput)

local flyButton = createButton("Fly: OFF", 725)

local speedInputLabel = Instance.new("TextLabel", scrollFrame)
speedInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
speedInputLabel.Position = UDim2.new(0.05, 0, 0, 765)
speedInputLabel.BackgroundTransparency = 1
speedInputLabel.Text = "Speed:"
speedInputLabel.Font = Enum.Font.SourceSansBold
speedInputLabel.TextSize = 14
speedInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedInput = Instance.new("TextBox", scrollFrame)
speedInput.Size = UDim2.new(0.45, 0, 0, 25)
speedInput.Position = UDim2.new(0.5, 0, 0, 765)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.Font = Enum.Font.SourceSans
speedInput.TextSize = 14
speedInput.Text = "16"
local speedInputCorner = Instance.new("UICorner", speedInput)

local sliderFrame = Instance.new("Frame", scrollFrame)
sliderFrame.Size = UDim2.new(0.9, 0, 0, 15)
sliderFrame.Position = UDim2.new(0.05, 0, 0, 795)
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

local speedButton = createButton("Speed: OFF", 820)

local fovInputLabel = Instance.new("TextLabel", scrollFrame)
fovInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
fovInputLabel.Position = UDim2.new(0.05, 0, 0, 860)
fovInputLabel.BackgroundTransparency = 1
fovInputLabel.Text = "FOV:"
fovInputLabel.Font = Enum.Font.SourceSansBold
fovInputLabel.TextSize = 14
fovInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local fovInput = Instance.new("TextBox", scrollFrame)
fovInput.Size = UDim2.new(0.45, 0, 0, 25)
fovInput.Position = UDim2.new(0.5, 0, 0, 860)
fovInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fovInput.TextColor3 = Color3.new(1,1,1)
fovInput.Font = Enum.Font.SourceSans
fovInput.TextSize = 14
fovInput.Text = "70"
local fovInputCorner = Instance.new("UICorner", fovInput)

local fovSliderFrame = Instance.new("Frame", scrollFrame)
fovSliderFrame.Size = UDim2.new(0.9, 0, 0, 15)
fovSliderFrame.Position = UDim2.new(0.05, 0, 0, 890)
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

local fovButton = createButton("FOV: OFF", 915)

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

-- Config вікно
local configFrame = Instance.new("Frame", screenGui)
configFrame.Size = UDim2.new(0, 230, 0, 370)
configFrame.Position = UDim2.new(0.5, -115, 0.5, -170)
configFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
configFrame.BorderSizePixel = 0
configFrame.Visible = false
configFrame.Active = true
local configFrameCorner = Instance.new("UICorner", configFrame)

local configTitle = Instance.new("TextLabel", configFrame)
configTitle.Size = UDim2.new(1, 0, 0, 30)
configTitle.BackgroundTransparency = 1
configTitle.Text = "⚙️ Config Manager"
configTitle.Font = Enum.Font.SourceSansBold
configTitle.TextSize = 18
configTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

local configBackButton = Instance.new("TextButton", configFrame)
configBackButton.Size = UDim2.new(0.9, 0, 0, 25)
configBackButton.Position = UDim2.new(0.05, 0, 1, -30)
configBackButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
configBackButton.TextColor3 = Color3.new(1,1,1)
configBackButton.Font = Enum.Font.SourceSansBold
configBackButton.TextSize = 14
configBackButton.Text = "← Back"
local configBackButtonCorner = Instance.new("UICorner", configBackButton)

local configNameLabel = Instance.new("TextLabel", configFrame)
configNameLabel.Size = UDim2.new(0.9, 0, 0, 20)
configNameLabel.Position = UDim2.new(0.05, 0, 0, 40)
configNameLabel.BackgroundTransparency = 1
configNameLabel.Text = "Config Name:"
configNameLabel.Font = Enum.Font.SourceSansBold
configNameLabel.TextSize = 14
configNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
configNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local configNameInput = Instance.new("TextBox", configFrame)
configNameInput.Size = UDim2.new(0.9, 0, 0, 35)
configNameInput.Position = UDim2.new(0.05, 0, 0, 62)
configNameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
configNameInput.TextColor3 = Color3.new(1,1,1)
configNameInput.Font = Enum.Font.SourceSans
configNameInput.TextSize = 15
configNameInput.Text = ""
configNameInput.PlaceholderText = "Введи ім'я конфігу..."
local configNameInputCorner = Instance.new("UICorner", configNameInput)

local saveConfigButton = Instance.new("TextButton", configFrame)
saveConfigButton.Size = UDim2.new(0.43, 0, 0, 35)
saveConfigButton.Position = UDim2.new(0.05, 0, 0, 105)
saveConfigButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
saveConfigButton.TextColor3 = Color3.new(1,1,1)
saveConfigButton.Font = Enum.Font.SourceSansBold
saveConfigButton.TextSize = 15
saveConfigButton.Text = "💾 Save"
local saveConfigButtonCorner = Instance.new("UICorner", saveConfigButton)

local loadConfigButton = Instance.new("TextButton", configFrame)
loadConfigButton.Size = UDim2.new(0.43, 0, 0, 35)
loadConfigButton.Position = UDim2.new(0.52, 0, 0, 105)
loadConfigButton.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
loadConfigButton.TextColor3 = Color3.new(1,1,1)
loadConfigButton.Font = Enum.Font.SourceSansBold
loadConfigButton.TextSize = 15
loadConfigButton.Text = "📂 Load"
local loadConfigButtonCorner = Instance.new("UICorner", loadConfigButton)

local configListLabel = Instance.new("TextLabel", configFrame)
configListLabel.Size = UDim2.new(0.9, 0, 0, 20)
configListLabel.Position = UDim2.new(0.05, 0, 0, 150)
configListLabel.BackgroundTransparency = 1
configListLabel.Text = "Saved Configs:"
configListLabel.Font = Enum.Font.SourceSansBold
configListLabel.TextSize = 14
configListLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
configListLabel.TextXAlignment = Enum.TextXAlignment.Left

local configScroll = Instance.new("ScrollingFrame", configFrame)
configScroll.Size = UDim2.new(0.9, 0, 0, 120)
configScroll.Position = UDim2.new(0.05, 0, 0, 165)
configScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
configScroll.BorderSizePixel = 0
configScroll.ScrollBarThickness = 5
configScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local configScrollCorner = Instance.new("UICorner", configScroll)

local deleteConfigButton = Instance.new("TextButton", configFrame)
deleteConfigButton.Size = UDim2.new(0.9, 0, 0, 35)
deleteConfigButton.Position = UDim2.new(0.05, 0, 0, 295)
deleteConfigButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
deleteConfigButton.TextColor3 = Color3.new(1,1,1)
deleteConfigButton.Font = Enum.Font.SourceSansBold
deleteConfigButton.TextSize = 15
deleteConfigButton.Text = "🗑️ Delete Selected"
local deleteConfigButtonCorner = Instance.new("UICorner", deleteConfigButton)

-- Повертаємо всі елементи
return {
	screenGui = screenGui,
	frame = frame,
	titleLabel = titleLabel,
	scrollFrame = scrollFrame,
	aimSettingsFrame = aimSettingsFrame,
	aimSettingsTitle = aimSettingsTitle,
	aimCloseButton = aimCloseButton,
	fovCircleButton = fovCircleButton,
	wallButton = wallButton,
	aimFOVInput = aimFOVInput,
	aimFOVSliderFrame = aimFOVSliderFrame,
	aimFOVSliderButton = aimFOVSliderButton,
	hitboxSettingsFrame = hitboxSettingsFrame,
	hitboxSettingsTitle = hitboxSettingsTitle,
	hitboxHeadButton = hitboxHeadButton,
	hitboxTorsoButton = hitboxTorsoButton,
	hitboxArmsButton = hitboxArmsButton,
	hitboxLegsButton = hitboxLegsButton,
	hitboxSizeInput = hitboxSizeInput,
	hitboxCloseButton = hitboxCloseButton,
	teleportFrame = teleportFrame,
	teleportTitle = teleportTitle,
	teleportScroll = teleportScroll,
	backButton = backButton,
	teleportButton = teleportButton,
	aimButton = aimButton,
	aimSettingsOpenButton = aimSettingsOpenButton,
	espButton = espButton,
	charmsButton = charmsButton,
	infiniteJumpButton = infiniteJumpButton,
	noclipButton = noclipButton,
	bunnyHopButton = bunnyHopButton,
	skyButton = skyButton,
	chaosButton = chaosButton,
	thirdPersonButton = thirdPersonButton,
	wallHopButton = wallHopButton,
	hitboxButton = hitboxButton,
	hitboxSettingsOpenButton = hitboxSettingsOpenButton,
	fullbrightButton = fullbrightButton,
	godModeButton = godModeButton,
	fpsBoostButton = fpsBoostButton,
	antiAfkButton = antiAfkButton,
	configButton = configButton,
	flyInput = flyInput,
	flyButton = flyButton,
	speedInput = speedInput,
	sliderFrame = sliderFrame,
	sliderButton = sliderButton,
	speedButton = speedButton,
	fovInput = fovInput,
	fovSliderFrame = fovSliderFrame,
	fovSliderButton = fovSliderButton,
	fovButton = fovButton,
	minimizeButton = minimizeButton,
	minimizedCircle = minimizedCircle,
	configFrame = configFrame,
	configTitle = configTitle,
	configBackButton = configBackButton,
	configNameInput = configNameInput,
	saveConfigButton = saveConfigButton,
	loadConfigButton = loadConfigButton,
	configScroll = configScroll,
	deleteConfigButton = deleteConfigButton,
}
