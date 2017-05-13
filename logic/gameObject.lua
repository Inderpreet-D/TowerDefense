do
  local _class_0
  local _base_0 = {
    getHitBox = function(self)
      return self.sprite:getBounds(self.position.x, self.position.y)
    end,
    onCollide = function(self, object)
      if not self.alive then
        return 
      end
      self.health = self.health - object.damage
    end,
    kill = function(self)
      local score = SCORE + self.score_value
      SCORE = score
      self.alive = false
      self.health = 0
    end,
    update = function(self, dt)
      if not self.alive then
        return 
      end
      self.sprite:update(dt)
      local start = Vector(self.position.x, self.position.y)
      self.elapsed = self.elapsed + dt
      self.position:add(self.speed:multiply(dt))
      local radius = self:getHitBox().radius
      self.position.x = MathHelper:clamp(self.position.x, radius, love.graphics.getWidth() - radius)
      self.position.y = MathHelper:clamp(self.position.y, radius, love.graphics.getHeight() - radius)
      if self.id == EntityTypes.bullet then
        return 
      end
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          if not ((self.id == EntityTypes.player and o.id == EntityTypes.turret) or (self.id == EntityTypes.turret and o.id == EntityTypes.player)) then
            if o ~= self and o.id ~= EntityTypes.bullet then
              local other = o:getHitBox()
              local this = self:getHitBox()
              if other:contains(this) then
                self.position = start
                local dist = other:getCollisionDistance(this)
                dist = math.sqrt(math.sqrt(dist))
                local dist_vec = Vector(dist, dist)
                if self.speed:getLength() > 0 then
                  if self.id ~= EntityTypes.player then
                    self.position:add(dist_vec:multiply(-1))
                  end
                end
                if o.speed:getLength() > 0 then
                  if o.id ~= EntityTypes.player then
                    o.position:add(dist_vec)
                  end
                end
              end
            end
          end
        end
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      self.sprite:draw(self.position.x, self.position.y)
      if self.draw_health then
        love.graphics.setColor(0, 0, 0, 255)
        local radius = self.sprite.scaled_height / 2
        love.graphics.rectangle("fill", (self.position.x - radius) - 3, (self.position.y + radius) + 3, (radius * 2) + 6, 16)
        love.graphics.setColor(0, 255, 0, 255)
        local ratio = self.health / self.max_health
        love.graphics.rectangle("fill", self.position.x - radius, (self.position.y + radius) + 6, (radius * 2) * ratio, 10)
      end
      return love.graphics.pop()
    end,
    isOnScreen = function(self, radius)
      if radius == nil then
        radius = 0
      end
      if not self.alive then
        return false
      end
      local circle = self:getHitBox()
      circle.radius = circle.radius + radius
      local x, y = circle.center:getComponents()
      radius = circle.radius
      local xOn = x - radius >= 0 and x + radius <= love.graphics.getWidth()
      local yOn = y - radius >= 0 and y + radius <= love.graphics.getHeight()
      return xOn and yOn
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite, x_speed, y_speed)
      if x_speed == nil then
        x_speed = 0
      end
      if y_speed == nil then
        y_speed = 0
      end
      self.position = Vector(x, y)
      self.speed = Vector(x_speed, y_speed)
      self.sprite = sprite
      self.elapsed = 0
      self.health = 5
      self.max_health = self.health
      self.damage = 1
      self.alive = true
      self.id = nil
      self.draw_health = true
      self.score_value = 0
    end,
    __base = _base_0,
    __name = "GameObject"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  GameObject = _class_0
end
