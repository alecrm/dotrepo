-- ~/.hammerspoon/init.lua
local hyper          = {"ctrl","shift"}
local dropdownHeight = 600
local dropdownCmd    = "env WEZTERM_DROPDOWN=1 wezterm start"
local wezAppName     = "WezTerm"
local dropdownWindow = nil

local spaces = require("hs.spaces")
local wf     = require("hs.window.filter")

-- 1) Catch the first dropdown window, size it, sticky it once, then minimize
wf.new(false)
  :setAppFilter(wezAppName)
  :subscribe(wf.windowCreated, function(win)
    if not dropdownWindow then
      dropdownWindow = win
      -- initial position on whichever screen your mouse is on
      local sf = hs.mouse.getCurrentScreen():frame()
      win:setFrame{ x = sf.x, y = sf.y, w = sf.w, h = dropdownHeight }
      -- keep it hidden in the background
      win:minimize()
    end
  end)

-- 2) Pre‑launch at startup so you only pay the cold‑start cost once
hs.timer.doAfter(1, function()
  hs.execute(dropdownCmd, true)
end)

-- 3) Global hotkey: move into current Space, reposition, then toggle
hs.hotkey.bind(hyper, "`", function()
  if not dropdownWindow or not dropdownWindow:application() then
    -- if it somehow died, respawn it
    hs.execute(dropdownCmd, true)
    return
  end

  if dropdownWindow:isMinimized() then
    -- 3a) Figure out the Space ID under your mouse
    local screen = hs.mouse.getCurrentScreen()
    local sid    = spaces.activeSpaceOnScreen(screen)
    -- 3b) Move the dropdown window into *that* Space
    spaces.moveWindowToSpace(dropdownWindow:id(), sid)

    -- 3c) Reposition & resize at the top of the screen
    local sf = screen:frame()
    dropdownWindow:setFrame{
      x = sf.x,
      y = sf.y,
      w = sf.w,
      h = dropdownHeight,
    }

    -- 3d) Show it
    dropdownWindow:unminimize()
    dropdownWindow:focus()
  else
    -- Hide it again
    dropdownWindow:minimize()
  end
end)

