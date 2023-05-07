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

    @usable = {}
    @unusable = {}

    @textoffsetx = 5

    @width = 200

    @font = love.graphics.newFont(12) -- TODO: use theme

    Dump "Lines : ", @lines 

    @setEnabled true

    -- Events
    @on "UI_KEY_DOWN", @onKeyDown, @
    @on "UI_TEXT_INPUT", @onTextInput, @

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


  removeFromTxt: (pos) =>
    curLine = @lines[@line]
    text = curLine
    p1 = utf8.sub text, 1, pos - 1
    removedTxt =  utf8.sub text, pos, pos + 1
    p2 = utf8.sub text, pos + 1
    new = p1 .. p2
    new, removedTxt

  addIntoTxt: (txt, pos) =>
    text = @lines[@line]
    p1 = utf8.sub text, 1, pos
    p2 = utf8.sub text, pos + 1
    new = p1 .. txt .. p2
    new

  clear: =>
    @lines = {""}
    @line = 1
    @offsetx = 0
    @offsety = 0
    @indiNum = 0
    
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
          @indiNum = utf8.len @lines[#@lines]
          @allTextSelected = false

      if @editable == false then return

      if key == "backspace"
        if @allTextSelected
          @clear!
          @allTextSelected = false
        else
          removedTxt = ''
          text = @lines[@line]
          if text ~= "" and @indiNum ~= 0
            text, removedTxt = @removeFromTxt @indiNum
            @moveIndicator -1
            @lines[@line] = text

          -- TODO Multiline

          cwidth = 0
          if @masked
            cwidth = @font\getWidth utf8.gsub(removedTxt, ".", maskChar)
          else
            cwidth = @font\getWidth removedTxt

          if @offsetx > 0
            @offsetx -= cwidth
          elseif @offsetx < 0
            @offsetx = 0

      if key == "delete"
        if editable == false then return
        if @allTextSelected
          @clear!
          @allTextSelected = false

      if key == "tab"
        if @allTextSelected then return
        @lines[@line] = @addIntoTxt @tabreplacement, @indiNum
        @moveIndicator utf8.len(@tabreplacement)

    else
      if @editable == false then return
      text = @lines[@line]
      
      if utf8.len(text) >= @limit and @limit ~= 0 and @allTextSelected == false
        return

      if #@usable > 0
        found = false
        for k, v in ipairs @usable
          if v == key then found = true

        if found then return
      
      if #@unusable > 0
        found = false
        for k, v in ipairs @unusable
          if v == key then found = true

        if found then return

      if @allTextSelected
        @allTextSelected = false
        @clear!
        text = ""

      if @indiNum ~= 0 and @indiNum ~= utf8.len text
        text = @addIntoTxt key, @indiNum
        @lines[@line] = text
        @moveIndicator 1
      elseif @indiNum == utf8.len text
        text ..= key
        @lines[@line] = text
        @moveIndicator 1
      elseif @indiNum == 0
        text = @addIntoTxt key, @indiNum
        @lines[@line] = text
        @moveIndicator 1

      text = @lines[@line]

      if @multiline == false
        twidth = 0
        cwidth = 0
        
        if @masked
          twidth = @font\getWidth utf8.gsub(text, ".", maskChar)
          cwidth = @font\getWidth utf8.gsub(key, ".", maskChar)
        else
          twidth = @font\getWidth text
          cwidth = @font\getWidth key

        if (twidth + @textoffsetx) >= (@width - 1)
          @offsetx += cwidth
      
      


        

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

  
  onTextInput: (text) =>
    @processKey text, true

  
  -- DEBUG METHODS
  getLines: =>
    @lines