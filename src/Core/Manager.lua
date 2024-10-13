local MeowUI = MeowUI
local love = love
local Root = assert(require(MeowUI.cwd .. "Core.Root"))
local Singleton = assert(require(MeowUI.cwd .. "Core.Singleton"))
local DEBUG = assert(require(MeowUI.cwd .. "Core.Debug"))
local Timer = love.timer
local Mouse = love.mouse
local Chrono = assert(require(MeowUI.cwd .. "Core.Chrono"))
local debug
debug = function(hitControl)
  if hitControl and hitControl._d then
    DEBUG:watch(hitControl)
    return nil
  else
    DEBUG:watch(hitControl)
    return hitControl
  end
end
local Manager
do
  local _class_0
  local _parent_0 = Singleton
  local _base_0 = {
    getRoot = function(self)
      return self.rootControl
    end,
    update = function(self, dt)
      Chrono.getInstance():update(dt)
      if self.rootControl then
        self.rootControl:update(dt)
      end
      if self.focusControl and self.focusControl.updateWhenFocused then
        return self.__class:dispatch(self.focusControl, "UI_UPDATE", dt)
      end
    end,
    draw = function(self)
      if self.rootControl then
        self.rootControl:draw()
      end
      if MeowUI.debug then
        return DEBUG:draw()
      end
    end,
    mousemoved = function(self, x, y, dx, dy)
      if not self.rootControl then
        return 
      end
      local hitControl = self.rootControl:hitTest(x, y)
      MeowUI.hoveredControl = hitControl
      if MeowUI.debug then
        hitControl = debug(hitControl)
      end
      if hitControl ~= self.hoverControl then
        if self.hoverControl then
          self.__class:dispatch(self.hoverControl, "UI_MOUSE_LEAVE")
        end
        self.hoverControl = hitControl
        if hitControl then
          self.__class:dispatch(hitControl, "UI_MOUSE_ENTER")
        end
      end
      if self.holdControl then
        return self.__class:dispatch(self.holdControl, "UI_MOUSE_MOVE", x, y, dx, dy)
      else
        if self.hoverControl then
          return self.__class:dispatch(self.hoverControl, "UI_MOUSE_MOVE", x, y, dx, dy)
        end
      end
    end,
    setFocus = function(self, control)
      if self.focusControl == control then
        return 
      end
      if self.focusControl then
        self.__class:dispatch(self.focusControl, "UI_UN_FOCUS")
        self.focusControl:rollBackDepth()
        self.focusControl:setFocused(false)
      end
      self.focusControl = control
      if control:getMakeTopWhenClicked() then
        control:makeTop()
      end
      if self.focusControl then
        self.__class:dispatch(self.focusControl, "UI_FOCUS")
        return self.focusControl:setFocused(true)
      end
    end,
    notify = function(self, control, name)
      local _exp_0 = name
      if "UI_FOCUS" == _exp_0 then
        return control:setFocused(true)
      elseif "UI_UN_FOCUS" == _exp_0 then
        return control:setFocused(false)
      end
    end,
    mousepressed = function(self, x, y, button, isTouch)
      if not self.rootControl then
        return 
      end
      local hitControl = self.rootControl:hitTest(x, y)
      MeowUI.clickedControl = hitControl
      if MeowUI.debug then
        hitControl = debug(hitControl)
      end
      if hitControl then
        self.__class:dispatch(hitControl, "UI_MOUSE_DOWN", x, y, button, isTouch)
        self.holdControl = hitControl
      end
      if hitControl then
        if hitControl:getFocusEnabled() then
          return self:setFocus(hitControl)
        end
      else
        return self:setFocus(self.focusControl)
      end
    end,
    mousereleased = function(self, x, y, button, isTouch)
      if self.holdControl then
        self.__class:dispatch(self.holdControl, "UI_MOUSE_UP", x, y, button, isTouch)
        if self.rootControl then
          local hitControl = self.rootControl:hitTest(x, y)
          MeowUI.releasedControl = hitControl
          if MeowUI.debug then
            hitControl = debug(hitControl)
          end
          if hitControl == self.holdControl then
            if self.lastClickControl and self.lastClickControl == self.holdControl and (Timer.getTime() - self.lastClickTime <= 0.4) then
              self.__class:dispatch(self.holdControl, "UI_DB_CLICK", self.holdControl, x, y)
              self.lastClickControl = nil
              self.lastClickTime = 0
            else
              self.__class:dispatch(self.holdControl, "UI_CLICK", self.holdControl, x, y)
              self.lastClickControl = self.holdControl
              self.lastClickTime = Timer.getTime()
            end
          end
        end
        self.holdControl = nil
      end
    end,
    wheelmoved = function(self, x, y)
      local hitControl = self.rootControl:hitTest(Mouse:getX(), Mouse:getY())
      MeowUI.wheeledControl = hitControl
      if MeowUI.debug then
        hitControl = debug(hitControl)
      end
      while hitControl do
        self:mousemoved(Mouse:getX(), Mouse:getY(), 0, 0)
        if self.__class:dispatch(hitControl, "UI_WHELL_MOVE", x, y) then
          return 
        end
        hitControl = hitControl:getParent()
      end
    end,
    keypressed = function(self, key, scancode, isrepeat)
      if key == "f1" then
        MeowUI.debug = not MeowUI.debug
      end
      if self.focusControl then
        return self.__class:dispatch(self.focusControl, "UI_KEY_DOWN", key, scancode, isrepeat)
      end
    end,
    keyreleased = function(self, key)
      if self.focusControl then
        return self.__class:dispatch(self.focusControl, "UI_KEY_UP", key)
      end
    end,
    textinput = function(self, text)
      if self.focusControl then
        return self.__class:dispatch(self.focusControl, "UI_TEXT_INPUT", text)
      end
    end,
    resize = function(self, w, h)
      return self.rootControl:resize(w, h)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.rootControl = Root()
      self.rootControl:setEnabled(true)
      self.hoverControl = nil
      self.focusControl = nil
      self.holdControl = nil
      self.lastClickControl = nil
      self.lastClickTime = Timer.getTime()
    end,
    __base = _base_0,
    __name = "Manager",
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
  self.dispatch = function(self, control, name, ...)
    control.events:dispatch(control.events:getEvent(name), ...)
    if control:getNotifyParent() then
      local p = control:getParent()
      return self:notify(p, name, ...)
    end
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Manager = _class_0
end
return Manager.getInstance()
