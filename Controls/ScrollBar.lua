local love = love
local MeowUI = MeowUI
local Graphics = love.graphics
local Control = MeowUI.Control
local Button = assert(require(MeowUI.c_cwd .. "Button"))
local Mixins = assert(require(MeowUI.root .. "Controls.mx"))
local ScrollBar
do
  local _class_0
  local _parent_0 = Control
  local _base_0 = {
    onDraw = function(self)
      local box = self:getBoundingBox()
      local x, y = box:getPosition()
      local width, height = box:getSize()
      local r, g, b, a = Graphics.getColor()
      local color = self.backgroundColor
      color[4] = color[4] or self.alpha
      Graphics.setColor(color)
      Graphics.rectangle("fill", x, y, width, height)
      return Graphics.setColor(r, g, b, a)
    end,
    onBarDown = function(self)
      self.barDown = true
    end,
    onBarUp = function(self)
      self.barDown = false
    end,
    setBarPos = function(self, ratio)
      if ratio < 0 then
        ratio = 0
      end
      if ratio > 1 then
        ratio = 1
      end
      self.barPosRation = ratio
      if self.dir == "vertical" then
        self.bar:setX(0)
        self.bar:setY((self:getHeight() - self.bar:getHeight()) * ratio)
      else
        self.bar:setX((self:getWidth() - self.bar:getWidth()) * ratio)
        self.bar:setY(0)
      end
      return self.events:dispatch(self.events:getEvent("UI_ON_SCROLL"), ratio)
    end,
    onBarMove = function(self, x, y, dx, dy)
      if self.barDown == false then
        return 
      end
      local bar = self.bar
      if self.dir == "vertical" then
        local after = bar:getY() + dy
        if after < 0 then
          after = 0
        elseif after + bar:getHeight() > self:getHeight() then
          after = self:getHeight() - bar:getHeight()
        end
        self.barPosRation = after / (self:getHeight() - bar:getHeight())
      else
        local after = bar:getX() + dx
        if after < 0 then
          after = 0
        elseif after + bar:getWidth() > self:getWidth() then
          after = self:getWidth() - bar:getWidth()
        end
        self.barPosRation = after / (self:getWidth() - bar:getWidth())
      end
      return self:setBarPos(self.barPosRation)
    end,
    onBgDown = function(self, x, y)
      x, y = self:globalToLocal(x, y)
      if self.dir == "vertical" then
        return self:setBarPos(y / self:getHeight())
      else
        return self:setBarPos(x / self:getWidth())
      end
    end,
    reset = function(self)
      local ratio = self.ratio
      if self.dir == "vertical" then
        self.bar:setWidth(self:getWidth())
        self.bar:setHeight(self:getHeight() / ratio)
      else
        self.bar:setWidth(self:getWidth() / ratio)
        self.bar:setHeight(self:getHeight())
      end
      return self:setBarPos(self.barPosRation)
    end,
    setDir = function(self, dir)
      self.dir = dir
      return self:reset()
    end,
    getDir = function(self)
      return self.dir
    end,
    setSize = function(self, width, height)
      _class_0.__parent.__base.setSize(self, width, height)
      return self:reset()
    end,
    setWidth = function(self, width)
      _class_0.__parent.__base.setWidth(self, width)
      return self:reset()
    end,
    setHeight = function(self, height)
      _class_0.__parent.__base.setHeight(self, height)
      return self:reset()
    end,
    getBar = function(self)
      return self.bar
    end,
    getBarPos = function(self)
      return self.barPosRation
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, type)
      _class_0.__parent.__init(self, "Box", "ScrollBar")
      self.bar = Button(type)
      self:setEnabled(true)
      local t = self:getTheme()
      local style = t.scrollBar
      self.bar:setSize(style.width, style.width)
      self.backgroundColor = t.colors.scrollBar
      self.alpha = 1
      self.dir = "vertical"
      self.ratio = 5
      self.barPosRation = 0
      self.barDown = false
      self:setSize(style.width, style.height)
      self:on("UI_MOUSE_DOWN", self.onBarDown, self)
      self:on("UI_MOUSE_MOVE", self.onBarMove, self)
      self:on("UI_MOUSE_UP", self.onBarUp, self)
      self:on("UI_MOUSE_DOWN", self.onBgDown, self)
      self:on("UI_DRAW", self.onDraw, self)
      self:addChild(self.bar)
      self.bar:on("UI_MOUSE_DOWN", self.onBarDown, self.bar:getParent())
      self.bar:on("UI_MOUSE_UP", self.onBarUp, self.bar:getParent())
      self.bar:on("UI_MOUSE_MOVE", self.onBarMove, self.bar:getParent())
      self.bar:on("UI_MOUSE_DOWN", self.onBgDown, self.bar:getParent())
      return self:reset()
    end,
    __base = _base_0,
    __name = "ScrollBar",
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
  self:include(Mixins.ThemeMixins)
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  ScrollBar = _class_0
  return _class_0
end
