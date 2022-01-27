----
-- A control class
-- @classmod Control
-- @usage c = Control!


Utils      = assert require MeowUI.cwd .. "Core.Utils"
Event      = assert require MeowUI.cwd .. "Core.Event"
Box        = assert require MeowUI.cwd .. "Core.Box"
Circle     = assert require MeowUI.cwd .. "Core.Circle"
Chrono     = assert require MeowUI.cwd .. "Core.Chrono"

class Control
  @root: {}
  new: (boxT) =>
    @id = Utils.Uid!
    @x = 0
    @y = 0
    @anchorX = 0
    @anchorY = 0
    @width = 0
    @height = 0
    @depth = 0
    @children = {}
    @parent = nil
    @visible = true
    @enabled = false
    @childrenEnabled = true
    @events = Event!
    @requireConform = false
    @worldX = 0
    @worldY = 0
    @timer = nil
    @onTimerDone = nil
    @radius = nil

    if boxT == 'Box'
      @boundingBox = Box!
    elseif boxT == 'Circle'
      @boundingBox = Circle!


  getRoot: =>
    @@root

  getBoundingBox: =>
    @boundingBox

  needConforming: (f) =>
    @requireConform = f

  localToGlobal: (x = 0, y = 0) =>
    x = x + @x
    y = y + @y

    if @parent
      x, y = @parent\localToGlobal x, y

    x, y


  conform: =>
    if not @requireConform then return
    x, y = @localToGlobal!
    w, h = @width * @anchorX, @height * @anchorY
    @worldX, @worldY = x - w, y - h
    box = @boundingBox

    if box.__class == Box
      with box
        \setPosition @worldX, @worldX
        \setSize @worldX + @width, @worldY + @height
    elseif box.__class == Circle
      with box
        \setPosition @worldX, @worldX
        \setRadius @radius

    for _, child in ipairs @children
      with child
        \needConforming true
        \conform!

    @needConforming false


  hitTest: (x, y) =>
    if not @getBoundingBox!\contains x, y then return nil

    if @childrenEnabled
      for id, _ in ipairs @children
        control = @children[id]
        hitControl = control\hitTest x, y
        if hitControl then return hitControl

    if @enabled then return @
    return nil

  setParent: (p) =>
    @parent = p
    @needConforming true

  --- TODO
  setDepth: (depth) =>
    @depth = depth
    if @parent then return --@parent\sortChildren!

  childExists: (id) =>
    for _, child in ipairs @children
      if child.id == id then return true
    false

  addChild: (child, depth) =>
    assert child.__class.__parent == Control,
      "child must be a subclass of Control."
    assert type(depth) == 'number',
      "depth must be of type number."

    if @childExists child.id then return

    @children[#@children + 1] = child
    @setParent self

    if depth then child\setDepth depth
    events = child.events
    events\dispatch events\getEvent "UI_ON_ADD"








  --@root: Control!
