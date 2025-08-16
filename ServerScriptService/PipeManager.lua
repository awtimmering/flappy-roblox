local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local RemoteEvents = require(ReplicatedStorage:WaitForChild("RemoteEvents"))

local PipeManager = {}

local pipes = {}
local pipeSpeed = 20
local pipeSpacing = 25
local gapSize = 8
local pipeWidth = 3
local pipeHeight = 20
local spawnDistance = 50
local despawnDistance = -30
local lastSpawnX = 0
local isGameActive = false

local function createPipe(x, gapY)
    local topPipe = Instance.new("Part")
    topPipe.Name = "TopPipe"
    topPipe.Size = Vector3.new(pipeWidth, pipeHeight, 4)
    topPipe.BrickColor = BrickColor.new("Dark green")
    topPipe.Anchored = true
    topPipe.CanCollide = true
    topPipe.Position = Vector3.new(x, gapY + gapSize/2 + pipeHeight/2, 0)
    topPipe.Parent = workspace
    
    local bottomPipe = Instance.new("Part")
    bottomPipe.Name = "BottomPipe"
    bottomPipe.Size = Vector3.new(pipeWidth, pipeHeight, 4)
    bottomPipe.BrickColor = BrickColor.new("Dark green")
    bottomPipe.Anchored = true
    bottomPipe.CanCollide = true
    bottomPipe.Position = Vector3.new(x, gapY - gapSize/2 - pipeHeight/2, 0)
    bottomPipe.Parent = workspace
    
    local pipeSet = {
        top = topPipe,
        bottom = bottomPipe,
        x = x,
        scored = false
    }
    
    table.insert(pipes, pipeSet)
    return pipeSet
end

local function spawnPipes()
    if not isGameActive then
        return
    end
    
    if spawnDistance - lastSpawnX >= pipeSpacing then
        local gapY = math.random(-5, 15)
        createPipe(spawnDistance, gapY)
        lastSpawnX = spawnDistance
    end
end

local function movePipes()
    if not isGameActive then
        return
    end
    
    for i = #pipes, 1, -1 do
        local pipeSet = pipes[i]
        
        pipeSet.x = pipeSet.x - pipeSpeed * RunService.Heartbeat:Wait()
        pipeSet.top.Position = Vector3.new(pipeSet.x, pipeSet.top.Position.Y, 0)
        pipeSet.bottom.Position = Vector3.new(pipeSet.x, pipeSet.bottom.Position.Y, 0)
        
        if pipeSet.x < despawnDistance then
            pipeSet.top:Destroy()
            pipeSet.bottom:Destroy()
            table.remove(pipes, i)
        end
    end
end

local function checkScoring()
    if not isGameActive then
        return
    end
    
    for _, pipeSet in pairs(pipes) do
        if not pipeSet.scored and pipeSet.x < -2 then
            pipeSet.scored = true
            RemoteEvents.ScoreUpdate:FireAllClients()
        end
    end
end

local function clearAllPipes()
    for _, pipeSet in pairs(pipes) do
        if pipeSet.top then
            pipeSet.top:Destroy()
        end
        if pipeSet.bottom then
            pipeSet.bottom:Destroy()
        end
    end
    pipes = {}
    lastSpawnX = 0
end

local function startGame()
    isGameActive = true
    clearAllPipes()
    
    RunService.Heartbeat:Connect(function()
        if isGameActive then
            spawnPipes()
            movePipes()
            checkScoring()
        end
    end)
end

local function stopGame()
    isGameActive = false
end

RemoteEvents.GameStart.OnServerEvent:Connect(function(player)
    startGame()
    RemoteEvents.GameStart:FireAllClients()
end)

RemoteEvents.GameRestart.OnServerEvent:Connect(function(player)
    startGame()
    RemoteEvents.GameRestart:FireAllClients()
end)

RemoteEvents.GameOver.OnServerEvent:Connect(function(player)
    stopGame()
    RemoteEvents.GameOver:FireAllClients()
end)

PipeManager.StartGame = startGame
PipeManager.StopGame = stopGame
PipeManager.GetPipes = function() return pipes end
PipeManager.ClearPipes = clearAllPipes

return PipeManager