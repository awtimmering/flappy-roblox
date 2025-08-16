local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local RemoteEvents = require(ReplicatedStorage:WaitForChild("RemoteEvents"))

local BirdController = {}

local bird = nil
local bodyVelocity = nil
local isGameActive = false
local flapForce = 50
local gravity = -120
local currentVelocity = 0
local maxFallSpeed = -60

local function createBird()
    bird = Instance.new("Part")
    bird.Name = "Bird"
    bird.Size = Vector3.new(2, 2, 2)
    bird.Shape = Enum.PartType.Ball
    bird.BrickColor = BrickColor.new("Bright yellow")
    bird.CanCollide = false
    bird.Position = Vector3.new(0, 10, 0)
    bird.Parent = workspace
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = bird
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Scale = Vector3.new(1.2, 1, 1.2)
    mesh.Parent = bird
end

local function updateBirdPhysics()
    if not bird or not bodyVelocity or not isGameActive then
        return
    end
    
    currentVelocity = currentVelocity + gravity * RunService.Heartbeat:Wait()
    currentVelocity = math.max(currentVelocity, maxFallSpeed)
    
    bodyVelocity.Velocity = Vector3.new(0, currentVelocity, 0)
    
    local rotationAngle = math.clamp(currentVelocity * 2, -45, 45)
    bird.Rotation = Vector3.new(0, 0, rotationAngle)
end

local function flapBird()
    if not isGameActive then
        return
    end
    
    currentVelocity = flapForce
    RemoteEvents.BirdFlap:FireServer()
    
    local flapTween = TweenService:Create(
        bird,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = Vector3.new(2.2, 1.8, 2.2)}
    )
    flapTween:Play()
    
    flapTween.Completed:Connect(function()
        local returnTween = TweenService:Create(
            bird,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Size = Vector3.new(2, 2, 2)}
        )
        returnTween:Play()
    end)
end

local function onInputBegan(input, gameProcessed)
    if gameProcessed then
        return
    end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch or
       input.KeyCode == Enum.KeyCode.Space then
        flapBird()
    end
end

local function startGame()
    isGameActive = true
    currentVelocity = 0
    
    if not bird then
        createBird()
    else
        bird.Position = Vector3.new(0, 10, 0)
        bird.Rotation = Vector3.new(0, 0, 0)
        currentVelocity = 0
    end
    
    RunService.Heartbeat:Connect(updateBirdPhysics)
end

local function stopGame()
    isGameActive = false
    currentVelocity = 0
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end

RemoteEvents.GameStart.OnClientEvent:Connect(startGame)
RemoteEvents.GameOver.OnClientEvent:Connect(stopGame)
RemoteEvents.GameRestart.OnClientEvent:Connect(startGame)

UserInputService.InputBegan:Connect(onInputBegan)

BirdController.StartGame = startGame
BirdController.StopGame = stopGame
BirdController.GetBird = function() return bird end

return BirdController