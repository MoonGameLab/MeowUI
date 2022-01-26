----
-- Event class
-- @classmod Event
-- @usage e: Event!

Tinsert = table.insert
Tremove = table.remove
Utils = MeowUI.cwd .. "Core.Utils"

class Event

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

  new: =>
    @handlers =  {}

  getEvent: (ename) =>
    assert type(ename) == 'string',
      "Event name must be of type string."
    @@eventsDef[ename]

  drop: =>
    @handlers = {}

  on: (name, callback, target) =>
    assert type(name) == 'string',
      "Event name must be of type string."
    assert type(callback) == 'function',
      "Callback name must be a function."
    assert type(target) == 'table',
      "Target must be a table."

    if not @handlers[name] then @handlers[name] = {}
    hdlr = {id: Utils.Uid!, callback: callback, target: target}
    Tinsert @handlers[name], hdlr
    hdlr

  dispatch: (name, ...) =>
    assert type(name) == 'string',
      "Event name must be of type string."

    hdlr = @handlers[name]
    if not hdlr then return false

    for _, h in ipairs hdlr
      handler = h
      if handler.callback
        if handler.target
          if handler.callback(handler.target, ...)
            return true
        else
          if handler.callback(...)
            return true

    return false

  remove: (event, id) =>
    if @handlers[@getEvent(event)] == nil then return
    for i, h in ipairs @handlers[@getEvent(event)]
      if h.id == id
        Tremove @handlers[@getEvent(event)], i
        return







