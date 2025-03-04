--- Load C Module
local c = require("c")

-- Load Xinput DLL
local XInput = c.Library("xinput1_4.dll")

-- Initialize gamepad object
local g = {}

-- Initialize variables
local r, sR
local lastKey = "N/A"
local isConnected = false
local max_count = 4
local index_any = 0x000000FF
g.currentControlerIndex = 0 -- Default to 0, which is the first controller connected (depends on Windows)

-- Battery Types
local BATTERY_DEVTYPE_GAMEPAD = 0x00
local BATTERY_DEVTYPE_HEADSET = 0x01

-- Device Subtypes
local dev_subtype = {
  [0x00] = "Unknown",
  [0x01] = "Gamepad",
  [0x02] = "Wheel",
  [0x03] = "Arcade Stick",
  [0x04] = "Flight Stick",
  [0x05] = "Dance Pad",
  [0x06] = "Guitar",
  [0x07] = "Guitar Alternate",
  [0x08] = "Drum Kit",
  [0x0B] = "Guitar Bass",
  [0x13] = "Arcade Pad"
}

-- Gamepad Capabilities
local caps = {
  [0x0004] = "Voice Supported",
  [0x0001] = "FFB Supported",
  [0x0002] = "Wireless",
  [0x0008] = "PMD Supported",
  [0x0010] = "No Navigation"
}

-- Button mappings
local g_buttons = {
  [0x0001] = "DPAD Up",
  [0x0002] = "DPAD Down",
  [0x0004] = "DPAD Left",
  [0x0008] = "DPAD Right",
  [0x0010] = "Start",
  [0x0020] = "Back",
  [0x0040] = "Left Thumb",
  [0x0080] = "Right Thumb",
  [0x0100] = "Left Shoulder",
  [0x0200] = "Right Shoulder",
  [0x1000] = "A",
  [0x2000] = "B",
  [0x4000] = "X",
  [0x8000] = "Y"
}

-- Button mapping for XInput keys
local buttonMap = {
  [0x5800] = "A",
  [0x5801] = "B",
  [0x5802] = "X",
  [0x5803] = "Y",
  [0x5804] = "RSHOULDER",
  [0x5805] = "LSHOULDER",
  [0x5806] = "LTRIGGER",
  [0x5807] = "RTRIGGER",
  [0x5810] = "DPAD_UP",
  [0x5811] = "DPAD_DOWN",
  [0x5812] = "DPAD_LEFT",
  [0x5813] = "DPAD_RIGHT",
  [0x5814] = "START",
  [0x5815] = "BACK",
  [0x5816] = "LTHUMB_PRESS",
  [0x5817] = "RTHUMB_PRESS",
  [0x5820] = "LTHUMB_UP",
  [0x5821] = "LTHUMB_DOWN",
  [0x5822] = "LTHUMB_RIGHT",
  [0x5823] = "LTHUMB_LEFT",
  [0x5824] = "LTHUMB_UPLEFT",
  [0x5825] = "LTHUMB_UPRIGHT",
  [0x5826] = "LTHUMB_DOWNRIGHT",
  [0x5827] = "LTHUMB_DOWNLEFT",
  [0x5830] = "RTHUMB_UP",
  [0x5831] = "RTHUMB_DOWN",
  [0x5832] = "RTHUMB_RIGHT",
  [0x5833] = "RTHUMB_LEFT",
  [0x5834] = "RTHUMB_UPLEFT",
  [0x5835] = "RTHUMB_UPRIGHT",
  [0x5836] = "RTHUMB_DOWNRIGHT",
  [0x5837] = "RTHUMB_DOWNLEFT"
}

-- Battery Types
local bTypes = {
  [0x00] = "DISCONNECTED",  -- Device is not connected
  [0x01] = "WIRED",         -- Wired device, no battery
  [0x02] = "ALKALINE",      -- Alkaline battery source
  [0x03] = "NIMH",          -- Nickel Metal Hydride battery source
  [0xFF] = "UNKNOWN"        -- Battery type unknown
}

-- Battery Levels (valid for wireless connected devices)
local bLevels = {
  [0x00] = "EMPTY",         -- Battery is empty
  [0x01] = "LOW",           -- Battery is low
  [0x02] = "MEDIUM",        -- Battery is medium
  [0x03] = "FULL"           -- Battery is full
}

-- Keystroke Flags
local keystroke_flags = {
  [0x0001] = "Key Down",
  [0x0002] = "Key Up",
  [0x0004] = "Key Repeating"
}

