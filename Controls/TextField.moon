

Graphics = love.graphics
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control


class TextField extends Control

  _lettersWidth: =>
    if @letters == nil then return
    w = 0
    for i = 1, #@letters
      w += @font\getWidth @letters[i].c
    w

  new: (defaultText) =>
    -- Bounding box type
    super "Box", "TextField"

    @text = nil
    @chars = nil


    -- colors
    t = assert(require(MeowUI.root .. "Controls.Style"))[MeowUI.theme]
    colors = t.colors
    common = t.common
    style = t.textField

    @stroke = common.stroke
    @fontSize = common.fontSize
    @iconAndTextSpace = common.iconAndTextSpace
    @downColor = colors.downColor
    @hoverColor = colors.hoverColor
    @upColor = colors.upColor
    @disabledColor = colors.disabledColor
    @strokeColor = colors.strokeColor
    @backgroundColor = colors.backgroundColor
    @fontColor = colors.fontColor
    @font = Graphics.newFont @fontSize
    @rx = style.rx
    @ry = style.ry

    -- alpha

    @letters = nil

    @setEnabled true

    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @


  onDraw: =>
    box = @getBoundingBox!
    r, g, b, a = Graphics.getColor!
    boxW, boxH = box\getWidth!, box\getHeight!
    x, y = box\getX!, box\getY!
    color = @backgroundColor
    color[4] = color[4] or @alpha

    Graphics.setColor color
    Graphics.rectangle "fill", box.x, box.y, boxW, boxH, @rx, @ry

    Graphics.setColor r, g, b, a



  onMouseEnter: =>
  onMouseLeave: =>
  onMouseDown: =>
  onMouseUp: =>
