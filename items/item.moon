export class Item extends GameObject
  @probability = 1
  new: (x, y, sprite) =>
    super x, y, sprite
    @item_type = nil
    @collectable = true
    @draw_health = false
    @contact_damage = true
    @id = EntityTypes.item
    @player = nil
    @timer = 0
    @solid = true
    @damage = 0
    @name = "No name"
    @description = "No description"

  pickup: (player) =>
    table.insert player.equipped_items, @
    @collectable = false
    @contact_damage = false
    @solid = false
    @player = player
    print "Equipped " .. @name

  unequip: (player) =>
    for k, i in pairs player.equipped_items
      if i.name == @name
        table.remove player.equipped_items, k
        successful = true
        break
    print "Unequipped " .. @name

  use: =>
    return

  update2: (dt) =>
    @timer += dt

  update: (dt) =>
    if @collectable
      super dt
    else
      @update2 dt

  draw2: =>
    return

  draw: =>
    if @collectable
      super!
    else
      @draw2!