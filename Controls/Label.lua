local Graphics = love.graphics
local MeowUI = MeowUI
local love = love
local Control = MeowUI.Control
local Mixins = assert(require(MeowUI.root .. "Controls.mx"))
local Colors = assert(require(MeowUI.cwd .. "AddOns.Colors"))
local Label
do
  local _class_0
  local _setContactArea
  local _parent_0 = Control
  local _base_0 = {
    onDraw = function(self)
      local box = self:getBoundingBox()
      local r, g, b, a = Graphics.getColor()
      Graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
      if self.drawBg then
        Graphics.setColor(self.bgColor[1], self.bgColor[2], self.bgColor[3], self.alpha)
        Graphics.draw(self.textDrawable, box:getX() - self.bgOffsetX, box:getY() - self.bgOffsetY, self.rot, self.scaleX, self.scaleY)
        Graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
      end
      Graphics.draw(self.textDrawable, box:getX(), box:getY(), self.rot, self.scaleX, self.scaleY)
      return Graphics.setColor(r, g, b, a)
    end,
    onMouseEnter = function(self)
      if self.hoverable then
        local Mouse = love.mouse
        if self.Hover then
          self:Hover()
        end
        self.isHovred = true
        if Mouse.getSystemCursor("hand") then
          return Mouse.setCursor(Mouse.getSystemCursor("hand"))
        end
      end
    end,
    onMouseDown = function(self, x, y)
      if self.pressable then
        if self.Click then
          self:Click()
        end
        self.isPressed = true
      end
    end,
    onMouseUp = function(self, x, y)
      if self.pressable then
        if self.aClick then
          self:aClick()
        end
        self.isPressed = false
      end
    end,
    setPressable = function(self, p)
      self.pressable = p
    end,
    setHoverable = function(self, h)
      self.hoverable = h
    end,
    setColor = function(self, c)
      self.color = c
    end,
    setBgColor = function(self, c)
      self.bgColor = c
    end,
    setBgOffset = function(self, ox, oy)
      if ox == nil then
        ox = nil
      end
      if oy == nil then
        oy = nil
      end
      self.bgOffsetX = ox or self.bgOffsetX
      self.bgOffsetY = oy or self.bgOffsetY
    end,
    setAlpha = function(self, a)
      self.alpha = a
    end,
    setScale = function(self, sx, sy)
      self.scaleX = sx
      self.scaleY = sy
    end,
    setDrawShadow = function(self, bool)
      self.drawBg = bool
    end,
    setFont = function(self, font, size)
      if size == nil then
        size = self.size
      end
      if type(font) == "number" then
        self.font = Graphics.newFont(font)
      end
      if type(font) == "string" then
        self.font = Graphics.newFont(font, size)
      end
      self.textDrawable = Graphics.newText(self.font, self.text)
      return _setContactArea(self)
    end,
    setText = function(self, text)
      if text == nil then
        text = self.text
      end
      self.textDrawable = Graphics.newText(self.font, text)
      return _setContactArea(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, font, text, color, size)
      if font == nil then
        font = nil
      end
      if text == nil then
        text = ""
      end
      if color == nil then
        color = Colors.white
      end
      if size == nil then
        size = 15
      end
      _class_0.__parent.__init(self, "Box", "Label")
      self.size = size
      self.text = text
      self.color = color
      self:setEnabled(true)
      self.bgColor = Colors.white
      self.LineHight = 1
      self.scaleX = 1
      self.scaleY = 1
      self.autoSize = true
      self.drawBg = false
      self.bgOffsetX = 3
      self.bgOffsetY = 3
      self.alpha = 1
      self.isHovred = false
      self.isPressed = false
      self.pressable = false
      self.hoverable = false
      if font then
        if type(font) == "number" then
          self.font = Graphics.newFont(font)
        end
        if type(font) == "string" then
          self.font = Graphics.newFont(font, self.size)
        end
      else
        self.font = Graphics.newFont(self.size)
      end
      self.textDrawable = Graphics.newText(self.font, self.text)
      self.font:setLineHeight(self.LineHight)
      self:setEnabled(true)
      _setContactArea(self)
      self:on("UI_DRAW", self.onDraw, self)
      self:on("UI_MOUSE_ENTER", self.onMouseEnter, self)
      self:on("UI_MOUSE_LEAVE", self.onMouseLeave, self)
      self:on("UI_MOUSE_DOWN", self.onMouseDown, self)
      return self:on("UI_MOUSE_UP", self.onMouseUp, self)
    end,
    __base = _base_0,
    __name = "Label",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self:include(Mixins.ColorMixins)
  self:include(Mixins.EventMixins)
  self:include(Mixins.ThemeMixins)
  _setContactArea = function(self)
    if self.autoSize then
      return self:setSize(self.textDrawable:getWidth(), self.textDrawable:getHeight())
    else
      local _, wt = self.font:getWrap(self.text, self:getWidth())
      local text = ""
      for i, v in ipairs(wt) do
        if i == #wt then
          text = text .. v
        else
          text = text .. (v .. "\n")
        end
        self.textDrawable:set(text)
      end
    end
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Label = _class_0
  return _class_0
end
