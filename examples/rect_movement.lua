local ui = require("ui")
local gamepad = require("src/libraries/gamepad")
require("canvas")

isRunning = true


local win = ui.Window("Gamepad DEMO")

local canvas = ui.Canvas(win)
canvas.align = "all"

local rect = {
  x = 30,
  y = 30,
  width = 30,
  height = 30
}

rect.x2 = rect.x + rect.width
rect.y2 = rect.y + rect.height

function canvas:onPaint()
  self:clear()
  local currentKey = gamepad:getKeystroke()
  gamepad:update() -- update the dll
  
 if currentKey == "DPAD_DOWN" or currentKey == "LTHUMB_DOWN" then
    rect.y = rect.y + 4
    rect.y2 = rect.y + rect.height
elseif currentKey == "DPAD_UP" or currentKey == "LTHUMB_UP" then
    rect.y = rect.y - 4
    rect.y2 = rect.y + rect.height
elseif currentKey == "DPAD_LEFT" or currentKey == "LTHUMB_LEFT" then
    rect.x = rect.x - 4
    rect.x2 = rect.x + rect.width
elseif currentKey == "DPAD_RIGHT" or currentKey == "LTHUMB_RIGHT" then
    rect.x = rect.x + 4
    rect.x2 = rect.x + rect.width
elseif currentKey == "LTHUMB_UPRIGHT" then
    rect.x = rect.x + 4
    rect.y = rect.y - 4
    rect.x2 = rect.x + rect.width
    rect.y2 = rect.y + rect.height
elseif currentKey == "LTHUMB_UPLEFT" then
    rect.x = rect.x - 4
    rect.y = rect.y - 4
    rect.x2 = rect.x + rect.width
    rect.y2 = rect.y + rect.height
elseif currentKey == "LTHUMB_DOWNRIGHT" then
    rect.x = rect.x + 4
    rect.y = rect.y + 4
    rect.x2 = rect.x + rect.width
    rect.y2 = rect.y + rect.height
elseif currentKey == "LTHUMB_DOWNLEFT" then
    rect.x = rect.x - 4
    rect.y = rect.y + 4
    rect.x2 = rect.x + rect.width
    rect.y2 = rect.y + rect.height
end

  
  self:rect(rect.x,rect.y,rect.x2,rect.y2)
end

function win:onKey(key)

end

ui.run(win):wait()
