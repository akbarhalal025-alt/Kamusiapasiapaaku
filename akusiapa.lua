--[[
================================================================================
  👑 KING AKBAR - ULTIMATE AUTO FARM SCRIPT 👑
================================================================================
    [+] Developer   : King Akbar
    [+] Version     : DDS GLOBAL EDITION (v7.9.5 ANTI-LAG + FAKE NAME FIX)
    [+] Changelog   : - BYPASS TOTAL MATEMATIKA (Silent Fire UUID)
                      - Anti-Admin recoded (Deteksi Rank, Nama, & Chat Tag)
                      - Bot langsung nembak jawaban ke Server (No UI Click)
                      - FIX MOBILE: Nggak ada lagi masalah tombol nggak keklik
                      - [NEW] ANTI-LAG (Particle Purge + Quality Lock)
                      - [FIX] FAKE NAME recoded (No FPS drop, auto-restore)
                      - FIX AFK STUCK (Anti GUI Freeze & Remote Drop)
                      - FULL ENGLISH UI + Sections Collapsed by Default
================================================================================
]]--

-- ============================================================================
-- // SILENT MODE (MATIKAN F9 CONSOLE)
-- ============================================================================
local print = function() end
local warn = function() end
local error = function() end

-- ============================================================================
-- // 0. ULTIMATE FULL BYPASS V3 (Zero-Lag / Anti FPS Drop)
-- ============================================================================
do
    local LocalPlayer = game:GetService("Players").LocalPlayer

    pcall(function()
        for k, v in pairs(getgc(true)) do
            if pcall(function() return rawget(v, "indexInstance") end) and type(rawget(v, "indexInstance")) == "table" and (rawget(v, "indexInstance"))[1] == "kick" then
                setreadonly(v, false)
                v.tvk = { "kick", function() return game.Workspace:WaitForChild("") end }
            end
        end
    end)

    pcall(function()
        local requestFunc = (syn and syn.request) or http_request or (fluxus and fluxus.request) or request or (http and http.request)
        if requestFunc then
            local oldRequest = requestFunc
            hookfunction(requestFunc, function(opts)
                local url = string.lower(tostring(opts.Url or opts.url or ""))
                if not (url:find("roblox.com") or url:find("rbxcdn")) then
                    return { StatusCode = 200, Body = "{\"success\":true}", Success = true }
                end
                return oldRequest(opts)
            end)
        end
    end)

    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        if setreadonly then setreadonly(mt, false) end
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            
            if (method == "Kick" or method == "kick" or method == "Disconnect") and self == LocalPlayer then
                return wait(9e9)
            end
            
            if method == "FireServer" or method == "InvokeServer" then
                local remoteName = string.lower(tostring(self.Name))
                local parentName = self.Parent and string.lower(tostring(self.Parent.Name)) or ""
                
                if remoteName:find("adonis") or parentName:find("adonis") or remoteName:find("anticheat") or remoteName:find("detector") or remoteName:find("admin") or remoteName:find("log") or remoteName:find("report") then
                    return nil
                end
            end
            return oldNamecall(self, ...)
        end)
        if setreadonly then setreadonly(mt, true) end
    end)

    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua", true))() end)
    pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/SUUUUUS00000/MEGGD-Anti-kick/refs/heads/main/MEGGD%20Best%20Anti-kick.lua'))() end)

    local hui = gethui and gethui() or game:GetService("CoreGui")
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    local cg = game:GetService("CoreGui")

    local function killCheat(parent)
        if not parent then return end
        for _, v in pairs(parent:GetChildren()) do
            local name = string.lower(v.Name)
            if name:find("adonis") or name:find("ae_") or name:find("admin") or name:find("anticheat") or name:find("detector") then
                pcall(function()
                    if v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("Script") then v.Disabled = true end
                    v:Destroy()
                end)
            end
        end
    end

    task.spawn(function()
        while task.wait(2) do
            pcall(killCheat, pg)
            pcall(killCheat, cg)
            pcall(killCheat, hui)
        end
    end)

    local function monitor(parent)
        if not parent then return end
        parent.ChildAdded:Connect(function(child)
            local name = string.lower(child.Name)
            if name:find("adonis") or name:find("ae_") or name:find("admin") or name:find("anticheat") or name:find("detector") then
                pcall(function()
                    if child:IsA("LocalScript") or child:IsA("ModuleScript") or child:IsA("Script") then child.Disabled = true end
                    child:Destroy()
                end)
            end
        end)
    end

    pcall(monitor, pg)
    pcall(monitor, cg)
    pcall(monitor, hui)
end

-- ============================================================================
-- // 1. LOAD WINDUI (SAFE)
-- ============================================================================
local WindUI
do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(
            "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
        ))()
    end)
    if ok and result then
        WindUI = result
    else
        WindUI = {
            CreateWindow = function() return {
                Tab            = function() return {
                    Paragraph  = function() return { Set = function() end } end,
                    Toggle     = function() end,
                    Button     = function() end,
                    Input      = function() end,
                    Slider     = function() end,
                    Section    = function() return {
                        Paragraph = function() return { Set = function() end } end,
                        Toggle    = function() end,
                        Button    = function() end,
                        Input     = function() end,
                        Slider    = function() end,
                    } end,
                    Select     = function() end,
                } end,
                Tag            = function() return { SetTitle = function() end } end,
                EditOpenButton = function() end,
                SetIconSize    = function() end,
            } end,
            Notify   = function() end,
            SetTheme = function() end,
            Gradient = function() return {} end,
        }
    end
end

-- ============================================================================
-- // 2. SERVICES & REFERENCES
-- ============================================================================
local Services = {
    Players            = game:GetService("Players"),
    RunService         = game:GetService("RunService"),
    TweenSvc           = game:GetService("TweenService"),
    UserInput           = game:GetService("UserInputService"),
    Stats              = game:GetService("Stats"),
    Workspace          = game:GetService("Workspace"),
    VIM                = game:GetService("VirtualInputManager"),
    VirtualUser        = game:GetService("VirtualUser"),
    HttpService        = game:GetService("HttpService"),
    GuiService         = game:GetService("GuiService"),
    PathfindingService = game:GetService("PathfindingService"),
    ReplicatedStorage  = game:GetService("ReplicatedStorage"),
    StarterGui         = game:GetService("StarterGui"),
}

local LocalPlayer = Services.Players.LocalPlayer

local IsMobile = Services.UserInput.TouchEnabled
    and not Services.UserInput.KeyboardEnabled
    and not Services.UserInput.MouseEnabled

local CharRef = {
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait(),
    Humanoid  = nil,
    Root      = nil,
}
CharRef.Humanoid = CharRef.Character:WaitForChild("Humanoid")
CharRef.Root     = CharRef.Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    CharRef.Character = newChar
    CharRef.Humanoid  = newChar:WaitForChild("Humanoid")
    CharRef.Root      = newChar:WaitForChild("HumanoidRootPart")
end)

-- ============================================================================
-- // 3. STATE MANAGER
-- ============================================================================
local State = {
    IsBaristaActive    = false,
    IsOfficeActive     = false,
    IsCourierActive    = false,
    AiThread           = nil,
    StatusText         = "Idling...",
    OrderCount         = 0,
    ActionDelay        = 5,
    AntiAFK            = true,
    AntiAdmin          = true,
    UangAwal           = 0,
    UangAwalSession    = 0,
    SessionStartTime   = 0,
    LastStopReason     = "",
    MachineFixCount    = 0,
    OfficeMathSolved   = 0,
    OfficePrints       = 0,
    CourierDelivered   = 0,
    FakeNameActive     = false,
    FakeName           = "King Akbar",
}

LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        pcall(function()
            Services.VirtualUser:CaptureController()
            Services.VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

task.spawn(function()
    while true do
        pcall(function()
            local coreGui = game:GetService("CoreGui")
            local robloxGui = coreGui:FindFirstChild("RobloxGui")
            if robloxGui then
                local pauseScript = robloxGui:FindFirstChild("CoreScripts/NetworkPause")
                if pauseScript then
                    pauseScript:Destroy()
                end
            end
        end)
        task.wait(0.2)
    end
end)

-- ============================================================================
-- // 3.5 FAKE NAME SYSTEM (FIXED: No FPS Drop, No UI Break, Auto Restore)
-- ============================================================================
local OriginalDisplayName = LocalPlayer.DisplayName
local SpoofCache = {}

local function SpoofScan(char)
    for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Visible then
            local t = obj.Text
            if t == LocalPlayer.Name or t == OriginalDisplayName or t == ("@" .. LocalPlayer.Name) then
                if SpoofCache[obj] == nil then SpoofCache[obj] = t end
                obj.Text = State.FakeName
            end
        end
    end
end

local function SpoofRestore()
    for obj, original in pairs(SpoofCache) do
        pcall(function()
            if obj.Parent then obj.Text = original end
        end)
    end
    SpoofCache = {}
end

local function SpoofApplyNow()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.DisplayName = State.FakeName end
        SpoofScan(char)
    end)
end

local function SpoofDisableNow()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.DisplayName = OriginalDisplayName end
        end
    end)
    SpoofRestore()
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if State.FakeNameActive then
        SpoofCache = {}
        pcall(function()
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then hum.DisplayName = State.FakeName end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if not State.FakeNameActive then continue end
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.DisplayName ~= State.FakeName then
                hum.DisplayName = State.FakeName
            end
            SpoofScan(char)
        end)
    end
end)

-- ============================================================================
-- // 4. HUMANIZATION (RNG WAIT)
-- ============================================================================
local function rWait(minSec, maxSec)
    task.wait(math.random((minSec or 0.5) * 1000, (maxSec or 1.5) * 1000) / 1000)
end

-- ============================================================================
-- // 5. GetPlayerMoney
-- ============================================================================
local function GetPlayerMoney()
    local money = 0
    pcall(function()
        if LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Money") then
            money = LocalPlayer.leaderstats.Money.Value
        elseif LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Money") then
            money = LocalPlayer.Data.Money.Value
        else
            for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and string.find(v.Text, "Rp%.") then
                    local m = tonumber(string.gsub(v.Text, "[^%d]", ""))
                    if m and m > money then money = m end
                end
            end
        end
    end)
    return money
end

-- ============================================================================
-- // 6. ADMIN SENSOR (BULLETPROOF EDITION)
-- ============================================================================
local GAME_GROUP_ID  = 11378976 
local MIN_STAFF_RANK = 2 

local BlacklistedNames = {
    "slametriyadi", 
    "admin", 
    "moderator",
    "developer"
}

local function CheckForAdmin(player)
    if not State.AntiAdmin or player == LocalPlayer then return end
    
    local isStaff = false

    local pName = string.lower(player.Name)
    local dName = string.lower(player.DisplayName)
    for _, badName in ipairs(BlacklistedNames) do
        if pName:find(badName) or dName:find(badName) then
            isStaff = true
            break
        end
    end

    if not isStaff then
        pcall(function()
            local rank = player:GetRankInGroup(GAME_GROUP_ID)
            if rank >= MIN_STAFF_RANK then
                isStaff = true
            end
        end)
    end

    if not isStaff then
        pcall(function()
            local chatTag = player:GetAttributeInHierarchy("ChatTags") or player:GetAttribute("IsAdmin")
            if chatTag then isStaff = true end
        end)
    end

    if isStaff then
        State.LastStopReason = "Admin detected: " .. player.Name
        rWait(0.2, 0.5)
        LocalPlayer:Kick("🚨 " .. player.Name .. " (Admin) joined! Leaving for safety.")
    end
