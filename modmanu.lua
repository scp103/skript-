-- Smile Mod Menu v3 (ESP + AIM + Noclip + Speed Hack)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Створення UI
local function createUI(class, props)
    local inst = Instance.new(class)
    for i,v in pairs(props) do
        inst[i] = v
    end
    return inst
end

local ScreenGui = createUI("ScreenGui", {Name = "SmileModMenu", ResetOnSpawn = false, Parent = player:WaitForChild("PlayerGui")})
local frame = createUI("Frame", {
    Size = UDim2.new(0, 200, 0, 300),
    Position = UDim2.new(0, 20, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(35,35,35),
    BorderSizePixel = 0,
    Parent = ScreenGui
})

local UIListLayout = createUI("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = frame
})

-- ESP
local espEnabled = false
local function toggleESP()
    espEnabled = not espEnabled
end

local espButton = createUI("TextButton", {
    Size = UDim2.new(1, -20, 0, 40),
    BackgroundColor3 = Color3.fromRGB(65,65,65),
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    Text = "ESP: OFF",
    Parent = frame
})
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0,120,0) or Color3.fromRGB(65,65,65)
end)

-- AIM
local aimEnabled = false
local function getClosestTarget()
    local closest, shortest = nil, math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, visible = camera:WorldToViewportPoint(plr.Character.Head.Position)
            if visible then
                local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if dist < shortest and dist < 150 then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

local aimButton = createUI("TextButton", {
    Size = UDim2.new(1, -20, 0, 40),
    BackgroundColor3 = Color3.fromRGB(65,65,65),
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    Text = "AIM: OFF",
    Parent = frame
})
aimButton.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimButton.Text = aimEnabled and "AIM: ON" or "AIM: OFF"
    aimButton.BackgroundColor3 = aimEnabled and Color3.fromRGB(0,120,0) or Color3.fromRGB(65,65,65)
end)

RunService.RenderStepped:Connect(function()
    if aimEnabled then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- NoClip
local noclipEnabled = false
local noclipButton = createUI("TextButton", {
    Size = UDim2.new(1, -20, 0, 40),
    BackgroundColor3 = Color3.fromRGB(65,65,65),
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    Text = "NOCLIP: OFF",
    Parent = frame
})
noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "NOCLIP: ON" or "NOCLIP: OFF"
    noclipButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0,120,0) or Color3.fromRGB(65,65,65)
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- SPEED HACK (Додано)
local speedEnabled = false
local currentSpeed = 50
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

local speedButton = createUI("TextButton", {
    Size = UDim2.new(1, -20, 0, 40),
    BackgroundColor3 = Color3.fromRGB(65,65,65),
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    Text = "SPEED HACK: OFF",
    Parent = frame
})

local speedInput = createUI("TextBox", {
    Size = UDim2.new(1, -20, 0, 30),
    BackgroundColor3 = Color3.fromRGB(50,50,50),
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    PlaceholderText = "Enter speed (16-500)",
    Text = tostring(currentSpeed),
    Visible = false,
    Parent = frame
})

local function updateSpeed()
    if humanoid then
        humanoid.WalkSpeed = speedEnabled and currentSpeed or 16
    end
end

speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedButton.Text = speedEnabled and "SPEED HACK: ON" or "SPEED HACK: OFF"
    speedButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(0,120,0) or Color3.fromRGB(65,65,65)
    updateSpeed()
end)

speedButton.MouseButton2Click:Connect(function()
    speedInput.Visible = not speedInput.Visible
    if speedInput.Visible then
        speedInput:CaptureFocus()
    end
end)

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val and val >= 16 and val <= 500 then
        currentSpeed = val
        if speedEnabled then updateSpeed() end
    else
        speedInput.Text = tostring(currentSpeed)
    end
end)

player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    updateSpeed()
end)
