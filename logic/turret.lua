do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      if not self.alive then
        return 
      end
      _class_0.__parent.__base.update(self, dt)
      if self.target then
        local enemy = self.target:getHitBox()
        local turret = self:getHitBox()
        local dist = Vector(enemy.center.x - turret.center.x, enemy.center.y - enemy.center.y)
        if dist:getLength() > self.range then
          self.target = nil
          return self:findTarget()
        else
          self.target:onCollide(self)
          if self.target.health <= 0 then
            self.target = nil
            return self:findTarget()
          end
        end
      else
        return self:findTarget()
      end
    end,
    findTarget = function(self)
      if not self.alive then
        return 
      end
      if Driver.objects[EntityTypes.enemy] then
        for k, v in pairs(Driver.objects[EntityTypes.enemy]) do
          local enemy = v:getHitBox()
          local turret = self:getHitBox()
          enemy.radius = enemy.radius + self.range
          if enemy:contains(turret.center) then
            self.target = v
            break
          end
        end
      end
    end,
    draw = function(self)
      if not self.alive then
        return 
      end
      if DEBUGGING then
        love.graphics.push("all")
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.circle("fill", self.position.x, self.position.y, self.range, 25)
        love.graphics.pop()
      end
      return _class_0.__parent.__base.draw(self)
    end,
    drawFaded = function(self)
      if not self.alive then
        return 
      end
      love.graphics.push("all")
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor(r, g, b, 50)
      love.graphics.circle("fill", self.position.x, self.position.y, self.range, 25)
      self.sprite:draw(self.position.x, self.position.y)
      return love.graphics.pop()
    end,
    isOnScreen = function(self)
      if not self.alive then
        return false
      end
      local circle = self:getHitBox()
      local x, y = circle.center:getComponents()
      local radius = self.range
      local xOn = x - radius >= 0 and x + radius <= love.graphics.getWidth()
      local yOn = y - radius >= 0 and y + radius <= love.graphics.getHeight()
      return xOn and yOn
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, range, sprite)
      _class_0.__parent.__init(self, x, y, sprite, 0, 0)
      self.range = self.sprite:getBounds().radius + range
      self.damage = 1 / 60
      self.target = nil
    end,
    __base = _base_0,
    __name = "Turret",
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
  Turret = _class_0
end
