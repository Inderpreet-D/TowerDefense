do
  local _class_0
  local _parent_0 = Mode
  local _base_0 = {
    nextWave = function(self)
      _class_0.__parent.__base.nextWave(self)
      self.wave = BossWave(self, pick(self.bosses))
    end,
    update = function(self, dt)
      if not self.complete then
        if not self.started then
          self:start()
        end
        if not self.wave.complete then
          self.wave:update(dt)
          local level = self.parent:getLevel() + 1
          self.message2 = "Level " .. level
          if self.wave.complete then
            return self.wave:finish()
          end
        else
          self.parent.difficulty = self.parent.difficulty + 2
          self.complete = true
          self.started = false
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      _class_0.__parent.__init(self, parent)
      self.objective_text = "Eliminate the boss"
      self.mode_type = ModeTypes.boss
      self.bosses = { }
      local i = 1
      for k, v in pairs(BossTypes) do
        self.bosses[i] = v
        i = i + 1
      end
    end,
    __base = _base_0,
    __name = "BossMode",
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
  BossMode = _class_0
end