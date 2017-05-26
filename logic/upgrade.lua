do
  local _class_0
  local _base_0 = {
    update = function(self, dt) end,
    add_skill = function(self, tree, idx)
      print(tree, idx)
      local _exp_0 = tree
      if Upgrade_Trees.player_stats == _exp_0 then
        if self.player_stats[idx] < self.max_skill then
          self.player_stats[idx] = self.player_stats[idx] + 1
          self.skill_points = self.skill_points - 1
        end
      elseif Upgrade_Trees.turret_stats == _exp_0 then
        if self.turret_stats[idx] < self.max_skill then
          self.turret_stats[idx] = self.turret_stats[idx] + 1
          self.skill_points = self.skill_points - 1
        end
      elseif Upgrade_Trees.player_special == _exp_0 then
        if not self.player_special[idx] then
          self.player_special[idx] = true
          self.skill_points = self.skill_points - 1
        end
      elseif Upgrade_Trees.turret_special == _exp_0 then
        if not self.turret_special[idx] then
          self.turret_special[idx] = true
          self.skill_points = self.skill_points - 1
        end
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      for j = 0, 1 do
        for i = 1, 4 do
          local height = 40
          local width = 600
          local y = 100 + (i * 65) - (height / 2) + (400 * j)
          local x = 320
          local ratio = self.player_stats[i] / self.max_skill
          if j == 1 then
            ratio = self.turret_stats[i] / self.max_skill
          end
          love.graphics.setColor(178, 150, 0, 255)
          love.graphics.rectangle("fill", x, y, width, height)
          love.graphics.setColor(255, 215, 0, 255)
          love.graphics.rectangle("fill", x + 3, y + 3, (width - 6) * ratio, height - 6)
          love.graphics.setColor(0, 0, 0, 255)
          for i = x, x + width, width / self.max_skill do
            love.graphics.line(i, y, i, y + height)
          end
        end
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.skill_points = 0
      self.max_skill = 6
      self.player_stats = {
        0,
        0,
        0,
        0
      }
      self.turret_stats = {
        0,
        0,
        0,
        0
      }
      self.player_special = {
        false,
        false,
        false,
        false
      }
      self.turret_special = {
        false,
        false,
        false,
        false
      }
    end,
    __base = _base_0,
    __name = "Upgrade"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Upgrade = _class_0
end
