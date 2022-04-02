-- @local

love = love

import random from love.math

Utils = {}


with Utils
  .Uid = ->
    f = (x) ->
      r = random(16) - 1
      r = (x == "x") and (r + 1) or (r % 4) + 9
      return ("0123456789abcdef")\sub r, r
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx")\gsub("[xy]", f))

  .Copy = (t) ->
    out = {}
    for k, v in pairs t
      out[k] = v
    out

  .GetTableKeys = (tab) ->
    keyset = {}
    for k,_ in pairs(tab)
      keyset[#keyset + 1] = k
    keyset

Utils
