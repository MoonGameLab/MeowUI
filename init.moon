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

export MeowUI = {
    debug: true
    keyInput: true -- If you are using keyInput functions else disable it. (Some example controls will used it, so if you want to use them keep it as is).
    version: "v0.0.0.93"
    stage: "alpha"
    author: "Tourahi Amine"
}


MeowUI["cwd"]          = cwd
MeowUI["c_cwd"]        = c_cwd
MeowUI["root"]         = root
MeowUI["manager"]      = assert(require(MeowUI.cwd .. "Core.Manager")).getInstance!
MeowUI["Control"]      = assert require MeowUI.cwd .. "Core.Control"
MeowUI["Utils"]      = assert require MeowUI.cwd .. "Core.Utils"
MeowUI["theme"]        = "dark-green-neon"

