local MeowUI = MeowUI
local love = love
local Singleton = assert(require(MeowUI.cwd .. "Core.Singleton"))
local Graphics = love.graphics
local Debug
do
  local _class_0
  local _parent_0 = Singleton
  local _base_0 = {
    watch = function(self, control)
      if control == nil then
        return 
      end
      if self.focusControl == nil then
        self.focusControl = control
      end
      if control.id ~= self.focusControl.id then
        self.focusControl = control
        self.focusControlType = control.boundingBox.__class.__name
      end
    end,
    draw = function(self)
      local Timer = love.timer
      local delta = Timer.getDelta()
      local fps = Timer.getFPS()
      local loveV = love._version
      local libV = MeowUI.version
      local stage = MeowUI.stage
      if self.focusControl then
        local r, g, b, a = Graphics.getColor()
        local oldLineWidth = Graphics.getLineWidth()
        local box = self.focusControl:getBoundingBox()
        local _exp_0 = self.focusControlType
        if "Box" == _exp_0 then
          Graphics.setLineWidth(2)
          Graphics.setColor(self.outlineColor)
          Graphics.rectangle('line', box:getX(), box:getY(), box:getWidth(), box:getHeight())
        elseif "Circle" == _exp_0 then
          Graphics.setLineWidth(2)
          Graphics.setColor(self.outlineColor)
          Graphics.circle('line', box:getX(), box:getY(), box:getRadius())
        elseif "Polygon" == _exp_0 then
          Graphics.setLineWidth(2)
          Graphics.setColor(self.outlineColor)
          Graphics.polygon("line", box:getVertices())
        end
        Graphics.setLineWidth(oldLineWidth)
        Graphics.setColor(r, g, b, a)
      end
      local oldFont = Graphics.getFont()
      local r, g, b, a = Graphics.getColor()
      Graphics.setFont(self.font)
      Graphics.setColor(self.boxColor)
      Graphics.rectangle('fill', self.x, self.y, 165, 234)
      Graphics.setColor(self.palette.blue)
      Graphics.print("MeowUI [" .. libV .. " - " .. stage .. "]", self.x + 18, self.y + 5)
      Graphics.setColor(self.palette.white)
      Graphics.print("LOVE Version [" .. loveV .. "]", self.x + 35, self.y + 20)
      Graphics.line(self.x, self.y + 40, self.x + 165, self.y + 40)
      Graphics.print("FPS: " .. fps, self.x + 5, self.y + 45)
      Graphics.print("Delta: " .. delta, self.x + 5, self.y + 60)
      Graphics.print("MEM (KB): " .. collectgarbage('count'), self.x + 5, self.y + 75)
      local controlInfo
      controlInfo = function(focusControl)
        local cy = 0
        local pname
        if self.focusControl.boxType == "Polygon" then
          cy = 160
        else
          cy = 148
        end
        local parent = focusControl:getParent()
        if parent == nil then
          pname = "Control"
        else
          pname = parent.__name or "Control"
        end
        Graphics.print("Parent: " .. pname, self.x + 10, self.y + cy)
        Graphics.print("Depth: " .. focusControl.depth, self.x + 10, self.y + cy + 12)
        Graphics.print("#Children: " .. #focusControl.children, self.x + 10, self.y + cy + 24)
        Graphics.print("isClipped: " .. tostring(focusControl:getClip()), self.x + 10, self.y + cy + 36)
        return Graphics.print("isVisible: " .. tostring(focusControl:getVisible()), self.x + 10, self.y + cy + 48)
      end
      Graphics.setColor(self.palette.green)
      if self.focusControl then
        local wh = Graphics.getHeight()
        Graphics.setColor(self.boxColor)
        Graphics.rectangle('fill', 0, wh - 20, 230, 20)
        Graphics.setColor(self.palette.white)
        Graphics.print("id: " .. self.focusControl.id, 5, wh - 15)
        Graphics.setColor(self.palette.blue)
        Graphics.rectangle('line', self.x + 5, self.y + 95, 155, 134)
        local className = self.focusControl.__name or self.focusControl.__class.__name
        local box = self.focusControl:getBoundingBox()
        Graphics.setColor(self.palette.white)
        if self.focusControl.label then
          Graphics.print(self.focusControl.label .. ": " .. className, self.x + 10, self.y + 100)
        else
          Graphics.print("Class: " .. className, self.x + 10, self.y + 100)
        end
        Graphics.print("Box_type: " .. self.focusControl.boxType, self.x + 10, self.y + 112)
        Graphics.print("Pos: " .. box:getX() .. ", " .. box:getY(), self.x + 10, self.y + 124)
        local _exp_0 = self.focusControl.boxType
        if "Box" == _exp_0 then
          Graphics.print("Size (w|h): " .. self.focusControl:getWidth() .. ", " .. self.focusControl:getHeight(), self.x + 10, self.y + 136)
          controlInfo(self.focusControl)
        elseif "Polygon" == _exp_0 then
          Graphics.print("Radius: " .. self.focusControl:getRadius(), self.x + 10, self.y + 136)
          Graphics.print("#Vertices: " .. #self.focusControl:getBoundingBox():getVertices() / 2, self.x + 10, self.y + 148)
          controlInfo(self.focusControl)
        elseif "Circle" == _exp_0 then
          Graphics.print("Radius: " .. self.focusControl:getRadius(), self.x + 10, self.y + 136)
          controlInfo(self.focusControl)
        end
      end
      Graphics.setFont(oldFont)
      return Graphics.setColor(r, g, b, a)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.focusedControl = nil
      self.x, self.y = 5, 40
      self.font = Graphics.newFont(9)
      self.outlineColor = {
        1,
        0,
        0,
        1
      }
      self.boxColor = {
        0,
        0,
        0,
        0.78431372549
      }
      self.palette = {
        red = {
          1,
          0,
          0,
          1
        },
        blue = {
          0,
          0.8,
          1,
          1
        },
        green = {
          0,
          1,
          0,
          1
        },
        white = {
          1,
          1,
          1,
          1
        }
      }
    end,
    __base = _base_0,
    __name = "Debug",
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
  Debug = _class_0
end
return Debug.getInstance()
