Root = assert require MeowUI.cwd .. "Core.Root"


class Manager
  @callbacks: {
    'update'
    'draw'
    'mousemoved'
    'mousepressed'
    'mousereleased'
    'keypressed'
    'keyreleased'
    'wheelmoved'
    'textinput'
  }
  new: =>
