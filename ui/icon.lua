do
  local _parent_0 = UIElement
  local _base_0 = {
    update = function(self, dt)
      return self.sprite:update(dt)
    end,
    draw = function(self)
      return self.sprite:draw(self.x, self.y)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y, sprite)
      _parent_0.__init(self, x, y)
      self.sprite = sprite
    end,
    __base = _base_0,
    __name = "Icon",
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
  Icon = _class_0
end
