Graphics = love.graphics
MeowUI = MeowUI
Control  = MeowUI.Control
ScrollBar = assert require MeowUI.c_cwd .. "ScrollBar"
Mixins   = assert require MeowUI.root .. "Controls.mx"
mouse = love.mouse

drawRect = =>
  box = @getBoundingBox!
  r, g, b, a = Graphics.getColor!
  boxW, boxH = box\getWidth!, box\getHeight!
  x, y = box\getX!, box\getY!
  local color

  color = @backgroundColor

  color[4] = color[4] or @alpha

  Graphics.setColor color
  Graphics.rectangle "fill", x, y, boxW, boxH, @rx, @ry
  -- border
  if @enabled and @stroke > 0
    oldLineWidth = Graphics.getLineWidth!
    Graphics.setLineWidth @stroke
    Graphics.setLineStyle "rough"
    Graphics.setColor @strokeColor
    Graphics.rectangle "line", x, y, boxW, boxH, @rx, @ry
    Graphics.setLineWidth oldLineWidth

  Graphics.setColor r, g, b, a


class Slide extends Control
  
  @include Mixins.EventMixins

  new: (type, idx, parent, extend) =>
    super type, "Slide"..idx

    @setEnabled true
    @extend = extend

    -- Events
    if @extend
      -- @on "UI_MOUSE_DOWN", parent.onMouseDown, parent
      -- @on "UI_MOUSE_UP", parent.onMouseUp, parent
      @on "UI_UPDATE", parent.onUpdate, parent
    else
      -- @on "UI_MOUSE_DOWN", @.onMouseDown, @
      -- @on "UI_MOUSE_UP", @.onMouseUp, @
      @on "UI_UPDATE", @.onUpdate, @


  getExtend: =>
    @extend
    
