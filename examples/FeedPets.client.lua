-- Feed Pets integration for NagiHub V3
-- Place in StarterPlayer > StarterPlayerScripts in YOUR OWN Roblox experience.
-- This keeps the normal button click and lets NagiHub AUTO CLICK request the same action.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "FeedPetsGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.fromOffset(220, 60)
button.Position = UDim2.new(0.5, -110, 0.8, 0)
button.Text = "🍎 FEED YOUR PETS"
button.TextScaled = true
button.Parent = gui

local function feedPets()
    print("FEED YOUR PETS clicked!")

    -- Your normal food/growth action.
    local food = Instance.new("Part")
    food.Name = "PetFood"
    food.Size = Vector3.new(2, 1, 2)
    food.Position = workspace.CurrentCamera.CFrame.Position + Vector3.new(0, 0, -5)
    food.Anchored = true
    food.Parent = workspace
end

-- Normal manual click.
button.MouseButton1Click:Connect(feedPets)

-- NagiHub AUTO CLICK integration.
local feedEvent = playerGui:WaitForChild("NagiHubFeedPets", 10)
if feedEvent and feedEvent:IsA("BindableEvent") then
    feedEvent.Event:Connect(feedPets)
end
