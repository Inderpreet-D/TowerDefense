do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    onCollide = function(self, entity)
      if self.unlocked then
        if entity.id == EntityTypes.enemy and entity.enemyType == EnemyTypes.capture then
          self.capture_amount = self.capture_amount - entity.damage
          entity.health = 0
        else
          if entity.__class == Missile then
            self.capture_amount = self.capture_amount + 2
          else
            self.capture_amount = self.capture_amount + (2 / 60)
          end
        end
        self.capture_amount = clamp(self.capture_amount, 0, self.max_health)
      end
    end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      self.capture_amount = clamp(self.capture_amount, 0, self.max_health)
      if self.tesseract and self.unlocked then
        self.timer = self.timer + dt
        if self.timer >= self.attack_delay then
          self.timer = 0
          return self.tesseract:onCollide(self)
        end
      end
    end,
    draw = function(self)
      if self.tesseract and self.unlocked then
        local ratio = self.capture_amount / self.max_health
        local blue = math.floor((ratio * 255))
        local red = 255 - blue
        love.graphics.setColor(red, 127, blue, blue)
        love.graphics.setLineWidth(ratio * 20)
        love.graphics.line(self.position.x, self.position.y + (self.sprite.scaled_height * 0.33), self.tesseract.position.x, self.tesseract.position.y)
      end
      _class_0.__parent.__base.draw(self)
      love.graphics.push("all")
      love.graphics.setShader(Driver.shader)
      love.graphics.setColor(0, 0, 0, 255)
      local radius = self.sprite.scaled_height / 2
      love.graphics.rectangle("fill", (self.position.x - radius) - (3 * Scale.width), (self.position.y + radius) + (3 * Scale.height), (radius * 2) + (6 * Scale.width), 16 * Scale.height)
      love.graphics.setColor(0, 127, 255, 255)
      local ratio = self.capture_amount / self.max_health
      love.graphics.rectangle("fill", self.position.x - radius, (self.position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height)
      love.graphics.setColor(255, 127, 0, 255)
      love.graphics.rectangle("fill", self.position.x - radius + ((radius * 2) * ratio), (self.position.y + radius) + (6 * Scale.height), (radius * 2) * (1 - ratio), 10 * Scale.height)
      love.graphics.setShader()
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("objective/flag.tga", 34, 16, 1, 2.5)
      _class_0.__parent.__init(self, x, y, sprite)
      self.id = EntityTypes.goal
      self.goal_type = GoalTypes.capture
      self.health = 10
      self.max_health = self.health
      self.capture_amount = self.health / 2
      self.draw_health = false
      self.unlocked = false
      self.tesseract = nil
      self.timer = 0
      self.attack_delay = 1 / 60
      self.damage = (20 / 3) * self.attack_delay
      self.solid = false
    end,
    __base = _base_0,
    __name = "CaptureGoal",
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
  CaptureGoal = _class_0
end
