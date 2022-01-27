----
-- A control class
-- @classmod Control
-- @usage c = Control!


Utils      = assert require MeowUI.cwd .. "Core.Utils"
Event      = assert require MeowUI.cwd .. "Core.Event"
Box        = assert require MeowUI.cwd .. "Core.Box"
Circle     = assert require MeowUI.cwd .. "Core.Circle"
Chrono     = assert require MeowUI.cwd .. "Core.Chrono"

Tremove = table.remove

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

  globalToLocal: (x = 0, y = 0) =>
    x = x - @x
    y = y - @y

    if @parent
      x, y = @parent\globalToLocal x, y

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

  getParent: =>
    @parent

  sortChildren: =>
    table.sort @children, (a, b) ->
      a.depth < b.depth

  setDepth: (depth) =>
    @depth = depth
    if @parent then @parent\sortChildren!

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

  setAnchor: (x, y) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."

    @anchorX, @anchorY = x, y
    @needConforming true


  getAnchor: =>
    @anchorX, @anchorY


  setAnchorX: (x) =>
    assert type(x) == 'number',
      "x must be of type number."
    @anchorX = x
    @needConforming true

  getAnchorX: =>
    @anchorX

  setAnchorY: (y) =>
    assert type(y) == 'number',
      "y must be of type number."
    @anchorX = y
    @needConforming true

  getAnchorY: =>
    @anchorY

  setPos: (x, y) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."

    @x, @y = x, y
    @needConforming true
    @events\dispatch @events\getEvent "UI_ON_ADD"

  getPos: =>
    @x, @y

  setX: (x)=>
    assert type(x) == 'number',
      "x must be of type number."

    @x = x
    @needConforming true

  getX: =>
    @x

  setY: (y)=>
    assert type(y) == 'number',
      "y must be of type number."

    @y = y
    @needConforming true

  getY: =>
    @y

  --- getter for the control size.
  -- @treturn table
  getSize: =>
    @w, @h

  --- getter for the control width.
  -- @treturn number
  getWidth: =>
    @width

  --- getter for the control height.
  -- @treturn number
  getHeight: =>
    @height

  setWidth: (w) =>
    assert type(w) == 'number',
      "w must be of type number."
    @width = w
    @needConforming true

  setHeight: (h) =>
    assert type(h) == 'number',
      "h must be of type number."
    @height = h
    @needConforming true

  --- setter for the control size.
  -- @tparam number width
  -- @tparam number height
  setSize: (width, height) =>
    assert (type(width) == 'number') and (type(height) == 'number'),
      "width and height must be of type number."

    @width, @height = width, height
    @needConforming true


  setEnabled: (enabled) =>
    @enabled = enabled

  isEnabled: =>
    @enabled

  setChildrenEnabled: (enabled) =>
    @childrenEnabled = enabled

  isChildrenEnabled: =>
    @childrenEnabled

  setDepth: (depth) =>
    @depth = depth
    if @parent then @parent\sortChildren!

  getDepth: =>
    @depth

  removeChild: (id) =>
    for i, child in ipairs @children
      if child.id == id
        Tremove @children, i
        child.events\dispatch child.events\getEvent "UI_ON_REMOVE"
        break

  dropChildren: =>
    @children = {}

  disableChildren: =>
    for _, child in ipairs @children do child\setEnabled false

  enableChildren: =>
    for _, child in ipairs @children do child\setEnabled true

  getChildren: =>
    @children

  on: (event, callback, target) =>
    assert type(event) == 'string',
      "event must be of type string."
    assert type(callback) == 'function',
      "callback must be of type function."
    assert target.__class.__parent == Control,
      "target must be a subclass of Control."

  addTimer: (duration, onDone) =>
    chrono = Chrono.getInstance!
    if not @chrono
      @chrono = chrono\create duration, onDone

  updateChildren: (dt) =>
    for _, child in ipairs @children
      child\update dt

  drawChildren: =>
    for _, child in ipairs @children
      child\draw!

  update: (dt) =>
    Chrono.getInstance!\update self, dt
    @conform!
    @events\dispatch @events\getEvent "UI_UPDATE", dt
    @updateChildren dt

  draw: =>
    if not @visible then return
    @events\dispatch @events\getEvent "UI_DRAW"
    @drawChildren!




