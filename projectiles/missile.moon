export class Missile extends HomingProjectile
  new: (x, y) =>
    sprite = Sprite "projectile/missile.tga", 32, 16, 1, 1
    sprite\scaleUniformly 1.25, 1.50
    super x, y, nil, sprite
    @damage = Stats.player[3] * 120
    @speed_multiplier = 250
    @target = @findTarget!
    if not @target
      @kill!

  findTarget: =>
    targets = {}
    if Driver.objects[EntityTypes.enemy]
      targets = concatTables targets, Driver.objects[EntityTypes.enemy]
    if Driver.objects[EntityTypes.boss]
      targets = concatTables targets, Driver.objects[EntityTypes.boss]
    if Driver.objects[EntityTypes.goal]
      goals = {GoalTypes.attack, GoalTypes.capture, GoalTypes.tesseract}
      for k, g in pairs Driver.objects[EntityTypes.goal]
        if tableContains goals, g.goal_type
          table.insert targets, g
    return pick targets