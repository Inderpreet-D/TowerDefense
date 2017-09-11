export class UpgradeScreen extends Screen
  new: =>
    super!

    @skill_points = 0
    --@skill_points = 160
    @max_skill = 6

    @player_stats = {0, 0, 0, 0, 0}
    @turret_stats = {0, 0, 0, 0, 0}
    @upgrade_cost = {1, 1, 2, 2, 3, 3}

    @player_special = {true, true, true, true}
    @turret_special = {true, true, true, true}

    @amount       = {}
    @amount[1]    = {}
    @amount[1][1] = {10, 20, 40, 60, 110, 160}
    @amount[1][2] = {25, 50, 80, 115, 155, 200}
    @amount[1][3] = {0.2, 0.5, 1.0, 1.5, 2.0, 2.8}
    @amount[1][4] = {5, 15, 35, 75, 100, 125}
    @amount[1][5] = {1, 2, 3, 4, 5, 6}

    @amount[2]    = {}
    @amount[2][1] = {5, 10, 20, 30, 55, 80}
    @amount[2][2] = {15, 30, 50, 70, 100, 150}
    @amount[2][3] = {0.25, 0.75, 1.25, 2.0, 2.8, 3.65}
    @amount[2][4] = {-2.5, -5.0, -7.5, -10.0, -12.5, -15.0}
    @amount[2][5] = {-1 / 540, -2 / 540, -3 / 540, -4 / 540, -5 / 540, -6 / 540}

    for k = 1, #@amount
      for k2 = 1, #@amount[k][2]
        @amount[k][2][k2] *= Scale.diag

    for k = 1, #@amount[1][4]
      @amount[1][4][k] *= Scale.diag

  add_point: (num) =>
    @skill_points += num

  add_skill: (tree, idx) =>
    success = false
    switch tree
      when Upgrade_Trees.player_stats
        if @player_stats[idx] < @max_skill
          if @skill_points >= @upgrade_cost[@player_stats[idx] + 1]
            @skill_points -= @upgrade_cost[@player_stats[idx] + 1]
            @player_stats[idx] += 1
            Stats.player[idx] = Base_Stats.player[idx] + (@amount[1][idx][@player_stats[idx]])--(@player_stats[idx] * @amount[1][idx])
            success = true
      when Upgrade_Trees.turret_stats
        if @turret_stats[idx] < @max_skill
          if @skill_points >= @upgrade_cost[@turret_stats[idx] + 1]
            @skill_points -= @upgrade_cost[@turret_stats[idx] + 1]
            @turret_stats[idx] += 1
            Stats.turret[idx] = Base_Stats.turret[idx] + (@amount[2][idx][@turret_stats[idx]])--(@turret_stats[idx] * @amount[2][idx])
            success = true
      when Upgrade_Trees.player_special
        if not @player_special[idx]
          if @skill_points >= 5
            @player_special[idx] = true
            @skill_points -= 5
            success = true
      when Upgrade_Trees.turret_special
        if not @turret_special[idx]
          if @skill_points >= 5
            @turret_special[idx] = true
            @skill_points -= 5
            success = true
    return success

  draw: =>
    love.graphics.push "all"
    for j = 0, 1
      for i = 1, #@player_stats
        height = 40 * Scale.height
        width = 600 * Scale.width
        y = (25 * Scale.height) + (i * 65 * Scale.height) - (height / 2) + (425 * j * Scale.height)
        x = (0.5 * Screen_Size.width) - (width / 2)
        ratio = @player_stats[i] / @max_skill
        if j == 1
          ratio = @turret_stats[i] / @max_skill

        love.graphics.setColor 178, 150, 0, 255
        love.graphics.rectangle "fill", x, y, width, height

        love.graphics.setColor 255, 215, 0, 255
        love.graphics.rectangle "fill", x + (3 * Scale.width), y + (3 * Scale.height), (width - (6 * Scale.width)) * ratio, height - (6 * Scale.height)

        love.graphics.setColor 0, 0, 0, 255
        for i = x, x + width, width / @max_skill
          love.graphics.line i, y, i, y + height

    message = "Skill Points: " .. @skill_points
    Renderer\drawHUDMessage message, Screen_Size.width * 0.80, 0
    love.graphics.pop!
