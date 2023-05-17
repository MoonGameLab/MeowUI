Graphics = love.graphics
Window = love.window
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control
Mixins   = assert require MeowUI.root .. "Controls.Mixins"


-- @local
stencileFuncRect = =>
  box = @getBoundingBox!
  x, y, w, h = box\getX!, box\getY!, box\getWidth!, box\getHeight!
  floor = math.floor
  mc = h / @marginCorner
  w, h = floor(w - mc * 2), floor(h - mc * 2)
  -> Graphics.rectangle "fill", x + mc, y + mc, w, h, @trx, @try

class TextField extends Control

  @include Mixins.KeyboardMixins

  _backspace: =>
    @_popTextString!

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
    @textString = ""
    @selectAll = false

    @cursorChrono = @addChrono 0.4, true, false, ->
      @showCursor = not @showCursor

    @keyChrono = @addChrono style.keyChronoRepeatTime, true, false, ->
      if @keyToRepeat and @keyToRepeat == 'backspace'
        @_backspace!
        @keyToRepeat = nil


    @setUpdateWhenFocused false

    -- Default size
    @setSize 250, 25

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
  _clear: =>
    @textString = ""

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
        @xCursor = x + displacement + (height / @marginCorner) + @marginCorner/3
        Graphics.line fl(@xCursor), fl(y + marginCorner + @unit / 15), fl(@xCursor),
          fl(y + height - marginCorner - @unit / 15)

  _pushTextString: (text) =>
    if @selectAll
      @_clear!
      @indexCursor = 0
      @selectAll = false

      firstHalf = string.utf8sub @textString, 1, @indexCursor
      secondHalf = string.utf8sub @textString, @indexCursor + 1

      @indexCursor += 1

      @textString = firstHalf .. text .. secondHalf
    else
      if @font\getWidth(@textString) <= @getBoundingBox!\getWidth! - @marginText * 4 - (@getBoundingBox!\getHeight! / @marginCorner) - (@getBoundingBox!\getHeight! / @marginCorner)
        firstHalf = string.utf8sub @textString, 1, @indexCursor
        secondHalf = string.utf8sub @textString, @indexCursor + 1

        @indexCursor += 1

        @textString = firstHalf .. text .. secondHalf

  _popTextString: () =>
    if @selectAll
      @_clear!
      @indexCursor = 0
      @selectAll = false
      return
    if #@textString > 0 and @indexCursor > 0
      firstHalf = string.utf8sub @textString, 1, @indexCursor - 1
      secondHalf = string.utf8sub @textString, @indexCursor + 1
      @indexCursor -= 1
      @textString = firstHalf .. secondHalf



  _drawText: (x, y, height) =>
    _marginCorner = height / 6

    r, g, b, a = Graphics.getColor!
    Graphics.setColor @textColor

    charDisplacement = 0

    for i = 1, @textString\utf8len!
      letter = @textString\utf8sub i, i

      xChar = x + charDisplacement + (height / @marginCorner) + @marginCorner/3
      yChar = y + (height/2 - @font\getHeight(@textString)/2)

      Graphics.print letter, @font, xChar, yChar

      charDisplacement += @font\getWidth(letter)
      if i == @indexCursor then @_drawCursor x, y, height, charDisplacement, _marginCorner

    if @indexCursor == 0 then @_drawCursor x - 2.5, y, height, @marginText, _marginCorner

    Graphics.setColor r, g, b, a

  _selectedRect: (x, y, height) =>
    r, g, b, a = Graphics.getColor!
    Graphics.setColor {0, 0.5, 1}
    if #@textString > 0
      if @oldSize != #@textString
        @selectedwidth, @selectedHeight = @font\getWidth(@textString), @font\getHeight!

      xChar = x + (height / @marginCorner) + @marginCorner/3
      yChar = y + (height/2 - @font\getHeight(@textString)/2)
      Graphics.rectangle "fill", xChar, yChar, @selectedwidth, @selectedHeight
      @oldSize = #@textString
    Graphics.setColor r, g, b, a

  setKeyToRepeat: (k) =>
    if k == @keyToRepeat
      @keyToRepeat = nil
      return

    @keyToRepeat = k

  cursorMove: (k) =>
    if k == 'left' then if @indexCursor >= 1 then @indexCursor -= 1
    if k == 'right' then if @indexCursor < #@textString then @indexCursor += 1

  onDraw: =>
    box = @getBoundingBox!
    r, g, b, a = Graphics.getColor!
    boxW, boxH = box\getWidth!, box\getHeight!
    x, y = box\getX!, box\getY!

    @_drawBackground x, y, boxW, boxH

    sf = stencileFuncRect self
    Graphics.stencil sf
    Graphics.setStencilTest "greater", 0

    @_drawTextArea x, y, boxW, boxH
    if @selectAll then @_selectedRect x, y, boxH
    @_drawText x, y, boxH

    Graphics.setStencilTest!

    Graphics.setColor r, g, b, a

  onMouseEnter: =>
  onMouseLeave: =>
  onMouseUp: =>
  onMouseDown: =>

  onKeyUp: (key) =>

  onKeyDown: (key) =>
    if @isCtrlDown!
      if key == 'a' and #@textString > 0
        @selectAll = not @selectAll

    @setKeyToRepeat key
    @cursorMove key


  onTextInput: (text) =>
    @_pushTextString text
