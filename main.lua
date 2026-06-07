-- Main (запускай цей в KRNL!)

local GUI_URL = "https://raw.githubusercontent.com/scp103/skript-/main/gui.lua"
local FUNC_URL = "https://raw.githubusercontent.com/scp103/skript-/main/functions.lua"
local BTN_URL = "https://raw.githubusercontent.com/scp103/skript-/main/buttons.lua"

-- Завантажуємо GUI
local G = loadstring(game:HttpGet(GUI_URL))()

-- Завантажуємо Functions
local funcLoader = loadstring(game:HttpGet(FUNC_URL))()
local F = funcLoader(G)

-- Завантажуємо Buttons
local btnLoader = loadstring(game:HttpGet(BTN_URL))()
btnLoader(G, F)

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "😊 Smile Mod Menu";
	Text = "Successfully loaded!";
	Duration = 2;
})

print("✅ Smile Mod Menu завантажено!")
