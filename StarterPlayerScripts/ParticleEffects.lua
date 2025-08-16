local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local RemoteEvents = require(ReplicatedStorage:WaitForChild("RemoteEvents"))

local ParticleEffects = {}

local function createFlapParticles(bird)
    if not bird then return end
    
    for i = 1, 5 do
        local particle = Instance.new("Part")
        particle.Name = "FlapParticle"
        particle.Size = Vector3.new(0.2, 0.2, 0.2)
        particle.Shape = Enum.PartType.Ball
        particle.BrickColor = BrickColor.new("White")
        particle.CanCollide = false
        particle.Anchored = true
        particle.Transparency = 0.3
        particle.Parent = workspace
        
        local startPos = bird.Position + Vector3.new(
            math.random(-2, 2),
            math.random(-1, 1),
            math.random(-1, 1)
        )
        particle.Position = startPos
        
        local endPos = startPos + Vector3.new(
            math.random(-5, 5),
            math.random(-3, 3),
            math.random(-2, 2)
        )
        
        local tween = TweenService:Create(
            particle,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Position = endPos,
                Transparency = 1,
                Size = Vector3.new(0.05, 0.05, 0.05)
            }
        )
        
        tween:Play()
        tween.Completed:Connect(function()
            particle:Destroy()
        end)
    end
end

local function createScoreParticles(position)
    for i = 1, 8 do
        local particle = Instance.new("Part")
        particle.Name = "ScoreParticle"
        particle.Size = Vector3.new(0.3, 0.3, 0.3)
        particle.Shape = Enum.PartType.Ball
        particle.BrickColor = BrickColor.new("Bright yellow")
        particle.CanCollide = false
        particle.Anchored = true
        particle.Transparency = 0.2
        particle.Parent = workspace
        
        particle.Position = position or Vector3.new(0, 10, 0)
        
        local endPos = particle.Position + Vector3.new(
            math.random(-8, 8),
            math.random(3, 8),
            math.random(-3, 3)
        )
        
        local tween = TweenService:Create(
            particle,
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Position = endPos,
                Transparency = 1,
                Size = Vector3.new(0.1, 0.1, 0.1)
            }
        )
        
        tween:Play()
        tween.Completed:Connect(function()
            particle:Destroy()
        end)
    end
end

local function createCrashParticles(position)
    for i = 1, 12 do
        local particle = Instance.new("Part")
        particle.Name = "CrashParticle"
        particle.Size = Vector3.new(0.4, 0.4, 0.4)
        particle.Shape = Enum.PartType.Block
        particle.BrickColor = BrickColor.new("Bright red")
        particle.CanCollide = false
        particle.Anchored = true
        particle.Transparency = 0.1
        particle.Parent = workspace
        
        particle.Position = position or Vector3.new(0, 10, 0)
        
        local endPos = particle.Position + Vector3.new(
            math.random(-10, 10),
            math.random(-5, 5),
            math.random(-5, 5)
        )
        
        local tween = TweenService:Create(
            particle,
            TweenInfo.new(1.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
            {
                Position = endPos,
                Transparency = 1,
                Size = Vector3.new(0.05, 0.05, 0.05),
                Rotation = Vector3.new(
                    math.random(0, 360),
                    math.random(0, 360),
                    math.random(0, 360)
                )
            }
        )
        
        tween:Play()
        tween.Completed:Connect(function()
            particle:Destroy()
        end)
    end
end

RemoteEvents.BirdFlap.OnClientEvent:Connect(function()
    local bird = workspace:FindFirstChild("Bird")
    if bird then
        createFlapParticles(bird)
    end
end)

RemoteEvents.ScoreUpdate.OnClientEvent:Connect(function()
    local bird = workspace:FindFirstChild("Bird")
    if bird then
        createScoreParticles(bird.Position)
    end
end)

RemoteEvents.GameOver.OnClientEvent:Connect(function()
    local bird = workspace:FindFirstChild("Bird")
    if bird then
        createCrashParticles(bird.Position)
    end
end)

ParticleEffects.CreateFlapParticles = createFlapParticles
ParticleEffects.CreateScoreParticles = createScoreParticles
ParticleEffects.CreateCrashParticles = createCrashParticles

return ParticleEffects