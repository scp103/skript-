-- Key System with memory | For mobile
-- Author: Smile Script | Ukraine 🇺🇦

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Check if already running
if LocalPlayer.PlayerGui:FindFirstChild("KeySystemGUI") then
	warn("⚠️ Key System already running!")
	return
end

-- SETTINGS
local userKey = "226622"
local adminKey = "murko2020"
local discordLink = "https://discord.gg/gGnZgTvQY"
local scriptUrl = "https://raw.githubusercontent.com/scp103/skript-/main/mode%20menu%20v2.lua"

-- Variables
local keyAccepted = false
local isAdmin = false
local attempts = 0
local maxAttempts = 5
local savedKeyFile = "SmileKeySystem_" .. LocalPlayer.UserId .. ".txt"

-- Functions for saving/loading keys
local function saveKey(key)
	if writefile then
		writefile(savedKeyFile, key)
	end
end

local function loadSavedKey()
	if isfile and readfile and isfile(savedKeyFile) then
		return readfile(savedKeyFile)
	end
	return nil
end

local function clearSavedKey()
	if delfile and isfile and isfile(savedKeyFile) then
		delfile(savedKeyFile)
	end
end

-- Check if there is a saved key
local savedKey = loadSavedKey()
local autoLoaded = false

-- GUI creation
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "KeySystemGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Background blur
local backgroundBlur = Instance.new("Frame", screenGui)
backgroundBlur.Size = UDim2.new(1, 0, 1, 0)
backgroundBlur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backgroundBlur.BackgroundTransparency = 0.3
backgroundBlur.BorderSizePixel = 0
backgroundBlur.ZIndex = 1
backgroundBlur.Visible = true

-- Main key window
local keyFrame = Instance.new("Frame", screenGui)
keyFrame.Size = UDim2.new(0, 340, 0, 410)
keyFrame.Position = UDim2.new(0.5, -170, 0.5, -205)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
keyFrame.BorderSizePixel = 0
keyFrame.Active = true
keyFrame.ZIndex = 2
keyFrame.Visible = true

local keyFrameCorner = Instance.new("UICorner", keyFrame)
keyFrameCorner.CornerRadius = UDim.new(0, 18)

-- Close X button
local closeKeyButton = Instance.new("TextButton", keyFrame)
closeKeyButton.Size = UDim2.new(0, 30, 0, 30)
closeKeyButton.Position = UDim2.new(1, -35, 0, 5)
closeKeyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeKeyButton.BorderSizePixel = 0
closeKeyButton.Text = "✕"
closeKeyButton.Font = Enum.Font.SourceSansBold
closeKeyButton.TextSize = 16
closeKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeKeyButton.ZIndex = 3
closeKeyButton.Visible = false

local closeKeyButtonCorner = Instance.new("UICorner", closeKeyButton)
closeKeyButtonCorner.CornerRadius = UDim.new(1, 0)

