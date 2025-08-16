local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvents = {}

local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

local birdFlap = Instance.new("RemoteEvent")
birdFlap.Name = "BirdFlap"
birdFlap.Parent = remoteEvents

local gameStart = Instance.new("RemoteEvent")
gameStart.Name = "GameStart"
gameStart.Parent = remoteEvents

local gameOver = Instance.new("RemoteEvent")
gameOver.Name = "GameOver"
gameOver.Parent = remoteEvents

local scoreUpdate = Instance.new("RemoteEvent")
scoreUpdate.Name = "ScoreUpdate"
scoreUpdate.Parent = remoteEvents

local gameRestart = Instance.new("RemoteEvent")
gameRestart.Name = "GameRestart"
gameRestart.Parent = remoteEvents

RemoteEvents.BirdFlap = birdFlap
RemoteEvents.GameStart = gameStart
RemoteEvents.GameOver = gameOver
RemoteEvents.ScoreUpdate = scoreUpdate
RemoteEvents.GameRestart = gameRestart

return RemoteEvents