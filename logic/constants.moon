export EntityTypes = {}

EntityTypes.player = "Player"
EntityTypes.turret = "Turret"
EntityTypes.enemy  = "Enemy"
EntityTypes.item   = "Item"
EntityTypes.health = "Health"
EntityTypes.coin   = "Coin"
EntityTypes.bullet = "Bullet"
EntityTypes.goal   = "Goal"

EntityTypes.layers = {}

EntityTypes.layers[EntityTypes.player] = 5
EntityTypes.layers[EntityTypes.turret] = 2
EntityTypes.layers[EntityTypes.enemy]  = 4
EntityTypes.layers[EntityTypes.item]   = 3
EntityTypes.layers[EntityTypes.health] = 3
EntityTypes.layers[EntityTypes.coin]   = 3
EntityTypes.layers[EntityTypes.bullet] = 1
EntityTypes.layers[EntityTypes.goal]   = 2

export GoalTypes = {}

GoalTypes.attack = "Attack"
GoalTypes.defend = "Defend"

export EnemyTypes = {}

EnemyTypes.player  = "PlayerEnemy"
EnemyTypes.turret  = "TurretEnemy"
EnemyTypes.spawner = "SpawnerEnemy"
EnemyTypes.strong  = "StrongEnemy"
EnemyTypes.basic   = "BasicEnemy"

export Scaling = {}

Scaling.health = 5
Scaling.damage = 0.5
Scaling.speed  = 5

export Screen_State = {}

Screen_State.main_menu  = "Main Menu"
Screen_State.pause_menu = "Pause Menu"
Screen_State.game_over  = "Game Over"
Screen_State.upgrade    = "Upgrade"
Screen_State.scores     = "Scores"
Screen_State.loading    = "Loading"
Screen_State.none       = "None"

export Game_State = {}

Game_State.main_menu = "Main Menu"
Game_State.paused    = "Paused"
Game_State.game_over = "Game Over"
Game_State.playing   = "Playing"
Game_State.upgrading = "Upgrading"
Game_State.none      = "None"

export Screen_Size = {}

Screen_Size.width       = love.graphics.getWidth!
Screen_Size.height      = love.graphics.getHeight!
Screen_Size.half_width  = Screen_Size.width / 2
Screen_Size.half_height = Screen_Size.height / 2
