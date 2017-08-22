export class HealingFieldActive extends ActiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    cd = ({15, 14, 13, 12, 11})[@rarity]
    sprite = Sprite "background/healingField.tga", 32, 32, 2, 1.75
    effect = (player) =>
      field = HealingField player.position.x, player.position.y
      Driver\addObject field, EntityTypes.background
    super x, y, sprite, cd, effect
    @name = "Healing Field"
    @description = "Place a healing field"
