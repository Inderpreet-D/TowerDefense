export class HomingProjectile extends GameObject
  new: (x, y, target, sprite) =>
    sprite = Sprite "bullet.tga", 32, 16, 1, 0.75
    super x, y, sprite
    @target = target
    @attack_range = 15 * Scale.diag
    @damage = 1 / 10
    @id = EntityTypes.bullet
    @draw_health = false

  update: (dt) =>
    if not @alive
      return
    if not @target
      @kill!
    @sprite\update dt

    @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
    @speed\toUnitVector!
    @speed = @speed\multiply 1000

    @position\add @speed\multiply dt

    vec = Vector 0, 0
    @sprite.rotation = @speed\getAngleBetween vec

    target = @target\getHitBox!
    bullet = @getHitBox!
    bullet.radius += @attack_range
    if target\contains bullet
      @target\onCollide @
      @kill!

  draw: =>
    if @speed\getLength! > 0
      if @target and @target.health > 0 and @alive
        if DEBUGGING
          love.graphics.push "all"
          love.graphics.setColor 255, 0, 255, 127
          enemy = @getHitBox!
          love.graphics.circle "fill", @position.x, @position.y, @attack_range + enemy.radius, 360
          love.graphics.pop!
        super!
