----
-- A button class (An example that you can use or build on.)
-- @usage b = Button!

Graphics = love.graphics
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control

-- @local
stencileFuncCircle = =>
  box = @getBoundingBox!
  -> Graphics.circle "fill", box.x, box.y, @bgImage\getWidth! / 2 + @stroke

-- @local
stencileFuncPoly = =>
  box = @getBoundingBox!
  -> Graphics.polygon "fill", box\getVertices!

-- @local
circleBorder = (box) =>
  if @enabled and @stroke > 0
    oldLineWidth = Graphics.getLineWidth!
    Graphics.setLineWidth @stroke
    Graphics.setLineStyle "rough" -- could be dynamic
    Graphics.setColor @strokeColor
    Graphics.circle "line", box.x, box.y, box\getRadius!
    Graphics.setLineWidth oldLineWidth

-- @local
polyBorder = (box) =>
  if @enabled and @stroke > 0
    oldLineWidth = Graphics.getLineWidth!
    Graphics.setLineWidth @stroke
    Graphics.setLineStyle "rough" -- could be dynamic
    Graphics.setColor @strokeColor
    Graphics.polygon "line", box\getVertices!
    Graphics.setLineWidth oldLineWidth


-- @local
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


-- @local
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

    Graphics.push 'all'

    sf = stencileFuncPoly self
    Graphics.stencil sf, "increment", 1, true
    Graphics.setStencilTest "greater", 1
    x, y = box\getPosition!
    Graphics.draw @bgImage, x - @bgImage\getWidth!/2 , y - @bgImage\getHeight!/2
    -- border
    polyBorder @, box
    Graphics.setStencilTest!
    Graphics.setColor r, g, b, a

    Graphics.pop!
  else
    Graphics.setColor color
    Graphics.polygon 'fill', box\getVertices!
    -- border
    polyBorder @, box
    Graphics.setColor r, g, b, a

  -- Text
  if @textDrawable
    Graphics.setColor @fontColor
    textW, textH = @textDrawable\getWidth!, @textDrawable\getHeight!
    x = box.x - textW / 2
    y = box.y - textH / 2
    Graphics.draw @textDrawable, x, y

  Graphics.setColor r, g, b, a


-- @local
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

    Graphics.push 'all'

    sf = stencileFuncCircle self

    Graphics.stencil sf, "increment", 1, true
    Graphics.setStencilTest "greater", 1
    Graphics.draw @bgImage, ((box.x - @bgImageBx) - @radius * @scaleX),
      ((box.y - @bgImageBx) - @radius * @scaleY)
    -- border
    circleBorder @, box
    Graphics.setStencilTest!
    Graphics.setColor r, g, b, a

    Graphics.pop!
  else
    Graphics.setColor color
    Graphics.circle 'fill', box.x, box.y, boxR
    circleBorder @, box
    Graphics.setColor r, g, b, a

  -- Text
  if @textDrawable
    Graphics.setColor @fontColor
    textW, textH = @textDrawable\getWidth!, @textDrawable\getHeight!
    x = box.x - textW / 2
    y = box.y - textH / 2
    Graphics.draw @textDrawable, x, y


  Graphics.setColor r, g, b, a


