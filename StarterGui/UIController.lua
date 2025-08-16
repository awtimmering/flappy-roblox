local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RemoteEvents = require(ReplicatedStorage:WaitForChild("RemoteEvents"))

local UIController = {}

local screenGui = nil
local menuFrame = nil
local gameFrame = nil
local gameOverFrame = nil
local scoreLabel = nil
local currentScore = 0

local function createScreenGui()
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlappyBirdUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(135, 206, 235)
    background.BorderSizePixel = 0
    background.Parent = screenGui
    
    local clouds = Instance.new("ImageLabel")
    clouds.Name = "Clouds"
    clouds.Size = UDim2.new(1.2, 0, 0.3, 0)
    clouds.Position = UDim2.new(0, 0, 0, 0)
    clouds.BackgroundTransparency = 1
    clouds.ImageColor3 = Color3.fromRGB(255, 255, 255)
    clouds.ImageTransparency = 0.8
    clouds.Parent = background
end

local function createMenuFrame()
    menuFrame = Instance.new("Frame")
    menuFrame.Name = "MenuFrame"
    menuFrame.Size = UDim2.new(0.6, 0, 0.8, 0)
    menuFrame.Position = UDim2.new(0.2, 0, 0.1, 0)
    menuFrame.BackgroundTransparency = 1
    menuFrame.Parent = screenGui
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0.3, 0)
    titleLabel.Position = UDim2.new(0, 0, 0.1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "FLAPPY BIRD"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.Parent = menuFrame
    
    local startButton = Instance.new("TextButton")
    startButton.Name = "StartButton"
    startButton.Size = UDim2.new(0.5, 0, 0.15, 0)
    startButton.Position = UDim2.new(0.25, 0, 0.5, 0)
    startButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    startButton.Text = "START GAME"
    startButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    startButton.TextScaled = true
    startButton.Font = Enum.Font.SourceSansBold
    startButton.BorderSizePixel = 3
    startButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    startButton.Parent = menuFrame
    
    local instructionLabel = Instance.new("TextLabel")
    instructionLabel.Name = "InstructionLabel"
    instructionLabel.Size = UDim2.new(1, 0, 0.2, 0)
    instructionLabel.Position = UDim2.new(0, 0, 0.7, 0)
    instructionLabel.BackgroundTransparency = 1
    instructionLabel.Text = "Click or press SPACE to flap!"
    instructionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    instructionLabel.TextScaled = true
    instructionLabel.Font = Enum.Font.SourceSans
    instructionLabel.TextStrokeTransparency = 0
    instructionLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    instructionLabel.Parent = menuFrame
    
    startButton.MouseButton1Click:Connect(function()
        RemoteEvents.GameStart:FireServer()
    end)
end

local function createGameFrame()
    gameFrame = Instance.new("Frame")
    gameFrame.Name = "GameFrame"
    gameFrame.Size = UDim2.new(1, 0, 1, 0)
    gameFrame.BackgroundTransparency = 1
    gameFrame.Visible = false
    gameFrame.Parent = screenGui
    
    scoreLabel = Instance.new("TextLabel")
    scoreLabel.Name = "ScoreLabel"
    scoreLabel.Size = UDim2.new(0.3, 0, 0.15, 0)
    scoreLabel.Position = UDim2.new(0.35, 0, 0.05, 0)
    scoreLabel.BackgroundTransparency = 1
    scoreLabel.Text = "0"
    scoreLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    scoreLabel.TextScaled = true
    scoreLabel.Font = Enum.Font.SourceSansBold
    scoreLabel.TextStrokeTransparency = 0
    scoreLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    scoreLabel.Parent = gameFrame
end

local function createGameOverFrame()
    gameOverFrame = Instance.new("Frame")
    gameOverFrame.Name = "GameOverFrame"
    gameOverFrame.Size = UDim2.new(0.6, 0, 0.6, 0)
    gameOverFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
    gameOverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    gameOverFrame.BackgroundTransparency = 0.3
    gameOverFrame.BorderSizePixel = 3
    gameOverFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    gameOverFrame.Visible = false
    gameOverFrame.Parent = screenGui
    
    local gameOverLabel = Instance.new("TextLabel")
    gameOverLabel.Name = "GameOverLabel"
    gameOverLabel.Size = UDim2.new(1, 0, 0.3, 0)
    gameOverLabel.Position = UDim2.new(0, 0, 0.1, 0)
    gameOverLabel.BackgroundTransparency = 1
    gameOverLabel.Text = "GAME OVER"
    gameOverLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    gameOverLabel.TextScaled = true
    gameOverLabel.Font = Enum.Font.SourceSansBold
    gameOverLabel.Parent = gameOverFrame
    
    local finalScoreLabel = Instance.new("TextLabel")
    finalScoreLabel.Name = "FinalScoreLabel"
    finalScoreLabel.Size = UDim2.new(1, 0, 0.2, 0)
    finalScoreLabel.Position = UDim2.new(0, 0, 0.4, 0)
    finalScoreLabel.BackgroundTransparency = 1
    finalScoreLabel.Text = "Score: 0"
    finalScoreLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    finalScoreLabel.TextScaled = true
    finalScoreLabel.Font = Enum.Font.SourceSans
    finalScoreLabel.Parent = gameOverFrame
    
    local restartButton = Instance.new("TextButton")
    restartButton.Name = "RestartButton"
    restartButton.Size = UDim2.new(0.6, 0, 0.2, 0)
    restartButton.Position = UDim2.new(0.2, 0, 0.7, 0)
    restartButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    restartButton.Text = "RESTART"
    restartButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    restartButton.TextScaled = true
    restartButton.Font = Enum.Font.SourceSansBold
    restartButton.BorderSizePixel = 2
    restartButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    restartButton.Parent = gameOverFrame
    
    restartButton.MouseButton1Click:Connect(function()
        RemoteEvents.GameRestart:FireServer()
    end)
    
    return finalScoreLabel
end

local function showMenu()
    menuFrame.Visible = true
    gameFrame.Visible = false
    gameOverFrame.Visible = false
end

local function showGame()
    menuFrame.Visible = false
    gameFrame.Visible = true
    gameOverFrame.Visible = false
    currentScore = 0
    scoreLabel.Text = "0"
end

local function showGameOver()
    gameFrame.Visible = false
    gameOverFrame.Visible = true
    local finalScoreLabel = gameOverFrame:FindFirstChild("FinalScoreLabel")
    if finalScoreLabel then
        finalScoreLabel.Text = "Score: " .. currentScore
    end
end

local function updateScore(score)
    currentScore = score or currentScore + 1
    scoreLabel.Text = tostring(currentScore)
    
    local scoreTween = TweenService:Create(
        scoreLabel,
        TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
        {TextSize = 48}
    )
    scoreTween:Play()
    
    scoreTween.Completed:Connect(function()
        local returnTween = TweenService:Create(
            scoreLabel,
            TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.In),
            {TextSize = 36}
        )
        returnTween:Play()
    end)
end

local function initialize()
    createScreenGui()
    createMenuFrame()
    createGameFrame()
    createGameOverFrame()
    showMenu()
end

RemoteEvents.GameStart.OnClientEvent:Connect(showGame)
RemoteEvents.GameOver.OnClientEvent:Connect(showGameOver)
RemoteEvents.GameRestart.OnClientEvent:Connect(showGame)
RemoteEvents.ScoreUpdate.OnClientEvent:Connect(updateScore)

initialize()

UIController.ShowMenu = showMenu
UIController.ShowGame = showGame
UIController.ShowGameOver = showGameOver
UIController.UpdateScore = updateScore

return UIController