local c = require("c")
local gamepad = {}
local xinput = c.Library("xinput1_4.dll")
local result,stateR
local lastkey = "No New Keystrokes / Controller not connected"
local isConnected = false

local button_map = {
    [22528] = "A",             
    [22529] = "B",              
    [22530] = "X",             
    [22531] = "Y",              
    [22532] = "RSHOULDER",      
    [22533] = "LSHOULDER",      
    [22534] = "LTRIGGER",       
    [22535] = "RTRIGGER",       

    [22544] = "DPAD_UP",       
    [22545] = "DPAD_DOWN",      
    [22546] = "DPAD_LEFT",     
    [22547] = "DPAD_RIGHT",      
    [22548] = "START",           
    [22549] = "BACK",
    [22550] = "LTHUMB_PRESS",    
    [22551] = "RTHUMB_PRESS",   

    [22560] = "LTHUMB_UP",      
    [22561] = "LTHUMB_DOWN",    
    [22562] = "LTHUMB_RIGHT",    
    [22563] = "LTHUMB_LEFT",    
    [22564] = "LTHUMB_UPLEFT",  
    [22565] = "LTHUMB_UPRIGHT", 
    [22566] = "LTHUMB_DOWNRIGHT", 
    [22567] = "LTHUMB_DOWNLEFT", 

    [22576] = "RTHUMB_UP",      
    [22577] = "RTHUMB_DOWN",    
    [22578] = "RTHUMB_RIGHT",   
    [22579] = "RTHUMB_LEFT",    
    [22580] = "RTHUMB_UPLEFT",  
    [22581] = "RTHUMB_UPRIGHT", 
    [22582] = "RTHUMB_DOWNRIGHT", 
    [22583] = "RTHUMB_DOWNLEFT" 
}

local flag_map = {
 [1] = "Key Down",
 [2] = "Key Up",
 [5] = "Key Repeating"
}

local xinput_keystroke = c.Struct("SwSCC", "VirtualKey", "Unicode", "Flags", "UserIndex", "HidCode")

xinput.XInputGetKeystroke = "(IIp)I"

local keystroke = xinput_keystroke()


function gamepad:update()
  result = xinput.XInputGetKeystroke(0,0,keystroke)
end



function gamepad:isRepeating()
  if keystroke.Flags == 5 then
    return true
  else
    return false
  end
end

function gamepad:isConnected()
  if result  ~= 1167 then
    isConnected = true
    return isConnected
  end
end

function gamepad:getKeystroke()
  if result == 0 then
    lastkey = button_map[keystroke.VirtualKey]
    return button_map[keystroke.VirtualKey]
  else
    
  end
end

function gamepad:isPressed(key)
  if result == 0 then
    if key == button_map[keystroke.VirtualKey] then
      return true
    else
      return false
    end
  end
end

return gamepad
