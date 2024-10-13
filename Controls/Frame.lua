local Button = assert(require(MeowUI.c_cwd .. "Button"))
local Content = assert(require(MeowUI.c_cwd .. "Content"))
local manager = MeowUI.manager
local Graphics = love.graphics
local drawToolBar
drawToolBar = function(self)
  local box = self:getBoundingBox()
  local r, g, b, a = Graphics.getColor()
  local boxW = box:getWidth()
  local _toolBarColor
  if self.focused then
    _toolBarColor = self.toolBarColor
  else
    _toolBarColor = self.toolBarColorUnfocused
  end
  Graphics.setColor(_toolBarColor)
  Graphics.rectangle("fill", box.x, box.y, boxW, self.toolBarHeight, self.rx, self.ry)
  Graphics.setColor(self.backgroundColor)
  Graphics.rectangle("line", box.x, box.y, boxW, self.toolBarHeight, self.rx, self.ry)
  return Graphics.setColor(r, g, b, a)
end
local Frame
do
  local _class_0
  local _parent_0 = Content
  local _base_0 = {
    onDraw = function(self)
      drawToolBar(self)
      local box = self:getBoundingBox()
      local r, g, b, a = Graphics.getColor()
      local boxW, boxH = box:getWidth(), box:getHeight()
      Graphics.setColor(self.toolBarTitleColor)
      Graphics.draw(self.toolBarTitle, box.x + self.titleOffSet, box.y + self.titleOffSet)
      Graphics.setColor(self.backgroundColor)
      Graphics.rectangle("fill", box.x, box.y + self.toolBarHeight, boxW, boxH - self.toolBarHeight, self.rx, self.ry)
      return Graphics.setColor(r, g, b, a)
    end,
    setSize = function(self, w, h)
      _class_0.__parent.__base.setSize(self, w, h)
      return self.closeBtn:setPosition(w - 20, 6)
    end,
    setPosition = function(self, x, y)
      return _class_0.__parent.__base.setPosition(self, x, y)
    end,
    onFocus = function(self)
      self.focused = true
    end,
    onUnFocus = function(self)
      self.focused = false
    end,
    isInsideToolBar = function(self, x, y)
      return x >= self:getX() and x <= self:getX() + self:getWidth() and y >= self:getY() and y <= self:getY() + self.toolBarHeight
    end,
    onMouseDown = function(self, x, y, btn)
      if self:isInsideToolBar(x, y) then
        return _class_0.__parent.__base.onMouseDown(self, x, y, btn)
      end
    end,
    addChild = function(self, child, depth)
      child:setNotifyParent(true)
      return _class_0.__parent.__base.addChild(self, child, depth)
    end,
    onAdd = function(self)
      manager:setFocus(self)
      return self:onFocus()
    end,
    onClick = function(self)
      manager:setFocus(self)
      return self:onFocus()
    end,
    setToolBarTitle = function(self, text, size, font)
      if text == nil then
        text = self.text
      end
      if size == nil then
        size = 15
      end
      if size and font then
        if type(font) == "number" then
          self.font = Graphics.newFont(font)
        end
        if type(font) == "string" then
          self.font = Graphics.newFont(font, size)
        end
        self.toolBarTitle = Graphics.newText(self.font, text)
      end
      if size then
        self.font = Graphics.newFont(size)
        self.toolBarTitle = Graphics.newText(self.font, text)
      end
      self.titleOffSet = math.floor(((self.toolBarHeight - 1) / 2) - (size / 2))
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, label, vbar, hbar)
      _class_0.__parent.__init(self, label, vbar, hbar, false)
      self.toolBarHeight = 26
      local t = self:getTheme()
      self.toolBarColor = t.frame.toolBarColor
      self.toolBarColorUnfocused = t.frame.toolBarColorUnfocused
      self.backgroundColor = t.frame.contentBackground
      self.toolBarTitleColor = t.frame.toolBarTitleColor
      self.closeBtn = Button("Box")
      do
        local _with_0 = self.closeBtn
        _with_0:setLabel("Frame_closeBtn")
        _with_0:setSize(18, 18)
        _with_0:setImage(MeowUI.assets .. "cross.png", true)
        _with_0:setStroke(0)
        _with_0:setNotifyParent(true)
        _with_0:onClick(function()
          return self:destruct(MeowUI.manager:getRoot())
        end)
      end
      self:on("UI_DRAW", self.onDraw, self)
      self:on("UI_FOCUS", self.onFocus, self)
      self:on("UI_UN_FOCUS", self.onUnFocus, self)
      self:on("UI_CLICK", self.onClick, self)
      self:on("UI_MOUSE_DOWN", self.onMouseDown, self)
      self:on("UI_ON_ADD", self.onAdd, self)
      self:addChild(self.closeBtn)
      self:setDrag(true)
      self:setMakeTopWhenClicked(true)
      return self:setToolBarTitle(label, math.ceil(self.toolBarHeight / 2))
    end,
    __base = _base_0,
    __name = "Frame",
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
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Frame = _class_0
end
return Frame
