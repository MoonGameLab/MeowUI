----
-- A Chrono class (extends @{Singleton})
-- @classmod Chrono
-- @usage c = Chrono.getInstance!

MeowUI = MeowUI

Tinsert   = table.insert
Utils     = assert require MeowUI.cwd .. "Core.Utils"
Singleton = assert require MeowUI.cwd .. "Core.Singleton"

-- @local
tick = (dt) =>
  @time += (1 * dt)
  if @time >= @duration
    @onDone @
    if @repeated
      @time = 0
    else
      @isDone = true
  false


class Chrono extends Singleton
  --- constructor.
  new: () =>
    @timers = {}

  --- will return the number of active timers.
  -- @treturn number
  getTimersCount: =>
    #@timers

  --- creates a timer. This timer will be removed automatically from owner if
  -- "chrono" is the key for the timer instance.
  -- You can set it to be repeated with the same duration and onDone callback.
  -- @tparam number duration
  -- @tparam boolean repeated
  -- @tparam function onDone
  -- @treturn table
  create: (owner, duration, repeated, alwaysUpdate, onDone) =>
    assert type(duration) == 'number',
      "duration must be of type number."
    assert type(onDone) == 'function',
      "onDone must be of type number."

    timer = {
      id:       Utils.Uid!
      time:     0
      duration: duration
      onDone:   onDone
      isDone:   false
      tick:     tick
      owner:    owner
      repeated: repeated and true or false
      alwaysUpdate: alwaysUpdate
    }

    Tinsert @timers, timer

    timer

  --- updates the active timers.
  -- @tparam table owner
  -- @tparam number dt
  update: (dt) =>
    if @getTimersCount! == 0 then return
    for i = 1, @getTimersCount!, 1
      if @timers[i].alwaysUpdate or @timers[i].owner == MeowUI.clickedControl
        if @timers[i] and @timers[i]\tick dt
          @timers[i] = nil


