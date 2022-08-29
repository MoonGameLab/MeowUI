----
-- CheckBox class (An example that you can use or build on.)
-- @usage c = CheckBox!

Graphics = love.graphics
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control
Mixins   = assert require MeowUI.root .. "Controls.Mixins"



drawRect = =>
  box = @getBoundingBox!
  r, g, b, a = Graphics.getColor!
  boxW, boxH = box\getWidth!, box\getHeight!

  colorBk = @backColor
  local colorfr

  if @checked
    colorfr = @pressedColor
  else
    colorfr = @frontColor

  Graphics.setColor colorBk
  Graphics.rectangle "fill", box.x, box.y, boxW, boxH, @rx, @ry
  Graphics.setColor colorfr
  Graphics.rectangle "fill", box.x + @margin, box.y + @margin, boxW - @margin*2, boxH - @margin*2, @rx, @ry


  Graphics.setColor r, g, b, a



class CheckBox extends Control

  @include Mixins.ColorMixins
  @include Mixins.EventMixins
  @include Mixins.ThemeMixins

  new: (type) =>
    -- Bounding box type
    super type, "CheckBox"

    t = @getTheme!
    colors = t.colors
    common = t.common
    @stroke = common.stroke

    @backColor = colors.downColor
    @frontColor = colors.upColor
    @pressedColor = colors.strokeColor
    @disabledColor = colors.disabledColor
    @alpha = 1
    @checked = false

    @setEnabled true


    switch type
      when "Box"
        @onDraw = drawRect
        style = t.checkBox
        @width  = style.width
        @margin = style.margin
        @height = style.height
        @rx = style.rx
        @ry = style.ry


    -- Events
    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @


  onMouseDown: (x, y) =>
    if @Click
      @Click!
    @isPressed = true
    @checked = not @checked

  isChecked: =>
    @checked

  setOutlineColor: (c) =>
    @backColor = c

  setInnerColor: (c) =>
    @frontColor = c

  setPressedColor: (c) =>
    @pressedColor = c

  setMargin: (m) =>
    @margin = m

  setChecked: (bool) =>
    @checked = bool

