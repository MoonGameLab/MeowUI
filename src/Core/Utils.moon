-- @local

import random from love.math

Utils = {}


with Utils
  .Uid = ->
    f = (x) ->
      r = random(16) - 1
      r = (x == "x") and (r + 1) or (r % 4) + 9
      return ("0123456789abcdef")\sub r, r
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx")\gsub("[xy]", f))

  .Overrides = (parent, child, overrides) ->
    for i = 1, #overrides
      func = parent[overrides[i]]
      parent[overrides[i]] = (parent, ...) ->
        func parent, ...
        child[overrides[i]] child, ...

Utils
