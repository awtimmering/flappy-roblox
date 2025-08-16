local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local RemoteEvents = require(ReplicatedStorage:WaitForChild("RemoteEvents"))

local SoundManager = {}

local sounds = {}

local function createSound(name, soundId, volume, pitch)
    local sound = Instance.new("Sound")
    sound.Name = name
    sound.SoundId = soundId
    sound.Volume = volume or 0.5
    sound.Pitch = pitch or 1
    sound.Parent = SoundService
    sounds[name] = sound
    return sound
end

local function playSound(name)
    if sounds[name] then
        sounds[name]:Play()
    end
end

local function initializeSounds()
    createSound("Flap", "rbxasset://sounds/electronicpingshort.wav", 0.3, 1.5)
    createSound("Score", "rbxasset://sounds/bell.mp3", 0.4, 1.2)
    createSound("GameOver", "rbxasset://sounds/uuhhh.mp3", 0.6, 0.8)
    createSound("GameStart", "rbxasset://sounds/switch.mp3", 0.4, 1.1)
end

RemoteEvents.BirdFlap.OnClientEvent:Connect(function()
    playSound("Flap")
end)

RemoteEvents.ScoreUpdate.OnClientEvent:Connect(function()
    playSound("Score")
end)

RemoteEvents.GameOver.OnClientEvent:Connect(function()
    playSound("GameOver")
end)

RemoteEvents.GameStart.OnClientEvent:Connect(function()
    playSound("GameStart")
end)

initializeSounds()

SoundManager.PlaySound = playSound
SoundManager.CreateSound = createSound

return SoundManager