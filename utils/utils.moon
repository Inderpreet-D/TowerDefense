-- Seed random and dispose of some values
math.randomseed os.time!
for i = 1, 3 do math.random!

-- Get a random sign
export randomSign = () ->
  if math.random 0, 1 == 1
    return 1
  else
    return -1

-- Get a random point on a circle
-- radius: The radius of the circle
export getRandomUnitStart = (radius = love.graphics.getHeight! / 3) ->
  -- Create a Point
  point = Point 0, 1

  -- Find a random rotation
  rand_num = ((math.random 0, 361) / 360) * (2 * math.pi)

  -- Rotate the point
  point\rotate rand_num

  -- Expand Point
  point.x *= radius
  point.y *= radius

  -- Shift Point
  point.x += love.graphics.getWidth! / 2
  point.y += love.graphics.getHeight! / 2

  -- Return Point coordinates
  return point\getComponents!

-- Clamps a number between two values
-- x: The number to clamp
-- min: Minimum value for number
-- max: Maximum value for number
export clamp = (x, min, max) ->
  -- Return a number in the range [min, max]
  if x <= min
    return min
  elseif x >= max
    return max
  else
    return x

-- Shuffles a list in place
-- list: The list to shuffle
export shuffle = (list) ->
  copy = {}
  -- Copy the list
  for k, v in pairs list
    copy[k] = v

  -- Shuffle the list
  for k, v in pairs list
    i = math.random #copy
    list[k] = copy[i]
    table.remove copy, i

-- Get random element from list
-- list: The list to choose from
export pick = (list) ->
  num = math.random(1, #list)
  return list[num]

-- Maps a value in [low, high] to [newLow, newHigh]
-- value: The value to map
-- low: Original lowest possible value
-- high: Original highest possible value
-- newLow: New lowest value
-- newHigh: New highest value
export map = (value, low, high, newLow, newHigh) ->
  a = high - low
  b = newHigh - newLow
  if a == 0 or b == 0 or value == 0
    return 0
  else
    return (value * b) / a

export ljust = (str, length) ->
  str = tostring str
  if #str >= length
    return str
  else
    num = length - #str
    for i = 1, num
      str ..= " "
    return str

export rjust = (str, length) ->
  str = tostring str
  if #str >= length
    return str
  else
    num = length - #str
    for i = 1, num
      str = " " .. str
    return str
