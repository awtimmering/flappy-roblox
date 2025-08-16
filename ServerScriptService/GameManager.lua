local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RemoteEvents = require(ReplicatedStorage:WaitForChild("RemoteEvents"))
local PipeManager = require(script.Parent:WaitForChild("PipeManager"))

local GameManager = {}

local gameState = "menu"
local playerScores = {}
local gameConnection = nil

local function getBird()
    return workspace:FindFirstChild("Bird")
end

local function checkCollisions()
    local bird = getBird()
    if not bird then
        return false
    end
    
    local birdPosition = bird.Position
    
    if birdPosition.Y < -10 then
        return true
    end
    
    if birdPosition.Y > 50 then
        return true
    end
    
    local pipes = PipeManager.GetPipes()
    for _, pipeSet in pairs(pipes) do
        if pipeSet.top and pipeSet.bottom then
            local topPipe = pipeSet.top
            local bottomPipe = pipeSet.bottom
            
            local birdRadius = 1
            local pipeWidth = topPipe.Size.X / 2
            
            if math.abs(birdPosition.X - topPipe.Position.X) < (birdRadius + pipeWidth) and
               math.abs(birdPosition.Z - topPipe.Position.Z) < 2 then
                
                if birdPosition.Y > (bottomPipe.Position.Y + bottomPipe.Size.Y/2) and
                   birdPosition.Y < (topPipe.Position.Y - topPipe.Size.Y/2) then
                else
                    return true
                end
            end
        end
    end
    
    return false
end

local function gameLoop()
    if gameState ~= "playing" then
        return
    end
    
    if checkCollisions() then
        endGame()
    end
end

local function startGame(player)
    if gameState == "playing" then
        return
    end
    
    gameState = "playing"
    
    for _, p in pairs(Players:GetPlayers()) do
        playerScores[p.UserId] = 0
    end
    
    PipeManager.StartGame()
    
    if gameConnection then
        gameConnection:Disconnect()
    end
    gameConnection = RunService.Heartbeat:Connect(gameLoop)
    
    RemoteEvents.GameStart:FireAllClients()
end

local function endGame()
    if gameState ~= "playing" then
        return
    end
    
    gameState = "gameOver"
    
    PipeManager.StopGame()
    
    if gameConnection then
        gameConnection:Disconnect()
        gameConnection = nil
    end
    
    RemoteEvents.GameOver:FireAllClients()
end

local function restartGame(player)
    gameState = "menu"
    PipeManager.ClearPipes()
    
    wait(0.5)
    startGame(player)
end

local function updateScore(player)
    if gameState ~= "playing" then
        return
    end
    
    if not playerScores[player.UserId] then
        playerScores[player.UserId] = 0
    end
    
    playerScores[player.UserId] = playerScores[player.UserId] + 1
    RemoteEvents.ScoreUpdate:FireClient(player, playerScores[player.UserId])
end

RemoteEvents.GameStart.OnServerEvent:Connect(startGame)
RemoteEvents.GameRestart.OnServerEvent:Connect(restartGame)
RemoteEvents.ScoreUpdate.OnServerEvent:Connect(updateScore)

RemoteEvents.BirdFlap.OnServerEvent:Connect(function(player)
    if gameState == "menu" then
        startGame(player)
    end
end)

GameManager.StartGame = startGame
GameManager.EndGame = endGame
GameManager.RestartGame = restartGame
GameManager.GetGameState = function() return gameState end
GameManager.GetScore = function(player) return playerScores[player.UserId] or 0 end

return GameManager