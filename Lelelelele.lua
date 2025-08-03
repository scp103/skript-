local HttpService = game:GetService("HttpService")

local blacklist = {
    "grabify.link", "iplogger.org", "webhook.site", "gyazo.in", "leakix.net",
    "bmwforum.co", "yip.su", "ipgraber.ru", "2no.co", "iplogger.com",
    "trackip.link", "boob.pl", "ip-tracker.org", "webhook.le", "requestbin.net",
    "api.ipify.org"
}

for i, domain in ipairs(blacklist) do
    blacklist[i] = domain:lower()
end

local function isMalicious(url)
    url = url:lower()
    for _, badDomain in ipairs(blacklist) do
        if string.find(url, badDomain, 1, true) then
            return true
        end
    end
    return false
end

local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }

    if method == "HttpGet" and typeof(self) == "Instance" and self == game then
        local url = args[1]
        if url and isMalicious(url) then
            warn("[DontGrabMe] Blocked HttpGet (via __namecall): " .. url)
            return "Blocked by DontGrabMe"
        end
    end

    return oldNamecall(self, ...)
end)

local oldRequestAsync = hookfunction(HttpService.RequestAsync, function(self, options)
    local url = options and options.Url
    if url and isMalicious(url) then
        warn("[DontGrabMe] Blocked RequestAsync: " .. url)
        return { Success = false, StatusCode = 403, Body = "Blocked by DontGrabMe" }
    end
    return oldRequestAsync(self, options)
end)

local function hookExecutorRequest(fnName)
    local fn = rawget(_G, fnName) or getfenv()[fnName]
    if type(fn) == "function" then
        hookfunction(fn, newcclosure(function(tbl)
            local url = tbl and (tbl.Url or tbl.URL or tbl.url)
            if url and isMalicious(url) then
                warn("[DontGrabMe] Blocked executor request to: " .. url)
                return { Success = false, StatusCode = 403, Body = "Blocked by DontGrabMe" }
            end
            return fn(tbl)
        end))
    end
end

hookExecutorRequest("http_request")
hookExecutorRequest("request")
hookExecutorRequest("syn.request")
hookExecutorRequest("fluxus.request")
-- // More scripts: t.me/arceusxscripts
