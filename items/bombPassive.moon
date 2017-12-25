export class BombPassive extends PassiveItem
  new: =>
    @rarity = @getRandomRarity!
    cd = ({7, 6, 5, 4, 3})[@rarity]
    sprite = Sprite "item/bomb.tga", 32, 32, 1, 1.75
    effect = (player) =>
      x = math.random Screen_Size.border[1], Screen_Size.border[3]
      y = math.random Screen_Size.border[2], Screen_Size.border[4]
      bomb = Bomb x, y
      Driver\addObject bomb, EntityTypes.background
    super sprite, cd, effect
    @name = "Bomb"
    @description = "A bomb randomly spawns on the screen"
