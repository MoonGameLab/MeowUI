local MeowUI = MeowUI
local Tinsert = table.insert
local Utils = assert(require(MeowUI.cwd .. "Core.Utils"))
local Singleton = assert(require(MeowUI.cwd .. "Core.Singleton"))
local tick
tick = function(self, dt)
  self.time = self.time + (1 * dt)
  if self.time >= self.duration then
    self:onDone(self)
    if self.repeated then
      self.time = 0
    else
      self.isDone = true
    end
  end
  return false
end
local Chrono
do
  local _class_0
  local _parent_0 = Singleton
  local _base_0 = {
    getTimersCount = function(self)
      return #self.timers
    end,
    create = function(self, owner, duration, repeated, alwaysUpdate, onDone)
      assert(type(duration) == 'number', "duration must be of type number.")
      assert(type(onDone) == 'function', "onDone must be of type number.")
      local timer = {
        id = Utils.Uid(),
        time = 0,
        duration = duration,
        onDone = onDone,
        isDone = false,
        tick = tick,
        owner = owner,
        repeated = repeated and true or false,
        alwaysUpdate = alwaysUpdate
      }
      Tinsert(self.timers, timer)
      return timer
    end,
    update = function(self, dt)
      if self:getTimersCount() == 0 then
        return 
      end
      for i = 1, self:getTimersCount(), 1 do
        if self.timers[i].alwaysUpdate or self.timers[i].owner == MeowUI.clickedControl then
          if self.timers[i] and self.timers[i]:tick(dt) then
            self.timers[i] = nil
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.timers = { }
    end,
    __base = _base_0,
    __name = "Chrono",
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
  Chrono = _class_0
  return _class_0
end
