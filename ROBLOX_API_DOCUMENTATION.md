# Roblox API Documentation

This document explains all the key Roblox APIs used in the Flappy Bird clone
implementation.

## Core Services

### game:GetService()

Used to access Roblox services safely. Services are singleton objects that
provide specific functionality.

```lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
```

**Key Services Used:**

#### Players

Manages all players in the game.

- `Players.LocalPlayer` - Reference to the current client's player
- `Players:GetPlayers()` - Returns array of all players

#### RunService

Provides events that fire during different phases of the game loop.

- `RunService.Heartbeat` - Fires every frame after physics simulation
- `RunService.Heartbeat:Connect(function)` - Connects a function to run every
  frame
- `RunService.Heartbeat:Wait()` - Returns time since last frame (delta time)

#### UserInputService

Handles user input on the client side.

- `UserInputService.InputBegan` - Event that fires when input begins
- `UserInputService.UserInputType` - Enum for different input types
- `UserInputService.KeyCode` - Enum for keyboard keys

#### ReplicatedStorage

Container for objects that should be replicated to all clients.

- Shared between server and all clients
- Used for RemoteEvents and shared modules

#### TweenService

Creates smooth animations between property values.

- `TweenService:Create(object, tweenInfo, propertyTable)` - Creates a tween
- `TweenInfo.new(time, easingStyle, easingDirection)` - Tween configuration

#### SoundService

Manages audio in the game.

- Container for Sound objects
- Provides audio-related settings

## Instance Classes

### Part

3D objects in the workspace.

```lua
local part = Instance.new("Part")
part.Size = Vector3.new(4, 1, 2)
part.Position = Vector3.new(0, 10, 0)
part.BrickColor = BrickColor.new("Bright red")
part.CanCollide = false
part.Anchored = true
```

**Key Properties:**

- `Size` - Vector3 defining dimensions
- `Position` - Vector3 world position
- `Rotation` - Vector3 rotation in degrees
- `BrickColor` - Color of the part
- `CanCollide` - Whether part participates in physics collisions
- `Anchored` - Whether part is fixed in place
- `Shape` - PartType enum (Block, Ball, Cylinder, etc.)
- `Parent` - Where the object is placed in hierarchy

### BodyVelocity

Physics object that applies constant velocity to a part.

```lua
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
bodyVelocity.Velocity = Vector3.new(0, 50, 0)
bodyVelocity.Parent = part
```

**Key Properties:**

- `Velocity` - Vector3 target velocity
- `MaxForce` - Vector3 maximum force that can be applied

### RemoteEvent

Enables communication between server and clients.

```lua
local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "BirdFlap"
remoteEvent.Parent = ReplicatedStorage

-- Server side
remoteEvent.OnServerEvent:Connect(function(player, ...)
    -- Handle event from client
end)
remoteEvent:FireClient(player, data)
remoteEvent:FireAllClients(data)

-- Client side
remoteEvent.OnClientEvent:Connect(function(...)
    -- Handle event from server
end)
remoteEvent:FireServer(data)
```

### Sound

Audio objects for playing sound effects.

```lua
local sound = Instance.new("Sound")
sound.SoundId = "rbxasset://sounds/bell.mp3"
sound.Volume = 0.5
sound.Pitch = 1.2
sound:Play()
```

**Key Properties:**

- `SoundId` - Asset ID or rbxasset path
- `Volume` - Loudness (0-1)
- `Pitch` - Playback speed multiplier

## GUI Classes

### ScreenGui

Top-level container for GUI elements.

```lua
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui
```

### Frame

Rectangular GUI container.

```lua
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5, 0, 0.3, 0)
frame.Position = UDim2.new(0.25, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
```

### TextLabel

Displays text in the GUI.

```lua
local label = Instance.new("TextLabel")
label.Text = "Score: 0"
label.TextScaled = true
label.Font = Enum.Font.SourceSansBold
label.TextColor3 = Color3.fromRGB(0, 0, 0)
```

### TextButton

Clickable button with text.

```lua
local button = Instance.new("TextButton")
button.Text = "Start Game"
button.MouseButton1Click:Connect(function()
    -- Handle click
end)
```

## Data Types

### Vector3

3D coordinate or direction.

```lua
local position = Vector3.new(x, y, z)
local direction = Vector3.new(0, 1, 0) -- Up direction
```

### UDim2

2D size/position with scale and offset components.

```lua
-- UDim2.new(xScale, xOffset, yScale, yOffset)
local size = UDim2.new(0.5, 0, 0.3, 0) -- 50% width, 30% height
local position = UDim2.new(0.25, 0, 0.35, 0) -- 25% from left, 35% from top
```

### Color3

RGB color values (0-1 range).

```lua
local white = Color3.fromRGB(255, 255, 255)
local red = Color3.new(1, 0, 0)
```

### BrickColor

Predefined Roblox colors.

```lua
local color = BrickColor.new("Bright red")
local randomColor = BrickColor.random()
```

## Events and Connections

### RBXScriptConnection

Returned when connecting to events.

```lua
local connection = event:Connect(function()
    -- Event handler
end)

-- Later...
connection:Disconnect() -- Stop listening to event
```

### Common Event Patterns

```lua
-- User input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Handle click
    end
end)

-- RemoteEvent communication
remoteEvent.OnServerEvent:Connect(function(player, data)
    -- Validate data from client
    -- Process server-side logic
end)

-- Tween completion
tween.Completed:Connect(function()
    -- Handle animation finished
end)
```

## Security Considerations

### Client-Server Model

- **Server Authority**: Game logic runs on server for security
- **Client Prediction**: UI and visual effects on client for responsiveness
- **Validation**: Always validate client input on server

### RemoteEvent Best Practices

- Validate all parameters from clients
- Rate limit RemoteEvent calls
- Don't trust client data for important game logic

### Example Validation

```lua
-- Server-side validation
RemoteEvents.BirdFlap.OnServerEvent:Connect(function(player)
    -- Check if player can flap (cooldown, game state, etc.)
    if canPlayerFlap(player) then
        -- Process flap
    end
end)
```

## Performance Tips

### Efficient Object Management

- Reuse objects instead of creating/destroying constantly
- Use object pooling for frequently created objects (particles)
- Clean up connections when no longer needed

### RunService Usage

- Use Heartbeat for frame-rate dependent updates
- Disconnect RunService connections when not needed
- Avoid heavy calculations in RunService loops

### Memory Management

- Set Parent to nil or call :Destroy() on unused objects
- Disconnect event connections
- Clear large tables when done

This documentation covers the essential Roblox APIs used in the Flappy Bird
implementation. Each API serves a specific purpose in creating a complete,
functional game experience.
