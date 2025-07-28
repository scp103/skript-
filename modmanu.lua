--== Smile Mod Menu (з твоїм оригінальним UI) + Speed Hack ==--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local speedEnabled = false
local currentSpeed = 50

-- Створити Speed Hack
local function applySpeed(speed)
    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedEnabled and speed or 16
    end
end

-- Створити UI-кнопку в твоєму стилі (aimButton, espButton і т.д.)
local function createSpeedButton(parent)
    local speedButton = parent:Clone()
    speedButton.Name = "speedButton"
    speedButton.Text = "SPEED: " .. tostring(currentSpeed) .. (speedEnabled and " (ON)" or " (OFF)")
    speedButton.Parent = parent.Parent

    -- Натиснення ЛКМ вмикає/вимикає Speed
    speedButton.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        applySpeed(currentSpeed)
        speedButton.Text = "SPEED: " .. tostring(currentSpeed) .. (speedEnabled and " (ON)" or " (OFF)")
    end)

    -- ПКМ відкриває поле введення швидкості
    speedButton.MouseButton2Click:Connect(function()
        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(1, 0, 0, 25)
        inputBox.Position = UDim2.new(0, 0, 1, 5)
        inputBox.PlaceholderText = "Enter speed (16-500)"
        inputBox.Text = ""
        inputBox.BackgroundColor3 = speedButton.BackgroundColor3
        inputBox.TextColor3 = speedButton.TextColor3
        inputBox.BorderSizePixel = 1
        inputBox.Font = speedButton.Font
        inputBox.TextScaled = true
        inputBox.Parent = speedButton

        inputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local val = tonumber(inputBox.Text)
                if val and val >= 16 and val <= 500 then
                    currentSpeed = val
                    if speedEnabled then applySpeed(currentSpeed) end
                    speedButton.Text = "SPEED: " .. tostring(currentSpeed) .. (speedEnabled and " (ON)" or " (OFF)")
                end
                inputBox:Destroy()
            end
        end)
    end)
end

-- Зачекаємо, поки кнопки будуть завантажені
RunService.RenderStepped:Wait()

-- Пошук твоєї кнопки, щоб створити Speed Hack поруч
local menu = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ScreenGui")
if menu then
    local aimButton = menu:FindFirstChild("aimButton", true) -- будь-яка з твоїх кнопок
    if aimButton then
        createSpeedButton(aimButton)
    end
end

--== Тут твій оригінальний код нижче, я не чіпаю нічого ==--
-- aimButton, espButton, noclipButton і решта тут залишаються такими ж
-- вставлений Speed Hack лише додається у твій існуючий фрейм
