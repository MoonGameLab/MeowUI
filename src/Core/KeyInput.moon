love = love
MeowUI = MeowUI
import insert from table
import remove from table
import timer from love

Utils      = assert require MeowUI.cwd .. "Core.Utils"

copy = Utils.Copy
getTableKeys = Utils.GetTableKeys

class Input

  new: =>
    @state = {}
    @binds = {}
    @functions = {}
    @prevState = {}
    @repeatState = {}
    @sequences = {}

  bind: (key, action) =>
    if type(action) == 'function'
      @functions[key] = action
      return
    if not @binds[action]
      @binds[action] = {}

    insert @binds[action], key

  bindArr: (bs = nil) =>
    if bs == nil then return
    for k, a in pairs bs
      @bind k, a

  pressed: (action) =>
    if action
      for _, key in ipairs @binds[action]
        if @state[key] and not @prevState[key]
          return true
    else
      for _, key in ipairs(getTableKeys(@functions))
        if @state[key] and not @prevState[key]
          @functions[key]!


  released: (action) =>
    for _, key in ipairs(@binds[action])
      if @prevState[key] and not @state[key]
        return true

  sequence: (...) =>
    sequence = {...}
    if #sequence <= 1
      error("Use pressed if only checking one action.")
    if type(sequence[#sequence]) ~= 'string'
      error("The last argument must be an action :: string.")
    if #sequence % 2 == 0
      error("The number of arguments must be odd.")

    sequenceKey = ''
    for _, seq in ipairs sequence
      sequenceKey ..= tostring(seq)

    if not @sequences[sequenceKey]
      @sequences[sequenceKey] = {
        sequence: sequence,
        currentIdx: 1
      }
    else
      if @sequences[sequenceKey].currentIdx == 1
        action = @sequences[sequenceKey].sequence[@sequences[sequenceKey].currentIdx]
        for _, key in ipairs @binds[action]
          if @state[key] and not @prevState[key]
            @sequences[sequenceKey].lastPressed = timer.getTime!
            @sequences[sequenceKey].currentIdx += 1

      else
        delay = @sequences[sequenceKey].sequence[@sequences[sequenceKey].currentIdx]
        action = @sequences[sequenceKey].sequence[@sequences[sequenceKey].currentIdx + 1]
        if (timer.getTime! - @sequences[sequenceKey].lastPressed) > delay
          @sequences[sequenceKey] = nil
          return
        for _, key in ipairs @binds[action]
          if @state[key] and not @prevState[key]
            if (timer.getTime! - @sequences[sequenceKey].lastPressed) <= delay
              if @sequences[sequenceKey].currentIdx + 1 == #@sequences[sequenceKey].sequence
                @sequences[sequenceKey] = nil
                return true
              else
                @sequences[sequenceKey].lastPressed = timer.getTime!
                @sequences[sequenceKey].currentIdx += 2
            else
              @sequences[sequenceKey] = nil

  down: (action = nil, interval = nil, delay = nil) =>
    if action and interval and delay
      for _, key in ipairs @binds[action]
        if @state[key] and not @prevState[key]
          @repeatState[key] = {
            pressedTime: timer.getTime!,
            delay: 0,
            interval: interval,
            delayed: true
          }
          return true
        else if @state[key] and @prevState[key]
          return true


    if action and interval and not delay
      for _, key in ipairs @binds[action]
        if @state[key] and not @prevState[key]
          @repeatState[key] = {
            pressedTime: timer.getTime!,
            delay: 0,
            interval: interval,
            delayed: false
          }
          return true
        else if @state[key] and @prevState[key]
          return true

  unbind: (key) =>
    for action, keys in pairs @binds
      for i = #keys, 1, -1
        if key == @binds[action][i]
          remove @binds[action], i
    if @functions[key]
      @functions[key] = nil


  unbindAll:  =>
    @binds = {}
    @functions = {}

  update: =>
    if #@binds == 0 then return
    @pressed!
    @prevState = copy @state

    for _, v in pairs @repeatState
      if v
        v.pressed = false
        t = timer.getTime! - v.pressedTime
        if v.delayed
          if t > v.delay
            v.pressed = true
            v.pressedTime = timer.getTime!
            v.delayed = false
        else
          if t > v.interval
            v.pressed = true
            v.pressedTime = timer.getTime!

  keypressed: (key) =>
    @state[key] = true

  keyreleased: (key) =>
    @state[key] = false
    @repeatState[key] = false
