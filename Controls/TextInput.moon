Graphics = love.graphics
Window = love.window
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control
Mixins   = assert require MeowUI.root .. "Controls.Mixins"


class TextInput extends Control
  new: (placeHolder) ->
    super "Box", "TextInput"

    @keyDown = "none"
    @limit = 0
    @line = 1
    @lines = {""}
    @placeHolder = placeHolder
    @showIndicator = true
    @focus = false
    @multiline = false
    @allTextSelected = false
    @editable = true

    @setEnabled true

    -- Events
    @on "UI_KEY_DOWN", @onKeyDown, @


  onKeyDown = (key) =>
    -- TODO
    

