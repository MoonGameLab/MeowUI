

Graphics = love.graphics
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control


class TextField extends Control
  new: (defaultText) =>
    -- Bounding box type
    super "Box", "TextField"

    @text = nil
    @chars = nil


    -- colors
    t = assert(require(MeowUI.root .. "Controls.Style"))[MeowUI.theme]
    colors = t.colors
    common = t.common