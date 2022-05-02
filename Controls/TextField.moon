

Graphics = love.graphics
Window = love.window
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control


class TextField extends Control

  -- @local
  _lettersWidth: =>
    if @letters == nil then return
    w = 0
    for i = 1, #@letters
      w += @font\getWidth rawget(@letters, i).c
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
    @unit = 25
    @marginText = @unit / 5
    @fontSize = common.fontSize
    @iconAndTextSpace = common.iconAndTextSpace
    @downColor = colors.downColor
    @hoverColor = colors.hoverColor
    @upColor = colors.upColor
    @disabledColor = colors.disabledColor
    @strokeColor = colors.strokeColor
    @fontColor = colors.fontColor
    @strokeColor = colors.strokeColor

    @font = Graphics.newFont Window.toPixels(@fontSize)
    @rx = style.rx
    @ry = style.ry
    @trx, @try = @rx, @ry
    @marginCorner = style.marginCorner
    @textAreaColor = style.textAreaColor
    @showCursor = true
    @indexCursor = 0
    @addChrono 0.4, true, -> @showCursor = not @showCursor

    -- alpha

    @letters = {
      {c: "A"}
    }

    @setEnabled true

    @on "UI_DRAW", @onDraw, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @
    @on "UI_TEXT_INPUT", @onTextInput, @
    @on "UI_TEXT_CHANGE", @onTextInput, @

  -- @local
  _drawBackground: (x, y, w, h) =>
    color = @strokeColor
    color[4] = color[4] or @alpha
    Graphics.setColor color
    Graphics.rectangle "fill", x, y, w, h, @rx, @ry

  -- @local
  _drawTextArea: (x, y, w, h) =>
    floor = math.floor
    mc = h / @marginCorner
    color = @textAreaColor
    color[4] = color[4] or @alpha
    Graphics.setColor color
    w, h = floor(w - mc * 2), floor(h - mc * 2)
    Graphics.rectangle "fill", x + mc, y + mc, w, h, @trx, @try

  _drawCursor: (x, y, displacement) =>
    fl = math.floor
    if @showCursor
      if @ == MeowUI.focusedControl
        @xCursor = x + @marginCorner + displacement
        Graphics.line fl(@xCursor), fl(y + @marginCorner + @unit / 15)

  _pushText: (x, y, text, boxW) =>
    r, g, b, a = Graphics.getColor!
    if @_lettersWidth! <= boxW - @marginText * 4
      rawset @letters, @indexCursor + 1, {
        c: text
        w: @font\getWidth(text)
        h: @font\getHeight!
      }
      @indexCursor += 1
    Graphics.setColor r, g, b, a

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
  onTextInput: (text) =>
