local Graphics = love.graphics
local MeowUI = MeowUI
local love = love
local Control = MeowUI.Control
local Mixins = assert(require(MeowUI.root .. "Controls.mx"))
local stencileFuncCircle
stencileFuncCircle = function(self)
  local box = self:getBoundingBox()
  return function()
    return Graphics.circle("fill", box.x, box.y, self.bgImage:getWidth() / 2 + self.stroke)
  end
end
local stencileFuncPoly
stencileFuncPoly = function(self)
  local box = self:getBoundingBox()
  return function()
    return Graphics.polygon("fill", box:getVertices())
  end
end
local circleBorder
circleBorder = function(self, box)
  if self.enabled and self.stroke > 0 then
    local oldLineWidth = Graphics.getLineWidth()
    Graphics.setLineWidth(self.stroke)
    Graphics.setColor(self.strokeColor)
    Graphics.circle("line", box.x, box.y, box:getRadius())
    return Graphics.setLineWidth(oldLineWidth)
  end
end
local polyBorder
polyBorder = function(self, box)
  if self.enabled and self.stroke > 0 then
    local oldLineWidth = Graphics.getLineWidth()
    Graphics.setLineWidth(self.stroke)
    Graphics.setColor(self.strokeColor)
    Graphics.polygon("line", box:getVertices())
    return Graphics.setLineWidth(oldLineWidth)
  end
end
local currentColor
currentColor = function(self)
  local color
  if self.isPressed then
    color = self.downColor
    color[4] = (color[4] ~= nil) and color[4] or self.alphaDown
  elseif self.isHovred then
    color = self.hoverColor
    color[4] = (color[4] ~= nil) and color[4] or self.alphaHover
  elseif self.enabled then
    color = self.upColor
    color[4] = (color[4] ~= nil) and color[4] or self.alphaEnable
  else
    color = self.disabledColor
    color[4] = (color[4] ~= nil) and color[4] or self.alphaDisable
  end
  return color
end
local drawPoly
drawPoly = function(self)
  local box = self:getBoundingBox()
  local r, g, b, a = Graphics.getColor()
  local color = currentColor(self)
  Graphics.setLineStyle(self.borderLineStyle)
  if self.bgImage then
    if not self.isPressed then
      Graphics.setColor(r, g, b, a)
    end
    if self.isHovred then
      Graphics.setColor(color)
    end
    Graphics.push('all')
    local sf = stencileFuncPoly(self)
    Graphics.stencil(sf, "increment", 1, true)
    Graphics.setStencilTest("greater", 1)
    local x, y = box:getPosition()
    Graphics.draw(self.bgImage, x - self.bgImage:getWidth() / 2, y - self.bgImage:getHeight() / 2)
    polyBorder(self, box)
    Graphics.setStencilTest()
    Graphics.setColor(r, g, b, a)
    Graphics.pop()
  else
    Graphics.setColor(color)
    Graphics.polygon('fill', box:getVertices())
    polyBorder(self, box)
    Graphics.setColor(r, g, b, a)
  end
  if self.textDrawable then
    Graphics.setColor(self.fontColor)
    local textW, textH = self.textDrawable:getWidth(), self.textDrawable:getHeight()
    local x = math.ceil(box.x - textW / 2)
    local y = math.ceil(box.y - textH / 2)
    Graphics.draw(self.textDrawable, x, y)
  end
  return Graphics.setColor(r, g, b, a)
