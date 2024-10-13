local Singleton
do
  local _class_0
  local _base_0 = {
    __inherited = function(self, By)
      By.getInstance = function(...)
        do
          local I = By.Instance
          if I then
            return I
          end
        end
        do
          local I = By(...)
          By.Instance = I
          return I
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Singleton"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Singleton = _class_0
  return _class_0
end
