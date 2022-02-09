----
-- A control class
-- @classmod Control
-- @usage c = Control!


Utils      = assert require MeowUI.cwd .. "Core.Utils"
Event      = assert require MeowUI.cwd .. "Core.Event"
Box        = assert require MeowUI.cwd .. "Core.Box"
Circle     = assert require MeowUI.cwd .. "Core.Circle"
Chrono     = assert require MeowUI.cwd .. "Core.Chrono"

BBoxs = {
  Box: Box
  Circle: Circle
  Polygon: Chrono
}

class Control
  --- constructor
  -- @tparam string boxT Bounding box type[Box, Circle]
  new: (boxT = "Box") =>
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
    @chrono = nil
    @onTimerDone = nil
    @radius = nil
    @alwaysUpdate = true
    @boundingBox = BBoxs[boxT]!


  --- getter for the root control.
  -- @treturn Control root
  getRoot: =>
    @@root

  --- getter for the boundingbox.
  -- @treturn table boundingBox
  getBoundingBox: =>
    @boundingBox

  -- @local
  needConforming: =>
    @requireConform = true

  --- converts a local position to window position.
  -- @tparam number x
  -- @tparam number y
  -- @treturn table boundingBox
  localToGlobal: (x = 0, y = 0) =>
    x += @x
    y += @y

    if @parent then
      x , y = @parent\localToGlobal(x , y)

    return x, y

  --- converts a window position to local position.
  -- @tparam number x
  -- @tparam number y
  -- @treturn table boundingBox
  globalToLocal: (x = 0, y = 0) =>
    x -= @x
    y -= @y

    if @parent
      x, y = @parent\globalToLocal x, y

    x, y

  --- conform the boundingbox size/pos to the content entity.
  -- @local
  conform: =>
    if not @requireConform then return
    x, y = @localToGlobal!
    w = @width * @anchorX
    h = @height * @anchorY
    @worldX = x - w
    @worldY = y - h

    box = @boundingBox
    if box.__class == Box
      with box
        \setPosition @worldX, @worldY
        \setSize @worldX + @width, @worldY + @height
    elseif box.__class == Circle
      with box
        \setPosition @worldX, @worldY
        \setRadius @radius

    for k = 1, #@children
      @children[k]\needConforming true
      @children[k]\conform!

    @needConforming false

  -- @local
  hitTest: (x, y) =>
    if not @getBoundingBox!\contains x, y then return nil

    if @childrenEnabled
      for k = 1, #@children
        control = @children[k]
        hitControl = control\hitTest x, y
        if hitControl then return hitControl

    if @enabled then return @
    return nil

  --- setter for the content parent.
  -- @tparam Content p
  setParent: (p) =>
    @parent = p
    @needConforming true

  --- getter for the content parent.
  -- @treturn Content p
  getParent: =>
    @parent

  -- @local
  sortChildren: =>
    table.sort @children, (a, b) ->
      a.depth < b.depth

  --- setter for the content depth.
  -- @tparam number depth
  setDepth: (depth) =>
    @depth = depth
    if @parent then @parent\sortChildren!

  -- @local
  childExists: (id) =>
    for k = 1, #@children
      if @children[k].id == id then return true
    false

  --- attach a a child to the content entity.
  -- @tparam Content child
  -- @tparam number depth
  addChild: (child, depth) =>
    assert (child.__class.__parent == Control) or (child.__class == Control),
      "child must be Control or a subclass of Control."

    if @childExists child.id then return

    @children[#@children + 1] = child
    child\setParent self

    if depth then child\setDepth depth
    events = child.events
    events\dispatch events\getEvent "UI_ON_ADD"

  --- setter for the content anchor.
  -- @tparam number x
  -- @tparam number y
  setAnchor: (x, y) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."

    @anchorX, @anchorY = x, y
    @needConforming true

  --- getter for the content anchor.
  -- @treturn table anchor
  getAnchor: =>
    @anchorX, @anchorY


  --- setter for the content anchorX.
  -- @tparam number x
  setAnchorX: (x) =>
    assert type(x) == 'number',
      "x must be of type number."
    @anchorX = x
    @needConforming true

  --- getter for the content anchorX.
  -- @treturn number anchorX
  getAnchorX: =>
    @anchorX

  --- setter for the content anchorY.
  -- @tparam number y
  setAnchorY: (y) =>
    assert type(y) == 'number',
      "y must be of type number."
    @anchorX = y
    @needConforming true

  --- getter for the content anchorY.
  -- @treturn number anchorY
  getAnchorY: =>
    @anchorY

  --- setter for the content position.
  -- @tparam number x
  -- @tparam number y
  setPos: (x, y) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."

    @x, @y = x, y
    @needConforming true
    @events\dispatch @events\getEvent "UI_MOVE"

  --- getter for the content position.
  -- @treturn table position
  getPos: =>
    @x, @y

  --- setter for the content x position.
  -- @tparam number x
  setX: (x)=>
    assert type(x) == 'number',
      "x must be of type number."

    @x = x
    @needConforming true

  --- getter for the content x position.
  -- @treturn number x
  getX: =>
    @x

  --- setter for the content y position.
  -- @tparam number y
  setY: (y)=>
    assert type(y) == 'number',
      "y must be of type number."

    @y = y
    @needConforming true

  --- getter for the content y position.
  -- @treturn number y
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

  --- setter for the content width.
  -- @tparam number w
  setWidth: (w) =>
    assert type(w) == 'number',
      "w must be of type number."
    @width = w
    @needConforming true

  --- setter for the content height.
  -- @tparam number h
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

  --- setter for the control enabled property.
  -- @tparam boolean enabled
  setEnabled: (enabled) =>
    @enabled = enabled

  --- getter for the control enabled property.
  -- @treturn boolean enabled
  isEnabled: =>
    @enabled

  --- setter for the control childrenEnabled property.
  -- @tparam boolean enabled
  setChildrenEnabled: (enabled) =>
    @childrenEnabled = enabled

  --- getter for the control childrenEnabled property.
  -- @treturn boolean childrenEnabled
  isChildrenEnabled: =>
    @childrenEnabled

  --- setter for the control depth.
  -- @tparam number depth
  setDepth: (depth) =>
    @depth = depth
    if @parent then @parent\sortChildren!

  --- getter for the control depth.
  -- @treturn number depth
  getDepth: =>
    @depth

  --- remove an attached child.
  -- @tparam number id
  removeChild: (id) =>
    for i = 1, #@children
      if @children[i].id == id
        @children[i] = nil
        child.events\dispatch child.events\getEvent "UI_ON_REMOVE"
        break

  --- drops the control children.
  dropChildren: =>
    @children = {}

  --- disables the control children.
  disableChildren: =>
    for i = 1, #@children do @children[i]\setEnabled false

  --- enables the control children.
  enableChildren: =>
    for i = 1, #@children do @children[i]\setEnabled true

  -- getter for the control children.
  getChildren: =>
    @children

  --- attaches a handler to an event.
  -- @see Event
  on: (event, callback, target) =>
    assert type(event) == 'string',
      "event must be of type string."
    assert type(callback) == 'function',
      "callback must be of type function."
    assert target.__class.__parent == Control,
      "target must be a subclass of Control."

    @events\on @events\getEvent(event), callback, target

  -- adds a chrono to the control.
  -- @tparam number duration
  -- @tparam function onDone
  addChrono: (duration, onDone) =>
    chrono = Chrono.getInstance!
    if not @chrono
      @chrono = chrono\create duration, onDone

  -- @local
  updateChildren: (dt) =>
    for i = 1, #@children
      @children[i]\update dt

  -- @local
  drawChildren: =>
    for i = 1, #@children
      @children[i]\draw!

  --- updates the control.
  -- @tparam number dt
  update: (dt) =>
    if @visible == false
      if @alwaysUpdate == false then return
    Chrono.getInstance!\update self, dt
    @conform!
    @events\dispatch @events\getEvent("UI_UPDATE"), dt
    @updateChildren dt

  --- sets alwaysUpdate (If false it will prevent the control from updating if visible is false).
  -- @tparam boolean bool
  setAlwaysUpdate: (bool) =>
    @alwaysUpdate = bool

  --- sets visible.
  -- @tparam boolean bool
  setVisible: (bool) =>
    @visible = bool

  --- draws the control.
  draw: =>
    if @visible == false then return
    @events\dispatch @events\getEvent("UI_DRAW")
    @drawChildren!