end
local drawCircle
drawCircle = function(self)
  local box = self:getBoundingBox()
  local r, g, b, a = Graphics.getColor()
  local boxR = box:getRadius()
  local color = currentColor(self)
  Graphics.setLineStyle(self.borderLineStyle)
  if self.bgImage then
    if not self.isPressed then
      Graphics.setColor(r, g, b, a)
    end
    if self.isHovred then
      Graphics.setColor(color)
    end
    Graphics.push('all')
    local sf = stencileFuncCircle(self)
    Graphics.stencil(sf, "increment", 1, true)
    Graphics.setStencilTest("greater", 1)
    Graphics.draw(self.bgImage, ((box.x - self.bgImageBx) - self.radius * self.scaleX), ((box.y - self.bgImageBx) - self.radius * self.scaleY))
    circleBorder(self, box)
    Graphics.setStencilTest()
    Graphics.setColor(r, g, b, a)
    Graphics.pop()
  else
    Graphics.setColor(color)
    Graphics.circle('fill', box.x, box.y, boxR)
    circleBorder(self, box)
    Graphics.setColor(r, g, b, a)
  end
  if self.textDrawable then
    Graphics.setColor(self.fontColor)
    local textW, textH = self.textDrawable:getWidth(), self.textDrawable:getHeight()
    local x = box.x - textW / 2
    local y = box.y - textH / 2
    Graphics.draw(self.textDrawable, x, y)
  end
  return Graphics.setColor(r, g, b, a)
end
local drawRect
drawRect = function(self)
  local box = self:getBoundingBox()
  local r, g, b, a = Graphics.getColor()
  local boxW, boxH = box:getWidth(), box:getHeight()
  local color = currentColor(self)
  Graphics.setLineStyle(self.borderLineStyle)
  if self.bgImage then
    local imageW, imageH = self.bgImage:getWidth(), self.bgImage:getHeight()
    if not self.isPressed then
      Graphics.setColor(r, g, b, a)
    end
    if self.isHovred then
      Graphics.setColor(color)
    end
    Graphics.draw(self.bgImage, box.x, box.y)
    local x = box.x + ((imageW - boxW) / 2)
    local y = box.y + ((imageH - boxH) / 2)
    box.x, box.y = x + (self.bgImageBx / 2), y + (self.bgImageBy / 2)
    Graphics.setColor(r, g, b, a)
  else
    Graphics.setColor(color)
    Graphics.rectangle("fill", box.x, box.y, boxW, boxH, self.rx, self.ry)
    Graphics.setColor(r, g, b, a)
  end
  if self.enabled and self.stroke > 0 then
    local oldLineWidth = Graphics.getLineWidth()
    Graphics.setLineWidth(self.stroke)
    Graphics.setColor(self.strokeColor)
    Graphics.rectangle("line", box.x, box.y, boxW, boxH, self.rx, self.ry)
    Graphics.setLineWidth(oldLineWidth)
  end
  if self.textDrawable then
    Graphics.setColor(self.fontColor)
    local textW, textH = self.textDrawable:getWidth(), self.textDrawable:getHeight()
    local x = box.x + ((boxW - textW) / 2) + (self.bgImageBx or 0)
    local y = box.y + ((boxH - textH) / 2) + (self.bgImageBx or 0)
    Graphics.draw(self.textDrawable, x, y)
  end
  return Graphics.setColor(r, g, b, a)
