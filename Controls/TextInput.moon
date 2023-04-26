Graphics = love.graphics
Window = love.window
MeowUI   = MeowUI
utf8 = utf8
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
    local text
    if @multiline
      for k, line in ipairs @lines
        text ..= line
        if k ~= #@lines
          text ..= "\n" -- Jump to next line.
    else
      text = @lines[1] -- Only one line

    text

  setText: (text) =>
    text = tostring text
    text = utf8.gsub text, string.char(9), @tabreplacement
    text = utf8.gsub text, string.char(13), ""

    if @multiline
      return -- TODO
    else
      text = utf8.gsub text, string.char(92) .. string.char(110), ""
      text = utf8.gsub text, string.char(10), ""
      @lines = {text}
      @line = 1
      @indiNum = utf8.len text
      

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
        system = love.system
        print text
        system.setClipboardText text
        -- TODO: OnCut callback
        -- TODO: clear Text
        @setText ""
      elseif key == "v" and @editable
        @Paste!
      else
        @processKey key, false
      
    else @processKey key, true

  
  -- DEBUG METHODS
  getLines: =>
    @lines