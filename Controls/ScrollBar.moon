Graphics = love.graphics
Control = MeowUI.Control
Button = assert require MeowUI.c_cwd .. "Button"


class ScrollBar extends Control
  new: (type) =>
    super "Box", "ScrollBar"

    @bar = Button type

    @setEnabled true

    t = assert(require(MeowUI.root .. "Controls.Style"))[MeowUI.theme]
    style = t.scrollBar
    @setSize style.width, style.height
    @bar\setSize style.width, style.width
    @backgroundColor = t.colors.scrollBar
    @alpha = 1

    --@on "UI_MOUSE_DOWN", @onBarDown, @
    --@on "UI_MOUSE_MOVE", @onBarMove, @
    --@on "UI_MOUSE_UP", @onBarUp, @
    --@on "UI_MOUSE_DOWN", @onBgDown, @
    @on "UI_DRAW", @onDraw, @

    @addChild @bar
    
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
