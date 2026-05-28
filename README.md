# MYSTERY SAVE GUI

A feature-rich Roblox Save Instance wrapper with a modern draggable GUI. Save entire games including terrain, lighting, camera settings, and decompiled scripts into `.rbxmx` files that open directly in Roblox Studio.

## Loader

Paste this in your executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/mystry112000/adhi-save-gui/main/save_gui.lua"))()
```

## Features

- Modern dark theme GUI with MYSTERY brand accent
- Draggable window
- 6 toggleable options
- Custom filename input
- Visual backup system — captures Lighting properties, Terrain paint data, Camera settings, and Workspace configuration into a `__VisualBackup` model inside the save
- Status log showing real-time progress

## Options

| Toggle | Default | Description |
|--------|---------|-------------|
| Save Terrain | ON | Export terrain voxels and material color palette |
| Decompile Scripts | ON | Save decompiled Lua source code |
| Stream Only | OFF | Only save streamed-in parts |
| Compress Output | ON | Compress the final .rbxmx file |
| Remove Default Tags | ON | Strip default Roblox instance tags |
| Remove Collision | OFF | Skip collision data for smaller file size |

## Requirements

- A Roblox executor that supports:
  - `saveinstance()` function
  - `syn.protect_gui()` or `gethui()` for GUI parenting
  - `writefile()` for file output

### Compatible Executors

- Script-ware
- Synapse (legacy)
- Fluxus
- Any executor with saveinstance API

## Output

The script saves a `.rbxmx` file to the executor's workspace directory. Import it into Roblox Studio via **File → Import** or drag-drop into the Workspace.

The `__VisualBackup` model contains all saved lighting, terrain, camera, and workspace data as `StringValue` nodes. Apply manually or extend with an auto-restore script.

## Output Locations by Executor

Executor save file locations vary. Check your executor's documentation for the `writefile()` output directory. Common locations include `%appdata%\YourExecutor\workspace` or the executor installation folder.

## Disclaimer

**USE AT YOUR OWN RISK.**

This tool is provided for educational purposes only. The authors are not responsible for:
- Any violations of Roblox Terms of Service
- Account bans or restrictions
- Data loss or corruption
- Any damages arising from the use of this software

By using this script you acknowledge that:
1. Saving Roblox games may violate Roblox ToS
2. Decompiled scripts may be protected by copyright
3. You are solely responsible for how you use saved content

## Credits

- Adament_Knight_07 — Original saveinstance implementation
- MYSTERY — GUI wrapper and enhancements
- OpenCode — Development assistance

## License

This project is for educational and research purposes only. Redistribution is permitted as long as credit is maintained.
