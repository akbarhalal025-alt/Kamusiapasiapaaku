--[[
================================================================================
  👑 KING AKBAR - ULTIMATE AUTO FARM SCRIPT (NO VIRTUAL INPUT VERSION) 👑
================================================================================
    [+] Developer   : King Akbar
    [+] Game        : Drag Drive Simulator
    [+] Fitur       : + Auto RideGO Driver (Void Gate Ultra + Anti-Kick Stabil)
                      + Silent Humanizer Cycle (Auto Reset Motor Acak 3-7 Trip)
                      + Auto Barista (New AI Minigame + Smart Pathfinding + Auto Zoom)
                      + Auto Courier (100% Fix Drop Paket & Auto Delivered +1)
                      + Auto Office (Anti-AFK + Print & Math Logic)
                      + Universal Monitoring GUI untuk SEMUA JOB
                      + Permanent Noclip (Karakter, Motor, & Penumpang Stepped)
                      + Watchdog 8s: Auto Spawn/Despawn Motor jika Rute Bug
                      + Anti-Kick 3 Lapis (Hook + No Input Spam + Heartbeat Disabled)
                      + Auto-Recovery Respawn Karakter
                      + Discord Webhook Free (Rapi & Real-time)
================================================================================
]]--

-- ============================================================================
-- // SILENT MODE (MATIKAN F9 CONSOLE)
-- ============================================================================
local print = function() end
local warn = function() end
local error = function() end

-- ============================================================================
-- // SAFE DESTROY (ANTI WARNING SPAM - F9 CLEAN)
-- ============================================================================
local function safeDestroy(obj)
    task.defer(function()
        pcall(function()
            if obj and obj.Parent then obj:Destroy() end
        end)
    end)
end

-- ============================================================================
-- // 0. ULTIMATE BYPASS "GACOR" — DDS TARGETED
-- ============================================================================
do
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local RS          = game:GetService("ReplicatedStorage")

    local function BLog(msg)  end
    local function BWarn(msg) end

    -- ── [1] INDEXINSTANCE NEUTRALIZER ──────────────────────────────────
    pcall(function()
        if not getgc then return end
        for _, v in pairs(getgc(true)) do
            pcall(function()
                local idx = rawget(v, "indexInstance")
                if type(idx) == "table" and idx[1] == "kick" then
                    setreadonly(v, false)
                    v.tvk = { "kick", function() return game.Workspace:WaitForChild("") end }
                    BLog("IndexInstance kick dinetralkan")
                end
            end)
        end
    end)

    -- ── [2] HTTP WEBHOOK BLOCKER ───────────────────────────────────────
    pcall(function()
        local requestFunc =
            (syn and syn.request) or http_request or
            (fluxus and fluxus.request) or request or
            (http and http.request)
        if not requestFunc or not hookfunction then return end

        local oldReq = requestFunc
        hookfunction(requestFunc, function(opts)
            local url = string.lower(tostring(opts and (opts.Url or opts.url) or ""))
            local safe = url:find("roblox%.com") or url:find("rbxcdn%.com") or url:find("discord%.com") or url:find("discordapp%.com") or url == ""
            if not safe then
                BWarn("HTTP diblokir: " .. url)
                return { StatusCode = 200, Body = '{"success":true}', Success = true, Headers = {} }
            end
            return oldReq(opts)
        end)
        BLog("HTTP Blocker aktif")
    end)

    -- ── [3] METATABLE HOOK — Anti-Kick + DDS Remote Blocker ───────────
    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end
        local oldNamecall = rawget(mt, "__namecall")
        if not oldNamecall then return end
        if not pcall(setreadonly, mt, false) then return end

        local BLOCK_FIRE = {
            ["admin"]              = true,
            ["reportmessageevent"] = true,
            ["0bde16ec-a0df-43fe-ba4b-b1fca4f092ee"] = true,
        }
        local SPOOF_INVOKE = {
            ["requestadminstatus"] = false,
        }

        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod and getnamecallmethod() or ""

            if (method:lower() == "kick" or method == "Disconnect")
                and tostring(self) == tostring(LocalPlayer)
            then
                if getgenv().allowSelfKick then
                    getgenv().allowSelfKick = false
                    return oldNamecall(self, ...)
                end
                BWarn("Kick diblokir!")
                return nil
            end

            if method == "FireServer" then
                local ok, name = pcall(function()
                    return string.lower(tostring(self.Name))
                end)
                if ok and BLOCK_FIRE[name] then
                    BWarn("FireServer diblokir: " .. name)
                    return nil
                end
            end

            if method == "InvokeServer" then
                local ok, name = pcall(function()
                    return string.lower(tostring(self.Name))
                end)
                if ok and SPOOF_INVOKE[name] ~= nil then
                    BWarn("InvokeServer dispoofed: " .. name)
                    return SPOOF_INVOKE[name]
                end
            end

            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
        BLog("Metatable Hook aktif (Anti-Kick + Remote Blocker)")
    end)

    -- ── [4] WRONGTEAMEVENT INTERCEPTOR ────────────────────────────────
    task.spawn(function()
        local jobEv = RS:WaitForChild("JobEvents", 10)
        if not jobEv then return end
        local wte = jobEv:WaitForChild("WrongTeamEvent", 5)
        if not wte then return end
        wte.OnClientEvent:Connect(function()
            BWarn("WrongTeamEvent dari server — DIABAIKAN")
        end)
        BLog("WrongTeamEvent interceptor aktif")
    end)

    -- ── [5] UUID AC REMOTE NEUTRALIZER ────────────────────────────────
    task.spawn(function()
        local UUID = "0bde16ec-a0df-43fe-ba4b-b1fca4f092ee"
        local rem = RS:WaitForChild(UUID, 5)
        if not rem then BLog("UUID AC tidak aktif sesi ini") return end
        pcall(function()
            if rem:IsA("RemoteEvent") then
                rem.OnClientEvent:Connect(function()
                    BWarn("UUID AC fired — DIABAIKAN")
                end)
            end
        end)
        pcall(function()
            local fn = rem:FindFirstChildWhichIsA("RemoteFunction")
            if fn then fn.OnClientInvoke = function() return nil end end
        end)
        BLog("UUID AC dinetralkan: " .. UUID)
    end)

    -- ── [6] SMART AC SCRIPT KILLER ────────────────────────────────────
    local AC_KW = {
        "adonis","ae_","anticheat","anti_cheat","cheatdetect",
        "adminscript","bansystem","kicksystem","hackdetect",
        "exploitdetect","injectioncheck"
    }
    local killedSet = {}

    local function isAC(name)
        local low = string.lower(name)
        for _, kw in ipairs(AC_KW) do
            if low:find(kw, 1, true) then return true end
        end
        return false
    end

    local function killAC(parent)
        if not parent then return end
        pcall(function()
            for _, v in pairs(parent:GetChildren()) do
                local name = string.lower(v.Name)
                if isAC(name) then
                    pcall(function()
                        if v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("Script") then
                            if not v.Disabled then
                                v.Disabled = true
                                if not killedSet[v] then
                                    BWarn("AC Script dimatikan: " .. v.Name)
                                    killedSet[v] = true
                                end
                            end
                        end
                    end)
                    safeDestroy(v)
                end
            end
        end)
    end

    local gui_services = {
        LocalPlayer:WaitForChild("PlayerGui"),
        game:GetService("CoreGui"),
        gethui and gethui() or game:GetService("CoreGui"),
    }

    for _, svc in ipairs(gui_services) do pcall(killAC, svc) end

    task.spawn(function()
        while task.wait(5) do
            for _, svc in ipairs(gui_services) do pcall(killAC, svc) end
        end
    end)

    for _, svc in ipairs(gui_services) do
        pcall(function()
            svc.ChildAdded:Connect(function(child)
                if isAC(child.Name) then
                    pcall(function()
                        if child:IsA("LocalScript") or child:IsA("ModuleScript") or child:IsA("Script") then
                            child.Disabled = true
                            BWarn("AC Script baru dicegah: " .. child.Name)
                        end
                    end)
                    safeDestroy(child)
                end
            end)
        end)
    end

    BLog("Smart AC Killer aktif (scan 5s + ChildAdded monitor)")

    -- ── [7] EXTERNAL BYPASS ───────────────────────────────────────────
    task.spawn(function()
        local ok1, e1 = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua", true))()
        end)
        BLog(ok1 and "AdonisCries loaded" or "AdonisCries gagal: " .. tostring(e1))

        task.wait(1)

        local ok2, e2 = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/SUUUUUS00000/MEGGD-Anti-kick/refs/heads/main/MEGGD%20Best%20Anti-kick.lua"))()
        end)
        BLog(ok2 and "MEGGD Anti-Kick loaded" or "MEGGD gagal: " .. tostring(e2))
    end)
end

-- ============================================================================
-- // 1. LOAD WINDUI (SAFE)
-- ============================================================================
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
                    Dropdown   = function() end,
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
    Players             = game:GetService("Players"),
    RunService          = game:GetService("RunService"),
    TweenSvc            = game:GetService("TweenService"),
    UserInput           = game:GetService("UserInputService"),
    Stats               = game:GetService("Stats"),
    Workspace           = game:GetService("Workspace"),
    HttpService         = game:GetService("HttpService"),
    GuiService          = game:GetService("GuiService"),
    PathfindingService  = game:GetService("PathfindingService"),
    ReplicatedStorage   = game:GetService("ReplicatedStorage"),
    StarterGui          = game:GetService("StarterGui"),
}

local LocalPlayer = Services.Players.LocalPlayer

local IsMobile = Services.UserInput.TouchEnabled
    and not Services.UserInput.KeyboardEnabled
    and not Services.UserInput.MouseEnabled

local CharRef = {
    Character = nil,
    Humanoid  = nil,
    Root      = nil,
}

local function UpdateCharRef()
    CharRef.Character = LocalPlayer.Character
    if CharRef.Character then
        CharRef.Humanoid = CharRef.Character:WaitForChild("Humanoid", 5)
        CharRef.Root     = CharRef.Character:WaitForChild("HumanoidRootPart", 5)
    end
end
UpdateCharRef()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    UpdateCharRef()
end)

-- ============================================================================
-- // SAFE INPUT SYSTEM (TANPA VIRTUAL USER & MOUSE)
-- ============================================================================
local function SafeClick(x, y, holdTime)
    holdTime = holdTime or 0.05
    pcall(function()
        local gui = LocalPlayer:FindFirstChild("PlayerGui")
        if not gui then return end
        
        for _, button in ipairs(gui:GetDescendants()) do
            if button:IsA("GuiButton") and button.Visible and button.Active then
                local pos = button.AbsolutePosition
                local size = button.AbsoluteSize
                if x >= pos.X and x <= pos.X + size.X and y >= pos.Y and y <= pos.Y + size.Y then
                    if getconnections then
                        for _, signal in ipairs({button.MouseButton1Click, button.Activated}) do
                            for _, conn in ipairs(getconnections(signal)) do
                                if conn.Function then pcall(conn.Function) end
                            end
                        end
                    end
                    return
                end
            end
        end
    end)
end

-- ============================================================================
-- // 3. STATE MANAGER
-- ============================================================================
local State = {
    IsBaristaActive      = false,
    IsOfficeActive       = false,
    IsCourierActive      = false,
    IsRideGOActive       = false,
    AiThread             = nil,
    StatusText           = "Idling...",
    OrderCount           = 0,
    ActionDelay          = 5,
    AntiAFK              = true,
    AntiAdmin            = true,
    UangAwal             = 0,
    UangAwalSession      = 0,
    SessionStartTime     = 0,
    LastStopReason       = "",
    MachineFixCount      = 0,
    OfficeMathSolved     = 0,
    OfficePrints         = 0,
    CourierDelivered     = 0,
    CourierPhase         = "Idle",
    FakeNameActive       = false,
    FakeName             = "King Akbar",
    TargetProfit         = 0,
    RideGOIsOnline       = false,
    RideGOPhase          = "idle",
    RideGOToken          = nil,
    RideGOTargetPos      = nil,
    RideGOTripCount      = 0,
    RideGOEarnings       = 0,

    -- Konfigurasi Rentang Kecepatan (Min & Max Terpisah)
    RideGOMinSpeed       = 180,
    RideGOMaxSpeed       = 220,
    CourierMinSpeed      = 180,
    CourierMaxSpeed      = 220,

    -- Auto Silent Humanizer Cycle (Reset Motor 3-7 Trip)
    NextBikeCycle        = math.random(3, 7),
    CurrentCycleTrips    = 0,

    -- Barista Debug UI
    DebugOverlay         = nil,
    DebugEnabled         = true,
    DebugCursorY         = 0,
    DebugTargetY         = 0,
    DebugTapCount        = 0,
    DebugLastAction      = "idle",
    DebugMinigameActive  = false,
    DebugCursorDelta     = 0,
}

-- ============================================================================
-- // ANTI-KICK & KEEPALIVE (TANPA VIRTUAL INPUT)
-- ============================================================================
pcall(function()
    if not hookmetamethod or not newcclosure or not getnamecallmethod then return end
    local _origNamecall
    _origNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
            if getgenv().allowSelfKick then
                getgenv().allowSelfKick = false
                return _origNamecall(self, ...)
            end
            return nil
        end
        return _origNamecall(self, ...)
    end))
end)

LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(1), 0)
                task.wait(0.05)
                cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(-1), 0)
            end
            if CharRef.Root and CharRef.Humanoid then
                CharRef.Humanoid:MoveTo(CharRef.Root.Position + Vector3.new(1, 0, 0))
                task.wait(0.05)
                CharRef.Humanoid:MoveTo(CharRef.Root.Position - Vector3.new(1, 0, 0))
            end
        end)
    end
end)

-- ============================================================================
-- // 3.5 FAKE NAME SYSTEM
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
    while task.wait(1.5) do
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
-- // 4. HUMANIZATION & SAFE CAMERA FOCUS ZOOM SYSTEM
-- ============================================================================
local function rWait(minSec, maxSec)
    task.wait(math.random((minSec or 0.5) * 1000, (maxSec or 1.5) * 1000) / 1000)
end

local function focusCameraZoom(enable, targetPart)
    local cam = workspace.CurrentCamera
    if not cam then return end
    pcall(function()
        if enable then
            cam.CameraType = Enum.CameraType.Scriptable
            local targetPos = nil
            if targetPart and targetPart:IsA("BasePart") then
                targetPos = targetPart.Position
            elseif CharRef.Root then
                targetPos = CharRef.Root.Position
            end

            if targetPos then
                local forward = (CharRef.Root and CharRef.Root.CFrame.LookVector) or Vector3.new(0, 0, -1)
                local camPos = targetPos - (forward * 3.2) + Vector3.new(0, 1.3, 0)
                cam.CFrame = CFrame.lookAt(camPos, targetPos)
            end
        else
            cam.CameraType = Enum.CameraType.Custom
            if CharRef.Humanoid then
                cam.CameraSubject = CharRef.Humanoid
            end
        end
    end)
end

local function DoHold(prompt, targetPart)
    if not prompt or not prompt.Parent then return false end
    local ok = false
    pcall(function()
        prompt.Enabled = true
        pcall(function()
            prompt.RequiresLineOfSight = false
            if (prompt.MaxActivationDistance or 0) < 30 then
                prompt.MaxActivationDistance = 30
            end
        end)

        local part = targetPart or (prompt.Parent:IsA("BasePart") and prompt.Parent) or CharRef.Root
        focusCameraZoom(true, part)
        task.wait(0.05)

        prompt:InputHoldBegin()
        local duration = (prompt.HoldDuration or 1) + 0.3
        task.wait(duration)
        prompt:InputHoldEnd()
        ok = true
    end)
    focusCameraZoom(false)
    rWait(0.12, 0.25)
    return ok
end

local function DoTap(prompt, targetPart)
    if not prompt or not prompt.Parent then return false end
    local ok = false
    pcall(function()
        prompt.Enabled = true
        pcall(function()
            prompt.RequiresLineOfSight = false
            if (prompt.MaxActivationDistance or 0) < 30 then
                prompt.MaxActivationDistance = 30
            end
        end)

        local part = targetPart or (prompt.Parent:IsA("BasePart") and prompt.Parent) or CharRef.Root
        focusCameraZoom(true, part)
        task.wait(0.05)

        prompt:InputHoldBegin()
        task.wait(0.12)
        prompt:InputHoldEnd()
        ok = true
    end)
    focusCameraZoom(false)
    rWait(0.12, 0.25)
    return ok
end

