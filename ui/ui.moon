-- Class for handling UI elements
export class UI
  new: =>
    -- List of elements of the GUI
    @screens = {}
    @current_screen = Screen_State.none

    for k, v in pairs Screen_State
      @screens[v] = {}

  -- Add an element to the GUI
  add: (element, screen = @current_screen) =>
    @screens[screen][#@screens[screen] + 1] = element

  set_screen: (new_screen) =>
    @current_screen = new_screen

  keypressed: (key, scancode, isrepeat) =>
    for k, v in pairs @screens[@current_screen]
      v\keypressed key, scancode, isrepeat

  keyreleased: (key) =>
    for k, v in pairs @screens[@current_screen]
      v\keyreleased key

  mousepressed: (x, y, button, isTouch) =>
    for k, v in pairs @screens[@current_screen]
      v\mousepressed x, y, button, isTouch

  mousereleased: (x, y, button, isTouch) =>
    for k, v in pairs @screens[@current_screen]
      v\mousereleased x, y, button, isTouch

  focus: (focus) =>
    for k, v in pairs @screens[@current_screen]
      v\focus focus

  -- Update all the elements of the GUI
  -- dt: Time since last update
  update: (dt) =>
    for k, v in pairs @screens[@current_screen]
      v\update dt

  -- Draw the GUI elements
  draw: =>
    for k, v in pairs @screens[@current_screen]
      v\draw!
