local path = ...
local cwd = path .. ".src."
local c_cwd = path .. ".Controls."
local root = path .. "."
local love = love
local keyboard
keyboard = love.keyboard
local os = love.system.getOS()
local _separator
if os == "Windows" then
  _separator = '\\'
else
  _separator = '/'
end
local _assets = root:gsub('%.', _separator)
keyboard.setKeyRepeat(true)
MeowUI = {
  debug = true,
  keyInput = true,
  version = "v0.1",
  stage = "Release-0.1",
  defTheme = "blues",
  author = "Tourahi Amine"
}
MeowUI["cwd"] = cwd
MeowUI["c_cwd"] = c_cwd
MeowUI["root"] = root
MeowUI["assets"] = _assets .. "Controls" .. _separator .. "assets" .. _separator
MeowUI["path_seperator"] = _separator
MeowUI["Control"] = assert(require(MeowUI.cwd .. "Core.Control"))
MeowUI["manager"] = assert(require(MeowUI.cwd .. "Core.Manager"))
MeowUI["theme"] = assert(require(MeowUI.root .. "Controls.themes")[MeowUI.defTheme]())
MeowUI["useThirdParty-utf8"] = true
if MeowUI["useThirdParty-utf8"] then
  utf8 = assert(require(MeowUI.cwd .. "ThirdParty.utf8"):init())
end