end

for _, p in ipairs(Services.Players:GetPlayers()) do CheckForAdmin(p) end
Services.Players.PlayerAdded:Connect(CheckForAdmin)

local TextChatService = game:GetService("TextChatService")
pcall(function()
    TextChatService.MessageReceived:Connect(function(message)
        if not State.AntiAdmin then return end
        local text = string.lower(message.Text or "")
        local sender = message.TextSource
        if sender then
            local player = Services.Players:GetPlayerByUserId(sender.UserId)
            if player and player ~= LocalPlayer then
                if text:find("%[admin%]") or text:find("%[mod%]") or text:find("%[owner%]") or text:find("%[staff%]") then
                    State.LastStopReason = "Admin chat detected: " .. player.Name
                    rWait(0.2, 0.5)
                    LocalPlayer:Kick("🚨 Admin chatting detected! Leaving server!")
                end
            end
        end
    end)
end)

-- ============================================================================
-- // 7. SPLASH SCREEN
-- ============================================================================
do
    local sg = Instance.new("ScreenGui")
    sg.Name = "BaristaSplash"; sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true; sg.DisplayOrder = 999
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame", sg)
    bg.Size = UDim2.fromScale(1,1); bg.BackgroundColor3 = Color3.fromHex("#0a0a0a")
    bg.BorderSizePixel = 0; bg.ZIndex = 1

    local grad = Instance.new("UIGradient", bg)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#0a0a0a")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#1e1e1e")),
    }); grad.Rotation = 135

    local ct = Instance.new("Frame", bg)
    ct.Size = UDim2.fromOffset(500, 300); ct.Position = UDim2.fromScale(0.5, 0.5)
    ct.AnchorPoint = Vector2.new(0.5, 0.5); ct.BackgroundTransparency = 1; ct.ZIndex = 2

    local function mkLabel(txt, yOff, sz)
        local l = Instance.new("TextLabel", ct)
        l.Size = UDim2.fromOffset(500, 70); l.Position = UDim2.fromOffset(0, yOff)
        l.BackgroundTransparency = 1; l.Text = txt; l.TextSize = sz
        l.Font = Enum.Font.GothamBold; l.TextColor3 = Color3.fromHex("#ffffff")
        l.TextTransparency = 1; l.ZIndex = 3; return l
    end

    local icon = Instance.new("ImageLabel", ct)
    icon.Size = UDim2.fromOffset(120, 120); icon.Position = UDim2.fromOffset(190, -40)
    icon.BackgroundTransparency = 1; icon.Image = "rbxassetid://91115084979317"
    icon.ImageTransparency = 1; icon.ZIndex = 3

    local title = mkLabel("King Akbar", 70, IsMobile and 38 or 50)
    local tg = Instance.new("UIGradient", title)
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#ffffff")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#aaaaaa")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#555555")),
    }); tg.Rotation = 45

    local stat = mkLabel("Preparing combat engine...", 200, 12)
    stat.Font = Enum.Font.Gotham; stat.TextColor3 = Color3.fromHex("#555555")
    stat.TextXAlignment = Enum.TextXAlignment.Left; stat.Position = UDim2.fromOffset(50, 200)

    local line = Instance.new("Frame", ct)
    line.Size = UDim2.fromOffset(0, 2); line.Position = UDim2.fromOffset(250, 152)
    line.AnchorPoint = Vector2.new(0.5, 0); line.BackgroundColor3 = Color3.fromHex("#444444")
    line.BorderSizePixel = 0; line.ZIndex = 3

    local barBg = Instance.new("Frame", ct)
    barBg.Size = UDim2.fromOffset(400, 5); barBg.Position = UDim2.fromOffset(50, 190)
    barBg.BackgroundColor3 = Color3.fromHex("#222222"); barBg.BackgroundTransparency = 1
    barBg.BorderSizePixel = 0; barBg.ZIndex = 3
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.fromOffset(0, 5); bar.BackgroundColor3 = Color3.fromHex("#ffffff")
    bar.BorderSizePixel = 0; bar.ZIndex = 4
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local function tw(obj, props, t)
        Services.TweenSvc:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
    end

    task.spawn(function()
        tw(icon,  { ImageTransparency = 0 }, 0.5); task.wait(0.15)
        tw(title, { TextTransparency  = 0 }, 0.6); task.wait(0.35)
        tw(line,  { Size = UDim2.fromOffset(400, 2) }, 0.7); task.wait(0.4)
        tw(barBg, { BackgroundTransparency = 0 }, 0.3)
        tw(stat,  { TextTransparency = 0 }, 0.3)

        for _, s in ipairs({
            { "Preparing RNG Bot...", 0.30 },
            { "Activating Emergency Alarm...", 0.60 },
            { "Welcome, King Akbar!",     1.00 },
        }) do
            stat.Text = s[1]
            tw(bar, { Size = UDim2.fromOffset(400 * s[2], 5) }, 0.5)
            task.wait(0.55)
        end

        task.wait(0.3)
        for _, p in ipairs({ bg, icon, title, line, barBg, bar, stat }) do
            local prop = p == stat and "TextTransparency"
                or (p == icon  and "ImageTransparency" or "BackgroundTransparency")
            if p == title then prop = "TextTransparency" end
            tw(p, { [prop] = 1 }, 0.4)
        end
        task.wait(0.8); sg:Destroy()
    end)
    task.wait(3)
end

-- ============================================================================
-- // 8. CONSTANTS & PATHS (BARISTA)
-- ============================================================================
local Constants = {
    START_SHIFT  = Vector3.new(-4991.23, 4.29, -715.26),
    COLOR_ORANGE = Color3.fromRGB(230, 150, 30),
    COLOR_GREEN  = Color3.fromRGB(30,  180, 60),
}

local Paths = {
    START_TO_MACHINE = {
        Vector3.new(-4991.23, 4.29, -715.26), Vector3.new(-5004.86, 4.29, -718.90),
        Vector3.new(-5006.28, 4.29, -802.11), Vector3.new(-4994.18, 4.29, -801.66),
        Vector3.new(-4994.62, 4.29, -794.89), Vector3.new(-4997.13, 4.29, -794.57),
        Vector3.new(-4998.16, 4.29, -794.80),
    },
    MACHINE_TO_CASHIER = {
        Vector3.new(-4997.13, 4.29, -794.57), Vector3.new(-4994.62, 4.29, -794.89),
        Vector3.new(-4995.56, 4.29, -759.78),
    },
    CASHIER_TO_MACHINE = {
        Vector3.new(-4994.62, 4.29, -794.89), Vector3.new(-4997.13, 4.29, -794.57),
        Vector3.new(-4998.16, 4.29, -794.80),
    },
    MACHINE_TO_START = {
        Vector3.new(-4998.16, 4.29, -794.80), Vector3.new(-4997.13, 4.29, -794.57),
        Vector3.new(-4994.62, 4.29, -794.89), Vector3.new(-4994.18, 4.29, -801.66),
        Vector3.new(-5006.28, 4.29, -802.11), Vector3.new(-5004.86, 4.29, -718.90),
        Vector3.new(-4991.23, 4.29, -715.26),
    },
    CASHIER_TO_START = {
        Vector3.new(-4995.56, 4.29, -759.78), Vector3.new(-4994.62, 4.29, -794.89),
        Vector3.new(-4994.18, 4.29, -801.66), Vector3.new(-5006.28, 4.29, -802.11),
        Vector3.new(-5004.86, 4.29, -718.90), Vector3.new(-4991.23, 4.29, -715.26),
    },
    MACHINE_TO_FIX = {
        Vector3.new(-4998.14, 4.29, -795.38), Vector3.new(-4997.02, 4.29, -802.18),
        Vector3.new(-5006.31, 4.29, -802.30), Vector3.new(-5003.75, 4.29, -711.60),
        Vector3.new(-5004.43, 3.19, -670.40), Vector3.new(-5114.86, 3.19, -670.41),
    },
    FIX_TO_MACHINE = {
        Vector3.new(-5114.86, 3.19, -670.41), Vector3.new(-5004.43, 3.19, -670.40),
        Vector3.new(-5003.75, 4.29, -711.60), Vector3.new(-5006.31, 4.29, -802.30),
        Vector3.new(-4997.02, 4.29, -802.18), Vector3.new(-4998.14, 4.29, -795.38),
    },
}

-- ============================================================================
-- // 9. PERFORMANCE SYSTEMS (BLACK SCREEN + ANTI-LAG)
-- ============================================================================
local BlackGui
local function ToggleBlackScreen(on)
    pcall(function() Services.RunService:Set3dRenderingEnabled(not on) end)
    if on then
        if not BlackGui then
            BlackGui = Instance.new("ScreenGui")
            BlackGui.Name = "BlackScreenSaver"; BlackGui.IgnoreGuiInset = true
            BlackGui.DisplayOrder = 9999; BlackGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            local f = Instance.new("Frame", BlackGui)
            f.Size = UDim2.fromScale(1,1); f.BackgroundColor3 = Color3.new(0,0,0)
            local t = Instance.new("TextLabel", f)
            t.Text = "🌑 POWER SAVING MODE ACTIVE 🌑\nKing Akbar is farming..."
            t.Size = UDim2.fromScale(1,1); t.TextColor3 = Color3.new(1,1,1)
            t.BackgroundTransparency = 1; t.Font = Enum.Font.GothamBold; t.TextSize = 20
        end
        BlackGui.Enabled = true
    else
        if BlackGui then BlackGui.Enabled = false end
    end
end

-- [NEW] ANTI-LAG SYSTEM (Particle Purge + Quality Lock)
local AntiLagActive = false
local AntiLagConn = nil

local LAG_CLASSES = {
    "ParticleEmitter", "Smoke", "Fire", "Explosion", "Beam", "Trail", "Sparkles"
}

local function isLaggy(inst)
    for _, c in ipairs(LAG_CLASSES) do
        if inst:IsA(c) then return true end
    end
    return false
end

local function ToggleAntiLag(on)
    AntiLagActive = on
    if on then
        -- Kunci kualitas grafis ke minimum
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
            game:GetService("Lighting").GlobalShadows = false
        end)

        -- Bersihkan partikel yang udah ada
        task.spawn(function()
            for _, v in pairs(Services.Workspace:GetDescendants()) do
                if isLaggy(v) then pcall(function() v:Destroy() end) end
            end
        end)

        -- Cegah partikel baru muncul
        if not AntiLagConn then
            AntiLagConn = Services.Workspace.DescendantAdded:Connect(function(v)
                if AntiLagActive and isLaggy(v) then
                    pcall(function() v:Destroy() end)
                end
            end)
        end
    else
        if AntiLagConn then
            AntiLagConn:Disconnect()
            AntiLagConn = nil
        end
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)
        pcall(function()
            game:GetService("Lighting").GlobalShadows = true
        end)
    end
