local function createObjESP(obj)
    if charmsEspObjStorage[obj] then return end
    
    -- Визначаємо правильну ціль для підсвітки всієї моделі або конкретного парента
    local adorneeTarget = obj
    if obj:IsA("BasePart") and obj.Parent:IsA("Model") then
        adorneeTarget = obj.Parent
    end
    
    -- Створюємо підсвітку (Обводку)
    local h = Instance.new("Highlight")
    h.FillTransparency = 1        -- Прозоре всередині
    h.OutlineTransparency = 0     -- Повна обводка
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = adorneeTarget     -- Підсвічує весь об'єкт/модель повністю
    h.Parent = game:GetService("CoreGui")
    
    -- Створюємо GUI для відображення Назви та Відстані
    local bgui = Instance.new("BillboardGui")
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.AlwaysOnTop = true
    bgui.Adornee = obj
    bgui.ExtentsOffset = Vector3.new(0, 2, 0)
    bgui.Parent = game:GetService("CoreGui")
    
    local textLabel = Instance.new("TextLabel", bgui)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.TextStrokeTransparency = 0
    textLabel.Text = obj.Name
    
    charmsEspObjStorage[obj] = {Highlight = h, Billboard = bgui, Label = textLabel}
end
