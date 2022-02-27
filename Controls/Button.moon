Graphics = love.graphics
MeowUI = MeowUI
Control = MeowUI.Control

stencileFuncCircle = =>
  box = @getBoundingBox!
  -> Graphics.circle "fill", box.x, box.y, @bgImage\getWidth! / 2

stencileFuncPoly = =>
  box = @getBoundingBox!
  -> Graphics.polygon "fill", box\getVertices!

currentColor = =>
  local color
  if @isPressed
    color = @downColor
    color[4] = (color[4] ~= nil) and color[4] or @alphaDown
  elseif @isHovred
    color = @hoverColor
    color[4] = (color[4] ~= nil) and color[4] or @alphaHover
  elseif @enabled
    color = @upColor
    color[4] = (color[4] ~= nil) and color[4] or @alphaEnable
  else
    color = @disabledColor
    color[4] = (color[4] ~= nil) and color[4] or @alphaDisable

  color


drawPoly = =>
  box = @getBoundingBox!
  r, g, b, a = Graphics.getColor!
  color = currentColor self

  -- Button body
  if @bgImage
    if not @isPressed
      Graphics.setColor r, g, b, a
    if @isHovred
      Graphics.setColor color

    sf = stencileFuncPoly self
    Graphics.stencil sf, "increment", 1, true
    Graphics.setStencilTest "greater", 1
    x, y = box\getPosition!
    Graphics.draw @bgImage, x - @bgImage\getWidth!/2 , y - @bgImage\getHeight!/2
    love.graphics.polygon "line", box\getVertices!
    Graphics.setStencilTest!
    Graphics.setColor r, g, b, a
  else
    Graphics.setColor color
    Graphics.polygon 'fill', box\getVertices!
    Graphics.setColor r, g, b, a

  -- border
  if @enabled and @stroke > 0
    oldLineWidth = Graphics.getLineWidth!
    Graphics.setLineWidth @stroke
    Graphics.setLineStyle "rough" -- could be dynamic
    Graphics.setColor @strokeColor
    Graphics.polygon "line", box\getVertices!
    Graphics.setLineWidth oldLineWidth
    Graphics.setColor r, g, b, a

  -- Text
  if @textDrawable
    Graphics.setColor @fontColor
    textW, textH = @textDrawable\getWidth!, @textDrawable\getHeight!
    x = @x - textW / 2
    y = @y - textH / 2
    Graphics.draw @textDrawable, x, y

  Graphics.setColor r, g, b, a

drawCircle = =>
  box = @getBoundingBox!
  r, g, b, a = Graphics.getColor!
  boxR = box\getRadius!
  color = currentColor self

  -- Button body
  if @bgImage
    if not @isPressed
      Graphics.setColor r, g, b, a
    if @isHovred
      Graphics.setColor color

    sf = stencileFuncCircle self

    Graphics.stencil sf, "increment", 1, true
    Graphics.setStencilTest "greater", 1
    Graphics.draw @bgImage, ((box.x - @bgImageBx) - @radius * @scaleX),
      ((box.y - @bgImageBx) - @radius * @scaleY)
    Graphics.setStencilTest!
    Graphics.setColor r, g, b, a
  else
    Graphics.setColor color
    Graphics.circle 'fill', box.x, box.y, boxR
    Graphics.setColor r, g, b, a

  -- border
  if @enabled and @stroke > 0
    oldLineWidth = Graphics.getLineWidth!
    Graphics.setLineWidth @stroke
    Graphics.setLineStyle "rough" -- could be dynamic
    Graphics.setColor @strokeColor
    Graphics.circle "line", box.x, box.y, boxR
    Graphics.setLineWidth oldLineWidth
    Graphics.setColor r, g, b, a

  -- Text
  if @textDrawable
    Graphics.setColor @fontColor
    textW, textH = @textDrawable\getWidth!, @textDrawable\getHeight!
    x = box.x - textW / 2
    y = box.y - textH / 2
    Graphics.draw @textDrawable, x, y

  Graphics.setColor r, g, b, a

drawRect = =>
    box = @getBoundingBox!
    r, g, b, a = Graphics.getColor!
    boxW, boxH = box\getWidth!, box\getHeight!
    color = currentColor self

    -- Button body
    if @bgImage
      imageW, imageH = @bgImage\getWidth!, @bgImage\getHeight!
      if not @isPressed
        Graphics.setColor r, g, b, a
      if @isHovred
        Graphics.setColor color

      Graphics.draw @bgImage, box.x, box.y
      x = box.x + ((imageW - boxW) / 2)
      y = box.y + ((imageH - boxH) / 2)
      box.x, box.y = x + (@bgImageBx/2), y + (@bgImageBy/2)

      Graphics.setColor r, g, b, a
    else
      Graphics.setColor color
      Graphics.rectangle "fill", box.x, box.y, boxW, boxH, @rx, @ry
      Graphics.setColor r, g, b, a

    -- border
    if @enabled and @stroke > 0
      oldLineWidth = Graphics.getLineWidth!
      Graphics.setLineWidth @stroke
      Graphics.setLineStyle "rough" -- could be dynamic
      Graphics.setColor @strokeColor
      Graphics.rectangle "line", box.x, box.y, boxW, boxH, @rx, @ry
      Graphics.setLineWidth oldLineWidth

    -- Text
    if @textDrawable
      Graphics.setColor @fontColor
      textW, textH = @textDrawable\getWidth!, @textDrawable\getHeight!
      x = box.x + ((boxW - textW) / 2) + (@bgImageBx or 0)
      y = box.y + ((boxH - textH) / 2) + (@bgImageBx or 0)
      Graphics.draw @textDrawable, x, y

    Graphics.setColor r, g, b, a

