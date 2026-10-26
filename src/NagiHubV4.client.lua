-- NagiHub V4 | Team Zyvora
-- SINGLE-FILE build for YOUR OWN Roblox Studio experience.
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.
--
-- This version includes:
--   * NagiHub UI
--   * FEED YOUR PETS button
--   * AUTO CLICK that repeatedly calls the same feedPets() function
--   * OFF immediately stops the loop
--
-- Replace the body of feedPets() with your game's authorized feeding logic.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("NagiHubV4")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(8, 10, 16),
    panel = Color3.fromRGB(14, 17, 26),
    card = Color3.fromRGB(21, 25, 37),
    hover = Color3.fromRGB(30, 36, 53),
    text = Color3.fromRGB(242, 245, 255),
    muted = Color3.fromRGB(145, 154, 178),
    accent = Color3.fromRGB(90, 160, 255),
    good = Color3.fromRGB(75, 220, 145),
    off = Color3.fromRGB(75, 82, 100),
}

local gui = Instance.new("ScreenGui")
gui.Name = "NagiHubV4"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function round(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = o
end

local function stroke(o, transparency)
    local s = Instance.new("UIStroke")
    s.Color = C.accent
    s.Thickness = 1
    s.Transparency = transparency or 0.75
    s.Parent = o
end

local function textLabel(parent, value, size, color)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Text = value
    x.TextColor3 = color or C.text
    x.TextSize = size or 13
    x.Font = Enum.Font.Gotham
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.Parent = parent
    return x
end

local function notify(message)
    local n = Instance.new("TextLabel")
    n.AnchorPoint = Vector2.new(0.5, 0)
    n.Position = UDim2.new(0.5, 0, 0, -48)
    n.Size = UDim2.fromOffset(310, 38)
    n.BackgroundColor3 = C.panel
    n.TextColor3 = C.text
    n.TextSize = 12
    n.Font = Enum.Font.GothamMedium
    n.Text = message
    n.Parent = gui
    round(n, 9)
    stroke(n, 0.45)
    TweenService:Create(n, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0, 0, 18)}):Play()
    task.delay(1.4, function()
        if not n.Parent then return end
        TweenService:Create(n, TweenInfo.new(0.18), {Position = UDim2.new(0.5, 0, 0, -48)}):Play()
        task.wait(0.2)
        if n.Parent then n:Destroy() end
    end)
end

-- ============================================================
-- REAL FEED ACTION FOR YOUR OWN EXPERIENCE
-- ============================================================
local function feedPets()
    print("[NagiHub V4] FEED YOUR PETS action")

    -- TEST ACTION:
    -- Replace this section with the same function your real Feed button uses.
    local camera = workspace.CurrentCamera
    if not camera then return end

    local food = Instance.new("Part")
    food.Name = "PetFood"
    food.Size = Vector3.new(2, 1, 2)
    food.Position = camera.CFrame.Position + camera.CFrame.LookVector * 5
    food.Anchored = true
    food.CanCollide = false
    food.Parent = workspace

    task.delay(0.5, function()
        if food.Parent then food:Destroy() end
    end)
end

-- ============================================================
-- MAIN UI
-- ============================================================
local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(350, 470)
main.BackgroundColor3 = C.bg
main.Parent = gui
round(main, 14)
stroke(main, 0.3)

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 58)
top.BackgroundColor3 = C.panel
top.Parent = main
round(top, 14)

local title = textLabel(top, "⚡ NAGIHUB V4", 17, C.text)
title.Position = UDim2.fromOffset(16, 7)
title.Size = UDim2.fromOffset(220, 24)
title.Font = Enum.Font.GothamBold

local sub = textLabel(top, "TEAM ZYVORA  •  SINGLE FILE", 9, C.muted)
sub.Position = UDim2.fromOffset(18, 31)
sub.Size = UDim2.fromOffset(230, 16)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -40, 0, 14)
close.BackgroundColor3 = C.card
close.Text = "×"
close.TextColor3 = C.text
close.TextSize = 20
close.Font = Enum.Font.GothamBold
close.Parent = top
round(close, 8)

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(12, 68)
content.Size = UDim2.new(1, -24, 1, -80)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = C.accent
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingBottom = UDim.new(0, 10)
padding.Parent = content

local mainTitle = textLabel(content, "MAIN", 10, C.muted)
mainTitle.Size = UDim2.new(1, 0, 0, 20)
mainTitle.Font = Enum.Font.GothamBold

-- Manual Feed button.
local feedButton = Instance.new("TextButton")
feedButton.Size = UDim2.new(1, 0, 0, 52)
feedButton.BackgroundColor3 = C.accent
feedButton.Text = "🍎  FEED YOUR PETS"
feedButton.TextColor3 = Color3.new(1, 1, 1)
feedButton.TextSize = 14
feedButton.Font = Enum.Font.GothamBold
feedButton.AutoButtonColor = false
feedButton.Parent = content
round(feedButton, 10)
feedButton.MouseEnter:Connect(function() feedButton.BackgroundColor3 = C.good end)
feedButton.MouseLeave:Connect(function() feedButton.BackgroundColor3 = C.accent end)
feedButton.MouseButton1Click:Connect(feedPets)

