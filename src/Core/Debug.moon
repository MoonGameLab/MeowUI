----
-- A debug class
-- @classmod Debug
-- @usage c = Debug!

Singleton = assert require MeowUI.cwd .. "Core.Singleton"
Graphics = love.graphics

class Debug extends Singleton

  --- constructor.
  new: =>
    -- Will hold the currently hovered control
    @focusedControl = nil
    -- Pos
    @x, @y = 5, 40

    -- Font
    @font = Graphics.newFont 10

    -- Color
    @color = {1, 0, 0, 1}

  watch: (control) =>
    if control == nil then return
    if @focusControl == nil then @focusControl = control
    if control.id ~= @focusControl.id
      @focusControl = control
      @focusControlType = control.boundingBox.__class.__name

  draw: =>
    Timer = love.timer
    fps = Timer.getFPS!
    delta = Timer.getDelta!
    loveV = love._version
    libV = MeowUI.version
    stage = MeowUI.stage

    if @focusControl
      r, g, b, a = Graphics.getColor!
      oldLineWidth = Graphics.getLineWidth!

      box = @focusControl\getBoundingBox!
      switch @focusControlType
        when "Box"
          Graphics.setLineWidth 2
          Graphics.setColor @color
          Graphics.rectangle 'line', box\getX!, box\getY!, box\getWidth!, box\getHeight!

      Graphics.setLineWidth oldLineWidth
      Graphics.setColor r, g, b, a
    
    

return Debug.getInstance!