end
local Button
do
  local _class_0
  local _parent_0 = Control
  local _base_0 = {
    setText = function(self, text)
      self.textDrawable:set(text)
      if self.dynamicSize then
        self.width = self.width > self.textDrawable:getWidth() and self.oWidth or self.textDrawable:getWidth() + self.dPadding
        self.height = self.height > self.textDrawable:getHeight() and self.oHeight or self.textDrawable:getHeight()
      end
    end,
    setDynamicPadding = function(self, p)
      self.dPadding = p
    end,
    setDynamicSize = function(self, bool)
      self.dynamicSize = bool
    end,
    setSize = function(self, width, height)
      _class_0.__parent.__base.setSize(self, width, height)
      self.oWidth = self.width
      self.oHeight = self.height
    end,
    setStroke = function(self, s)
      if self:getBoundingBox().__class.__name == "Polygon" then
        local _s = self:getStroke() * 2
        local r = self:getRadius() - _s
        self.stroke = s * 2
        self:setRadius(r + s)
        return 
      end
      self.stroke = s
    end,
    getStroke = function(self)
      return self.stroke
    end,
    setFontSize = function(self, size)
      Graphics = love.graphics
      return self.textDrawable:setFont(Graphics.newFont(size))
    end,
    getFontSize = function(self)
      return self.textDrawable:getFont():getWidth(), self.textDrawable:getFont():getHeight()
    end,
    getBorderLineStyle = function(self)
      return self.borderLineStyle
    end,
    setImage = function(self, image, conform, bx, by)
      if bx == nil then
        bx = 0
      end
      if by == nil then
        by = 0
      end
      self.bgImage = Graphics.newImage(image)
      local box = self:getBoundingBox()
      self.dynamicSize = false
      self.stroke = 0
      self.imageX, self.imageY = box.x, box.y
      if conform then
        box = self:getBoundingBox()
        if box.__class.__name == "Box" then
          self.bgImageBx, self.bgImageBy = bx or 0, by
          return self:setSize(self.bgImage:getWidth() - bx, self.bgImage:getHeight() - by)
        elseif box.__class.__name == "Circle" then
          local r = self.bgImage:getWidth() / 2 - bx
          self.bgImageBx = bx or 0
          return self:setRadius(r)
        elseif box.__class.__name == "Polygon" then
          local w, h = self.bgImage:getWidth() / 1.5, self.bgImage:getHeight() / 1.5
          local r = (w > h) and w or h
          self.bgImageBx = bx or 0
          return self:setRadius(r + self.stroke)
        end
      end
    end,
    setImageBorder = function(self, bx, by)
      if bx == nil then
        bx = 0
      end
      if by == nil then
        by = 0
      end
      self.bgImageBx, self.bgImageBy = bx, by
      return self:setSize(self.bgImage:getWidth() - bx, self.bgImage:getHeight() - by)
    end,
    setCorners = function(self, rx, ry)
      self.rx, self.ry = rx, ry
    end,
    setScale = function(self, x, y)
      if x == nil then
        x = nil
      end
      if y == nil then
        y = nil
      end
      self.sx, self.sy = x or self.sx, y or self.sy
    end,
    setDepth = function(self, depth)
      return _class_0.__parent.__base.setDepth(self, depth)
    end,
    setBorderLineStyle = function(self, bl)
      self.borderLineStyle = bl
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, type)
      _class_0.__parent.__init(self, type, "Button")
      local t = self:getTheme()
      local colors = t.colors
      local common = t.common
      self.borderLineStyle = t.button.borderLineStyle
      self.stroke = common.stroke
      self.fontSize = common.fontSize
      self.iconAndTextSpace = common.iconAndTextSpace
      self.downColor = colors.downColor
      self.hoverColor = colors.hoverColor
      self.upColor = colors.upColor
      self.disabledColor = colors.disabledColor
      self.strokeColor = colors.strokeColor
      self.fontColor = colors.fontColor
      self.bgImageBx, self.bgImageBy = 0, 0
      self.alpha = 1
      self.scaleX = 1
      self.scaleY = 1
      self.bgImage = nil
      self.textDrawable = Graphics.newText(Graphics.newFont(self.fontSize), "")
      self.dynamicSize = true
      self:setEnabled(true)
      local _exp_0 = type
      if "Box" == _exp_0 then
        self.onDraw = drawRect
        local style = t.button
        self.width = style.width
        self.height = style.height
        self.rx = style.rx
        self.ry = style.ry
        self.oWidth = self.width
        self.oHeight = self.height
        self.dPadding = 0
      elseif "Circle" == _exp_0 then
        self.onDraw = drawCircle
        local style = t.circleButton
        self.radius = style.radius
        self.dPadding = 15
      elseif "Polygon" == _exp_0 then
        self.onDraw = drawPoly
        local style = t.polyButton
        self.radius = style.radius
        self.dPadding = 15
      end
      self:on("UI_DRAW", self.onDraw, self)
      self:on("UI_MOUSE_ENTER", self.onMouseEnter, self)
      self:on("UI_MOUSE_LEAVE", self.onMouseLeave, self)
      self:on("UI_MOUSE_DOWN", self.onMouseDown, self)
      return self:on("UI_MOUSE_UP", self.onMouseUp, self)
    end,
    __base = _base_0,
    __name = "Button",
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
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Button = _class_0
  return _class_0
end
