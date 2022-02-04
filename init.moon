--- A useful set of core classes that help you make an extensible set of UI controls.
-- * This GUI framework is an improved version of catui (https://github.com/wilhantian/catui)
-- * Credit : wilhantian (https://github.com/wilhantian)
--@author Tourahi Amine  (tourahi.amine@gmail.com)
--@license TODO
--@module MeowUI

path = ...
cwd = path .. ".src."

export MeowUI = {}
MeowUI.cwd = cwd

MeowUI = {
  manager: assert(require(MeowUI.cwd .. "Core.Manager")).getInstance!
  Control: assert require MeowUI.cwd .. "Core.Control"
}