local function makeToggle(name, icon, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = C.card
    row.Parent = content
    round(row, 9)
    stroke(row, 0.86)

    local txt = textLabel(row, icon .. "  " .. name, 12, C.text)
    txt.Position = UDim2.fromOffset(13, 0)
    txt.Size = UDim2.new(1, -90, 1, 0)
    txt.Font = Enum.Font.GothamMedium

    local sw = Instance.new("TextButton")
    sw.Size = UDim2.fromOffset(62, 28)
    sw.Position = UDim2.new(1, -72, 0.5, -14)
    sw.BackgroundColor3 = C.off
    sw.Text = "OFF"
    sw.TextColor3 = C.text
    sw.TextSize = 10
    sw.Font = Enum.Font.GothamBold
    sw.AutoButtonColor = false
    sw.Parent = row
    round(sw, 7)

    local state = false
    sw.MouseButton1Click:Connect(function()
        state = not state
        sw.Text = state and "ON" or "OFF"
        sw.BackgroundColor3 = state and C.good or C.off
        callback(state)
    end)
end

makeToggle("SPEED", "⚡", function(on)
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = on and 28 or 16 end
    notify(on and "Speed ON" or "Speed OFF")
end)

-- AUTO CLICK is directly connected to feedPets(), so no second script/event is required.
local autoClick = false
local autoClickThread = nil
local CLICK_INTERVAL = 0.2

local function setAutoClick(enabled)
    autoClick = enabled

    if not enabled then
        notify("Auto Click OFF")
        return
    end

    if autoClickThread then return end

    notify("Auto Click ON • 5 clicks/sec")

    autoClickThread = task.spawn(function()
        while autoClick do
            feedPets()
            task.wait(CLICK_INTERVAL)
        end
        autoClickThread = nil
    end)
end

makeToggle("AUTO CLICK", "🖱", setAutoClick)

makeToggle("AUTO FEED", "🍖", function(on)
    notify(on and "Auto Feed hook enabled" or "Auto Feed OFF")
end)

makeToggle("AUTO PET", "🐾", function(on)
    notify(on and "Auto Pet hook enabled" or "Auto Pet OFF")
end)

makeToggle("AUTO EVENT", "🎯", function(on)
    notify(on and "Auto Event hook enabled" or "Auto Event OFF")
end)

local customTitle = textLabel(content, "CUSTOM", 10, C.muted)
customTitle.Size = UDim2.new(1, 0, 0, 20)
customTitle.Font = Enum.Font.GothamBold

local speedBox = Instance.new("Frame")
speedBox.Size = UDim2.new(1, 0, 0, 48)
speedBox.BackgroundColor3 = C.card
speedBox.Parent = content
round(speedBox, 9)
stroke(speedBox, 0.86)

local speedText = textLabel(speedBox, "Speed Value", 12, C.text)
speedText.Position = UDim2.fromOffset(13, 0)
speedText.Size = UDim2.fromOffset(120, 48)

local input = Instance.new("TextBox")
input.Size = UDim2.fromOffset(80, 30)
input.Position = UDim2.new(1, -92, 0.5, -15)
input.BackgroundColor3 = C.panel
input.Text = "28"
input.TextColor3 = C.text
input.TextSize = 12
input.Font = Enum.Font.GothamMedium
input.ClearTextOnFocus = false
input.Parent = speedBox
round(input, 7)
stroke(input, 0.75)

input.FocusLost:Connect(function()
    local value = tonumber(input.Text)
    if not value then
        input.Text = "28"
        notify("Invalid speed value")
        return
    end
    input.Text = tostring(math.clamp(math.floor(value), 8, 100))
end)

local hide = Instance.new("TextButton")
hide.Size = UDim2.new(1, 0, 0, 42)
hide.BackgroundColor3 = C.card
hide.Text = "⚙  HIDE NAGIHUB"
hide.TextColor3 = C.text
hide.TextSize = 12
hide.Font = Enum.Font.GothamMedium
hide.TextXAlignment = Enum.TextXAlignment.Left
hide.Parent = content
round(hide, 9)
stroke(hide, 0.82)

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(125, 38)
reopen.Position = UDim2.fromOffset(18, 110)
reopen.BackgroundColor3 = C.panel
reopen.Text = "⚡ NAGIHUB"
reopen.TextColor3 = C.accent
reopen.TextSize = 12
reopen.Font = Enum.Font.GothamBold
reopen.Visible = false
reopen.Parent = gui
round(reopen, 9)
stroke(reopen, 0.35)

local function hideHub()
    main.Visible = false
    reopen.Visible = true
end

hide.MouseButton1Click:Connect(hideHub)
close.MouseButton1Click:Connect(hideHub)
reopen.MouseButton1Click:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

-- Drag window.
local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inputObject.Position
        startPos = main.Position
    end
end)

top.InputEnded:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(inputObject)
    if not dragging then return end
    if inputObject.UserInputType ~= Enum.UserInputType.MouseMovement and inputObject.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = inputObject.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end)

local fpsFrames = 0
local fpsClock = os.clock()
RunService.RenderStepped:Connect(function()
    fpsFrames += 1
    if os.clock() - fpsClock >= 1 then
        sub.Text = string.format("TEAM ZYVORA  •  FPS %d", fpsFrames)
        fpsFrames = 0
        fpsClock = os.clock()
    end
end)

notify("NagiHub V4 loaded")
print("NagiHub V4 loaded | PlaceId:", game.PlaceId)