-- @local
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

  --- constructor.
  -- @tparam string type Bounding box type[Box, Circle, Polygon]
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
    @alpha = 1
    @scaleX = 1
    @scaleY = 1
    @bgImage = nil
    @textDrawable = Graphics.newText Graphics.newFont(@fontSize), ""
    @dynamicSize = true

    @setEnabled true

    switch type
      when "Box"
        @onDraw = drawRect
        style = t.button
        @width  = style.width
        @height = style.height
        @rx = style.rx
        @ry = style.ry
        @oWidth = @width
        @oHeight = @height
        @dPadding = 0
      when "Circle"
        @onDraw = drawCircle
        style = t.circleButton
        @radius  = style.radius
        @dPadding = 15
      when "Polygon"
        @onDraw = drawPoly
        style = t.polyButton
        @radius  = style.radius
        @dPadding = 15

    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @

  --- sets the onClick callback.
  -- @tparam function cb
  onClick: (cb) =>
    @Click = cb

  --- sets the onHover callback.
  -- @tparam function cb
  onHover: (cb) =>
    @Hover = cb

  --- sets the onLeave callback.
  -- @tparam function cb
  onLeave: (cb) =>
    @Leave = cb

  --- sets the onAfterClick callback.
  -- @tparam function cb
  onAfterClick: (cb) =>
    @aClick = cb

  -- @local
  onMouseEnter: =>
    Mouse = love.mouse
    if @Hover
      @Hover!
    @isHovred = true
    if Mouse.getSystemCursor "hand"
      Mouse.setCursor(Mouse.getSystemCursor("hand"))

  -- @local
  onMouseLeave: =>
    Mouse = love.mouse
    if @Leave
      @Leave!
    @isHovred = false
    Mouse.setCursor!

  -- @local
  onMouseDown: (x, y) =>
    if @Click
      @Click!
    @isPressed = true

  -- @local
  onMouseUp: (x, y) =>
    if @aClick
      @aClick!
    @isPressed = false

  --- sets button text.
  -- @tparam string text
  setText: (text) =>
    @textDrawable\set text
    if @dynamicSize
      @width = @width > @textDrawable\getWidth! and @oWidth or @textDrawable\getWidth! + @dPadding
      @height = @height > @textDrawable\getHeight! and @oHeight or @textDrawable\getHeight!


  --- sets dynamic padding.
  -- @tparam number p
  setDynamicPadding: (p) =>
    @dPadding = p

  --- sets dynamic size (Grows with the text).
  -- @tparam boolean bool
  setDynamicSize: (bool) =>
    @dynamicSize = bool

  -- @local (Overload)
  setSize: (width, height) =>
    super width, height
    @oWidth = @width
    @oHeight = @height

  --- sets upColor.
  -- @tparam table color
  setUpColor: (color) =>
    @upColor = color

  --- sets downColor.
  -- @tparam table color
  setDownColor: (color) =>
    @downColor = color

  --- sets hoverColor.
  -- @tparam table color
  setHoverColor: (color) =>
    @hoverColor = color

  --- sets DisableColor.
  -- @tparam table color
  setDisableColor: (color) =>
    @theme.disableColor = color

  --- sets the stroke (Border line width).
  setStroke: (s) =>
    if @getBoundingBox!.__class.__name == "Polygon"
      _s = @getStroke! * 2
      r = @getRadius! - _s
      @stroke = s * 2
      @setRadius r + s
      return

    @stroke = s

  --- gets stroke
  -- @treturn number stroke
  getStroke: =>
    @stroke

  --- sets the text font color.
  -- @tparam table color
  setFontColor: (color) =>
    @fontColor = color

  --- sets the text font size.
  -- @tparam number size
  setFontSize: (size) =>
    Graphics = love.graphics
    @textDrawable\setFont Graphics.newFont size

  --- gets the font size.
  -- @treturn number fsize
  getFontSize: =>
    @textDrawable\getFont!\getWidth!, @textDrawable\getFont!\getHeight!

  --- sets button image
  -- @tparam string image (path)
  -- @tparam boolean conform (Give the Bbox the same size as the image).
  -- @tparam number bx (Image border x)
  -- @tparam number by (Image border x)
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
        @setRadius r + @stroke


  --- sets the image border
  -- @tparam number bx
  -- @tparam number by
  setImageBorder: (bx = 0, by = 0) =>
    @bgImageBx, @bgImageBy = bx, by
    @setSize @bgImage\getWidth! - bx, @bgImage\getHeight! - by

  --- sets alpha for when the button is down.
  -- @tparam number a
  setAlphaDown: (a) =>
    @alphaDown = a

  --- sets alpha for when the button is hovred.
  -- @tparam number a
  setAlphaHover: (a) =>
    @alphaHover = a

  --- sets alpha for when the button is enabled.
  -- @tparam number a
  setAlphaEnable: (a) =>
    @alphaEnable = a

   -- sets alpha for when the button is disabled.
  -- @tparam number a
  setAlphaDisable: (a) =>
    @alphaDisable = a

  --- sets corners sharpness.
  -- @tparam number rx
  -- @tparam number ry
  setCorners: (rx, ry) =>
    @rx, @ry = rx, ry

  --- sets the scale.
  -- @tparam number x
  -- @tparam number y
  setScale: (x = nil, y = nil) =>
    @sx, @sy = x or @sx, y or @sy

  --- sets the depth.
  -- @tparam number depth
  setDepth: (depth) =>
    super depth
