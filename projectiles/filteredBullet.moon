export class FilteredBullet extends GameObject
  new: (x, y, damage, speed, filter = {}) =>
    sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 0.5
    super x, y, sprite
    @filter = filter
    @damage = damage
    @attack_range = 15 * Scale.diag
    @speed = speed
    @id = EntityTypes.bullet
    @draw_health = false
    @solid = false

    @trail = nil

    sound = Sound "player_bullet.ogg", 0.025, false, 1.125, true
    @death_sound = MusicPlayer\add sound

  update: (dt) =>
    if not @alive
      return

    if not (@isOnScreen Screen_Size.border)
      @health = 0
      return

    if @trail
      @trail\update dt
    @sprite\update dt
    @sprite.rotation = @speed\getAngle! + (math.pi / 2)

    @position\add @speed\multiply dt

    if #@filter == 0
      return

    for k, filter in pairs @filter
      if Driver.objects[filter]
        for k2, o in pairs Driver.objects[filter]
          target = o\getHitBox!
          bullet = @getHitBox!
          bullet.radius += @attack_range
          if target\contains bullet
            o\onCollide @
            MusicPlayer\play @death_sound
            @health = 0

  kill: =>
    super!
    if Upgrade.player_special[1]
      if Driver.objects[EntityTypes.player]
        for k, p in pairs Driver.objects[EntityTypes.player]
          p.health += Stats.player[3] * 0.01
          p.health = math.min p.health, p.max_health

  draw: =>
    if @speed\getLength! > 0
      if @alive
        if DEBUGGING
          love.graphics.push "all"
          love.graphics.setColor 255, 0, 255, 127
          love.graphics.circle "fill", @position.x, @position.y, @attack_range + @getHitBox!.radius, 360
          love.graphics.pop!
        super!
