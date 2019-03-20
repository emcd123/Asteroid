 
--LÖVE calls 3 functions. First it calls love.load(). In here we create our variables.
--After that it calls love.update() and love.draw(), repeatedly in that order.
--So: love.load -> love.update -> love.draw -> love.update -> love.draw -> love.update, etc.

player = {
  x = 10,
  y = 10,
  width = 50,
  height = 50,
  speed = 100,
  xvel = 0,
  yvel = 0,
  rotation = 0
}

local ANGACCEL      = 4
local ACCELERATION  = player.speed
  
function love.load()
end

function love.update(dt)
  love.keypressed(key)
end

function love.draw()
  love.graphics.translate(player.x, player.y)
  love.graphics.rotate(player.rotation)
  CreatePlayer(player.x/2, player.y/2, player.width, player.height)
end

function CreatePlayer(x, y, width, height, speed)  
  body = {}
  body.x = x
  body.y = y
  body.width = width
  body.height = height
  body.speed = speed
  
  head = {}
  head.x = x + width
  head.y = y + height * 0.25
  head.width = width - 25
  head.height = height / 2
  head.speed = speed
  
  love.graphics.rectangle("fill", body.x, body.y, body.width, body.height)
  love.graphics.rectangle("fill", head.x, head.y, head.width, head.height)
end

function Turn(direction, ANGACCEL)
  local dt = love.timer.getDelta()
  if direction == "right" then 
    player.rotation = player.rotation + ANGACCEL*dt
  elseif direction == "left" then 
    player.rotation = player.rotation - ANGACCEL*dt
  end
end

function love.keypressed(key)
  local dt = love.timer.getDelta()
  
  if love.keyboard.isDown("right") then
    Turn("right", ANGACCEL)
    
  elseif love.keyboard.isDown("left") then
    Turn("left", ANGACCEL)
  elseif love.keyboard.isDown("up") then
    player.xvel = player.xvel + ACCELERATION*dt * math.cos(player.rotation)
    player.yvel = player.yvel + ACCELERATION*dt * math.sin(player.rotation)
    
  elseif love.keyboard.isDown("down") then
    player.xvel = player.xvel - ACCELERATION*dt * math.cos(player.rotation)
    player.yvel = player.yvel - ACCELERATION*dt * math.sin(player.rotation)
    
  elseif love.keyboard.isDown("escape") then
    love.window.close()
  end 
  
  player.x = player.x + player.xvel*dt
  player.y = player.y + player.yvel*dt
  player.xvel = player.xvel * 0.99
  player.yvel = player.yvel * 0.99
end