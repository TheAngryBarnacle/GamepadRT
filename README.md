
# GamepadRT

**GamepadRT** is a Lua library that adds gamepad input functionality to LuaRT (version 1.9.0 and above). This library allows you to integrate gamepad controls into your LuaRT projects, enabling users to interact with your applications using gamepad devices.

This library requires **LuaRT 1.9.0** or later, as it relies on the new C module introduced in version 1.9.0.

## Requirements

- **LuaRT 1.9.0 or later** (this version includes the necessary C module required by GamepadRT)
- **XINPUT.DLL** (typically preinstalled on Windows, but can be downloaded from Microsoft if needed)
- **A compatible gamepad device** connected to your computer

## Installation

To install **GamepadRT**, follow these steps:

1. Download the GamepadRT Lua library.
2. Place the library file in your LuaRT project's `modules/` directory or any directory of your choice.
3. In your Lua script, include the library:
   ```lua
   local gamepad = require("path/to/gamepad")
   ```

## Basic Usage

Here’s a basic example of how to use GamepadRT to read gamepad inputs:

```lua
local ui = require("ui")
local gamepad = require("path/to/gamepad")

local win = ui.Window("Gamepad DEMO")

function gamepad:onKeyDown(key, isRepeating)
  if key == "A" and isRepeating then
    print("A is being pressed and repeated")
  end
end

function win:onShow()
  gamepad:Init() -- Start the async update task
end

ui.run(win):wait()
```

## Functions

### `gamepad:Init()`
- Initializes the GamepadRT module and starts the async update function.

### `gamepad:isControllerConnected(cID)`
- Returns `true` if the specified gamepad is connected, `false` otherwise.

### `gamepad:onKeyDown(key, isRepeating)`
- Called when a key is pressed. Returns the current key and whether it is repeating.

### `gamepad:onKeyUp()`
- Called when a key is released.

### `gamepad:getBatteryInfo()`
- Returns the current battery type and level.

### Functions Not Implemented But Present in the Source Code

- `gamepad:leftTrigger(pressure)`
  - Returns the current pressure of the left trigger (0-255).
  
- `gamepad:rightTrigger(pressure)`
  - Returns the current pressure of the right trigger (0-255).
  
- `gamepad:getCurrentControllers()`
  - Returns the index of the currently connected controllers.
  
- `gamepad:setCurrentController(id)`
  - Sets the current controller by index.

## Button Values

- `A`
- `B`
- `X`
- `Y`
- `RSHOULDER`
- `LSHOULDER`
- `LTRIGGER`
- `RTRIGGER`
- `DPAD_UP`
- `DPAD_DOWN`
- `DPAD_LEFT`
- `DPAD_RIGHT`
- `START`
- `BACK`
- `LTHUMB_PRESS`
- `RTHUMB_PRESS`
- `LTHUMB_UP`
- `LTHUMB_DOWN`
- `LTHUMB_RIGHT`
- `LTHUMB_LEFT`
- `LTHUMB_UPLEFT`
- `LTHUMB_UPRIGHT`
- `LTHUMB_DOWNRIGHT`
- `LTHUMB_DOWNLEFT`
- `RTHUMB_UP`
- `RTHUMB_DOWN`
- `RTHUMB_RIGHT`
- `RTHUMB_LEFT`
- `RTHUMB_UPLEFT`
- `RTHUMB_UPRIGHT`
- `RTHUMB_DOWNRIGHT`
- `RTHUMB_DOWNLEFT`

## Thumb Stick (Axis)

- **Not supported yet. See known issues below.**

## Known Bugs

1. The `getState()` function is not working correctly and does not assign values properly to the struct.
2. Battery information for wireless controllers may be buggy (it might show "Disconnected" incorrectly).

## Roadmap

1. Add support for Axis (Angle).
2. Add support for multiple controllers.
