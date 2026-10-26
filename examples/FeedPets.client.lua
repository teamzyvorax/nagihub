-- Feed Pets integration for NagiHub V3
-- Place in StarterPlayer > StarterPlayerScripts in YOUR OWN Roblox experience.
-- IMPORTANT: This script creates the shared BindableEvent itself, so it works
-- even if FeedPets loads before NagiHub.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Shared local event. NagiHub will reuse this exact event.
local feedEvent = playerGui:FindFirstChild("NagiHubFeedPets")
if not feedEvent then
    feedEvent = Instance.new("BindableEvent")
    feedEvent.Name = "NagiHubFeedPets"
    feedEvent.Parent = playerGui
end

local gui = playerGui:FindFirstChild("FeedPetsGUI")
if gui then gui:Destroy() end

gui = Instance.new("ScreenGui")
gui.Name = "FeedPetsGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local button = Instance.new("TextButton")
button.Name = "FeedButton"
button.Size = UDim2.fromOffset(220, 60)
button.Position = UDim2.new(0.5, -110, 0.8, 0)
button.Text = "🍎 FEED YOUR PETS"
button.TextScaled = true
button.Parent = gui

local clickCount = 0

local function feedPets()
    clickCount += 1
    print("FEED YOUR PETS action #" .. clickCount)

    -- PUT YOUR REAL GAME FEED/GROW FUNCTION HERE.
    -- This example creates a visible test part so you can verify AUTO CLICK.
    local camera = workspace.CurrentCamera
    if not camera then return end

    local food = Instance.new("Part")
    food.Name = "PetFood"
    food.Size = Vector3.new(2, 1, 2)
    food.Position = camera.CFrame.Position + camera.CFrame.LookVector * 5
    food.Anchored = true
    food.Parent = workspace

    task.delay(1, function()
        if food and food.Parent then
            food:Destroy()
        end
    end)
end

-- Manual button click uses the exact same function.
button.MouseButton1Click:Connect(feedPets)

-- NagiHub AUTO CLICK uses the exact same function.
feedEvent.Event:Connect(feedPets)

print("FeedPets integration loaded | BindableEvent ready")
