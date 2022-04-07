

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
    @fontColor = colors.fontColor
    @strokeColor = colors.strokeColor

    @font = Graphics.newFont @fontSize
    @rx = style.rx
    @ry = style.ry
    @trx, @try = @rx, @ry
    @marginCorner = style.marginCorner
    @textAreaColor = style.textAreaColor

    -- alpha

    @letters = nil

    @setEnabled true

    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @

  _drawBackground: (x, y, w, h) =>
    color = @strokeColor
    color[4] = color[4] or @alpha
    Graphics.setColor color
    Graphics.rectangle "fill", x, y, w, h, @rx, @ry


  _drawTextArea: (x, y, w, h) =>
    floor = math.floor
    mc = h / @marginCorner
    color = @textAreaColor
    color[4] = color[4] or @alpha
    Graphics.setColor color
    w, h = floor(w - mc * 2), floor(h - mc * 2)
    Graphics.rectangle "fill", x + mc, y + mc, w, h, @trx, @try

  onDraw: =>
    box = @getBoundingBox!
    r, g, b, a = Graphics.getColor!
    boxW, boxH = box\getWidth!, box\getHeight!
    x, y = box\getX!, box\getY!

    @_drawBackground x, y, boxW, boxH
    @_drawTextArea x, y, boxW, boxH

    Graphics.setColor r, g, b, a


  onMouseEnter: =>
  onMouseLeave: =>
  onMouseDown: =>
  onMouseUp: =>
