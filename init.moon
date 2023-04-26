--- A useful set of core classes that help you make an extensible set of UI controls.
-- * This GUI framework is an improved version of catui (https://github.com/wilhantian/catui)
-- * Credit : wilhantian (https://github.com/wilhantian)
--@author Tourahi Amine  (tourahi.amine@gmail.com)
--@license TODO
--@module MeowUI

path = ...
cwd = path .. ".src."
c_cwd = path .. ".Controls."
root = path .. "."
love = love
import keyboard from love

-- Love config
keyboard.setKeyRepeat true

export MeowUI = {
  debug: true
  keyInput: true -- If you are using keyInput functions else disable it. (Some example controls will used it, so if you want to use them keep it as is).
  version: "v0.0.0.116"
  stage: "alpha"
  author: "Tourahi Amine"
}

MeowUI["cwd"]          = cwd
MeowUI["c_cwd"]        = c_cwd
MeowUI["root"]         = root
MeowUI["manager"]      = assert require MeowUI.cwd .. "Core.Manager"
MeowUI["Control"]      = assert require MeowUI.cwd .. "Core.Control"
MeowUI["theme"]        = "dark-green-neon"
MeowUI["useThirdParty-utf8"]        = true -- utf8.lua - https://github.com/Stepets/utf8.lua

if MeowUI["useThirdParty-utf8"] 
  export utf8 = assert require(MeowUI.cwd .. "ThirdParty.utf8")\init!
