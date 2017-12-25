export class ExtraLifePassive extends PassiveItem
  new: =>
    sprite = Sprite "item/extraLife.tga", 26, 26, 1, 56 / 26
    effect = (player) =>
      player.lives += 1
    super sprite, nil, effect
    @name = "Heart"
    @description = "Gives an extra life"

  unequip: (player) =>
    super player
    player.lives = 1
