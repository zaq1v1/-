-- [[ 只是吐司 - FULLY CERTIFIED & OPTIMIZED EDITION ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Settings = { 
    ESP = false, 
    Aimbot = false, 
    Spin = false, 
    FOV = 200, 
    HitLevel = 0, 
    Speed = false, 
    InfJump = false,
    AutoJump = false,
    AutoWarp = false 
}

-- 1. LANGUAGE DICTIONARY DATA
local CurrentLang = "ZH" 
local Localization = {
    EN = {
        Title = "只是吐司", Engines = "ENGINES", Navigation = "NAVIGATION",
        ESP = "RAINBOW ESP", Aimbot = "BEAST AIMBOT", Hitbox = "HITBOX LEVEL: ",
        Speed = "SUPER SPEED", InfJump = "INF JUMP", Spin = "STEALTH SPIN",
        FOV = "FOV SIZE: ", AutoJump = "SPAM JUMP: MAX", LogPos = "LOG CURRENT POSITION",
        Warp = "WARP TO COORDINATES", AutoWarp = "AUTO WARP LOOP", Invalid = "Invalid Vector3 Format!"
    },
    AR = {
        Title = "只是吐司", Engines = "المحركات", Navigation = "الإحداثيات",
        ESP = "رادار قوس قزز", Aimbot = "التصويب التلقائي", Hitbox = "مستوى الهيت بوكس: ",
        Speed = "السرعة الفائقة", InfJump = "قفز لا نهائي", Spin = "الدوران الخفي",
        FOV = "حجم دائرة الرؤية: ", AutoJump = "سبام قفز: أقصى سرعة", LogPos = "تسجيل الموقع الحالي",
        Warp = "الانتقال للإحداثيات", AutoWarp = "انتقال تلقائي مستمر", Invalid = "صيغة الإحداثيات خاطئة!"
    },
    ZH = {
        Title = "只是吐司", Engines = "功能引擎", Navigation = "坐標導航",
        ESP = "彩虹透視", Aimbot = "野獸自瞄", Hitbox = "碰撞箱等級: ",
        Speed = "超級速度", InfJump = "無限跳躍", Spin = "隱形自旋",
        FOV = "自瞄範圍: ", AutoJump = "極速連跳: 最大", LogPos = "記錄當前坐標",
        Warp = "瞬移到該坐標", AutoWarp = "循環自動瞬移", Invalid = "無效的坐標格式!"
    }
}

-- 2. GLOBAL CONTAINER
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToastGuiContainer"
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "ZhiShiTuSiHub"
Main.Size = UDim2.new(0, 420, 0, 240)
Main.Position = UDim2.new(0.35, 0, 0.35, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true; Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(30, 30, 35)
MainStroke.Thickness = 1.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Minimal Header Area
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Text = "  " .. Localization[CurrentLang].Title
Title.Size = UDim2.new(0, 120, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.RobotoMono; Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left

-- Header Control Buttons
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Text = "×"; CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.Font = Enum.Font.RobotoMono; CloseBtn.TextSize = 16; CloseBtn.BorderSizePixel = 0
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MiniBtn = Instance.new("TextButton", Header)
MiniBtn.Text = "-"; MiniBtn.Size = UDim2.new(0, 24, 0, 24); MiniBtn.Position = UDim2.new(1, -65, 0, 8)
MiniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); MiniBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1, 0)
MiniBtn.Font = Enum.Font.RobotoMono; MiniBtn.TextSize = 16; MiniBtn.BorderSizePixel = 0

-- Inner Viewport Containers
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -30, 1, -95)
Container.Position = UDim2.new(0, 15, 0, 85)
Container.BackgroundTransparency = 1

local CombatPage = Instance.new("ScrollingFrame", Container)
CombatPage.Size = UDim2.new(1, 0, 1, 0)
CombatPage.BackgroundTransparency = 1; CombatPage.CanvasSize = UDim2.new(0, 0, 0, 310); CombatPage.ScrollBarThickness = 0
CombatPage.Visible = true

local NavPage = Instance.new("Frame", Container)
NavPage.Size = UDim2.new(1, 0, 1, 0)
NavPage.BackgroundTransparency = 1
NavPage.Visible = false

local ToggleElementsList = { Container }

-- Horizontal Tab Layout Wrapper
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(1, -30, 0, 32)
TabBar.Position = UDim2.new(0, 15, 0, 45)
TabBar.BackgroundTransparency = 1
table.insert(ToggleElementsList, TabBar)

local function CreateTopTab(text, position, active_default)
    local tab = Instance.new("TextButton", TabBar)
    tab.Text = text; tab.Size = UDim2.new(0, 95, 1, 0); tab.Position = position
    tab.BackgroundColor3 = active_default and Color3.fromRGB(18, 18, 22) or Color3.fromRGB(14, 14, 16)
    tab.TextColor3 = active_default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 130, 135)
    tab.Font = Enum.Font.RobotoMono; tab.TextSize = 10
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 6)
    return tab
