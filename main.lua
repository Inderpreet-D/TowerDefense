require("logic.classLoader")
DEBUGGING = not true
love.graphics.setBackgroundColor(200, 200, 200)
love.graphics.setDefaultFilter("nearest", "nearest", 1)
MathHelper = MathHelper()
MusicHandler = MusicHandler()
UI = UI()
Renderer = Renderer()
State = State()
EntityTypes = EntityTypes()
Player = Player(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, Sprite("test.tga", 16, 16, 1, 4))
Driver = Driver()
Driver:addObject(Player, EntityTypes.player)
