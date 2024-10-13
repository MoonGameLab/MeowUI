local pi, cos, sin, atan2, abs = math.pi, math.cos, math.sin, math.atan2, math.abs
local twoPi = 6.283185307179586476925287
local getAngle
getAngle = function(x1, y1, x2, y2)
  local dtheta, theta1, theta2
  theta1 = atan2(y1, x1)
  theta2 = atan2(y2, x2)
  dtheta = theta2 - theta1
  while dtheta > pi do
    dtheta = dtheta - twoPi
  end
  while dtheta < -pi do
    dtheta = dtheta + twoPi
  end
  return dtheta
end
local Polygon
do
  local _class_0
  local _base_0 = {
    calcVertices = function(self)
      self.vertices = { }
      for i = self.sides, 1, -1 do
        local x, y = 0, 0
        x = (sin(i / self.sides * 2 * pi - self.angle) * self.radius) + self.x
        y = (cos(i / self.sides * 2 * pi - self.angle) * self.radius) + self.y
        self.vertices[#self.vertices + 1] = {
          x,
          y
        }
      end
      return self:makeVerticesArray()
    end,
    contains = function(self, x, y)
      local x1, y1, x2, y2 = 0, 0, 0, 0
      local vertsNum = #self.vertices
      local angle = 0
      for i = 1, vertsNum, 1 do
        x1 = self.vertices[i][1] - x
        y1 = self.vertices[i][2] - y
        if (i + 1) % vertsNum ~= 0 then
          x2 = self.vertices[(i + 1) % vertsNum][1] - x
          y2 = self.vertices[(i + 1) % vertsNum][2] - y
          angle = angle + getAngle(x1, y1, x2, y2)
        end
      end
      if abs(angle) < pi then
        return false
      else
        return true
      end
    end,
    makeVerticesArray = function(self)
      for i = 1, #self.vertices do
        self.verticesArray[2 * i - 1] = self.vertices[i][1]
        self.verticesArray[2 * i] = self.vertices[i][2]
      end
    end,
    getVertices = function(self)
      return self.verticesArray
    end,
    setRadius = function(self, radius)
      if radius == self.radius then
        return 
      end
      assert((type(radius) == 'number'), "radius must be of type number.")
      self.radius = radius
      return self:calcVertices()
    end,
    getRadius = function(self)
      return self.radius
    end,
    setPosition = function(self, x, y)
      if x == nil then
        x = self.x
      end
      if y == nil then
        y = self.y
      end
      if x == self.x and y == self.y then
        return 
      end
      assert((type(x) == 'number') and (type(y) == 'number'), "x and y must be of type number.")
      self.x, self.y = x, y
      return self:calcVertices()
    end,
    getX = function(self)
      return self.x
    end,
    getY = function(self)
      return self.y
    end,
    getPosition = function(self)
      return self.x, self.y
    end,
    setSides = function(self, sides)
      if sides == self.sides then
        return 
      end
      assert((type(sides) == 'number'), "sides must be of type number.")
      self.sides = sides
      if sides == 3 then
        self.angle = self.angle or pi
      elseif sides == 4 then
        self.angle = self.angle or pi / 4
      end
      return self:calcVertices()
    end,
    getSides = function(self)
      return self.sides
    end,
    setAngle = function(self, angle)
      if angle == self.angle then
        return 
      end
      assert((type(angle) == 'number'), "angle must be of type number.")
      self.angle = angle
      return self:calcVertices()
    end,
    getAngle = function(self)
      return self.angle
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, n, radius, angle)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      if n == nil then
        n = 3
      end
      if radius == nil then
        radius = 0
      end
      self.vertices = { }
      self.verticesArray = { }
      self.sides = n
      self.x, self.y = x, y
      self.radius = radius
      if n == 3 then
        self.angle = angle or pi
      elseif n == 4 then
        self.angle = angle or pi / 4
      else
        self.angle = angle or 0
      end
      self.centroid = {
        x = self.x,
        y = self.y
      }
      return self:calcVertices()
    end,
    __base = _base_0,
    __name = "Polygon"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Polygon = _class_0
  return _class_0
end
