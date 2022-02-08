
----
-- A polygon class
-- @classmod Polygon
-- @usage b = Polygon!

pi, cos, sin, tan = math.pi, math.cos, math.sin, math.tan
twoPi = 6.283185307179586476925287


-- @local
getAngle =  (x1, y1, x2, y2) ->
  local dtheta, theta1, theta2

  theta1 = math.atan2 y1, x1
  theta2 = math.atan2 y2, x2
  dtheta = theta2 - theta1

  while dtheta > math.pi
    dtheta -= twoPi
  while dtheta < -math.pi
    dtheta += twoPi

  dtheta



class Polygon

  --- constructor
  -- @tparam number x
  -- @tparam number y
  -- @tparam number n
  -- @tparam number radius
  -- @tparam number angle
  new: (x = 0, y = 0, n = 3, radius = 0, angle) =>

    @vertices = {}
    @sides = n
    @x, @y = x, y
    @radius = radius
    if n == 3
      @angle = angle or math.pi
    elseif n == 4
      @angle = angle or math.pi/4
    else
      @angle = angle or 0
    @centroid = {x:@x, y:@y}
    @calcVertices!

  -- @local
  calcVertices: () =>
    @vertices = {}
    for i = @sides, 1, -1
      x, y = 0, 0
      x = ( sin( i / @sides * 2 * pi - @angle) * @radius) + @x
      y = ( cos( i / @sides * 2 * pi - @angle) * @radius) + @y
      @vertices[#@vertices + 1] = {x:x, y:y}

  --- tests if a given point is inside the poly.
  -- @tparam number x
  -- @tparam number y
  -- @treturn boolean
  contains: (x, y) =>
    point = {x:x, y:y}
    p1, p2 = {x:0, y:0}, {x:0, y:0}
    vertsNum = #@vertices
    angle = 0

    for i = 1, vertsNum, 1
      p1.x = @vertices[i].x - point.x
      p1.y = @vertices[i].y - point.y
      if (i+1) % vertsNum ~= 0
        p2.x = @vertices[(i+1) % vertsNum].x - point.x
        p2.y = @vertices[(i+1) % vertsNum].y - point.y
        angle += getAngle p1.x, p1.y, p2.x, p2.y

    if math.abs(angle) < math.pi
      return false
    else
      return true


  --- getter for vertices.
  -- @treturn table
  getVertices: =>
    vertices = {}

    for i = 1,#@vertices do
      vertices[2*i-1] = @vertices[i].x
      vertices[2*i]   = @vertices[i].y

    vertices

  -- setter for radius.
  -- @tparam number radius
  setRadius: (radius) =>
    assert (type(radius) == 'number'),
      "radius must be of type number."
    @radius = radius
    @calcVertices!

  --- getter for radius.
  -- @treturn number
  getRadius: =>
    @radius

  --- setter for position.
  -- @tparam number x
  -- @tparam number y
  setPosition: (x = @x, y = @y) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."
    @x, @y = x, y
    @calcVertices!

  --- getter for position.
  -- @treturn number
  getPosition: =>
    @x, @y

  --- setter for sides.
  -- @tparam number sides
  setSides: (sides) =>
    assert (type(sides) == 'number'),
      "sides must be of type number."
    @sides = sides

    if sides == 3
      @angle = @angle or math.pi
    elseif sides == 4
      @angle = @angle or math.pi/4

    @calcVertices!


  --- getter for sides.
  -- @treturn number
  getSides: =>
    @sides

  --- setter for angle.
  -- @tparam number angle
  setAngle: (angle) =>
    assert (type(angle) == 'number'),
      "angle must be of type number."
    @angle = angle
    @calcVertices!

  --- getter for angle.
  -- @treturn number
  getAngle: =>
    @angle






