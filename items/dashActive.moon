export class DashActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "item/dashActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      x, y = player.speed\getComponents!
      speed = Vector x, y, true
      player.position\add speed\multiply (Scale.diag * 350)
      radius = player\getHitBox!.radius
      player.position.x = clamp player.position.x, Screen_Size.border[1] + radius, Screen_Size.border[3] - radius
      player.position.y = clamp player.position.y, Screen_Size.border[2] + radius, (Screen_Size.border[4] + Screen_Size.border[2]) - radius
    super x, y, sprite, 5, effect
    @name = "Dash"
    @description = "Dash in the direction you are moving"
