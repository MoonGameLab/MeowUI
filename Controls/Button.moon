Graphics = love.graphics

drawRect = (self) ->
    box = @getBoundingBox!

    r, g, b, a = Graphics.getColor!

    local color
    if @isPressed
      color = @downColor
    elseif @isHovred
      color = @hoverColor
    elseif @enabled
      color = @upColor
    else
      color = @disabledColor


    -- Button body
    if @bgImage
      if not @isPressed
        Graphics.setColor r, g, b
      if @isHovred
        Graphics.setColor color

      Graphics.draw @bgImage, @imageX, @imageY
      x = @imageX + ((@bgImage\getWidth! - box\getWidth!) / 2)
      y = @imageY + ((@bgImage\getHeight! - box\getHeight!) / 2)
      box.x, box.y = x + (@bgImageBx/2), y + (@bgImageBy/2)

      Graphics.setColor r, g, b
    else
      Graphics.setColor color
      Graphics.rectangle "fill", box.x, box.y, box\getWidth!, box\getHeight!, @rx, @ry
      Graphics.setColor r, g, b

    -- border
    if @enabled and @stroke > 0
      oldLineWidth = Graphics.getLineWidth!
      Graphics.setLineWidth @stroke
      Graphics.setLineStyle "rough" -- could be dynamic
      Graphics.setColor @strokeColor
      Graphics.rectangle "line", box.x, box.y, box\getWidth!, box\getHeight!, @rx, @ry
      Graphics.setLineWidth oldLineWidth

    -- Text
    if @textDrawable
      x = @x + ((box\getWidth! - @textDrawable\getWidth!) / 2) + @bgImageBx
      y = @y + ((box\getHeight! - @textDrawable\getHeight!) / 2) + @bgImageBy
      Graphics.draw @textDrawable, x, y

    Graphics.setColor r, g, b, a

class Button extends MeowUI.Control

  new: =>
    -- Bounding box type
    super "Box"
    style = assert(require(MeowUI.root .. "Controls.Style"))[MeowUI.theme].button

    @width  = style.width
    @height = style.height
    @stroke = style.stroke
    @iconAndTextSpace = style.iconAndTextSpace
    @textDrawable = Graphics.newText Graphics.newFont(style.fontSize), ""
    @rx = style.rx
    @ry = style.ry
    @dynamicSize = true
    @oWidth = @width
    @oHeight = @height
    @dPadding = 15
    @bgImage = nil

    -- colors
    @downColor = style.downColor
    @hoverColor = style.hoverColor
    @upColor = style.upColor
    @disabledColor = style.disabledColor
    @strokeColor = style.strokeColor
    @fontColor = style.fontColor

    @onDraw = drawRect

    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @

  onDraw: =>

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
    -- @text = text
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
    @dynamicSize = false
    @stroke = 0
    @imageX, @imageY = @x, @y
    if conform
      @bgImageBx, @bgImageBy = bx, by
      @setSize @bgImage\getWidth! - bx, @bgImage\getHeight! - by

  setImageBorder: (bx = 0, by = 0) =>
    @bgImageBx, @bgImageBy = bx, by
    @setSize @bgImage\getWidth! - bx, @bgImage\getHeight! - by

