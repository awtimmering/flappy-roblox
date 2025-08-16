# Roblox Studio Setup Guide

This guide explains how to get the Flappy Bird clone working in Roblox Studio.

## Method 1: Manual Setup (Easiest)

### Step 1: Create a New Place
1. Open Roblox Studio
2. Create a new Baseplate template
3. Save your place

### Step 2: Copy Scripts Manually
Copy each script file to its corresponding location in Roblox Studio:

1. **ReplicatedStorage/RemoteEvents.lua**
   - In Explorer, right-click ReplicatedStorage
   - Insert → Object → ModuleScript
   - Rename to "RemoteEvents"
   - Replace the code with contents from `ReplicatedStorage/RemoteEvents.lua`

2. **ServerScriptService Scripts**
   - Right-click ServerScriptService
   - Insert → Object → Script (not LocalScript!)
   - Create "GameManager" and paste code from `ServerScriptService/GameManager.lua`
   - Create "PipeManager" and paste code from `ServerScriptService/PipeManager.lua`

3. **StarterGui/UIController.lua**
   - Right-click StarterGui
   - Insert → Object → LocalScript
   - Rename to "UIController"
   - Paste code from `StarterGui/UIController.lua`

4. **StarterPlayerScripts**
   - Right-click StarterPlayer → StarterPlayerScripts
   - Insert → Object → LocalScript for each:
     - "BirdController" (from `StarterPlayerScripts/BirdController.lua`)
     - "SoundManager" (from `StarterPlayerScripts/SoundManager.lua`)
     - "ParticleEffects" (from `StarterPlayerScripts/ParticleEffects.lua`)

### Step 3: Test the Game
1. Press F5 or click the Play button
2. Click "START GAME" in the menu
3. Use mouse clicks or spacebar to flap

## Method 2: Using Rojo (Advanced)

### Prerequisites
- Install [Node.js](https://nodejs.org/)
- Install Rojo: `npm install -g @rojo-rbx/cli`
- Install Rojo Studio Plugin from [Roblox](https://www.roblox.com/library/1997686364/Rojo)

### Setup Steps
1. Clone this repository
2. Open terminal in the project folder
3. Run `rojo serve` to start the sync server
4. In Roblox Studio, click the Rojo plugin button
5. Connect to localhost:34872
6. The project will sync automatically

### Benefits of Rojo
- Automatic syncing when you edit files
- Version control integration
- Better code organization
- Team collaboration support

## Troubleshooting

### Common Issues

**"RemoteEvents not found" error:**
- Make sure RemoteEvents.lua is a ModuleScript in ReplicatedStorage
- Check that it returns the RemoteEvents table

**"Players.LocalPlayer is nil" error:**
- Make sure client scripts are LocalScripts
- Server scripts should be regular Scripts

**Bird doesn't move:**
- Check that BirdController is in StarterPlayerScripts as a LocalScript
- Verify UserInputService is working (test in Play mode, not Edit mode)

**No UI appears:**
- Ensure UIController is in StarterGui as a LocalScript
- Check for script errors in Output window

### Script Hierarchy Check
Your Explorer should look like this:
```
ReplicatedStorage
  └── RemoteEvents (ModuleScript)

ServerScriptService
  ├── GameManager (Script)
  └── PipeManager (Script)

StarterGui
  └── UIController (LocalScript)

StarterPlayer
  └── StarterPlayerScripts
      ├── BirdController (LocalScript)
      ├── SoundManager (LocalScript)
      └── ParticleEffects (LocalScript)
```

### Performance Tips
- Test with multiple players using the "Clients and Servers" test option
- Monitor memory usage in the Performance Stats window
- Check for script errors in the Output window

## Next Steps
- Customize bird appearance and pipe colors
- Add background music
- Implement high score persistence
- Add power-ups or special effects
- Create multiple difficulty levels