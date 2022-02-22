----
-- A Root class (extends @{Control})
-- @classmod Root
-- @usage r = Root!

Control = assert require MeowUI.cwd .. "Core.Control"
Graphics = love.graphics

class Root extends Control
  --- constructor.
  new: =>
    super "Box"
    w, h = Graphics.getWidth!, Graphics.getHeight!

    @setSize w, h
    @initContainers w, h


  --- initializes the containers.
  -- @tparam number w
  -- @tparam number h
  initContainers: (w, h) =>
    with @coreContainer = Control "Box", "coreContainer"
      \setSize w, h
      --\setAlwaysUpdate false
      --\setEnabled false

    super\addChild @coreContainer, 1


  --- drops the children of all root containers.
  clear: =>
    @coreContainer\dropChildren!

  --- attaches a child control to the core container.
  -- @tparam Control child
  addChild: (child) =>
    @coreContainer\addChild child

  --- removes a child control from the core container.
  -- @tparam number id
  removeChild: (id) =>
    @coreContainer\removeChild id







