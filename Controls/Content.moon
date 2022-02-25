Graphics = love.graphics
MeowUI = MeowUI
Control  = MeowUI.Control
Utils  = MeowUI.Utils
ScrollBar = assert require MeowUI.c_cwd .. "ScrollBar"


drawRect = =>
  box = @getBoundingBox!
  r, g, b, a = Graphics.getColor!
  boxW, boxH = box\getWidth!, box\getHeight!
  x, y = box\getX!, box\getY!
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

class Content extends Control

  -- @local
  _attachSlide = (self, slide) ->
    @addChild slide, 1

  -- @local
  _detachSlide = (self, slide) ->
    @removeChild slide.id


  new: =>
    -- Bounding box type
    super "Box", "Content"

    -- colors
    t = assert(require(MeowUI.root .. "Controls.Style"))[MeowUI.theme]
    colors = t.colors
    common = t.common
    @stroke = common.stroke
    @backgroundColor = colors.backgroundColor
    @strokeColor = colors.strokeColor
    @vBar = nil
    @hBar = nil

    @setClip true

    @slides = {}
    @currentSlide = nil
    @slidesIdx = 1
  

    @alpha = 1

    @onDraw = drawRect
    style = t.content
    @width  = style.width
    @height = style.height
    @rx = style.rx
    @ry = style.ry

    @on "UI_DRAW", @onDraw, @

    @attachScrollBarV "Box"
    @addSlide true


  addSlide: (attach) =>
    slideIdx = @slidesIdx
    @slides[@slidesIdx] = Control "Box", "content_slide_" .. @slidesIdx
    Utils.Overrides @, @slides[@slidesIdx], Control.boxOverrides
    @slides[@slidesIdx]\setSize @getWidth!, @getHeight!
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
    @setY - ratio * @getHeight!

  attachScrollBarV: (barType) =>
    if @vBar ~= nil then return
    @vBar = ScrollBar barType
    @vBar\setDir "vertical"
    --@addChild @vBar, 99999
    --@bvBarar\on "UI_ON_SCROLL", @onVBarScroll, @bar\getParent!

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


  getNumberOfSlides: =>
    @slidesIdx - 1

  getSlide: (idx) =>
    @slides[idx]

  next: =>
    nSlides = @getNumberOfSlides!
    nCurrent = @currentSlideIdx

    if nCurrent == nSlides then @attachSlide 1
    else @attachSlide nCurrent + 1


  previous: =>
    nSlides = @getNumberOfSlides!
    nCurrent = @currentSlideIdx

    if nCurrent == 1 then @attachSlide nSlides
    else @attachSlide nCurrent - 1
