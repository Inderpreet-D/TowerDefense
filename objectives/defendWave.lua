do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    spawnRandomEnemy = function(self)
      local spawnerChance = self.parent.parent.spawnerChance / 4
      local basicChance = self.parent.parent.basicChance + spawnerChance
      local playerChance = self.parent.parent.playerChance + spawnerChance
      local turretChance = self.parent.parent.turretChance + spawnerChance
      local strongChance = self.parent.parent.strongChance + spawnerChance
      return self.parent.parent:spawn(self.parent.parent:getRandomEnemy(basicChance, playerChance, turretChance, strongChance, 0))
    end,
    start = function(self)
      return self.parent.parent:spawn(GoalTypes.defend)
    end,
    entityKilled = function(self, entity)
      if entity.id == EntityTypes.goal then
        self.dead = self.dead + 1
      end
    end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if not self.waiting then
        self.elapsed = self.elapsed + dt
        self.target = self.target - dt
        if self.elapsed >= self.max_time and self.target > 0 then
          self.elapsed = 0
          self:spawnRandomEnemy()
        end
      end
      if self.dead > 0 then
        Driver.game_over()
      end
      if self.target <= 0 then
        self.complete = true
        return Driver:killEnemies()
      end
    end,
    draw = function(self)
      local message = "seconds"
      local num = math.floor(self.target)
      if num == 1 then
        message = "second"
      end
      self.parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      _class_0.__parent.__init(self, parent)
      self.target = 20
      self.dead = 0
      self.max_time = 2
    end,
    __base = _base_0,
    __name = "DefendWave",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DefendWave = _class_0
end