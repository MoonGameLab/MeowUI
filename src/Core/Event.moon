----
-- Event class
-- @classmod Event
-- @usage e: Event!

MeowUI = MeowUI
love = love

Tinsert = table.insert

Utils = assert require MeowUI.cwd .. "Core.Utils"

class Event
  --- a table of event constants.
  -- @field UI_MOUSE_DOWN
  -- @field UI_MOUSE_UP
  -- @field UI_MOUSE_MOVE
  -- @field UI_MOUSE_ENTER
  -- @field UI_MOUSE_LEAVE
  -- @field UI_WHELL_MOVE
  -- @field UI_CLICK
  -- @field UI_DB_CLICK
  -- @field UI_DB_CLICK
  -- @field UI_FOCUS
  -- @field UI_UN_FOCUS
  -- @field UI_KEY_DOWN
  -- @field UI_KEY_UP
  -- @field UI_TEXT_INPUT
  -- @field UI_TEXT_CHANGE
  -- @field UI_DRAW
  -- @field UI_MOVE
  -- @field UI_ON_ADD
  -- @field UI_ON_REMOVE
  -- @field UI_ON_SCROLL
  -- @field UI_ON_SELECT
  -- @field TIMER_DONE
  -- @table eventsDef
  @eventsDef: {
    UI_MOUSE_DOWN: "mouseDown"
    UI_MOUSE_UP: "mouseUp"
    UI_MOUSE_MOVE: "mouseMove"
    UI_MOUSE_ENTER: "mouseEnter"
    UI_MOUSE_LEAVE: "mouseLeave"
    UI_WHELL_MOVE: "whellMove"
    UI_CLICK: "click"
    UI_DB_CLICK: "dbClick"
    UI_FOCUS: "focus"
    UI_UN_FOCUS: "unFocus"
    UI_KEY_DOWN: "keyDown"
    UI_KEY_UP: "keyUp"
    UI_TEXT_INPUT: "textInput"
    UI_TEXT_CHANGE: "textChange"
    UI_UPDATE: "update"
    UI_DRAW: "draw"
    UI_MOVE: "move"
    UI_ON_ADD: "onAdd"
    UI_ON_REMOVE: "onRemove"
    UI_ON_SCROLL: "onScroll"
    UI_ON_SELECT: "onSelect"
    TIMER_DONE: "onTimerDone"
  }

  --- constructor
  new: =>
    @handlers =  {}

  --- getter for an event from event constants table.
  -- @tparam string ename
  -- @treturn string
  getEvent: (ename) =>
    assert type(ename) == 'string',
      "Event name must be of type string."
    @@eventsDef[ename]

  --- drops all the handlers of an event instance.
  drop: =>
    @handlers = {}

  --- attaches a handler to an event.
  -- @tparam string name
  -- @tparam function callback
  -- @tparam table target
  -- @treturn table handler
  on: (name, callback, target) =>
    assert type(name) == 'string',
      "Event name must be of type string."
    assert type(callback) == 'function',
      "Callback must be a function."
    assert type(target) == 'table',
      "Target must be a table."

    if not @handlers[name] then @handlers[name] = {}
    hdlr = {
      id: Utils.Uid!
      callback: callback
      target: target
    }
    Tinsert @handlers[name], hdlr
    hdlr

  --- runs the callback associated to an event name.
  -- @tparam string name
  -- @tparam table ... (params)
  -- @treturn boolean
  dispatch: (name, ...) =>
    assert type(name) == 'string',
      "Event name must be of type string."

    hdlr = @handlers[name]
    if not hdlr then return false
    for i = 1, #hdlr
      handler = hdlr[i]
      if handler.callback
        if handler.target
          if handler.callback(handler.target, ...)
            return true
        else
          if handler.callback(...)
            return true

    return false

  --- removes an event handler.
  -- @tparam string event
  -- @tparam string id
  remove: (event, id) =>
    _event = @getEvent(event)
    if @handlers[_event] == nil then return
    for i = 1, #@handlers[_event]
      h = @handlers[_event][i]
      if h.id == id
        @handlers[@getEvent(event)][i] = nil
        return







