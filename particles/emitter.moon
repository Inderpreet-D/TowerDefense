export class ParticleEmitter extends GameObject
  new: (x, y, delay, life_time, parent) =>
    sprite = Sprite "particle/particle.tga", 32, 32, 1, 0.5
    sprite\setColor {0, 0, 0, 0}
    super x, y, sprite
    @emitting = true
    @delay = delay
    @life_time = life_time
    @id = EntityTypes.particle
    @draw_health = false
    @parent = parent
    @shader = nil
    @particle_type = ParticleTypes.normal
    @moving_particles = true

  start: =>
    @emitting = true

  stop: =>
    @emitting = false

  update: (dt) =>
    if @parent
      if @parent.alive
        @position = @parent.position
      else
        @kill!
    @elapsed += dt
    if @emitting and @elapsed >= @delay
      @elapsed = 0
      particle = switch @particle_type
        when ParticleTypes.normal
          Particle @position.x, @position.y, @sprite, 200, 50, @life_time
        when ParticleTypes.poison
          PoisonParticle @position.x, @position.y, @sprite, 200, 50, @life_time
      if @moving_particles
        x, y = getRandomUnitStart!
        particle.speed = Vector x, y, true
        particle.speed = particle.speed\multiply 250 * Scale.diag
      particle\setShader @shader, true
      Driver\addObject particle, EntityTypes.particle