-- Threshold values for thumbsticks and triggers
local thresholds = {
  LEFT_THUMB_DEADZONE = 7849,
  RIGHT_THUMB_DEADZONE = 8689,
  TRIGGER_THRESHOLD = 30
}

local gamepad_cap_flag = 0x00000001

-- Define the gamepad, state, vibration, capabilities, battery, and keystroke structs
local gamepad_struct = c.Struct("SCCssss", "wButtons", "bLeftTrigger", "bRightTrigger", "sThumbLX", "sThumbLY", "sThumbRX", "sThumbRY")
local state_struct = c.Struct("I.", "dwPacketNumber", {Gamepad = gamepad_struct})
local vibration_struct = c.Struct("SS", "wLeftMotorSpeed", "wrightMotorSpeed")
local capabilities_struct = c.Struct("CC..", "Type", "SubType", {Gamepad = gamepad_struct}, {Vibration = vibration_struct})
local battery_struct = c.Struct("CC", "BatteryType", "BatteryLevel")
local keystroke_struct = c.Struct("SwSCC", "VirtualKey", "Unicode", "Flags", "UserIndex", "HidCode")

local gamepad = gamepad_struct()
local state = state_struct()
local vibration = vibration_struct()
local capabilities = capabilities_struct()
local batteryInfo = battery_struct()
local keystroke = keystroke_struct()

-- XInput library call setup
XInput.XInputGetState = "(Ip)I"
XInput.XInputSetState = "(Ip)I"
XInput.XInputGetCapabilities = "(IIp)I"
XInput.XInputEnable = "(B)"
XInput.XInputGetBatteryInformation = "(ICp)I"
XInput.XInputGetKeystroke = "(IIp)I"

-- Function to check if the controller is connected
local function isControllerConnected(cID)
  local state = state_struct()
  local result = XInput.XInputGetState(cID, state)
  return result == 0
end

-- Function to grab the controller state
local function grab_controller_state(id)
  local s = state_struct()
  return XInput.XInputGetState(id, s)
end

-- Function to get the current connected controllers
function g:getCurrentControllers()
  for i = 0, 3 do
    if isControllerConnected(i) then
      print("Controller with ID: "..i.." is connected")
    else
      print("Controller with ID: "..i.." is not connected")
    end
  end
end

-- Function to set the current controller
function g:setCurrentController(id)
  if id < 0 or id > 3 then
    ui.warn("GamepadRT: Could not set controller; Controller ID Out of Range", "GamepadRT")
    return false
  else
    if isControllerConnected(id) then
      self.currentControlerIndex = id
      return true
    else
      ui.warn("GamepadRT: Could not set controller; Controller with ID: "..id.." is not connected", "GamepadRT")
      return false
    end
  end
end

-- Function for handling key down event
function g:onKeyDown(key, isRepeating)
  -- Implement key down handling logic here
end

-- Function for handling key up event
function g:onKeyUp(key)
  -- Implement key up handling logic here
end

-- Function for left trigger pressure
function g:leftTrigger(pressure)
  -- Implement left trigger pressure logic here
end

-- Function for right trigger pressure
function g:rightTrigger(pressure)
  -- Implement right trigger pressure logic here
end

-- Function to get battery information
function g:getBatteryInfo()
  local result = XInput.XInputGetBatteryInformation(self.currentControlerIndex, BATTERY_DEVTYPE_GAMEPAD, batteryInfo)
  if result == 0 then
    return bTypes[batteryInfo.BatteryType], bLevels[batteryInfo.BatteryLevel]
  else
    return "Controller Not connected"
  end
end

-- Update function to read keystrokes periodically
local function update()
  while true do
    local result = XInput.XInputGetKeystroke(g.currentControlerIndex, 0, keystroke)
    local key = buttonMap[keystroke.VirtualKey]
    local isRepeating = (keystroke.Flags == 0x0004)

    if keystroke.Flags == 0x0001 or keystroke.Flags == 0x0004 then
      -- Handle key down
      g:onKeyDown(key, isRepeating)
    elseif keystroke.Flags == 0x0002 then
      -- Handle key up
      g:onKeyUp(key)
    end

    sleep(33) -- About 30 IPM
  end
end

-- Start the update task
updateTask = sys.Task(update)

-- Initialize the gamepad
function g:Init()
  updateTask()
end

return g