end

-- ============================================================================
-- // 10. UTILITY (BARISTA)
-- ============================================================================
local function WalkToPoint(pos)
    if not CharRef.Humanoid or not CharRef.Root then return end
    if CharRef.Humanoid.Sit then
        CharRef.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        task.wait(0.2)
    end
    local hp = pos + Vector3.new(math.random(-15,15)/10, 0, math.random(-15,15)/10)
    CharRef.Humanoid:MoveTo(hp)
    local t = 10
    while t > 0 and State.IsBaristaActive do
        local d = Vector3.new(CharRef.Root.Position.X, 0, CharRef.Root.Position.Z)
               - Vector3.new(hp.X, 0, hp.Z)
        if d.Magnitude < 3 then break end
        task.wait(0.1); t -= 0.1
    end
end

local function FollowPath(arr)
    for _, p in ipairs(arr) do
        if not State.IsBaristaActive then break end
        WalkToPoint(p)
    end
end

local function FindPrompt(kw, maxD, origin)
    if not CharRef.Root then return nil end
    origin = origin or CharRef.Root.Position; maxD = maxD or 20
    local found, closest = nil, maxD
    for _, v in pairs(Services.Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled
            and string.find(string.lower(v.ActionText), string.lower(kw))
        then
            local part = v.Parent
            if part and part:IsA("BasePart") then
                local d = (part.Position - origin).Magnitude
                if d < closest then closest = d; found = v end
            end
        end
    end
    return found
end

local function DoHold(prompt)
    if not prompt then return false end
    pcall(function()
        prompt:InputHoldBegin()
        rWait((prompt.HoldDuration or 1) + 0.2, (prompt.HoldDuration or 1) + 0.6)
        prompt:InputHoldEnd()
    end)
    rWait(0.1, 0.3); return true
end

local function DoTap(prompt)
    if not prompt then return false end
    pcall(function()
        prompt:InputHoldBegin(); rWait(0.08, 0.18); prompt:InputHoldEnd()
    end)
    rWait(0.2, 0.4); return true
end

local function IsMachineBroken()
    for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        for _, v in pairs(gui:GetDescendants()) do
            if v:IsA("TextLabel") and v.Visible then
                local t = string.lower(v.Text)
                if t:find("machine broke") or t:find("needs maintenance") or t:find("fix machine") then
                    return true
                end
            end
        end
    end
    return false
end

local function HasJob()
    local hasJob = true
    for _, v in pairs(Services.Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled and v.ActionText:lower():find("shift") then
            local part = v.Parent
            if part and part:IsA("BasePart") and (part.Position - Constants.START_SHIFT).Magnitude < 40 then
                hasJob = v.ActionText:lower():find("end") and true or false
                break
            end
        end
    end
    return hasJob
end

local function FindByColor(parent, col, tol)
    local best, bestD = nil, math.huge
    for _, v in pairs(parent:GetDescendants()) do
        if (v:IsA("Frame") or v:IsA("ImageLabel")) and v.Visible and v.BackgroundTransparency < 0.8 then
            local c = v:IsA("ImageLabel") and v.ImageColor3 or v.BackgroundColor3
            local d = math.abs(c.R-col.R) + math.abs(c.G-col.G) + math.abs(c.B-col.B)
            if d < bestD then bestD = d; best = v end
        end
    end
    return bestD < (tol or 0.6) and best or nil
end

-- ============================================================================
-- // 11. AI MINIGAME (BARISTA)
-- ============================================================================
local function StartMinigameAI()
    if State.AiThread then task.cancel(State.AiThread) end
    State.AiThread = task.spawn(function()
        local cam = Services.Workspace.CurrentCamera
        while State.IsBaristaActive do
            task.wait(0.016)
            local gui = LocalPlayer.PlayerGui:FindFirstChild("BaristaGUI")
            if not gui then task.wait(0.1); continue end
            local mf = gui:FindFirstChild("MinigameFrame", true)
            if not (mf and mf.Visible) then task.wait(0.1); continue end

            local cx = (cam.ViewportSize.X/2) + math.random(-15,15)
            local cy = (cam.ViewportSize.Y/2) + math.random(-15,15)
            local pill, bar = nil, nil

            for _, v in pairs(mf:GetDescendants()) do
                if v:IsA("Frame") or v:IsA("ImageLabel") then
                    local nm = v.Name:lower()
                    if nm:find("pill") or nm:find("indicator") or nm:find("player") or nm:find("handle") then pill = v end
                    if nm:find("target") or nm:find("zone") or nm:find("goal") or nm:find("safe") then bar = v end
                end
            end

            if not pill then pill = FindByColor(mf, Constants.COLOR_ORANGE, 0.6) end
            if not bar  then bar  = FindByColor(mf, Constants.COLOR_GREEN,  0.6) end

            if not pill or not bar then
                local els = {}
                for _, v in pairs(mf:GetDescendants()) do
                    if (v:IsA("Frame") or v:IsA("ImageLabel")) and v.Visible
                        and v.BackgroundTransparency < 0.9 and v.AbsoluteSize.Y > 10
                    then table.insert(els, v) end
                end
                table.sort(els, function(a,b) return a.AbsolutePosition.X < b.AbsolutePosition.X end)
                if #els >= 2 then pill = els[1]; bar = els[#els] end
            end

            if pill and bar then
                local diff = (pill.AbsolutePosition.Y + pill.AbsoluteSize.Y/2)
                           - (bar.AbsolutePosition.Y  + bar.AbsoluteSize.Y/2)
                if diff > 6 then
                    Services.VIM:SendMouseButtonEvent(cx,cy,0,true,game,1); task.wait(math.random(55,90)/1000)
                    Services.VIM:SendMouseButtonEvent(cx,cy,0,false,game,1); task.wait(math.random(30,60)/1000)
                elseif diff < -6 then
                    task.wait(0.016)
                else
                    Services.VIM:SendMouseButtonEvent(cx,cy,0,true,game,1); task.wait(math.random(50,80)/1000)
                    Services.VIM:SendMouseButtonEvent(cx,cy,0,false,game,1); task.wait(math.random(80,130)/1000)
                end
            else
                Services.VIM:SendMouseButtonEvent(cx,cy,0,true,game,1); task.wait(math.random(55,90)/1000)
                Services.VIM:SendMouseButtonEvent(cx,cy,0,false,game,1); task.wait(math.random(60,100)/1000)
            end
        end
    end)
end

-- ============================================================================
-- // 12. BARISTA FARMING LOOP
-- ============================================================================
local function TakeJob()
    State.StatusText = "🏃 Walking to start shift..."
    WalkToPoint(Constants.START_SHIFT); rWait(0.4, 0.8)
    local sp = FindPrompt("start shift", 30) or FindPrompt("shift", 30)
    if sp and sp.ActionText:lower():find("start") then
        State.StatusText = "💼 Shift started, let's work!"
        DoTap(sp); rWait(0.8, 1.5)
    end
end

local function HasPendingOrder()
    local mp = Paths.START_TO_MACHINE[#Paths.START_TO_MACHINE]
    return FindPrompt("brewing", 40, mp) or FindPrompt("brew", 40, mp) or FindPrompt("make", 40, mp) ~= nil
end

local function BaristaFarmLoop()
    local isAtCashier = false
    while State.IsBaristaActive do
        if not CharRef.Character or not CharRef.Character.Parent then
            CharRef.Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            CharRef.Humanoid  = CharRef.Character:WaitForChild("Humanoid")
            CharRef.Root      = CharRef.Character:WaitForChild("HumanoidRootPart")
        end

        if not HasJob() then
            State.StatusText = "⚠️ Shift ended, restarting..."
            local dm = (CharRef.Root.Position - Paths.START_TO_MACHINE[#Paths.START_TO_MACHINE]).Magnitude
            local dc = (CharRef.Root.Position - Paths.MACHINE_TO_CASHIER[#Paths.MACHINE_TO_CASHIER]).Magnitude
            FollowPath(dm < dc and Paths.MACHINE_TO_START or Paths.CASHIER_TO_START)
            TakeJob()
            State.StatusText = "🚶 Returning to workstation..."
            FollowPath(Paths.START_TO_MACHINE); isAtCashier = false; continue
        end

        while not HasPendingOrder() and not IsMachineBroken() and State.IsBaristaActive do
            State.StatusText = "Waiting for customers..."; task.wait(1)
        end
        if not State.IsBaristaActive then continue end
        if not HasJob()         then continue end

        if IsMachineBroken() then
            State.StatusText = "Machine broken, fixing..."
            if isAtCashier then FollowPath(Paths.CASHIER_TO_MACHINE); isAtCashier = false end
            State.StatusText = "Walking to repair station..."
            FollowPath(Paths.MACHINE_TO_FIX); rWait(0.4, 0.8)
            local fix = FindPrompt("fix",20) or FindPrompt("repair",20) or FindPrompt("clean",20) or FindPrompt("maintain",20)
            if fix then
                State.StatusText = "Repairing machine..."; DoHold(fix)
            else
                for _, v in pairs(Services.Workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled then
                        local p = v.Parent
                        if p and p:IsA("BasePart") and (p.Position - CharRef.Root.Position).Magnitude < 15 then DoHold(v) end
                    end
                end
            end
            rWait(0.4, 0.8); State.StatusText = "🚶 Returning to work..."
            State.MachineFixCount = (State.MachineFixCount or 0) + 1
            FollowPath(Paths.FIX_TO_MACHINE); continue
        end

        if HasPendingOrder() then
            if isAtCashier then
                State.StatusText = "🚶 Heading to coffee machine..."; FollowPath(Paths.CASHIER_TO_MACHINE); isAtCashier = false
            else
                WalkToPoint(Paths.START_TO_MACHINE[#Paths.START_TO_MACHINE])
            end

            local mp = Paths.START_TO_MACHINE[#Paths.START_TO_MACHINE]
            local bp = FindPrompt("brewing",30,mp) or FindPrompt("brew",30,mp) or FindPrompt("make",30,mp)
            if bp then
                State.StatusText = "Brewing coffee..."; DoTap(bp); rWait(0.8, 1.2)
                while State.IsBaristaActive do
                    local g = LocalPlayer.PlayerGui:FindFirstChild("BaristaGUI")
                    local m = g and g:FindFirstChild("MinigameFrame", true)
                    if not m or not m.Visible then break end; task.wait(0.5)
                end
            end
            rWait(0.8, 1.5)

            State.StatusText = "🥤 Grabbing coffee..."
            local dp = FindPrompt("take",25,mp) or FindPrompt("grab",25,mp)
            if dp then DoTap(dp) end; rWait(0.3, 0.7)

            local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or CharRef.Character:FindFirstChildOfClass("Tool")
            if tool then CharRef.Humanoid:EquipTool(tool) end

            State.StatusText = "🚶 Delivering coffee..."
            FollowPath(Paths.MACHINE_TO_CASHIER); isAtCashier = true

            local attempt = 0
            while CharRef.Character:FindFirstChildOfClass("Tool") and State.IsBaristaActive and attempt < 5 do
                State.StatusText = "Serving coffee..."
                local sp2 = FindPrompt("serve",25) or FindPrompt("deliver",25)
                if sp2 then DoHold(sp2) else break end
                attempt += 1; rWait(0.4, 0.7)
            end

            if not CharRef.Character:FindFirstChildOfClass("Tool") then
                State.OrderCount += 1
                State.StatusText  = "✅ Coffee sold! Total: " .. State.OrderCount
            else
                State.StatusText = "❌ Failed to serve, retrying..."
            end

            local delay = State.ActionDelay + math.random(-5, 10) / 10
            rWait(delay, delay + 0.5)
        end
    end
end

local function StartBaristaScript()
    if State.IsBaristaActive then return end
    State.IsBaristaActive = true
    State.UangAwal = GetPlayerMoney()
    State.UangAwalSession = State.UangAwal
    State.SessionStartTime = os.time()
    State.LastStopReason = ""
    State.MachineFixCount = 0
    task.spawn(function() TakeJob(); StartMinigameAI(); BaristaFarmLoop() end)
end

local function StopBaristaScript(reason)
    local stopReason = reason or "User manually stopped Barista"
    State.IsBaristaActive = false
    State.StatusText = "Idling..."
    State.LastStopReason = stopReason
    if CharRef.Humanoid and CharRef.Root then 
        CharRef.Humanoid:MoveTo(CharRef.Root.Position) 
    end
end

-- ============================================================================
-- // 13. OFFICE JOB SYSTEM (WITH ULTIMATE MATH BYPASS + AFK FIX)
-- ============================================================================
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local function hasText(str, keyword)
    return str and string.find(string.lower(str), string.lower(keyword)) ~= nil
end

local function eksekusiPromptTahan(pp)
    if not pp then return end
    if (pp.HoldDuration or 0) > 0 then
        DoHold(pp)
    else
        DoTap(pp)
    end
end

local myChair            = nil
local CachedTargetLabel  = nil
local CachedTargetParent = nil
local CachedTargetText   = nil

local function isSameChair(obj)
    if not myChair or not obj then return false end
    if obj == myChair then return true end
    if obj:IsAncestorOf(myChair) or myChair:IsAncestorOf(obj) then return true end
    return false
end

local function findNearestChair(radius)
    local origin = CharRef.Root and CharRef.Root.Position
    if not origin then return nil end
    radius = radius or 50
    local best, bestD = nil, radius
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled and hasText(v.ActionText, "sit") then
            local part = v.Parent
            if part and part:IsA("BasePart") then
                local d = (part.Position - origin).Magnitude
                if d < bestD then best, bestD = part, d end
            end
        end
        if v:IsA("Seat") and v:IsA("BasePart") then
            local d = (v.Position - origin).Magnitude
            if d < bestD then best, bestD = v, d end
        end
        if v.Name == "Chair" and v:IsA("Model") then
            local handle = v:FindFirstChild("Handle")
            if handle then
                local d = (handle.Position - origin).Magnitude
                if d < bestD then best, bestD = v, d end
            end
        end
    end
    return best
end

local function findAnotherChair()
    local origin = CharRef.Root and CharRef.Root.Position
    if not origin then return nil end
    local radius = 150
    local best, bestD = nil, radius
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled and hasText(v.ActionText, "sit") then
            local part = v.Parent
            if part and part:IsA("BasePart") and not isSameChair(part) then
                local d = (part.Position - origin).Magnitude
                if d < bestD then best, bestD = part, d end
            end
        end
        if v:IsA("Seat") and v:IsA("BasePart") and not isSameChair(v) then
            local d = (v.Position - origin).Magnitude
            if d < bestD then best, bestD = v, d end
        end
        if v.Name == "Chair" and v:IsA("Model") and not isSameChair(v) then
            local handle = v:FindFirstChild("Handle")
            if handle then
                local d = (handle.Position - origin).Magnitude
                if d < bestD then best, bestD = v, d end
            end
        end
    end
    return best
end

local function jalanKe(pos)
    local root = CharRef.Root
    local hum = CharRef.Humanoid
    if not root or not hum then return false end
    local targetPos = pos + Vector3.new(math.random(-12,12)/10, 0, math.random(-12,12)/10)
    local path = Services.PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true
    })
    local success, _ = pcall(function()
        path:ComputeAsync(root.Position, targetPos)
    end)
    if success and path.Status == Enum.PathStatus.Success then
        for _, waypoint in ipairs(path:GetWaypoints()) do
            if not State.IsOfficeActive then break end
            if waypoint.Action == Enum.PathWaypointAction.Jump then hum.Jump = true end
            hum:MoveTo(waypoint.Position)
            local t = 0
            while (root.Position - waypoint.Position).Magnitude > 3.5 do
                task.wait(0.02); t += 0.02
                if t > 1.5 or not State.IsOfficeActive then break end
            end
        end
        return true
    else
        hum:MoveTo(targetPos)
        hum.MoveToFinished:Wait(3)
        return true
    end
end

local function keluarKursi()
    local hum = CharRef.Humanoid
    if not hum then return end
    if hum.SeatPart then 
        myChair = hum.SeatPart
        task.wait(math.random(10, 20)/10)
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        task.wait(0.3)
    end
end

local function dudukKeKursi(instantTP)
    if not myChair then return false end
    local hum = CharRef.Humanoid
    if not hum then return false end
    
    if hum.SeatPart then return true end
    
    if not instantTP then
        keluarKursi()
    end
    
    local seat = myChair:IsA("Seat") and myChair or myChair:FindFirstChildWhichIsA("Seat") or myChair:FindFirstChildWhichIsA("VehicleSeat")
    local handle = myChair:FindFirstChild("Handle")
    local targetCFrame = seat and seat.CFrame or (handle and handle.CFrame) or myChair.CFrame
    
    if instantTP then
        if CharRef.Root then
            CharRef.Root.CFrame = targetCFrame
            task.wait(0.1)
        end
        if seat then
            seat:Sit(hum)
            task.wait(1.5)
            return true
        else
            for _, child in pairs(myChair:GetChildren()) do
                if child:IsA("ProximityPrompt") and child.Enabled then
                    eksekusiPromptTahan(child)
                    task.wait(1.5)
                    return true
                end
            end
        end
    else
        jalanKe(targetCFrame.Position + Vector3.new(0, 2, 0))
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        if seat then
            seat:Sit(hum)
            task.wait(1.5)
            return true
        else
            for _, child in pairs(myChair:GetChildren()) do
                if child:IsA("ProximityPrompt") and child.Enabled then
                    eksekusiPromptTahan(child)
                    task.wait(1.5)
                    return true
                end
            end
        end
    end
    return false
end

local function normalizeText(str)
    if not str then return "" end
    str = string.gsub(str, "^%s+", "")
    str = string.gsub(str, "%s+$", "")
    str = string.gsub(str, "\n", "")
    str = string.gsub(str, "\r", "")
    return str
end

-- [FIX PATCH 2: OPTIMASI CARI SOAL DENGAN CACHE GUI]
local MathGUICache = nil

local function cariSoalBaru()
    CachedTargetLabel, CachedTargetParent, CachedTargetText = nil, nil, nil
    
    if MathGUICache and MathGUICache.Parent then
        for _, v in pairs(MathGUICache:GetDescendants()) do
            if v:IsA("TextLabel") and v.Visible and v.Text ~= "" then
                if string.find(v.Text, "=") or string.find(v.Text, "%?") then
                    local isMath = string.match(v.Text, "%d+%s*[%+%-%*/xX×÷]%s*%d+")
                    if isMath then
                        CachedTargetLabel  = v
                        CachedTargetParent = v.Parent
                        CachedTargetText   = v.Text
                        return v
                    end
                end
            end
        end
    end

    for _, v in pairs(playerGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Visible and v.Text ~= "" then
            local lowerText = string.lower(v.Text)
            if not (string.find(lowerText, "xp") or string.find(lowerText, "silver") or string.find(lowerText, "level")) then
                if string.find(v.Text, "=") or string.find(v.Text, "%?") then
                    local isMath = string.match(v.Text, "%d+%s*[%+%-%*/xX×÷]%s*%d+")
                    if isMath then
                        MathGUICache = v:FindFirstAncestorOfClass("ScreenGui") or v.Parent
                        CachedTargetLabel  = v
                        CachedTargetParent = v.Parent
                        CachedTargetText   = v.Text
                        return v
                    end
                end
            end
        end
    end
    return nil
end

local function soalCacheValid()
    if not CachedTargetLabel or not CachedTargetLabel.Parent or not CachedTargetLabel.Visible then return false end
    if CachedTargetLabel.Text ~= CachedTargetText then return false end
    return true
end

local function getButtonText(btn)
    if not btn then return "" end
    local rawText = ""
    if btn:IsA("TextButton") then rawText = btn.Text or "" end
    
    if rawText == "" then
        for _, child in pairs(btn:GetDescendants()) do
            if child:IsA("TextLabel") and child.Visible and child.Text ~= "" then
                rawText = child.Text
                break
            end
        end
    end
    
    local numStr = string.match(rawText, "%-?%d+")
    return numStr or rawText
end

-- ============================================================================
-- // BYPASS TOTAL MATEMATIKA (SILENT FIRE UUID) + [FIX PATCH 3: ANTI DROP]
-- ============================================================================
local JobEvents = Services.ReplicatedStorage:WaitForChild("JobEvents")
local CorrectAnswerRemote = JobEvents:WaitForChild("CorrectAnswer")

local function getSafeRemote()
    if not CorrectAnswerRemote or not CorrectAnswerRemote.Parent then
        pcall(function()
            CorrectAnswerRemote = Services.ReplicatedStorage:WaitForChild("JobEvents", 2):WaitForChild("CorrectAnswer", 2)
        end)
    end
    return CorrectAnswerRemote
end

local function extractUUIDs(obj)
    if not obj then return nil, nil end
    local uuidPattern = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
    local foundUUIDs = {}
    
    local function checkVal(val)
        if type(val) == "string" then
            for id in string.gmatch(val, uuidPattern) do
                table.insert(foundUUIDs, id)
            end
        end
    end

    checkVal(obj.Name)
    for _, v in pairs(obj:GetAttributes()) do checkVal(v) end
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then checkVal(obj.Text) end

    for _, child in pairs(obj:GetDescendants()) do
        checkVal(child.Name)
        for _, v in pairs(child:GetAttributes()) do checkVal(v) end
        if child:IsA("TextLabel") or child:IsA("TextButton") then checkVal(child.Text) end
        if child:IsA("ValueBase") then checkVal(child.Value) end
    end
    
    if #foundUUIDs == 0 and obj.Parent then
        checkVal(obj.Parent.Name)
        for _, v in pairs(obj.Parent:GetAttributes()) do checkVal(v) end
    end

    return foundUUIDs[1], foundUUIDs[2]
end

local function SubmitJawabanMath(soalLabel, btn)
    local soalUUID1, soalUUID2 = extractUUIDs(soalLabel)
    local btnUUID1, btnUUID2 = extractUUIDs(btn)
    
    local allUUIDs = {}
    if soalUUID1 then table.insert(allUUIDs, soalUUID1) end
    if soalUUID2 then table.insert(allUUIDs, soalUUID2) end
    if btnUUID1 then table.insert(allUUIDs, btnUUID1) end
    if btnUUID2 then table.insert(allUUIDs, btnUUID2) end
    
    if #allUUIDs >= 2 then
        pcall(function()
            getSafeRemote():FireServer(allUUIDs[1], allUUIDs[2])
        end)
        task.wait(0.05)
        return true
    end
    
    if btn and type(getconnections) == "function" then
        local ok = pcall(function() 
            for _, c in pairs(getconnections(btn.MouseButton1Click)) do c:Fire() end 
            for _, c in pairs(getconnections(btn.Activated)) do c:Fire() end 
        end)
        if ok then task.wait(0.05) return true end
    end
    
    if btn then
        pcall(function()
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local actualX = pos.X + (size.X / 2) + math.random(-3, 3)
            local actualY = pos.Y + (size.Y / 2) + math.random(-3, 3)
            Services.VIM:SendMouseButtonEvent(actualX, actualY, 0, true, game, 1)
            task.wait(0.08)
            Services.VIM:SendMouseButtonEvent(actualX, actualY, 0, false, game, 1)
        end)
        return true
    end
    return false
end

local function hitungSoal(text)
    local cleanText = string.gsub(text, "[xX×]", "*")
    cleanText = string.gsub(cleanText, "÷", "/")
    
    local mathStr = string.match(cleanText, "(%d[%d%s%+%-%*%/]+)")
    if not mathStr then return nil end
    
    mathStr = string.match(mathStr, "^(.+%d)") 
    if not mathStr then return nil end

    local func, err = loadstring("return " .. mathStr)
    if func then
        local success, result = pcall(func)
        if success and type(result) == "number" then
            return result
        end
    end
    return nil
end

local lastActivityTime = tick()
local isSwitching = false
local IDLE_SWITCH_TIME = 60

getgenv().forceStopMath = false
getgenv().isGoingToPrinter = false

task.spawn(function()
    while true do
        task.wait(1)
        if not State.IsOfficeActive then continue end
        if getgenv().isGoingToPrinter or getgenv().forceStopMath or isSwitching then continue end
        if tick() - lastActivityTime > IDLE_SWITCH_TIME then
            isSwitching = true
            getgenv().forceStopMath = true
            keluarKursi()
            local newChair = findAnotherChair()
            if newChair then myChair = newChair end
            dudukKeKursi(false)
            CachedTargetLabel, CachedTargetParent, CachedTargetText = nil, nil, nil
            getgenv().forceStopMath = false
            isSwitching = false
            lastActivityTime = tick()
        end
    end
end)

-- [FIX PATCH 1: ANTI STUCK LOOP]
local lastMathText = "" 

task.spawn(function()
    task.wait(2)
    while true do
        task.wait(0.3)
        if not State.IsOfficeActive or getgenv().forceStopMath or getgenv().isGoingToPrinter then continue end
        local hum = CharRef.Humanoid
        if not hum or not hum.SeatPart then
            if myChair then dudukKeKursi(false) end
            task.wait(1.5)
            continue
        end

        local soalLabel = soalCacheValid() and CachedTargetLabel or cariSoalBaru()
        if not soalLabel then 
            lastMathText = ""
            task.wait(1) 
            continue 
        end

        local text = soalLabel.Text
        
        if text == lastMathText then
            -- Diamkan, biarkan timer AFK 60 detik jalan
        else
            lastMathText = text
            lastActivityTime = tick() 
        end
        
        local availableOptions = {}
        local buttonsList = {}
        
        for _, btn in pairs(playerGui:GetDescendants()) do
            if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Visible then
                local btnText = getButtonText(btn)
                local btnNum = tonumber(btnText)
                if btnNum then
                    table.insert(availableOptions, btnNum)
                    table.insert(buttonsList, {btn = btn, num = btnNum})
                end
            end
        end
        
        local jawaban = hitungSoal(text)
        if not jawaban then
            CachedTargetLabel, CachedTargetParent, CachedTargetText = nil, nil, nil
            continue
        end
        
        local ditemukan = false
        
        for _, data in ipairs(buttonsList) do
            if getgenv().forceStopMath or not State.IsOfficeActive then break end
            if math.abs(data.num - jawaban) < 0.01 then
                ditemukan = true
                
                task.wait(math.random(15, 35) / 10)
                
                if getgenv().forceStopMath or not State.IsOfficeActive then break end
                
                if SubmitJawabanMath(soalLabel, data.btn) then
                    State.OfficeMathSolved = (State.OfficeMathSolved or 0) + 1
                    lastActivityTime = tick()
                end
                
                task.wait(math.random(5, 15) / 10)
                break
            end
        end
        
        CachedTargetLabel, CachedTargetParent, CachedTargetText = nil, nil, nil
    end
end)

local AssignPrintJob = JobEvents:WaitForChild("AssignPrintJob")
local ClearPrintJob = JobEvents:WaitForChild("ClearPrintJob")
local ComputersFolder = workspace:WaitForChild("Computers")

local activePrinterName = nil

AssignPrintJob.OnClientEvent:Connect(function(printerName)
    activePrinterName = printerName
end)

ClearPrintJob.OnClientEvent:Connect(function()
    activePrinterName = nil
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if not State.IsOfficeActive then continue end
        
        if activePrinterName and not getgenv().isGoingToPrinter then
            getgenv().isGoingToPrinter = true
            getgenv().forceStopMath = true
            
            task.wait(math.random(8,18)/10)
            keluarKursi()
            
            local hum = CharRef.Humanoid
            local root = CharRef.Root
            
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            end
            
            local printerPart = nil
            local targetPrompt = nil
            
            for i=1, 15 do
                local printerModel = ComputersFolder:FindFirstChild(activePrinterName)
                if printerModel and printerModel:FindFirstChild("Part") then
                    printerPart = printerModel.Part
                    targetPrompt = printerPart:FindFirstChildOfClass("ProximityPrompt")
                    if targetPrompt then
                        targetPrompt.Enabled = true
                        break
                    end
                end
                task.wait(0.5)
            end
            
            if printerPart and targetPrompt then
                jalanKe(printerPart.Position + Vector3.new(0, 0, 2.5))
                
                if CharRef.Root and printerPart then
                    local lookTarget = Vector3.new(printerPart.Position.X, CharRef.Root.Position.Y, printerPart.Position.Z)
                    CharRef.Root.CFrame = CFrame.lookAt(CharRef.Root.Position, lookTarget)
                    local cam = workspace.CurrentCamera
                    if cam then
                        cam.CameraType = Enum.CameraType.Scriptable
                        cam.CFrame = CFrame.lookAt(CharRef.Root.Position + Vector3.new(0, 3, 0), lookTarget)
                        task.wait(0.1)
                        cam.CameraType = Enum.CameraType.Custom
                    end
                end
                
                task.wait(math.random(4,10)/10)
                eksekusiPromptTahan(targetPrompt)
                State.OfficePrints = (State.OfficePrints or 0) + 1
                
                local timeout = 0
                while activePrinterName and timeout < 10 do
                    task.wait(0.5)
                    timeout += 0.5
                end
            end
            
            local cam = workspace.CurrentCamera
            if cam and cam.CameraType == Enum.CameraType.Scriptable then
                cam.CameraType = Enum.CameraType.Custom
            end
            
            dudukKeKursi(false)
            task.wait(math.random(8,15)/10)
            
            CachedTargetLabel, CachedTargetParent, CachedTargetText = nil, nil, nil
            getgenv().isGoingToPrinter = false
            getgenv().forceStopMath = false
            lastActivityTime = tick()
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(10)
        if State.IsOfficeActive then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("EventEvents"):WaitForChild("GetMyJoinedEvents"):InvokeServer({})
            end)
        end
    end
end)

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer2 = Players.LocalPlayer
local TrackerGui = nil

local CachedMoneyLabel = nil

local function parseNumber(val)
    if not val then return 0 end
    local cleanString = string.gsub(tostring(val), "[^%d%-]", "")
    return tonumber(cleanString) or 0
end

local function formatTime(seconds)
    seconds = tonumber(seconds) or 0
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function CariLabelUang()
    local playerGui = LocalPlayer2:FindFirstChild("PlayerGui")
    if not playerGui then return nil end

    for _, guiObject in ipairs(playerGui:GetDescendants()) do
        if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") then
            local text = guiObject.Text
            if text and string.find(text, "Rp%.") and string.match(text, "%d+") then
                return guiObject
            end
        end
    end
    return nil
end

local function DapatkanUangPemain()
    if CachedMoneyLabel and CachedMoneyLabel.Parent then
        return parseNumber(CachedMoneyLabel.Text)
    end

    CachedMoneyLabel = CariLabelUang()
    if CachedMoneyLabel then
        return parseNumber(CachedMoneyLabel.Text)
    end
    
    return GetPlayerMoney()
end

local function fmtRupiah(num)
    num = tonumber(num) or 0
    if num >= 1e9 then return "Rp" .. string.format("%.1fB", num / 1e9)
    elseif num >= 1e6 then return "Rp" .. string.format("%.1fM", num / 1e6)
    elseif num >= 1e3 then return "Rp" .. string.format("%.1fK", num / 1e3)
    else return "Rp" .. tostring(math.floor(num)) end
end

local function fmtProfit(num)
    num = tonumber(num) or 0
    local sign = num >= 0 and "+" or "-"
    local absNum = math.abs(num)
    if absNum >= 1e9 then return sign .. string.format("%.1fB", absNum / 1e9)
    elseif absNum >= 1e6 then return sign .. string.format("%.1fM", absNum / 1e6)
    elseif absNum >= 1e3 then return sign .. string.format("%.1fK", absNum / 1e3)
    else return sign .. tostring(math.floor(absNum)) end
end

local function fmtShort(num)
    num = tonumber(num) or 0
    if num >= 1e9 then return string.format("%.1fB", num / 1e9)
    elseif num >= 1e6 then return string.format("%.1fM", num / 1e6)
    elseif num >= 1e3 then return string.format("%.1fK", num / 1e3)
    else return tostring(math.floor(num)) end
end

local function buatMonitoringGUI()
    local uangSekarang = DapatkanUangPemain()
    
    if not getgenv().UangAwalDikunci or getgenv().UangAwalDikunci == 0 then
        getgenv().UangAwalDikunci = uangSekarang
    end
    
    getgenv().WaktuMulai = getgenv().WaktuMulai or tick()
    
    local uangAwal = getgenv().UangAwalDikunci

    if TrackerGui and TrackerGui.Parent then TrackerGui:Destroy() end
    TrackerGui = Instance.new("ScreenGui")
    TrackerGui.Name = "KingAkbarTracker"
    TrackerGui.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 220, 0, 0)
    Frame.Position = UDim2.new(1, -16, 0.5, 0)
    Frame.AnchorPoint = Vector2.new(1, 0.5)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BackgroundTransparency = 0.25
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.Parent = TrackerGui

    local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0,8); Corner.Parent = Frame
    local Stroke = Instance.new("UIStroke"); Stroke.Color = Color3.fromRGB(70,70,75); Stroke.Thickness = 1; Stroke.Parent = Frame
    local Padding = Instance.new("UIPadding"); Padding.PaddingTop = UDim.new(0,10); Padding.PaddingBottom = UDim.new(0,10); Padding.PaddingLeft = UDim.new(0,10); Padding.PaddingRight = UDim.new(0,10); Padding.Parent = Frame
    local List = Instance.new("UIListLayout"); List.Padding = UDim.new(0,6); List.SortOrder = Enum.SortOrder.LayoutOrder; List.Parent = Frame

    local H = Instance.new("Frame"); H.Size = UDim2.new(1,0,0,36); H.BackgroundTransparency = 1; H.LayoutOrder = 1; H.Parent = Frame
    local Img = Instance.new("ImageLabel"); Img.Size = UDim2.new(0,36,0,36); Img.Position = UDim2.new(0,0,0.5,-18); Img.BackgroundTransparency = 1; Img.Image = "rbxassetid://84070081307966"; Img.ScaleType = Enum.ScaleType.Fit; Img.ZIndex = 2; Img.Parent = H
    local ImgCorner = Instance.new("UICorner"); ImgCorner.CornerRadius = UDim.new(0,8); ImgCorner.Parent = Img
    local Title = Instance.new("TextLabel"); Title.Size = UDim2.new(1,-42,0,24); Title.Position = UDim2.new(0,42,0.5,-12); Title.BackgroundTransparency = 1; Title.Text = "KING AKBAR"; Title.TextColor3 = Color3.fromRGB(180,180,180); Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = H
    local Div = Instance.new("Frame"); Div.Size = UDim2.new(1,0,0,1); Div.BackgroundColor3 = Color3.fromRGB(70,70,75); Div.BorderSizePixel = 0; Div.LayoutOrder = 2; Div.Parent = Frame

    local function baris(labelKiri, labelKanan, order)
        local R = Instance.new("Frame"); R.Size = UDim2.new(1,0,0,28); R.BackgroundTransparency = 1; R.LayoutOrder = order; R.Parent = Frame
        local L = Instance.new("Frame"); L.Size = UDim2.new(0.5,-3,1,0); L.BackgroundTransparency = 1; L.Parent = R
        local LLab = Instance.new("TextLabel"); LLab.Size = UDim2.new(1,0,0,12); LLab.BackgroundTransparency = 1; LLab.Text = labelKiri; LLab.TextColor3 = Color3.fromRGB(140,140,140); LLab.Font = Enum.Font.GothamMedium; LLab.TextSize = 10; LLab.TextXAlignment = Enum.TextXAlignment.Left; LLab.Parent = L
        local LVal = Instance.new("TextLabel"); LVal.Size = UDim2.new(1,0,0,14); LVal.Position = UDim2.new(0,0,1,-14); LVal.BackgroundTransparency = 1; LVal.Text = "0"; LVal.TextColor3 = Color3.fromRGB(220,220,220); LVal.Font = Enum.Font.GothamBold; LVal.TextSize = 12; LVal.TextXAlignment = Enum.TextXAlignment.Left; LVal.Parent = L
        local Ri = Instance.new("Frame"); Ri.Size = UDim2.new(0.5,-3,1,0); Ri.Position = UDim2.new(0.5,3,0,0); Ri.BackgroundTransparency = 1; Ri.Parent = R
        local RLab = Instance.new("TextLabel"); RLab.Size = UDim2.new(1,0,0,12); RLab.BackgroundTransparency = 1; RLab.Text = labelKanan; RLab.TextColor3 = Color3.fromRGB(140,140,140); RLab.Font = Enum.Font.GothamMedium; RLab.TextSize = 10; RLab.TextXAlignment = Enum.TextXAlignment.Left; RLab.Parent = Ri
        local RVal = Instance.new("TextLabel"); RVal.Size = UDim2.new(1,0,0,14); RVal.Position = UDim2.new(0,0,1,-14); RVal.BackgroundTransparency = 1; RVal.Text = "0"; RVal.TextColor3 = Color3.fromRGB(220,220,220); RVal.Font = Enum.Font.GothamBold; RVal.TextSize = 12; RVal.TextXAlignment = Enum.TextXAlignment.Left; RVal.Parent = Ri
        return LVal, RVal
    end

    local v_initial, v_profit = baris("💵 Initial", "💰 Profit", 4)
    local v_solved, v_prints = baris("📝 Solved", "🖨️ Prints", 5)
    local v_profitH, v_ping = baris("⚡ Profit/H", "📶 Ping", 6)
    local v_fps, v_uptime = baris("🎮 FPS", "⏱️ Uptime", 7)

    v_initial.Text = fmtRupiah(uangAwal)

    task.spawn(function()
        while TrackerGui and TrackerGui.Parent do
            local success, err = pcall(function()
                local currentMoney = DapatkanUangPemain()
                
                if uangAwal == 0 and currentMoney > 0 then
                    getgenv().UangAwalDikunci = currentMoney
                    uangAwal = currentMoney
                    v_initial.Text = fmtRupiah(uangAwal)
                end
                
                local profit = currentMoney - uangAwal
                local uptimeDetik = tick() - getgenv().WaktuMulai
                local uptimeJam = uptimeDetik / 3600
                if uptimeJam < (1/3600) then uptimeJam = (1/3600) end
                
                v_profit.Text = fmtProfit(profit)
                
                if type(State) == "table" then
                    v_solved.Text = tostring(State.OfficeMathSolved or 0)
                    v_prints.Text = tostring(State.OfficePrints or 0)
                else
                    v_solved.Text = "0"
                    v_prints.Text = "0"
                end
                
                v_profitH.Text = fmtShort(profit / uptimeJam)
                
                local pingVal = 0
                pcall(function()
                    pingVal = math.floor(Services.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                end)
                v_ping.Text = pingVal .. " ms"
                
                local fpsVal = 0
                pcall(function()
                    fpsVal = math.floor(workspace:GetRealPhysicsFPS())
                end)
                v_fps.Text = tostring(fpsVal)
                
                v_uptime.Text = formatTime(uptimeDetik)
            end)
            task.wait(1)
        end
    end)
end

local function matikanMonitoring()
    if TrackerGui and TrackerGui.Parent then TrackerGui:Destroy(); TrackerGui = nil end
end

local function StartOfficeScript()
    if State.IsOfficeActive then return end
    State.IsOfficeActive = true
    State.OfficeMathSolved = 0
    State.OfficePrints = 0
    getgenv().fullAuto = true

    CachedMoneyLabel = nil
    getgenv().UangAwalDikunci = nil
    getgenv().WaktuMulai = tick()

    if not CharRef.Humanoid or not CharRef.Humanoid.SeatPart then
        WindUI:Notify({ Title = "🔍 Office", Content = "Finding chair & TP...", Duration = 3 })
        local targetChair = nil
        pcall(function()
            for _, comp in pairs(workspace.Computers:GetChildren()) do
                local chair = comp:FindFirstChild("Chair")
                if chair then
                    targetChair = chair
                    break
                end
            end
        end)

        if targetChair then
            myChair = targetChair
            dudukKeKursi(true)
        else
            local sitPrompt = findNearestChair(60)
            if sitPrompt then
                if sitPrompt:IsA("ProximityPrompt") then
                    myChair = sitPrompt.Parent
                else
                    myChair = sitPrompt
                end
                dudukKeKursi(true)
            else
                WindUI:Notify({ Title = "⚠️ Office", Content = "Chair not found, please sit manually!", Duration = 5 })
            end
        end
    else
        myChair = CharRef.Humanoid.SeatPart
    end

    lastActivityTime = tick()
    buatMonitoringGUI()
    WindUI:Notify({ Title = "✅ Office", Content = "Auto Office started! Initial money scanned.", Duration = 4 })
end

local function StopOfficeScript()
    State.IsOfficeActive = false
    getgenv().fullAuto = false
    getgenv().forceStopMath = false
    getgenv().isGoingToPrinter = false
    
    if CharRef.Humanoid then
        CharRef.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    end

    CachedTargetLabel, CachedTargetParent, CachedTargetText = nil, nil, nil
    CachedMoneyLabel = nil
    getgenv().UangAwalDikunci = nil

    matikanMonitoring()
    WindUI:Notify({ Title = "🛑 Office", Content = "Auto Office stopped.", Duration = 3 })
end

-- ============================================================================
-- // 14. AUTO COURIER (INTEGRATED)
-- ============================================================================
local CourierJob = {
    Name = "Courier",
    TeamId = 11378976,
    X = -5158.57,
    Y = 4.41,
    Z = -3757.87
}

local SELECTED_CAR = "Yamahax-MioSporty"

local function spawnCar()
    Services.ReplicatedStorage:WaitForChild("SpawnCarEvents"):WaitForChild("SpawnCar"):FireServer(SELECTED_CAR)
end

local function findMyMotor()
    local myName = LocalPlayer.Name
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name:match(myName) and v.name:match("Montors") then
            return v
        end
    end
    return nil
end

local function walkToCourier(point, timeout)
    timeout = timeout or 10
    local hum = CharRef.Humanoid
    if not hum then return end
    local t = tick()
    while tick() - t < timeout and State.IsCourierActive do
        local hrp = CharRef.Root
        if hrp and (hrp.Position - point).Magnitude < 5 then break end
        hum:MoveTo(point)
        task.wait(0.5)
    end
end

local function setJob(job)
    pcall(function()
        Services.ReplicatedStorage:WaitForChild("JobEvents"):WaitForChild("TeamChangeRequest")
            :FireServer(job.Name, job.TeamId, 1, 0, "Detector")
    end)
end

local function exitMotor()
    local motor = findMyMotor()
    if not motor then return false end
    local char = LocalPlayer.Character
    if not char then return false end

    local anims = motor:FindFirstChild("Anims")
    if anims then
        pcall(function() anims:FireServer("RemovePlayer", char, nil) end)
        task.wait(0.3)
    end

    local driveSeat = motor:FindFirstChild("DriveSeat", true)
    if driveSeat then
        pcall(function() driveSeat:Sit(nil) end)
        task.wait(0.3)
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        pcall(function() humanoid.Jump = true end)
    end
    return true
end

local function rideMotor()
    local motor = findMyMotor()
    if not motor then return false end
    local char = LocalPlayer.Character
    if not char then return false end

    local anims = motor:FindFirstChild("Anims")
    if anims then
        pcall(function() anims:FireServer("CreatePlayer", char) end)
        task.wait(0.2)
        pcall(function() anims:FireServer("RegisterPlayer", char) end)
        task.wait(0.2)
    end

    local kickstand = motor:FindFirstChild("Kickstand")
    if kickstand then
        pcall(function() kickstand:FireServer("StandUp", 0, 0, 0, 0, false) end)
        task.wait(0.2)
    end

    local driveSeat = motor:FindFirstChild("DriveSeat", true)
    if driveSeat then
        pcall(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = driveSeat.CFrame end
            driveSeat:Sit(char:FindFirstChildOfClass("Humanoid"))
        end)
    end
    return true
end

local function forceDismount()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return end
    hum.Jump = true
    task.wait(0.1)
    if hum.SeatPart then
        char:PivotTo(char:GetPivot() * CFrame.new(0, 2, 0))
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    task.wait(0.2)
end

local function ghostGlideMotor(targetPos)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SeatPart
    local vehicle = seat and seat:FindFirstAncestorOfClass("Model")
    if not (vehicle and vehicle.PrimaryPart) then return end

    local pp = vehicle.PrimaryPart
    local speed = 150
    local glideHeight = targetPos.Y + 3
    local posTujuan = Vector3.new(targetPos.X, glideHeight, targetPos.Z)

    local virtualAnchor = Instance.new("BodyVelocity")
    virtualAnchor.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    virtualAnchor.Velocity = Vector3.new(0, 0, 0)
    virtualAnchor.Parent = pp

    local virtualGyro = Instance.new("BodyGyro")
    virtualGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    virtualGyro.P = 100000
    virtualGyro.Parent = pp

    local noclip = Services.RunService.Stepped:Connect(function()
        if not State.IsCourierActive then return end
        for _, v in pairs(vehicle:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)

    local _, currentYRot, _ = pp.CFrame:ToEulerAnglesYXZ()

    local function glideTo(targetVector, faceForward)
        if not State.IsCourierActive then return end
        local dist = (pp.Position - targetVector).Magnitude
        local timeToMove = dist / speed
        if timeToMove > 0 then
            local startTime = tick()
            while tick() - startTime < timeToMove and State.IsCourierActive do
                if not hum.SeatPart then break end
                local alpha = (tick() - startTime) / timeToMove
                local currentPos = pp.Position:Lerp(targetVector, alpha)
                if faceForward then
                    local dir = (targetVector - pp.Position).Unit
                    local flatDir = Vector3.new(dir.X, 0, dir.Z).Unit
                    if flatDir.Magnitude > 0.001 then
                        local newCFrame = CFrame.lookAt(currentPos, currentPos + flatDir)
                        virtualGyro.CFrame = newCFrame
                        vehicle:PivotTo(newCFrame)
                    end
                else
                    local newCFrame = CFrame.new(currentPos) * CFrame.Angles(0, currentYRot, 0)
                    virtualGyro.CFrame = newCFrame
                    vehicle:PivotTo(newCFrame)
                end
                Services.RunService.Heartbeat:Wait()
            end
        end
    end

    glideTo(posTujuan, true)

    local finalSafeY = targetPos.Y + 3
    local timeout = tick() + 8
    while tick() < timeout and State.IsCourierActive do
        local rayOrigin = Vector3.new(targetPos.X, glideHeight + 5, targetPos.Z)
        local rayResult = workspace:Raycast(rayOrigin, Vector3.new(0, -100, 0))
        if rayResult and rayResult.Instance then
            finalSafeY = rayResult.Position.Y + 1.5
            break
        else
            task.wait(1)
        end
    end

    glideTo(Vector3.new(targetPos.X, finalSafeY, targetPos.Z), false)

    virtualAnchor:Destroy()
    virtualGyro:Destroy()
    noclip:Disconnect()
    pp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    pp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

    forceDismount()
end

local ServiceEventConn = nil

local function startCourierLoop()
    local activePackageLoc = nil
    local activePackageNum = nil

    local serviceEvent = Services.ReplicatedStorage:FindFirstChild("ServiceEvent", true)
    if serviceEvent then
        ServiceEventConn = serviceEvent.OnClientEvent:Connect(function(eventName, action, paketNum)
            if not State.IsCourierActive then return end
            if action == "Create" then
                local Location = workspace:FindFirstChild("Livrason") and workspace.Livrason:FindFirstChild("Location")
                if Location then
                    local paket = Location:FindFirstChild(tostring(paketNum))
                    if paket then
                        local block = paket:FindFirstChild("Block")
                        if block then
                            activePackageLoc = block.Position
                            activePackageNum = paketNum
                        end
                    end
                end
            elseif action == "Remove" then
                if activePackageNum == paketNum then
                    activePackageLoc = nil
                    activePackageNum = nil
                end
            end
        end)
    end

    setJob(CourierJob)
    task.wait(1.5)

    spawnCar()
    task.wait(6)
    rideMotor()
    task.wait(3.5)

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local motor = findMyMotor()
    if not (motor and hrp and State.IsCourierActive) then return end

    local target = CFrame.new(CourierJob.X, CourierJob.Y, CourierJob.Z)
    pcall(function()
        motor:SetPrimaryPartCFrame(target)
        task.wait(0.3)
        hrp.CFrame = target * CFrame.new(0, 2, 0)
    end)

    task.wait(3.5)
    exitMotor()
    task.wait(1.5)

    walkToCourier(Vector3.new(-5109.06, 5.18, -3758.69), 10)
    task.wait(1.5)

    pcall(function()
        local prompt = workspace.Livrason.Take1.Take.ProximityPrompt
        if prompt then
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration + 0.2)
            prompt:InputHoldEnd()
        end
    end)
    task.wait(1.5)

    while State.IsCourierActive do
        local t = tick()
        while State.IsCourierActive and not activePackageLoc and tick() - t < 20 do
            task.wait(0.4)
        end
        if not State.IsCourierActive then break end
        if not activePackageLoc then break end

        spawnCar()
        task.wait(4)
        rideMotor()
        task.wait(3.5)

        ghostGlideMotor(activePackageLoc)
        task.wait(1)

        walkToCourier(activePackageLoc, 20)
        task.wait(2.0)

        local targetNum = activePackageNum
        pcall(function()
            local LocationFolder = workspace.Livrason.Location
            local paketModel = LocationFolder:FindFirstChild(tostring(targetNum))
            if paketModel then
                local block = paketModel:FindFirstChild("Block")
                local prompt = block and block:FindFirstChild("ProximityPrompt")
                if prompt and prompt.Enabled then
                    local box = LocalPlayer.Backpack:FindFirstChild("Box")
                        or LocalPlayer.Character:FindFirstChild("Box")
                        or LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                    if box and CharRef.Humanoid then
                        CharRef.Humanoid:EquipTool(box)
                        task.wait(1.0)
                    end
                    prompt:InputHoldBegin()
                    task.wait(prompt.HoldDuration + 0.2)
                    prompt:InputHoldEnd()
                    State.CourierDelivered = (State.CourierDelivered or 0) + 1
                    task.wait(2.5)
                end
            end
        end)
        task.wait(2.0)
    end

    if ServiceEventConn then
        ServiceEventConn:Disconnect()
        ServiceEventConn = nil
    end
end

local function StartCourierScript()
    if State.IsCourierActive then return end
    State.IsCourierActive = true
    State.CourierDelivered = 0
    task.spawn(startCourierLoop)
end

local function StopCourierScript()
    State.IsCourierActive = false
    if ServiceEventConn then
        ServiceEventConn:Disconnect()
        ServiceEventConn = nil
    end
end

-- ============================================================================
-- // 15. INJECT A-CHASSIS
-- ============================================================================
local function InjectMesin(HP_Mult, RPM_Add, Ratio_Mult, FD_Mult, NamaMode)
    local char = game:GetService("Players").LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart then
        local vehicle = char.Humanoid.SeatPart.Parent
        while vehicle and not vehicle:IsA("Model") do vehicle = vehicle.Parent end
        
        if vehicle then
            local foundTune = false
            
            for _, s in pairs(vehicle:GetDescendants()) do
                if s:IsA("LocalScript") then
                    local name = string.lower(s.Name)
                    if string.find(name, "limit") or string.find(name, "speed") or string.find(name, "cap") then
                        if name ~= "a-chassis interface" and name ~= "drive" then
                            pcall(function() s.Disabled = true s:Destroy() end)
                        end
                    end
                end
            end
            for _, v in pairs(vehicle:GetDescendants()) do
                if v:IsA("ModuleScript") and (v.Name == "Tune" or string.find(string.lower(v.Name), "tune")) then
                    pcall(function()
                        local tune = require(v)
                        if tune.Horsepower then tune.Horsepower = tune.Horsepower * HP_Mult end
                        if tune.Redline then tune.Redline = tune.Redline + RPM_Add end
                        if tune.Ratios then
                            for i, ratio in pairs(tune.Ratios) do
                                if type(ratio) == "number" and ratio > 0 then tune.Ratios[i] = ratio * Ratio_Mult end
                            end
                        end
                        if tune.FinalDrive then tune.FinalDrive = tune.FinalDrive * FD_Mult end
                        if tune.Limiter ~= nil then tune.Limiter = false end
                        if tune.RevLimit then tune.RevLimit = 999999 end
                        if tune.SpeedLimit then tune.SpeedLimit = false end
                        if tune.TopSpeed then tune.TopSpeed = 999999 end
                        if tune.MaxSpeed then tune.MaxSpeed = 999999 end
                        if tune.DragMult then tune.DragMult = tune.DragMult * 0.05 end 
                        if tune.Weight then tune.Weight = tune.Weight * 0.7 end
                        foundTune = true
                    end)
                end
            end
            
            if foundTune then
                WindUI:Notify({ Title = "✅ " .. NamaMode, Content = "Safe! Respawn vehicle to apply.", Duration = 5 })
            else
                WindUI:Notify({ Title = "❌ Injection Failed", Content = "Not a standard A-Chassis.", Duration = 4 })
            end
        end
    else
        WindUI:Notify({ Title = "⚠️ Warning!", Content = "Please enter a vehicle first!", Duration = 3 })
    end
end

-- ============================================================================
-- // 16. UI — 7 TAB (GLOBAL ENGLISH EDITION + COLLAPSED SECTIONS)
-- ============================================================================
local wSz = IsMobile and UDim2.fromOffset(420, 320) or UDim2.fromOffset(580, 460)
local mnSz = IsMobile and Vector2.new(600, 300) or Vector2.new(600, 350)
local mxSz = IsMobile and Vector2.new(650, 400) or Vector2.new(850, 560)

local Window = WindUI:CreateWindow({
    Title                       = "King Akbar - Drag Drive Simulator",
    Icon                        = "crown",
    Author                      = "King Akbar",
    Folder                      = "MySuperHub",
    Size                        = wSz,
    MinSize                     = mnSz,
    MaxSize                     = mxSz,
    Transparent                 = false,
    Background                  = "rbxassetid://127295801178451",
    BackgroundImageTransparency = 0.5,
    Theme                       = "Dark",
    Resizable                   = true,
    SideBarWidth                = 210,
    HideSearchBar               = false,
    ScrollBarEnabled            = true,
})

-- ============================
-- TAB 1: INFO
-- ============================
local TabInfo = Window:Tab({ Title = "Info", Icon = "info", Border = true })

local memberCount = "N/A"
local onlineCount = "N/A"

local function fetchDiscordInfo()
    local req = request or http_request or (syn and syn.request)
    if not req then return end
    local ok, res = pcall(function()
        return req({
            Url     = "https://discord.com/api/v9/invites/XmWf3YQPpZ?with_counts=true",
            Method  = "GET",
            Headers = { ["User-Agent"] = "Mozilla/5.0" }
        })
    end)
    if ok and res and res.StatusCode == 200 then
        local ok2, data = pcall(function() return game:GetService("HttpService"):JSONDecode(res.Body) end)
        if ok2 and data then
            memberCount = tostring(data.approximate_member_count   or "N/A")
            onlineCount = tostring(data.approximate_presence_count or "N/A")
        end
    end
end
fetchDiscordInfo()

local ServerInfo = TabInfo:Paragraph({
    Title         = "King Vypers | Official",
    Desc          = "• Member Count: " .. memberCount .. "\n• Online Count: " .. onlineCount,
    Image         = "rbxassetid://107726435417936",
    Thumbnail     = "rbxassetid://83197533072664",
    ThumbnailSize = 80,
    Buttons = {
        {
            Title    = "Copy Discord Invite",
            Color    = Color3.fromHex("#5707AB"),
            Icon     = "link",
            Callback = function()
                if setclipboard then setclipboard("https://discord.gg/XmWf3YQPpZ") end
            end
        },
        {
            Title    = "Update Info",
            Icon     = "refresh-cw",
            Callback = function()
                fetchDiscordInfo()
                ServerInfo:SetDesc("• Member Count: " .. memberCount .. "\n• Online Count: " .. onlineCount)
            end
        }
    }
})

-- ============================
-- TAB 2: AUTO FARM
-- ============================
local TabFarm = Window:Tab({ Title = "Auto Farm", Icon = "coffee", Border = true })

local SectionBarista = TabFarm:Section({ Title = "Auto Barista", Box = true, BoxBorder = true, Opened = false })
SectionBarista:Toggle({ Title = "Enable Auto Barista", Icon = "play", Value = false, Callback = function(on) if on then StartBaristaScript() else StopBaristaScript() end end })

local SectionOffice = TabFarm:Section({ Title = "Auto Office", Box = true, BoxBorder = true, Opened = false })
SectionOffice:Toggle({ Title = "Enable Auto Office", Icon = "briefcase", Value = false, Callback = function(on) if on then StartOfficeScript() else StopOfficeScript() end end })

local SectionCourier = TabFarm:Section({ Title = "Auto Courier", Box = true, BoxBorder = true, Opened = false })
SectionCourier:Toggle({ Title = "Enable Auto Courier", Icon = "package", Value = false, Callback = function(on) if on then StartCourierScript() else StopCourierScript() end end })

-- ============================
-- TAB 3: SECURITY
-- ============================
local TabSec = Window:Tab({ Title = "Security", Icon = "shield", Border = true })
local Perlindungan = TabSec:Section({ Title = "Protection", Box = true, BoxBorder = true, Opened = false })

Perlindungan:Toggle({ Title = "Anti-Admin (Auto Leave)", Desc = "Automatically leaves if a staff member joins", Icon = "user-minus", Value = true, Callback = function(on) State.AntiAdmin = on end })
Perlindungan:Toggle({ Title = "Anti-AFK", Desc = "Keeps connection active while botting", Icon = "clock", Value = true, Callback = function(on) State.AntiAFK = on end })

-- ============================
-- TAB 4: PERFORMANCE (POWER SAVING + ANTI LAG)
-- ============================
local TabPerf = Window:Tab({ Title = "Performance", Icon = "zap", Border = true })

local HematDaya = TabPerf:Section({ Title = "Power Saving", Box = true, BoxBorder = true, Opened = false })
HematDaya:Toggle({ Title = "Disable Rendering (AFK Mode)", Desc = "Black screen, saves battery, bot keeps running", Value = false, Callback = function(on) ToggleBlackScreen(on) end })

local SectionAntiLag = TabPerf:Section({ Title = "Anti Lag", Box = true, BoxBorder = true, Opened = false })
SectionAntiLag:Toggle({
    Title = "Enable Anti Lag",
    Desc = "Purges particles & locks graphics to minimum for max FPS",
    Value = false,
    Callback = function(on) ToggleAntiLag(on) end
})

-- ============================
-- TAB 5: SETTINGS
-- ============================
local TabCfg = Window:Tab({ Title = "Settings", Icon = "settings", Border = true })

local Konfigurasi = TabCfg:Section({ Title = "Configuration", Box = true, BoxBorder = true, Opened = false })
Konfigurasi:Slider({ Title = "Action Delay (Seconds)", Desc = "Lower is faster, but riskier", Step = 1, Value = { Min = 1, Max = 10, Default = 5 }, Callback = function(v) State.ActionDelay = v end })

local SectionFakeName = TabCfg:Section({ Title = "Spoof Name", Box = true, BoxBorder = true, Opened = false })

SectionFakeName:Input({ 
    Title = "Spoof Name (Empty = King Akbar)", 
    Placeholder = "King Akbar", 
    Callback = function(Text) 
        local cleanText = string.gsub(Text or "", "^%s+", "")
        cleanText = string.gsub(cleanText, "%s+$", "")
        if cleanText == "" then
            State.FakeName = "King Akbar"
        else
            State.FakeName = cleanText
        end
        if State.FakeNameActive then SpoofApplyNow() end
    end 
})

SectionFakeName:Toggle({
    Title = "Enable Spoof Name",
    Desc = "Changes your display name (Client-sided, auto-restore)",
    Value = false,
    Callback = function(on)
        State.FakeNameActive = on
        if on then
            SpoofApplyNow()
            WindUI:Notify({ Title = "🎭 Spoof Name", Content = "Name changed to: " .. State.FakeName, Duration = 3 })
        else
            SpoofDisableNow()
            WindUI:Notify({ Title = "🎭 Spoof Name", Content = "Spoof disabled. Original name restored.", Duration = 3 })
        end
    end
})

local SectionRedeem = TabCfg:Section({ Title = "Auto Redeem", Box = true, BoxBorder = true, Opened = false })

local redeemCodes = {
    "DRAGDRIVESIMULATORJULY26",
    "DDSTHX150KROADTO175KLIKES",
    "DDSDRIVERTAXIONLINEUPDATE",
    "DDSSLAMETRIYADIUPDATE",
    "DELAYXIXIORDERANDOUBLE"
}

local function FireRedeemRemote(code)
    pcall(function()
        local remote = Services.ReplicatedStorage:WaitForChild("RedeemCodeEvents"):WaitForChild("Redeem")
        if remote then
            remote:InvokeServer(code)
        end
    end)
end

SectionRedeem:Button({
    Title = "🎁 Redeem All Codes",
    Desc = "Automatically redeems all available codes",
    Callback = function()
        task.spawn(function()
            WindUI:Notify({ Title = "🔄 Auto Redeem", Content = "Redeeming codes, please wait...", Duration = 3 })
            for _, code in ipairs(redeemCodes) do
                FireRedeemRemote(code)
                task.wait(2)
            end
            WindUI:Notify({ Title = "✅ Auto Redeem", Content = "All codes redeemed successfully!", Duration = 5 })
        end)
    end
})

-- ============================
-- TAB 6: INSTANT MODES
-- ============================
local TabPreset = Window:Tab({ Title = "Instant Modes", Icon = "car", Border = true })
local ModeCepat = TabPreset:Section({ Title = "Presets", Box = true, BoxBorder = true, Opened = false })

ModeCepat:Button({ Title = "🛵 SUNDAY RIDE (Safe)", Callback = function() InjectMesin(1.5, 2000, 0.9, 0.9, "Sunday Ride Active") end })
ModeCepat:Button({ Title = "🏎️ RACING MODE (Aggressive)", Callback = function() InjectMesin(3.5, 5000, 0.75, 0.75, "Racing Mode Active") end })
ModeCepat:Button({ Title = "🚀 GOD MODE (Max Speed)", Callback = function() InjectMesin(8, 15000, 0.45, 0.45, "God Mode Active") end })
ModeCepat:Button({ Title = "🔄 RESET TO DEFAULT", Callback = function() WindUI:Notify({ Title = "ℹ️ Info", Content = "Respawn vehicle from game menu to reset.", Duration = 5 }) end })

-- ============================
-- TAB 7: CUSTOM TUNE
-- ============================
local TabCustom = Window:Tab({ Title = "Custom Tune", Icon = "sliders", Border = true })
local TuneSendiri = TabCustom:Section({ Title = "Manual Tuning", Box = true, BoxBorder = true, Opened = false })

local customHP, customRPM, customRatio, customFD = 2, 5000, 0.8, 0.8
TuneSendiri:Input({ Title = "💪 Horsepower Multiplier", Placeholder = "Example: 3", Callback = function(Text) local val = tonumber(Text) if val then customHP = val end end })
TuneSendiri:Input({ Title = "🔥 RPM Adder", Placeholder = "Example: 8000", Callback = function(Text) local val = tonumber(Text) if val then customRPM = val end end })
TuneSendiri:Input({ Title = "⚙️ Gear Ratio Multiplier", Placeholder = "Example: 0.6", Callback = function(Text) local val = tonumber(Text) if val then customRatio = val end end })
TuneSendiri:Input({ Title = "⛓️ Final Drive Multiplier", Placeholder = "Example: 0.6", Callback = function(Text) local val = tonumber(Text) if val then customFD = val end end })
TuneSendiri:Button({ Title = "⚡ INJECT CUSTOM TUNE", Callback = function() InjectMesin(customHP, customRPM, customRatio, customFD, "Custom Tune Active") end })

-- ============================
-- OPEN BUTTON & FPS TAG
-- ============================
Window:EditOpenButton({
    Title           = "Open King Akbar",
    Icon            = "crown",
    CornerRadius    = UDim.new(0, 12),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#ffffff")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#0a0a0a")),
    }),
    Enabled   = true,
    Draggable = true,
})

local FpsTag = Window:Tag({
    Title = "Fps: ...",
    Color = WindUI:Gradient({
        [0]   = { Color = Color3.fromHex("#0a0a0a"), Transparency = 0 },
        [100] = { Color = Color3.fromHex("#888888"), Transparency = 0 },
    }, { Rotation = 45 }),
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local fps  = math.floor(1 / Services.RunService.RenderStepped:Wait())
            local ping = math.floor(Services.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            if FpsTag and FpsTag.SetTitle then
                FpsTag:SetTitle(("Fps: %d | Ping: %d"):format(fps, ping))
            end
        end)
    end
end)

-- ============================
-- INIT
-- ============================
Window:SetIconSize(47)
WindUI:SetTheme("dark")
TabInfo:Select()

WindUI:Notify({
    Title    = "👑 KING AKBAR V7.9.5 READY!",
    Content  = "Anti-Lag added & Fake Name fixed! Enjoy the boost!",
    Duration = 5,
})
