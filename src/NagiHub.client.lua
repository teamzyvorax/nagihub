-- NagiHub
-- Team Zyvora
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- Built for Roblox Studio experiences you own or are authorized to test.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("NagiHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "NagiHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function stroke(parent, transparency)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(75, 95, 135)
    s.Transparency = transparency or 0.35
    s.Thickness = 1
    s.Parent = parent
end

local function tween(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function makeLabel(parent, text, size, color)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(235, 240, 255)
    l.TextSize = size or 14
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function notify(text)
    local n = Instance.new("TextLabel")
    n.AnchorPoint = Vector2.new(0.5, 0)
    n.Position = UDim2.new(0.5, 0, 0, -50)
    n.Size = UDim2.fromOffset(300, 42)
    n.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    n.TextColor3 = Color3.fromRGB(240, 245, 255)
    n.Text = text
    n.TextSize = 14
    n.Font = Enum.Font.GothamMedium
    n.Parent = gui
    corner(n, 12)
    stroke(n, 0.25)
    tween(n, {Position = UDim2.new(0.5, 0, 0, 20)}, 0.25)
    task.delay(2, function()
        tween(n, {Position = UDim2.new(0.5, 0, 0, -50)}, 0.25)
        task.wait(0.3)
        n:Destroy()
    end)
end

local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(680, 440)
main.BackgroundColor3 = Color3.fromRGB(10, 13, 21)
main.Parent = gui
corner(main, 18)
stroke(main, 0.15)

local scale = Instance.new("UIScale")
scale.Scale = 1
scale.Parent = main

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 68)
top.BackgroundColor3 = Color3.fromRGB(15, 19, 30)
top.Parent = main
corner(top, 18)

local title = makeLabel(top, "NAGI HUB", 22, Color3.fromRGB(245, 248, 255))
title.Position = UDim2.fromOffset(22, 13)
title.Size = UDim2.fromOffset(250, 28)
title.Font = Enum.Font.GothamBold

local subtitle = makeLabel(top, "TEAM ZYVORA  •  STUDIO BUILD", 11, Color3.fromRGB(125, 145, 180))
subtitle.Position = UDim2.fromOffset(24, 39)
subtitle.Size = UDim2.fromOffset(300, 18)

local close = Instance.new("TextButton")
close.AnchorPoint = Vector2.new(1, 0.5)
close.Position = UDim2.new(1, -18, 0.5, 0)
close.Size = UDim2.fromOffset(36, 36)
close.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
close.Text = "×"
close.TextColor3 = Color3.fromRGB(230, 235, 245)
close.TextSize = 24
close.Font = Enum.Font.GothamBold
close.Parent = top
corner(close, 10)
close.MouseButton1Click:Connect(function() main.Visible = false end)

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(12, 80)
sidebar.Size = UDim2.fromOffset(145, 348)
sidebar.BackgroundTransparency = 1
sidebar.Parent = main

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(169, 80)
content.Size = UDim2.new(1, -181, 1, -92)
content.BackgroundTransparency = 1
content.Parent = main

local pages = {}
local buttons = {}

local function page(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Size = UDim2.fromScale(1, 1)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 3
    p.CanvasSize = UDim2.new()
    p.Visible = false
    p.Parent = content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = p
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
    end)
    pages[name] = p
    return p
end

local function tab(name, icon)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 42)
    b.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    b.Text = "  " .. icon .. "   " .. name
    b.TextColor3 = Color3.fromRGB(145, 157, 180)
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = sidebar
    corner(b, 10)
    buttons[name] = b
    return b
end

local home = page("Home")
local playerPage = page("Player")
local visuals = page("Visuals")
local settings = page("Settings")

local function card(parent, height)
    local c = Instance.new("Frame")
    c.Size = UDim2.new(1, -4, 0, height or 70)
    c.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
    c.Parent = parent
    corner(c, 12)
    stroke(c, 0.45)
    return c
end

local welcome = card(home, 112)
local wt = makeLabel(welcome, "Welcome to NagiHub", 20)
wt.Position = UDim2.fromOffset(18, 16)
wt.Size = UDim2.new(1, -36, 28, 0)
wt.Font = Enum.Font.GothamBold
local wd = makeLabel(welcome, "A lightweight utility hub for your own Roblox experience.", 13, Color3.fromRGB(145, 157, 180))
wd.Position = UDim2.fromOffset(18, 48)
wd.Size = UDim2.new(1, -36, 24, 0)

local status = card(home, 82)
local st = makeLabel(status, "STATUS", 11, Color3.fromRGB(105, 125, 160))
st.Position = UDim2.fromOffset(18, 13)
st.Size = UDim2.new(1, -36, 18, 0)
local sv = makeLabel(status, "●  Ready", 16, Color3.fromRGB(100, 220, 155))
sv.Position = UDim2.fromOffset(18, 34)
sv.Size = UDim2.new(1, -36, 25, 0)

