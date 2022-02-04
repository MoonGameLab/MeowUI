Graphics = love.graphics

class Button extends MeowUI.Control

  new: =>
    -- Bounding box type
    super "Box"
    style = assert(require(MeowUI.root .. "Controls.Style"))[MeowUI.theme].button

    @width = style.width
    @height = style.height
    @stroke = style.stroke
    @font = Graphics.newFont style.fontSize
    @iconAndTextSpace = style.iconAndTextSpace
    @textDrawable = Graphics.newText @font, ""
    @rx = style.rx
    @ry = style.ry

    -- colors
    @downColor = style.downColor
    @hoverColor = style.hoverColor
    @upColor = style.upColor
    @disabledColor = style.disabledColor
    @strokeColor = style.strokeColor
    @fontColor = style.fontColor


    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @


  drawText: (box) =>
    text = @textDrawable
    textW = text and text\getWidth! or 0
    textH = text and text\getHeight! or 0
    space = text and @iconAndTextSpace or 0
    dynamicContentWidth = space + textW
    textX = (box\getWidth! - dynamicContentWidth + 10) / 2 + box.x
    textY = (box\getHeight! - textH)/2 + box.y
    Graphics.setColor @fontColor
    Graphics.draw text, textX, textY

  onDraw: =>
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

    -- base
    Graphics.setColor color
    Graphics.rectangle "fill", box.x, box.y, box\getWidth!, box\getHeight!, @rx, @ry

    -- border
    if @enabled and @stroke > 0
      oldLineWidth = Graphics.getLineWidth!
      Graphics.setLineWidth @stroke
      Graphics.setLineStyle "rough" -- could be dynamic
      Graphics.setColor @strokeColor
      Graphics.rectangle "line", box.x, box.y, box\getWidth!, box\getHeight!, @rx, @ry
      Graphics.setLineWidth oldLineWidth

    -- Text
    if @textDrawable then @drawText box


    Graphics.setColor r, g, b, a

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
