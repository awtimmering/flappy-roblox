# Flappy Bird Clone for Roblox

A complete Flappy Bird clone implementation for Roblox Studio with proper client-server architecture.

## Features

- **Classic Flappy Bird Gameplay**: Tap/click or press space to make the bird flap
- **Procedural Pipe Generation**: Randomly positioned pipes with gaps
- **Score System**: Points awarded for passing through pipes
- **Game States**: Menu, playing, and game over screens
- **Visual Effects**: Particle effects for flapping, scoring, and crashes
- **Sound Effects**: Audio feedback for all game actions
- **Responsive UI**: Clean, animated user interface

## Installation

1. Open Roblox Studio
2. Create a new place or open an existing one
3. Copy the script files to their corresponding locations in your game:
   - `ReplicatedStorage/RemoteEvents.lua`
   - `ServerScriptService/GameManager.lua`
   - `ServerScriptService/PipeManager.lua`
   - `StarterGui/UIController.lua`
   - `StarterPlayerScripts/BirdController.lua`
   - `StarterPlayerScripts/SoundManager.lua`
   - `StarterPlayerScripts/ParticleEffects.lua`

## File Structure

```
ReplicatedStorage/
  └── RemoteEvents.lua          # Client-server communication setup

ServerScriptService/
  ├── GameManager.lua           # Core game logic and collision detection
  └── PipeManager.lua           # Pipe generation and movement

StarterGui/
  └── UIController.lua          # User interface management

StarterPlayerScripts/
  ├── BirdController.lua        # Bird physics and input handling
  ├── SoundManager.lua          # Sound effects system
  └── ParticleEffects.lua       # Visual particle effects
```

## How to Play

1. **Start**: Click "START GAME" or flap to begin
2. **Flap**: Click, tap, or press Space to make the bird flap upward
3. **Avoid**: Don't hit the pipes or ground
4. **Score**: Gain points by passing through pipe gaps
5. **Restart**: Click "RESTART" when game over

## Technical Details

### Architecture
- **Client-Server Model**: Proper separation of client and server logic
- **RemoteEvents**: Secure communication between client and server
- **Modular Design**: Each system is contained in its own script

### Key Components
- **Bird Physics**: Custom gravity and flap mechanics
- **Collision Detection**: Server-side collision checking for security
- **Pipe System**: Continuous generation and cleanup of obstacles
- **UI System**: Animated menus and HUD elements

### Customization
You can easily modify:
- Bird physics (gravity, flap force) in `BirdController.lua`
- Pipe spacing and gap size in `PipeManager.lua`
- Visual effects in `ParticleEffects.lua`
- UI appearance in `UIController.lua`

## Credits

Created as a demonstration of Roblox game development best practices.