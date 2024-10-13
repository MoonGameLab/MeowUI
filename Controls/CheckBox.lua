local Graphics = love.graphics
local MeowUI = MeowUI
local love = love
local Control = MeowUI.Control
local Mixins = assert(require(MeowUI.root .. "Controls.mx"))
local ceil
ceil = math.ceil
local insert
insert = table.insert
local drawRect
drawRect = function(self)
  local box = self:getBoundingBox()
  local r, g, b, a = Graphics.getColor()
  local boxW, boxH = box:getWidth(), box:getHeight()
  local colorBk = self.strokeColor
  local colorfr
  if self.checked then
    colorfr = self.pressedColor
  else
    colorfr = self.frontColor
  end
  Graphics.setLineStyle(self.borderLineStyle)
  Graphics.setColor(colorBk)
  Graphics.rectangle("fill", box.x, box.y, boxW, boxH, self.rx, self.ry)
  Graphics.setColor(colorfr)
  Graphics.rectangle("fill", box.x + self.margin, box.y + self.margin, boxW - self.margin * 2, boxH - self.margin * 2, self.rx, self.ry)
  return Graphics.setColor(r, g, b, a)
end
local setChecked
setChecked = function(self, bool, rec)
  if rec == nil then
    rec = true
  end
  if rec == false then
    self.checked = bool
    return 
  end
  if #self.group > 0 then
    for _, elem in ipairs(self.group) do
      if elem.checked then
        elem.checked = not bool
      else
        if self.reverseGroup then
          elem.checked = not bool
        end
      end
    end
  end
  self.checked = bool
end
local drawCircle
drawCircle = function(self)
  local box = self:getBoundingBox()
  local r, g, b, a = Graphics.getColor()
  local boxR = box:getRadius()
  Graphics.setLineStyle(self.borderLineStyle)
  local colorBk = self.strokeColor
  local colorfr
  if self.checked then
    colorfr = self.pressedColor
  else
    colorfr = self.frontColor
  end
  Graphics.setColor(colorfr)
  Graphics.circle('fill', box.x, box.y, boxR)
  Graphics.setLineWidth(self.stroke)
  Graphics.setColor(colorBk)
  Graphics.circle('line', box.x, box.y, boxR)
  return Graphics.setColor(r, g, b, a)
end
local polyBorder
polyBorder = function(self, box)
  local oldLineWidth = Graphics.getLineWidth()
  Graphics.setLineWidth(self.stroke)
  Graphics.setLineStyle(self.borderLineStyle)
  Graphics.setColor(self.strokeColor)
  Graphics.polygon("line", box:getVertices())
  return Graphics.setLineWidth(oldLineWidth)
end
local drawPoly
drawPoly = function(self)
  local box = self:getBoundingBox()
  local r, g, b, a = Graphics.getColor()
  local colorfr
  if self.checked then
    colorfr = self.pressedColor
  else
    colorfr = self.frontColor
  end
  Graphics.setColor(colorfr)
  Graphics.polygon('fill', box:getVertices())
  polyBorder(self, box)
  return Graphics.setColor(r, g, b, a)
end
local CheckBox
do
  local _class_0
  local _parent_0 = Control
  local _base_0 = {
    onMouseDown = function(self, x, y)
      if self.Click then
        self:Click()
      end
      self.isPressed = true
      return self:setChecked(not self.checked)
    end,
    linkTo = function(self, cb)
      if #cb:getGroup() > 0 then
        for _, v in ipairs(cb:getGroup()) do
          v:addToGroup(self)
        end
        for _, v in ipairs(cb:getGroup()) do
          self:addToGroup(v)
        end
        self:addToGroup(cb)
        return cb:addToGroup(self)
      else
        self:addToGroup(cb)
        return cb:addToGroup(self)
      end
    end,
    addToGroup = function(self, e)
      return insert(self.group, e)
    end,
    getGroup = function(self)
      return self.group
    end,
    isChecked = function(self)
      return self.checked
    end,
    setOutlineColor = function(self, c)
      self.backColor = c
    end,
    setInnerColor = function(self, c)
      self.frontColor = c
    end,
    setPressedColor = function(self, c)
      self.pressedColor = c
    end,
    setMargin = function(self, m)
      self.margin = m
    end,
    setReverseGroup = function(self, bool)
      self.reverseGroup = bool
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, type)
      _class_0.__parent.__init(self, type, "CheckBox")
      local t = self:getTheme()
      local colors = t.colors
      local common = t.common
      self.stroke = common.stroke
      self.backColor = colors.downColor
      self.frontColor = colors.upColor
      self.pressedColor = t.checkBox.pressedColor
      self.disabledColor = colors.disabledColor
      self.strokeColor = t.checkBox.borderLineColor
      self.borderLineStyle = t.checkBox.borderLineStyle
      self.alpha = 1
      self.reverseGroup = false
      self.checked = false
      self.group = { }
      self.setChecked = setChecked
      self:setEnabled(true)
      self.groupMember = false
      local _exp_0 = type
      if "Box" == _exp_0 then
        self.onDraw = drawRect
        local style = t.checkBox
        self.width = style.width
        self.margin = style.margin
        self.height = style.height
        self.rx = style.rx
        self.ry = style.ry
      elseif "Circle" == _exp_0 then
        self.onDraw = drawCircle
        local style = t.checkBox
        self.margin = style.margin
        self.radius = style.radius
        self.segments = style.segments
        self.dPadding = 15
      elseif "Polygon" == _exp_0 then
        self.onDraw = drawPoly
        local style = t.checkBox
        self.radius = style.radius
        self.stroke = t.checkBox.stroke
      end
      self:on("UI_DRAW", self.onDraw, self)
      self:on("UI_MOUSE_ENTER", self.onMouseEnter, self)
      self:on("UI_MOUSE_LEAVE", self.onMouseLeave, self)
      self:on("UI_MOUSE_DOWN", self.onMouseDown, self)
      return self:on("UI_MOUSE_UP", self.onMouseUp, self)
    end,
    __base = _base_0,
    __name = "CheckBox",
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
  CheckBox = _class_0
  return _class_0
end
