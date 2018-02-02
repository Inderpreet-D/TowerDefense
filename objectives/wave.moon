export class Wave
  new: (parent) =>
    @elapsed = 0
    @delay = 5
    @waiting = true
    @complete = false
    @parent = parent

  start: =>
    return

  finish: =>
    Driver\killEnemies!

  entityKilled: (entity) =>
    return

  update: (dt) =>
    if @waiting
      @elapsed += dt
      if @elapsed >= @delay
        @elapsed = 0
        @waiting = false
        @start!

  draw: =>
    if @waiting
      love.graphics.push "all"
      -- TODO: Fix this to be right aligned
      message = (@delay - math.floor @elapsed)
      Renderer\drawStatusMessage message, love.graphics.getHeight! / 2, (Renderer\newFont 250), Color 255, 255, 255, 255
      Renderer\drawAlignedMessage "Next wave in: " .. message .. "\t", 50 * Scale.height, "right", (Renderer\newFont 30)
      love.graphics.pop!
