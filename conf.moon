love.conf = (t) ->
  t.console = true
  t.window.fullscreen = not true
  t.window.title = "Tower Defense"
  t.window.width = 1366
  t.window.height = 768
  t.window.vsync = true
  t.window.msaa = 8

  t.modules.joystick = false
  t.modules.physics = false
  t.modules.thread = false
  t.modules.touch = false
  t.modules.video = false