class Button extends Control

  new: (type) =>
    -- Bounding box type
    super type, "Button"

    -- colors
    t = assert(require(MeowUI.root .. "Controls.Style"))[MeowUI.theme]
    colors = t.colors
    common = t.common
    @stroke = common.stroke
    @fontSize = common.fontSize
    @iconAndTextSpace = common.iconAndTextSpace
    @downColor = colors.downColor
    @hoverColor = colors.hoverColor
    @upColor = colors.upColor
    @disabledColor = colors.disabledColor
    @strokeColor = colors.strokeColor
    @fontColor = colors.fontColor
    @bgImageBx, @bgImageBy = 0, 0

    @setEnabled true

    switch type
      when "Box"
        @onDraw = drawRect
        style = t.button
        @width  = style.width
        @height = style.height
        @textDrawable = Graphics.newText Graphics.newFont(@fontSize), ""
        @rx = style.rx
        @ry = style.ry
        @dynamicSize = true
        @oWidth = @width
        @oHeight = @height
        @dPadding = 0
        @bgImage = nil
        @alpha = 1
      when "Circle"
        @onDraw = drawCircle
        style = t.circleButton
        @radius  = style.radius
        @textDrawable = Graphics.newText Graphics.newFont(@fontSize), ""
        @dynamicSize = true
        @oRadius = @radius
        @dPadding = 15
        @bgImage = nil
        @alpha = 1
        @scaleX = 1
        @scaleY = 1
      when "Polygon"
        @onDraw = drawPoly
        style = t.polyButton
        @radius  = style.radius
        @textDrawable = Graphics.newText Graphics.newFont(@fontSize), ""
        @dynamicSize = true
        @oRadius = @radius
        @dPadding = 15
        @bgImage = nil
        @alpha = 1
        @scaleX = 1
        @scaleY = 1

    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @

  onClick: (cb) =>
    @Click = cb

  onHover: (cb) =>
    @Hover = cb

  onLeave: (cb) =>
    @Leave = cb

  onAfterClick: (cb) =>
    @aClick = cb

  onMouseEnter: =>
    Mouse = love.mouse
    if @Hover
      @Hover!
    @isHovred = true
    if Mouse.getSystemCursor "hand"
      Mouse.setCursor(Mouse.getSystemCursor("hand"))

  onMouseLeave: =>
    Mouse = love.mouse
    if @Leave
      @Leave!
    @isHovred = false
    Mouse.setCursor!

  onMouseDown: (x, y) =>
    if @Click
      @Click!
    @isPressed = true

  onMouseUp: (x, y) =>
    if @aClick
      @aClick!
    @isPressed = false

  setText: (text) =>
    @textDrawable\set text
    if @dynamicSize
      @width = @width > @textDrawable\getWidth! and @oWidth or @textDrawable\getWidth! + @dPadding
      @height = @height > @textDrawable\getHeight! and @oHeight or @textDrawable\getHeight!

  setDynamicPadding: (p) =>
    @dPadding = p

  setDynamicSize: (bool) =>
    @dynamicSize = bool

  setSize: (width, height) =>
    super width, height
    @oWidth = @width
    @oHeight = @height

  setUpColor: (color) =>
    @upColor = color

  setDownColor: (color) =>
    @downColor = color

  setHoverColor: (color) =>
    @hoverColor = color

  setDisableColor: (color) =>
    @theme.disableColor = color

  setStroke: (s) =>
    @stroke = s

  setFontColor: (color) =>
    @fontColor = color

  setFontSize: (size) =>
    Graphics = love.graphics
    @textDrawable\setFont Graphics.newFont size

  getFontSize: =>
    @textDrawable\getFont!\getWidth!, @textDrawable\getFont!\getHeight!

  setImage: (image, conform, bx = 0, by = 0) =>
    @bgImage = Graphics.newImage image
    box = @getBoundingBox!
    @dynamicSize = false
    @stroke = 0
    @imageX, @imageY = box.x, box.y
    if conform
      box = @getBoundingBox!
      if box.__class.__name == "Box"
        @bgImageBx, @bgImageBy = bx or 0, by
        @setSize @bgImage\getWidth! - bx, @bgImage\getHeight! - by
      elseif box.__class.__name == "Circle"
        r = @bgImage\getWidth! / 2 - bx
        @bgImageBx = bx or 0
        @setRadius r
      elseif box.__class.__name == "Polygon"
        w, h = @bgImage\getWidth! / 1.5, @bgImage\getHeight! / 1.5
        r = (w > h) and w or h
        @bgImageBx = bx or 0
        @setRadius r


  setImageBorder: (bx = 0, by = 0) =>
    @bgImageBx, @bgImageBy = bx, by
    @setSize @bgImage\getWidth! - bx, @bgImage\getHeight! - by

  setAlphaDown: (a) =>
    @alphaDown = a

  setAlphaHover: (a) =>
    @alphaHover = a

  setAlphaEnable: (a) =>
    @alphaEnable = a

  setAlphaDisable: (a) =>
    @alphaDisable = a

  setCorners: (rx, ry) =>
    @rx, @ry = rx, ry

  setScale: (x = nil, y = nil) =>
    @sx, @sy = x or @sx, y or @sy
