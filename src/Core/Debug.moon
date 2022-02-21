----
-- A debug class
-- @classmod Debug
-- @usage c = Debug!

Singleton = assert require MeowUI.cwd .. "Core.Singleton"

class Debug extends Singleton

  --- constructor.
  new: =>
    -- Will hold the currently hovered control
    @focusedControl = {}

  watch: (control) =>
    print control.id

  draw: =>
    -- slove.graphics.rectangle 'fill', 10, 10, 100, 100
    return



return Debug.getInstance!