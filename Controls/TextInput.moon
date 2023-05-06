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
    @indiNum = 0
    @indincatortime = 0
    @maskChar = '*'
    @indicatorx = 0
    @indicatory = 0
    @visible = true

    @offsetx = 0
    @offsety = 0

    @textoffsetx = 5
    @textoffsety = 5

    @textx = 0
    @texty = 0

    @width = 200

    @font = love.graphics.newFont(12) -- TODO: use theme

    Dump "Lines : ", @lines 

    @setEnabled true

    -- Events
    @on "UI_KEY_DOWN", @onKeyDown, @

  updateIndicator: =>
    time = love.timer.getTime!

    text = @lines[@line]

    if @indincatortime < time
      if @showIndicator then @showIndicator = false
      else @showIndicator = true
      @indincatortime += (time + 0.50)
    
    if @allTextSelected
      @showIndicator = false -- we dont need to show the indicator if everything is selected
    else
      if @keyboardIsDown "up", "down", "left", "right" then @showIndicator = true
    
    width = 0

    if @masked
      width = @font\getWidth string.rep(@maskChar, @indiNum)
    else
      if @indiNum == 0
        width = 0 -- Empty text box
      elseif @indiNum >= utf8.len(text)
        width = @font\getWidth text -- Indi is at the end of the text
      else -- Indi is somewhere else in the text
        width = @font\getWidth utf8.sub text, 1, @indiNum


    if @multiline
      return -- TODO: multiline
    else
      @indicatorx += @textx + width
      @indicatory = texty

    -- TODO: Might need to handle scrolling here ??
    
    @


  
  moveIndicator: (num, exact = nil) =>
    if exact == nil then @indiNum += num
    else @indiNum = num
    text = @lines[@line]
    --print "Text : ", utf8.len(text), @indiNum

    if @indiNum > utf8.len(text)
      @indiNum = utf8.len text
    elseif @indiNum < 0
      @indiNum = 0

    @showIndicator = true
    -- Update indicator
    @updateIndicator!
    @

  processKey: (key, isText) =>

    if @visible == false then return -- keep in mind the Contorl checks if visible only when drawing.
    
    offsetx = @offsetx

    if isText == false
      if key == "left"
        if @multiline == false
          @moveIndicator -1
          if @indicatorx <= @x and @indiNum ~= 0
            currentLine = @lines[@line]
            width = @font\getWidth utf8.sub(currentLine, @indiNum, @indiNum + 1)
            @offsetx = offsetx - width
          elseif @indiNum == 0 and offsetx ~= 0
            @offsetx = 0
        else
          -- Todo Multiline
          return

        if @allTextSelected
          @line = 1
          @indiNum = 0
          @allTextSelected = false

      elseif key == "right"
        if @multiline == false
          @moveIndicator 1
          currentLine = @lines[@line]
          if @indicatorx >= (@x + @width) and @indiNum ~= utf8.len(currentLine)
            width = @font\getWidth utf8.sub(currentLine, @indiNum, @indiNum)
            @offsetx = offsetx + width
          elseif @indiNum == utf8.len(currentLine) and offsetx ~= ((@font\getWidth(currentLine)) - @width + 10) and @font\getWidth(currentLine) + @textoffsetx > @width
            @offsetx = ((@font\getWidth(currentLine)) - @width + 10)
        else
          -- Todo Multiline
          return
          
        if @allTextSelected
          @line = #@lines
          @indiNum = utf8.len @lines[@#lines]
          @allTextSelected = false
        

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
        print "Copy"
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
    else @processKey key, false

  
  -- DEBUG METHODS
  getLines: =>
    @lines