do
  local _class_0
  local _parent_0 = UIElement
  local _base_0 = {
    setItem = function(self, item)
      self.empty = item.__class == NullItem
      self.item = item
      self.normal_sprite = self.item.sprite:getCopy()
      self.normal_sprite:scaleUniformly(2)
      self.sprite = self.normal_sprite:getCopy()
      self.small_sprite = self.normal_sprite:getCopy()
      return self.small_sprite:scaleUniformly(0.75)
    end,
    scaleUniformly = function(self, scale)
      self.sprite:scaleUniformly(scale)
      self.normal_sprite:scaleUniformly(scale)
      self.small_sprite:scaleUniformly(scale)
      self.width = self.width * scale
      self.height = self.height * scale
      self.x = self.center.x - (self.width / 2)
      self.y = self.center.y - (self.height / 2)
    end,
    isHovering = function(self, x, y)
      local xOn = self.x <= x and self.x + self.width >= x
      local yOn = self.y <= y and self.y + self.height >= y
      return xOn and yOn
    end,
    mousepressed = function(self, x, y, button, isTouch)
      if self.phase == 2 then
        for k, b in pairs(self.buttons) do
          b:mousepressed(x, y, button, isTouch)
        end
      end
    end,
    mousereleased = function(self, x, y, button, isTouch)
      if self.phase == 2 then
        for k, b in pairs(self.buttons) do
          b:mousereleased(x, y, button, isTouch)
        end
      end
    end,
    update = function(self, dt)
      if love.mouse.isDown(1) then
        if self:isHovering(love.mouse.getPosition()) then
          if self.usable then
            self.phase = 2
            self.sprite = self.small_sprite
          end
          Inventory:set_message(self.item.name, self.item.description)
        else
          self.phase = 1
          self.sprite = self.normal_sprite
        end
      end
      for k, b in pairs(self.buttons) do
        if self.phase == 2 then
          b:update(dt)
        end
        b.active = self.phase == 2
      end
      return self.sprite:update(dt)
    end,
    draw = function(self)
      love.graphics.push("all")
      love.graphics.setColor(200, 200, 200, 255)
      love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
      if self.phase == 1 then
        self.sprite:draw(self.center.x, self.center.y)
      else
        self.sprite:draw(self.center.x, self.y + (self.height * 0.35))
        for k, b in pairs(self.buttons) do
          b:draw()
        end
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, item)
      _class_0.__parent.__init(self, x, y)
      if item then
        self:setItem(item)
        self.usable = true
      else
        self:setItem((NullItem(0, 0)))
        self.usable = false
      end
      self.width = 150 * Scale.width
      self.height = 150 * Scale.height
      self.center = Point(self.x, self.y)
      self.x = self.x - (self.width / 2)
      self.y = self.y - (self.height / 2)
      self.phase = 1
      self.frameType = ItemFrameTypes.default
      local check_button = Button(self.x + (self.width * 0.5) - (50 * Scale.width), self.y + self.height - (25 * Scale.height), 50 * Scale.width, 50 * Scale.height, "", function(self)
        if self.master.frameType == ItemFrameTypes.transfer then
          local frames = UI:filter(ItemFrame)
          local equipped = false
          local slot = ""
          if self.master.item.item_type == ItemTypes.active then
            slot = "active"
            for k, f in pairs(frames) do
              if f.frameType == ItemFrameTypes.active then
                if f.empty then
                  f:setItem(self.master.item)
                  f.usable = true
                  self.master:setItem(NullItem(0, 0))
                  self.master.phase = 1
                  self.master.sprite = self.master.normal_sprite
                  self.master.usable = false
                  equipped = true
                  break
                end
              end
            end
          else
            for k, f in pairs(frames) do
              slot = "passive"
              if f.frameType == ItemFrameTypes.passive then
                if f.empty then
                  f:setItem(self.master.item)
                  f.usable = true
                  self.master:setItem(NullItem(0, 0))
                  self.master.phase = 1
                  self.master.sprite = self.master.normal_sprite
                  self.master.usable = false
                  equipped = true
                  break
                end
              end
            end
          end
          if equipped then
            return Inventory:set_message("", "Item stored")
          else
            return Inventory:set_message("Item can't be stored", "No " .. slot .. " item slot available")
          end
        else
          local frames = UI:filter(ItemFrame)
          local equipped = nil
          local slot = ""
          if self.master.item.item_type == ItemTypes.active then
            slot = "Active"
            for k, f in pairs(frames) do
              if f.frameType == ItemFrameTypes.equippedActive then
                equipped = f
                break
              end
            end
          else
            slot = "Passive"
            for k, f in pairs(frames) do
              if f.frameType == ItemFrameTypes.equippedPassive then
                equipped = f
                break
              end
            end
          end
          if equipped.empty then
            equipped:setItem(self.master.item)
            equipped.usable = false
            self.master:setItem(NullItem(0, 0))
            self.master.phase = 1
            self.master.sprite = self.master.normal_sprite
            self.master.usable = false
            if Driver.objects[EntityTypes.player] then
              for k, p in pairs(Driver.objects[EntityTypes.player]) do
                equipped.item:pickup(p)
              end
            end
          else
            local current_item, new_item = equipped.item, self.master.item
            equipped:setItem(new_item)
            equipped.usable = false
            self.master:setItem(current_item)
            self.master.phase = 1
            self.master.sprite = self.master.normal_sprite
            self.master.usable = true
            if Driver.objects[EntityTypes.player] then
              for k, p in pairs(Driver.objects[EntityTypes.player]) do
                new_item:pickup(p)
                current_item:unequip(p)
              end
            end
          end
          return Inventory:set_message("", equipped.item.name .. " equipped in " .. slot .. " slot")
        end
      end)
      check_button.master = self
      local check_sprite = Sprite("ui/button/check.tga", 32, 32, 1, 50 / 32)
      check_button:setSprite(check_sprite, check_sprite)
      local back_button = Button(self.x + (self.width * 0.5), self.y + self.height - (25 * Scale.height), 50 * Scale.width, 50 * Scale.height, "", function(self)
        self.master.phase = 1
        self.master.sprite = self.master.normal_sprite
      end)
      back_button.master = self
      local back_sprite = Sprite("ui/button/back.tga", 32, 32, 1, 50 / 32)
      back_button:setSprite(back_sprite, back_sprite)
      local trash_button = Button(self.x + (self.width * 0.5) + (50 * Scale.width), self.y + self.height - (25 * Scale.height), 50 * Scale.width, 50 * Scale.height, "", function(self)
        Inventory:set_message("", "Destroyed " .. self.master.item.name)
        self.master:setItem(NullItem(0, 0))
        self.master.phase = 1
        self.master.sprite = self.master.normal_sprite
        self.master.usable = false
      end)
      trash_button.master = self
      local trash_sprite = Sprite("ui/button/trash.tga", 32, 32, 1, 50 / 32)
      trash_button:setSprite(trash_sprite, trash_sprite)
      self.buttons = {
        check_button,
        back_button,
        trash_button
      }
    end,
    __base = _base_0,
    __name = "ItemFrame",
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
  ItemFrame = _class_0
end