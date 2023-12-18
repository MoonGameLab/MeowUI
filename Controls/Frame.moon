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
    @toolBarTitleColor = t.frame.toolBarTitleColor
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
    @on "UI_CLICK", @onClick, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_ON_ADD", @onAdd, @

    @addChild @closeBtn
    @setDrag true
    @setMakeTopWhenClicked true

    @setToolBarTitle label, math.ceil(@toolBarHeight/2)

  onDraw: =>
    drawToolBar @
    
    box = @getBoundingBox!
    r, g, b, a = Graphics.getColor!
    boxW, boxH = box\getWidth!, box\getHeight!

    Graphics.setColor @toolBarTitleColor
    Graphics.draw @toolBarTitle, box.x + @titleOffSet, box.y + @titleOffSet

    Graphics.setColor @backgroundColor
    Graphics.rectangle "fill", box.x, box.y + @toolBarHeight, boxW, boxH - @toolBarHeight, @rx, @ry
  
    Graphics.setColor r, g, b, a


  setSize: (w, h) =>
    super w, h

    @closeBtn\setPosition w - 20, 6

  setPosition: (x, y) =>
    super x, y

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

  onAdd: =>
    manager\setFocus @
    @onFocus!

  onClick: =>
    manager\setFocus @
    @onFocus!
    
  setToolBarTitle: (text = @text, size = 15, font) =>
    if size and font
      if type(font) == "number" then @font = Graphics.newFont font
      if type(font) == "string" then @font = Graphics.newFont font, size
      @toolBarTitle = Graphics.newText @font, text
    if size
      @font = Graphics.newFont size
      @toolBarTitle = Graphics.newText @font, text

    @titleOffSet = math.floor ((@toolBarHeight-1) / 2) - (size/2)


Frame