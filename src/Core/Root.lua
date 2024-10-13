local MeowUI = MeowUI
local love = love
local Control = MeowUI.Control
local Graphics = love.graphics
local Root
do
  local _class_0
  local _parent_0 = Control
  local _base_0 = {
    clear = function(self)
      return self:dropChildren()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self, "Box", "rootControl")
      local w, h = Graphics.getWidth(), Graphics.getHeight()
      do
        local _with_0 = self
        _with_0:setSize(w, h)
        _with_0:setEnabled(false)
        return _with_0
      end
    end,
    __base = _base_0,
    __name = "Root",
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
  Root = _class_0
  return _class_0
end
