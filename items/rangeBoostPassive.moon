export class RangeBoostPassive extends PassiveItem
  new: =>
    @rarity = @getRandomRarity!
    @amount = ({1.2, 1.25, 1.3, 1.35, 1.4})[@rarity]
    sprite = Sprite "item/rangeBoost.tga", 24, 24, 1, 56 / 24
    effect = (player) =>
      player.attack_range *= @amount
    super sprite, nil, effect
    @name = "Range Up"
    @description = "Raises player range by " .. ((@amount - 1) * 100) .. "%"

  unequip: (player) =>
    super player
    player.attack_range /= @amount
