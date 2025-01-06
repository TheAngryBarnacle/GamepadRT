# GamepadRT

**GamepadRT** is a Lua library that adds gamepad input functionality to LuaRT (version 1.9.0 and above). It allows you to easily integrate gamepad controls into your LuaRT projects, enabling users to interact with your applications using gamepad devices.

This library requires **LuaRT 1.9.0** or later, as it depends on the new C module introduced in version 1.9.0.

## Requirements

- **LuaRT 1.9.0 or later** (this version includes the necessary C module required by GamepadRT)
- **A compatible gamepad device** connected to your computer

## Installation

To install **GamepadRT**, simply place the library file into your LuaRT project directory. Then, you can load it within your Lua script.

1. Download the GamepadRT Lua library.
2. Place the library file in your LuaRT project's `modules/` directory or any directory of your choice.
3. In your Lua script, include the library:
```lua
local gamepad = require("path/to/gamepad")
```
## Basic Usage
Here is a basic example of how to use GamepadRT to read gamepad inputs (button presses for now)
```lua
local ui = require("ui")
local gamepad = require("src/libraries/gamepad")
require("canvas")

local win = ui.Window("Gamepad DEMO")

local canvas = ui.Canvas(win)
canvas.align = "all"

function canvas:onPaint()
  self:clear()
  gamepad:update() -- update the dll
  
  if gamepad:isPressed("A") then
    print("A Buttons has been pressed") -- print to the console since as soon as the a is let go, it returns to false
  end
end

ui.run(win):wait()

```




## Functions
```gamepad:isPressed(key)```
- Returns true of the specfied key is pressed

```gamepad:update()```
- Updates the keystroke provided by the DLL (must be called in the ui.update() or in canvas:onPaint()

```gamepad:isConnected()```
- Returns true if a gamepad is connected, false otherwise

```gamepad:onKeyRepeat()```
- Returns true if the current keystroke is repeating, false otherwise
  
```gamepad:onKeyDown()```
- Returns the current Key down event (when pressed)

```gamepad:onKeyUp()```
- Returns the current Key up event (when released)

## Values returned
- Buttons
  - ```A```
  - ```B```
  - ```X```
  - ```Y```
  - ```RSHOULDER```
  - ```LSHOULDER```
  - ```LTRIGGER```
  - ```RTRIGGER```
  - ```DPAD_UP```
  - ```DPAD_DOWN```
  - ```DPAD_LEFT```
  - ```DPAD_RIGHT```
  - ```START```
  - ```BACK```
  - ```LTHUMB_PRESS```
  - ```RTHUMB_PRESS```
  - ```LTHUMB_UP```
  - ```LTHUMB_DOWN```
  - ```LTHUMB_RIGHT```
  - ```LTHUMB_LEFT```
  - ```LTHUMB_UPLEFT```
  - ```LTHUMB_UPRIGHT```
  - ```LTHUMB_DOWNRIGHT```
  - ```LTHUMB_DOWNLEFT```
  - ```RTHUMB_UP```
  - ```RTHUMB_DOWN```
  - ```RTHUMB_RIGHT```
  - ```RTHUMB_LEFT```
  - ```RTHUMB_UPLEFT```
  - ```RTHUMB_UPRIGHT```
  - ```RTHUMB_DOWNRIGHT```
  - ```RTHUMB_DOWNLEFT```
- Axises
  - Not Supported Yet (Coming Soon)


## TODOs:
1. Add support for axis dection (angle)
2. Add support for battery information from a wireless controller (if able to)
3. Add support for detecting if the press is Down or Up
4. 	~~Add Support for detecting if the press is repeating or not~~

