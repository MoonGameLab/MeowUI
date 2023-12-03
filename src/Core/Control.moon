----
-- A control class
-- @classmod Control
-- @usage c = Control!

MeowUI = MeowUI
love = love

Utils      = assert require MeowUI.cwd .. "Core.Utils"
Event      = assert require MeowUI.cwd .. "Core.Event"
Box        = assert require MeowUI.cwd .. "Core.Box"
Circle     = assert require MeowUI.cwd .. "Core.Circle"
Polygon    = assert require MeowUI.cwd .. "Core.Polygon"
Chrono     = assert require MeowUI.cwd .. "Core.Chrono"
Tremove    = table.remove

BBoxs = {
  Box: Box
  Circle: Circle
  Polygon: Polygon
}

class Control

  @@curMaxDepth = 0

  --- constructor.
  -- @tparam string boxT Bounding box type[Box, Circle, Polygon]
  -- @tparam string __name name of the control
  new: (boxT = "Box", __name) =>

    @__name = __name
    @label = nil
    @boxType = boxT
    @id = Utils.Uid!
    @x = 0
    @y = 0
    @anchorX = 0
    @anchorY = 0
    @width = 0
    @height = 0
    @depth = 1
    @children = {}
    @parent = nil
    @visible = true
    @enabled = true
    @childrenEnabled = true
    @events = Event!
    @requireConform = false
    @worldX = 0
    @worldY = 0
    @onTimerDone = nil
    @updateWhenFocused = true
    @radius = 0
    @boundingBox = BBoxs[@boxType]!
    @clip = false
    @notifyParent = false
    @makeTopWhenClicked = false

    @focusEnabled = true

  --- gets control id
  -- @treturn string id
  getId: =>
    @id

  -- @local
  hasMinxins: =>
    rawget(@__class.__parent, "mixinsClass")

  --- get the class where mixins can be inserted.
  -- @treturn table {mixinTable, boolean(If mixin class was created)}
  getMixinsClass: (control) ->
    parent = control.__class.__parent -- The parent class

    assert (parent != nil),
      "The control does not have a parent class."

    if rawget(parent, "mixinsClass") then return parent, false

    mixinsClass = class extends parent
      @__name: "#{control.__name}Mixins"
      @mixinsClass: true

    control.__class.__parent = mixinsClass
    setmetatable control.__class.__base, mixinsClass.__class.__base

    mixinsClass, true

  include: (otherClass) =>
    otherClass, otherClassName = if type(otherClass) == "string"
      assert(require(otherClass)), otherClass

    assert (otherClass.__class != Control) and (otherClass.__class.__parent != Control),
      "Control is including a class that is or extends Control. An included class should be a plain class and not another control."

    mixinsClass = @getMixinsClass!

    if otherClass.__class.__parent then @include otherClass.__class.__parent

    assert otherClass.__class.__base != nil, "Expecting a class when trying to include #{otherClassName or otherClass} into #{@__name}"

    for k, v in pairs otherClass.__class.__base
      continue if k\match("^__")
      mixinsClass.__base[k] = v

    true



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
      if @parent\getBoundingBox!.__class.__name == "Box"
        x , y = @parent\localToGlobal(x , y)
      else
        r = @parent\getRadius!
        x , y = @parent\localToGlobal(x - r, y - r)


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
    switch box.__class
      when Box
        with box
          \setPosition @worldX, @worldY
          \setSize @worldX + @width, @worldY + @height
      when Circle
        with box
          \setPosition @worldX, @worldY
          \setRadius @radius
      when Polygon
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
      for i = #@children, 1, -1
        control = @children[i]
        hitControl = control\hitTest x, y
        if hitControl then return hitControl

    if @enabled
      if MeowUI.debug then @_d = false
      return @

    if MeowUI.debug
      @_d = true
      return @

    return nil

  --- setter for the content parent.
  -- @tparam Content p
  setParent: (p) =>
    local _rootParent

    if p 
      if p["__class"]
        if p.__class != Control
          _rootParent = p.__class.__parent
          while _rootParent != Control
            _rootParent = _rootParent.__parent
      else
        error "parent must a class."

    _rootParent = _rootParent or p

    assert (p == nil) or (p.__class == Control) or (_rootParent.__class == Control),
      "parent must be nil or Control or a subclass of Control."

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

  -- @local
  childExists: (id) =>
    for k = 1, #@children
      if @children[k].id == id then return true
    false

  --- attach a a child to the content entity.
  -- @tparam Content child
  -- @tparam number depth
  addChild: (child, depth) =>
    local _rootParent

    if child["__class"]
      if child.__class != Control
        _rootParent = child.__class.__parent
        while _rootParent != Control
          _rootParent = _rootParent.__parent
    else
      error "parent must a class."

    _rootParent = _rootParent or child

    assert (child.__class == Control) or (_rootParent.__class == Control),
      "child must be Control or a subclass of Control."

    assert child\getParent! == nil, "child must be an Orphan Control."


    if @childExists child.id then return

    @children[#@children + 1] = child
    child\setParent self

    if depth then child\setDepth depth
    else child\setDepth @getDepth! + 1
    events = child.events
    events\dispatch events\getEvent "UI_ON_ADD"

    @@curMaxDepth = (child\getDepth! > @@curMaxDepth) and child\getDepth! or @@curMaxDepth

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
  setPosition: (x, y) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."

    @x, @y = x, y
    @needConforming true
    @events\dispatch @events\getEvent "UI_MOVE"

  --- getter for the content position.
  -- @treturn table position
  getPosition: =>
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
    if @boundingBox.__class.__name ~= "Box" then return nil
    @w, @h

  --- getter for the control width.
  -- @treturn number
  getWidth: =>
    @width

  --- getter for the control height.
  -- @treturn number
  getHeight: =>
    if @boundingBox.__class.__name ~= "Box" then return nil
    @height

  --- setter for the content width.
  -- @tparam number w
  setWidth: (w) =>
    if @boundingBox.__class.__name ~= "Box" then return
    assert type(w) == 'number',
      "w must be of type number."
    @width = w
    @needConforming true

  --- setter for the content height.
  -- @tparam number h
  setHeight: (h) =>
    if @boundingBox.__class.__name ~= "Box" then return
    assert type(h) == 'number',
      "h must be of type number."
    @height = h
    @needConforming true

  --- setter for the control size.
  -- @tparam number width
  -- @tparam number height
  setSize: (width, height) =>
    if @boundingBox.__class.__name ~= "Box" then return
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

  --- setter for the control depth property.
  -- @tparam number depth
  setDepth: (depth) =>
    assert (type(depth) == 'number') and (depth > 0), "Depth must be a number and > 0."
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
        child = @children[i]
        @children[i]\setParent nil
        Tremove @children, i
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

    local _rootParent

    if target["__class"]
      if target.__class != Control
        _rootParent = target.__class.__parent
        while _rootParent != Control
          _rootParent = _rootParent.__parent
    else
      error "target must a class."
      
    _rootParent = _rootParent or target
    assert (target.__class == Control) or (_rootParent.__class == Control),
      "target must be a Control or a subclass of Control."

    @events\on @events\getEvent(event), callback, target

  -- adds a chrono to the control.
  -- @tparam number duration
  -- @tparam function onDone
  addChrono: (duration, repeated, alwaysUpdate, onDone) =>
    chrono = Chrono.getInstance!
    chrono\create @, duration, repeated, alwaysUpdate, onDone

  -- @local
  drawChildren: =>
    for i = 1, #@children
      @children[i]\draw!

  --- updates the ROOT.
  --- the root is the only ctrl that should be calling this method.
  --- The Conform method will take care of the rest.
  -- @tparam number dt
  update: (dt) =>
    @conform!

  --- sets visible.
  -- @tparam boolean bool
  setVisible: (bool) =>
    @visible = bool

  --- getter for visible property.
  -- @treturn boolean visible
  getVisible: =>
    @visible

  -- sets the radius.
  -- @tparam number r
  setRadius: (r) =>
    if @boundingBox.__class.__name == "Circle" or @boundingBox.__class.__name == "Polygon"
      assert (type(r) == 'number'),
        "radius must be of type number."
      @radius = r
      @needConforming true

  -- getter for the radius.
  -- @treturn number r
  getRadius: =>
    if @boundingBox.__class.__name == "Circle" or @boundingBox.__class.__name == "Polygon"
      return @radius
    return nil

  -- sets the number of sides.
  -- @tparam number sides
  setSides: (sides) =>
    if @boundingBox.__class.__name ~= "Polygon" then return
    @boundingBox\setSides sides

  -- gets the number of sides.
  -- @treturn number sides
  getSides: =>
    if @boundingBox.__class.__name ~= "Polygon" then return nil
    @boundingBox\getSides!

  -- sets the angle.
  -- @tparam number angle
  setAngle: (angle) =>
    if @boundingBox.__class.__name ~= "Polygon" then return
    @boundingBox\setAngle angle

  -- gets the angle.
  -- @treturn number angle
  getAngle: =>
    if @boundingBox.__class.__name ~= "Polygon" then return nil
    @boundingBox\getAngle!

  -- sets the clip.
  -- @tparam boolean bool
  setClip: (bool) =>
    @clip = bool

  -- gets the clip
  -- @treturn boolean clip
  getClip: =>
    @clip

  -- @local
  clipBegin: =>
    box = @getBoundingBox!
    if @clip
      Graphics = love.graphics
      switch @boundingBox.__class.__name
        when "Box"
          Graphics.stencil -> Graphics.rectangle "fill", box.x, box.y, box\getWidth!, box\getHeight!
        when "Polygon"
          Graphics.stencil -> Graphics.polygon "fill", box\getVertices!
        when "Circle"
          Graphics.stencil -> Graphics.circle "fill", box.x, box.y, box\getRadius!

      Graphics.setStencilTest "greater", 0

  -- @local
  clipEnd: =>
    if @clip
      Graphics = love.graphics
      Graphics.setStencilTest!

  --- draws the control.
  draw: =>
    if @visible == false then return
    @clipBegin!
    @events\dispatch @events\getEvent("UI_DRAW")
    @drawChildren!
    @clipEnd!

  --- sets updateWhenFocused (if true the UI_UPDATE event will be triggred when the control is clicked.).
  -- @tparam boolean updateWhenFocused
  setUpdateWhenFocused: (updateWhenFocused) =>
    @updateWhenFocused = updateWhenFocused

  --- sets control label (Mainly for debug)
  -- @tparam string l
  setLabel: (l) =>
    @label = l

  --- gets control label (Mainly for debug)
  -- @treturn string l
  getLabel: =>
    @label

  setNotifyParent: (bool) =>
    @notifyParent = bool

  getNotifyParent: (bool) =>
    @notifyParent

  setMakeTopWhenClicked: (bool) =>
    @makeTopWhenClicked = bool

  getMakeTopWhenClicked: =>
    @makeTopWhenClicked

  makeTop: =>
    @originalDepth = @depth
    @setDepth @@curMaxDepth + 1
    if @parent then @parent\sortChildren!

  rollBackDepth: =>
    if @makeTopWhenClicked
      @setDepth @originalDepth
      if @parent then @parent\sortChildren!

  setFocuseOnAdd: (bool) =>
    @focuseOnAdd bool

  getFocuseOnAdd: =>
    @focuseOnAdd

  setFocusEnabled: (bool) =>
    @focusEnabled = bool
  
  isFocusEnabled: =>
    @focusEnabled

  --- list of functions to override when boundingbox is of type Box.
  -- @table boxOverrides
  @boxOverrides: {
    "setSize"
    "setWidth"
    "setHeight"
  }

  --- list of functions to override when boundingbox is of type Circle.
  -- @table circleOverrides
  @circleOverrides: {
    "setRadius"
  }

  --- list of functions to override when boundingbox is of type Polygon.
  -- @table polyOverrides
  @polyOverrides: {
    "setRadius"
    "setSides"
    "setAngle"
  }
