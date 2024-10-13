local MeowUI = MeowUI
local love = love
local Utils = assert(require(MeowUI.cwd .. "Core.Utils"))
local Event = assert(require(MeowUI.cwd .. "Core.Event"))
local Box = assert(require(MeowUI.cwd .. "Core.Box"))
local Circle = assert(require(MeowUI.cwd .. "Core.Circle"))
local Polygon = assert(require(MeowUI.cwd .. "Core.Polygon"))
local Chrono = assert(require(MeowUI.cwd .. "Core.Chrono"))
local Tremove = table.remove
local BBoxs = {
  Box = Box,
  Circle = Circle,
  Polygon = Polygon
}
local Control
do
  local _class_0
  local _base_0 = {
    getId = function(self)
      return self.id
    end,
    hasMinxins = function(self)
      return rawget(self.__class.__parent, "mixinsClass")
    end,
    getMixinsClass = function(control)
      local parent = control.__class.__parent
      assert((parent ~= nil), "The control does not have a parent class.")
      if rawget(parent, "mixinsClass") then
        return parent, false
      end
      local mixinsClass
      do
        local _class_1
        local _parent_0 = parent
        local _base_1 = { }
        _base_1.__index = _base_1
        setmetatable(_base_1, _parent_0.__base)
        _class_1 = setmetatable({
          __init = function(self, ...)
            return _class_1.__parent.__init(self, ...)
          end,
          __base = _base_1,
          __name = "mixinsClass",
          __parent = _parent_0
        }, {
          __index = function(cls, name)
            local val = rawget(_base_1, name)
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
            local _self_0 = setmetatable({}, _base_1)
            cls.__init(_self_0, ...)
            return _self_0
          end
        })
        _base_1.__class = _class_1
        local self = _class_1
        self.__name = tostring(control.__name) .. "Mixins"
        self.mixinsClass = true
        if _parent_0.__inherited then
          _parent_0.__inherited(_parent_0, _class_1)
        end
        mixinsClass = _class_1
      end
      control.__class.__parent = mixinsClass
      setmetatable(control.__class.__base, mixinsClass.__class.__base)
      return mixinsClass, true
    end,
    include = function(self, otherClass)
      local otherClassName
      if type(otherClass) == "string" then
        otherClass, otherClassName = assert(require(otherClass)), otherClass
      end
      assert((otherClass.__class ~= Control) and (otherClass.__class.__parent ~= Control), "Control is including a class that is or extends Control. An included class should be a plain class and not another control.")
      local mixinsClass = self:getMixinsClass()
      if otherClass.__class.__parent then
        self:include(otherClass.__class.__parent)
      end
      assert(otherClass.__class.__base ~= nil, "Expecting a class when trying to include " .. tostring(otherClassName or otherClass) .. " into " .. tostring(self.__name))
      for k, v in pairs(otherClass.__class.__base) do
        local _continue_0 = false
        repeat
          if k:match("^__") then
            _continue_0 = true
            break
          end
          mixinsClass.__base[k] = v
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      return true
    end,
    getRoot = function(self)
      return self.__class.root
    end,
    getBoundingBox = function(self)
      return self.boundingBox
    end,
    needConforming = function(self)
      self.requireConform = true
    end,
    localToGlobal = function(self, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      x = x + self.x
      y = y + self.y
      if self.parent then
        if self.parent:getBoundingBox().__class.__name == "Box" then
          x, y = self.parent:localToGlobal(x, y)
        else
          local r = self.parent:getRadius()
          x, y = self.parent:localToGlobal(x - r, y - r)
        end
      end
      return x, y
    end,
    globalToLocal = function(self, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      x = x - self.x
      y = y - self.y
      if self.parent then
        x, y = self.parent:globalToLocal(x, y)
      end
      return x, y
    end,
    conform = function(self)
      if not self.requireConform then
        return 
      end
      local x, y = self:localToGlobal()
      local w = self.width * self.anchorX
      local h = self.height * self.anchorY
      self.worldX = x - w
      self.worldY = y - h
      local box = self.boundingBox
      local _exp_0 = box.__class
      if Box == _exp_0 then
        do
          box:setPosition(self.worldX, self.worldY)
          box:setSize(self.worldX + self.width, self.worldY + self.height)
        end
      elseif Circle == _exp_0 then
        do
          box:setPosition(self.worldX, self.worldY)
          box:setRadius(self.radius)
        end
      elseif Polygon == _exp_0 then
        do
          box:setPosition(self.worldX, self.worldY)
          box:setRadius(self.radius)
        end
      end
      for k = 1, #self.children do
        self.children[k]:needConforming(true)
        self.children[k]:conform()
      end
      return self:needConforming(false)
    end,
    hitTest = function(self, x, y)
      if not self:getBoundingBox():contains(x, y) then
        return nil
      end
      if self.childrenEnabled then
        for i = #self.children, 1, -1 do
          local hitControl = self.children[i]:hitTest(x, y)
          if hitControl then
            return hitControl
          end
        end
      end
      if self.enabled then
        if MeowUI.debug then
          self._d = false
        end
        return self
      end
      if MeowUI.debug then
        self._d = true
        return self
      end
      return nil
    end,
    setParent = function(self, p)
      local _rootParent
      if p then
        if p["__class"] then
          if p.__class ~= Control then
            _rootParent = p.__class.__parent
            while _rootParent ~= Control do
              _rootParent = _rootParent.__parent
            end
          end
        else
          error("parent must a class.")
        end
      end
      _rootParent = _rootParent or p
      assert((p == nil) or (p.__class == Control) or (_rootParent.__class == Control), "parent must be nil or Control or a subclass of Control.")
      self.parent = p
      return self:needConforming(true)
    end,
    getParent = function(self)
      return self.parent
    end,
    sortChildren = function(self)
      return table.sort(self.children, function(a, b)
        return a.depth < b.depth
      end)
    end,
    childExists = function(self, id)
      for k = 1, #self.children do
        if self.children[k].id == id then
          return true
        end
      end
      return false
    end,
    addChild = function(self, child, depth)
      local _rootParent
      if child["__class"] then
        if child.__class ~= Control then
          _rootParent = child.__class.__parent
          while _rootParent ~= Control do
            _rootParent = _rootParent.__parent
          end
        end
      else
        error("parent must a class.")
      end
      _rootParent = _rootParent or child
      assert((child.__class == Control) or (_rootParent.__class == Control), "child must be Control or a subclass of Control.")
      assert(child:getParent() == nil, "child must be an Orphan Control.")
      if self:childExists(child.id) then
        return 
      end
      self.children[#self.children + 1] = child
      child:setParent(self)
      if depth then
        child:setDepth(depth)
      else
        child:setDepth(self:getDepth() + 1)
      end
      local events = child.events
      events:dispatch(events:getEvent("UI_ON_ADD"))
      self.__class.curMaxDepth = (child:getDepth() > self.__class.curMaxDepth) and child:getDepth() or self.__class.curMaxDepth
    end,
    setAnchor = function(self, x, y)
      assert((type(x) == 'number') and (type(y) == 'number'), "x and y must be of type number.")
      self.anchorX, self.anchorY = x, y
      return self:needConforming(true)
    end,
    getAnchor = function(self)
      return self.anchorX, self.anchorY
    end,
    setAnchorX = function(self, x)
      assert(type(x) == 'number', "x must be of type number.")
      self.anchorX = x
      return self:needConforming(true)
    end,
    getAnchorX = function(self)
      return self.anchorX
    end,
    setAnchorY = function(self, y)
      assert(type(y) == 'number', "y must be of type number.")
      self.anchorX = y
      return self:needConforming(true)
    end,
    getAnchorY = function(self)
      return self.anchorY
    end,
    setPosition = function(self, x, y)
      assert((type(x) == 'number') and (type(y) == 'number'), "x and y must be of type number.")
      self.x, self.y = x, y
      self:needConforming(true)
      return self.events:dispatch(self.events:getEvent("UI_MOVE"))
    end,
    getPosition = function(self)
      return self.x, self.y
    end,
    setX = function(self, x)
      assert(type(x) == 'number', "x must be of type number.")
      self.x = x
      return self:needConforming(true)
    end,
    getX = function(self)
      return self.x
    end,
    setY = function(self, y)
      assert(type(y) == 'number', "y must be of type number.")
      self.y = y
      return self:needConforming(true)
    end,
    getY = function(self)
      return self.y
    end,
    getSize = function(self)
      if self.boundingBox.__class.__name ~= "Box" then
        return nil
      end
      return self.w, self.h
    end,
    getWidth = function(self)
      return self.width
    end,
    getHeight = function(self)
      if self.boundingBox.__class.__name ~= "Box" then
        return nil
      end
      return self.height
    end,
    setWidth = function(self, w)
      if self.boundingBox.__class.__name ~= "Box" then
        return 
      end
      assert(type(w) == 'number', "w must be of type number.")
      self.width = w
      return self:needConforming(true)
    end,
    setHeight = function(self, h)
      if self.boundingBox.__class.__name ~= "Box" then
        return 
      end
      assert(type(h) == 'number', "h must be of type number.")
      self.height = h
      return self:needConforming(true)
    end,
    setSize = function(self, width, height)
      if self.boundingBox.__class.__name ~= "Box" then
        return 
      end
      assert((type(width) == 'number') and (type(height) == 'number'), "width and height must be of type number.")
      self.width, self.height = width, height
      return self:needConforming(true)
    end,
    setEnabled = function(self, enabled)
      self.enabled = enabled
    end,
    isEnabled = function(self)
      return self.enabled
    end,
    setChildrenEnabled = function(self, enabled)
      self.childrenEnabled = enabled
    end,
    isChildrenEnabled = function(self)
      return self.childrenEnabled
    end,
    setDepth = function(self, depth)
      assert((type(depth) == 'number') and (depth > 0), "Depth must be a number and > 0.")
      self.depth = depth
      if self.parent then
        return self.parent:sortChildren()
      end
    end,
    getDepth = function(self)
      return self.depth
    end,
    removeChild = function(self, id)
      for i = 1, #self.children do
        if self.children[i].id == id then
          local child = self.children[i]
          self.children[i]:setParent(nil)
          Tremove(self.children, i)
          child.events:dispatch(child.events:getEvent("UI_ON_REMOVE"))
          child = nil
          break
        end
      end
    end,
    dropChildren = function(self)
      self.children = { }
    end,
    disableChildren = function(self)
      for i = 1, #self.children do
        self.children[i]:setEnabled(false)
      end
    end,
    enableChildren = function(self)
      for i = 1, #self.children do
        self.children[i]:setEnabled(true)
      end
    end,
    getChildren = function(self)
      return self.children
    end,
    on = function(self, event, callback, target)
      assert(type(event) == 'string', "event must be of type string.")
      assert(type(callback) == 'function', "callback must be of type function.")
      local _rootParent
      if target["__class"] then
        if target.__class ~= Control then
          _rootParent = target.__class.__parent
          while _rootParent ~= Control do
            _rootParent = _rootParent.__parent
          end
        end
      else
        error("target must a class.")
      end
      _rootParent = _rootParent or target
      assert((target.__class == Control) or (_rootParent.__class == Control), "target must be a Control or a subclass of Control.")
      return self.events:on(self.events:getEvent(event), callback, target)
    end,
    addChrono = function(self, duration, repeated, alwaysUpdate, onDone)
      local chrono = Chrono.getInstance()
      return chrono:create(self, duration, repeated, alwaysUpdate, onDone)
    end,
    drawChildren = function(self)
      for i = 1, #self.children do
        self.children[i]:draw()
      end
    end,
    update = function(self, dt)
      return self:conform()
    end,
    setVisible = function(self, bool)
      self.visible = bool
    end,
    getVisible = function(self)
      return self.visible
    end,
    setRadius = function(self, r)
      if self.boundingBox.__class.__name == "Circle" or self.boundingBox.__class.__name == "Polygon" then
        assert((type(r) == 'number'), "radius must be of type number.")
        self.radius = r
        return self:needConforming(true)
      end
    end,
    getRadius = function(self)
      if self.boundingBox.__class.__name == "Circle" or self.boundingBox.__class.__name == "Polygon" then
        return self.radius
      end
      return nil
    end,
    setSides = function(self, sides)
      if self.boundingBox.__class.__name ~= "Polygon" then
        return 
      end
      return self.boundingBox:setSides(sides)
    end,
    getSides = function(self)
      if self.boundingBox.__class.__name ~= "Polygon" then
        return nil
      end
      return self.boundingBox:getSides()
    end,
    setAngle = function(self, angle)
      if self.boundingBox.__class.__name ~= "Polygon" then
        return 
      end
      return self.boundingBox:setAngle(angle)
    end,
    getAngle = function(self)
      if self.boundingBox.__class.__name ~= "Polygon" then
        return nil
      end
      return self.boundingBox:getAngle()
    end,
    setClip = function(self, bool)
      self.clip = bool
    end,
    getClip = function(self)
      return self.clip
    end,
    clipBegin = function(self)
      local box = self:getBoundingBox()
      if self.clip then
        local Graphics = love.graphics
        local _exp_0 = self.boundingBox.__class.__name
        if "Box" == _exp_0 then
          Graphics.stencil(function()
            return Graphics.rectangle("fill", box.x, box.y, box:getWidth(), box:getHeight())
          end)
        elseif "Polygon" == _exp_0 then
          Graphics.stencil(function()
            return Graphics.polygon("fill", box:getVertices())
          end)
        elseif "Circle" == _exp_0 then
          Graphics.stencil(function()
            return Graphics.circle("fill", box.x, box.y, box:getRadius())
          end)
        end
        return Graphics.setStencilTest("greater", 0)
      end
    end,
    clipEnd = function(self)
      if self.clip then
        local Graphics = love.graphics
        return Graphics.setStencilTest()
      end
    end,
    draw = function(self)
      if self.visible == false then
        return 
      end
      self:clipBegin()
      self.events:dispatch(self.events:getEvent("UI_DRAW"))
      self:drawChildren()
      return self:clipEnd()
    end,
    setUpdateWhenFocused = function(self, updateWhenFocused)
      self.updateWhenFocused = updateWhenFocused
    end,
    setLabel = function(self, l)
      self.label = l
    end,
    getLabel = function(self)
      return self.label
    end,
    setNotifyParent = function(self, bool)
      self.notifyParent = bool
    end,
    getNotifyParent = function(self, bool)
      return self.notifyParent
    end,
    setMakeTopWhenClicked = function(self, bool)
      self.makeTopWhenClicked = bool
    end,
    getMakeTopWhenClicked = function(self)
      return self.makeTopWhenClicked
    end,
    makeTop = function(self)
      self.originalDepth = self.depth
      self:setDepth(self.__class.curMaxDepth + 1)
      if self.parent then
        return self.parent:sortChildren()
      end
    end,
    rollBackDepth = function(self)
      if self.makeTopWhenClicked then
        self:setDepth(self.originalDepth)
        if self.parent then
          return self.parent:sortChildren()
        end
      end
    end,
    setFocusEnabled = function(self, bool)
      self.focusEnabled = bool
    end,
    getFocusEnabled = function(self)
      return self.focusEnabled
    end,
    setFocused = function(self, bool)
      self.focused = bool
    end,
    getFocused = function(self)
      return self.focused
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, boxT, __name)
      if boxT == nil then
        boxT = "Box"
      end
      self.__name = __name
      self.label = nil
      self.boxType = boxT
      self.id = Utils.Uid()
      self.x = 0
      self.y = 0
      self.anchorX = 0
      self.anchorY = 0
      self.width = 0
      self.height = 0
      self.depth = 1
      self.children = { }
      self.parent = nil
      self.visible = true
      self.enabled = true
      self.childrenEnabled = true
      self.events = Event()
      self.requireConform = false
      self.worldX = 0
      self.worldY = 0
      self.onTimerDone = nil
      self.updateWhenFocused = true
      self.radius = 0
      self.boundingBox = BBoxs[self.boxType]()
      self.clip = false
      self.notifyParent = false
      self.makeTopWhenClicked = false
      self.focusEnabled = true
      self.focused = false
    end,
    __base = _base_0,
    __name = "Control"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.__class.curMaxDepth = 0
  self.boxOverrides = {
    "setSize",
    "setWidth",
    "setHeight"
  }
  self.circleOverrides = {
    "setRadius"
  }
  self.polyOverrides = {
    "setRadius",
    "setSides",
    "setAngle"
  }
  Control = _class_0
  return _class_0
end
