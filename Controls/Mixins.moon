love = love
Keyboard = love.keyboard
MeowUI   = MeowUI


ColorMixins = class

  --- sets upColor.
  -- @tparam table color
  setUpColor: (color) =>
    if @upColor == nil then return false
    @upColor = color
    true

  --- sets downColor.
  -- @tparam table color
  setDownColor: (color) =>
    if @downColor == nil then return false
    @downColor = color
    true

  --- sets hoverColor.
  -- @tparam table color
  setHoverColor: (color) =>
    if @hoverColor == nil then return false
    @hoverColor = color
    true

  --- sets DisabledColor.
  -- @tparam table color
  setDisabledColor: (color) =>
    if @disabledColor == nil then return false
    @disabledColor = color
    true

  --- sets StrokeColor.
  -- @tparam table color
  setStrokeColor: (color) =>
    if @strokeColor == nil then return false
    @strokeColor = color
    true

  --- sets alpha for when the control is down.
  -- @tparam number a
  setAlphaDown: (a) =>
    if @alphaDown == nil then return false
    @alphaDown = a
    true

  --- sets alpha for when the control is hovred.
  -- @tparam number a
  setAlphaHover: (a) =>
    if @alphaHover == nil then return false
    @alphaHover = a
    true

  --- sets alpha for when the control is enabled.
  -- @tparam number a
  setAlphaEnable: (a) =>
    if @alphaEnable == nil then return false
    @alphaEnable = a
    true

  --- sets alpha for when the control is disabled.
  -- @tparam number a
  setAlphaDisable: (a) =>
    if @alphaDisable == nil then return false
    @alphaDisable = a
    true

  --- sets the text font color.
  -- @tparam table color
  setFontColor: (color) =>
    if @fontColor == nil then return false
    @fontColor = color
    true


EventMixins = class

--- sets the onClick callback.
  -- @tparam function cb
  onClick: (cb) =>
    @Click = cb

  --- sets the onHover callback.
  -- @tparam function cb
  onHover: (cb) =>
    @Hover = cb

  --- sets the onLeave callback.
  -- @tparam function cb
  onLeave: (cb) =>
    @Leave = cb

  --- sets the onAfterClick callback.
  -- @tparam function cb
  onAfterClick: (cb) =>
    @aClick = cb

  -- @local
  onMouseEnter: =>
    Mouse = love.mouse
    if @Hover
      @Hover!
    @isHovred = true
    if Mouse.getSystemCursor "hand"
      Mouse.setCursor(Mouse.getSystemCursor("hand"))

  -- @local
  onMouseLeave: =>
    Mouse = love.mouse
    if @Leave
      @Leave!
    @isHovred = false
    Mouse.setCursor!

  -- @local
  onMouseDown: (x, y) =>
    if @Click
      @Click!
    @isPressed = true

  -- @local
  onMouseUp: (x, y) =>
    if @aClick
      @aClick!
    @isPressed = false


KeyboardMixins = class
  isCtrlDown: =>
    if love._os == "OS X"
      return Keyboard or Keyboard.isDown("rgui")
    return Keyboard.isDown("lctrl") or Keyboard.isDown("rctrl")

  keyboardIsDown: (...) =>
    Keyboard.isDown(...)


ThemeMixins = class
  getTheme: => assert(require(MeowUI.root .. "Controls.Style"))[MeowUI.theme]

{ :ColorMixins, :EventMixins, :KeyboardMixins, :ThemeMixins}
