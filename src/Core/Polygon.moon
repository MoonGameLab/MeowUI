
----
-- A polygon class
-- @classmod Polygon
-- @usage b = Polygon!

pi, cos, sin, tan, atan2, abs = math.pi, math.cos, math.sin, math.tan, math.atan2, math.abs
twoPi = 6.283185307179586476925287


-- @local
getAngle =  (x1, y1, x2, y2) ->
  local dtheta, theta1, theta2

  theta1 = atan2 y1, x1
  theta2 = atan2 y2, x2
  dtheta = theta2 - theta1

  while dtheta > pi
    dtheta -= twoPi
  while dtheta < -pi
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
    @verticesArray = {}
    @sides = n
    @x, @y = x, y
    @radius = radius
    if n == 3
      @angle = angle or pi
    elseif n == 4
      @angle = angle or pi/4
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
      @vertices[#@vertices + 1] = {x, y}
    
    @makeVerticesArray!

  --- tests if a given point is inside the poly.
  -- @tparam number x
  -- @tparam number y
  -- @treturn boolean
  contains: (x, y) =>
    x1, y1, x2, y2  = 0, 0, 0, 0
    vertsNum = #@vertices
    angle = 0

    for i = 1, vertsNum, 1
      x1 = @vertices[i][1] - x
      y1 = @vertices[i][2] - y
      if (i+1) % vertsNum ~= 0
        x2 = @vertices[(i+1) % vertsNum][1] - x
        y2 = @vertices[(i+1) % vertsNum][2] - y
        angle += getAngle x1, y1, x2, y2

    if abs(angle) < pi
      return false
    else
      return true

  -- @local
  makeVerticesArray: =>
    for i = 1,#@vertices do
      @verticesArray[2*i-1] = @vertices[i][1]
      @verticesArray[2*i]   = @vertices[i][2]

  --- getter for vertices.
  -- @treturn table
  getVertices: =>
    @verticesArray

  -- setter for radius.
  -- @tparam number radius
  setRadius: (radius) =>
    if radius == @radius then return
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
    if x == @x and y == @y then return
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
    if sides == @sides then return
    assert (type(sides) == 'number'),
      "sides must be of type number."
    @sides = sides

    if sides == 3
      @angle = @angle or pi
    elseif sides == 4
      @angle = @angle or pi/4

    @calcVertices!


  --- getter for sides.
  -- @treturn number
  getSides: =>
    @sides

  --- setter for angle.
  -- @tparam number angle
  setAngle: (angle) =>
    if angle == @angle then return
    assert (type(angle) == 'number'),
      "angle must be of type number."
    @angle = angle
    @calcVertices!

  --- getter for angle.
  -- @treturn number
  getAngle: =>
    @angle
