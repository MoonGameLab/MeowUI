local love = love
local Keyboard = love.keyboard
local MeowUI = MeowUI
local ColorMixins
do
  local _class_0
  local _base_0 = {
    setUpColor = function(self, color)
      if self.upColor == nil then
        return false
      end
      self.upColor = color
      return true
    end,
    setDownColor = function(self, color)
      if self.downColor == nil then
        return false
      end
      self.downColor = color
      return true
    end,
    setHoverColor = function(self, color)
      if self.hoverColor == nil then
        return false
      end
      self.hoverColor = color
      return true
    end,
    setDisabledColor = function(self, color)
      if self.disabledColor == nil then
        return false
      end
      self.disabledColor = color
      return true
    end,
    setStrokeColor = function(self, color)
      if self.strokeColor == nil then
        return false
      end
      self.strokeColor = color
      return true
    end,
    setAlphaDown = function(self, a)
      if self.alphaDown == nil then
        return false
      end
      self.alphaDown = a
      return true
    end,
    setAlphaHover = function(self, a)
      if self.alphaHover == nil then
        return false
      end
      self.alphaHover = a
      return true
    end,
    setAlphaEnable = function(self, a)
      if self.alphaEnable == nil then
        return false
      end
      self.alphaEnable = a
      return true
    end,
    setAlphaDisable = function(self, a)
      if self.alphaDisable == nil then
        return false
      end
      self.alphaDisable = a
      return true
    end,
    setFontColor = function(self, color)
      if self.fontColor == nil then
        return false
      end
      self.fontColor = color
      return true
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "ColorMixins"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ColorMixins = _class_0
end
local EventMixins
do
  local _class_0
  local _base_0 = {
    onClick = function(self, cb)
      self.Click = cb
    end,
    onHover = function(self, cb)
      self.Hover = cb
    end,
    onLeave = function(self, cb)
      self.Leave = cb
    end,
    onAfterClick = function(self, cb)
      self.aClick = cb
    end,
    onMouseEnter = function(self)
      local Mouse = love.mouse
      if self.Hover then
        self:Hover()
      end
      self.isHovred = true
      if Mouse.getSystemCursor("hand") then
        return Mouse.setCursor(Mouse.getSystemCursor("hand"))
      end
    end,
    onMouseLeave = function(self)
      local Mouse = love.mouse
      if self.Leave then
        self:Leave()
      end
      self.isHovred = false
      return Mouse.setCursor()
    end,
    onMouseDown = function(self, x, y)
      if self.Click then
        self:Click()
      end
      self.isPressed = true
    end,
    onMouseUp = function(self, x, y)
      if self.aClick then
        self:aClick()
      end
      self.isPressed = false
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "EventMixins"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EventMixins = _class_0
end
local KeyboardMixins
do
  local _class_0
  local _base_0 = {
    isCtrlDown = function(self)
      if love._os == "OS X" then
        return Keyboard.isDown("lgui") or Keyboard.isDown("rgui")
      end
      return Keyboard.isDown("lctrl") or Keyboard.isDown("rctrl")
    end,
    keyboardIsDown = function(self, ...)
      return Keyboard.isDown(...)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "KeyboardMixins"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  KeyboardMixins = _class_0
end
local utils
utils = { }
utils.tableHasValue = function(table, value)
  for k, v in pairs(table) do
    if v == value then
      return true
    end
  end
  return false
end
local ThemeMixins
do
  local _class_0
  local _base_0 = {
    getTheme = function(self)
      return MeowUI.theme
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "ThemeMixins"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ThemeMixins = _class_0
end
return {
  ColorMixins = ColorMixins,
  EventMixins = EventMixins,
  KeyboardMixins = KeyboardMixins,
  ThemeMixins = ThemeMixins
}
