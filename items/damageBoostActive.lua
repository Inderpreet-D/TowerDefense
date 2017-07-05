do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = {
    update2 = function(self, dt)
      _class_0.__parent.__base.update2(self, dt)
      if self.used then
        self.effect_sprite:update(dt)
        self.effect_timer = self.effect_timer + dt
        if self.effect_timer >= self.effect_time then
          self.effect_timer = 0
          self.used = false
          self.player.damage = Stats.player[3]
          return print("Restored: " .. self.player.damage)
        end
      end
    end,
    draw2 = function(self)
      _class_0.__parent.__base.draw2(self)
      if self.used then
        love.graphics.push("all")
        love.graphics.setShader(Driver.shader)
        self.effect_sprite:draw(self.player.position.x, self.player.position.y)
        love.graphics.setShader()
        return love.graphics.pop()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("item/damageBoost.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        print("Activated")
        print("B: " .. self.player.damage)
        self.player.damage = self.player.damage * 2
        print("A: " .. self.player.damage)
        self.used = true
      end
      _class_0.__parent.__init(self, x, y, sprite, 15, effect)
      self.name = "Damage Boost"
      self.description = "Gives a temporary boost to damage"
      self.used = false
      self.effect_time = 3
      self.effect_timer = 0
      self.effect_sprite = Sprite("effect/damageBoost.tga", 32, 32, 0.5, 2.25)
    end,
    __base = _base_0,
    __name = "DamageBoostActive",
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
  DamageBoostActive = _class_0
end
