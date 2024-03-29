----
-- A debug class
-- @classmod Debug
-- @usage c = Debug!

MeowUI = MeowUI
love = love

Singleton = assert require MeowUI.cwd .. "Core.Singleton"
Graphics  = love.graphics

class Debug extends Singleton

  --- constructor.
  new: =>
    -- Will hold the currently hovered control
    @focusedControl = nil
    -- Pos
    @x, @y = 5, 40

    -- Font
    @font = Graphics.newFont 9

    -- Color
    @outlineColor = {1, 0, 0, 1}
    @boxColor = {0, 0, 0, 0.78431372549}
    @palette = {
      red: {1, 0, 0, 1}
      blue: {0, 0.8, 1, 1}
      green: {0, 1, 0, 1}
      white: {1, 1, 1, 1}
    }

  watch: (control) =>
    if control == nil then return
    if @focusControl == nil then @focusControl = control
    if control.id ~= @focusControl.id
      @focusControl = control
      @focusControlType = control.boundingBox.__class.__name

  draw: =>
    Timer = love.timer
    delta = Timer.getDelta!
    fps = Timer.getFPS!
    loveV = love._version
    libV = MeowUI.version
    stage = MeowUI.stage

    -- Control outline
    if @focusControl
      r, g, b, a = Graphics.getColor!
      oldLineWidth = Graphics.getLineWidth!

      box = @focusControl\getBoundingBox!
      switch @focusControlType
        when "Box"
          Graphics.setLineWidth 2
          Graphics.setColor @outlineColor
          Graphics.rectangle 'line', box\getX!, box\getY!, box\getWidth!, box\getHeight!
        when "Circle"
          Graphics.setLineWidth 2
          Graphics.setColor @outlineColor
          Graphics.circle 'line', box\getX!, box\getY!, box\getRadius!
        when  "Polygon"
          Graphics.setLineWidth 2
          Graphics.setColor @outlineColor
          Graphics.polygon "line", box\getVertices!

      Graphics.setLineWidth oldLineWidth
      Graphics.setColor r, g, b, a

    -- debug view
    oldFont = Graphics.getFont!
    r, g, b, a = Graphics.getColor!

    Graphics.setFont @font
    Graphics.setColor @boxColor

    Graphics.rectangle 'fill', @x, @y, 165, 234
    Graphics.setColor @palette.blue
    Graphics.print "MeowUI [" .. libV .. " - " .. stage .. "]", @x + 18, @y + 5
    Graphics.setColor @palette.white
    Graphics.print "LOVE Version [" .. loveV.. "]", @x + 35, @y + 20
    Graphics.line @x, @y + 40, @x + 165, @y + 40
    Graphics.print "FPS: " ..fps, @x + 5, @y + 45
    Graphics.print "Delta: " .. delta, @x + 5, @y + 60
    Graphics.print "MEM (KB): " .. collectgarbage('count'), @x + 5, @y + 75

    -- Control info
    controlInfo = (focusControl) ->
      cy = 0
      local pname
      if @focusControl.boxType == "Polygon" then cy = 160
      else cy = 148
      parent = focusControl\getParent!
      if parent == nil then pname = "Control"
      else pname = parent.__name or "Control"
      Graphics.print "Parent: " .. pname, @x + 10, @y + cy
      Graphics.print "Depth: " .. focusControl.depth, @x + 10, @y + cy + 12
      Graphics.print "#Children: " .. #focusControl.children, @x + 10, @y + cy + 24
      Graphics.print "isClipped: " .. tostring(focusControl\getClip!), @x + 10, @y + cy + 36
      Graphics.print "isVisible: " .. tostring(focusControl\getVisible!), @x + 10, @y + cy + 48


    Graphics.setColor @palette.green
    if @focusControl
      wh = Graphics.getHeight!
      Graphics.setColor @boxColor
      Graphics.rectangle 'fill', 0, wh - 20, 230, 20
      Graphics.setColor @palette.white
      Graphics.print "id: " .. @focusControl.id, 5, wh - 15
      Graphics.setColor @palette.blue
      Graphics.rectangle 'line', @x + 5, @y + 95, 155, 134
      className = @focusControl.__name or @focusControl.__class.__name
      box = @focusControl\getBoundingBox!
      Graphics.setColor @palette.white
      if @focusControl.label
        Graphics.print @focusControl.label .. ": " .. className, @x + 10, @y + 100
      else  
        Graphics.print "Class: " .. className, @x + 10, @y + 100
      Graphics.print "Box_type: " .. @focusControl.boxType, @x + 10, @y + 112
      Graphics.print "Pos: " .. box\getX! .. ", " .. box\getY!, @x + 10, @y + 124
      switch @focusControl.boxType
        when "Box"
          Graphics.print "Size (w|h): " .. @focusControl\getWidth! .. ", " .. @focusControl\getHeight!, @x + 10, @y + 136
          controlInfo @focusControl
        when "Polygon"
          Graphics.print "Radius: " .. @focusControl\getRadius!, @x + 10, @y + 136
          Graphics.print "#Vertices: " .. #@focusControl\getBoundingBox!\getVertices!/2, @x + 10, @y + 148
          controlInfo @focusControl
        when "Circle"
          Graphics.print "Radius: " .. @focusControl\getRadius!, @x + 10, @y + 136
          controlInfo @focusControl



    Graphics.setFont oldFont
    Graphics.setColor r, g, b, a

    

return Debug.getInstance!