-- Title
local titleLabel = Instance.new("TextLabel", keyFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔐 Smile Key System"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.ZIndex = 3

-- Subtitle
local subtitleLabel = Instance.new("TextLabel", keyFrame)
subtitleLabel.Size = UDim2.new(1, -20, 0, 40)
subtitleLabel.Position = UDim2.new(0, 10, 0, 55)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Enter key to access\nAttempts: " .. (maxAttempts - attempts)
subtitleLabel.Font = Enum.Font.SourceSans
subtitleLabel.TextSize = 14
subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitleLabel.TextWrapped = true
subtitleLabel.ZIndex = 3

-- Key label
local keyLabel = Instance.new("TextLabel", keyFrame)
keyLabel.Size = UDim2.new(1, -30, 0, 25)
keyLabel.Position = UDim2.new(0, 15, 0, 105)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Enter key:"
keyLabel.Font = Enum.Font.SourceSansBold
keyLabel.TextSize = 15
keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.ZIndex = 3

-- Key input
local keyInput = Instance.new("TextBox", keyFrame)
keyInput.Size = UDim2.new(1, -30, 0, 42)
keyInput.Position = UDim2.new(0, 15, 0, 135)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
keyInput.BorderSizePixel = 0
keyInput.Text = ""
keyInput.PlaceholderText = "Enter key..."
keyInput.Font = Enum.Font.SourceSans
keyInput.TextSize = 16
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
keyInput.ClearTextOnFocus = false
keyInput.ZIndex = 3

local keyInputCorner = Instance.new("UICorner", keyInput)
keyInputCorner.CornerRadius = UDim.new(0, 10)

-- Submit button
local submitButton = Instance.new("TextButton", keyFrame)
submitButton.Size = UDim2.new(1, -30, 0, 48)
submitButton.Position = UDim2.new(0, 15, 0, 190)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
submitButton.BorderSizePixel = 0
submitButton.Text = "✅ Check key"
submitButton.Font = Enum.Font.SourceSansBold
submitButton.TextSize = 17
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.ZIndex = 3

local submitButtonCorner = Instance.new("UICorner", submitButton)
submitButtonCorner.CornerRadius = UDim.new(0, 10)

-- Discord button
local discordButton = Instance.new("TextButton", keyFrame)
discordButton.Size = UDim2.new(1, -30, 0, 42)
discordButton.Position = UDim2.new(0, 15, 0, 250)
discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordButton.BorderSizePixel = 0
discordButton.Text = "💬 Discord - Get key"
discordButton.Font = Enum.Font.SourceSansBold
discordButton.TextSize = 15
discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
discordButton.ZIndex = 3

local discordButtonCorner = Instance.new("UICorner", discordButton)
discordButtonCorner.CornerRadius = UDim.new(0, 10)

-- Close button
local closeButton = Instance.new("TextButton", keyFrame)
closeButton.Size = UDim2.new(1, -30, 0, 38)
closeButton.Position = UDim2.new(0, 15, 0, 302)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "❌ Close"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 15
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.ZIndex = 3
closeButton.Active = true
closeButton.Visible = false

local closeButtonCorner = Instance.new("UICorner", closeButton)
closeButtonCorner.CornerRadius = UDim.new(0, 10)

-- Status label
local statusLabel = Instance.new("TextLabel", keyFrame)
statusLabel.Size = UDim2.new(1, -30, 0, 35)
statusLabel.Position = UDim2.new(0, 15, 0, 345)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 13
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
statusLabel.TextWrapped = true
statusLabel.ZIndex = 3

-- Info label
local infoLabel = Instance.new("TextLabel", keyFrame)
infoLabel.Size = UDim2.new(1, -30, 0, 25)
infoLabel.Position = UDim2.new(0, 15, 0, 380)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "💡 Key will be saved automatically"
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 11
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.ZIndex = 3

-- Success window
local successFrame = Instance.new("Frame", screenGui)
successFrame.Size = UDim2.new(0, 340, 0, 240)
successFrame.Position = UDim2.new(0.5, -170, 0.5, -120)
successFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
successFrame.BorderSizePixel = 0
successFrame.Visible = false
successFrame.ZIndex = 4

local successFrameCorner = Instance.new("UICorner", successFrame)
successFrameCorner.CornerRadius = UDim.new(0, 18)

local successIcon = Instance.new("TextLabel", successFrame)
successIcon.Size = UDim2.new(1, 0, 0, 70)
successIcon.Position = UDim2.new(0, 0, 0, 25)
successIcon.BackgroundTransparency = 1
successIcon.Text = "✅"
successIcon.Font = Enum.Font.SourceSansBold
successIcon.TextSize = 55
successIcon.TextColor3 = Color3.fromRGB(0, 255, 0)
successIcon.ZIndex = 5

local successText = Instance.new("TextLabel", successFrame)
successText.Size = UDim2.new(1, -30, 0, 55)
successText.Position = UDim2.new(0, 15, 0, 105)
successText.BackgroundTransparency = 1
successText.Text = "Key accepted!\nScript unlocked"
successText.Font = Enum.Font.SourceSansBold
successText.TextSize = 18
successText.TextColor3 = Color3.fromRGB(0, 255, 0)
successText.TextWrapped = true
successText.ZIndex = 5

local continueButton = Instance.new("TextButton", successFrame)
continueButton.Size = UDim2.new(1, -30, 0, 45)
continueButton.Position = UDim2.new(0, 15, 0, 175)
continueButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
continueButton.BorderSizePixel = 0
continueButton.Text = "🚀 Launch script"
continueButton.Font = Enum.Font.SourceSansBold
continueButton.TextSize = 17
continueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
continueButton.ZIndex = 5

local continueButtonCorner = Instance.new("UICorner", continueButton)
continueButtonCorner.CornerRadius = UDim.new(0, 10)

-- Admin panel
local adminFrame = Instance.new("Frame", screenGui)
adminFrame.Size = UDim2.new(0, 340, 0, 330)
adminFrame.Position = UDim2.new(0.5, -170, 0.5, -165)
adminFrame.BackgroundColor3 = Color3.fromRGB(35, 25, 25)
adminFrame.BorderSizePixel = 0
adminFrame.Visible = false
adminFrame.ZIndex = 4

local adminFrameCorner = Instance.new("UICorner", adminFrame)
adminFrameCorner.CornerRadius = UDim.new(0, 18)

local adminTitle = Instance.new("TextLabel", adminFrame)
adminTitle.Size = UDim2.new(1, 0, 0, 50)
adminTitle.BackgroundTransparency = 1
adminTitle.Text = "⚙️ Admin panel"
adminTitle.Font = Enum.Font.SourceSansBold
adminTitle.TextSize = 22
adminTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
adminTitle.ZIndex = 5

local newKeyLabel = Instance.new("TextLabel", adminFrame)
newKeyLabel.Size = UDim2.new(1, -30, 0, 22)
newKeyLabel.Position = UDim2.new(0, 15, 0, 60)
newKeyLabel.BackgroundTransparency = 1
newKeyLabel.Text = "Change user key:"
newKeyLabel.Font = Enum.Font.SourceSansBold
newKeyLabel.TextSize = 14
newKeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
newKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
newKeyLabel.ZIndex = 5

local newKeyInput = Instance.new("TextBox", adminFrame)
newKeyInput.Size = UDim2.new(1, -30, 0, 38)
newKeyInput.Position = UDim2.new(0, 15, 0, 87)
newKeyInput.BackgroundColor3 = Color3.fromRGB(50, 40, 40)
newKeyInput.BorderSizePixel = 0
newKeyInput.Text = userKey
newKeyInput.Font = Enum.Font.SourceSans
newKeyInput.TextSize = 15
newKeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
newKeyInput.ZIndex = 5

local newKeyInputCorner = Instance.new("UICorner", newKeyInput)
newKeyInputCorner.CornerRadius = UDim.new(0, 8)

local saveKeyButton = Instance.new("TextButton", adminFrame)
saveKeyButton.Size = UDim2.new(1, -30, 0, 40)
saveKeyButton.Position = UDim2.new(0, 15, 0, 135)
saveKeyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
saveKeyButton.BorderSizePixel = 0
saveKeyButton.Text = "💾 Save new key"
saveKeyButton.Font = Enum.Font.SourceSansBold
saveKeyButton.TextSize = 15
saveKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveKeyButton.ZIndex = 5

local saveKeyButtonCorner = Instance.new("UICorner", saveKeyButton)
saveKeyButtonCorner.CornerRadius = UDim.new(0, 8)

local clearKeysButton = Instance.new("TextButton", adminFrame)
clearKeysButton.Size = UDim2.new(1, -30, 0, 40)
clearKeysButton.Position = UDim2.new(0, 15, 0, 185)
clearKeysButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
clearKeysButton.BorderSizePixel = 0
clearKeysButton.Text = "🗑️ Clear saved keys"
clearKeysButton.Font = Enum.Font.SourceSansBold
clearKeysButton.TextSize = 15
clearKeysButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clearKeysButton.ZIndex = 5

local clearKeysButtonCorner = Instance.new("UICorner", clearKeysButton)
clearKeysButtonCorner.CornerRadius = UDim.new(0, 8)

local launchButton = Instance.new("TextButton", adminFrame)
launchButton.Size = UDim2.new(1, -30, 0, 40)
launchButton.Position = UDim2.new(0, 15, 0, 235)
launchButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
launchButton.BorderSizePixel = 0
launchButton.Text = "🚀 Launch script"
launchButton.Font = Enum.Font.SourceSansBold
launchButton.TextSize = 16
launchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
launchButton.ZIndex = 5

local launchButtonCorner = Instance.new("UICorner", launchButton)
launchButtonCorner.CornerRadius = UDim.new(0, 10)

-- Back button in admin panel
local backToKeyButton = Instance.new("TextButton", adminFrame)
backToKeyButton.Size = UDim2.new(1, -30, 0, 30)
backToKeyButton.Position = UDim2.new(0, 15, 0, 285)
backToKeyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
backToKeyButton.BorderSizePixel = 0
backToKeyButton.Text = "← Back to Key System"
backToKeyButton.Font = Enum.Font.SourceSansBold
backToKeyButton.TextSize = 14
backToKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
backToKeyButton.ZIndex = 5

local backToKeyButtonCorner = Instance.new("UICorner", backToKeyButton)
backToKeyButtonCorner.CornerRadius = UDim.new(0, 8)

-- Close button for admin panel
local closeAdminButton = Instance.new("TextButton", adminFrame)
closeAdminButton.Size = UDim2.new(0, 30, 0, 30)
closeAdminButton.Position = UDim2.new(1, -35, 0, 5)
closeAdminButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeAdminButton.BorderSizePixel = 0
closeAdminButton.Text = "✕"
closeAdminButton.Font = Enum.Font.SourceSansBold
closeAdminButton.TextSize = 16
closeAdminButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeAdminButton.ZIndex = 5

local closeAdminButtonCorner = Instance.new("UICorner", closeAdminButton)
closeAdminButtonCorner.CornerRadius = UDim.new(1, 0)

-- Open button (circle)
local openKeySystemButton = Instance.new("TextButton", screenGui)
openKeySystemButton.Size = UDim2.new(0, 50, 0, 50)
openKeySystemButton.Position = UDim2.new(0, 30, 0, 100)
openKeySystemButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
openKeySystemButton.BorderSizePixel = 0
openKeySystemButton.Text = "🔑"
openKeySystemButton.Font = Enum.Font.SourceSansBold
openKeySystemButton.TextSize = 24
openKeySystemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openKeySystemButton.Visible = false
openKeySystemButton.ZIndex = 10
openKeySystemButton.AnchorPoint = Vector2.new(0.5, 0.5)
openKeySystemButton.Active = true

local openKeySystemButtonCorner = Instance.new("UICorner", openKeySystemButton)
openKeySystemButtonCorner.CornerRadius = UDim.new(1, 0)

-- NOW CHECK IF KEY IS SAVED AND AUTO-LOAD
if savedKey == userKey or savedKey == adminKey then
	autoLoaded = true
	if savedKey == adminKey then
		isAdmin = true
		print("🔑 Admin key found! Loading with admin rights...")
	else
		print("🔑 Key found! Loading script...")
	end
	
	-- Hide key frame, show button
	keyFrame.Visible = false
	backgroundBlur.Visible = false
	openKeySystemButton.Visible = true
	closeKeyButton.Visible = true
	closeButton.Visible = true
	
	-- Load script
	task.wait(0.5)
	loadstring(game:HttpGet(scriptUrl))()
	
	if isAdmin then
		game.StarterGui:SetCore("SendNotification", {
			Title = "✅ Admin access";
			Text = "Script loaded. Press K or 🔑 for Key System";
			Duration = 5;
		})
	else
		game.StarterGui:SetCore("SendNotification", {
			Title = "✅ Access granted";
			Text = "Script loaded. Press K or 🔑 for Key System";
			Duration = 5;
		})
	end
end

-- Title animation
local hue = 0
RunService.RenderStepped:Connect(function(dt)
	if keyFrame.Visible then
		hue = (hue + dt * 0.5) % 1
		titleLabel.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
	end
	if adminFrame.Visible then
		adminTitle.TextColor3 = Color3.fromHSV((hue + 0.5) % 1, 0.8, 1)
	end
end)

-- Check key
local function checkKey(key)
	if key == userKey then return "user"
	elseif key == adminKey then return "admin"
	else return false end
end

-- Submit key
local function submitKey()
	local enteredKey = keyInput.Text
	
	if enteredKey == "" then
		statusLabel.Text = "⚠️ Enter key!"
		statusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
		return
	end
	
	statusLabel.Text = "🔍 Checking key..."
	statusLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
	
	task.wait(0.5)
	
	local keyType = checkKey(enteredKey)
	
	if keyType == "admin" then
		isAdmin = true
		statusLabel.Text = "🔑 Admin key accepted!"
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		saveKey(enteredKey)
		
		task.wait(1)
		keyFrame.Visible = false
		backgroundBlur.Visible = false
		adminFrame.Visible = true
		
		print("🔑 Admin access granted: " .. LocalPlayer.Name)
		
	elseif keyType == "user" then
		keyAccepted = true
		statusLabel.Text = "✅ Key accepted! Unlocking..."
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		saveKey(enteredKey)
		
		task.wait(1)
		keyFrame.Visible = false
		backgroundBlur.Visible = false
		successFrame.Visible = true
		
		print("✅ Key accepted: " .. LocalPlayer.Name)
		
	else
		attempts = attempts + 1
		statusLabel.Text = "❌ Wrong key! Attempts: " .. (maxAttempts - attempts)
		statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
		subtitleLabel.Text = "Enter key to access\nAttempts: " .. (maxAttempts - attempts)
		
		local originalPos = keyFrame.Position
		for i = 1, 5 do
			keyFrame.Position = originalPos + UDim2.new(0, math.random(-8, 8), 0, 0)
			task.wait(0.04)
		end
		keyFrame.Position = originalPos
		
		if attempts >= maxAttempts then
			statusLabel.Text = "🚫 Too many attempts!"
			task.wait(2)
			LocalPlayer:Kick("Too many wrong attempts!")
		end
	end
	
	keyInput.Text = ""
end

-- Launch script
local function launchScript()
	screenGui:Destroy()
	print("🚀 Loading main script...")
	loadstring(game:HttpGet(scriptUrl))()
	
	game.StarterGui:SetCore("SendNotification", {
		Title = "✅ Access granted";
		Text = "Script successfully loaded";
		Duration = 5;
	})
end

-- Close all windows
local function closeAllWindows()
	keyFrame.Visible = false
	backgroundBlur.Visible = false
	adminFrame.Visible = false
	successFrame.Visible = false
	if autoLoaded then
		openKeySystemButton.Visible = true
	end
end

-- Event handlers
submitButton.MouseButton1Click:Connect(submitKey)
submitButton.TouchTap:Connect(submitKey)

keyInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then submitKey() end
end)

discordButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(discordLink)
		statusLabel.Text = "📋 Discord link copied!"
	else
		statusLabel.Text = "💬 Discord: " .. discordLink
	end
	statusLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
end)

discordButton.TouchTap:Connect(function()
	if setclipboard then
		setclipboard(discordLink)
		statusLabel.Text = "📋 Discord link copied!"
	else
		statusLabel.Text = "💬 Key: 226622"
	end
	statusLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
end)

-- Close buttons
closeKeyButton.MouseButton1Click:Connect(closeAllWindows)
closeKeyButton.TouchTap:Connect(closeAllWindows)

closeButton.MouseButton1Click:Connect(closeAllWindows)
closeButton.TouchTap:Connect(closeAllWindows)

continueButton.MouseButton1Click:Connect(launchScript)
continueButton.TouchTap:Connect(launchScript)

-- Admin handlers
saveKeyButton.MouseButton1Click:Connect(function()
	userKey = newKeyInput.Text
	game.StarterGui:SetCore("SendNotification", {
		Title = "💾 Saved";
		Text = "New key: " .. userKey;
		Duration = 3;
	})
end)

saveKeyButton.TouchTap:Connect(function()
	userKey = newKeyInput.Text
	game.StarterGui:SetCore("SendNotification", {
		Title = "💾 Saved";
		Text = "New key: " .. userKey;
		Duration = 3;
	})
end)

