export class Driver
    new: =>
      @objects = {}
      @game_state = Game_State.none
      @state_stack = Stack!
      @state_stack\add Game_State.main_menu
      --@state_stack\add Game_State.upgrading
      @elapsed = 0
      @shader = nil
      love.keypressed = @keypressed
      love.keyreleased = @keyreleased
      love.mousepressed = @mousepressed
      love.mousereleased = @mousereleased
      love.focus = @focus
      love.load = @load
      love.update = @update
      love.draw = @draw

    addObject: (object, id) =>
      if @objects[id]
        @objects[id][#@objects[id] + 1] = object
        Renderer\add object, EntityTypes.layers[id]
      else
        @objects[id] = {}
        @addObject(object, id)

    removeObject: (object, player_kill = true) =>
      for k, v in pairs Driver.objects
        for k2, o in pairs v
          if object == o
            Renderer\removeObject object
            if player_kill
              v[k2]\kill!
              Objectives\entityKilled v[k2]
            v[k2] = nil
            break

    killEnemies: =>
      if Driver.objects[EntityTypes.enemy]
        for k, o in pairs Driver.objects[EntityTypes.enemy]
          @removeObject o, false
      if Driver.objects[EntityTypes.bullet]
        for k, b in pairs Driver.objects[EntityTypes.bullet]
          @removeObject b, false

    respawnPlayers: =>
      if Driver.objects[EntityTypes.player]
        for k, p in pairs Driver.objects[EntityTypes.player]
          p2 = Player p.position.x, p.position.y
          Driver\removeObject p, false
          Driver\addObject p2, EntityTypes.player

    isClear: =>
      sum = 0
      for k, v in pairs Driver.objects
        for k2, o in pairs v
          if k ~= EntityTypes.player and k ~= EntityTypes.turret
            sum += 1
      return sum == 0

    keypressed: (key, scancode, isrepeat) ->
      if key == "escape"
        love.event.quit 0
      elseif key == "p"
        if Driver.game_state == Game_State.paused
          Driver.unpause!
        else
          Driver.pause!
      else
        if not (Driver.game_state == Game_State.paused or Driver.game_state == Game_State.game_over)
          for k, v in pairs Driver.objects[EntityTypes.player]
            v\keypressed key

    keyreleased: (key) ->
      if not (Driver.game_state == Game_State.paused or Driver.game_state == Game_State.game_over)
        for k, v in pairs Driver.objects[EntityTypes.player]
          v\keyreleased key

    mousepressed: (x, y, button, isTouch) ->
      UI\mousepressed x, y, button, isTouch

    mousereleased: (x, y, button, isTouch) ->
      UI\mousereleased x, y, button, isTouch

    focus: (focus) ->
      if focus
        Driver.unpause!
      else
        Driver.pause!
      UI\focus focus

    pause: ->
      Driver.state_stack\add Driver.game_state
      Driver.game_state = Game_State.paused
      for k, o in pairs Driver.objects[EntityTypes.player]
        o.keys_pushed = 0
      UI.state_stack\add UI.current_screen
      UI\set_screen Screen_State.pause_menu

    unpause: ->
      Driver.game_state = Driver.state_stack\remove!
      UI\set_screen UI.state_stack\remove!

    game_over: ->
      Driver.game_state = Game_State.game_over
      UI\set_screen Screen_State.game_over

    load: (arg) ->
      --Driver.shader = love.graphics.newShader "shaders/map.fs"
      --Driver.shader = love.graphics.newShader "shaders/distance.fs"
      --Driver.shader\send "screen_size", Screen_Size.size

      ScreenCreator!

      -- Create a player
      player = Player love.graphics.getWidth! / 2, love.graphics.getHeight! / 2
      Driver\addObject player, EntityTypes.player

      -- Start game
      Objectives\nextMode!

    update: (dt) ->
      Driver.elapsed += dt
      --if Driver.objects[EntityTypes.player]
      --  for k, v in pairs Driver.objects[EntityTypes.player]
      --    Driver.shader\send "player_pos", {v.position.x, v.position.y}

      --alpha = math.cos Driver.elapsed
      --alpha = math.abs alpha
      --Driver.shader\send "alpha", alpha
      --print love.mouse.getPosition!

      --Driver.shader\send "time", Driver.elapsed

      switch Driver.game_state
        when Game_State.game_over
          return
        when Game_State.paused
          return
        when Game_State.playing
          for k, v in pairs Driver.objects
            for k2, o in pairs v
              o\update dt
              if o.health <= 0 or not o.alive
                Driver\removeObject o
          Objectives\update dt
        when Game_State.upgrading
          Upgrade\update dt
      UI\update dt

      if not Driver.shader
        Driver.shader = love.graphics.newShader "shaders/normal.fs"

    draw: ->
      love.graphics.push "all"
      love.graphics.setShader Driver.shader
      love.graphics.setColor 75, 163, 255, 255
      love.graphics.rectangle "fill", 0, 0, Screen_Size.width, Screen_Size.height
      love.graphics.setShader!
      love.graphics.pop!
      love.graphics.push "all"
      UI\draw!
      switch Driver.game_state
        when Game_State.playing
          love.graphics.push "all"
          love.graphics.setColor 15, 87, 132, 200
          bounds = Screen_Size.border
          love.graphics.rectangle "fill", 0, 0, bounds[3], bounds[2]
          love.graphics.rectangle "fill", 0, bounds[2] + bounds[4], bounds[3], bounds[2]
          love.graphics.pop!

          Renderer\drawAlignedMessage SCORE .. "\t", 20, "right", Renderer.hud_font
          Renderer\drawAll!
          Objectives\draw!
        when Game_State.upgrading
          Upgrade\draw!
      if DEBUGGING
        love.graphics.setColor 200, 200, 200, 100
        bounds = Screen_Size.border
        love.graphics.rectangle "fill", bounds[1], bounds[2], bounds[3], bounds[4]
      love.graphics.pop!

      before = math.floor collectgarbage "count"
      collectgarbage "step"
      after = math.floor collectgarbage "count"
      --print "B: " .. before .. "; A: " .. after .. "; R: " .. (before - after)
