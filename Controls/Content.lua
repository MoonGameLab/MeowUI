local Graphics = love.graphics
local MeowUI = MeowUI
local Control = MeowUI.Control
local ScrollBar = assert(require(MeowUI.c_cwd .. "ScrollBar"))
local Mixins = assert(require(MeowUI.root .. "Controls.mx"))
local mouse = love.mouse
local drawRect
drawRect = function(self)
  local box = self:getBoundingBox()
  local r, g, b, a = Graphics.getColor()
  local boxW, boxH = box:getWidth(), box:getHeight()
  local x, y = box:getX(), box:getY()
  local color
  color = self.backgroundColor
  color[4] = color[4] or self.alpha
  Graphics.setColor(color)
  Graphics.rectangle("fill", x, y, boxW, boxH, self.rx, self.ry)
  if self.enabled and self.stroke > 0 then
    local oldLineWidth = Graphics.getLineWidth()
    Graphics.setLineWidth(self.stroke)
    Graphics.setLineStyle("rough")
    Graphics.setColor(self.strokeColor)
    Graphics.rectangle("line", x, y, boxW, boxH, self.rx, self.ry)
    Graphics.setLineWidth(oldLineWidth)
  end
  return Graphics.setColor(r, g, b, a)
end
local Slide
do
  local _class_0
  local _parent_0 = Control
  local _base_0 = {
    getExtend = function(self)
      return self.extend
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, type, idx, parent, extend)
      _class_0.__parent.__init(self, type, "Slide" .. idx)
      self:setEnabled(true)
      self.extend = extend
      if self.extend then
        return self:on("UI_UPDATE", parent.onUpdate, parent)
      else
        return self:on("UI_UPDATE", self.onUpdate, self)
      end
    end,
    __base = _base_0,
    __name = "Slide",
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
  self:include(Mixins.EventMixins)
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Slide = _class_0
end
local Content
do
  local _class_0
  local _attachSlide, _detachSlide, v_barSide, h_barSide
  local _parent_0 = Control
  local _base_0 = {
    onMouseDown = function(self, x, y)
      if self.Click then
        self:Click()
      end
      self.isPressed = true
      if self.dragParent == false then
        self.offsetX = x - self:getBoundingBox():getX()
        self.offsetY = y - self:getBoundingBox():getY()
      else
        local parent
        parent = self
        while parent.getDragParent and parent:getDragParent() do
          parent = parent:getParent()
        end
        if parent.getExtend then
          if parent:getExtend() then
            self.offsetX = x - parent:getParent():getBoundingBox():getX()
            self.offsetY = y - parent:getParent():getBoundingBox():getY()
          else
            self.offsetX = x - parent:getBoundingBox():getX()
            self.offsetY = y - parent:getBoundingBox():getY()
          end
        end
      end
    end,
    onMouseUp = function(self, x, y)
      if self.aClick then
        self:aClick()
      end
      self.isPressed = false
    end,
    addSlide = function(self, attach, extend, width, height)
      if width == nil then
        width = nil
      end
      if height == nil then
        height = nil
      end
      local slideIdx = self.slidesIdx
      self.slides[self.slidesIdx] = Slide("Box", self.slidesIdx, self, extend)
      self.slides[self.slidesIdx].autoSize = true
      if self:getLabel() then
        self.slides[self.slidesIdx]:setLabel(self:getLabel())
      end
      if width then
        self.slides[self.slidesIdx].autoSize = false
        self.slides[self.slidesIdx]:setWidth(width)
      else
        self.slides[self.slidesIdx]:setWidth(self:getWidth())
      end
      if height then
        self.slides[self.slidesIdx].autoSize = false
        self.slides[self.slidesIdx]:setHeight(height)
      else
        self.slides[self.slidesIdx]:setHeight(self:getHeight())
      end
      self.slidesIdx = self.slidesIdx + 1
      if attach then
        if self.currentSlideIdx then
          _detachSlide(self, self.slides[self.currentSlideIdx])
        end
        _attachSlide(self, self.slides[slideIdx])
        self.currentSlideIdx = slideIdx
      end
      return slideIdx
    end,
    setBackgroundColor = function(self, color)
      self.backgroundColor = color
    end,
    setStroke = function(self, s)
      self.stroke = s
    end,
    onVBarScroll = function(self, ratio)
      return self:setY(-ratio * self:getHeight())
    end,
    attachScrollBarV = function(self, barType)
      if self.vBar ~= nil then
        return 
      end
      self.vBar = ScrollBar(barType)
      self.vBar:setDir("vertical")
      self:vBarLeft()
      self:addChild(self.vBar, self.scrollBarDepth)
      self.vBar:on("UI_ON_SCROLL", self.onVBarScroll, self.vBar:getParent())
      return self.vBar:setHeight(self:getHeight() - (self.ry + self.rx))
    end,
    attachScrollBarH = function(self, barType)
      if self.hBar ~= nil then
        return 
      end
      self.hBar = ScrollBar(barType)
      self.hBar:setDir("horizontal")
      self:hBarTop()
      self:addChild(self.hBar, self.scrollBarDepth)
      self.hBar:on("UI_ON_SCROLL", self.onHBarScroll, self.hBar:getParent())
      return self.hBar:setWidth(self:getWidth() - (self.ry + self.rx))
    end,
    detachScrollBarV = function(self)
      if self.vBar then
        self:removeChild(self.vBar.id)
        self.vBar = nil
      end
    end,
    detachScrollBarH = function(self)
      if self.hBar then
        self:removeChild(self.hBar.id)
        self.hBar = nil
      end
    end,
    setSize = function(self, width, height)
      _class_0.__parent.__base.setSize(self, width, height)
      for i = 1, #self.slides do
        if self.slides[i].autoSize then
          self.slides[i]:setSize(width, height)
        end
      end
      if self.vBar then
        self.vBar:setHeight(height - (self.ry + self.rx))
        local _exp_0 = v_barSide
        if "right" == _exp_0 then
          self:vBarRight()
        elseif "left" == _exp_0 then
          self:vBarLeft()
        end
      end
      if self.hBar then
        self.hBar:setWidth(width - (self.ry + self.rx))
        local _exp_0 = h_barSide
        if "bottom" == _exp_0 then
          return self:hBarBot()
        elseif "top" == _exp_0 then
          return self:hBarTop()
        end
      end
    end,
    setWidth = function(self, width)
      _class_0.__parent.__base.setWidth(self, width)
      for i = 1, #self.slides do
        if self.slides[i].autoSize then
          self.slides[i]:setWidth(width)
        end
      end
      if self.hBar then
        self.hBar:setWidth(width - (self.ry + self.rx))
        local _exp_0 = h_barSide
        if "bottom" == _exp_0 then
          return self:hBarBot()
        elseif "top" == _exp_0 then
          return self:hBarTop()
        end
      end
    end,
    setHeight = function(self, height)
      _class_0.__parent.__base.setHeight(self, height)
      for i = 1, #self.slides do
        if self.slides[i].autoSize then
          self.slides[i]:setHeight(height)
        end
      end
      if self.vBar then
        self.vBar:setHeight(height - (self.ry + self.rx))
        local _exp_0 = v_barSide
        if "right" == _exp_0 then
          return self:vBarRight()
        elseif "left" == _exp_0 then
          return self:vBarLeft()
        end
      end
    end,
    addSlideChild = function(self, slideIdx, child, depth)
      if self.slides[slideIdx] == nil then
        return 
      end
      return self.slides[slideIdx]:addChild(child, depth)
    end,
    removeSlideChild = function(self, slideIdx, child)
      if self.slides[slideIdx] == nil then
        return 
      end
      return self.slides[slideIdx]:removeChild(child.id)
    end,
    attachSlide = function(self, idx)
      if self.currentSlideIdx == idx then
        return 
      end
      if self.currentSlideIdx then
        _detachSlide(self, self.slides[self.currentSlideIdx])
      end
      _attachSlide(self, self.slides[idx])
      self.currentSlideIdx = idx
    end,
    addContentChild = function(self, child)
      return self:addChild(child, self.contentDepth)
    end,
    removeContentChild = function(self, id)
      return self:removeChild(id)
    end,
    getNumberOfSlides = function(self)
      return self.slidesIdx - 1
    end,
    getSlide = function(self, idx)
      return self.slides[idx]
    end,
    next = function(self)
      local nSlides = self:getNumberOfSlides()
      local nCurrent = self.currentSlideIdx
      if nCurrent == nSlides then
        return self:attachSlide(1)
      else
        return self:attachSlide(nCurrent + 1)
      end
    end,
    vBarLeft = function(self)
      if self.vBar then
        v_barSide = "left"
        return self.vBar:setPosition(self.rx, self.ry)
      end
    end,
    vBarRight = function(self)
      if self.vBar then
        v_barSide = "right"
        return self.vBar:setPosition((self:getWidth() - self.vBar:getWidth()) - self.rx, self.ry)
      end
    end,
    hBarBot = function(self)
      if self.hBar then
        h_barSide = "bottom"
        return self.hBar:setPosition(self.rx, (self:getHeight() - self.hBar:getHeight()) - self.rx)
      end
    end,
    hBarTop = function(self)
      if self.hBar then
        h_barSide = "top"
        return self.hBar:setPosition(self.rx, self.rx)
      end
    end,
    previous = function(self)
      local nSlides = self:getNumberOfSlides()
      local nCurrent = self.currentSlideIdx
      if nCurrent == 1 then
        return self:attachSlide(nSlides)
      else
        return self:attachSlide(nCurrent - 1)
      end
    end,
    getVBar = function(self)
      if self.vBar then
        return self.vBar
      end
      return nil
    end,
    onWheelMove = function(self, x, y)
      local slide = self:getSlide(self.currentSlideIdx)
      if x ~= 0 and self:getWidth() > slide:getWidth() then
        return false
      end
      if y ~= 0 and self:getHeight() > slide:getHeight() then
        return false
      end
      if y ~= 0 then
        if self.vBar then
          local offsetR = y / slide:getHeight() * self.scrollSpeed
          if (slide:getHeight() - self:getHeight()) ~= 0 then
            self.vBar:setBarPos(self.vBar:getBarPos() - offsetR)
          end
        end
        if self.hBar then
          local offsetR = y / slide:getWidth() * self.scrollSpeed
          if (slide:getWidth() - self:getWidth()) ~= 0 then
            self.hBar:setBarPos(self.hBar:getBarPos() - offsetR)
          end
        end
      end
      return true
    end,
    onUpdate = function(self, dt)
      if self.isPressed and self.drag then
        local mx, my = mouse.getPosition()
        local parent
        parent = self:getParent()
        if self.dragParent == false then
          return self:setPosition(mx - self.offsetX, my - self.offsetY)
        else
          while parent.getExtend and parent:getExtend() do
            parent = parent:getParent()
          end
          return parent:setPosition(mx - self.offsetX, my - self.offsetY)
        end
      end
    end,
    setDrag = function(self, bool, dragParent)
      self.drag = bool
      self.dragParent = dragParent or self.dragParent
    end,
    setDragParent = function(self, bool)
      self.dragParent = bool
    end,
    getDragParent = function(self)
      return self.dragParent
    end,
    onVBarScroll = function(self, ratio)
      local slide = self:getSlide(self.currentSlideIdx)
      local offset = -ratio * (slide:getHeight() - self:getHeight())
      return slide:setY(offset)
    end,
    onHBarScroll = function(self, ratio)
      local slide = self:getSlide(self.currentSlideIdx)
      local offset = -ratio * (slide:getWidth() - self:getWidth())
      return slide:setX(offset)
    end,
    getCurrentSlideIdx = function(self)
      return self.currentSlideIdx
    end,
    getCurrentSlide = function(self)
      return self.slides[self.currentSlideIdx]
    end,
    destruct = function(self, root)
      self:detachScrollBarV()
      self:detachScrollBarH()
      for i, slide in ipairs(self.slides) do
        _detachSlide(self, slide)
      end
      self.slides = nil
      return root:removeChild(self:getId())
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, label, vbar, hbar, attachSlides)
      if attachSlides == nil then
        attachSlides = true
      end
      _class_0.__parent.__init(self, "Box", "Content")
      self:setLabel(label)
      local t = self:getTheme()
      local colors = t.colors
      local common = t.common
      self.stroke = common.stroke
      self.backgroundColor = t.content.backgroundColorFocuse
      self.backgroundColorUnFocus = t.content.backgroundColorUnFocuse
      self.focuseResponsive = false
      self.strokeColor = colors.strokeColor
      self:setClip(true)
      self.slides = { }
      self.currentSlide = nil
      self.slidesIdx = 1
      self.alpha = 1
      local style = t.content
      self.width = style.width
      self.height = style.height
      self.rx = style.rx
      self.ry = style.ry
      self.vBar = nil
      self.hBar = nil
      self.scrollBarDepth = 9999
      self.contentDepth = 9998
      self.scrollSpeed = 9
      self.drag = false
      self.dragParent = false
      if attachSlides then
        self:addSlide(true, true)
        self.onDraw = drawRect
      end
      self:on("UI_DRAW", self.onDraw, self)
      self:on("UI_MOUSE_DOWN", self.onMouseDown, self)
      self:on("UI_MOUSE_UP", self.onMouseUp, self)
      self:on("UI_UPDATE", self.onUpdate, self)
      self:on("UI_WHELL_MOVE", self.onWheelMove, self)
      if vbar then
        self:attachScrollBarV("Box")
      end
      if hbar then
        return self:attachScrollBarH("Box")
      end
    end,
    __base = _base_0,
    __name = "Content",
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
  self:include(Mixins.ThemeMixins)
  self:include(Mixins.EventMixins)
  self:include(Mixins.ColorMixins)
  _attachSlide = function(self, slide)
    return self:addChild(slide, 1)
  end
  _detachSlide = function(self, slide)
    return self:removeChild(slide.id)
  end
  v_barSide = "left"
  h_barSide = "bottom"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Content = _class_0
  return _class_0
end
