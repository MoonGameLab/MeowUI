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

    with @popupContainer = Control "Box", "popupContainer"
      \setSize w, h

    with @optionContainer = Control "Box", "optionContainer"
      \setSize w, h

    with @tipContainer = Control "Box", "tipContainer"
      \setSize w, h

    @addChild @coreContainer, 1
    @addChild @popupContainer, 2
    @addChild @optionContainer, 3
    @addChild @tipContainer, 4

  --- drops the children of all root containers.
  clear: =>
    @coreContainer\dropChildren!
    @popupContainer\dropChildren!
    @optionContainer\dropChildren!
    @tipContainer\dropChildren!

  --- drops the children of the core container.
  clearCore: =>
    @coreContainer\dropChildren!

  --- drops the children of the popup container.
  clearPopup: =>
    @popupContainer\dropChildren!

  --- drops the children of the option container.
  clearOption: =>
    @optionContainer\dropChildren!

  --- drops the children of the tip container.
  clearTip: =>
    @tipContainer\dropChildren!

  --- attaches a child control to the core container.
  -- @tparam Control child
  addCoreChild: (child) =>
    @coreContainer\addChild child

  --- attaches a child control to the popup container.
  -- @tparam Control child
  addPopupChild: (child) =>
    @popupContainer\addChild child

  --- attaches a child control to the option container.
  -- @tparam Control child
  addOptionChild: (child) =>
    @optionContainer\addChild child

  --- attaches a child control to the tip container.
  -- @tparam Control child
  addTipChild: (child) =>
    @tipContainer\addChild child

  --- removes a child control from the core container.
  -- @tparam number id
  removeCoreChild: (id) =>
    @coreContainer\removeChild id

  --- removes a child control from the popup container.
  -- @tparam number id
  removePopupChild: (id) =>
    @popupContainer\removeChild id

  --- removes a child control from the option container.
  -- @tparam number id
  removeOptionChild: (id) =>
    @optionContainer\removeChild id

  --- removes a child control from the tip container.
  -- @tparam number id
  removeTipChild: (id) =>
    @tipContainer\removeChild id







