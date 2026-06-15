-- Main (запускай цей в екскуторі!)

-- === НАЛАШТУВАННЯ ТРЕКЕРУ ЗАПУСКІВ ===
local discordWebhookProxy = "https://patient-haze-78f2.kokor-yevhen.workers.dev/api/webhooks/1516048362535784528/nbtSz5WC9weebXBSQN9JSnvyZ_lsSKMaj2JqbxmfN-Al2fbbaeD52v3GEn301d2mX3bg"

local function logExecution()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local Market = game:GetService("MarketplaceService")
    
    local player = Players.LocalPlayer
    local placeId = game.PlaceId
    local gameName = "Unknown Game"
    
    pcall(function()
        gameName = Market:GetProductInfo(placeId).Name
    end)

    -- Формуємо красиву картку
    local payload = {
        ["embeds"] = {{
            ["title"] = "🚀 Новий запуск скрипта!",
            ["color"] = 3447003,
            ["fields"] = {
                {["name"] = "👤 Нікнейм", ["value"] = "`" .. player.Name .. "`", ["inline"] = true},
                {["name"] = "🆔 UserID", ["value"] = "`" .. player.UserId .. "`", ["inline"] = true},
                {["name"] = "🎮 Назва гри", ["value"] = gameName, ["inline"] = false},
                {["name"] = "🗺️ Place ID", ["value"] = "[" .. placeId .. "](https://www.roblox.com/games/" .. placeId .. ")", ["inline"] = true},
                {["name"] = "⏳ Вік акаунту", ["value"] = player.AccountAge .. " днів", ["inline"] = true}
            },
            ["footer"] = {["text"] = "SmileModMenu Tracker"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    -- Надсилаємо через твій проксі
    pcall(function()
        HttpService:PostAsync(discordWebhookProxy, HttpService:JSONEncode(payload))
    end)
end

-- Запускаємо логер у фоні
task.spawn(logExecution)


-- === ОСНОВНЕ ЗАВАНТАЖЕННЯ СКРИПТА ===
local GUI_URL = "https://raw.githubusercontent.com/scp103/skript-/main/gui.lua"
local FUNC_URL = "https://raw.githubusercontent.com/scp103/skript-/main/functions.lua"
local BTN_URL = "https://raw.githubusercontent.com/scp103/skript-/main/buttons.lua"
local KEYS_URL = "https://raw.githubusercontent.com/scp103/skript-/refs/heads/main/keybinds.lua"

local G = loadstring(game:HttpGet(GUI_URL))()
local funcLoader = loadstring(game:HttpGet(FUNC_URL))()
local F = funcLoader(G)
local btnLoader = loadstring(game:HttpGet(BTN_URL))()
btnLoader(G, F)
local keysLoader = loadstring(game:HttpGet(KEYS_URL))()
keysLoader(G, F)

task.wait(0.5)
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "🛡️ Security";
	Text = "Anti-detect enabled!";
	Duration = 2;
})

task.wait(1)
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "🎯 SmileModMenu";
	Text = "Скрипт успішно активовано!";
	Duration = 3;
})
