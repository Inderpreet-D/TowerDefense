do
  local _parent_0 = Mode
  local _base_0 = {
    start = function(self)
      self.time_remaining = 90
      for k, p in pairs(self.point_positions) do
        local goal = CaptureGoal(p.x, p.y)
        goal.num = k
        goal.tesseract = tess
        Driver:addObject(goal, EntityTypes.goal)
      end
      return _parent_0.start(self)
    end,
    nextWave = function(self)
      _parent_0.nextWave(self)
      self.wave = CaptureWave(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent)
      _parent_0.__init(self, parent)
      self.objective_text = "Destroy the objective"
      self.mode_type = ModeTypes.capture
      local x_space = 100
      local y_space = 100
      self.point_positions = {
        Vector(x_space * Scale.width, Screen_Size.height - Screen_Size.border[2] - (y_space * Scale.height)),
        Vector(Screen_Size.width - (x_space * Scale.width), Screen_Size.height - Screen_Size.border[2] - (y_space * Scale.height)),
        Vector(Screen_Size.width / 2, Screen_Size.border[2] + (y_space * Scale.height))
      }
    end,
    __base = _base_0,
    __name = "CaptureMode",
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
  CaptureMode = _class_0
end
