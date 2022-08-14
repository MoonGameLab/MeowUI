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

    if font
      @font = Graphics.newFont font, @size
    else
      @font = Graphics.newFont @size

    @textDrawable = Graphics.newText @font, @text
    @font\setLineHeight @LineHight

    @setEnabled true

    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @

  onDraw: =>
  onMouseEnter: =>
  onMouseLeave: =>
  onMouseDown: =>
  onMouseUp: =>

