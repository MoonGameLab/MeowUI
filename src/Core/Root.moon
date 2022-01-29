-- @local
Control = assert require MeowUI.cwd .. "Core.Control"
Graphics = love.graphics

class Root extends Control
  new: =>
    super "Box"
    w, h = Graphics.getWidth!, Graphics.getHeight!

    @setSize w, h
    @initContainers w, h


  initContainers: (w, h) =>
    with @coreContainer = Control!
      \setSize w, h

    with @popupContainer = Control!
      \setSize w, h

    with @optionContainer = Control!
      \setSize w, h

    with @tipContainer = Control!
      \setSize w, h

    @addChild @coreContainer, 1
    @addChild @popupContainer, 2
    @addChild @optionContainer, 3
    @addChild @tipContainer, 4

  clear: =>
    @coreContainer\dropChildren!
    @popupContainer\dropChildren!
    @optionContainer\dropChildren!
    @tipContainer\dropChildren!

  clearCore: =>
    @coreContainer\dropChildren!

  clearPopup: =>
    @popupContainer\dropChildren!

  clearOption: =>
    @optionContainer\dropChildren!

  clearTip: =>
    @tipContainer\dropChildren!

  addCoreChild: (child) =>
    @coreContainer\addChild child

  addPopupChild: (child) =>
    @popupContainer\addChild child

  addOptionChild: (child) =>
    @optionContainer\addChild child

  addTipChild: (child) =>
    @tipContainer\addChild child

  removeCoreChild: (id) =>
    @coreContainer\removeChild id

  removePopupChild: (id) =>
    @popupContainer\removeChild id

  removeOptionChild: (id) =>
    @optionContainer\removeChild id

  removeTipChild: (id) =>
    @tipContainer\removeChild id







