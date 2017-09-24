export class BossTest extends Boss
  new: (x, y) =>
    sprite = Sprite "objective/portal.tga", 56, 56, 1, 1.8
    super x, y, sprite
    @bossType = BossTypes.test

    @health = 2000
    @max_health = @health
    @max_speed = 225
    @speed_multiplier = @max_speed
    @damage = 0.02--0.5

    @sprite\setShader love.graphics.newShader "shaders/fader.fs"
    @sprite\setRotationSpeed -math.pi / 2

    @shader = love.graphics.newShader "shaders/distance.fs"
    @shader\send "screen_size", {Screen_Size.width, Screen_Size.height}
    if Driver.objects[EntityTypes.player]
      for k, v in pairs Driver.objects[EntityTypes.player]
        @shader\send "player_pos", {v.position.x, v.position.y}
        @target = v
        break

    @ai_phase = 1
    @ai_time = 0

    @threshold = 0.1
    @fade_speed = 1.5

  isVisible: =>
    return (((math.sin @fade_speed * @ai_time) + 1) / 2) >= @threshold

  onCollide: (object) =>
    if @isVisible!
      super object

  update: (dt) =>
    @ai_time += dt
    visible = @isVisible!
    @solid = visible
    @draw_health = visible
    @sprite.shader\send "alpha", ((math.sin @fade_speed * @ai_time) + 1) / 2
    @shader\send "player_pos", {@target.position.x, @target.position.y}
    switch @ai_phase
      when 1
        @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
        @speed\toUnitVector!
        @speed = @speed\multiply @speed_multiplier
        super dt
        if @ai_time >= (math.random 7, 12)
          @ai_time = 0
          @ai_phase += 1
          @speed = Vector 0, 0

          speeds = {{0, 1}, {1, 0}, {-1, 0}, {0, -1}, {1, 1}, {-1, -1}, {-1, 1}, {1, -1}}
          for k, speed in pairs speeds
            copy = @sprite\getCopy!
            copy\scaleUniformly 0.3
            b = LinearProjectile @position.x, @position.y, (Vector speed[1], speed[2]), copy
            b.sprite\setShader love.graphics.newShader "shaders/normal.fs"
            Driver\addObject b, EntityTypes.bullet
      when 2
        super dt
        if @ai_time >= (math.random 3, 6)
          @ai_time = 0
          @ai_phase = 1

          temp = Objectives\spawn (BossTest), EntityTypes.boss
          @position = temp.position
          Driver\removeObject temp, false
