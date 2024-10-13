local path = MeowUI.root .. "Controls.themes" .. "."
local Themes = {
  ["default"] = function()
    return assert(require(path .. "default")[1])
  end,
  ["blues"] = function()
    return assert(require(path .. "blues")[1])
  end
}
return Themes
