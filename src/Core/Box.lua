local Box
do
  local _class_0
  local _base_0 = {
    contains = function(self, x, y)
      assert((type(x) == 'number') and (type(y) == 'number'), "x and y must be of type number.")
      if x < self.x or x >= self.width or y < self.y or y >= self.height then
        return false
      end
      return true
    end,
    getPosition = function(self)
      return self.x, self.y
    end,
    getSize = function(self)
      return self.width - self.x, self.height - self.y
    end,
    getWidth = function(self)
      return self.width - self.x
    end,
    getHeight = function(self)
      return self.height - self.y
    end,
    setPosition = function(self, x, y)
      assert((type(x) == 'number') and (type(y) == 'number'), "x and y must be of type number.")
      self.x, self.y = x, y
    end,
    getX = function(self)
      return self.x
    end,
    getY = function(self)
      return self.y
    end,
    setSize = function(self, width, height)
      assert((type(width) == 'number') and (type(height) == 'number'), "width and height must be of type number.")
      self.width, self.height = width, height
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      if width == nil then
        width = 0
      end
      if height == nil then
        height = 0
      end
      assert((type(x) == 'number') and (type(y) == 'number'), "x and y must be of type number.")
      assert((type(width) == 'number') and (type(height) == 'number'), "Width and Height must be of type number.")
      self.x = x
      self.y = y
      self.width = width
      self.height = height
    end,
    __base = _base_0,
    __name = "Box"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Box = _class_0
end
return Box
