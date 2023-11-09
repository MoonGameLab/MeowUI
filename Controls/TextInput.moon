Graphics = love.graphics
Window = love.window
MeowUI   = MeowUI
utf8 = utf8
love     = love
Control  = MeowUI.Control
Mixins   = assert require MeowUI.root .. "Controls.mx"
colors   = assert require MeowUI.root .. "src.AddOns.Colors"
tableHasValue = Mixins.tableHasValue

stencilFunc = =>
  -> Graphics.rectangle "fill", @x, @y, @width, @height

class TextInput extends Control

  @include Mixins.KeyboardMixins
  @include Mixins.EventMixins

  new: (placeHolder) =>
    super "Box", "TextInput"

    -- TODO: should be a mixin
    t = assert(require(MeowUI.root .. "Controls.Style"))[MeowUI.theme]
    common = t.common
    style = t.textField

    @marginCorner = style.marginCorner
    @textAreaColor = style.textAreaColor
    @textColor = style.textColor
    @strokeColor = t.colors.strokeColor
    @stroke = common.stroke
    @rx = style.rx
    @ry = style.ry
    @brx = 0
    @bry = 0

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

    @width = 150
    @height = 25

    @font = love.graphics.newFont(12) -- TODO: use theme

    Dump "Lines : ", @lines 

    @setEnabled true
    @setUpdateWhenFocused true

    -- Events
    @on "UI_KEY_DOWN", @onKeyDown, @
    @on "UI_TEXT_INPUT", @onTextInput, @
    @on "UI_DRAW", @draw, @
    @on "UI_UPDATE", @update, @
    @on "UI_MOUSE_ENTER", @onMouseEnter, @
    @on "UI_MOUSE_LEAVE", @onMouseLeave, @
    @on "UI_MOUSE_DOWN", @onMouseDown, @
    @on "UI_MOUSE_UP", @onMouseUp, @

  indicatorBlink: =>
    time = love.timer.getTime!

    text = @lines[@line]

    if @indincatortime < time
      if @showIndicator then @showIndicator = false
      else @showIndicator = true
      @indincatortime = (time + 0.50)

  updateIndicator: =>
    text = @lines[@line]

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
        width = @font\getWidth utf8.sub(text, 1, @indiNum)


    if @multiline
      return -- TODO: multiline
    else
      box = @getBoundingBox!
      @indicatorx = @textx + width
      @indicatory = @texty

    -- TODO: Might need to handle scrolling here ??
    

  moveIndicator: (num, exact = nil) =>
    if exact == nil then @indiNum += num
    else @indiNum = num
    text = @lines[@line]

    if @indiNum > utf8.len(text)
      @indiNum = utf8.len text
    elseif @indiNum < 0
      @indiNum = 0

    @showIndicator = true
    -- Update indicator
    @updateIndicator!

  offsetTextTab: =>
    twidth = 0
    cwidth = 0
    text = @lines[@line]
    
    if @masked
      twidth = @font\getWidth utf8.gsub(text, ".", maskChar)
      cwidth = @font\getWidth utf8.gsub(@tabreplacement, ".", maskChar)
    else
      twidth = @font\getWidth text
      cwidth = @font\getWidth @tabreplacement

    if (twidth + @textoffsetx) >= (@width - 1)
      @offsetx += cwidth

    @moveIndicator 1


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
          @updateIndicator!
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

      elseif key == "delete"
        if editable == false then return
        if @allTextSelected
          @clear!
          @allTextSelected = false
          @updateIndicator!
      elseif key == "tab"
        if @allTextSelected then return
        @lines[@line] = @addIntoTxt @tabreplacement, @indiNum
        @moveIndicator utf8.len(@tabreplacement)
        @updateIndicator!
        text = @lines[@line]
        if @multiline == false
          @offsetTextTab!
          currentLine = @lines[@line]
          if @indicatorx >= (@x + @width) and @indiNum ~= utf8.len(currentLine)
            width = @font\getWidth utf8.sub(currentLine, @indiNum, @indiNum)
            @offsetx = offsetx + width
          elseif @indiNum == utf8.len(currentLine) and offsetx ~= ((@font\getWidth(currentLine)) - @width + 10) and @font\getWidth(currentLine) + @textoffsetx > @width
            @offsetx = ((@font\getWidth(currentLine)) - @width + 10)

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
      

  positionText: =>
    if @multiline
      return
    else
      box = @getBoundingBox!
      @textx = (box.x - @offsetx) + @textoffsetx
      @texty = (box.y - @offsety) + @textoffsety   

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
        @copy!
        @allTextSelected = false
        -- TODO: OnCopy callback
      elseif key == "x" and @allTextSelected and @editable
        text = @getText!
        system = love.system
        system.setClipboardText text
        -- TODO: OnCut callback
        -- TODO: clear Text
        @setText ""
        @updateIndicator!
      elseif key == "v" and @editable
        @past!
      else
        @processKey key, false
    else @processKey key, false
  
  onTextInput: (text) =>
    @processKey text, true

  drawIndicator: =>
    if @showIndicator and @isFocused!
      r, g, b, a = Graphics.getColor!
      Graphics.setColor colors.black
      Graphics.rectangle "fill", @indicatorx, @indicatory - 2.5, 1, @height - 5
      Graphics.setColor r, g, b, a

  drawText: =>
    r, g, b, a = Graphics.getColor!
    font = Graphics.getFont!
    Graphics.setFont @font
    Graphics.setColor colors.black
    str = @lines[1]
    box = @getBoundingBox!
    Graphics.print str, math.floor(@textx), math.floor(@texty)
    Graphics.setColor r, g, b, a
    Graphics.setFont font
    Graphics.setColor r, g, b, a

  drawBgBox: =>
    r, g, b, a = Graphics.getColor!
    color = colors.gray
    color[4] = color[4] or @alpha
    Graphics.setColor color
    Graphics.rectangle "fill", @x - @stroke, @y - @stroke, @width + @stroke*2, @height + @stroke*2, @brx, @bry
    Graphics.setColor r, g, b, a 

  drawTextBox: =>
    r, g, b, a = Graphics.getColor!
    Graphics.setColor colors.white
    Graphics.rectangle "fill", @x, @y, @width, @height, @rx, @ry

  drawTextEffects: =>
    if @allTextSelected
      local w, h
      h = @font\getHeight "a"
      if @masked
        w = @font\getWidth utf8.gsub(@lines[@line], ".", @maskChar)
      else
        w = @font\getWidth @lines[@line]
      Graphics.setColor colors.lightskyblue
      Graphics.rectangle "fill", @textx, @texty, w, h
      Graphics.setColor colors.white

  draw: =>

    @drawBgBox!
    Graphics.stencil stencilFunc @
    Graphics.setStencilTest "greater", 0

    @positionText!
    @updateIndicator!
    @drawTextBox!
    @drawTextEffects!
    @drawIndicator!
    @drawText!

    Graphics.setStencilTest!

  
  update: (dt) =>
    @indicatorBlink!


  -- Getters/Setters
  getLines: =>
    @lines

  getText: =>
    if @multiline == false
      @lines[1]

  getFont: =>
    @font

  setFontSize: (size) =>
    Graphics = love.graphics
    @font = Graphics.newFont size

  getFontSize: =>
    @font\getWidth!, @font\getHeight!

  setCorners: (rx, ry, brx, bry) =>
    @rx = rx or @rx
    @ry = ry or @ry
    @brx = brx or @brx
    @bry = bry or @bry


  copy: =>
    sys = love.system
    text = @getText!
    sys.setClipboardText text

  past: =>
    sys = love.system
    text = sys.getClipboardText!

    if @limit > 0
      curText = @getText!
      curLenght = utf8.len  curText
      if curText == @limit
        return
      else
        inptLimit = @limit - curLenght
        if utf8.len(text) > inptLimit
          text = utf8.sub text, 1, inptLimit
    
    charCheck = (a) ->
      if #@usable > 0
        if tableHasValue(@usable, a) == false
          return ""
      elseif #@unusable > 0
        if tableHasValue(@usable, a) 
          return ""

    if @allTextSelected
      @setText text
      @allTextSelected = false
    else
      if @multiline
        return
      else
        text = utf8.gsub text, string.char(10), " "
        text = utf8.gsub text, string.char(13), " "
        text = utf8.gsub text, string.char(9), @tabreplacement
        lenght = utf8.len text
        linetxt = @lines[1]
        p1 = utf8.sub linetxt, 1, @indiNum
        p2 = utf8.sub linetxt, @indiNum + 1
        new = p1 .. text .. p2
        @lines[1] = new
        @indiNum = @indiNum + lenght



    