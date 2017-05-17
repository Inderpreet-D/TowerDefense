do
  local _class_0
  local _parent_0 = Enemy
  local _base_0 = {
    __tostring = function(self)
      return "T: " .. self.enemyType .. "\tH: " .. self.max_health .. "\tD: " .. self.damage .. "\tS: " .. self.max_speed
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("enemy/tracker.tga", 25, 25, 1, 2)
      _class_0.__parent.__init(self, x, y, sprite)
      self.enemyType = EnemyTypes.basic
      self.score_value = 100
      self.health = 5 + (2.5 * Objectives:getLevel())
      self.max_health = self.health
      self.max_speed = 150 + (5 * Objectives:getLevel())
      self.speed_multiplier = self.max_speed
      self.damage = 1 + (1 * Objectives:getLevel())
    end,
    __base = _base_0,
    __name = "BasicEnemy",
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
  BasicEnemy = _class_0
end
