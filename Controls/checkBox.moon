----
-- CheckBox class (An example that you can use or build on.)
-- @usage c = CheckBox!

Graphics = love.graphics
MeowUI   = MeowUI
love     = love
Control  = MeowUI.Control
Mixins   = assert require MeowUI.root .. "Controls.Mixins"


class CheckBox extends Control

  @include Mixins.ColorMixins
  @include Mixins.EventMixins
  @include Mixins.ThemeMixins

  new: (type) =>
    -- Bounding box type
    super type, "Button"

    t = @getTheme!
    colors = t.colors
    common = t.common
    @stroke = common.stroke

    @downColor = colors.downColor
    @hoverColor = colors.hoverColor
    @upColor = colors.upColor
    @disabledColor = colors.disabledColor
    @strokeColor = colors.strokeColor
    @fontColor = colors.fontColor
    @alpha = 1

    @setEnabled true