local function addSlider(parent, labelText, min, max, default, callback)
    local c = card(parent, 86)
    local label = makeLabel(c, labelText .. ": " .. tostring(default), 13)
    label.Position = UDim2.fromOffset(16, 10)
    label.Size = UDim2.new(1, -32, 22, 0)

    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(16, 48)
    bar.Size = UDim2.new(1, -32, 0, 8)
    bar.BackgroundColor3 = Color3.fromRGB(35, 42, 58)
    bar.Parent = c
    corner(bar, 4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(90, 130, 255)
    fill.Parent = bar
    corner(fill, 4)

    local knob = Instance.new("TextButton")
    knob.Text = ""
    knob.Size = UDim2.fromOffset(18, 18)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default-min)/(max-min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(235, 240, 255)
    knob.Parent = bar
    corner(knob, 9)

    local dragging = false
    local function setFromX(x)
        local alpha = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max-min)*alpha + 0.5)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        label.Text = labelText .. ": " .. tostring(value)
        callback(value)
    end
    knob.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)
end

local function button(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 48)
    b.BackgroundColor3 = Color3.fromRGB(20, 25, 37)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(220, 228, 245)
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.Parent = parent
    corner(b, 10)
    stroke(b, 0.5)
    b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = Color3.fromRGB(29, 37, 55)}, 0.15) end)
    b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = Color3.fromRGB(20, 25, 37)}, 0.15) end)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function getHumanoid()
    local char = player.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

addSlider(playerPage, "WalkSpeed", 8, 100, 16, function(value)
    local h = getHumanoid()
    if h then h.WalkSpeed = value end
end)

addSlider(playerPage, "JumpPower", 25, 150, 50, function(value)
    local h = getHumanoid()
    if h then
        h.UseJumpPower = true
        h.JumpPower = value
    end
end)

button(playerPage, "Reset Movement", function()
    local h = getHumanoid()
    if h then
        h.WalkSpeed = 16
        h.UseJumpPower = true
        h.JumpPower = 50
        notify("Movement reset")
    end
end)

local sprint = false
button(playerPage, "Toggle Sprint", function()
    sprint = not sprint
    local h = getHumanoid()
    if h then h.WalkSpeed = sprint and 28 or 16 end
    notify(sprint and "Sprint enabled" or "Sprint disabled")
end)

local function addSectionTitle(parent, text)
    local l = makeLabel(parent, text, 11, Color3.fromRGB(105, 125, 160))
    l.Size = UDim2.new(1, -4, 0, 20)
    l.Font = Enum.Font.GothamBold
    return l
end

addSectionTitle(visuals, "PLAYER LIST")
local playerList = card(visuals, 160)
local list = Instance.new("ScrollingFrame")
list.Position = UDim2.fromOffset(12, 12)
list.Size = UDim2.new(1, -24, 1, -24)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 2
list.Parent = playerList
local ll = Instance.new("UIListLayout")
ll.Padding = UDim.new(0, 6)
ll.Parent = list

local function refreshPlayers()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, other in ipairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -4, 0, 32)
        b.BackgroundColor3 = Color3.fromRGB(22, 27, 39)
        b.Text = other.DisplayName .. "  (" .. other.Name .. ")"
        b.TextColor3 = Color3.fromRGB(205, 214, 232)
        b.TextSize = 12
        b.Font = Enum.Font.Gotham
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = list
        corner(b, 8)
        b.MouseButton1Click:Connect(function()
            -- Teleport is intentionally local and useful for testing experiences you control.
            local myChar = player.Character
            local targetChar = other.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            if myRoot and targetRoot then
                myRoot.CFrame = targetRoot.CFrame + Vector3.new(3, 0, 0)
                notify("Moved near " .. other.DisplayName)
            end
        end)
    end
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

addSectionTitle(settings, "UI")
button(settings, "Hide NagiHub", function() main.Visible = false end)
button(settings, "Reset UI Position", function()
    main.Position = UDim2.fromScale(0.5, 0.5)
    notify("UI position reset")
end)
button(settings, "Show Notification Test", function() notify("NagiHub is working") end)

local tabNames = {
    {"Home", "◆"},
    {"Player", "◇"},
    {"Visuals", "◈"},
    {"Settings", "⚙"},
}

local function selectTab(name)
    for pageName, p in pairs(pages) do p.Visible = pageName == name end
    for buttonName, b in pairs(buttons) do
        b.BackgroundColor3 = buttonName == name and Color3.fromRGB(38, 51, 78) or Color3.fromRGB(18, 22, 32)
        b.TextColor3 = buttonName == name and Color3.fromRGB(225, 235, 255) or Color3.fromRGB(145, 157, 180)
    end
end

for i, info in ipairs(tabNames) do
    local b = tab(info[1], info[2])
    b.Position = UDim2.fromOffset(0, (i-1) * 50)
    b.MouseButton1Click:Connect(function() selectTab(info[1]) end)
end

selectTab("Home")

-- Drag support for desktop and touch.
do
    local dragging = false
    local dragStart
    local startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Small reopen button after the main window is hidden.
local reopen = Instance.new("TextButton")
reopen.AnchorPoint = Vector2.new(1, 1)
reopen.Position = UDim2.new(1, -18, 1, -18)
reopen.Size = UDim2.fromOffset(54, 54)
reopen.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
reopen.Text = "N"
reopen.TextColor3 = Color3.fromRGB(220, 230, 255)
reopen.TextSize = 22
reopen.Font = Enum.Font.GothamBold
reopen.Visible = false
reopen.Parent = gui
corner(reopen, 16)
stroke(reopen, 0.25)
close.MouseButton1Click:Connect(function() reopen.Visible = true end)
reopen.MouseButton1Click:Connect(function() main.Visible = true; reopen.Visible = false end)

notify("NagiHub loaded")
