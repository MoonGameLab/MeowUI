----
-- CheckBox class (An example that you can use or build on.)
-- @usage c = CheckBox!

Graphics = love.graphics
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control
Mixins   = assert require MeowUI.root .. "Controls.Mixins"


import ceil from math
import insert from table

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

setChecked = (bool, rec = true) =>
  if rec == false
    @checked = bool
    return
  if #@group > 0
    for _, elem in ipairs @group
      elem.checked = not bool
  @checked = bool


drawCircle = =>
  box = @getBoundingBox!
  r, g, b, a = Graphics.getColor!
  boxR = box\getRadius!

  colorBk = @backColor
  local colorfr

  if @checked
    colorfr = @pressedColor
  else
    colorfr = @frontColor

  Graphics.setColor colorBk
  Graphics.circle 'fill', box.x, box.y, boxR, @segments
  Graphics.setColor colorfr
  Graphics.circle 'fill', box.x, box.y, ceil(boxR - @margin), @segments
  Graphics.setColor r, g, b, a

-- @local
polyBorder = (box) =>
  oldLineWidth = Graphics.getLineWidth!
  Graphics.setLineWidth @stroke
  Graphics.setLineStyle "rough"
  Graphics.setColor @strokeColor
  Graphics.polygon "line", box\getVertices!
  Graphics.setLineWidth oldLineWidth

drawPoly = =>
  box = @getBoundingBox!
  r, g, b, a = Graphics.getColor!

  colorBk = @backColor
  local colorfr

  if @checked
    colorfr = @pressedColor
  else
    colorfr = @frontColor

  Graphics.setColor colorfr
  Graphics.polygon 'fill', box\getVertices!

  -- border
  polyBorder @, box
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
    @strokeColor = {0, 0, 0}
    @alpha = 1
    @checked = false
    @group = {}

    @setChecked = setChecked

    @setEnabled true

    @groupMember = false

    switch type
      when "Box"
        @onDraw = drawRect
        style = t.checkBox
        @width  = style.width
        @margin = style.margin
        @height = style.height
        @rx = style.rx
        @ry = style.ry
      when "Circle"
        @onDraw = drawCircle
        style = t.checkBox
        @margin = style.margin
        @radius  = style.radius
        @segments  = style.segments
        @dPadding = 15
      when "Polygon"
        @onDraw = drawPoly
        style = t.checkBox
        @radius  = style.radius
        @stroke = t.checkBox.stroke
        --@innerPoly =

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
    @setChecked not @checked

  linkTo: (cb) =>
    if #cb\getGroup! > 0
      for _, v in ipairs cb\getGroup!
        insert @group, v
        v\addToGroup @
      cb\addToGroup @
    else
      @addToGroup cb
      cb\addToGroup @

  addToGroup: (e) =>
    insert @group, e

  getGroup: =>
    @group

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




