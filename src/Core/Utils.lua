local love = love
local random
random = love.math.random
local Utils = { }
do
  Utils.Uid = function()
    local f
    f = function(x)
      local r = random(16) - 1
      r = (x == "x") and (r + 1) or (r % 4) + 9
      return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", f))
  end
  Utils.Copy = function(t)
    local out = { }
    for k, v in pairs(t) do
      out[k] = v
    end
    return out
  end
  Utils.GetTableKeys = function(tab)
    local keyset = { }
    for k, _ in pairs(tab) do
      keyset[#keyset + 1] = k
    end
    return keyset
  end
end
return Utils
