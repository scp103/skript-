--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]

pcall(function() setclipboard("HELLO BRO WHY USE CHEAT?") end)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- === ScreenGui ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WatermarkGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

-- === Watermark ===
local watermark = Instance.new("TextLabel")
watermark.Parent = screenGui
watermark.BackgroundTransparency = 1
watermark.Size = UDim2.new(0, 300, 0, 25)
watermark.Position = UDim2.new(0.01, 0, 0.01, 0)
watermark.Font = Enum.Font.GothamBold
watermark.TextSize = 12
watermark.TextColor3 = Color3.fromRGB(255,255,255)
watermark.TextStrokeTransparency = 0.5
watermark.TextXAlignment = Enum.TextXAlignment.Left
watermark.TextYAlignment = Enum.TextYAlignment.Top

-- === Координати ===
local coordsLabel = Instance.new("TextLabel")
coordsLabel.Parent = screenGui
coordsLabel.BackgroundTransparency = 1
coordsLabel.Size = UDim2.new(0, 200, 0, 25)
coordsLabel.Position = UDim2.new(0.01, 0, 0.15, 0)
coordsLabel.Font = Enum.Font.GothamBold
coordsLabel.TextSize = 12
coordsLabel.TextColor3 = Color3.fromRGB(255,255,255)
coordsLabel.TextStrokeTransparency = 0.5
coordsLabel.TextXAlignment = Enum.TextXAlignment.Left
coordsLabel.TextYAlignment = Enum.TextYAlignment.Top
coordsLabel.Text = "Coords: (0,0)"

-- === Кружок ===
local circle = Instance.new("Frame")
circle.Parent = screenGui
circle.Size = UDim2.new(0, 25, 0, 25)
circle.Position = UDim2.new(0.5, -12, 0.5, -12)
circle.BackgroundColor3 = Color3.fromRGB(255,0,0)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1,0)
uiCorner.Parent = circle

-- === Drag кружка (сенсор + миша) ===
local dragging = false
local dragStart = Vector2.new()
local circleStart = Vector2.new()

circle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		circleStart = Vector2.new(circle.Position.X.Offset, circle.Position.Y.Offset)
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		circle.Position = UDim2.new(0, circleStart.X + delta.X, 0, circleStart.Y + delta.Y)
		local screenSize = camera.ViewportSize
		local xFromCenter = circle.Position.X.Offset - (screenSize.X/2)
		local yFromCenter = circle.Position.Y.Offset - (screenSize.Y/2)
		coordsLabel.Text = "Coords: ("..math.floor(xFromCenter)..","..math.floor(yFromCenter)..")"
	end
end)

-- === Кнопка ON/OFF ===
local toggleButton = Instance.new("TextButton")
toggleButton.Parent = screenGui
toggleButton.Size = UDim2.new(0,80,0,25)
toggleButton.Position = UDim2.new(0.01,0,0.19,0)
toggleButton.Text = "ON"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 12
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.BackgroundTransparency = 0
toggleButton.BorderSizePixel = 0
local uiCornerBtn = Instance.new("UICorner")
uiCornerBtn.CornerRadius = UDim.new(0,8)
uiCornerBtn.Parent = toggleButton

local uiEnabled = true
toggleButton.MouseButton1Click:Connect(function()
	uiEnabled = not uiEnabled
	watermark.Visible = uiEnabled
	coordsLabel.Visible = uiEnabled
	circle.Visible = uiEnabled
	toggleButton.Text = uiEnabled and "ON" or "OFF"
end)

-- === Дані для watermark ===
local stats = {
	function() return "user: "..player.Name end,
	function() return "ping: "..math.floor(player:GetNetworkPing()*1000).."ms" end,
	function() return "fps: "..math.floor(workspace:GetRealPhysicsFPS()) end,
	function() return "time: "..os.date("%H:%M:%S") end,
	function() 
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		return "humanoid health: "..(hum and math.floor(hum.Health) or "N/A")
	end,
	function()
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		return "position: "..(hrp and "("..math.floor(hrp.Position.X)..","..math.floor(hrp.Position.Y)..","..math.floor(hrp.Position.Z)..")" or "N/A")
	end,
	function() return "game id: "..game.GameId end
}

-- === Переливання кольорів ===
local hue = 0
local hueStep = 0.003
local updateDelay = 0.02

task.spawn(function()
	while true do
		task.wait(updateDelay)
		hue = (hue + hueStep) % 1
		local rainbow = Color3.fromHSV(hue,1,1)

		if uiEnabled then
			watermark.TextColor3 = rainbow
			toggleButton.BackgroundColor3 = rainbow
			circle.BackgroundColor3 = rainbow

			local lines = {}
			for _,f in ipairs(stats) do
				pcall(function() table.insert(lines,f()) end)
			end
			watermark.Text = table.concat(lines," | ")
		end
	end
end)
