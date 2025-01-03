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
local gamepad = require("gamepad")
```
