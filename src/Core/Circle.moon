----
-- A circle class
-- @classmod Circle
-- @usage c = Circle!

sqrt = math.sqrt


--- Distance point-to-point squared
-- @local
pointToPointSqr = (x1, y1, x2, y2) ->
  dx, dy = x2 - x1, y2 - y1
  dx*dx + dy*dy

--- Distance point-to-point
-- @local
pointToPointDist = (x1, y1, x2, y2) ->
  sqrt pointToPointSqr(x1, y1, x2, y2)

class Circle

  --- constructor passed a pos (`x`, `y`) and `radius` which must be `numbers`.
  -- @tparam number x
  -- @tparam number y
  -- @tparam number radius
  new: (x = 0, y = 0, radius = 0) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."
    assert type(radius) == 'number',
      "radius must be of type number."
    @x = x
    @y = y
    @radius = radius

  --- tests if a given point is inside the circle.
  -- @tparam number x
  -- @tparam number y
  -- @treturn boolean
  contains: (x, y) =>
    if pointToPointDist(@x, @y, x, y) < @radius then return true
    false

  --- getter for the circle position.
  -- @treturn table
  getPosition: =>
    @x, @y

  --- getter for the circle x position.
  -- @treturn number
  getX: =>
    @x

  --- getter for the circle y position.
  -- @treturn number
  getY: =>
    @y

  --- getter for the circle radius.
  -- @treturn number
  getRadius: =>
    @radius

  --- getter for the circle radius.
  -- @treturn number
  getSize: =>
    @getRadius!

  --- getter for the circle width.
  -- @treturn number
  getWidth: =>
    @getRadius! - @x

  --- getter for the circle's height.
  -- @treturn number
  getHeight: =>
    @getRadius! - @y

  --- setter for the circle position.
  -- @tparam number x
  -- @tparam number y
  setPosition: (x, y) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."
    @x, @y = x, y

  --- setter for the circle radius.
  -- @tparam number radius
  setRadius: (radius) =>
    assert type(radius) == 'number',
      "radius must be of type number."
    @radius = radius




