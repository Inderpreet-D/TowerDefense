export class FreezeFieldActive extends ActiveItem
  new: =>
    @rarity = @getRandomRarity!
    cd = ({15, 14, 13, 12, 11})[@rarity]
    sprite = Sprite "background/frostField.tga", 32, 32, 2, 1.75
    effect = (player) =>
      field = FrostField player.position.x, player.position.y
      Driver\addObject field, EntityTypes.background
    super sprite, cd, effect
    @name = "Frozen Field"
    @description = "Place a freezing field"
    @effect_time = 7.5
