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

  _backspace: =>
    if #@letters > 0
      letter = table.remove @letters, @indexCursor
      if letter
        @indexCursor -= 1

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
    @textColor = style.textColor
    @allowBackspace = true
    @showCursor = true
    @indexCursor = 0
    @cursorChrono = @addChrono 0.4, true, -> @showCursor = not @showCursor

    @keyChrono = @addChrono style.keyChronoRepeatTime, true, ->
      if @keyToRepeat and @keyToRepeat == 'backspace'
        @_backspace!
        @keyToRepeat = nil


    -- alpha

    @letters = {}

    @setEnabled true

    @on "UI_DRAW", @onDraw, @
    @on "UI_UPDATE", @onUpdate, @
    @on "UI_KEY_DOWN", @onKeyDown, @
    @on "UI_KEY_UP", @onKeyUp, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_UP", @onMouseUp, @
    @on "UI_TEXT_INPUT", @onTextInput, @

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

  _drawCursor: (x, y, height, displacement, marginCorner) =>
    fl = math.floor
    if @showCursor
      if @ == MeowUI.clickedControl
        @xCursor = x + marginCorner + displacement
        Graphics.line fl(@xCursor), fl(y + marginCorner + @unit / 15), fl(@xCursor),
          fl(y + height - marginCorner - @unit / 15)

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

  _drawText: (x, y, height) =>
    mf = math.floor
    _marginCorner = height / 6

    r, g, b, a = Graphics.getColor!
    Graphics.setColor @textColor

    charDisplacement = 0

    for i = 1, #@letters
      letter = @letters[i] -- object
      xChar = x + _marginCorner + charDisplacement + @marginText
      yChar = y + height/2 - @font\getHeight!/2

      Graphics.print letter.c, mf(xChar), mf(yChar)

      charDisplacement += letter.w
      if i == @indexCursor then @_drawCursor x, y, height, charDisplacement + @marginText, _marginCorner

    if @indexCursor == 0 then @_drawCursor x, y, height, @marginText, _marginCorner

    Graphics.setColor r, g, b, a

  setKeyToRepeat: (k) =>
    if k == @keyToRepeat
      @keyToRepeat = nil
      return

    @keyToRepeat = k

  onDraw: =>
    box = @getBoundingBox!
    r, g, b, a = Graphics.getColor!
    boxW, boxH = box\getWidth!, box\getHeight!
    x, y = box\getX!, box\getY!

    @_drawBackground x, y, boxW, boxH
    @_drawTextArea x, y, boxW, boxH
    @_drawText x, y, boxH

    Graphics.setColor r, g, b, a

  onMouseEnter: =>

  onMouseLeave: =>

  onKeyDown: (key) =>
    @setKeyToRepeat key

  onKeyUp: (key) =>

  onUpdate: (dt) =>

  onMouseUp: =>

  onTextInput: (text) =>
    box = @getBoundingBox!
    x, y = box\getX!, box\getY!
    boxW = box\getWidth!
    @_pushText x, y, text, boxW -- TODO: Needs a wrapper to support UTF-8.