end

local Tab1 = CreateTopTab(Localization[CurrentLang].Engines, UDim2.new(0, 0, 0, 0), true)
local Tab2 = CreateTopTab(Localization[CurrentLang].Navigation, UDim2.new(0, 100, 0, 0), false)

-- Language Switcher Top Alignment Bar
local LangBar = Instance.new("Frame", Header)
LangBar.Size = UDim2.new(0, 100, 0, 24)
LangBar.Position = UDim2.new(1, -175, 0, 8)
LangBar.BackgroundTransparency = 1

local function CreateLangSelectorButton(label, offset_x, target_lang)
    local btn = Instance.new("TextButton", LangBar)
    btn.Text = label; btn.Size = UDim2.new(0, 30, 1, 0); btn.Position = UDim2.new(0, offset_x, 0, 0)
    btn.BackgroundColor3 = (CurrentLang == target_lang) and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(16, 16, 20)
    btn.TextColor3 = (CurrentLang == target_lang) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 145)
    btn.Font = Enum.Font.RobotoMono; btn.TextSize = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

local LangEN = CreateLangSelectorButton("EN", 0, "EN")
local LangAR = CreateLangSelectorButton("AR", 34, "AR")
local LangZH = CreateLangSelectorButton("ZH", 68, "ZH")

-- 3. COMBAT ENGINE GENERATION SYSTEM
local UIGridLayout = Instance.new("UIGridLayout", CombatPage)
UIGridLayout.CellSize = UDim2.new(0, 192, 0, 36)
UIGridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

local FOVCircle = Instance.new("Frame", ScreenGui)
FOVCircle.Size = UDim2.new(0, Settings.FOV * 2, 0, Settings.FOV * 2); FOVCircle.Position = UDim2.new(0.5, -Settings.FOV, 0.5, -Settings.FOV)
FOVCircle.BackgroundTransparency = 1; FOVCircle.Visible = false; Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", FOVCircle); Stroke.Color = Color3.new(1, 1, 1); Stroke.Thickness = 1

local function CreateMinimalButton(callback)
    local btn = Instance.new("TextButton", CombatPage)
    btn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.RobotoMono; btn.TextSize = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

local ESPBtn, AimBtn, HitBtn, SpdBtn, JmpBtn, SpinBtn, FOVBtn, AutoJumpBtn

ESPBtn = CreateMinimalButton(function(b) Settings.ESP = not Settings.ESP; b.Text = Localization[CurrentLang].ESP .. ": " .. (Settings.ESP and "ON" or "OFF") end)
AimBtn = CreateMinimalButton(function(b) Settings.Aimbot = not Settings.Aimbot; b.Text = Localization[CurrentLang].Aimbot .. ": " .. (Settings.Aimbot and "ON" or "OFF"); FOVCircle.Visible = Settings.Aimbot end)
HitBtn = CreateMinimalButton(function(b) Settings.HitLevel = (Settings.HitLevel >= 7) and 0 or Settings.HitLevel + 1; b.Text = Localization[CurrentLang].Hitbox .. Settings.HitLevel end)
SpdBtn = CreateMinimalButton(function(b) Settings.Speed = not Settings.Speed; b.Text = Localization[CurrentLang].Speed .. ": " .. (Settings.Speed and "ON" or "OFF") end)
JmpBtn = CreateMinimalButton(function(b) Settings.InfJump = not Settings.InfJump; b.Text = Localization[CurrentLang].InfJump .. ": " .. (Settings.InfJump and "ON" or "OFF") end)
SpinBtn = CreateMinimalButton(function(b) Settings.Spin = not Settings.Spin; b.Text = Localization[CurrentLang].Spin .. ": " .. (Settings.Spin and "ON" or "OFF") end)
FOVBtn = CreateMinimalButton(function(b)
    Settings.FOV = (Settings.FOV >= 1000) and 100 or Settings.FOV + 100; b.Text = Localization[CurrentLang].FOV .. Settings.FOV
    FOVCircle.Size = UDim2.new(0, Settings.FOV * 2, 0, Settings.FOV * 2); FOVCircle.Position = UDim2.new(0.5, -Settings.FOV, 0.5, -Settings.FOV)
end)

