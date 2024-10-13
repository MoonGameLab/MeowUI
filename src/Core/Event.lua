local MeowUI = MeowUI
local love = love
local Tinsert = table.insert
local Utils = assert(require(MeowUI.cwd .. "Core.Utils"))
local Event
do
  local _class_0
  local _base_0 = {
    getEvent = function(self, ename)
      assert(type(ename) == 'string', "Event name must be of type string.")
      return self.__class.eventsDef[ename]
    end,
    drop = function(self)
      self.handlers = { }
    end,
    on = function(self, name, callback, target)
      assert(type(name) == 'string', "Event name must be of type string.")
      assert(type(callback) == 'function', "Callback must be a function.")
      assert(type(target) == 'table', "Target must be a table.")
      if not self.handlers[name] then
        self.handlers[name] = { }
      end
      local hdlr = {
        id = Utils.Uid(),
        callback = callback,
        target = target
      }
      Tinsert(self.handlers[name], hdlr)
      return hdlr
    end,
    dispatch = function(self, name, ...)
      assert(type(name) == 'string', "Event name must be of type string.")
      local hdlr = self.handlers[name]
      if not hdlr then
        return false
      end
      for i = 1, #hdlr do
        local handler = hdlr[i]
        if handler.callback then
          if handler.target then
            if handler.callback(handler.target, ...) then
              return true
            end
          else
            if handler.callback(...) then
              return true
            end
          end
        end
      end
      return false
    end,
    remove = function(self, event, id)
      local _event = self:getEvent(event)
      if self.handlers[_event] == nil then
        return 
      end
      for i = 1, #self.handlers[_event] do
        local h = self.handlers[_event][i]
        if h.id == id then
          self.handlers[self:getEvent(event)][i] = nil
          return 
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.handlers = { }
    end,
    __base = _base_0,
    __name = "Event"
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
  self.eventsDef = {
    UI_MOUSE_DOWN = "mouseDown",
    UI_MOUSE_UP = "mouseUp",
    UI_MOUSE_MOVE = "mouseMove",
    UI_MOUSE_ENTER = "mouseEnter",
    UI_MOUSE_LEAVE = "mouseLeave",
    UI_WHELL_MOVE = "whellMove",
    UI_CLICK = "click",
    UI_DB_CLICK = "dbClick",
    UI_FOCUS = "focus",
    UI_UN_FOCUS = "unFocus",
    UI_KEY_DOWN = "keyDown",
    UI_KEY_UP = "keyUp",
    UI_TEXT_INPUT = "textInput",
    UI_TEXT_CHANGE = "textChange",
    UI_UPDATE = "update",
    UI_DRAW = "draw",
    UI_MOVE = "move",
    UI_ON_ADD = "onAdd",
    UI_ON_REMOVE = "onRemove",
    UI_ON_SCROLL = "onScroll",
    UI_ON_SELECT = "onSelect",
    TIMER_DONE = "onTimerDone"
  }
  Event = _class_0
  return _class_0
end
