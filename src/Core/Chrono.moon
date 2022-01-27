----
-- A Chrono class (timer)
-- @classmod Chrono
-- @usage b = Chrono!

Tinsert   = table.insert
Utils     = assert require MeowUI.cwd .. "Core.Utils"
Singleton = assert require MeowUI.cwd .. "Core.Singleton"

-- @local
tick = (owner, dt) =>
  @time += (1 * dt)
  if @time >= @duration
    @onDone(owner)
    if owner.chrono then owner.chrono = nil
    return true
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
  -- @tparam number duration
  -- @tparam function onDone
  -- @treturn table
  create: (duration, onDone) =>
    assert type(duration) == 'number',
      "duration must be of type number."
    assert type(onDone) == 'function',
      "onDone must be of type number."

    timer = {
      id:       Utils.Uid!
      time:     0
      duration: duration
      onDone:   onDone
      tick:     tick
    }

    Tinsert @timers, timer

    timer

  --- updates the active timers.
  -- @tparam table owner
  -- @tparam number dt
  update: (owner, dt) =>
    if @getTimersCount! == 0 then return
    for i = 1, @getTimersCount!, 1
      if @timers[i]\tick owner, dt
        @timers[i] = nil


