Button = assert require MeowUI.c_cwd .."Button"
Content = assert require MeowUI.c_cwd .."Content"

manager = MeowUI.manager
Graphics = love.graphics


drawToolBar = =>
  box = @getBoundingBox!
  r, g, b, a = Graphics.getColor!
  boxW = box\getWidth!
  
  local _toolBarColor
  if @focused
    _toolBarColor = @toolBarColor
  else
    _toolBarColor = @toolBarColorUnfocused

  Graphics.setColor _toolBarColor
  Graphics.rectangle "fill", box.x, box.y, boxW, @toolBarHeight, @rx, @ry
  Graphics.setColor @backgroundColor
  Graphics.rectangle "line", box.x, box.y, boxW, @toolBarHeight, @rx, @ry
  
  Graphics.setColor r, g, b, a


class Frame extends Content


  new: (label, vbar, hbar) =>
    super label, vbar, hbar, false

    @toolBarHeight = 26

    -- colors
    t = @getTheme!

    @toolBarColor = t.frame.toolBarColor
    @toolBarColorUnfocused = t.frame.toolBarColorUnfocused
    @backgroundColor = t.frame.contentBackground

    @closeBtn = Button "Box"

    with @closeBtn
      \setLabel "Frame_closeBtn"
      \setSize 18, 18
      \setImage MeowUI.assets .. "cross.png", true
      \setStroke 0
      \setNotifyParent true
      \onClick ->
        @destruct MeowUI.manager\getRoot!

    @on "UI_DRAW", @onDraw, @
    @on "UI_FOCUS", @onFocus, @
    @on "UI_UN_FOCUS", @onUnFocus, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @

    @addChild @closeBtn
    @setDrag true
    @setMakeTopWhenClicked true

  onDraw: =>
    drawToolBar @
    
    box = @getBoundingBox!
    r, g, b, a = Graphics.getColor!
    boxW, boxH = box\getWidth!, box\getHeight!

    Graphics.setColor @backgroundColor
    Graphics.rectangle "fill", box.x, box.y + @toolBarHeight, boxW, boxH - @toolBarHeight, @rx, @ry
  
    Graphics.setColor r, g, b, a


  setSize: (w, h) =>
    super w, h

    @closeBtn\setPosition w - 20, 6

  setPosition: (x, y) =>
    super x, y

  addChild: (child) =>
    super child

  onFocus: =>
    @focused = true

  onUnFocus: =>
    @focused = false

  isInsideToolBar: (x, y) =>
    return x >= @getX! and x <= @getX! + @getWidth! and 
      y >= @getY! and y <= @getY! + @toolBarHeight

  onMouseDown: (x, y, btn) =>
    if @isInsideToolBar(x, y) 
      super x, y, btn

  addChild: (child, depth) =>
    child\setNotifyParent true
    super child, depth

Frame