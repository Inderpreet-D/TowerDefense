do
  local _base_0 = {
    update = function(self, dt) end,
    draw = function(self) end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self) end,
    __base = _base_0,
    __name = "Screen"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Screen = _class_0
end
