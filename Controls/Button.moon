assert require "MeowUI"
Graphics = love.graphics

class Button extends MeowUI.Control

  new: =>
    -- Bounding box type
    super "Box"

    @width = 100
    @height = 50
    @stroke = 1
    @font = Graphics.newFont 16
    @iconAndTextSpace = 8
    @textDrawable = Graphics.newText @font, ""

    -- colors
    @downColor = { 0.0274509803922 ,0.0274509803922 ,0.0274509803922 }
    @hoverColor = { 0.2, 0.2, 0.2 }
    @upColor = { 0.0980392156863, 0.101960784314, 0.0980392156863 }
    @disabledColor = { 0.66274509803922, 0.66274509803922, 0.66274509803922 }
    @strokeColor = { 0.149019607843, 0.929411764706, 0.286274509804}
    @fontColor = { 1, 1, 1 }


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
    textX = (box\getWidth! - dynamicContentWidth) / 2 + box.x + (text\getWidth! / 2)
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
    Graphics.rectangle "fill", box.x, box.y, box\getWidth!, box\getHeight!

    -- border
    if @enabled and @stroke > 0
      oldLineWidth = Graphics.getLineWidth!
      Graphics.setLineWidth @stroke
      Graphics.setLineStyle "rough" -- could be dynamic
      Graphics.setColor @strokeColor
      Graphics.rectangle "line", box.x, box.y, box\getWidth!, box\getHeight!
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
