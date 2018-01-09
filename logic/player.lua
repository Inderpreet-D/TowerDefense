do
  local _parent_0 = GameObject
  local _base_0 = {
    calcExp = function(self, level)
      return (6 * level * level) + 673
    end,
    getStats = function(self)
      local stats = { }
      stats[1] = self.max_health
      stats[2] = self.attack_range
      stats[3] = self.damage
      stats[4] = self.max_speed
      stats[5] = self.attack_speed
      return stats
    end,
    onCollide = function(self, object)
      if not self.alive then
        return 
      end
      if object.id == EntityTypes.item then
        object:pickup(self)
        return 
      end
      if not self.shielded then
        local damage = object.damage
        if self.slagged then
          damage = damage * 2
        end
        if self.armored then
          if object.id == EntityTypes.enemy and object.enemyType == EnemyTypes.turret then
            damage = damage / 2
          end
          self.armor = self.armor - damage
          if self.armor <= 0 then
            self.health = self.health + self.armor
          end
          self.armored = self.armor > 0
        else
          damage = object.damage
          if object.id == EntityTypes.enemy and object.enemyType == EnemyTypes.turret then
            damage = damage / 2
          end
          self.health = self.health - damage
          self.hit = true
        end
        if object.slagging then
          self.slagged = true
        end
      end
      self.health = clamp(self.health, 0, self.max_health)
      self.armor = clamp(self.armor, 0, self.max_armor)
    end,
    keypressed = function(self, key)
      if not self.alive or self.is_clone then
        return 
      end
      if not self.movement_blocked then
        self.last_pressed = key
        if key == Controls.keys.MOVE_LEFT then
          self.speed.x = self.speed.x - self.max_speed
        elseif key == Controls.keys.MOVE_RIGHT then
          self.speed.x = self.speed.x + self.max_speed
        elseif key == Controls.keys.MOVE_UP then
          self.speed.y = self.speed.y - self.max_speed
        elseif key == Controls.keys.MOVE_DOWN then
          self.speed.y = self.speed.y + self.max_speed
        end
        for k, v in pairs({
          Controls.keys.MOVE_LEFT,
          Controls.keys.MOVE_RIGHT,
          Controls.keys.MOVE_UP,
          Controls.keys.MOVE_DOWN
        }) do
          if key == v then
            self.keys_pushed = self.keys_pushed + 1
          end
        end
      end
      if key == Controls.keys.USE_ITEM then
        for k, v in pairs(self.equipped_items) do
          v:use()
        end
      elseif key == Controls.keys.TOGGLE_TURRET then
        if self.can_place then
          self.show_turret = not self.show_turret
        end
      elseif key == Controls.keys.USE_TURRET then
        if self.show_turret then
          local turret = BasicTurret(self.position.x, self.position.y, self.turret_cooldown)
          Driver:addObject(turret, EntityTypes.turret)
          MusicPlayer:play(self.place_sound)
          if Upgrade.turret_special[4] then
            local num_missiles = 12
            local angle = 2 * math.pi * (1 / num_missiles)
            local point = Vector(self:getHitBox().radius + (20 * Scale.diag), 0)
            for i = 1, num_missiles do
              local missile = TurretMissile(self.position.x + point.x, self.position.y + point.y)
              missile:setTurret(turret)
              if (i % 2) == 0 then
                missile.rotation_direction = -1
              end
              Driver:addObject(missile, EntityTypes.bullet)
              point:rotate(angle)
            end
          end
          if self.num_turrets < self.max_turrets then
            self.num_turrets = self.num_turrets + 1
            self.turret[#self.turret + 1] = turret
          elseif self.num_turrets == self.max_turrets then
            Driver:removeObject(self.turret[1])
            for i = 1, self.num_turrets - 1 do
              self.turret[i] = self.turret[i + 1]
            end
            self.turret[#self.turret] = turret
          end
          self.show_turret = false
          self.turret_count = self.turret_count - 1
          if self.turret_count == 0 then
            self.can_place = false
          end
          self.charged = false
        elseif self.turret then
          for k, v in pairs(self.turret) do
            local turret = v:getAttackHitBox()
            local player = self:getHitBox()
            player.radius = player.radius + self.repair_range
            if turret:contains(player) then
              if v.health < v.max_health then
                MusicPlayer:play(self.repair_sound)
              end
              v.health = v.health + 1
              v.health = clamp(v.health, 0, v.max_health)
            end
          end
        end
      elseif key == Controls.keys.SHOW_RANGE then
        SHOW_RANGE = not SHOW_RANGE
      end
    end,
    keyreleased = function(self, key)
      if not self.alive then
        return 
      end
      if not self.movement_blocked then
        self.last_released = key
        if self.keys_pushed > 0 then
          if key == Controls.keys.MOVE_LEFT then
            self.speed.x = self.speed.x + self.max_speed
          elseif key == Controls.keys.MOVE_RIGHT then
            self.speed.x = self.speed.x - self.max_speed
          elseif key == Controls.keys.MOVE_UP then
            self.speed.y = self.speed.y + self.max_speed
          elseif key == Controls.keys.MOVE_DOWN then
            self.speed.y = self.speed.y - self.max_speed
          end
          for k, v in pairs({
            Controls.keys.MOVE_LEFT,
            Controls.keys.MOVE_RIGHT,
            Controls.keys.MOVE_UP,
            Controls.keys.MOVE_DOWN
          }) do
            if key == v then
              self.keys_pushed = self.keys_pushed - 1
            end
          end
        end
      end
    end,
    update = function(self, dt)
      if not self.alive then
        return 
      end
      if self.keys_pushed == 0 or self.movement_blocked then
        self.speed = Vector(0, 0)
        _parent_0.update(self, dt)
      else
        local start = Vector(self.speed:getComponents())
        if self.speed:getLength() > self.max_speed then
          self.speed = self.speed:multiply(1 / (math.sqrt(2)))
        end
        local boost = Vector(self.speed_boost, 0)
        local angle = self.speed:getAngle()
        boost:rotate(angle)
        self.speed:add(boost)
        _parent_0.update(self, dt)
        self.speed = start
      end
      self.lock_sprite:update(dt)
      for k, i in pairs(self.equipped_items) do
        i:update(dt)
      end
      self.missile_timer = self.missile_timer + dt
      if self.missile_timer >= self.max_missile_time then
        self.missile_timer = 0
        if Upgrade.player_special[3] then
          local missile = Missile(self.position.x, self.position.y)
          Driver:addObject(missile, EntityTypes.bullet)
        end
      end
      for k, bullet_position in pairs(self.globes) do
        bullet_position:rotate(dt * 1.25 * math.pi)
      end
      if self.turret_count ~= self.max_turrets then
        if self.elapsed >= self.turret_cooldown then
          self.elapsed = 0
          self.turret_count = clamp(self.turret_count + 1, 0, self.max_turrets)
          self.can_place = true
          self.charged = false
        end
      else
        self.elapsed = 0
        self.charged = true
      end
      local boosted = false
      for k, v in pairs(self.turret) do
        if not v.alive then
          self.num_turrets = self.num_turrets - 1
          self.turret[k] = nil
        elseif Upgrade.player_special[2] then
          local turret = v:getAttackHitBox()
          local player = self:getHitBox()
          player.radius = player.radius + (v.range / 5)
          if turret:contains(player) then
            boosted = true
          end
        end
      end
      if boosted then
        self.range_boost = self.attack_range
      else
        self.range_boost = 0
      end
      self.speed_boost = 0
      self.attack_timer = self.attack_timer + dt
      local attacked = false
      local filters = {
        EntityTypes.enemy,
        EntityTypes.boss
      }
      if Driver.objects[EntityTypes.goal] then
        for k, v in pairs(Driver.objects[EntityTypes.goal]) do
          if v.goal_type == GoalTypes.attack then
            table.insert(filters, EntityTypes.goal)
            break
          end
        end
      end
      if self.attack_timer >= self.attack_speed then
        local bullet_speed = Vector(0, 0)
        if love.keyboard.isDown(Controls.keys.SHOOT_LEFT) then
          bullet_speed:add((Vector(-self.bullet_speed, 0)))
        end
        if love.keyboard.isDown(Controls.keys.SHOOT_RIGHT) then
          bullet_speed:add((Vector(self.bullet_speed, 0)))
        end
        if love.keyboard.isDown(Controls.keys.SHOOT_UP) then
          bullet_speed:add((Vector(0, -self.bullet_speed)))
        end
        if love.keyboard.isDown(Controls.keys.SHOOT_DOWN) then
          bullet_speed:add((Vector(0, self.bullet_speed)))
        end
        if bullet_speed:getLength() > 0 then
          local bullet = FilteredBullet(self.position.x, self.position.y, self.damage, bullet_speed, filters)
          bullet.max_dist = self:getHitBox().radius + (2 * (self.attack_range + self.range_boost))
          if self.knocking_back then
            bullet.sprite = self.knock_back_sprite
            bullet.knockback = true
          end
          if self.can_shoot then
            Driver:addObject(bullet, EntityTypes.bullet)
            attacked = true
          end
        end
      end
      if attacked then
        self.attack_timer = 0
      end
      for k2, filter in pairs(filters) do
        if Driver.objects[filter] then
          for k, v in pairs(Driver.objects[filter]) do
            local enemy = v:getHitBox()
            local player = self:getHitBox()
            player.radius = player.radius + (self.attack_range + self.range_boost)
            if enemy:contains(player) then
              if Upgrade.player_special[4] then
                self.speed_boost = self.speed_boost + (self.max_speed / 4)
              end
            end
          end
        end
      end
      self.speed_boost = math.min(self.speed_boost, self.max_speed)
      if Driver.objects[EntityTypes.goal] then
        for k, v in pairs(Driver.objects[EntityTypes.goal]) do
          if v.goal_type == GoalTypes.capture then
            local goal = v:getHitBox()
            local player = self:getHitBox()
            player.radius = player.radius + self.repair_range
            if goal:contains(player) then
              v:onCollide(self)
            end
          end
        end
      end
      if self.show_turret then
        local turret = BasicTurret(self.position.x, self.position.y)
        Renderer:enqueue((function()
          local _base_1 = turret
          local _fn_0 = _base_1.drawFaded
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)())
      end
      while self.exp >= self.next_exp do
        self.exp = self.exp - self.next_exp
        self.level = self.level + 1
        Upgrade:addPoint(1)
        self.next_exp = self:calcExp(self.level)
      end
    end,
    draw = function(self)
      if not self.alive then
        return 
      end
      for k, i in pairs(self.equipped_items) do
        i:draw()
      end
      if DEBUGGING then
        love.graphics.push("all")
        love.graphics.setColor(0, 0, 255, 100)
        local player = self:getHitBox()
        love.graphics.circle("fill", self.position.x, self.position.y, self.attack_range + player.radius + self.range_boost, 360)
        love.graphics.setColor(0, 255, 0, 100)
        love.graphics.circle("fill", self.position.x, self.position.y, self.speed_range, 360)
        love.graphics.pop()
      end
      _parent_0.draw(self)
      if self.movement_blocked and self.draw_lock then
        self.lock_sprite:draw(self.position.x, self.position.y)
      end
      if self.show_stats then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.setFont(self.font)
        local message = "Turret Cooldown"
        love.graphics.printf(message, 9 * Scale.width, Screen_Size.height - (47 * Scale.height) - self.font:getHeight() / 2, 205 * Scale.width, "center")
        local x_start = (9 * Scale.width)
        local remaining = clamp(self.elapsed, 0, self.turret_cooldown)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.rectangle("fill", x_start + Scale.width, love.graphics.getHeight() - (30 * Scale.height), 200 * Scale.width, 20 * Scale.height)
        love.graphics.setColor(0, 0, 255, 255)
        local ratio = remaining / self.turret_cooldown
        if self.charged then
          ratio = 1
        end
        love.graphics.rectangle("fill", x_start + (4 * Scale.width), love.graphics.getHeight() - (27 * Scale.height), 194 * ratio * Scale.width, 14 * Scale.height)
        message = self.turret_count .. "/" .. self.max_turrets
        Renderer:drawHUDMessage(message, (x_start + 205) * Scale.width, Screen_Size.height - (30 * Scale.height), self.font)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.rectangle("fill", (love.graphics.getWidth() / 2) - (200 * Scale.width), love.graphics.getHeight() - (45 * Scale.height), 400 * Scale.width, 20 * Scale.height)
        love.graphics.setColor(255, 0, 0, 255)
        ratio = self.health / self.max_health
        love.graphics.rectangle("fill", (love.graphics.getWidth() / 2) - (197 * Scale.width), love.graphics.getHeight() - (42 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height)
        if self.armored then
          love.graphics.setColor(0, 127, 255, 255)
          ratio = self.armor / self.max_armor
          love.graphics.rectangle("fill", (love.graphics.getWidth() / 2) - (197 * Scale.width), love.graphics.getHeight() - (42 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height)
        end
        Renderer:drawAlignedMessage("Player Health", Screen_Size.height - (57 * Scale.height), nil, self.font)
        local level_info = "Level: " .. self.level .. "\tExp: " .. (math.floor(self.exp)) .. "/" .. (self:calcExp((self.level + 1)))
        Renderer:drawAlignedMessage(level_info, Screen_Size.height - (12 * Scale.height), nil, self.font)
      end
      if SHOW_RANGE then
        love.graphics.setColor(0, 255, 255, 255)
        for k, bullet_position in pairs(self.globes) do
          local boost = Vector(self.range_boost, 0)
          local angle = bullet_position:getAngle()
          boost:rotate(angle)
          local x = self.position.x + bullet_position.x + boost.x
          local y = self.position.y + bullet_position.y + boost.y
          love.graphics.circle("fill", x, y, 8 * Scale.diag, 360)
        end
      end
    end,
    kill = function(self)
      self.lives = self.lives - 1
      if self.lives <= 0 then
        _parent_0.kill(self)
        return Driver.game_over()
      else
        self.health = self.max_health
        self.shielded = true
        return Driver:addObject(self, EntityTypes.player)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("player/test.tga", 16, 16, 2, 4)
      _parent_0.__init(self, x, y, sprite)
      self.sprite:setRotationSpeed(-math.pi / 2)
      self.max_health = Stats.player[1]
      self.attack_range = Stats.player[2]
      self.damage = Stats.player[3]
      self.max_speed = Stats.player[4]
      self.turret_cooldown = Stats.turret[4]
      self.attack_speed = Stats.player[5]
      self.health = self.max_health
      self.repair_range = 30 * Scale.diag
      self.keys_pushed = 0
      self.hit = false
      self.attack_timer = 0
      self.lives = 1
      self.id = EntityTypes.player
      self.draw_health = false
      self.font = Renderer:newFont(20)
      self.can_place = true
      self.max_turrets = 1
      if Upgrade.turret_special[1] then
        self.max_turrets = 2
      end
      self.num_turrets = 0
      self.turret = { }
      self.range_boost = 0
      self.speed_boost = 0
      self.missile_timer = 0
      self.max_missile_time = 5.5
      self.speed_range = self.sprite:getBounds().radius + (150 * Scale.diag)
      self.turret_count = self.max_turrets
      self.charged = true
      self.globes = { }
      self.globe_index = 1
      local bounds = self:getHitBox()
      local width = bounds.radius + self.attack_range
      local num = 5
      for i = 1, num do
        local angle = ((math.pi * 2) / num) * i
        local vec = Vector(width, 0)
        vec:rotate(angle)
        self.globes[i] = Vector(vec.x, vec.y)
      end
      self.equipped_items = { }
      self:setArmor(0, self.max_health)
      self.knocking_back = false
      self.knock_back_sprite = Sprite("projectile/knockback.tga", 26, 20, 1, 0.75)
      self.movement_blocked = false
      self.lock_sprite = Sprite("effect/lock.tga", 32, 32, 1, 1.75)
      self.draw_lock = true
      local sound = Sound("turret_repair.ogg", 0.50, false, 0.33, true)
      self.repair_sound = MusicPlayer:add(sound)
      sound = Sound("turret_place.ogg", 0.75, false, 0.5, true)
      self.place_sound = MusicPlayer:add(sound)
      self.show_stats = true
      self.is_clone = false
      self.level = 1
      self.exp = 0
      self.next_exp = self:calcExp((self.level + 1))
      self.can_shoot = true
      self.bullet_speed = self.max_speed * 1.25
    end,
    __base = _base_0,
    __name = "Player",
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
  Player = _class_0
end
