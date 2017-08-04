export class SpawnerEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/dart.tga", 17, 17, 1, 2
    attack_speed = 0.65 - (0.01 * Objectives\getLevel!)
    attack_speed = math.max 0.4, attack_speed
    super x, y, sprite, 1, attack_speed
    @enemyType = EnemyTypes.spawner
    @score_value = 50

    @health = 12 + (13.2 * Objectives\getLevel!)
    @max_health = @health
    @max_speed = (150 + (10 * Objectives\getLevel!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 1 + (0.13 * Objectives\getLevel!)

    sound = Sound "spawner_enemy_death.ogg", 0.75, false, 1.25, true
    @death_sound = MusicPlayer\add sound

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed

  kill: =>
    super!

    enemy = PlayerEnemy @position.x - 10, @position.y
    enemy.solid = false
    enemy.value = 0.25
    Driver\addObject enemy, EntityTypes.enemy

    enemy = PlayerEnemy @position.x + 10, @position.y
    enemy.solid = false
    enemy.value = 0.25
    Driver\addObject enemy, EntityTypes.enemy

    enemy = PlayerEnemy @position.x, @position.y - 10
    enemy.solid = false
    enemy.value = 0.25
    Driver\addObject enemy, EntityTypes.enemy

    enemy = PlayerEnemy @position.x, @position.y + 10
    enemy.solid = false
    enemy.value = 0.25
    Driver\addObject enemy, EntityTypes.enemy