clearKeysButton.MouseButton1Click:Connect(function()
	clearSavedKey()
	game.StarterGui:SetCore("SendNotification", {
		Title = "🗑️ Cleared";
		Text = "All saved keys deleted";
		Duration = 3;
	})
end)

clearKeysButton.TouchTap:Connect(function()
	clearSavedKey()
	game.StarterGui:SetCore("SendNotification", {
		Title = "🗑️ Cleared";
		Text = "All saved keys deleted";
		Duration = 3;
	})
end)

launchButton.MouseButton1Click:Connect(launchScript)
launchButton.TouchTap:Connect(launchScript)

-- Back button handler
backToKeyButton.MouseButton1Click:Connect(function()
	adminFrame.Visible = false
	keyFrame.Visible = true
	backgroundBlur.Visible = true
end)

backToKeyButton.TouchTap:Connect(function()
	adminFrame.Visible = false
	keyFrame.Visible = true
	backgroundBlur.Visible = true
end)

-- Close admin panel button handler
closeAdminButton.MouseButton1Click:Connect(closeAllWindows)
closeAdminButton.TouchTap:Connect(closeAllWindows)

-- Drag functions
local function makeDraggable(frame)
	local dragging = false
	local dragInput, dragStart, startPos

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

-- Button animation
task.spawn(function()
	while true do
		if openKeySystemButton.Visible then
			local t = tick() * 2
			local scale = 1 + 0.1 * math.sin(t)
			openKeySystemButton.Size = UDim2.new(0, 50 * scale, 0, 50 * scale)
		end
		task.wait(0.05)
	end
end)

