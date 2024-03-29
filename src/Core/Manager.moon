----
-- A Manager class (extends @{Singleton})
-- @classmod Manager
-- @usage m = Manager.getInstance!

MeowUI = MeowUI
love = love

Root = assert require MeowUI.cwd .. "Core.Root"
Singleton = assert require MeowUI.cwd .. "Core.Singleton"
DEBUG = assert require MeowUI.cwd .. "Core.Debug"
Timer = love.timer
Mouse = love.mouse
Chrono     = assert require MeowUI.cwd .. "Core.Chrono"

-- @local
debug = (hitControl) ->
  if hitControl and hitControl._d
    DEBUG\watch hitControl -- TODO: change it to use focusedControl
    return nil
  else
    DEBUG\watch hitControl
    return hitControl

class Manager extends Singleton

  -- @local
  @dispatch: (control, name, ...) =>
    control.events\dispatch control.events\getEvent(name),
      ...
    if control\getNotifyParent!
      p = control\getParent!
      @notify p, name, ...


  --- constructor.
  new: =>
    @rootControl = Root!
    @rootControl\setEnabled true
    @hoverControl = nil
    @focusControl = nil
    @holdControl = nil
    @lastClickControl = nil
    @lastClickTime = Timer.getTime!

  --- getter for the root control.
  getRoot: =>
    @rootControl

  --- updates the manager.
  -- @tparam number dt
  update: (dt) =>
    -- if @focusControl then print @focusControl\getId!
    Chrono.getInstance!\update dt
    if @rootControl then @rootControl\update dt
    if @focusControl and @focusControl.updateWhenFocused
      @@dispatch @focusControl, "UI_UPDATE", dt

  --- draws the manager.
  draw: =>
    if @rootControl then @rootControl\draw!
    if MeowUI.debug then DEBUG\draw!

  --- callback function triggered when the mouse is moved.
  -- @tparam number x
  -- @tparam number y
  -- @tparam number dx
  -- @tparam number dy
  mousemoved: (x, y, dx, dy) =>
    if not @rootControl then return

    hitControl = @rootControl\hitTest x, y
    MeowUI.hoveredControl = hitControl

    if MeowUI.debug
      hitControl = debug hitControl

    if hitControl ~= @hoverControl
      if @hoverControl then @@dispatch @hoverControl, "UI_MOUSE_LEAVE"

      @hoverControl = hitControl

      if hitControl then @@dispatch hitControl, "UI_MOUSE_ENTER"

    if @holdControl then @@dispatch @holdControl, "UI_MOUSE_MOVE", x, y, dx, dy
    else
      if @hoverControl then @@dispatch @hoverControl, "UI_MOUSE_MOVE", x, y, dx, dy

  --- focuse on given control.
  -- @tparam Control control
  setFocus: (control) =>
    if @focusControl == control then return

    if @focusControl
      @@dispatch @focusControl, "UI_UN_FOCUS"
      @focusControl\rollBackDepth!
      @focusControl\setFocused false

    @focusControl = control
    if control\getMakeTopWhenClicked! then control\makeTop!

    if @focusControl
      @@dispatch @focusControl, "UI_FOCUS"
      @focusControl\setFocused true

  -- @local
  notify: (control, name) =>
    switch name
      when "UI_FOCUS"
        control\setFocused true
      when "UI_UN_FOCUS"
        control\setFocused false

  --- callback function triggered when a mouse button is pressed.
  -- @tparam number x
  -- @tparam number y
  -- @tparam number button
  -- @tparam boolean isTouch
  mousepressed: (x, y, button, isTouch) =>
    if not @rootControl then return

    hitControl = @rootControl\hitTest x, y
    MeowUI.clickedControl = hitControl

    if MeowUI.debug then hitControl = debug hitControl

    if hitControl
      @@dispatch hitControl, "UI_MOUSE_DOWN", x, y, button, isTouch
      @holdControl = hitControl
      
    if hitControl
      if hitControl\getFocusEnabled! then @setFocus hitControl
    else
      @setFocus @focusControl

  --- callback function triggered when a mouse button is released.
  -- @tparam number x
  -- @tparam number y
  -- @tparam number button
  -- @tparam boolean isTouch
  mousereleased: (x, y, button, isTouch) =>
    if @holdControl
      @@dispatch @holdControl, "UI_MOUSE_UP", x, y, button, isTouch
      if @rootControl

        hitControl = @rootControl\hitTest x, y
        MeowUI.releasedControl = hitControl

        if MeowUI.debug then hitControl = debug hitControl

        if hitControl == @holdControl
          if @lastClickControl and
            @lastClickControl == @holdControl and
            (Timer.getTime! - @lastClickTime <= 0.4)

            @@dispatch @holdControl, "UI_DB_CLICK", @holdControl, x, y
            @lastClickControl = nil
            @lastClickTime = 0
          else

            @@dispatch @holdControl, "UI_CLICK", @holdControl, x, y
            @lastClickControl = @holdControl
            @lastClickTime = Timer.getTime!

      @holdControl = nil

  --- callback function triggered when the mouse wheel is moved.
  -- @tparam number x
  -- @tparam number y
  wheelmoved: (x, y) =>
    hitControl = @rootControl\hitTest Mouse\getX!, Mouse\getY!
    MeowUI.wheeledControl = hitControl

    if MeowUI.debug then hitControl = debug hitControl

    while hitControl
      @mousemoved Mouse\getX!, Mouse\getY!, 0, 0
      if @@dispatch hitControl, "UI_WHELL_MOVE", x, y then return
      hitControl = hitControl\getParent!

  --- callback function triggered when a key is pressed.
  -- @tparam KeyConstant key
  -- @tparam scancode scancode
  -- @tparam boolean isrepeat
  keypressed: (key, scancode, isrepeat) =>
    if key == "f1" then MeowUI.debug = not MeowUI.debug
    if @focusControl then @@dispatch @focusControl, "UI_KEY_DOWN", key, scancode, isrepeat

  --- callback function triggered when a keyboard key is released.
  -- @tparam KeyConstant key
  keyreleased: (key) =>
    if @focusControl then @@dispatch @focusControl, "UI_KEY_UP", key

  --- called when text has been entered by the user.
  -- @tparam string text
  textinput: (text) =>
    if @focusControl then @@dispatch @focusControl, "UI_TEXT_INPUT", text

  --- resize the root control
  -- @tparam number w
  -- @tparam number h
  resize: (w, h) =>
    @rootControl\resize w, h


Manager.getInstance!
