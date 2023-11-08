love     = love
MeowUI   = MeowUI
Graphics = love.graphics
Control  = MeowUI.Control
Button   = assert require MeowUI.c_cwd .. "Button"
Mixins   = assert require MeowUI.root .. "Controls.mx"

class ScrollBar extends Control
  
  @include Mixins.ThemeMixins

  new: (type) =>
    super "Box", "ScrollBar"

    @bar = Button type

    @setEnabled true

    t = @getTheme!
    style = t.scrollBar
    @bar\setSize style.width, style.width
    @backgroundColor = t.colors.scrollBar
    @alpha = 1
    @dir = "vertical"
    @ratio = 5
    @barPosRation = 0
    @barDown = false
    @setSize style.width, style.height


    @on "UI_MOUSE_DOWN", @onBarDown, @
    @on "UI_MOUSE_MOVE", @onBarMove, @
    @on "UI_MOUSE_UP",   @onBarUp,   @
    @on "UI_MOUSE_DOWN", @onBgDown,  @
    @on "UI_DRAW",       @onDraw,    @

    @addChild @bar

    @bar\on "UI_MOUSE_DOWN", @onBarDown, @bar\getParent!
    @bar\on "UI_MOUSE_UP",   @onBarUp,   @bar\getParent!
    @bar\on "UI_MOUSE_MOVE", @onBarMove, @bar\getParent!
    @bar\on "UI_MOUSE_DOWN", @onBgDown,  @bar\getParent!

    @reset!

  onDraw: =>
    box = @getBoundingBox!
    x, y = box\getPosition!
    width, height = box\getSize!

    r, g, b, a = Graphics.getColor!
    color = @backgroundColor
    color[4] = color[4] or @alpha

    Graphics.setColor color
    Graphics.rectangle "fill", x, y, width, height
    Graphics.setColor r, g, b, a

  onBarDown: =>
    @barDown = true

  onBarUp: =>
    @barDown = false

  setBarPos: (ratio) =>
    if ratio < 0 then ratio = 0
    if ratio > 1 then ratio = 1

    @barPosRation = ratio

    if @dir == "vertical"
      @bar\setX 0
      @bar\setY (@getHeight! - @bar\getHeight!) * ratio
    else
      @bar\setX (@getWidth! - @bar\getWidth!) * ratio
      @bar\setY 0

    @events\dispatch @events\getEvent("UI_ON_SCROLL"), ratio


  onBarMove: (x, y, dx, dy) =>
    if @barDown == false then return


    bar = @bar

    if @dir == "vertical"
      after = bar\getY! + dy
      if after < 0 then after = 0
      elseif after + bar\getHeight! > @getHeight! then after = @getHeight! - bar\getHeight!
      @barPosRation = after / (@getHeight! - bar\getHeight!)
    else
      after = bar\getX! + dx
      if after < 0 then after = 0
      elseif after + bar\getWidth! > @getWidth! then after = @getWidth! - bar\getWidth!
      @barPosRation = after / (@getWidth! - bar\getWidth!)

    @setBarPos @barPosRation

  onBgDown: (x, y) =>
    x, y = @globalToLocal x, y

    if @dir == "vertical" then @setBarPos y / @getHeight!
    else @setBarPos x / @getWidth!

  reset: =>
    ratio = @ratio
    if @dir == "vertical"
      @bar\setWidth @getWidth!
      @bar\setHeight @getHeight! / ratio
    else
      @bar\setWidth @getWidth! / ratio
      @bar\setHeight @getHeight!
    @setBarPos @barPosRation


  setDir: (dir) =>
    @dir = dir
    @reset!

  getDir: =>
    @dir

  -- Override
  setSize: (width, height) =>
    super width, height
    @reset!

  -- Override
  setWidth: (width) =>
    super width
    @reset!

  --Override
  setHeight: (height) =>
    super height
    @reset!

  getBar: =>
    @bar

  getBarPos: =>
    @barPosRation




