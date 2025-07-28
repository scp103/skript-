-- Smile Mod Menu v2 (AIM + ESP + Noclip + Speed Hack)
-- Автор: твій скрипт, без змін

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local UI = {}

local function createUI(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props) do
        inst[i] = v
    end
    return inst
end

-- UI setup
local screenGui = createUI("ScreenGui", {
    Name = "SmileModMenu",
    ResetOnSpawn = false,
    Parent = game.CoreGui
})

local frame = createUI("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 200, 0, 350),
    Position = UDim2.new(0, 20, 0.5, -175),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Parent = screenGui
})

UI.contentFrame = createUI("Frame", {
    Name = "Content",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Parent = frame
})

local layout = createUI("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = UI.contentFrame
})

-- AIM Toggle
local aimButton = createUI("TextButton", {
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(65, 65, 65),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    Font = Enum.Font.Gotham,
    Text = "AIM: OFF",
    Parent = UI.contentFrame
})

local aimEnabled = false

aimButton.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimButton.Text = aimEnabled and "AIM: ON" or "AIM: OFF"
    aimButton.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(65, 65, 65)
end)

-- ESP Toggle
local espButton = createUI("TextButton", {
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(65, 65, 65),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    Font = Enum.Font.Gotham,
    Text = "ESP: OFF",
    Parent = UI.contentFrame
})

local espEnabled = false

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(65, 65, 65)
end)

-- Noclip Toggle
local noclipButton = createUI("TextButton", {
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(65, 65, 65),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    Font = Enum.Font.Gotham,
    Text = "NOCLIP: OFF",
    Parent = UI.contentFrame
})

local noclipEnabled = false

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "NOCLIP: ON" or "NOCLIP: OFF"
    noclipButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(65, 65, 65)
end)

-- SPEED HACK MODULE (додано без зміни стилю)
do
    UI.speedHackFrame = createUI("Frame", {
        Name = "SpeedHackFrame",
        Size = UDim2.new(1, 0, 0, 84),
        BackgroundTransparency = 1,
        Active = true,
        Selectable = true,
    })
    UI.speedHackFrame.LayoutOrder = 10
    UI.speedHackFrame.Parent = UI.contentFrame

    UI.speedHackButton = createUI("TextButton", {
        Size = UDim2.new(0.9, 0, 0, 40),
        Position = UDim2.new(0.05, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(65,65,65),
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Text = "SPEED: 50 (OFF)",
    })
    UI.speedHackButton.Parent = UI.speedHackFrame

    UI.speedInput = createUI("TextBox", {
        Size = UDim2.new(0.9, 0, 0, 30),
        Position = UDim2.new(0.05, 0, 0, 45),
        BackgroundColor3 = Color3.fromRGB(50,50,50),
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        PlaceholderText = "Enter speed (16-500)",
        Text = "50",
        Visible = false,
    })
    UI.speedInput.Parent = UI.speedHackFrame

    local speedEnabled = false
    local currentSpeed = 50
    local player = game.Players.LocalPlayer
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

    local function updateSpeed()
        if humanoid then
            humanoid.WalkSpeed = speedEnabled and currentSpeed or 16
        end
        UI.speedHackButton.Text = "SPEED: "..currentSpeed..(speedEnabled and " (ON)" or " (OFF)")
    end

    UI.speedHackButton.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        UI.speedHackButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(0,120,0) or Color3.fromRGB(65,65,65)
        updateSpeed()
    end)

    UI.speedHackButton.MouseButton2Click:Connect(function()
        UI.speedInput.Visible = not UI.speedInput.Visible
        if UI.speedInput.Visible then
            UI.speedInput:CaptureFocus()
        end
    end)

    UI.speedInput.FocusLost:Connect(function(enterPressed)
        local newSpeed = tonumber(UI.speedInput.Text)
        if newSpeed and newSpeed >= 16 and newSpeed <= 500 then
            currentSpeed = newSpeed
            if speedEnabled then updateSpeed() else updateSpeed() end
        else
            UI.speedInput.Text = tostring(currentSpeed)
        end
    end)

    player.CharacterAdded:Connect(function(character)
        humanoid = character:WaitForChild("Humanoid")
        updateSpeed()
    end)

    if player.Character then
        humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        updateSpeed()
    end
end
