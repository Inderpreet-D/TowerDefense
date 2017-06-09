export class EliminationWave extends Wave
  new: (parent, num) =>
    super parent
    @killed = 0
    @target = 0
    @queue = {}
    @to_spawn = 0

    for i = 1, num
      enemy, value = @parent.parent\getRandomEnemy!

      @target += value
      @queue[#@queue + 1] = enemy

--    for k, v in pairs @queue
--      print k .. ", " .. v

  entityKilled: (entity) =>
    if entity.id == EntityTypes.enemy or entity.enemyType
      @killed += 1
      @to_spawn += entity.value
      while @to_spawn >= 1 and #@queue ~= 0
        enemy = @queue[1]
        @parent.parent\spawn enemy
        table.remove @queue, 1
        @to_spawn -= 1

  start: =>
    num = math.min 4, #@queue
    for i = 1, num
      enemy = @queue[1]
--      print "Spawning: " .. enemy
      @parent.parent\spawn enemy
      table.remove @queue, 1


  update: (dt) =>
    super dt
    if @killed >= @target and Driver\isClear!
      @complete = true

  draw: =>
    num = @target - @killed
    message = "enemies"
    if num == 1
      message = "enemy"
    @parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
    super!