AutoJumpBtn = CreateMinimalButton(function(b) Settings.AutoJump = not Settings.AutoJump; b.Text = Localization[CurrentLang].AutoJump .. ": " .. (Settings.AutoJump and "ON" or "OFF") end)

-- 4. NAVIGATION TAB SETUP (Fixed UI Elements Conflict)
local CoordInput = Instance.new("TextBox", NavPage)
CoordInput.Size = UDim2.new(1, 0, 0, 32)
CoordInput.Position = UDim2.new(0, 0, 0, 2)
CoordInput.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
CoordInput.Font = Enum.Font.RobotoMono; CoordInput.TextSize = 11
CoordInput.PlaceholderText = "Vector3 Target: X, Y, Z"
CoordInput.Text = ""
CoordInput.TextColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", CoordInput).CornerRadius = UDim.new(0, 6)

local function CreateNavButton(position, bg_color, callback)
    local btn = Instance.new("TextButton", NavPage)
    btn.Size = UDim2.new(0, 192, 0, 32); btn.Position = position
    btn.BackgroundColor3 = bg_color; btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Font = Enum.Font.RobotoMono; btn.TextSize = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

local LogBtn = CreateNavButton(UDim2.new(0, 0, 0, 42), Color3.fromRGB(22, 22, 26), function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local currentPos = LocalPlayer.Character.HumanoidRootPart.Position
        CoordInput.Text = string.format("%.2f, %.2f, %.2f", currentPos.X, currentPos.Y, currentPos.Z)
    end
end)

local WarpBtn = CreateNavButton(UDim2.new(0, 198, 0, 42), Color3.fromRGB(22, 22, 26), function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local text = CoordInput.Text
        local x, y, z = text:match("([^,]+),([^,]+),([^,]+)")
        if x and y and z then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(tonumber(x), tonumber(y), tonumber(z)))
        else
            CoordInput.Text = Localization[CurrentLang].Invalid
        end
    end
end)

local AutoWarpBtn = CreateNavButton(UDim2.new(0, 0, 0, 82), Color3.fromRGB(22, 22, 26), function(b)
    Settings.AutoWarp = not Settings.AutoWarp
    b.Text = Localization[CurrentLang].AutoWarp .. ": " .. (Settings.AutoWarp and "ON" or "OFF")
end)

-- 5. INTERFACE RENDER REFRESH LANGUAGE ENGINE
local function UpdateUserInterfaceLanguage()
    Title.Text = "  " .. Localization[CurrentLang].Title
    Tab1.Text = Localization[CurrentLang].Engines
    Tab2.Text = Localization[CurrentLang].Navigation
    
    ESPBtn.Text = Localization[CurrentLang].ESP .. ": " .. (Settings.ESP and "ON" or "OFF")
    AimBtn.Text = Localization[CurrentLang].Aimbot .. ": " .. (Settings.Aimbot and "ON" or "OFF")
    HitBtn.Text = Localization[CurrentLang].Hitbox .. Settings.HitLevel
    SpdBtn.Text = Localization[CurrentLang].Speed .. ": " .. (Settings.Speed and "ON" or "OFF")
    JmpBtn.Text = Localization[CurrentLang].InfJump .. ": " .. (Settings.InfJump and "ON" or "OFF")
    SpinBtn.Text = Localization[CurrentLang].Spin .. ": " .. (Settings.Spin and "ON" or "OFF")
    FOVBtn.Text = Localization[CurrentLang].FOV .. Settings.FOV
    AutoJumpBtn.Text = Localization[CurrentLang].AutoJump .. ": " .. (Settings.AutoJump and "ON" or "OFF")
    
    LogBtn.Text = Localization[CurrentLang].LogPos
    WarpBtn.Text = Localization[CurrentLang].Warp
    AutoWarpBtn.Text = Localization[CurrentLang].AutoWarp .. ": " .. (Settings.AutoWarp and "ON" or "OFF")
    
    LangEN.BackgroundColor3 = (CurrentLang == "EN") and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(16, 16, 20)
    LangEN.TextColor3 = (CurrentLang == "EN") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 145)
    LangAR.BackgroundColor3 = (CurrentLang == "AR") and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(16, 16, 20)
    LangAR.TextColor3 = (CurrentLang == "AR") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 145)
    LangZH.BackgroundColor3 = (CurrentLang == "ZH") and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(16, 16, 20)
    LangZH.TextColor3 = (CurrentLang == "ZH") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 145)
end

LangEN.MouseButton1Click:Connect(function() CurrentLang = "EN"; UpdateUserInterfaceLanguage() end)
LangAR.MouseButton1Click:Connect(function() CurrentLang = "AR"; UpdateUserInterfaceLanguage() end)
LangZH.MouseButton1Click:Connect(function() CurrentLang = "ZH"; UpdateUserInterfaceLanguage() end)

