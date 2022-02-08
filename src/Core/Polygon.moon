
----
-- A polygon class
-- @classmod Polygon
-- @usage b = Polygon!

pi, cos, sin, tan = math.pi, math.cos, math.sin, math.tan

class Polygon

  --- constructor
  -- @tparam number x
  -- @tparam number y
  -- @tparam number n
  -- @tparam number radius
  -- @tparam number angle
  new: (x = 0, y = 0, n = 3, radius = 0, angle = 0) =>

    @vertices = {}
    @sides = n
    @x, @y = x, y
    @radius = radius
    @angle = angle
    @centroid = {x:@x, y:@y}
    @calcVertices!


  calcVertices: () =>
    @vertices = {}
    for i = @sides, 1, -1
      x, y = 0, 0
      x = ( sin( i / @sides * 2 * pi - @angle) * @radius) + @x
      y = ( cos( i / @sides * 2 * pi - @angle) * @radius) + @y
      @vertices[#@vertices + 1] = {x:x, y:y}

  getVertices: =>
    vertices = {}

    for i = 1,#@vertices do
      vertices[2*i-1] = @vertices[i].x
      vertices[2*i]   = @vertices[i].y

    vertices