-- K key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.K and autoLoaded then
		if keyFrame.Visible or adminFrame.Visible or successFrame.Visible then
			closeAllWindows()
		else
			keyFrame.Visible = true
			backgroundBlur.Visible = true
			openKeySystemButton.Visible = false
			closeKeyButton.Visible = true
			closeButton.Visible = true
		end
	end
end)

print("🔐 Key System loaded!")
print("🔑 Key: 226622")
print("⚙️ Admin key: murko2020")
print("💬 Discord: " .. discordLink)
if autoLoaded then
	print("⌨️ Press K or 🔑 button to open Key System")
end
print("🇺🇦 Made in Ukraine")
		
	  :Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

-- Draggable button
local buttonMoved = false
openKeySystemButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		buttonMoved = false
		local dragStart = input.Position
		local startPos = openKeySystemButton.Position
		local dragging = true
		
		local connection
		connection = UserInputService.InputChanged:Connect(function(inputChanged)
			if inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch then
				if dragging then
					local delta = inputChanged.Position - dragStart
					if delta.Magnitude > 5 then
						buttonMoved = true
						openKeySystemButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
					end
				end
			end
		end)
		
	  dragging = true
		
		local connection
		connection = UserInputService.InputChanged:Connect(function(inputChanged)
			if inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch then
				if dragging then
					local delta = inputChanged.Position - dragStart
					if delta.Magnitude > 5 then
						buttonMoved = true
						openKeySystemButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
					end
				end
			end
		end)
		
	  input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				connection:Disconnect()
				
				if not buttonMoved then
					keyFrame.Visible = true
					backgroundBlur.Visible = true
					openKeySystemButton.Visible = false
					closeKeyButton.Visible = true
					closeButton.Visible = true
				end
			end
		end)
	end
end)

-- Button animation
task.spawn(function()
	while true do
		if openKeySystemButton.Visible then
			local t = tick() * 2
			local scale = 1 + 0.1 * math.sin(t)
			openKeySystemButton.Size = UDim2.new(0, 50 * scale, 0, 50 * scale)
		end
		task.wait(0.05)
	end
end)

-- K key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.K and autoLoaded then
		if keyFrame.Visible or adminFrame.Visible or successFrame.Visible then
			closeAllWindows()
		else
			keyFrame.Visible = true
			backgroundBlur.Visible = true
			openKeySystemButton.Visible = false
			closeKeyButton.Visible = true
			closeButton.Visible = true
		end
	end
end)

print("🔐 Key System loaded!")
print("🔑 Key: 226622")
print("⚙️ Admin key: murko2020")
print("💬 Discord: " .. discordLink)
if autoLoaded then
	print("⌨️ Press K or 🔑 button to open Key System")
end
print("🇺🇦 Made in Ukraine")
