--[[
    ═══════════════════════════════════════════════════════════════════════════
    FLOW RIVALS // REMOTE BOOTSTRAP LOADER (GITHUB)
    Usage:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/<OWNER>/<REPO>/main/init.lua"))()
    ═══════════════════════════════════════════════════════════════════════════
]]

local GITHUB_USER = "cylixstudios"
local GITHUB_REPO = "rivals"
local GITHUB_BRANCH = "main"

local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s", GITHUB_USER, GITHUB_REPO, GITHUB_BRANCH)

-- Primary GitHub Fetch
local success, content = pcall(function()
    return game:HttpGet(BASE_URL .. "/main.lua", true)
end)

-- Fallback to local delivery daemon if offline or during local testing
if not success or not content or #content < 50 then
    warn("[Flow Rivals] GitHub fetch failed. Falling back to local delivery daemon...")
    local localSuccess, localContent = pcall(function()
        return game:HttpGet("http://127.0.0.1:3333/main.lua", true)
    end)
    if localSuccess and localContent and #localContent > 50 then
        success = true
        content = localContent
    end
end

if success and content then
    local executable, compileErr = loadstring(content)
    if executable then
        executable()
    else
        warn("[Flow Rivals] Compilation Error: " .. tostring(compileErr))
    end
else
    warn("[Flow Rivals] Failed to retrieve main.lua from remote endpoint.")
end