UpdateUserInterfaceLanguage()

Tab1.MouseButton1Click:Connect(function()
    CombatPage.Visible = true; NavPage.Visible = false
    Tab1.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Tab1.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab2.BackgroundColor3 = Color3.fromRGB(14, 14, 16); Tab2.TextColor3 = Color3.fromRGB(130, 130, 135)
end)

Tab2.MouseButton1Click:Connect(function()
    CombatPage.Visible = false; NavPage.Visible = true
    Tab2.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Tab2.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab1.BackgroundColor3 = Color3.fromRGB(14, 14, 16); Tab1.TextColor3 = Color3.fromRGB(130, 130, 135)
end)

MiniBtn.MouseButton1Click:Connect(function()
    if Main.Size.Y.Offset > 50 then
        Main:TweenSize(UDim2.new(0, 420, 0, 40), "Out", "Quart", 0.3, true)
        for _, element in pairs(ToggleElementsList) do element.Visible = false end
        MiniBtn.Text = "+"
    else
        Main:TweenSize(UDim2.new(0, 420, 0, 240), "Out", "Quart", 0.3, true)
        for _, element in pairs(ToggleElementsList) do element.Visible = true end
        MiniBtn.Text = "-"
    end
end)

-- 6. CORE PROCESS ENGINE BACKGROUND ASYNC CALLS
local ArrowFolder = Instance.new("Folder", ScreenGui)
local PlayerArrows = {}

local function IsVisible(part, char)
    local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Blacklist; params.FilterDescendantsInstances = {LocalPlayer.Character, char}
    return workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, params) == nil
end

RunService.RenderStepped:Connect(function()
    if not ScreenGui.Parent then return end
    
    -- Fixed & Secure Humanoid Jump Force loop
    if Settings.AutoJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum.Jump = true
        end
    end

    -- Continuous Auto Teleport Loop
    if Settings.AutoWarp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local text = CoordInput.Text
        local x, y, z = text:match("([^,]+),([^,]+),([^,]+)")
        if x and y and z then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(tonumber(x), tonumber(y), tonumber(z)))
        end
    end

    local target = nil; local maxDist = Settings.FOV; local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local head = p.Character.Head
            local root = p.Character.HumanoidRootPart
            
            if Settings.HitLevel > 0 then
                local sizes = {10, 20, 35, 50, 75, 100, 150}
                local s = sizes[Settings.HitLevel]
                root.Size = Vector3.new(s, s, s); root.Transparency = 0.75; root.BrickColor = BrickColor.new("Bright red"); root.Material = Enum.Material.Neon; root.CanCollide = false
            else
                if root.Size.X > 2 then
                    root.Size = Vector3.new(2, 2, 1); root.Transparency = 1; root.Material = Enum.Material.Plastic
                end
            end

            local arrow = PlayerArrows[p] or (function()
                local a = Instance.new("TextLabel", ArrowFolder); a.Size = UDim2.new(0, 30, 0, 30); a.BackgroundTransparency = 1; a.Text = "▲"; a.TextColor3 = Color3.new(1, 1, 1); a.TextSize = 25; a.AnchorPoint = Vector2.new(0.5, 0.5); PlayerArrows[p] = a; return a
            end)()

            if Settings.ESP then
                local relPos = Camera.CFrame:PointToObjectSpace(head.Position); local angle = math.atan2(relPos.X, -relPos.Z)
                arrow.Visible = true; arrow.Position = UDim2.new(0.5, math.sin(angle) * 180, 0.5, -math.cos(angle) * 180); arrow.Rotation = math.deg(angle)
                arrow.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                local hl = p.Character:FindFirstChild("GetoHL") or Instance.new("Highlight", p.Character); hl.Name = "GetoHL"; hl.Enabled = true; hl.FillColor = arrow.TextColor3; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else arrow.Visible = false; if p.Character:FindFirstChild("GetoHL") then p.Character.GetoHL.Enabled = false end end

            if Settings.Aimbot and IsVisible(head, p.Character) then
                local pos, vis = Camera:WorldToViewportPoint(head.Position)
                if vis then local mag = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude; if mag < maxDist then maxDist = mag; target = p end end
            end
        elseif PlayerArrows[p] then PlayerArrows[p].Visible = false end
    end
    
    if Settings.Aimbot and target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position); Stroke.Color = Color3.new(1, 0, 0) else Stroke.Color = Color3.new(1, 1, 1) end
    if Settings.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 100 else if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end end
    if Settings.Spin and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(60), 0) end
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
