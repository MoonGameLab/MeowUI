----
-- A Root class (extends @{Control})
-- @classmod Root
-- @usage r = Root!

MeowUI = MeowUI
love = love

Control = assert require MeowUI.cwd .. "Core.Control"
Graphics = love.graphics

class Root extends Control
  --- constructor.
  new: =>
    super "Box", "rootControl"
    w, h = Graphics.getWidth!, Graphics.getHeight!

    with @
      \setSize w, h
      \setEnabled false

  --- drops the children of all root containers.
  clear: =>
    @dropChildren!