class Content extends Control

  @include Mixins.ThemeMixins
  @include Mixins.EventMixins
  @include Mixins.ColorMixins

  -- @local
  _attachSlide = (self, slide) ->
    @addChild slide, 1

  -- @local
  _detachSlide = (self, slide) ->
    @removeChild slide.id

  -- @local
  v_barSide = "left"

  -- @local
  h_barSide = "bottom"

  new: (label, vbar, hbar, attachSlides = true) =>
    -- Bounding box type
    super "Box", "Content"

    @setLabel label

    -- colors
    t = @getTheme!
    colors = t.colors
    common = t.common
    @stroke = common.stroke
    @backgroundColor = t.content.backgroundColorFocuse
    @backgroundColorUnFocus = t.content.backgroundColorUnFocuse
    @focuseResponsive = false

    @strokeColor = colors.strokeColor

    @setClip true

    @slides = {}
    @currentSlide = nil
    @slidesIdx = 1


    @alpha = 1

    style = t.content
    @width  = style.width
    @height = style.height
    @rx = style.rx
    @ry = style.ry

    @vBar = nil
    @hBar = nil
    @scrollBarDepth = 9999
    @contentDepth = 9998
    @scrollSpeed = 9
    @drag = false
    @dragParent = false


    if attachSlides
      @addSlide true, true
      @onDraw = drawRect -- FIX

    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @
    @on "UI_UPDATE", @onUpdate, @
    @on "UI_WHELL_MOVE", @onWheelMove, @

    if vbar then @attachScrollBarV "Box"
    if hbar then @attachScrollBarH "Box"


  onMouseDown: (x, y) =>
    if @Click
      @Click!
    @isPressed = true
    if @dragParent == false
      @offsetX = x - @getBoundingBox!\getX!
      @offsetY = y - @getBoundingBox!\getY!
    else
      local parent
      parent = @

      while parent.getDragParent and parent\getDragParent!
        parent = parent\getParent!
    
      if parent.getExtend
        if parent\getExtend!
          @offsetX = x - parent\getParent!\getBoundingBox!\getX!
          @offsetY = y - parent\getParent!\getBoundingBox!\getY!
        else
          @offsetX = x - parent\getBoundingBox!\getX!
          @offsetY = y - parent\getBoundingBox!\getY!

  onMouseUp: (x, y) =>
    if @aClick
      @aClick!
    @isPressed = false

  addSlide: (attach, extend, width = nil, height = nil) =>
    slideIdx = @slidesIdx
    @slides[@slidesIdx] = Slide "Box", @slidesIdx, @, extend
    @slides[@slidesIdx].autoSize = true

    if @getLabel!
      @slides[@slidesIdx]\setLabel @getLabel!

    if width
      @slides[@slidesIdx].autoSize = false
      @slides[@slidesIdx]\setWidth width
    else
      @slides[@slidesIdx]\setWidth @getWidth!

    if height
      @slides[@slidesIdx].autoSize = false
      @slides[@slidesIdx]\setHeight height
    else
      @slides[@slidesIdx]\setHeight @getHeight!

      

    @slidesIdx += 1
    if attach
      if @currentSlideIdx then _detachSlide @, @slides[@currentSlideIdx]
      _attachSlide @, @slides[slideIdx]
      @currentSlideIdx = slideIdx
    slideIdx

  setBackgroundColor: (color) =>
    @backgroundColor = color

  setStroke: (s) =>
    @stroke = s

  onVBarScroll: (ratio) =>
    @setY -ratio * @getHeight!

  attachScrollBarV: (barType) =>
    if @vBar ~= nil then return
    @vBar = ScrollBar barType
    @vBar\setDir "vertical"
    @vBarLeft!
    @addChild @vBar, @scrollBarDepth
    @vBar\on "UI_ON_SCROLL", @onVBarScroll, @vBar\getParent!
    @vBar\setHeight @getHeight! - (@ry + @rx)

  attachScrollBarH: (barType) =>
    if @hBar ~= nil then return
    @hBar = ScrollBar barType
    @hBar\setDir "horizontal"
    @hBarTop!
    @addChild @hBar, @scrollBarDepth

    @hBar\on "UI_ON_SCROLL", @onHBarScroll, @hBar\getParent!
    @hBar\setWidth @getWidth! - (@ry + @rx)


  detachScrollBarV: =>
    if @vBar
      @removeChild @vBar.id
      @vBar = nil

  detachScrollBarH: =>
    if @hBar
      @removeChild @hBar.id
      @hBar = nil

  setSize: (width, height) =>
    super width, height

    for i = 1, #@slides
      if @slides[i].autoSize then @slides[i]\setSize width, height

    if @vBar
      @vBar\setHeight height - (@ry + @rx)
      switch v_barSide
        when "right" then @vBarRight!
        when "left" then @vBarLeft!

    if @hBar
      @hBar\setWidth width - (@ry + @rx)
      switch h_barSide
        when "bottom" then @hBarBot!
        when "top" then @hBarTop!


  setWidth: (width) =>
    super width

    for i = 1, #@slides
      if @slides[i].autoSize then @slides[i]\setWidth width

    if @hBar
      @hBar\setWidth width - (@ry + @rx)
      switch h_barSide
        when "bottom" then @hBarBot!
        when "top" then @hBarTop!

  setHeight: (height) =>
    super height

    for i = 1, #@slides
      if @slides[i].autoSize then @slides[i]\setHeight height

    if @vBar
      @vBar\setHeight height - (@ry + @rx)
      switch v_barSide
        when "right" then @vBarRight!
        when "left" then @vBarLeft!

  addSlideChild: (slideIdx, child, depth) =>
    if @slides[slideIdx] == nil then return
    @slides[slideIdx]\addChild child, depth

  removeSlideChild: (slideIdx, child) =>
    if @slides[slideIdx] == nil then return
    @slides[slideIdx]\removeChild child.id

  attachSlide: (idx) =>
    if @currentSlideIdx == idx then return
    if @currentSlideIdx then _detachSlide @, @slides[@currentSlideIdx]
    _attachSlide @, @slides[idx]
    @currentSlideIdx = idx

  addContentChild: (child) =>
    @addChild child, @contentDepth

  removeContentChild: (id) =>
    @removeChild id

  getNumberOfSlides: =>
    @slidesIdx - 1

  getSlide: (idx) =>
    @slides[idx]

  next: =>
    nSlides = @getNumberOfSlides!
    nCurrent = @currentSlideIdx

    if nCurrent == nSlides
      @attachSlide 1
    else
      @attachSlide nCurrent + 1

  vBarLeft: =>
    if @vBar
      v_barSide = "left"
      @vBar\setPosition @rx, @ry

  vBarRight: =>
    if @vBar
      v_barSide = "right"
      @vBar\setPosition (@getWidth! - @vBar\getWidth!) - @rx, @ry

  hBarBot: =>
    if @hBar
      h_barSide = "bottom"
      @hBar\setPosition @rx, (@getHeight! - @hBar\getHeight!) - @rx

  hBarTop: =>
      if @hBar
        h_barSide = "top"
        @hBar\setPosition @rx, @rx

  previous: =>
    nSlides = @getNumberOfSlides!
    nCurrent = @currentSlideIdx

    if nCurrent == 1 then @attachSlide nSlides
    else @attachSlide nCurrent - 1


  getVBar: =>
    if @vBar then return @vBar
    nil

  onWheelMove: (x, y) =>
    slide = @getSlide @currentSlideIdx

    if x ~= 0 and @getWidth! > slide\getWidth! then return false
    if y ~= 0 and @getHeight! > slide\getHeight! then return false

    if y ~= 0
      if @vBar
        offsetR = y / slide\getHeight! * @scrollSpeed
        if (slide\getHeight! - @getHeight!) ~= 0 then @vBar\setBarPos @vBar\getBarPos! - offsetR

      if @hBar
        offsetR = y / slide\getWidth! * @scrollSpeed
        if (slide\getWidth! - @getWidth!) ~= 0 then @hBar\setBarPos @hBar\getBarPos! - offsetR

    true

  onUpdate: (dt) =>
    if @isPressed and @drag
      mx, my = mouse.getPosition!
      local parent
      parent = @getParent!

      if @dragParent == false
        @setPosition mx - @offsetX, my - @offsetY
      else
        while parent.getExtend and parent\getExtend!
          parent = parent\getParent!
        parent\setPosition mx - @offsetX, my - @offsetY

  setDrag: (bool, dragParent) =>
    @drag = bool
    @dragParent = dragParent or @dragParent

  setDragParent: (bool) =>
    @dragParent = bool

  getDragParent: =>
    @dragParent -- TODO : should be mixin since other controls can be dragged.

  onVBarScroll: (ratio) =>
    slide = @getSlide @currentSlideIdx
    offset = -ratio * (slide\getHeight! - @getHeight!)
    slide\setY offset

  onHBarScroll: (ratio) =>
    slide = @getSlide @currentSlideIdx
    offset = -ratio * (slide\getWidth! - @getWidth!)
    slide\setX offset

  getCurrentSlideIdx: =>
    @currentSlideIdx

  getCurrentSlide: =>
    @slides[@currentSlideIdx]

  destruct: (root) =>
    @detachScrollBarV!
    @detachScrollBarH!
    
    for i, slide in ipairs @slides
      _detachSlide @, slide
    
    @slides = nil

    root\removeChild @getId!
