local Graphics = love.graphics
local Window = love.window
local MeowUI = MeowUI
local utf8 = utf8
local love = love
local Control = MeowUI.Control
local Mixins = assert(require(MeowUI.root .. "Controls.mx"))
local colors = assert(require(MeowUI.root .. "src.AddOns.Colors"))
local tableHasValue = Mixins.tableHasValue
local stencilFunc
stencilFunc = function(self)
  local bg = self:getBoundingBox()
  return function()
    return Graphics.rectangle("fill", bg.x, bg.y, self:getWidth(), self:getHeight())
  end
end
local TextInput
do
  local _class_0
  local _parent_0 = Control
  local _base_0 = {
    indicatorBlink = function(self)
      local time = love.timer.getTime()
      local text = self.lines[self.line]
      if self.indincatortime < time then
        if self.showIndicator then
          self.showIndicator = false
        else
          self.showIndicator = true
        end
        self.indincatortime = (time + 0.50)
      end
    end,
    updateIndicator = function(self)
      local text = self.lines[self.line]
      if self.allTextSelected then
        self.showIndicator = false
      else
        if self:keyboardIsDown("up", "down", "left", "right") then
          self.showIndicator = true
        end
      end
      local width = 0
      if self.masked then
        width = self.font:getWidth(string.rep(self.maskChar, self.indiNum))
      else
        if self.indiNum == 0 then
          width = 0
        elseif self.indiNum >= utf8.len(text) then
          width = self.font:getWidth(text)
        else
          width = self.font:getWidth(utf8.sub(text, 1, self.indiNum))
        end
      end
      if self.multiline then
        return 
      else
        self.indicatorx = self.textx + width
        self.indicatory = self.texty
      end
    end,
    moveIndicator = function(self, num, exact)
      if exact == nil then
        exact = nil
      end
      if exact == nil then
        self.indiNum = self.indiNum + num
      else
        self.indiNum = num
      end
      local text = self.lines[self.line]
      if self.indiNum > utf8.len(text) then
        self.indiNum = utf8.len(text)
      elseif self.indiNum < 0 then
        self.indiNum = 0
      end
      self.showIndicator = true
      return self:updateIndicator()
    end,
    offsetTextTab = function(self)
      local twidth = 0
      local cwidth = 0
      local text = self.lines[self.line]
      if self.masked then
        twidth = self.font:getWidth(utf8.gsub(text, ".", maskChar))
        cwidth = self.font:getWidth(utf8.gsub(self.tabreplacement, ".", maskChar))
      else
        twidth = self.font:getWidth(text)
        cwidth = self.font:getWidth(self.tabreplacement)
      end
      if (twidth + self.textoffsetx) >= (self.width - 1) then
        self.offsetx = self.offsetx + cwidth
      end
      return self:moveIndicator(1)
    end,
    removeFromTxt = function(self, pos)
      local curLine = self.lines[self.line]
      local text = curLine
      local p1 = utf8.sub(text, 1, pos - 1)
      local removedTxt = utf8.sub(text, pos, pos + 1)
      local p2 = utf8.sub(text, pos + 1)
      local new = p1 .. p2
      return new, removedTxt
    end,
    addIntoTxt = function(self, txt, pos)
      local text = self.lines[self.line]
      local p1 = utf8.sub(text, 1, pos)
      local p2 = utf8.sub(text, pos + 1)
      local new = p1 .. txt .. p2
      return new
    end,
    clear = function(self)
      self.lines = {
        ""
      }
      self.line = 1
      self.offsetx = 0
      self.offsety = 0
      self.indiNum = 0
    end,
    processKey = function(self, key, isText)
      if self.visible == false then
        return 
      end
      local offsetx = self.offsetx
      local bg = self:getBoundingBox()
      if isText == false then
        if key == "left" then
          if self.multiline == false then
            self:moveIndicator(-1)
            if self.indicatorx <= bg.x and self.indiNum ~= 0 then
              local currentLine = self.lines[self.line]
              local width = self.font:getWidth(utf8.sub(currentLine, self.indiNum, self.indiNum + 1))
              self.offsetx = offsetx - width
            elseif self.indiNum == 0 and offsetx ~= 0 then
              self.offsetx = 0
            end
          else
            return 
          end
          if self.allTextSelected then
            self.line = 1
            self.indiNum = 0
            self.allTextSelected = false
          end
        elseif key == "right" then
          if self.multiline == false then
            self:moveIndicator(1)
            local currentLine = self.lines[self.line]
            if self.indicatorx >= (bg.x + self:getWidth()) and self.indiNum ~= utf8.len(currentLine) then
              local width = self.font:getWidth(utf8.sub(currentLine, self.indiNum, self.indiNum))
              self.offsetx = offsetx + width
            elseif self.indiNum == utf8.len(currentLine) and offsetx ~= ((self.font:getWidth(currentLine)) - self.width + 10) and self.font:getWidth(currentLine) + self.textoffsetx > self.width then
              self.offsetx = ((self.font:getWidth(currentLine)) - self:getWidth() + 10)
            end
          else
            return 
          end
          if self.allTextSelected then
            self.line = #self.lines
            self.indiNum = utf8.len(self.lines[#self.lines])
            self.allTextSelected = false
          end
        end
        if self.editable == false then
          return 
        end
        if key == "backspace" then
          if self.allTextSelected then
            self:clear()
            self.allTextSelected = false
            return self:updateIndicator()
          else
            local removedTxt = ''
            local text = self.lines[self.line]
            if text ~= "" and self.indiNum ~= 0 then
              text, removedTxt = self:removeFromTxt(self.indiNum)
              self:moveIndicator(-1)
              self.lines[self.line] = text
            end
            local cwidth = 0
            if self.masked then
              cwidth = self.font:getWidth(utf8.gsub(removedTxt, ".", maskChar))
            else
              cwidth = self.font:getWidth(removedTxt)
            end
            if self.offsetx > 0 then
              self.offsetx = self.offsetx - cwidth
            elseif self.offsetx < 0 then
              self.offsetx = 0
            end
          end
        elseif key == "delete" then
          if editable == false then
            return 
          end
          if self.allTextSelected then
            self:clear()
            self.allTextSelected = false
            return self:updateIndicator()
          end
        elseif key == "tab" then
          if self.allTextSelected then
            return 
          end
          self.lines[self.line] = self:addIntoTxt(self.tabreplacement, self.indiNum)
          self:moveIndicator(utf8.len(self.tabreplacement))
          self:updateIndicator()
          local text = self.lines[self.line]
          if self.multiline == false then
            self:offsetTextTab()
            local currentLine = self.lines[self.line]
            if self.indicatorx >= (self.x + self.width) and self.indiNum ~= utf8.len(currentLine) then
              local width = self.font:getWidth(utf8.sub(currentLine, self.indiNum, self.indiNum))
              self.offsetx = offsetx + width
            elseif self.indiNum == utf8.len(currentLine) and offsetx ~= ((self.font:getWidth(currentLine)) - self.width + 10) and self.font:getWidth(currentLine) + self.textoffsetx > self.width then
              self.offsetx = ((self.font:getWidth(currentLine)) - self.width + 10)
            end
          end
        end
      else
        if self.editable == false then
          return 
        end
        local text = self.lines[self.line]
        if utf8.len(text) >= self.limit and self.limit ~= 0 and self.allTextSelected == false then
          return 
        end
        if #self.usable > 0 then
          local found = false
          for k, v in ipairs(self.usable) do
            if v == key then
              found = true
            end
          end
          if found then
            return 
          end
        end
        if #self.unusable > 0 then
          local found = false
          for k, v in ipairs(self.unusable) do
            if v == key then
              found = true
            end
          end
          if found then
            return 
          end
        end
        if self.allTextSelected then
          self.allTextSelected = false
          self:clear()
          text = ""
        end
        if self.indiNum ~= 0 and self.indiNum ~= utf8.len(text) then
          text = self:addIntoTxt(key, self.indiNum)
          self.lines[self.line] = text
          self:moveIndicator(1)
        elseif self.indiNum == utf8.len(text) then
          text = text .. key
          self.lines[self.line] = text
          self:moveIndicator(1)
        elseif self.indiNum == 0 then
          text = self:addIntoTxt(key, self.indiNum)
          self.lines[self.line] = text
          self:moveIndicator(1)
        end
        text = self.lines[self.line]
        if self.multiline == false then
          local twidth = 0
          local cwidth = 0
          if self.masked then
            twidth = self.font:getWidth(utf8.gsub(text, ".", maskChar))
            cwidth = self.font:getWidth(utf8.gsub(key, ".", maskChar))
          else
            twidth = self.font:getWidth(text)
            cwidth = self.font:getWidth(key)
          end
          if (twidth + self.textoffsetx) >= (self.width - 1) then
            self.offsetx = self.offsetx + cwidth
          end
        end
      end
    end,
    getText = function(self)
      local text
      if self.multiline then
        for k, line in ipairs(self.lines) do
          text = text .. line
          if k ~= #self.lines then
            text = text .. "\n"
          end
        end
      else
        text = self.lines[1]
      end
      return text
    end,
    setText = function(self, text)
      text = tostring(text)
      text = utf8.gsub(text, string.char(9), self.tabreplacement)
      text = utf8.gsub(text, string.char(13), "")
      if self.multiline then
        return 
      else
        text = utf8.gsub(text, string.char(92) .. string.char(110), "")
        text = utf8.gsub(text, string.char(10), "")
        self.lines = {
          text
        }
        self.line = 1
        self.indiNum = utf8.len(text)
      end
    end,
    positionText = function(self)
      if self.multiline then
        return 
      else
        local box = self:getBoundingBox()
        self.textx = (box.x - self.offsetx) + self.textoffsetx
        self.texty = (box.y - self.offsety) + self.textoffsety
      end
    end,
    onKeyDown = function(self, key)
      local timer = love.timer
      if self.visible == false then
        return 
      end
      local time = timer.getTime()
      local keyDown = key
      if self:isCtrlDown() then
        if key == "a" then
          if self.multiline then
            if self.lines[1] ~= "" then
              self.allTextSelected = true
            end
          else
            self.allTextSelected = true
          end
        elseif key == "c" and self.allTextSelected then
          self:copy()
          self.allTextSelected = false
        elseif key == "x" and self.allTextSelected and self.editable then
          local text = self:getText()
          local system = love.system
          system.setClipboardText(text)
          self:setText("")
          return self:updateIndicator()
        elseif key == "v" and self.editable then
          return self:past()
        else
          return self:processKey(key, false)
        end
      else
        return self:processKey(key, false)
      end
    end,
    onTextInput = function(self, text)
      return self:processKey(text, true)
    end,
    drawIndicator = function(self)
      if self.showIndicator and self:getFocused() then
        local r, g, b, a = Graphics.getColor()
        Graphics.setColor(colors.black)
        Graphics.rectangle("fill", self.indicatorx, self.indicatory - 2.5, 1, self:getHeight() - 5)
        return Graphics.setColor(r, g, b, a)
      end
    end,
    drawText = function(self)
      local r, g, b, a = Graphics.getColor()
      local font = Graphics.getFont()
      Graphics.setFont(self.font)
      Graphics.setColor(colors.black)
      local str = self.lines[1]
      Graphics.print(str, math.floor(self.textx), math.floor(self.texty))
      Graphics.setColor(r, g, b, a)
      Graphics.setFont(font)
      return Graphics.setColor(r, g, b, a)
    end,
    drawBgBox = function(self)
      local bg = self:getBoundingBox()
      local r, g, b, a = Graphics.getColor()
      local color = colors.gray
      color[4] = color[4] or self.alpha
      Graphics.setLineStyle("smooth")
      Graphics.setColor(color)
      Graphics.rectangle("fill", bg.x - self.stroke, bg.y - self.stroke, self:getWidth() + self.stroke * 2, self:getHeight() + self.stroke * 2, self.brx, self.bry)
      return Graphics.setColor(r, g, b, a)
    end,
    drawTextBox = function(self)
      local bg = self:getBoundingBox()
      local r, g, b, a = Graphics.getColor()
      Graphics.setLineStyle("smooth")
      Graphics.setColor(colors.white)
      return Graphics.rectangle("fill", bg.x, bg.y, self:getWidth(), self:getHeight(), self.rx, self.ry)
    end,
    drawTextEffects = function(self)
      if self.allTextSelected then
        local w, h
        h = self.font:getHeight("a")
        if self.masked then
          w = self.font:getWidth(utf8.gsub(self.lines[self.line], ".", self.maskChar))
        else
          w = self.font:getWidth(self.lines[self.line])
        end
        Graphics.setColor(colors.lightskyblue)
        Graphics.rectangle("fill", self.textx, self.texty, w, h)
        return Graphics.setColor(colors.white)
      end
    end,
    draw = function(self)
      self:drawBgBox()
      Graphics.stencil(stencilFunc(self))
      Graphics.setStencilTest("greater", 0)
      self:positionText()
      self:updateIndicator()
      self:drawTextBox()
      self:drawTextEffects()
      self:drawIndicator()
      self:drawText()
      return Graphics.setStencilTest()
    end,
    update = function(self, dt)
      return self:indicatorBlink()
    end,
    getLines = function(self)
      return self.lines
    end,
    getText = function(self)
      if self.multiline == false then
        return self.lines[1]
      end
    end,
    getFont = function(self)
      return self.font
    end,
    setFontSize = function(self, size)
      Graphics = love.graphics
      self.font = Graphics.newFont(size)
    end,
    getFontSize = function(self)
      return self.font:getWidth(), self.font:getHeight()
    end,
    setCorners = function(self, rx, ry, brx, bry)
      self.rx = rx or self.rx
      self.ry = ry or self.ry
      self.brx = brx or self.brx
      self.bry = bry or self.bry
    end,
    copy = function(self)
      local sys = love.system
      local text = self:getText()
      return sys.setClipboardText(text)
    end,
    past = function(self)
      local sys = love.system
      local text = sys.getClipboardText()
      if self.limit > 0 then
        local curText = self:getText()
        local curLenght = utf8.len(curText)
        if curText == self.limit then
          return 
        else
          local inptLimit = self.limit - curLenght
          if utf8.len(text) > inptLimit then
            text = utf8.sub(text, 1, inptLimit)
          end
        end
      end
      local charCheck
      charCheck = function(a)
        if #self.usable > 0 then
          if tableHasValue(self.usable, a) == false then
            return ""
          end
        elseif #self.unusable > 0 then
          if tableHasValue(self.usable, a) then
            return ""
          end
        end
      end
      if self.allTextSelected then
        self:setText(text)
        self.allTextSelected = false
      else
        if self.multiline then
          return 
        else
          text = utf8.gsub(text, string.char(10), " ")
          text = utf8.gsub(text, string.char(13), " ")
          text = utf8.gsub(text, string.char(9), self.tabreplacement)
          local lenght = utf8.len(text)
          local linetxt = self.lines[1]
          local p1 = utf8.sub(linetxt, 1, self.indiNum)
          local p2 = utf8.sub(linetxt, self.indiNum + 1)
          local new = p1 .. text .. p2
          self.lines[1] = new
          self.indiNum = self.indiNum + lenght
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, placeHolder)
      _class_0.__parent.__init(self, "Box", "TextInput")
      local t = self:getTheme()
      local common = t.common
      local style = t.textField
      self.marginCorner = style.marginCorner
      self.textAreaColor = style.textAreaColor
      self.textColor = style.textColor
      self.strokeColor = t.colors.strokeColor
      self.stroke = common.stroke
      self.rx = style.rx
      self.ry = style.ry
      self.brx = style.rx
      self.bry = style.ry
      self.keyDown = "none"
      self.limit = 0
      self.line = 1
      self.lines = {
        ""
      }
      self.placeHolder = placeHolder
      self.showIndicator = true
      self.focus = false
      self.multiline = false
      self.allTextSelected = false
      self.editable = true
      self.tabreplacement = "        "
      self.indiNum = 0
      self.indincatortime = 0
      self.maskChar = '*'
      self.indicatorx = 0
      self.indicatory = 0
      self.visible = true
      self.offsetx = 0
      self.offsety = 0
      self.textoffsetx = 5
      self.textoffsety = 5
      self.textx = 0
      self.texty = 0
      self.usable = { }
      self.unusable = { }
      self.textoffsetx = 5
      self.width = 150
      self.height = 25
      self.font = love.graphics.newFont(12)
      self:setEnabled(true)
      self:setUpdateWhenFocused(true)
      self:on("UI_KEY_DOWN", self.onKeyDown, self)
      self:on("UI_TEXT_INPUT", self.onTextInput, self)
      self:on("UI_DRAW", self.draw, self)
      self:on("UI_UPDATE", self.update, self)
      self:on("UI_MOUSE_ENTER", self.onMouseEnter, self)
      self:on("UI_MOUSE_LEAVE", self.onMouseLeave, self)
      self:on("UI_MOUSE_DOWN", self.onMouseDown, self)
      return self:on("UI_MOUSE_UP", self.onMouseUp, self)
    end,
    __base = _base_0,
    __name = "TextInput",
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
  self:include(Mixins.KeyboardMixins)
  self:include(Mixins.EventMixins)
  self:include(Mixins.ThemeMixins)
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  TextInput = _class_0
  return _class_0
end
