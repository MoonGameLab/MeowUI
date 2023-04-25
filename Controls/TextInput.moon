Graphics = love.graphics
Window = love.window
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control
Mixins   = assert require MeowUI.root .. "Controls.Mixins"


class TextInput extends Control

  @include Mixins.KeyboardMixins

  new: (placeHolder) =>
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
    @tabreplacement = "        "

    @setEnabled true

    -- Events
    @on "UI_KEY_DOWN", @onKeyDown, @


  processKey: (key, isText) =>


  getText: =>
    if @multiline
      for k, line in ipairs @lines
        text ..= line
        if k ~= #@lines
          text ..= "\n" -- Jump to next line.
    else
      text = @lines[1] -- Only one line

    text

  setText: (text) =>
    

  onKeyDown: (key) =>
    timer = love.timer
    if @visible == false then return

    time = timer.getTime!
    keyDown = key

    if @isCtrlDown!
      if key == "a"
        if @multiline
          if @lines[1] ~= "" then @allTextSelected = true
        else
          @allTextSelected = true
      elseif key == "c" and @allTextSelected
        print "COpy"
        system = love.system
        text = @getText!
        -- TODO: OnCopy callback
        system.setClipboardText text
      elseif key == "x" and @allTextSelected and @editable
        text = @getText!
        system.setClipboardText text
        -- TODO: OnCut callback
        -- TODO: clear Text
      elseif key == "v" and @editable
        @Paste!
      else
        @processKey key, false
      
    else @processKey key, true

