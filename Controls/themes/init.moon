-- t = assert(require(MeowUI.root .. "Controls.Style"))[MeowUI.theme]
path = MeowUI.root .. "Controls.themes" .. "."

Themes = 
  ["default"]: -> assert(require(path.."default")[1])
  ["blues"]: -> assert(require(path.."blues")[1])


Themes