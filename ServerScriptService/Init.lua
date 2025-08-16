-- Init.lua - Ensures proper initialization order
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for RemoteEvents to be created
local RemoteEvents = require(ReplicatedStorage:WaitForChild("RemoteEvents"))

-- Initialize managers in proper order
local PipeManager = require(script.Parent:WaitForChild("PipeManager"))
local GameManager = require(script.Parent:WaitForChild("GameManager"))

print("Flappy Bird server initialized successfully!")

-- Optional: Add server-side commands for testing
game.Players.PlayerAdded:Connect(function(player)
    print("Player joined:", player.Name)
end)