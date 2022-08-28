----
-- Label class
-- @usage l = Label!

Graphics = love.graphics
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control
Mixins   = assert require MeowUI.root .. "Controls.Mixins"
Colors = assert require MeowUI.cwd .. "AddOns.Colors"


class Label extends Control

  @include Mixins.ColorMixins
  @include Mixins.EventMixins
  @include Mixins.ThemeMixins

  _setContactArea = =>
    if @autoSize
      @setSize @textDrawable\getWidth!, @textDrawable\getHeight!
    else
      _, wt = @font\getWrap @text, @getWidth!
      text = ""
      for i, v in ipairs wt
        if i == #wt
          text ..= v
        else
          text ..= v .. "\n"
        @textDrawable\set text



  new: (font = nil, text = "", color = Colors.white, size = 15) =>

    super "Box", "Label"

    @size = size
    @text = text
    @color = color
    @setEnabled true
    @bgColor = Colors.white

    @LineHight = 1
    @scaleX = 1
    @scaleY = 1
    @autoSize = true
    @drawBg = true
    @bgOffsetX = 3
    @bgOffsetY = 3
    @alpha = 1
    @isHovred = false
    @isPressed = false
    @pressable = false
    @hoverable = false


    if font
      if type(font) == "number" then @font = Graphics.newFont font
      if type(font) == "string" then @font = Graphics.newFont font, @size
    else
      @font = Graphics.newFont @size

    @textDrawable = Graphics.newText @font, @text
    @font\setLineHeight @LineHight

    @setEnabled true

    _setContactArea @

    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @



  onDraw: =>
    box = @getBoundingBox!
    r, g, b, a = Graphics.getColor!
    Graphics.setColor @color[1], @color[2], @color[3], @alpha
    if @drawBg
      Graphics.setColor @bgColor[1], @bgColor[2], @bgColor[3], @alpha
      Graphics.draw @textDrawable, box\getX! - @bgOffsetX , box\getY! - @bgOffsetY, @rot, @scaleX, @scaleY
      Graphics.setColor @color[1], @color[2], @color[3], @alpha
    Graphics.draw @textDrawable, box\getX!, box\getY!, @rot, @scaleX, @scaleY
    Graphics.setColor r, g, b, a

  -- @override
  onMouseEnter: =>
    if @hoverable
      Mouse = love.mouse
      if @Hover
        @Hover!
      @isHovred = true
      if Mouse.getSystemCursor "hand"
        Mouse.setCursor(Mouse.getSystemCursor("hand"))

  -- @override
  onMouseDown: (x, y) =>
    if @pressable
      if @Click
        @Click!
      @isPressed = true

  -- @override
  onMouseUp: (x, y) =>
    if @pressable
      if @aClick
        @aClick!
      @isPressed = false

  setPressable: (p) =>
    @pressable = p

  setHoverable: (h) =>
    @hoverable = h

  setColor: (c) =>
    @color = c

  setBgColor: (c) =>
    @bgColor = c

  setBgOffset: (ox = nil, oy = nil) =>
    @bgOffsetX = ox or @bgOffsetX
    @bgOffsetY = oy or @bgOffsetY

  setAlpha: (a) =>
    @alpha = a

  setFont: (font, size = @size) =>
    if type(font) == "number" then @font = Graphics.newFont font
    if type(font) == "string" then @font = Graphics.newFont font, size
    @textDrawable = Graphics.newText @font, @text
    _setContactArea @

  setText: (text = @text) =>
    @textDrawable = Graphics.newText @font, text
    _setContactArea @
