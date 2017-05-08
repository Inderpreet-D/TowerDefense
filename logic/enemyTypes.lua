do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.player = "PlayerEnemy"
      self.turret = "TurretEnemy"
      self.spawner = "SpawnerEnemy"
      self.strong = "StrongEnemy"
      self.basic = "BasicEnemy"
      self.num_enemies = 5
    end,
    __base = _base_0,
    __name = "EnemyTypes"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EnemyTypes = _class_0
end
