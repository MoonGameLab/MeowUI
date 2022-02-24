Graphics = love.graphics
MeowUI = MeowUI
Control  = MeowUI.Control
Utils  = MeowUI.Utils
ScrollBar = assert require MeowUI.c_cwd .. "ScrollBar"


addChild = (child, depth) =>
  @content\addChild child, depth

removeChild =  (id) =>
  @content\removeChild id

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

drawCircle = =>
  box = @getBoundingBox!
  r, g, b, a = Graphics.getColor!
  boxR = box\getRadius!
  x, y = box\getX!, box\getY!
  color = @backgroundColor
  color[4] = color[4] or @alpha

  Graphics.setColor color
  Graphics.circle 'fill', x, y, boxR

  -- border
  if @enabled and @stroke > 0
    oldLineWidth = Graphics.getLineWidth!
    Graphics.setLineWidth @stroke
    Graphics.setLineStyle "rough" -- could be dynamic
    Graphics.setColor @strokeColor
    Graphics.circle "line", x, y, boxR
    Graphics.setLineWidth oldLineWidth
  
  Graphics.setColor r, g, b, a

drawPoly = =>
  box = @getBoundingBox!
  r, g, b, a = Graphics.getColor!
  color = @backgroundColor
  color[4] = color[4] or @alpha

  Graphics.setColor color
  Graphics.polygon 'fill', box\getVertices!
  
  if @enabled and @stroke > 0
    oldLineWidth = Graphics.getLineWidth!
    Graphics.setLineWidth @stroke
    Graphics.setLineStyle "rough" -- could be dynamic
    Graphics.setColor @strokeColor
    Graphics.polygon "line", box\getVertices!
    Graphics.setLineWidth oldLineWidth
    Graphics.setColor r, g, b, a
  
  
  Graphics.setColor r, g, b, a

class Content extends Control
  new: (type) =>
    -- Bounding box type
    super type, "Content"

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
    @slidesNum = 1
    @slides[@slidesNum] = Control type, "Content_slide_" .. @slidesNum
    @content = @slides[@slidesNum]

    switch type
      when "Box"
        @onDraw = drawRect
        style = t.content
        @width  = style.width
        @height = style.height
        @rx = style.rx
        @ry = style.ry
        @alpha = 1
        @content\setSize @width, @height
        Utils.Overrides @, @content, Control.boxOverrides
      when "Circle"
        @onDraw = drawCircle
        style = t.content
        @radius  = style.radius
        @alpha = 1
        @content\setRadius @radius
      when "Polygon"
        @onDraw = drawPoly
        style = t.content
        @radius  = style.radius
        @alpha = 1
        @content\setRadius @radius

    @addChild @content
    
    @addChild = addChild
    @removeChild = removeChild

    @on "UI_DRAW", @onDraw, @

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
    @addChild @vBar
    @bvBarar\on "UI_ON_SCROLL", @onVBarScroll, @bar\getParent!



    
