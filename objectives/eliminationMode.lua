do
  local _parent_0 = Mode
  local _base_0 = {
    nextWave = function(self)
      _parent_0.nextWave(self)
      local num = (((self.level_count - 1) * 3) + self.wave_count) * 3
      self.wave = EliminationWave(self, num + 5)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent)
      _parent_0.__init(self, parent)
      self.objective_text = "Eliminate all enemies"
      self.mode_type = ModeTypes.elimination
    end,
    __base = _base_0,
    __name = "EliminationMode",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
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
  EliminationMode = _class_0
end
