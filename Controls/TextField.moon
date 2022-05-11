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
    @overrideText = false

    @cursorChrono = @addChrono 0.4, true, false, ->
      @showCursor = not @showCursor

    @keyChrono = @addChrono style.keyChronoRepeatTime, true, false, ->
      if @keyToRepeat and @keyToRepeat == 'backspace'
        @_backspace!
        @keyToRepeat = nil

    @setUpdateWhenFocused false

    -- alpha

    @letters = {}

    @setEnabled true

    @on "UI_DRAW", @onDraw, @
    @on "UI_KEY_DOWN", @onKeyDown, @
    @on "UI_KEY_UP", @onKeyUp, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_UP", @onMouseUp, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
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
      if @overrideText
        rawset @letters, @indexCursor + 1, {
          c: text
          w: @font\getWidth(text)
          h: @font\getHeight!
        }
      else
        table.insert @letters, @indexCursor + 1, {
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

  _formStringFromLetters: =>
    str = ""
    for _, v in pairs @letters
      str ..= v.c
    str

  _getCurrentTextSize: =>
    print 'sizeCalc'
    if #@letters == 0 then return 0, 0
    @oldSize = #@letters
    str = @_formStringFromLetters!
    @font\getWidth(str), @font\getHeight(str)

  _selectedRect: (x, y) =>
    r, g, b, a = Graphics.getColor!
    Graphics.setColor {0, 0.5, 1}
    if #@letters > 0
      if @oldSize != #@letters
        @selectedwidth, @selectedHeight = @_getCurrentTextSize!
      Graphics.rectangle "fill", x + @font\getWidth(@letters[1].c), y + @font\getHeight(@letters[1].c)/3, @selectedwidth, @selectedHeight
    Graphics.setColor r, g, b, a

  setKeyToRepeat: (k) =>
    if k == @keyToRepeat
      @keyToRepeat = nil
      return

    @keyToRepeat = k

  cursorMove: (k) =>
    if k == 'left' then if @indexCursor > 0 then @indexCursor -= 1
    if k == 'right' then if @indexCursor < #@letters then @indexCursor += 1

  onDraw: =>
    box = @getBoundingBox!
    r, g, b, a = Graphics.getColor!
    boxW, boxH = box\getWidth!, box\getHeight!
    x, y = box\getX!, box\getY!

    @_drawBackground x, y, boxW, boxH
    @_drawTextArea x, y, boxW, boxH
    @_selectedRect x, y
    @_drawText x, y, boxH

    Graphics.setColor r, g, b, a

  onMouseEnter: =>
  onMouseLeave: =>
  onKeyUp: (key) =>
  onMouseUp: =>
  onMouseDown: =>

  onKeyDown: (key) =>
    @setKeyToRepeat key
    @cursorMove key

  onTextInput: (text) =>
    box = @getBoundingBox!
    x, y = box\getX!, box\getY!
    boxW = box\getWidth!
    @_pushText x, y, string.utf8sub(text, 1, 1), boxW
