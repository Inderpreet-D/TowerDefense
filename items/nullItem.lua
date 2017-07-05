do
  local _class_0
  local _parent_0 = Item
  local _base_0 = {
    getCopy = function(self)
      local item = NullItem(self.position.x, self.position.y)
      item.name = self.name
      item.description = self.description
      item.sprite = Sprite("item/empty.tga", 32, 32, 1, 1.75)
      return item
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("item/empty.tga", 32, 32, 1, 1.75)
      _class_0.__parent.__init(self, x, y, sprite)
      self.name = "Empty"
      self.description = "No item in this slot"
    end,
    __base = _base_0,
    __name = "NullItem",
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
  local self = _class_0
  self.probability = 0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  NullItem = _class_0
end
