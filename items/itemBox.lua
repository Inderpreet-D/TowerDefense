do
  local _class_0
  local _parent_0 = Item
  local _base_0 = {
    pickup = function(self, player)
      self.collectable = false
      self.contact_damage = false
      self.solid = false
      Inventory.boxes = Inventory.boxes + 1
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("item/box.tga", 32, 32, 1, 1.75)
      _class_0.__parent.__init(self, x, y, sprite)
      self.name = "Item Box"
      self.description = "Open to get a random item"
    end,
    __base = _base_0,
    __name = "ItemBox",
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
  ItemBox = _class_0
end
