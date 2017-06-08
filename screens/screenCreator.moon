export class ScreenCreator
  new: =>
    @createPauseMenu!
    @createGameOverMenu!
    @createUpgradeMenu!
    @createMainMenu!

  createHelp: =>
    keys = {}
    keys["space"] = Sprite "keys/space.tga", 32, 96, 1, 1
    for k, v in pairs {"w", "a", "s", "d", "p", "e", "z"}
      keys[v] = Sprite "keys/" .. v .. ".tga", 32, 32, 1, 1

    font = Renderer\newFont 20

    start_x = 100 * Scale.width
    start_y = Screen_Size.height * 0.4

    -- A key
    x = start_x
    y = start_y
    text = "Left"
    t = Text x, y, text, font
    UI\add t

    i = Icon x + (10 * Scale.width) + ((font\getWidth text) * Scale.width), y, keys["a"]
    UI\add i

    -- S key
    i = Icon x + (10 * Scale.width) + ((font\getWidth text) * Scale.width) + (50 * Scale.width), y, keys["s"]
    UI\add i

    x = start_x + (10 * Scale.width) + ((font\getWidth text) * Scale.width) + (50 * Scale.width)
    y = start_y + (36 * Scale.height)
    text = "Down"
    t = Text x, y, text, font
    UI\add t

    -- D key
    x = start_x + (10 * Scale.width) + ((font\getWidth "Left") * Scale.width) + (100 * Scale.width)
    y = start_y
    i = Icon x, y, keys["d"]
    UI\add i

    text = "Right"
    t = Text x + ((font\getWidth text) * Scale.width), y, text, font
    UI\add t

    -- W key
    x = start_x
    y = start_y
    i = Icon x + (10 * Scale.width) + ((font\getWidth "Left") * Scale.width) + (50 * Scale.width), y - (46 * Scale.height), keys["w"]
    UI\add i

    text = "Up"
    t = Text x + (10 * Scale.width) + ((font\getWidth "Left") * Scale.width) + (50 * Scale.width), y - (82 * Scale.height), text, font
    UI\add t

    -- P key
    x = (Screen_Size.width / 3) - (100 * Scale.width)
    y = start_y - (46 * Scale.height)
    i = Icon x, y, keys["p"]
    UI\add i

    text = "Pause"
    t = Text x, y - (36 * Scale.height), text, font
    UI\add t

    -- E key
    x = ((Screen_Size.width / 3) * 2) + (200 * Scale.width)
    y = start_y - (46 * Scale.height)
    i = Icon x, y, keys["e"]
    UI\add i

    text = "Toggle Turret"
    t = Text x, y - (36 * Scale.height), text, font
    UI\add t

    -- space key
    x = ((Screen_Size.width / 3) * 2) + (200 * Scale.width)
    y = start_y
    i = Icon x, y, keys["space"]
    UI\add i

    text = "Place/Repair Turret"
    t = Text x, y + (36 * Scale.height), text, font
    UI\add t

    -- Z key
    x = (Screen_Size.width / 3) - (100 * Scale.width)
    y = start_y + (46 * Scale.height)
    i = Icon x, y, keys["z"]
    UI\add i

    text = "Toggle Range"
    t = Text x, y + (36 * Scale.height), text, font
    UI\add t

  createMainMenu: =>
    UI\set_screen Screen_State.main_menu

    @createHelp!

    title = Text Screen_Size.width / 2, (Screen_Size.height / 4), "Tower Defense"
    UI\add title

    start_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Start", () ->
      Driver.game_state = Game_State.playing
      UI\set_screen Screen_State.none
    UI\add start_button

    exit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (32 * Scale.height), 250, 60, "Exit", () -> love.event.quit 0
    UI\add exit_button

  createPauseMenu: =>
    UI\set_screen Screen_State.pause_menu

    @createHelp!

    title = Text Screen_Size.width / 2, (Screen_Size.height / 3), "Game Paused"
    UI\add title

    names = {"Basic", "Player", "Spawner", "Strong", "Turret"}
    sprites = {(Sprite "enemy/tracker.tga", 32, 32, 1, 1.25), (Sprite "enemy/enemy.tga", 26, 26, 1, 0.75), (Sprite "projectile/dart.tga", 17, 17, 1, 2), (Sprite "enemy/bullet.tga", 26, 20, 1, 2), (Sprite "enemy/circle.tga", 26, 26, 1, 1.75)}

    for i = 1, #names
      x = map i, 1, #names, 100 * Scale.width, Screen_Size.width - (200 * Scale.width)
      y = Screen_Size.height * 0.8
      icon = Icon x, y, sprites[i]
      UI\add icon
      bounds = sprites[i]\getBounds x, y
      font = Renderer\newFont 20
      width = font\getWidth names[i]
      text = Text x + (10 * Scale.width) + bounds.radius + (width / 2), y, names[i], font
      UI\add text

    resume_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Resume", () ->
      Driver.unpause!
    UI\add resume_button

    restart_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (38 * Scale.height), 250, 60, "Restart", () -> Driver.restart!
    UI\add restart_button

    quit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (108 * Scale.height), 250, 60, "Quit", () -> love.event.quit 0
    UI\add quit_button

  createGameOverMenu: =>
    UI\set_screen Screen_State.game_over

    title = Text Screen_Size.width / 2, (Screen_Size.height / 2), "YOU LOSE!", Renderer.giant_font
    UI\add title

    restart_button = Button Screen_Size.width / 2, Screen_Size.height - (200 * Scale.height), 250, 60, "Restart", () -> Driver.restart!
    UI\add restart_button

    quit_button = Button Screen_Size.width / 2, Screen_Size.height - (130 * Scale.height), 250, 60, "Quit", () -> love.event.quit 0
    UI\add quit_button

  createUpgradeMenu: =>
    UI\set_screen Screen_State.upgrade

    bg = Background {255, 255, 255, 255}--{8, 167, 0, 255}
    UI\add bg

    title = Text Screen_Size.width / 2, 25 * Scale.height, "Upgrade"
    UI\add title

    UI\add Text 90 * Scale.width, 65 * Scale.width, "Player", Renderer.hud_font
    stats = {"Health", "Range", "Damage", "Speed", "Attack Delay", "Special"}

    for k, v in pairs stats
      y = (25 + (k * 65)) * Scale.height
      UI\add Text 190 * Scale.width, y, v, Renderer.small_font
      if k ~= #stats
        tt = Tooltip Screen_Size.width * (5 / 24), y - (30 * Scale.height), (() =>
          level = Upgrade.player_stats[k]
          if level == Upgrade.max_skill
            return "Upgrade Complete!"
          else
            modifier = 0
            if level > 0
              modifier = Upgrade.amount[1][k][level]
            amount = Upgrade.amount[1][k][level + 1] - modifier
            message = "  Player  " .. v .. "  by  " .. (string.format "%.3f", math.abs amount)
            if amount < 0
              message = "Decrease" .. message
            else
              message = "Increase" .. message
            return message
        ), Renderer\newFont 15
        tt2 = Tooltip Screen_Size.width * 0.72, y, (() =>
          level = Upgrade.player_stats[k]
          if level == Upgrade.max_skill
            return ""
          else
            modifier = 0
            if level > 0
              modifier = Upgrade.amount[1][k][level]
            amount = Upgrade.amount[1][k][level + 1] - modifier
            message = "("
            if amount < 0
              message ..= "-"
            else
              message ..= "+"
            message ..= (string.format "%.3f", math.abs amount) .. ")"
            return message
        ), Renderer\newFont 30, "right"
        tt2.color = {0, 225, 0, 255}
        b = TooltipButton 280 * Scale.width, y, 30, 30, "+", (() -> Upgrade\add_skill Upgrade_Trees.player_stats, k), nil, {tt, tt2}
        UI\add b
        UI\add tt
        UI\add tt2
      else
        specials = {"Life Steal", "Range Boost", "Bomb", "Speed Boost"}
        font = Renderer\newFont 15
        width = 0
        for k, v in pairs specials
          w = font\getWidth v
          if w > width
            width = w
        x = (280 + (width / 2)) * Scale.width
        for k, v in pairs specials
          b = Button x, y, width * 1.5, 30, v, (() =>
            result = Upgrade\add_skill Upgrade_Trees.player_special, k
            @active = not result
          ), font
          x += b.width + (10 * Scale.width)
          UI\add b

    UI\add Text 85 * Scale.width, 485 * Scale.height, "Turret", Renderer.hud_font
    stats = {"Health", "Range", "Damage", "Cooldown", "Attack Delay", "Special"}

    for k, v in pairs stats
      y = (450 + (k * 65)) * Scale.height
      UI\add Text 190 * Scale.width, y, v, Renderer.small_font
      if k ~= #stats
        tt = Tooltip Screen_Size.width * (5 / 24), y - (30 * Scale.height), (() =>
          level = Upgrade.turret_stats[k]
          if level == Upgrade.max_skill
            return "Upgrade Complete!"
          else
            modifier = 0
            if level > 0
              modifier = Upgrade.amount[2][k][level]
            amount = Upgrade.amount[2][k][level + 1] - modifier
            message = "  Turret  " .. v .. "  by  " .. string.format "%.3f", math.abs amount
            if amount < 0
              message = "Decrease" .. message
            else
              message = "Increase" .. message
            return message
        ), Renderer\newFont 15
        tt2 = Tooltip Screen_Size.width * 0.72, y, (() =>
          level = Upgrade.turret_stats[k]
          if level == Upgrade.max_skill
            return ""
          else
            modifier = 0
            if level > 0
              modifier = Upgrade.amount[2][k][level]
            amount = Upgrade.amount[2][k][level + 1] - modifier
            message = "("
            if amount < 0
              message ..= "-"
            else
              message ..= "+"
            message ..= (string.format "%.3f", math.abs amount) .. ")"
            return message
        ), Renderer\newFont 30, "right"
        tt2.color = {0, 225, 0, 255}
        b = TooltipButton 280 * Scale.width, y, 30, 30, "+", (() -> Upgrade\add_skill Upgrade_Trees.turret_stats, k), nil, {tt, tt2}
        UI\add b
        UI\add tt
        UI\add tt2
      else
        specials = {"Extra Turret", "Shield", "Multiple Targets", "Pickup"}
        font = Renderer\newFont 15
        width = 0
        for k, v in pairs specials
          w = font\getWidth v
          if w > width
            width = w
        --width *= Scale.width
        x = (280 + (width / 2)) * Scale.width
        for k, v in pairs specials
          b = Button x, y, width * 1.5, 30, v, (() =>
            result = Upgrade\add_skill Upgrade_Trees.turret_special, k
            @active = not result
          ), font
          x += b.width + (10 * Scale.width)
          UI\add b

    continue_button = Button Screen_Size.width - 150, Screen_Size.height - (32 * Scale.height), 200, 45, "Continue", () ->
      UI\set_screen Screen_State.none
      Driver.game_state = Game_State.playing
      Driver\respawnPlayers!
      Objectives\nextMode!
    UI\add continue_button
