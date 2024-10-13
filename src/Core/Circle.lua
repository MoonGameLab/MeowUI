local sqrt = math.sqrt
local pointToPointSqr
pointToPointSqr = function(x1, y1, x2, y2)
  local dx, dy = x2 - x1, y2 - y1
  return dx * dx + dy * dy
end
local pointToPointDist
pointToPointDist = function(x1, y1, x2, y2)
  return sqrt(pointToPointSqr(x1, y1, x2, y2))
end
local Circle
do
  local _class_0
  local _base_0 = {
    contains = function(self, x, y)
      if pointToPointDist(self.x, self.y, x, y) < self.radius then
        return true
      end
      return false
    end,
    getPosition = function(self)
      return self.x, self.y
    end,
    getX = function(self)
      return self.x
    end,
    getY = function(self)
      return self.y
    end,
    getRadius = function(self)
      return self.radius
    end,
    getSize = function(self)
      return self:getRadius()
    end,
    getWidth = function(self)
      return self:getRadius() - self.x
    end,
    getHeight = function(self)
      return self:getRadius() - self.y
    end,
    setPosition = function(self, x, y)
      assert((type(x) == 'number') and (type(y) == 'number'), "x and y must be of type number.")
      self.x, self.y = x, y
    end,
    setRadius = function(self, radius)
      assert((type(radius) == 'number'), "radius must be of type number.")
      self.radius = radius
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, radius)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      if radius == nil then
        radius = 0
      end
      assert((type(x) == 'number') and (type(y) == 'number'), "x and y must be of type number.")
      assert(type(radius) == 'number', "radius must be of type number.")
      self.x = x
      self.y = y
      self.radius = radius
    end,
    __base = _base_0,
    __name = "Circle"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Circle = _class_0
  return _class_0
end