local function forceDismount()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return end
    hum.Sit = false
    hum.Jump = true
    task.wait(0.1)
    if hum.SeatPart then
        char:PivotTo(char:GetPivot() * CFrame.new(0, 3, 0))
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    task.wait(0.2)
end

-- ============================================================================
-- // 5. GET PLAYER MONEY
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
-- // 6. ADMIN SENSOR
-- ============================================================================
local GAME_GROUP_ID  = 11378976
local MIN_STAFF_RANK = 2

local BlacklistedExactNames = {
    ["slametriyadi"] = true,
    ["admin"]        = true,
    ["moderator"]    = true,
    ["developer"]    = true
}

local function CheckForAdmin(player)
    if not State.AntiAdmin or player == LocalPlayer then return end
    local isStaff = false
    local pName = string.lower(player.Name)
    local dName = string.lower(player.DisplayName)

    if BlacklistedExactNames[pName] or BlacklistedExactNames[dName] then
        isStaff = true
    end

    if not isStaff then
        pcall(function()
            local rank = player:GetRankInGroup(GAME_GROUP_ID)
            if rank >= MIN_STAFF_RANK then isStaff = true end
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
        getgenv().allowSelfKick = true
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
                    getgenv().allowSelfKick = true
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
            { "Welcome, King Akbar!", 1.00 },
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
    START_SHIFT = Vector3.new(-4991.23, 4.29, -715.26),
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
-- // 9. PERFORMANCE SYSTEMS
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

local AntiLagActive = false
local AntiLagConn = nil
local PotatoActive = false
local PotatoConns = {}

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
    if on and PotatoActive then PotatoActive = false end
    AntiLagActive = on
    if on then
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        pcall(function() game:GetService("Lighting").GlobalShadows = false end)
        task.spawn(function()
            for _, v in pairs(Services.Workspace:GetDescendants()) do
                if isLaggy(v) then safeDestroy(v) end
            end
        end)
        if not AntiLagConn then
            AntiLagConn = Services.Workspace.DescendantAdded:Connect(function(v)
                if AntiLagActive and isLaggy(v) then safeDestroy(v) end
            end)
        end
    else
        if AntiLagConn then AntiLagConn:Disconnect(); AntiLagConn = nil end
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
        pcall(function() game:GetService("Lighting").GlobalShadows = true end)
    end
end

local function TogglePotatoMode(on)
    if on and AntiLagActive then ToggleAntiLag(false) end
    PotatoActive = on
    if on then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
            local Lighting = game:GetService("Lighting")
            Lighting.GlobalShadows = false; Lighting.FogEnd = 10
            Lighting.Brightness = 0; Lighting.TimeOfDay = "12:00:00"
            for _, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("Clouds") then
                    pcall(function() v.Enabled = false end)
                end
            end
        end)
        task.spawn(function()
            for _, v in pairs(Services.Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or
                   v:IsA("Explosion") or v:IsA("Beam") or v:IsA("Trail") or
                   v:IsA("Sparkles") or v:IsA("Sound") or v:IsA("Decal") or
                   v:IsA("Texture") or v:IsA("PointLight") or v:IsA("SpotLight") or
                   v:IsA("SurfaceLight") then
                    safeDestroy(v)
                elseif v:IsA("MeshPart") then
                    pcall(function() v.TextureID = ""; v.MeshId = "" end)
                elseif v:IsA("BasePart") then
                    pcall(function() v.Material = Enum.Material.SmoothPlastic end)
                end
            end
        end)
        pcall(function()
            Services.Workspace.Terrain:Clear()
            Services.Workspace.Terrain.WaterWaveSize = 0
        end)
        local c1 = Services.Workspace.DescendantAdded:Connect(function(v)
            if not PotatoActive then return end
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or
               v:IsA("Explosion") or v:IsA("Beam") or v:IsA("Trail") or
               v:IsA("Sparkles") or v:IsA("Sound") or v:IsA("Decal") or
               v:IsA("Texture") or v:IsA("PointLight") or v:IsA("SpotLight") or
               v:IsA("SurfaceLight") then
                safeDestroy(v)
            elseif v:IsA("MeshPart") then
                pcall(function() v.TextureID = ""; v.MeshId = "" end)
            elseif v:IsA("BasePart") then
                pcall(function() v.Material = Enum.Material.SmoothPlastic end)
            end
        end)
        table.insert(PotatoConns, c1)
    else
        for _, conn in ipairs(PotatoConns) do pcall(function() conn:Disconnect() end) end
        PotatoConns = {}
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
        pcall(function()
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").Brightness = 2
        end)
    end
end

-- ============================================================================
-- // 10. AUTO WALK SYSTEM (BARISTA)
-- ============================================================================
local function WalkToPoint(pos, timeoutSec)
    timeoutSec = timeoutSec or 15
    if not CharRef.Humanoid or not CharRef.Root then return false end

    if CharRef.Humanoid.Sit then
        CharRef.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        task.wait(0.2)
    end

    local offset = Vector3.new(math.random(-8,8)/10, 0, math.random(-8,8)/10)
    local target = pos + offset

    local t0 = tick()
    local lastPos = CharRef.Root.Position
    local stuckTime = tick()
    local jumpCooldown = 0

    while tick() - t0 < timeoutSec and State.IsBaristaActive do
        if not CharRef.Humanoid or not CharRef.Root or not CharRef.Root.Parent then return false end

        local myPos = CharRef.Root.Position
        local flatDist = (Vector3.new(myPos.X, 0, myPos.Z) - Vector3.new(target.X, 0, target.Z)).Magnitude

        if flatDist < 3 then
            CharRef.Humanoid:MoveTo(CharRef.Root.Position)
            return true
        end

        if (myPos - lastPos).Magnitude < 0.5 then
            if tick() - stuckTime > 1.5 then
                pcall(function()
                    if tick() > jumpCooldown then
                        CharRef.Humanoid.Jump = true
                        jumpCooldown = tick() + 1
                    end
                end)
                target = pos + Vector3.new(math.random(-20,20)/10, 0, math.random(-20,20)/10)
                stuckTime = tick()
            end
        else
            lastPos = myPos
            stuckTime = tick()
        end

        CharRef.Humanoid:MoveTo(target)
        task.wait(0.1)
    end

    pcall(function()
        if CharRef.Humanoid then CharRef.Humanoid:MoveTo(CharRef.Root.Position) end
    end)
    return false
end

local function FollowPath(pathArray, skipFirst)
    if not pathArray or #pathArray == 0 then return false end
    for i, waypoint in ipairs(pathArray) do
        if not State.IsBaristaActive then return false end
        if skipFirst and i == 1 then continue end
        local ok = WalkToPoint(waypoint, 15)
        if not ok and State.IsBaristaActive then
            task.wait(0.3)
            WalkToPoint(waypoint, 10)
        end
        rWait(0.1, 0.25)
    end
    return true
end

local function FindClosestWaypointIndex(pathArray, currentPos)
    local bestIdx, bestDist = 1, math.huge
    for i, wp in ipairs(pathArray) do
        local d = (Vector3.new(wp.X, 0, wp.Z) - Vector3.new(currentPos.X, 0, currentPos.Z)).Magnitude
        if d < bestDist then bestDist = d; bestIdx = i end
    end
    return bestIdx, bestDist
end

local function SmartFollowPath(pathArray, threshold)
    threshold = threshold or 15
    if not CharRef.Root then return false end
    local idx, dist = FindClosestWaypointIndex(pathArray, CharRef.Root.Position)
    if dist < threshold and idx < #pathArray then
        local sliced = {}
        for i = idx, #pathArray do table.insert(sliced, pathArray[i]) end
        return FollowPath(sliced)
    end
    return FollowPath(pathArray)
end

-- ============================================================================
-- // 11. BARISTA DEBUG OVERLAY
-- ============================================================================
local function CreateDebugOverlay()
    if State.DebugOverlay and State.DebugOverlay.Parent then
        State.DebugOverlay:Destroy()
    end

    local sg = Instance.new("ScreenGui")
    sg.Name = "BaristaDebugOverlay"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 500
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    State.DebugOverlay = sg

    local panel = Instance.new("Frame", sg)
    panel.Name = "Panel"
    panel.Size = UDim2.fromOffset(240, 190)
    panel.Position = UDim2.fromOffset(12, 12)
    panel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    panel.BackgroundTransparency = 0.15
    panel.BorderSizePixel = 0
    panel.Visible = true
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", panel)
    stroke.Color = Color3.fromRGB(60, 200, 100); stroke.Thickness = 1.5

    local title = Instance.new("TextLabel", panel)
    title.Size = UDim2.new(1, 0, 0, 22)
    title.Position = UDim2.fromOffset(0, 6)
    title.BackgroundTransparency = 1
    title.Text = "☕ BARISTA DEBUG MONITOR"
    title.TextColor3 = Color3.fromRGB(80, 220, 130)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Center

    local div = Instance.new("Frame", panel)
    div.Size = UDim2.new(1, -20, 0, 1)
    div.Position = UDim2.fromOffset(10, 30)
    div.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    div.BorderSizePixel = 0

    local function makeRow(yPos, labelTxt, color)
        local row = Instance.new("Frame", panel)
        row.Size = UDim2.new(1, -20, 0, 16)
        row.Position = UDim2.fromOffset(10, yPos)
        row.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0, 110, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelTxt
        lbl.TextColor3 = Color3.fromRGB(140, 140, 155)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local val = Instance.new("TextLabel", row)
        val.Size = UDim2.new(1, -115, 1, 0)
        val.Position = UDim2.fromOffset(115, 0)
        val.BackgroundTransparency = 1
        val.Text = "—"
        val.TextColor3 = color or Color3.fromRGB(230, 230, 235)
        val.Font = Enum.Font.GothamBold
        val.TextSize = 10
        val.TextXAlignment = Enum.TextXAlignment.Right
        return val
    end

    local labels = {}
    labels.status   = makeRow(38,  "Status",       Color3.fromRGB(200, 200, 210))
    labels.mgActive = makeRow(56,  "Minigame",     Color3.fromRGB(220, 180, 60))
    labels.cursor   = makeRow(74,  "Cursor Y",     Color3.fromRGB(80, 180, 255))
    labels.target   = makeRow(92,  "Target Y",     Color3.fromRGB(80, 220, 130))
    labels.delta    = makeRow(110, "Delta",        Color3.fromRGB(230, 130, 130))
    labels.tap      = makeRow(128, "Total Taps",   Color3.fromRGB(230, 200, 80))
    labels.action   = makeRow(146, "Last Action",  Color3.fromRGB(180, 180, 200))
    labels.order    = makeRow(164, "Coffee Sold",  Color3.fromRGB(80, 220, 130))

    local toggleBtn = Instance.new("TextButton", sg)
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.fromOffset(80, 22)
    toggleBtn.Position = UDim2.fromOffset(12, 210)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "🐞 Hide Debug"
    toggleBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
    toggleBtn.Font = Enum.Font.GothamMedium
    toggleBtn.TextSize = 10
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

    toggleBtn.MouseButton1Click:Connect(function()
        State.DebugEnabled = not State.DebugEnabled
        panel.Visible = State.DebugEnabled
        toggleBtn.Text = State.DebugEnabled and "🐞 Hide Debug" or "🐞 Show Debug"
        toggleBtn.Position = State.DebugEnabled
            and UDim2.fromOffset(12, 210)
            or  UDim2.fromOffset(12, 12)
    end)

    task.spawn(function()
        while sg.Parent do
            task.wait(0.1)
            pcall(function()
                labels.status.Text   = State.StatusText or "idle"
                labels.status.TextColor3 = State.IsBaristaActive
                    and Color3.fromRGB(80, 220, 130)
                    or  Color3.fromRGB(180, 180, 190)

                labels.mgActive.Text = State.DebugMinigameActive and "AKTIF 🟢" or "OFF ⚪"
                labels.mgActive.TextColor3 = State.DebugMinigameActive
                    and Color3.fromRGB(80, 220, 130)
                    or  Color3.fromRGB(120, 120, 130)

                labels.cursor.Text = string.format("%.0f px", State.DebugCursorY)
                labels.target.Text = string.format("%.0f px", State.DebugTargetY)

                local delta = State.DebugCursorDelta
                labels.delta.Text = string.format("%.0f px", delta)
                if math.abs(delta) < 5 then
                    labels.delta.TextColor3 = Color3.fromRGB(80, 220, 130)
                elseif math.abs(delta) < 30 then
                    labels.delta.TextColor3 = Color3.fromRGB(230, 200, 80)
                else
                    labels.delta.TextColor3 = Color3.fromRGB(230, 90, 90)
                end

                labels.tap.Text = tostring(State.DebugTapCount)
                labels.action.Text = State.DebugLastAction or "idle"
                labels.order.Text = tostring(State.OrderCount or 0)
            end)
        end
    end)
end

local function DestroyDebugOverlay()
    if State.DebugOverlay and State.DebugOverlay.Parent then
        State.DebugOverlay:Destroy()
        State.DebugOverlay = nil
    end
end

-- ============================================================================
-- // 12. BARISTA AI MINIGAME & LOGIC
-- ============================================================================
local function StartMinigameAI()
    if State.AiThread then task.cancel(State.AiThread) end
    State.DebugTapCount = 0
    State.AiThread = task.spawn(function()
        while State.IsBaristaActive do
            task.wait(0.02)
            local gui = LocalPlayer.PlayerGui:FindFirstChild("BaristaGUI")
            if not gui then
                State.DebugMinigameActive = false
                task.wait(0.1); continue
            end
            local mf = gui:FindFirstChild("MinigameFrame", true)
            if not (mf and mf.Visible) then
                State.DebugMinigameActive = false
                task.wait(0.1); continue
            end

            State.DebugMinigameActive = true

            local tapZone    = mf:FindFirstChild("TapZone", true)
            local bgBar      = mf:FindFirstChild("BackgroundBar", true)
            local targetZone = bgBar and bgBar:FindFirstChild("TargetZone")
            local cursor     = bgBar and bgBar:FindFirstChild("PlayerCursor")

            if tapZone and targetZone and cursor then
                local cursorY  = cursor.AbsolutePosition.Y + cursor.AbsoluteSize.Y / 2
                local tzTop    = targetZone.AbsolutePosition.Y
                local tzHeight = targetZone.AbsoluteSize.Y
                local tzCenter = tzTop + tzHeight / 2

                State.DebugCursorY = cursorY
                State.DebugTargetY = tzCenter
                State.DebugCursorDelta = cursorY - tzCenter

                if cursorY > tzCenter + 2 then
                    pcall(function()
                        if getconnections then
                            for _, c in ipairs(getconnections(tapZone.MouseButton1Down)) do
                                if c.Function then c.Function() end
                            end
                        end
                        if firesignal then firesignal(tapZone.MouseButton1Down) end
                    end)
                    State.DebugTapCount = State.DebugTapCount + 1
                    State.DebugLastAction = "TAP ⚡"
                else
                    State.DebugLastAction = "WAIT ⏳"
                end
            else
                State.DebugLastAction = "NO UI ❌"
            end
        end
        State.DebugMinigameActive = false
    end)
end

local BaristaRefs = {}

local function RefreshBaristaRefs()
    local job = workspace:FindFirstChild("BaristaJob")
    local inter = job and job:FindFirstChild("Interactions")
    if not inter then return false end

    local sp = inter:FindFirstChild("StartPart")
    sp = sp and sp:FindFirstChild("StartPart")
    BaristaRefs.JobPrompt = sp and sp:FindFirstChild("JobPrompt")

    local mach = inter:FindFirstChild("MachinePart")
    mach = mach and mach:FindFirstChild("MachinePart")
    BaristaRefs.MachinePart   = mach
    BaristaRefs.MachinePrompt = mach and mach:FindFirstChild("MachinePrompt")

    local reg = inter:FindFirstChild("RegisterPart")
    reg = reg and reg:FindFirstChild("RegisterPart")
    BaristaRefs.RegisterPart   = reg
    BaristaRefs.RegisterPrompt = reg and reg:FindFirstChild("RegisterPrompt")

    local sup = inter:FindFirstChild("SupplyPart")
    sup = sup and sup:FindFirstChild("SupplyPart")
    BaristaRefs.SupplyPart   = sup
    BaristaRefs.SupplyPrompt = sup and sup:FindFirstChild("SupplyPrompt")

    return BaristaRefs.JobPrompt ~= nil
end

local function HasJobActive()
    local p = BaristaRefs.JobPrompt
    if not p or not p.ActionText then return false end
    return p.ActionText:lower():find("end") ~= nil
end

local function HasPendingOrder()
    local p = BaristaRefs.MachinePrompt
    return p and p.Enabled or false
end

local function NeedsRestock()
    local s = BaristaRefs.SupplyPrompt
    return s and s.Enabled or false
end

local function CanServe()
    local r = BaristaRefs.RegisterPrompt
    return r and r.Enabled or false
end

local function TriggerPrompt(prompt, keepCameraLocked)
    if not prompt or not prompt.Parent then return false end
    local ok = false
    pcall(function()
        prompt.Enabled = true
        pcall(function()
            prompt.RequiresLineOfSight = false
            if (prompt.MaxActivationDistance or 0) < 30 then prompt.MaxActivationDistance = 30 end
        end)
        
        -- Kamera mengunci ke part sebelum ditekan
        if prompt.Parent and prompt.Parent:IsA("BasePart") then
            focusCameraZoom(true, prompt.Parent)
            task.wait(0.05)
        end
        
        prompt:InputHoldBegin()
        task.wait((prompt.HoldDuration or 0.1) + 0.15)
        prompt:InputHoldEnd()
        ok = true
    end)
    rWait(0.15, 0.3)
    
    -- Kembalikan kamera jika tidak disuruh ditahan
    if not keepCameraLocked then
        focusCameraZoom(false)
    end
    
    return ok
end

local function BaristaFarmLoop()
    local lastLocation = "unknown"

    while State.IsBaristaActive do
        if not CharRef.Character or not CharRef.Character.Parent then
            UpdateCharRef(); task.wait(0.5)
        end
        if not RefreshBaristaRefs() then
            State.StatusText = "Loading BaristaJob..."
            task.wait(1); continue
        end

        if not HasJobActive() then
            State.StatusText = "🏃 Jalan ke Start Shift..."
            State.DebugLastAction = "GO START"
            if lastLocation ~= "start" then
                if lastLocation == "machine" then
                    SmartFollowPath(Paths.MACHINE_TO_START)
                elseif lastLocation == "cashier" then
                    SmartFollowPath(Paths.CASHIER_TO_START)
                elseif lastLocation == "supply" then
                    SmartFollowPath(Paths.FIX_TO_MACHINE)
                    SmartFollowPath(Paths.MACHINE_TO_START)
                else
                    WalkToPoint(Constants.START_SHIFT, 20)
                end
                lastLocation = "start"
            end

            rWait(0.5, 1)
            local p = BaristaRefs.JobPrompt
            if p and p.Enabled and p.ActionText:lower():find("start") then
                State.StatusText = "💼 Mulai shift..."
                State.DebugLastAction = "START SHIFT"
                TriggerPrompt(p)
                rWait(1.5, 2.5)
                State.StatusText = "🚶 Jalan ke mesin..."
                SmartFollowPath(Paths.START_TO_MACHINE)
                lastLocation = "machine"
            end
            continue
        end

        if CanServe() then
            State.StatusText = "☕ Jalan ke kasir..."
            State.DebugLastAction = "GO CASHIER"
            if lastLocation ~= "cashier" then
                SmartFollowPath(Paths.MACHINE_TO_CASHIER)
                lastLocation = "cashier"
            end

            rWait(0.3, 0.6)
            local r = BaristaRefs.RegisterPrompt
            if r and r.Enabled then
                TriggerPrompt(r)
                State.OrderCount = (State.OrderCount or 0) + 1
                State.StatusText = "✅ Terkirim! Total: " .. State.OrderCount
                State.DebugLastAction = "SERVED"
                rWait(1, 1.5)
            end
            continue
        end

        if NeedsRestock() then
            State.StatusText = "🔧 Jalan ke supply (fix mesin)..."
            State.DebugLastAction = "GO FIX"
            if lastLocation == "cashier" then
                SmartFollowPath(Paths.CASHIER_TO_MACHINE)
            end
            SmartFollowPath(Paths.MACHINE_TO_FIX)
            lastLocation = "supply"

            rWait(0.4, 0.8)
            local s = BaristaRefs.SupplyPrompt
            if s and s.Enabled then
                TriggerPrompt(s)
                State.MachineFixCount = (State.MachineFixCount or 0) + 1
                State.StatusText = "✅ Mesin diperbaiki!"
                State.DebugLastAction = "FIXED"

                State.StatusText = "🚶 Balik ke mesin..."
                SmartFollowPath(Paths.FIX_TO_MACHINE)
                lastLocation = "machine"
                rWait(0.5, 1)
            end
            continue
        end

        if HasPendingOrder() then
            State.StatusText = "☕ Jalan ke mesin (brew)..."
            State.DebugLastAction = "GO BREW"
            if lastLocation == "cashier" then
                SmartFollowPath(Paths.CASHIER_TO_MACHINE)
            elseif lastLocation == "supply" then
                SmartFollowPath(Paths.FIX_TO_MACHINE)
            elseif lastLocation == "start" then
                SmartFollowPath(Paths.START_TO_MACHINE)
            else
                WalkToPoint(BaristaRefs.MachinePart.Position + Vector3.new(0,0,2), 10)
            end
            lastLocation = "machine"

            rWait(0.3, 0.6)
            local m = BaristaRefs.MachinePrompt
            if m and m.Enabled then
                State.StatusText = "🍺 Brewing..."
                State.DebugLastAction = "BREWING"
                
                -- Tahan kamera (Lock) selama proses Minigame
                TriggerPrompt(m, true)
                
                local t = 0
                while State.IsBaristaActive and t < 30 do
                    task.wait(0.3); t += 0.3
                    if CanServe() or NeedsRestock() then break end
                    if not HasJobActive() then break end
                end
                
                -- Lepaskan kamera saat Minigame selesai
                focusCameraZoom(false)
            end
            continue
        end

        if lastLocation == "unknown" or lastLocation == "start" then
            State.StatusText = "🚶 Jalan ke standby..."
            State.DebugLastAction = "STANDBY"
            WalkToPoint(BaristaRefs.MachinePart and BaristaRefs.MachinePart.Position + Vector3.new(0,0,3), 15)
            lastLocation = "machine"
            continue
        end

        State.StatusText = "⏳ Nunggu pelanggan..."
        State.DebugLastAction = "IDLE"
        task.wait(1)
    end

    State.DebugMinigameActive = false
    focusCameraZoom(false)
end

-- ============================================================================
-- // 13. OFFICE JOB SYSTEM & MONITORING
-- ============================================================================
local playerGui       = LocalPlayer:WaitForChild("PlayerGui")
local ComputersFolder = workspace:WaitForChild("Computers")

local function eksekusiPromptTahan(pp)
    if not pp then return end
    if (pp.HoldDuration or 0) > 0 then DoHold(pp, pp.Parent) else DoTap(pp, pp.Parent) end
end

local myChair = nil

local function jalanKe(pos)
    local root = CharRef.Root
    local hum = CharRef.Humanoid
    if not root or not hum then return false end
    local targetPos = pos + Vector3.new(math.random(-12,12)/10, 0, math.random(-12,12)/10)
    local path = Services.PathfindingService:CreatePath({
        AgentRadius = 2, AgentHeight = 5, AgentCanJump = true
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

local function getSeatFromChair(chair)
    if not chair then return nil end
    if chair:IsA("Seat") or chair:IsA("VehicleSeat") then return chair end
    return chair:FindFirstChildWhichIsA("Seat") or chair:FindFirstChildWhichIsA("VehicleSeat")
end

local function findOfficeSeat(excludeSeat)
    local origin = CharRef.Root and CharRef.Root.Position
    if not origin then return nil end
    local best, bestD = nil, math.huge
    for _, v in pairs(ComputersFolder:GetDescendants()) do
        if v:IsA("Model") and v.Name == "Setup" then
            local seat = v:FindFirstChild("Seat", true)
            if seat and seat:IsA("Seat") and seat ~= excludeSeat then
                if not seat.Occupant or seat.Occupant == CharRef.Humanoid then
                    local d = (seat.Position - origin).Magnitude
                    if d < bestD then bestD = d; best = seat end
                end
            end
        end
    end
    return best
end

local function joinOfficeTeam()
    pcall(function()
        Services.ReplicatedStorage:WaitForChild("JobEvents")
            :WaitForChild("TeamChangeRequest")
            :FireServer("Office Worker", 0, 1, 0, "")
    end)
end

local function dudukKeKursi(instantTP)
    local hum = CharRef.Humanoid
    if not hum then return false end
    if hum.SeatPart then return true end

    if State.IsOfficeActive then
        if not myChair or (myChair.Occupant and myChair.Occupant ~= hum) then
            myChair = findOfficeSeat()
        end
    end

    if not myChair then return false end
    if not instantTP then keluarKursi() end

    local seat = getSeatFromChair(myChair)
    local handle = myChair:FindFirstChild("Handle")
    local targetCFrame = seat and seat.CFrame
        or (handle and handle.CFrame)
        or (myChair:IsA("BasePart") and myChair.CFrame)
        or (myChair.PrimaryPart and myChair.PrimaryPart.CFrame)

    if not targetCFrame then return false end

    if instantTP then
        if CharRef.Root then CharRef.Root.CFrame = targetCFrame; task.wait(0.1) end
        if seat then seat:Sit(hum); task.wait(1.5); return true
        else
            for _, child in pairs(myChair:GetChildren()) do
                if child:IsA("ProximityPrompt") and child.Enabled then
                    eksekusiPromptTahan(child); task.wait(1.5); return true
                end
            end
        end
    else
        jalanKe(targetCFrame.Position + Vector3.new(0, 2, 0))
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        if seat then seat:Sit(hum); task.wait(1.5); return true
        else
            for _, child in pairs(myChair:GetChildren()) do
                if child:IsA("ProximityPrompt") and child.Enabled then
                    eksekusiPromptTahan(child); task.wait(1.5); return true
                end
            end
        end
    end
    return false
end

-- ============================================================================
-- // AUTO JAWAB SOAL MATEMATIKA (OFFICE)
-- ============================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local JobEvents = ReplicatedStorage:WaitForChild("JobEvents")
local GenerateQuestion = JobEvents:WaitForChild("GenerateQuestion")

local function evaluateMath(text)
    local cleanText = string.gsub(text, "<[^>]+>", "")
    cleanText = string.gsub(cleanText, "%s+", "")
    local a, op, b = string.match(cleanText, "(%-?%d+%.?%d*)([%+%-])(%-?%d+%.?%d*)")
    if not a or not op or not b then return nil end
    a, b = tonumber(a), tonumber(b)
    if op == "+" then return a + b
    elseif op == "-" then return a - b end
    return nil
end

local function getAnswerButtons()
    local gui = LocalPlayer.PlayerGui:FindFirstChild("WorkGui")
    local frame = gui and gui:FindFirstChild("Frame")
    if not frame then return {} end
    local list = {}
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("GuiButton") then table.insert(list, child) end
    end
    return list
end

local function findCorrectButton(jawaban, timeoutSec)
    local deadline = tick() + (timeoutSec or 2.5)
    while tick() < deadline do
        for _, btn in ipairs(getAnswerButtons()) do
            local numText = string.match(tostring(btn.Text or ""), "%-?%d+%.?%d*")
            if tonumber(numText) == jawaban and btn:IsDescendantOf(game) then
                return btn
            end
        end
        task.wait(0.1)
    end
    return nil
end

local function clearHighlights()
    local gui = LocalPlayer.PlayerGui:FindFirstChild("WorkGui")
    if not gui then return end
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj.Name == "AutoMathHighlight" then safeDestroy(obj) end
    end
end

local function highlightButton(btn)
    clearHighlights()
    local stroke = Instance.new("UIStroke")
    stroke.Name = "AutoMathHighlight"
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = btn
    TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Thickness = 7}):Play()
end

local function unhighlightLater(btn, delaySec)
    task.delay(delaySec, function()
        local s = btn:FindFirstChild("AutoMathHighlight")
        if s then
            TweenService:Create(s, TweenInfo.new(0.2), {Thickness = 0}):Play()
            task.delay(0.25, function() safeDestroy(s) end)
        end
    end)
end

local function pressButton(btn)
    if getconnections then
        for _, signal in ipairs({btn.MouseButton1Click, btn.Activated}) do
            for _, conn in ipairs(getconnections(signal)) do
                if conn.Function then
                    if pcall(conn.Function) then return "handler-asli" end
                end
            end
        end
    end
    return nil
end

local lastActivityTime = tick()

GenerateQuestion.OnClientEvent:Connect(function(questionText, answerData, sessionID)
    if State and State.IsOfficeActive == false then return end
    lastActivityTime = tick()

    local jawaban = evaluateMath(questionText)
    if not jawaban then return end

    local correctButton = findCorrectButton(jawaban, 2.5)
    if correctButton then highlightButton(correctButton) end
    task.wait(math.random(15, 25) / 10)

    if correctButton then
        local reText = string.match(tostring(correctButton.Text or ""), "%-?%d+%.?%d*")
        if not correctButton:IsDescendantOf(game) or tonumber(reText) ~= jawaban then
            correctButton = findCorrectButton(jawaban, 0.5)
        end
    end

    if correctButton then
        pressButton(correctButton)
        unhighlightLater(correctButton, 0.4)
    else
        clearHighlights()
    end

    if State then State.OfficeMathSolved = (State.OfficeMathSolved or 0) + 1 end
end)

-- ============================================================================
-- // OFFICE STABILITY ENGINE
-- ============================================================================
task.spawn(function()
    while true do
        task.wait(2.5)
        if not State.IsOfficeActive then continue end
        if getgenv().isGoingToPrinter or isSwitching then continue end

        local hum = CharRef.Humanoid
        if not hum then continue end

        if not hum.SeatPart then
            pcall(function()
                local seat = findOfficeSeat(nil)
                if seat then
                    myChair = seat
                    jalanKe(seat.CFrame.Position + Vector3.new(0, 2, 0))
                    task.wait(0.3)
                    if CharRef.Humanoid then seat:Sit(CharRef.Humanoid) end
                end
            end)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if not State.IsOfficeActive then return end
    task.wait(3)
    if not State.IsOfficeActive then return end

    local seat = findOfficeSeat(nil)
    if seat then
        myChair = seat
        pcall(function()
            jalanKe(seat.CFrame.Position + Vector3.new(0, 2, 0))
            task.wait(0.3)
            seat:Sit(CharRef.Humanoid)
        end)
    end
    lastActivityTime = tick()
end)

local isSwitching = false
local IDLE_SWITCH_TIME = 60

getgenv().forceStopMath = false
getgenv().isGoingToPrinter = false

task.spawn(function()
    while true do
        task.wait(2)
        if not State.IsOfficeActive then continue end
        if getgenv().isGoingToPrinter or getgenv().forceStopMath or isSwitching then continue end
        if tick() - lastActivityTime > IDLE_SWITCH_TIME then
            isSwitching = true
            getgenv().forceStopMath = true
            keluarKursi()
            local newSeat = findOfficeSeat(myChair)
            if newSeat then myChair = newSeat end
            dudukKeKursi(false)
            getgenv().forceStopMath = false
            isSwitching = false
            lastActivityTime = tick()
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(5)
        if not State.IsOfficeActive then continue end
        if getgenv().isGoingToPrinter then
            getgenv().printWatchdog = getgenv().printWatchdog or tick()
            if tick() - getgenv().printWatchdog > 45 then
                getgenv().isGoingToPrinter = false
                getgenv().forceStopMath = false
                getgenv().printWatchdog = nil
                activePrinterName = nil
                lastActivityTime = tick()
            end
        else
            getgenv().printWatchdog = nil
        end
    end
end)

-- ============================================================================
-- // PRINTER LOOP
-- ============================================================================
local AssignPrintJob = JobEvents:WaitForChild("AssignPrintJob")
local ClearPrintJob  = JobEvents:WaitForChild("ClearPrintJob")
local activePrinterName = nil
local printerRetryCount = 0
local MAX_PRINTER_RETRY = 3
local printerCooldownUntil = 0

AssignPrintJob.OnClientEvent:Connect(function(printerName)
    if tick() < printerCooldownUntil then return end
    activePrinterName = printerName
    printerRetryCount = 0
end)

ClearPrintJob.OnClientEvent:Connect(function()
    activePrinterName = nil
    printerRetryCount = 0
end)

task.spawn(function()
    while true do
        task.wait(0.8)
        if not State.IsOfficeActive then continue end

        if activePrinterName and not getgenv().isGoingToPrinter then
            if printerRetryCount >= MAX_PRINTER_RETRY then
                activePrinterName = nil
                printerRetryCount = 0
                getgenv().isGoingToPrinter = false
                getgenv().forceStopMath = false
                lastActivityTime = tick()
                continue
            end

            getgenv().isGoingToPrinter = true
            getgenv().forceStopMath = true
            getgenv().printWatchdog = tick()
            printerRetryCount = printerRetryCount + 1

            pcall(function()
                task.wait(math.random(3,7)/10)

                local hum = CharRef.Humanoid
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                    if hum.SeatPart then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait(0.4)
                    end
                end

                local printerPart = nil
                local targetPrompt = nil
                local currentPrinterName = activePrinterName

                for i = 1, 10 do
                    if not activePrinterName or activePrinterName ~= currentPrinterName then break end
                    local printerModel = ComputersFolder:FindFirstChild(activePrinterName)
                    if printerModel then
                        printerPart = printerModel:FindFirstChild("Part")
                        if printerPart then
                            targetPrompt = printerPart:FindFirstChildOfClass("ProximityPrompt")
                            if targetPrompt then break end
                        end
                    end
                    task.wait(0.5)
                end

                if printerPart and targetPrompt and activePrinterName then
                    targetPrompt.Enabled = true
                    jalanKe(printerPart.Position + Vector3.new(0, 0, 2.5))

                    if CharRef.Root then
                        local look = Vector3.new(printerPart.Position.X, CharRef.Root.Position.Y, printerPart.Position.Z)
                        CharRef.Root.CFrame = CFrame.lookAt(CharRef.Root.Position, look)
                    end

                    task.wait(0.3)
                    eksekusiPromptTahan(targetPrompt)
                    State.OfficePrints = (State.OfficePrints or 0) + 1

                    local t = 0
                    while activePrinterName == currentPrinterName and t < 12 do
                        task.wait(0.5); t = t + 0.5
                    end

                    printerRetryCount = 0
                end
            end)

            pcall(function()
                local hum = CharRef.Humanoid
                if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end

                local seat = findOfficeSeat(nil)
                if seat then
                    myChair = seat
                    jalanKe(seat.CFrame.Position + Vector3.new(0, 2, 0))
                    task.wait(0.3)
                    if CharRef.Humanoid then seat:Sit(CharRef.Humanoid) end
                end
            end)

            getgenv().isGoingToPrinter = false
            getgenv().forceStopMath = false
            getgenv().printWatchdog = nil
            lastActivityTime = tick()
            printerCooldownUntil = tick() + 8
        end
    end
end)

-- ============================================================================
-- // 14. MONITORING GUI (RAPIH & MULTI-JOB)
-- ============================================================================
local CoreGui2 = (gethui and gethui()) or game:GetService("CoreGui")
local TrackerGui = nil
local CachedMoneyLabel = nil
local DisplayedValues = {}

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
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not pGui then return nil end
    for _, guiObject in ipairs(pGui:GetDescendants()) do
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
    if CachedMoneyLabel then return parseNumber(CachedMoneyLabel.Text) end
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

local function animateValue(label, targetNum, formatter, colorPos, colorNeg, colorNeutral)
    targetNum = tonumber(targetNum) or 0
    local key = label
    if DisplayedValues[key] == nil then DisplayedValues[key] = targetNum end
    local cur = DisplayedValues[key]
    if math.abs(cur - targetNum) < 0.5 then
        DisplayedValues[key] = targetNum
        if formatter then label.Text = formatter(targetNum) end
        if colorNeutral then label.TextColor3 = colorNeutral end
        return
    end
    local next = cur + (targetNum - cur) * 0.18
    DisplayedValues[key] = next
    if formatter then label.Text = formatter(next) end
    if colorPos and colorNeg then
        label.TextColor3 = (next >= 0) and colorPos or colorNeg
    elseif colorNeutral then
        label.TextColor3 = colorNeutral
    end
end

local function buatMonitoringGUI()
    local uangSekarang = DapatkanUangPemain()
    if not getgenv().UangAwalDikunci or getgenv().UangAwalDikunci == 0 then
        getgenv().UangAwalDikunci = uangSekarang
    end
    getgenv().WaktuMulai = getgenv().WaktuMulai or tick()
    local uangAwal = getgenv().UangAwalDikunci
    DisplayedValues = {}

    if TrackerGui and TrackerGui.Parent then TrackerGui:Destroy() end
    TrackerGui = Instance.new("ScreenGui")
    TrackerGui.Name = "KingAkbarTracker"
    TrackerGui.Parent = CoreGui2

    local Frame = Instance.new("Frame")
    Frame.Size        = UDim2.new(0, 230, 0, 0)
    Frame.Position    = UDim2.new(1, -16, 0.5, 0)
    Frame.AnchorPoint = Vector2.new(1, 0.5)
    Frame.BackgroundColor3       = Color3.fromRGB(18, 18, 22)
    Frame.BackgroundTransparency = 0.15
    Frame.BorderSizePixel = 0
    Frame.Active   = true
    Frame.Draggable = true
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.Parent   = TrackerGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromRGB(60, 60, 68); Stroke.Thickness = 1
    local Padding = Instance.new("UIPadding", Frame)
    Padding.PaddingTop    = UDim.new(0,10); Padding.PaddingBottom = UDim.new(0,10)
    Padding.PaddingLeft   = UDim.new(0,12); Padding.PaddingRight  = UDim.new(0,12)
    local List = Instance.new("UIListLayout", Frame)
    List.Padding = UDim.new(0, 7); List.SortOrder = Enum.SortOrder.LayoutOrder

    local H = Instance.new("Frame", Frame)
    H.Size = UDim2.new(1,0,0,36); H.BackgroundTransparency = 1; H.LayoutOrder = 1
    local Img = Instance.new("ImageLabel", H)
    Img.Size = UDim2.new(0,32,0,32); Img.Position = UDim2.new(0,0,0.5,-16)
    Img.BackgroundTransparency = 1; Img.Image = "rbxassetid://84070081307966"
    Img.ScaleType = Enum.ScaleType.Fit; Img.ZIndex = 2
    Instance.new("UICorner", Img).CornerRadius = UDim.new(0,7)
    local TitleLbl = Instance.new("TextLabel", H)
    TitleLbl.Size = UDim2.new(1,-40,0,14); TitleLbl.Position = UDim2.new(0,40,0,4)
    TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "KING AKBAR"
    TitleLbl.TextColor3 = Color3.fromRGB(210,210,215); TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local SubLbl = Instance.new("TextLabel", H)
    SubLbl.Size = UDim2.new(1,-40,0,11); SubLbl.Position = UDim2.new(0,40,0,20)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text = State.IsRideGOActive and "RideGO Driver" or (State.IsCourierActive and "Courier Express" or (State.IsBaristaActive and "Barista" or (State.IsOfficeActive and "Office Worker" or "Bypass GACOR")))
    SubLbl.TextColor3 = Color3.fromRGB(90,90,100); SubLbl.Font = Enum.Font.Gotham
    SubLbl.TextSize = 9; SubLbl.TextXAlignment = Enum.TextXAlignment.Left

    local Div = Instance.new("Frame", Frame)
    Div.Size = UDim2.new(1,0,0,1); Div.BackgroundColor3 = Color3.fromRGB(55,55,62)
    Div.BorderSizePixel = 0; Div.LayoutOrder = 2

    local function baris(iconL, labelL, iconR, labelR, order)
        local R = Instance.new("Frame", Frame)
        R.Size = UDim2.new(1,0,0,34); R.BackgroundTransparency = 1; R.LayoutOrder = order
        local function kolom(parent, xOffset, icon, caption)
            local bg = Instance.new("Frame", parent)
            bg.Size = UDim2.new(0.5,-4,1,0); bg.Position = UDim2.new(xOffset,0,0,0)
            bg.BackgroundColor3 = Color3.fromRGB(30,30,36); bg.BackgroundTransparency = 0.4
            bg.BorderSizePixel = 0
            Instance.new("UICorner", bg).CornerRadius = UDim.new(0,6)
            local capLbl = Instance.new("TextLabel", bg)
            capLbl.Size = UDim2.new(1,-6,0,11); capLbl.Position = UDim2.new(0,6,0,4)
            capLbl.BackgroundTransparency = 1; capLbl.Text = icon .. " " .. caption
            capLbl.TextColor3 = Color3.fromRGB(110,110,120); capLbl.Font = Enum.Font.GothamMedium
            capLbl.TextSize = 9; capLbl.TextXAlignment = Enum.TextXAlignment.Left
            local valLbl = Instance.new("TextLabel", bg)
            valLbl.Size = UDim2.new(1,-6,0,14); valLbl.Position = UDim2.new(0,6,1,-18)
            valLbl.BackgroundTransparency = 1; valLbl.Text = "—"
            valLbl.TextColor3 = Color3.fromRGB(225,225,230); valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 11; valLbl.TextXAlignment = Enum.TextXAlignment.Left
            return valLbl, capLbl
        end
        local lv, lc = kolom(R, 0,   iconL, labelL)
        local rv, rc = kolom(R, 0.5, iconR, labelR)
        return lv, rv, lc, rc
    end

    local v_initial, v_profit = baris("💵","Initial", "💰","Profit", 3)
    local v_stat1, v_stat2, c_stat1, c_stat2 = baris(
        State.IsRideGOActive and "🚕" or (State.IsCourierActive and "📦" or (State.IsBaristaActive and "☕" or "📝")),
        State.IsRideGOActive and "Trips" or (State.IsCourierActive and "Delivered" or (State.IsBaristaActive and "Sold" or "Solved")),
        State.IsRideGOActive and "💵" or (State.IsCourierActive and "🔄" or (State.IsBaristaActive and "🔧" or "🖨️")),
        State.IsRideGOActive and "Fares" or (State.IsCourierActive and "Status" or (State.IsBaristaActive and "Fixes" or "Prints")),
        4
    )
    local v_profitH, v_ping   = baris("⚡","Profit/H", "📶","Ping", 5)
    local v_fps,     v_uptime = baris("🎮","FPS",      "⏱️","Uptime", 6)

    local CLR_WHITE  = Color3.fromRGB(225,225,230)
    local CLR_GREEN  = Color3.fromRGB(80, 210, 120)
    local CLR_RED    = Color3.fromRGB(230, 80,  80)
    local CLR_YELLOW = Color3.fromRGB(230,190, 60)

    v_initial.Text = fmtRupiah(uangAwal)

    task.spawn(function()
        while TrackerGui and TrackerGui.Parent do
            pcall(function()
                local currentMoney = DapatkanUangPemain()
                if uangAwal == 0 and currentMoney > 0 then
                    getgenv().UangAwalDikunci = currentMoney
                    uangAwal = currentMoney
                    v_initial.Text = fmtRupiah(uangAwal)
                end
                local profit      = currentMoney - uangAwal
                local uptimeDetik = tick() - getgenv().WaktuMulai
                local uptimeJam   = math.max(uptimeDetik / 3600, 1/3600)
                local profitH     = profit / uptimeJam

                local pingVal, fpsVal = 0, 0
                pcall(function() pingVal = math.floor(Services.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
                pcall(function() fpsVal  = math.floor(workspace:GetRealPhysicsFPS()) end)

                animateValue(v_profit, profit, fmtProfit, CLR_GREEN, CLR_RED, nil)

                if State.IsRideGOActive then
                    SubLbl.Text = "RideGO Driver"
                    c_stat1.Text = "🚕 Trips"
                    c_stat2.Text = "💵 Fares"
                    local trips = State.RideGOTripCount or 0
                    local fares = State.RideGOEarnings or 0
                    animateValue(v_stat1, trips, function(n) return tostring(math.floor(n)) end, nil, nil, CLR_WHITE)
                    animateValue(v_stat2, fares, fmtShort, nil, nil, CLR_WHITE)
                elseif State.IsCourierActive then
                    SubLbl.Text = "Courier Express"
                    c_stat1.Text = "📦 Delivered"
                    c_stat2.Text = "🔄 Status"
                    local delivered = State.CourierDelivered or 0
                    animateValue(v_stat1, delivered, function(n) return tostring(math.floor(n)) end, nil, nil, CLR_WHITE)
                    v_stat2.Text = State.CourierPhase or "Idle"
                    v_stat2.TextColor3 = CLR_GREEN
                elseif State.IsBaristaActive then
                    SubLbl.Text = "Barista"
                    c_stat1.Text = "☕ Sold"
                    c_stat2.Text = "🔧 Fixes"
                    local sold = State.OrderCount or 0
                    local fixes = State.MachineFixCount or 0
                    animateValue(v_stat1, sold, function(n) return tostring(math.floor(n)) end, nil, nil, CLR_WHITE)
                    animateValue(v_stat2, fixes, function(n) return tostring(math.floor(n)) end, nil, nil, CLR_WHITE)
                else
                    SubLbl.Text = State.IsOfficeActive and "Office Worker" or "Bypass GACOR"
                    c_stat1.Text = "📝 Solved"
                    c_stat2.Text = "🖨️ Prints"
                    local solved = State.OfficeMathSolved or 0
                    local prints = State.OfficePrints or 0
                    animateValue(v_stat1, solved, function(n) return tostring(math.floor(n)) end, nil, nil, CLR_WHITE)
                    animateValue(v_stat2, prints, function(n) return tostring(math.floor(n)) end, nil, nil, CLR_WHITE)
                end

                animateValue(v_profitH, profitH, fmtShort, CLR_GREEN, CLR_RED, nil)
                animateValue(v_ping, pingVal, function(n) return tostring(math.floor(n)) .. " ms" end, nil, nil, pingVal > 200 and CLR_RED or CLR_WHITE)

                local fpsColor = fpsVal >= 30 and CLR_GREEN or (fpsVal >= 15 and CLR_YELLOW or CLR_RED)
                animateValue(v_fps, fpsVal, function(n) return tostring(math.floor(n)) end, nil, nil, fpsColor)

                v_uptime.Text = formatTime(uptimeDetik)
                v_uptime.TextColor3 = CLR_WHITE

                if State.TargetProfit > 0 and profit >= State.TargetProfit then
                    if getgenv().WebhookSettings and getgenv().WebhookSettings.Enabled then
                        if SendDiscordWebhook then SendDiscordWebhook("TARGET PROFIT TERCAPAI!") end
                    end
                    
                    State.IsOfficeActive   = false
                    State.IsBaristaActive  = false
                    State.IsCourierActive  = false
                    State.IsRideGOActive   = false
                    getgenv().fullAuto     = false

                    WindUI:Notify({
                        Title    = "Target Tercapai",
                        Content  = "Profit " .. fmtProfit(profit) .. " dari target " .. fmtRupiah(State.TargetProfit) .. ", keluar sekarang.",
                        Duration = 4,
                    })

                    task.wait(3)

                    pcall(function()
                        game:GetService("Players"):FindFirstChildOfClass("Player").Parent = nil
                    end)
                end
            end)
            task.wait(0.2)
        end
    end)
end

local function matikanMonitoring()
    if TrackerGui and TrackerGui.Parent then TrackerGui:Destroy(); TrackerGui = nil end
end

-- ============================================================================
-- // START / STOP MODULE (BARISTA & OFFICE)
-- ============================================================================
local function StartBaristaScript()
    if State.IsBaristaActive then return end
    State.IsBaristaActive = true
    State.MachineFixCount = 0
    State.OrderCount      = 0
    State.DebugTapCount   = 0

    CachedMoneyLabel = nil
    getgenv().UangAwalDikunci = nil
    getgenv().WaktuMulai = tick()
    buatMonitoringGUI()

    if State.DebugEnabled then CreateDebugOverlay() end
    task.spawn(function()
        RefreshBaristaRefs()
        StartMinigameAI()
        BaristaFarmLoop()
    end)
    WindUI:Notify({ Title = "☕ Auto Barista", Content = "Auto Barista & Monitoring Aktif!", Duration = 3 })
end

local function StopBaristaScript()
    State.IsBaristaActive = false
    State.StatusText = "Idling..."
    State.DebugMinigameActive = false
    focusCameraZoom(false)
    if CharRef.Humanoid and CharRef.Root then
        CharRef.Humanoid:MoveTo(CharRef.Root.Position)
    end
    DestroyDebugOverlay()
    matikanMonitoring()
    WindUI:Notify({ Title = "🛑 Auto Barista", Content = "Auto Barista Dihentikan.", Duration = 3 })
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

    joinOfficeTeam()
    task.wait(0.8)

    if not CharRef.Humanoid or not CharRef.Humanoid.SeatPart then
        WindUI:Notify({ Title = "🔍 Office", Content = "Finding seat...", Duration = 3 })
        local targetSeat = findOfficeSeat(nil)
        if targetSeat then
            myChair = targetSeat
            dudukKeKursi(true)
        else
            WindUI:Notify({ Title = "⚠️ Office", Content = "No empty seat found! Sit manually.", Duration = 5 })
        end
    else
        myChair = CharRef.Humanoid.SeatPart
    end

    lastActivityTime = tick()
    buatMonitoringGUI()
    WindUI:Notify({ Title = "✅ Office", Content = "Auto Office started!", Duration = 4 })
end

local function StopOfficeScript()
    State.IsOfficeActive = false
    getgenv().fullAuto = false
    getgenv().forceStopMath = false
    getgenv().isGoingToPrinter = false

    pcall(function()
        Services.ReplicatedStorage:WaitForChild("JobEvents")
            :WaitForChild("PlayerChangedJob"):FireServer()
    end)

    if CharRef.Humanoid then
        CharRef.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    end

    CachedMoneyLabel = nil
    getgenv().UangAwalDikunci = nil
    matikanMonitoring()
    WindUI:Notify({ Title = "🛑 Office", Content = "Auto Office stopped.", Duration = 3 })
end

-- ============================================================================
-- // SHARED VEHICLE SCANNER & STRICT OWNERSHIP SYSTEM
-- ============================================================================
SELECTED_CAR = nil
OwnedVehiclesList = {}

VehicleDropdownCourier = nil
VehicleDropdownRideGO  = nil

local function parseVehicleCandidate(item, outMap)
    if not item then return end
    if type(item) == "string" and #item > 1 then
        local low = item:lower()
        if not low:find("slot") and not low:find("frame") and not low:find("button") and not low:find("package") then
            outMap[item] = true
        end
    elseif type(item) == "table" then
        local carName = item.Name or item.Car or item.CarName or item.Vehicle or item.Model
        if carName and type(carName) == "string" and #carName > 1 then
            local low = carName:lower()
            if not low:find("slot") and not low:find("frame") then
                outMap[carName] = true
            end
        end
    end
end

function FetchOwnedVehicles()
    local foundMap = {}
    local RS = game:GetService("ReplicatedStorage")
    local DealershipEvents = RS:FindFirstChild("DealershipEvents")

    if DealershipEvents then
        if DealershipEvents:FindFirstChild("InitializeCarData") then
            pcall(function()
                local res = DealershipEvents.InitializeCarData:InvokeServer()
                if type(res) == "table" then
                    for _, entry in pairs(res) do parseVehicleCandidate(entry, foundMap) end
                end
            end)
        end

        if DealershipEvents:FindFirstChild("GetInfoCarSlot") then
            pcall(function()
                local slotRes = DealershipEvents.GetInfoCarSlot:InvokeServer()
                if type(slotRes) == "table" then
                    for _, entry in pairs(slotRes) do parseVehicleCandidate(entry, foundMap) end
                end
            end)
            for i = 1, 30 do
                pcall(function()
                    local slotRes = DealershipEvents.GetInfoCarSlot:InvokeServer(i)
                    if type(slotRes) == "table" then parseVehicleCandidate(slotRes, foundMap) end
                end)
            end
        end
    end

    pcall(function()
        if not getgc then return end
        for _, tbl in pairs(getgc(true)) do
            if type(tbl) == "table" and rawget(tbl, 1) and type(rawget(tbl, 1)) == "table" then
                local first = rawget(tbl, 1)
                if rawget(first, "Horsepower") and rawget(first, "Name") and rawget(first, "FinalDrive") then
                    for _, carData in ipairs(tbl) do
                        if type(carData) == "table" and carData.Name then foundMap[carData.Name] = true end
                    end
                end
            end
        end
    end)

    pcall(function()
        if not (getgc and getupvalues) then return end
        for _, fn in pairs(getgc()) do
            if type(fn) == "function" and (not isexecutorclosure or not isexecutorclosure(fn)) then
                local ok, ups = pcall(getupvalues, fn)
                if ok and type(ups) == "table" then
                    for _, up in pairs(ups) do
                        if type(up) == "table" and #up > 0 then
                            local sample = up[1]
                            if type(sample) == "table" and sample.Name and sample.Horsepower then
                                for _, c in ipairs(up) do
                                    if type(c) == "table" and c.Name then foundMap[c.Name] = true end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    pcall(function()
        for _, fName in ipairs({"Data", "Cars", "Garage", "Vehicles", "OwnedCars"}) do
            local folder = LocalPlayer:FindFirstChild(fName)
            if folder then
                for _, child in ipairs(folder:GetChildren()) do
                    if child:IsA("StringValue") and #child.Value > 1 then
                        foundMap[child.Value] = true
                    elseif not child:IsA("Folder") then
                        foundMap[child.Name] = true
                    end
                end
            end
        end
    end)

    local unique = {}
    for carName, _ in pairs(foundMap) do
        if type(carName) == "string" and #carName > 1 and carName ~= "None" and carName ~= "Empty" then
            table.insert(unique, carName)
        end
    end
    table.sort(unique)

    if #unique > 0 then
        OwnedVehiclesList = unique
        if not foundMap[SELECTED_CAR] then SELECTED_CAR = OwnedVehiclesList[1] end
    else
        OwnedVehiclesList = { "Tidak ada kendaraan terdeteksi" }
        SELECTED_CAR = nil
    end

    return OwnedVehiclesList
end

function RefreshAllVehicleDropdowns()
    local cars = FetchOwnedVehicles()
    local validCars = (cars[1] ~= "Tidak ada kendaraan terdeteksi") and cars or {}
    pcall(function()
        if VehicleDropdownCourier then
            if VehicleDropdownCourier.Refresh then VehicleDropdownCourier:Refresh(validCars)
            elseif VehicleDropdownCourier.SetValues then VehicleDropdownCourier:SetValues(validCars) end
        end
        if VehicleDropdownRideGO then
            if VehicleDropdownRideGO.Refresh then VehicleDropdownRideGO:Refresh(validCars)
            elseif VehicleDropdownRideGO.SetValues then VehicleDropdownRideGO:SetValues(validCars) end
        end
    end)
    return cars
end

local function isVehicleMine(v)
    if not (v and v:IsA("Model")) then return false end
    local myName = LocalPlayer.Name
    local vName  = v.Name

    local ownerAttr = v:GetAttribute("Owner") or v:GetAttribute("Player") or v:GetAttribute("Creator")
    if ownerAttr and (tostring(ownerAttr) == myName or tostring(ownerAttr) == tostring(LocalPlayer.UserId)) then
        return true
    end

    local ownerVal = v:FindFirstChild("Owner") or v:FindFirstChild("Player")
    if ownerVal and (ownerVal:IsA("StringValue") or ownerVal:IsA("ObjectValue")) then
        if tostring(ownerVal.Value) == myName or ownerVal.Value == LocalPlayer then return true end
    end

    local seat = v:FindFirstChildOfClass("VehicleSeat") or v:FindFirstChild("DriveSeat", true)
    if seat and seat.Occupant and CharRef.Humanoid and seat.Occupant == CharRef.Humanoid then
        return true
    end

    if vName:find(myName, 1, true) then return true end

    if SELECTED_CAR and vName:find(SELECTED_CAR, 1, true) then
        for _, plr in ipairs(Services.Players:GetPlayers()) do
            if plr ~= LocalPlayer and vName:find(plr.Name, 1, true) then return false end
        end
        return true
    end
    return false
end

local function findMyMotor()
    for _, v in pairs(workspace:GetChildren()) do
        if isVehicleMine(v) and (v:FindFirstChildOfClass("VehicleSeat") or v:FindFirstChild("DriveSeat", true)) then
            return v
        end
    end
    local vFolder = workspace:FindFirstChild("Cars") or workspace:FindFirstChild("Vehicles")
    if vFolder then
        for _, v in pairs(vFolder:GetChildren()) do
            if isVehicleMine(v) then return v end
        end
    end
    return nil
end

local function getBikeModel()
    local hum = CharRef.Humanoid
    if not hum or not hum.SeatPart then return nil end
    return hum.SeatPart:FindFirstAncestorOfClass("Model")
end

local function getMovers(primary)
    if not primary then return nil, nil end

    local bv = primary:FindFirstChild("RideGO_BV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "RideGO_BV"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = primary
    end

    local bg = primary:FindFirstChild("RideGO_BG")
    if not bg then
        bg = Instance.new("BodyGyro")
        bg.Name = "RideGO_BG"
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.CFrame = primary.CFrame
        bg.Parent = primary
    end

    return bv, bg
end

-- ============================================================================
-- // PERMANENT NOCLIP (TEMBUS TEMBOK STEPPED)
-- ============================================================================
Services.RunService.Stepped:Connect(function()
    if State.IsRideGOActive or State.IsCourierActive then
        pcall(function()
            if CharRef.Character then
                for _, part in ipairs(CharRef.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            local bike = getBikeModel() or findMyMotor()
            if bike then
                for _, part in ipairs(bike:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            local activeMissions = Services.Workspace:FindFirstChild("ActiveMissions")
            if activeMissions then
                local passenger = activeMissions:FindFirstChild("RideGO_Passenger")
                if passenger then
                    if passenger:IsA("BasePart") then passenger.CanCollide = false end
                    for _, part in ipairs(passenger:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end)
    end
end)

-- ============================================================================
-- // CORE GO-JEK ENGINE: SPAWN, DESPAWN & NAIK MOTOR
-- ============================================================================
local DealershipEvents = Services.ReplicatedStorage:WaitForChild("DealershipEvents", 10)
local SpawnCarEvents   = Services.ReplicatedStorage:WaitForChild("SpawnCarEvents", 10)

local function spawnAndMountBike()
    if not SELECTED_CAR then FetchOwnedVehicles() end
    if not SELECTED_CAR then return nil end

    pcall(function()
        if SpawnCarEvents:FindFirstChild("DespawnCar") then
            SpawnCarEvents.DespawnCar:FireServer()
        elseif SpawnCarEvents:FindFirstChild("RemoveCar") then
            SpawnCarEvents.RemoveCar:FireServer()
        end
    end)
    task.wait(0.8)

    pcall(function()
        if DealershipEvents:FindFirstChild("InitializeCarData") then
            DealershipEvents.InitializeCarData:InvokeServer()
        end
        if DealershipEvents:FindFirstChild("GetInfoCarSlot") then
            DealershipEvents.GetInfoCarSlot:InvokeServer()
        end
        if SpawnCarEvents:FindFirstChild("SpawnCar") then
            SpawnCarEvents.SpawnCar:FireServer(SELECTED_CAR)
        end
    end)

    local seatFound = nil
    local timeout = tick() + 8
    while tick() < timeout and not seatFound do
        task.wait(0.2)
        if CharRef.Root then
            for _, model in ipairs(Services.Workspace:GetChildren()) do
                if model:IsA("Model") and isVehicleMine(model) then
                    local seat = model:FindFirstChildOfClass("VehicleSeat") or model:FindFirstChild("DriveSeat", true)
                    if seat and (not seat.Occupant or seat.Occupant == CharRef.Humanoid) then
                        local dist = (seat.Position - CharRef.Root.Position).Magnitude
                        if dist < 100 then
                            seatFound = seat
                            break
                        end
                    end
                end
            end
        end
    end

    if seatFound and CharRef.Humanoid and CharRef.Root then
        CharRef.Root.CFrame = seatFound.CFrame
        task.wait(0.1)
        seatFound:Sit(CharRef.Humanoid)
        task.wait(0.5)

        if CharRef.Humanoid.SeatPart ~= seatFound then
            CharRef.Root.CFrame = seatFound.CFrame
            task.wait(0.1)
            seatFound:Sit(CharRef.Humanoid)
            task.wait(0.5)
        end

        local primary = seatFound.Parent.PrimaryPart or seatFound
        getMovers(primary)

        return seatFound.Parent
    end

    return getBikeModel()
end

local function ensureBike()
    if not SELECTED_CAR then
        FetchOwnedVehicles()
        if not SELECTED_CAR then
            WindUI:Notify({ Title = "⚠️ Garasi Kosong", Content = "Pilih kendaraan di garasi terlebih dahulu!", Duration = 4 })
            return nil
        end
    end

    local bike = getBikeModel()
    if bike and isVehicleMine(bike) and CharRef.Humanoid and CharRef.Humanoid.SeatPart then
        local primary = bike.PrimaryPart or bike:FindFirstChild("VehicleSeat") or bike:FindFirstChildOfClass("BasePart")
        if primary then getMovers(primary) end
        return bike
    end

    local existing = findMyMotor()
    if existing and CharRef.Root and CharRef.Humanoid then
        local seat = existing:FindFirstChildOfClass("VehicleSeat") or existing:FindFirstChild("DriveSeat", true)
        if seat and (not seat.Occupant or seat.Occupant == CharRef.Humanoid) then
            local dist = (seat.Position - CharRef.Root.Position).Magnitude
            if dist < 100 then
                CharRef.Root.CFrame = seat.CFrame
                task.wait(0.1)
                seat:Sit(CharRef.Humanoid)
                task.wait(0.5)
                local primary = existing.PrimaryPart or seat
                getMovers(primary)
                return existing
            end
        end
    end

    return spawnAndMountBike()
end

local function resetMotorDanNaik()
    forceDismount()
    task.wait(0.3)

    local existing = findMyMotor()
    if existing and CharRef.Root and CharRef.Humanoid then
        local seat = existing:FindFirstChildOfClass("VehicleSeat") or existing:FindFirstChild("DriveSeat", true)
        if seat and (not seat.Occupant or seat.Occupant == CharRef.Humanoid) then
            CharRef.Root.CFrame = seat.CFrame
            task.wait(0.1)
            seat:Sit(CharRef.Humanoid)
            task.wait(0.5)
            local primary = existing.PrimaryPart or seat
            getMovers(primary)
            return existing
        end
    end

    return spawnAndMountBike()
end

-- ============================================================================
-- // GLOBAL FLIGHT ENGINE (VOID GATE & HOVER TERBANG TEMBUS TEMBOK)
-- ============================================================================
local HOVER_HEIGHT    = 4
local VOID_STOP_TIME  = 0.08
local VOID_SCAN_MAX   = 4000
local VOID_SCAN_STEP  = 60
local HOP_DISTANCE    = 600
local HOP_MAX         = 20
local STREAM_WAIT_MAX = 4

local function newRayParams()
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local blacklist = { LocalPlayer.Character }
    
    local bike = getBikeModel()
    if bike then
        table.insert(blacklist, bike)
        for _, seat in ipairs(bike:GetDescendants()) do
            if seat:IsA("VehicleSeat") and seat.Occupant then
                table.insert(blacklist, seat.Occupant.Parent)
            end
        end
    end

    local activeMissions = Services.Workspace:FindFirstChild("ActiveMissions")
    if activeMissions then
        local pass = activeMissions:FindFirstChild("RideGO_Passenger")
        if pass then
            table.insert(blacklist, pass)
        end
    end

    rayParams.FilterDescendantsInstances = blacklist
    return rayParams
end

local function findGroundY(origin)
    local ray = Services.Workspace:Raycast(origin, Vector3.new(0, -600, 0), newRayParams())
    return ray and ray.Position.Y or nil
end

local function findGroundYFar(x, z, fromY)
    local origin = Vector3.new(x, (fromY or 0) + 300, z)
    local ray = Services.Workspace:Raycast(origin, Vector3.new(0, -3000, 0), newRayParams())
    return ray and ray.Position.Y or nil
end

local function requestStream(pos)
    pcall(function() Services.Workspace:RequestStreamAround(pos, 0.4) end)
end

local function hoverLock(primary, bv, bg, flatLook)
    bv.Velocity = Vector3.zero
    primary.AssemblyLinearVelocity  = Vector3.zero
    primary.AssemblyAngularVelocity = Vector3.zero
    if flatLook then
        bg.CFrame = CFrame.lookAt(primary.Position, primary.Position + flatLook)
    end
end

local function isFlightAllowed()
    return State.IsRideGOActive or State.IsCourierActive
end

local function hoverWaitForGround(primary, bv, bg, flatLook, targetPos, timeout)
    local t0 = tick()
    while tick() - t0 < (timeout or STREAM_WAIT_MAX) do
        if not isFlightAllowed() then return nil, true end
        if not primary.Parent then return nil, true end

        hoverLock(primary, bv, bg, flatLook)

        local gY = findGroundY(primary.Position)
        if gY then return gY, false end
        task.wait(0.3)
    end
    return nil, false
end

local function flyToTarget(targetPos)
    local bike = ensureBike()
    if not bike then return false end

    local primary = bike.PrimaryPart
        or bike:FindFirstChild("VehicleSeat")
        or bike:FindFirstChildOfClass("BasePart")
    if not primary then return false end

    pcall(function() bike:SetNetworkOwner(LocalPlayer) end)

    local bv, bg = getMovers(primary)
    bv.MaxForce  = Vector3.new(1e9, 1e9, 1e9)
    bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)

    local reached    = false
    local flatTarget = Vector3.new(targetPos.X, 0, targetPos.Z)

    -- Dynamic Random Speed (math.random antara MIN & MAX yang disetel user)
    local minSpd = 180
    local maxSpd = 220
    if State.IsRideGOActive then
        minSpd = tonumber(State.RideGOMinSpeed) or 180
        maxSpd = tonumber(State.RideGOMaxSpeed) or 220
    elseif State.IsCourierActive then
        minSpd = tonumber(State.CourierMinSpeed) or 180
        maxSpd = tonumber(State.CourierMaxSpeed) or 220
    end

    if minSpd > maxSpd then
        minSpd, maxSpd = maxSpd, minSpd
    end

    local baseSpeed = math.random(math.floor(minSpd), math.floor(maxSpd))

    local function voidStopAndTP()
        local stopStart = tick()
        while tick() - stopStart < VOID_STOP_TIME do
            if not isFlightAllowed() then return end
            bv.Velocity = Vector3.zero
            primary.AssemblyAngularVelocity = Vector3.zero
            task.wait(0.03)
        end
        hoverLock(primary, bv, bg, nil)
        task.wait(0.05)

        local posNow   = primary.Position
        local flatNow  = Vector3.new(posNow.X, 0, posNow.Z)
        local distNow  = (flatNow - flatTarget).Magnitude
        local dirToTgt = distNow > 1 and ((flatTarget - flatNow).Unit) or Vector3.new(0, 0, -1)
        local hoverY   = posNow.Y

        local safeLandPos = nil
        local streak, firstD, firstGY = 0, nil, nil
        for d = VOID_SCAN_STEP, VOID_SCAN_MAX, VOID_SCAN_STEP do
            if not isFlightAllowed() then return end

            local px = posNow.X + dirToTgt.X * d
            local pz = posNow.Z + dirToTgt.Z * d
            local gY = findGroundYFar(px, pz, posNow.Y)

            if gY then
                if streak == 0 then firstD = d; firstGY = gY end
                streak += 1
                if streak >= 3 then
                    local landD = firstD + 25
                    if landD >= distNow - 10 then break end
                    local lx = posNow.X + dirToTgt.X * landD
                    local lz = posNow.Z + dirToTgt.Z * landD
                    local newDist = (Vector3.new(lx, 0, lz) - flatTarget).Magnitude
                    if newDist < distNow then safeLandPos = Vector3.new(lx, firstGY + HOVER_HEIGHT, lz) end
                    break
                end
            else
                streak, firstD, firstGY = 0, nil, nil
            end
        end

        if safeLandPos then
            local tpCFrame = CFrame.lookAt(safeLandPos, safeLandPos + dirToTgt)
            bike:PivotTo(tpCFrame)
            bg.CFrame = tpCFrame
            requestStream(safeLandPos)
            task.wait(0.05)
            hoverLock(primary, bv, bg, dirToTgt)
            task.wait(0.05)
            return
        end

        local curFlat = flatNow
        for hop = 1, HOP_MAX do
            if not isFlightAllowed() or not primary.Parent then return end
            local remaining = (flatTarget - curFlat).Magnitude
            if remaining < 20 then break end

            local stepD  = math.min(HOP_DISTANCE, remaining)
            local hopPos = Vector3.new(curFlat.X + dirToTgt.X * stepD, hoverY, curFlat.Z + dirToTgt.Z * stepD)
            local tpCF   = CFrame.lookAt(hopPos, hopPos + dirToTgt)

            bike:PivotTo(tpCF)
            bg.CFrame = tpCF
            hoverLock(primary, bv, bg, dirToTgt)
            requestStream(hopPos)
            task.wait(0.05)

            local gY = findGroundY(primary.Position)
            if gY then
                local landPos = Vector3.new(primary.Position.X, gY + HOVER_HEIGHT, primary.Position.Z)
                bike:PivotTo(CFrame.lookAt(landPos, landPos + dirToTgt))
                hoverLock(primary, bv, bg, dirToTgt)
                return
            end
            curFlat = Vector3.new(primary.Position.X, 0, primary.Position.Z)
        end

        local missionPos = Vector3.new(targetPos.X, math.max(hoverY, targetPos.Y + HOVER_HEIGHT), targetPos.Z)
        local tpCF = CFrame.lookAt(missionPos, missionPos + dirToTgt)
        bike:PivotTo(tpCF)
        bg.CFrame = tpCF
        hoverLock(primary, bv, bg, dirToTgt)
        requestStream(missionPos)

        local gY, aborted = hoverWaitForGround(primary, bv, bg, dirToTgt, targetPos, STREAM_WAIT_MAX)
        if aborted then return end
        if gY then
            local landPos = Vector3.new(primary.Position.X, gY + HOVER_HEIGHT, primary.Position.Z)
            bike:PivotTo(CFrame.lookAt(landPos, landPos + dirToTgt))
            hoverLock(primary, bv, bg, dirToTgt)
        end
    end

    pcall(function()
        while isFlightAllowed() do
            if not primary.Parent or not CharRef.Humanoid then break end
            if not CharRef.Humanoid or CharRef.Humanoid.Health <= 0 then break end

            if not CharRef.Humanoid.SeatPart then
                pcall(function()
                    if bv then bv.Velocity = Vector3.zero end
                    if primary then primary.AssemblyLinearVelocity = Vector3.zero end
                end)

                local bike2 = spawnAndMountBike()
                if bike2 then
                    local primary2 = bike2.PrimaryPart or bike2:FindFirstChild("VehicleSeat") or bike2:FindFirstChildOfClass("BasePart")
                    if primary2 then
                        bv, bg = getMovers(primary2)
                        primary = primary2
                        bike = bike2
                        continue
                    end
                else
                    bike2 = resetMotorDanNaik()
                    local primary2 = bike2 and (bike2.PrimaryPart or bike2:FindFirstChild("VehicleSeat") or bike2:FindFirstChildOfClass("BasePart"))
                    if primary2 then
                        bv, bg = getMovers(primary2)
                        primary = primary2
                        bike = bike2
                        continue
                    end
                end
            end

            local pos      = primary.Position
            local flatPos  = Vector3.new(pos.X, 0, pos.Z)
            local flatDist = (flatPos - flatTarget).Magnitude

            if flatDist < 15 then
                reached = true
                break
            end

            local dirToTarget    = (flatTarget - flatPos).Unit
            local currentGroundY = findGroundY(pos)
            local lookAheadPos   = pos + dirToTarget * 40
            local groundAheadY   = findGroundY(lookAheadPos)

            if (not currentGroundY) or (not groundAheadY) then
                voidStopAndTP()
                continue
            end

            local targetHoverY = currentGroundY + HOVER_HEIGHT
            local currentSpeed = baseSpeed
            if flatDist < 90 then
                currentSpeed = math.clamp(flatDist * 2.0, 25, baseSpeed)
            end
            currentSpeed = currentSpeed * (1 + (math.random(-2, 2) / 100))

            local moveDir = dirToTarget
            if moveDir.X ~= moveDir.X then moveDir = Vector3.zero end
            local moveVel = moveDir * currentSpeed
            local yVel    = math.clamp((targetHoverY - pos.Y) * 4.5, -25, 25)

            bv.Velocity = Vector3.new(moveVel.X, yVel, moveVel.Z)
            if moveVel.Magnitude > 0 then
                bg.CFrame = CFrame.lookAt(pos, pos + moveVel)
            end
            task.wait(0.03)
        end
    end)

    if not reached then
        bv.Velocity = Vector3.zero
        return false
    end

    local currentLook = bike:GetPivot().LookVector
    local flatLook = Vector3.new(currentLook.X, 0, currentLook.Z).Unit
    if flatLook.Magnitude == 0 then flatLook = Vector3.new(0, 0, -1) end

    bg.CFrame = CFrame.lookAt(primary.Position, primary.Position + flatLook)

    local lastVel = bv.Velocity
    for i = 1, 8 do
        bv.Velocity = lastVel * (1 - i / 8)
        task.wait(0.03)
    end
    bv.Velocity = Vector3.zero

    local groundY = findGroundY(primary.Position)
    if not groundY then
        groundY = hoverWaitForGround(primary, bv, bg, flatLook, targetPos, STREAM_WAIT_MAX)
    end

    if groundY then
        local targetLandY = groundY + 2.5
        local landTimeout = tick() + 2.5
        while primary.Parent and primary.Position.Y > targetLandY and tick() < landTimeout do
            if not isFlightAllowed() then break end
            local remainingDist = primary.Position.Y - targetLandY
            local downSpeed = math.clamp(remainingDist * 3, 1, 6)
            bv.Velocity = Vector3.new(0, -downSpeed, 0)
            bg.CFrame   = CFrame.lookAt(primary.Position, primary.Position + flatLook)
            task.wait(0.04)
        end
    end

    hoverLock(primary, bv, bg, flatLook)
    task.wait(0.4)
    return true
end

-- ============================================================================
-- // 15. AUTO COURIER (VERIFIKASI DROP MANDIRI & AUTO DELIVERED +1)
-- ============================================================================
local CourierJob = {
    Name = "Courier", TeamId = 11378976,
    DepotPos = Vector3.new(-5109.06, 5.18, -3758.69)
}

local ServiceEventConn = nil

local function setJobCourier()
    pcall(function()
        Services.ReplicatedStorage:WaitForChild("JobEvents"):WaitForChild("TeamChangeRequest")
            :FireServer(CourierJob.Name, CourierJob.TeamId, 1, 0, "Detector")
    end)
end

local function getKotakTool()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local ch = LocalPlayer.Character or CharRef.Character
    if ch then
        for _, t in ipairs(ch:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("kotak") or t.Name:lower():find("package") or t.Name:lower():find("box")) then
                return t, true
            end
        end
    end
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("kotak") or t.Name:lower():find("package") or t.Name:lower():find("box")) then
                return t, false
            end
        end
    end
    return nil, false
end

local function equipKotak()
    local tool, isEquipped = getKotakTool()
    if isEquipped then return tool end
    if tool and CharRef.Humanoid then
        CharRef.Humanoid:EquipTool(tool)
        local t0 = tick()
        while tick() - t0 < 1.5 do
            task.wait(0.1)
            local _, equippedNow = getKotakTool()
            if equippedNow then break end
        end
        return tool
    end
    return nil
end

local function startCourierLoop()
    if not SELECTED_CAR then FetchOwnedVehicles() end
    if not SELECTED_CAR then
        WindUI:Notify({ Title = "⚠️ Auto Courier", Content = "Pilih kendaraan di garasi terlebih dahulu!", Duration = 4 })
        State.IsCourierActive = false
        return
    end

    local activePackageLoc = nil
    local activePackageNum = nil
    local DeliverySettings = nil

    pcall(function()
        DeliverySettings = require(Services.ReplicatedStorage:WaitForChild("Delivery System", 5):WaitForChild("Settings", 5))
    end)

    local courierRemote = (DeliverySettings and DeliverySettings.RemoteEvent) or Services.ReplicatedStorage:FindFirstChild("ServiceEvent", true)
    local livrasonFolder = (DeliverySettings and DeliverySettings.Folder) or workspace:FindFirstChild("Livrason")

    if courierRemote then
        ServiceEventConn = courierRemote.OnClientEvent:Connect(function(...)
            if not State.IsCourierActive then return end
            local args = {...}
            local a1 = tostring(args[1] or ""):lower()
            local a2 = tostring(args[2] or ""):lower()
            local pNum = args[3] or args[2]

            if a1 == "serviceevent" then
                if a2 == "create" and pNum then
                    local locFolder = livrasonFolder and livrasonFolder:FindFirstChild("Location")
                    if locFolder then
                        local paket = locFolder:WaitForChild(tostring(pNum), 5)
                        local block = paket and paket:FindFirstChild("Block")
                        if block then
                            activePackageLoc = block.Position
                            activePackageNum = tostring(pNum)
                        end
                    end
                elseif a2 == "remove" or a2 == "delete" or a2 == "clear" or a2 == "finish" then
                    activePackageLoc = nil
                    activePackageNum = nil
                end
            elseif a1 == "create" and pNum then
                local locFolder = livrasonFolder and livrasonFolder:FindFirstChild("Location")
                if locFolder then
                    local paket = locFolder:WaitForChild(tostring(pNum), 5)
                    local block = paket and paket:FindFirstChild("Block")
                    if block then
                        activePackageLoc = block.Position
                        activePackageNum = tostring(pNum)
                    end
                end
            elseif a1 == "remove" or a1 == "delete" or a1 == "clear" or a1 == "finish" then
                activePackageLoc = nil
                activePackageNum = nil
            end
        end)
    end

    setJobCourier()
    task.wait(1.5)

    pcall(function()
        if courierRemote then courierRemote:FireServer("RequestJobUpdate") end
    end)

    while State.IsCourierActive do
        local hasBox = getKotakTool() ~= nil

        if hasBox and not activePackageLoc and livrasonFolder then
            pcall(function()
                local locFolder = livrasonFolder:FindFirstChild("Location")
                if locFolder then
                    for _, folder in ipairs(locFolder:GetChildren()) do
                        local block = folder:FindFirstChild("Block") or folder:FindFirstChildWhichIsA("BasePart")
                        if block then
                            local prompt = block:FindFirstChildOfClass("ProximityPrompt")
                            if prompt and prompt.Enabled then
                                activePackageLoc = block.Position
                                activePackageNum = folder.Name
                                break
                            end
                        end
                    end
                end
            end)
        end

        if hasBox and activePackageLoc then
            State.CourierPhase = "Antar Paket"
            spawnAndMountBike()
            task.wait(0.4)

            flyToTarget(activePackageLoc)
            if not State.IsCourierActive then break end

            State.CourierPhase = "Drop Paket"
            forceDismount()
            task.wait(0.3)

            local moneyBefore = GetPlayerMoney()
            local successDrop = false

            for attempt = 1, 3 do
                if not State.IsCourierActive then break end

                if CharRef.Root then
                    CharRef.Root.CFrame = CFrame.new(activePackageLoc + Vector3.new(0, 1.2, 0))
                end
                task.wait(0.3)

                equipKotak()
                task.wait(0.2)

                local targetPrompt = nil
                local targetBlock  = nil

                pcall(function()
                    local locFolder = livrasonFolder and livrasonFolder:FindFirstChild("Location")
                    local paket = locFolder and locFolder:FindFirstChild(tostring(activePackageNum))
                    if paket then
                        targetBlock  = paket:FindFirstChild("Block") or paket:FindFirstChildWhichIsA("BasePart")
                        targetPrompt = targetBlock and targetBlock:FindFirstChildOfClass("ProximityPrompt")
                    end
                end)

                if not targetPrompt and livrasonFolder then
                    pcall(function()
                        local locFolder = livrasonFolder:FindFirstChild("Location")
                        if locFolder then
                            for _, f in ipairs(locFolder:GetChildren()) do
                                local blk = f:FindFirstChild("Block") or f:FindFirstChildWhichIsA("BasePart")
                                if blk and (blk.Position - CharRef.Root.Position).Magnitude < 15 then
                                    local pr = blk:FindFirstChildOfClass("ProximityPrompt")
                                    if pr and pr.Enabled then
                                        targetBlock  = blk
                                        targetPrompt = pr
                                        break
                                    end
                                end
                            end
                        end
                    end)
                end

                if targetPrompt and targetBlock then
                    DoHold(targetPrompt, targetBlock)
                end

                task.wait(0.8)

                local stillHasBox = getKotakTool() ~= nil
                local moneyNow = GetPlayerMoney()
                if not stillHasBox or moneyNow > moneyBefore then
                    successDrop = true
                    break
                end
            end

            if successDrop or (getKotakTool() == nil) then
                State.CourierDelivered = (State.CourierDelivered or 0) + 1
                activePackageLoc = nil
                activePackageNum = nil
                State.CourierPhase = "Terkirim!"

                State.CourierPhase = "Menunggu Paket Baru"
                local waitTimeout = tick() + 60
                while State.IsCourierActive and tick() < waitTimeout do
                    task.wait(1)
                    if livrasonFolder then
                        pcall(function()
                            local locFolder = livrasonFolder:FindFirstChild("Location")
                            if locFolder then
                                for _, folder in ipairs(locFolder:GetChildren()) do
                                    local block = folder:FindFirstChild("Block") or folder:FindFirstChildWhichIsA("BasePart")
                                    if block then
                                        local prompt = block:FindFirstChildOfClass("ProximityPrompt")
                                        if prompt and prompt.Enabled then
                                            activePackageLoc = block.Position
                                            activePackageNum = folder.Name
                                            break
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    if activePackageLoc then break end
                end
                task.wait(1)
            else
                activePackageLoc = nil
                activePackageNum = nil
                State.CourierPhase = "Reset Rute"
                task.wait(0.5)
            end

        else
            State.CourierPhase = "Ke Depot"
            spawnAndMountBike()
            task.wait(0.4)

            flyToTarget(CourierJob.DepotPos)
            if not State.IsCourierActive then break end

            State.CourierPhase = "Ambil Paket"
            forceDismount()
            task.wait(0.3)
            if CharRef.Root then
                CharRef.Root.CFrame = CFrame.new(CourierJob.DepotPos + Vector3.new(0, 1.5, 0))
            end
            task.wait(0.4)

            local pBox = nil
            local pPart = nil
            pcall(function()
                local takeFolder = livrasonFolder and (livrasonFolder:FindFirstChild("Take1") or livrasonFolder:FindFirstChild("Take"))
                if takeFolder then
                    pPart = takeFolder:FindFirstChild("Take") or takeFolder:FindFirstChild("Part") or takeFolder:FindFirstChildWhichIsA("BasePart")
                    if pPart then pBox = pPart:FindFirstChildOfClass("ProximityPrompt") end
                end
            end)

            if pBox and pPart then
                DoHold(pBox, pPart)
            end

            State.CourierPhase = "Menunggu..."
            local tWait = tick()
            while State.IsCourierActive and not activePackageLoc and (getKotakTool() == nil) do
                if tick() - tWait > 6 then
                    pcall(function()
                        if courierRemote then courierRemote:FireServer("RequestJobUpdate") end
                    end)
                    tWait = tick()
                end
                task.wait(0.4)
            end
        end
    end

    focusCameraZoom(false)
    if ServiceEventConn then ServiceEventConn:Disconnect(); ServiceEventConn = nil end
end

local function StartCourierScript()
    if State.IsCourierActive then return end
    State.IsCourierActive = true
    State.CourierDelivered = 0
    State.CourierPhase = "Standby"
    
    CachedMoneyLabel = nil
    getgenv().UangAwalDikunci = nil
    getgenv().WaktuMulai = tick()
    buatMonitoringGUI()

    task.spawn(startCourierLoop)
    WindUI:Notify({ Title = "📦 Auto Courier", Content = "Auto Courier (RideGO Engine) Aktif!", Duration = 3 })
end

local function StopCourierScript()
    State.IsCourierActive = false
    State.CourierPhase = "Idle"
    if ServiceEventConn then ServiceEventConn:Disconnect(); ServiceEventConn = nil end
    local bike = getBikeModel() or findMyMotor()
    if bike then
        local primary = bike.PrimaryPart or bike:FindFirstChild("VehicleSeat") or bike:FindFirstChildOfClass("BasePart")
        if primary then
            local bv = primary:FindFirstChild("RideGO_BV")
            local bg = primary:FindFirstChild("RideGO_BG")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
    focusCameraZoom(false)
    matikanMonitoring()
    WindUI:Notify({ Title = "🛑 Auto Courier", Content = "Auto Courier Dihentikan.", Duration = 3 })
end

-- ============================================================================
-- // 16. INJECT A-CHASSIS
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
                            pcall(function() s.Disabled = true end); safeDestroy(s)
                        end
                    end
                end
            end
            for _, v in pairs(vehicle:GetDescendants()) do
                if v:IsA("ModuleScript") and (v.Name == "Tune" or string.find(string.lower(v.Name), "tune")) then
                    pcall(function()
                        local tune = require(v)
                        if tune.Horsepower then tune.Horsepower = tune.Horsepower * HP_Mult end
                        if tune.Redline    then tune.Redline    = tune.Redline + RPM_Add end
                        if tune.Ratios then
                            for i, ratio in pairs(tune.Ratios) do
                                if type(ratio) == "number" and ratio > 0 then tune.Ratios[i] = ratio * Ratio_Mult end
                            end
                        end
                        if tune.FinalDrive   then tune.FinalDrive   = tune.FinalDrive * FD_Mult end
                        if tune.Limiter  ~= nil then tune.Limiter  = false end
                        if tune.RevLimit     then tune.RevLimit     = 999999 end
                        if tune.SpeedLimit   then tune.SpeedLimit   = false end
                        if tune.TopSpeed     then tune.TopSpeed     = 999999 end
                        if tune.MaxSpeed     then tune.MaxSpeed     = 999999 end
                        if tune.DragMult     then tune.DragMult     = tune.DragMult * 0.05 end
                        if tune.Weight       then tune.Weight       = tune.Weight * 0.7 end
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
-- // 17. AUTO RIDEGO DRIVER (TUNED NETWORK + SILENT HUMANIZER CYCLE)
-- ============================================================================
local TaxiEvent = Services.ReplicatedStorage
    :WaitForChild("TaxiAssets", 10)
    :WaitForChild("Events", 10)
    :WaitForChild("TaxiEvent", 10)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if not (State.IsRideGOActive or State.IsCourierActive) then return end
    task.wait(1.5)
    pcall(ensureBike)
    if not State.RideGOTargetPos and State.RideGOPhase ~= "idle" and State.RideGOPhase ~= "cycling" then
        State.RideGOPhase = "idle"
    end
end)

TaxiEvent.OnClientEvent:Connect(function(action, data)
    if not State.IsRideGOActive then return end
    local d = data or {}

    if action == "DutyStarted" then
        State.RideGOIsOnline = true
        State.RideGOPhase    = "idle"
        ensureBike()

    elseif action == "DutyEnded" then
        State.RideGOIsOnline  = false
        State.RideGOPhase     = "idle"
        State.RideGOTargetPos = nil

    elseif action == "OrderOffer" and State.RideGOPhase == "idle" then
        State.RideGOToken = d.Token
        State.RideGOPhase = "offered"
        ensureBike()
        TaxiEvent:FireServer("AcceptOrder", State.RideGOToken)

    elseif action == "OrderAccepted" and State.RideGOToken == d.Token then
        State.RideGOTargetPos = d.PickupPos
        State.RideGOPhase     = "goingPickup"

    elseif action == "PassengerBoarding"
        and (State.RideGOPhase == "goingPickup" or State.RideGOPhase == "atPickup") then
        State.RideGOPhase = "waitingBoard"

    elseif action == "TripStarted" and State.RideGOPhase == "waitingBoard" then
        State.RideGOTargetPos = d.DropPos
        State.RideGOPhase     = "goingDrop"

    elseif action == "OrderCompleted" then
        State.RideGOTripCount = (State.RideGOTripCount or 0) + 1
        local earned = tonumber(d.Earned or d.FareEarned) or 0
        State.RideGOEarnings = (State.RideGOEarnings or 0) + earned

        task.delay(1, function() TaxiEvent:FireServer("AckTripComplete") end)
        State.RideGOToken     = nil
        State.RideGOTargetPos = nil

        -- AUTO HUMANIZER: RESET MOTOR SECARA ACAK ANTARA 3 - 7 TRIP (SILENT / NO NOTIF)
        State.CurrentCycleTrips = (State.CurrentCycleTrips or 0) + 1
        if State.CurrentCycleTrips >= (State.NextBikeCycle or 5) then
            State.RideGOPhase = "cycling"
            task.spawn(function()
                -- 1. Offline sejenak agar order tidak tertimpa
                pcall(function() TaxiEvent:FireServer("GoOffline") end)
                task.wait(0.5)

                -- 2. Turun dari motor
                forceDismount()

                -- 3. Jeda santai seperti player asli (4 - 8 detik)
                task.wait(math.random(40, 80) / 10)

                -- 4. Despawn & spawn ulang motor baru lalu naik
                spawnAndMountBike()
                task.wait(math.random(15, 25) / 10)

                -- 5. Masuk online kembali dan set target acak baru (3 - 7 trip)
                pcall(function() TaxiEvent:FireServer("GoOnline") end)
                State.CurrentCycleTrips = 0
                State.NextBikeCycle = math.random(3, 7)
                State.RideGOPhase = "idle"
            end)
        else
            State.RideGOPhase = "idle"
        end

    elseif action == "OrderExpired"
        or action == "OrderDeclined"
        or action == "OrderCancelled" then
        State.RideGOToken     = nil
        State.RideGOTargetPos = nil
        if State.RideGOPhase ~= "cycling" then
            State.RideGOPhase = "idle"
        end
    end
end)

-- ============================================================================
-- // RIDEGO FLIGHT DISPATCHER (WATCHDOG 8S ANTI-NYANGKUT)
-- ============================================================================
task.spawn(function()
    while true do
        task.wait(0.4)
        if not State.IsRideGOActive or not State.RideGOTargetPos then continue end

        if State.RideGOPhase == "goingPickup" then
            local ok = flyToTarget(State.RideGOTargetPos)
            if ok and State.RideGOPhase == "goingPickup" then
                State.RideGOPhase = "atPickup"
            end

        elseif State.RideGOPhase == "goingDrop" then
            local ok = flyToTarget(State.RideGOTargetPos)
            if ok and State.RideGOPhase == "goingDrop" then
                State.RideGOPhase = "waitingDropOff"

                local arrivedAt = tick()
                while State.IsRideGOActive and State.RideGOPhase == "waitingDropOff" and (tick() - arrivedAt < 8) do
                    task.wait(0.5)
                end

                if State.RideGOPhase == "waitingDropOff" then
                    WindUI:Notify({
                        Title    = "⚠️ Rute Gagal / Macet",
                        Content  = "Nyangkut verifikasi rute (8s). Auto reset motor & cari order lain...",
                        Duration = 4
                    })

                    pcall(function()
                        TaxiEvent:FireServer("CancelOrder")
                        if State.RideGOToken then
                            TaxiEvent:FireServer("DeclineOrder", State.RideGOToken)
                        end
                    end)

                    forceDismount()
                    task.wait(0.5)
                    spawnAndMountBike()

                    State.RideGOToken     = nil
                    State.RideGOTargetPos = nil
                    State.RideGOPhase     = "idle"
                end
            end
        end
    end
end)

local function StartRideGOScript()
    if State.IsRideGOActive then return end
    if not SELECTED_CAR then FetchOwnedVehicles() end
    if not SELECTED_CAR then
        WindUI:Notify({ Title = "❌ Gagal Memulai", Content = "Pilih kendaraan di garasi sebelum menyalakan RideGO!", Duration = 4 })
        return
    end

    State.IsRideGOActive = true
    State.RideGOTripCount = 0
    State.RideGOEarnings = 0
    State.CurrentCycleTrips = 0
    State.NextBikeCycle = math.random(3, 7)
    
    CachedMoneyLabel = nil
    getgenv().UangAwalDikunci = nil
    getgenv().WaktuMulai = tick()

    buatMonitoringGUI()

    ensureBike()
    if not State.RideGOIsOnline then TaxiEvent:FireServer("GoOnline") end

    WindUI:Notify({ Title = "🚕 RideGO Driver", Content = "Auto RideGO & Monitoring Aktif!", Duration = 4 })
end

local function StopRideGOScript()
    State.IsRideGOActive = false
    State.RideGOTargetPos = nil
    if State.RideGOIsOnline then TaxiEvent:FireServer("GoOffline") end
    local bike = getBikeModel() or findMyMotor()
    if bike then
        local primary = bike.PrimaryPart or bike:FindFirstChild("VehicleSeat") or bike:FindFirstChildOfClass("BasePart")
        if primary then
            local bv = primary:FindFirstChild("RideGO_BV")
            local bg = primary:FindFirstChild("RideGO_BG")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end

    focusCameraZoom(false)
    CachedMoneyLabel = nil
    getgenv().UangAwalDikunci = nil
    matikanMonitoring()

    WindUI:Notify({ Title = "🛑 RideGO Driver", Content = "Auto RideGO dihentikan.", Duration = 3 })
end

local function OnRideGOTeamChanged()
    if State.IsRideGOActive and LocalPlayer.Team and LocalPlayer.Team.Name ~= "RideGO Driver" then
        StopRideGOScript()
        WindUI:Notify({ Title = "⚠️ RideGO Driver", Content = "Keluar dari tim driver, bot dimatikan otomatis.", Duration = 3 })
    end
end
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(OnRideGOTeamChanged)

-- ============================================================================
-- // 18. DISCORD WEBHOOK SYSTEM
-- ============================================================================
getgenv().WebhookSettings = {
    URL = "",
    Enabled = false,
    Interval = 15
}

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

function SendDiscordWebhook(statusTitle)
    if not getgenv().WebhookSettings.Enabled or getgenv().WebhookSettings.URL == "" then return end
    if not httprequest then return end

    local uptimeDetik = getgenv().WaktuMulai and (tick() - getgenv().WaktuMulai) or 0
    local uangSekarang = DapatkanUangPemain and DapatkanUangPemain() or 0
    local uangAwal = getgenv().UangAwalDikunci or uangSekarang
    local profit = uangSekarang - uangAwal

    local jobName = "Idling"
    local stat1, val1 = "Status", "Standby"
    local stat2, val2 = "Mode", "Idle"

    if State.IsRideGOActive then
        jobName = "RideGO Driver"
        stat1, val1 = "Total Trips", tostring(State.RideGOTripCount or 0)
        stat2, val2 = "Total Fares", fmtRupiah(State.RideGOEarnings or 0)
    elseif State.IsCourierActive then
        jobName = "Courier Express"
        stat1, val1 = "Delivered", tostring(State.CourierDelivered or 0)
        stat2, val2 = "Phase", State.CourierPhase or "Idle"
    elseif State.IsOfficeActive then
        jobName = "Office Worker"
        stat1, val1 = "Solved", tostring(State.OfficeMathSolved or 0)
        stat2, val2 = "Prints", tostring(State.OfficePrints or 0)
    elseif State.IsBaristaActive then
        jobName = "Barista"
        stat1, val1 = "Coffee Sold", tostring(State.OrderCount or 0)
        stat2, val2 = "Machine Fix", tostring(State.MachineFixCount or 0)
    end

    local embedColor = profit > 0 and tonumber(0x50d278) or (profit < 0 and tonumber(0xd25050) or tonumber(0x3498db))
    local profitStr = (profit >= 0 and "**+** " or "**-** ") .. fmtRupiah(math.abs(profit))

    local uptimeJam = math.max(uptimeDetik / 3600, 1/3600)
    local profitPerJam = profit / uptimeJam
    local profitHStr = (profitPerJam >= 0 and "+ " or "- ") .. fmtRupiah(math.abs(profitPerJam))

    local timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
    local targetStr = (State.TargetProfit > 0 and fmtRupiah(State.TargetProfit) or "Unlimited")

    local data = {
        ["embeds"] = {{
            ["title"] = "King Akbar - " .. (statusTitle or "Status Update"),
            ["description"] = "```fix\nAuto Farm Berjalan: " .. formatTime(uptimeDetik) .. "```",
            ["color"] = embedColor,
            ["timestamp"] = timestamp,
            ["author"] = {
                ["name"] = "King Akbar Ultimate System",
                ["icon_url"] = "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
            },
            ["thumbnail"] = {
                ["url"] = "https://cdn-icons-png.flaticon.com/512/2694/2694157.png"
            },
            ["fields"] = {
                {["name"] = "Player",          ["value"] = "||" .. game.Players.LocalPlayer.Name .. "||", ["inline"] = true},
                {["name"] = "Active Job",      ["value"] = jobName,                                       ["inline"] = true},
                {["name"] = "Current Money",   ["value"] = "**" .. fmtRupiah(uangSekarang) .. "**",       ["inline"] = true},

                {["name"] = "Total Profit",    ["value"] = profitStr,                                    ["inline"] = true},
                {["name"] = "Profit / Hour",   ["value"] = profitHStr,                                   ["inline"] = true},
                {["name"] = "Target Profit",   ["value"] = targetStr,                                    ["inline"] = true},

                {["name"] = stat1,             ["value"] = val1,                                         ["inline"] = true},
                {["name"] = stat2,             ["value"] = val2,                                         ["inline"] = true},
                {["name"] = "Uptime",          ["value"] = formatTime(uptimeDetik),                      ["inline"] = true}
            },
            ["footer"] = {
                ["text"] = "Drag Drive Simulator • Free Auto Farm",
                ["icon_url"] = "https://cdn-icons-png.flaticon.com/512/2583/2583269.png"
            }
        }}
    }

    task.spawn(function()
        pcall(function()
            httprequest({
                Url = getgenv().WebhookSettings.URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = game:GetService("HttpService"):JSONEncode(data)
            })
        end)
    end)
end

local lastWebhookTick = tick()

task.spawn(function()
    while true do
        task.wait(1)
        local settings = getgenv().WebhookSettings
        if settings and settings.Enabled and settings.URL and settings.URL ~= "" then
            local intervalMinutes = tonumber(settings.Interval) or 15
            if intervalMinutes < 1 then intervalMinutes = 1 end
            local intervalSeconds = intervalMinutes * 60

            if (tick() - lastWebhookTick) >= intervalSeconds then
                lastWebhookTick = tick()
                SendDiscordWebhook("Auto Report")
            end
        else
            lastWebhookTick = tick()
        end
    end
end)

-- ============================================================================
-- // 19. UI SETUP
-- ============================================================================
local wSz  = IsMobile and UDim2.fromOffset(420, 320) or UDim2.fromOffset(580, 460)
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
            Callback = function() if setclipboard then setclipboard("https://discord.gg/XmWf3YQPpZ") end end
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

local TabFarm = Window:Tab({ Title = "Auto Farm", Icon = "coffee", Border = true })

-- SECTION BARISTA
local SectionBarista = TabFarm:Section({ Title = "Auto Barista", Box = true, BoxBorder = true, Opened = false })
SectionBarista:Toggle({ Title = "Enable Auto Barista", Icon = "play", Value = false, Callback = function(on) if on then StartBaristaScript() else StopBaristaScript() end end })
SectionBarista:Toggle({ Title = "Show Debug Overlay", Icon = "monitor", Value = true, Callback = function(on) State.DebugEnabled = on; if State.IsBaristaActive then if on then CreateDebugOverlay() else DestroyDebugOverlay() end end end })

-- SECTION OFFICE
local SectionOffice = TabFarm:Section({ Title = "Auto Office", Box = true, BoxBorder = true, Opened = false })
SectionOffice:Toggle({ Title = "Enable Auto Office", Icon = "briefcase", Value = false, Callback = function(on) if on then StartOfficeScript() else StopOfficeScript() end end })

SectionOffice:Input({
    Title       = "Stop otomatis di profit (Rp)",
    Desc        = "Kalau sudah nyampe, langsung keluar server. Kosongin = gak ada batas.",
    Placeholder = "contoh: 50000000",
    Callback    = function(Text)
        local bersih = string.gsub(Text or "", "[^%d]", "")
        local val = tonumber(bersih) or 0
        State.TargetProfit = val
        if val > 0 then
            WindUI:Notify({ Title = "Target dipasang", Content = "Bakal keluar pas profit udah " .. fmtRupiah(val), Duration = 3 })
        else
            WindUI:Notify({ Title = "Target dicopot", Content = "Gak ada batas profit, jalan terus.", Duration = 3 })
        end
    end
})

-- SECTION COURIER
local SectionCourier = TabFarm:Section({ Title = "Auto Courier", Box = true, BoxBorder = true, Opened = false })
SectionCourier:Toggle({ Title = "Enable Auto Courier", Icon = "package", Value = false, Callback = function(on) if on then StartCourierScript() else StopCourierScript() end end })

VehicleDropdownCourier = SectionCourier:Dropdown({
    Title    = "Pilih Motor Kurir",
    Multi    = false,
    Options  = #OwnedVehiclesList > 0 and OwnedVehiclesList or {"Pindai garasi..."},
    Callback = function(chosen)
        if chosen and chosen ~= "" and chosen ~= "Tidak ada kendaraan terdeteksi" and chosen ~= "Pindai garasi..." then
            SELECTED_CAR = chosen
            WindUI:Notify({ Title = "🚗 Kendaraan Dipilih", Content = "Menggunakan: " .. SELECTED_CAR, Duration = 2 })
        end
    end
})

SectionCourier:Button({
    Title    = "🔄 Refresh Garasi",
    Icon     = "refresh-cw",
    Callback = function()
        local cars = RefreshAllVehicleDropdowns()
        local count = (cars[1] == "Tidak ada kendaraan terdeteksi") and 0 or #cars
        WindUI:Notify({ Title = "✅ Garasi Terdeteksi", Content = "Ditemukan " .. count .. " kendaraan!", Duration = 3 })
    end
})

SectionCourier:Slider({
    Title    = "Kecepatan Minimum Kurir",
    Desc     = "Batas kecepatan terendah saat antar paket (Default: 180)",
    Step     = 5,
    Value    = { Min = 60, Max = 400, Default = 180 },
    Callback = function(v)
        State.CourierMinSpeed = v
    end
})

SectionCourier:Slider({
    Title    = "Kecepatan Maksimum Kurir",
    Desc     = "Batas kecepatan tertinggi saat antar paket (Default: 220)",
    Step     = 5,
    Value    = { Min = 80, Max = 450, Default = 220 },
    Callback = function(v)
        State.CourierMaxSpeed = v
    end
})

-- SECTION RIDEGO DRIVER
local SectionRideGO = TabFarm:Section({ Title = "Auto RideGO Driver", Box = true, BoxBorder = true, Opened = false })
SectionRideGO:Paragraph({ Title = "", Desc = "Pilih dulu motor di dropdown sebelum mengaktifkan" })
SectionRideGO:Toggle({
    Title = "Enable Auto RideGO",
    Icon = "car",
    Value = false,
    Callback = function(on) if on then StartRideGOScript() else StopRideGOScript() end end
})

VehicleDropdownRideGO = SectionRideGO:Dropdown({
    Title    = "Pilih Kendaraan RideGO",
    Multi    = false,
    Options  = #OwnedVehiclesList > 0 and OwnedVehiclesList or {"Pindai garasi..."},
    Callback = function(chosen)
        if chosen and chosen ~= "" and chosen ~= "Tidak ada kendaraan terdeteksi" and chosen ~= "Pindai garasi..." then
            SELECTED_CAR = chosen
            WindUI:Notify({ Title = "🚕 Kendaraan Dipilih", Content = "Menggunakan: " .. SELECTED_CAR, Duration = 2 })
        end
    end
})

SectionRideGO:Button({
    Title    = "🔄 Refresh Garasi",
    Icon     = "refresh-cw",
    Callback = function()
        local cars = RefreshAllVehicleDropdowns()
        local count = (cars[1] == "Tidak ada kendaraan terdeteksi") and 0 or #cars
        WindUI:Notify({ Title = "✅ Garasi Terdeteksi", Content = "Ditemukan " .. count .. " kendaraan!", Duration = 3 })
    end
})

SectionRideGO:Slider({
    Title    = "Kecepatan Minimum RideGO",
    Desc     = "Batas kecepatan terendah saat jemput/antar penumpang (Default: 180)",
    Step     = 5,
    Value    = { Min = 60, Max = 400, Default = 180 },
    Callback = function(v)
        State.RideGOMinSpeed = v
    end
})

SectionRideGO:Slider({
    Title    = "Kecepatan Maksimum RideGO",
    Desc     = "Batas kecepatan tertinggi saat jemput/antar penumpang (Default: 220)",
    Step     = 5,
    Value    = { Min = 80, Max = 450, Default = 220 },
    Callback = function(v)
        State.RideGOMaxSpeed = v
    end
})

local TabSec = Window:Tab({ Title = "Security", Icon = "shield", Border = true })
local Perlindungan = TabSec:Section({ Title = "Protection", Box = true, BoxBorder = true, Opened = false })
Perlindungan:Toggle({ Title = "Anti-Admin (Auto Leave)", Desc = "Automatically leaves if a staff member joins", Icon = "user-minus", Value = true, Callback = function(on) State.AntiAdmin = on end })
Perlindungan:Toggle({ Title = "Anti-AFK", Desc = "Keeps connection active while botting", Icon = "clock", Value = true, Callback = function(on) State.AntiAFK = on end })

local TabPerf = Window:Tab({ Title = "Performance", Icon = "zap", Border = true })
local HematDaya = TabPerf:Section({ Title = "Power Saving", Box = true, BoxBorder = true, Opened = false })
HematDaya:Toggle({ Title = "Disable Rendering (AFK Mode)", Desc = "Black screen, saves battery, bot keeps running", Value = false, Callback = function(on) ToggleBlackScreen(on) end })

local SectionAntiLag = TabPerf:Section({ Title = "Anti Lag", Box = true, BoxBorder = true, Opened = false })
SectionAntiLag:Toggle({ Title = "Enable Anti Lag", Desc = "Purges particles & locks graphics to minimum", Value = false, Callback = function(on) ToggleAntiLag(on) end })

local SectionPotato = TabPerf:Section({ Title = "Ultra Potato Mode", Box = true, BoxBorder = true, Opened = false })
SectionPotato:Toggle({ Title = "Enable Potato Mode (EXTREME)", Desc = "Destroys terrain, meshes, lighting, sounds for MAX FPS.", Value = false, Callback = function(on) TogglePotatoMode(on) end })

local TabCfg = Window:Tab({ Title = "Settings", Icon = "settings", Border = true })
local Konfigurasi = TabCfg:Section({ Title = "Configuration", Box = true, BoxBorder = true, Opened = false })
Konfigurasi:Slider({ Title = "Action Delay (Seconds)", Desc = "Lower is faster, but riskier", Step = 1, Value = { Min = 1, Max = 10, Default = 5 }, Callback = function(v) State.ActionDelay = v end })

local SectionFakeName = TabCfg:Section({ Title = "Spoof Name", Box = true, BoxBorder = true, Opened = false })
SectionFakeName:Input({
    Title = "Spoof Name (Empty = King Akbar)", Placeholder = "King Akbar",
    Callback = function(Text)
        local cleanText = string.gsub(Text or "", "^%s+", "")
        cleanText = string.gsub(cleanText, "%s+$", "")
        State.FakeName = (cleanText == "") and "King Akbar" or cleanText
        if State.FakeNameActive then SpoofApplyNow() end
    end
})
SectionFakeName:Toggle({
    Title = "Enable Spoof Name", Desc = "Changes your display name (Client-sided)", Value = false,
    Callback = function(on)
        State.FakeNameActive = on
        if on then
            SpoofApplyNow()
            WindUI:Notify({ Title = "🎭 Spoof Name", Content = "Name changed to: " .. State.FakeName, Duration = 3 })
        else
            SpoofDisableNow()
            WindUI:Notify({ Title = "🎭 Spoof Name", Content = "Original name restored.", Duration = 3 })
        end
    end
})

local SectionRedeem = TabCfg:Section({ Title = "Auto Redeem", Box = true, BoxBorder = true, Opened = false })
local redeemCodes = {
    "DRAGDRIVESIMULATORAUGUST26",
    "DDSSPECIALMERDEKA2026",
    "NEWLIGHTSMODIFICATION",
    "DELAYDIKITBARULOMBA",
    "DDSTHX175KROADTO200KLIKES"
}
local function FireRedeemRemote(code)
    pcall(function()
        local remote = Services.ReplicatedStorage:WaitForChild("RedeemCodeEvents"):WaitForChild("Redeem")
        if remote then remote:InvokeServer(code) end
    end)
end
SectionRedeem:Button({
    Title = "🎁 Redeem All Codes", Desc = "Automatically redeems all available codes",
    Callback = function()
        task.spawn(function()
            WindUI:Notify({ Title = "🔄 Auto Redeem", Content = "Redeeming codes...", Duration = 3 })
            for _, code in ipairs(redeemCodes) do FireRedeemRemote(code); task.wait(2) end
            WindUI:Notify({ Title = "✅ Auto Redeem", Content = "All codes redeemed!", Duration = 5 })
        end)
    end
})

local SectionWebhook = TabCfg:Section({ Title = "Discord Webhook", Box = true, BoxBorder = true, Opened = false })
SectionWebhook:Input({
    Title = "Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(Text)
        getgenv().WebhookSettings.URL = Text
    end
})
SectionWebhook:Toggle({
    Title = "Enable Webhook",
    Desc = "Kirim status progress farm otomatis ke Discord",
    Value = false,
    Callback = function(on)
        getgenv().WebhookSettings.Enabled = on
        if on and getgenv().WebhookSettings.URL ~= "" then
            lastWebhookTick = tick()
            SendDiscordWebhook("Webhook Connected")
            WindUI:Notify({ Title = "🌐 Webhook", Content = "Webhook berhasil diaktifkan!", Duration = 3 })
        end
    end
})
SectionWebhook:Slider({
    Title = "Send Interval (Minutes)",
    Desc = "Jeda waktu pengiriman laporan",
    Step = 1,
    Value = { Min = 1, Max = 60, Default = 15 },
    Callback = function(v)
        getgenv().WebhookSettings.Interval = v
        lastWebhookTick = tick()
    end
})
SectionWebhook:Button({
    Title = "🚀 Test Send Webhook",
    Desc = "Kirim laporan sekarang untuk testing",
    Callback = function()
        if getgenv().WebhookSettings.URL == "" then
            WindUI:Notify({ Title = "❌ Error", Content = "Isi Webhook URL dulu!", Duration = 3 })
            return
        end
        SendDiscordWebhook("Manual Test")
        WindUI:Notify({ Title = "✅ Webhook", Content = "Test webhook terkirim!", Duration = 3 })
    end
})

local TabPreset = Window:Tab({ Title = "Instant Modes", Icon = "car", Border = true })
local ModeCepat = TabPreset:Section({ Title = "Presets", Box = true, BoxBorder = true, Opened = false })
ModeCepat:Button({ Title = "🛵 SUNDAY RIDE (Safe)",         Callback = function() InjectMesin(1.5,  2000, 0.9,  0.9,  "Sunday Ride Active") end })
ModeCepat:Button({ Title = "🏎️ RACING MODE (Aggressive)",  Callback = function() InjectMesin(3.5,  5000, 0.75, 0.75, "Racing Mode Active") end })
ModeCepat:Button({ Title = "🚀 GOD MODE (Max Speed)",       Callback = function() InjectMesin(8,   15000, 0.45, 0.45, "God Mode Active") end })
ModeCepat:Button({ Title = "🔄 RESET TO DEFAULT",           Callback = function() WindUI:Notify({ Title = "ℹ️ Info", Content = "Respawn vehicle from game menu to reset.", Duration = 5 }) end })

local TabCustom = Window:Tab({ Title = "Custom Tune", Icon = "sliders", Border = true })
local TuneSendiri = TabCustom:Section({ Title = "Manual Tuning", Box = true, BoxBorder = true, Opened = false })
local customHP, customRPM, customRatio, customFD = 2, 5000, 0.8, 0.8
TuneSendiri:Input({ Title = "💪 Horsepower Multiplier", Placeholder = "Example: 3",    Callback = function(Text) local val = tonumber(Text) if val then customHP    = val end end })
TuneSendiri:Input({ Title = "🔥 RPM Adder",             Placeholder = "Example: 8000", Callback = function(Text) local val = tonumber(Text) if val then customRPM   = val end end })
TuneSendiri:Input({ Title = "⚙️ Gear Ratio Multiplier", Placeholder = "Example: 0.6",  Callback = function(Text) local val = tonumber(Text) if val then customRatio = val end end })
TuneSendiri:Input({ Title = "⛓️ Final Drive Multiplier", Placeholder = "Example: 0.6", Callback = function(Text) local val = tonumber(Text) if val then customFD    = val end end })
TuneSendiri:Button({ Title = "⚡ INJECT CUSTOM TUNE", Callback = function() InjectMesin(customHP, customRPM, customRatio, customFD, "Custom Tune Active") end })

Window:EditOpenButton({
    Title = "Open King Akbar", Icon = "crown",
    CornerRadius = UDim.new(0, 12), StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#ffffff")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#0a0a0a")),
    }),
    Enabled = true, Draggable = true,
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

Window:SetIconSize(47)
WindUI:SetTheme("dark")
TabInfo:Select()

WindUI:Notify({
    Title    = "👑 King Akbar Siap",
    Content  = "Auto Farm Drag Drive Simulator telah dimuat!",
    Duration = 5,
})

task.spawn(function()
    task.wait(2.5)
    RefreshAllVehicleDropdowns()
end)
