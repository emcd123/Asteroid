 
--LÖVE calls 3 functios. First it calls love.load(). In here we create our variables.
--After that it calls love.update() and love.draw(), repeatedly in that order.
--So: love.load -> love.update -> love.draw -> love.update -> love.draw -> love.update, etc.

 

function love.load()
  --CONSTANTS
  MAXASTEROIDS = 10
  
  --Data Models
  player = {
    x = love.graphics.getWidth()/2,
    y = love.graphics.getHeight()/2,
    width = 50,
    height = 50,
    speed = 100,
    xvel = 0,
    yvel = 0,
    angle_accelaration = 4,
    accelaration = 100,
    rotation = 0
  }
  bullet = {
    --Not used for corrdinate tracking
    --Only for special bullet properties
    radius = 10,
    speed = 200,
    rotation = 0
  }
  asteroid = {
    health = 1,
    damage = 1,
    radius = 10,
    speed = 20
  }
  
  --Data Stores
  bullets = {
  }
  asteroids = {
  }
end

function love.update(dt)
  love.keypressed(key)  
  love.keyreleased(key)
  if getTableSize(asteroids) < MAXASTEROIDS then
    SpawnAsteroid()
  end
  if getTableSize(bullets) > 0 then
    --print(getTableSize(bullets))
    for i=1,getTableSize(bullets) do
      bullets[i].x = bullets[i].x + bullet.speed*dt * math.cos(bullets[i].rotation)
      bullets[i].y = bullets[i].y + bullet.speed*dt * math.sin(bullets[i].rotation)
    end
  end
  if getTableSize(asteroids) > 0 then
    --print(getTableSize(bullets))
    for i=1,getTableSize(asteroids) do
      speed_x = love.math.random(20)
      speed_y = love.math.random(20)
      --asteroids[i].x = asteroids[i].x + speed_x*dt
      --asteroids[i].y = asteroids[i].y + speed_y*dt
    end
  end
  if getTableSize(bullets) > 0 and getTableSize(asteroids) > 0 then
    --print(getTableSize(bullets))
    for i=1,getTableSize(bullets) do
      for j=1,getTableSize(asteroids) do
        if CheckBulletIntersectAsteroid(bullets[i], asteroids[j]) == true then
          table.remove(asteroids[j])
          table.remove(bullets[i])
        end
      end
    end
  end  
end

function love.draw()
  --love.graphics.print(.x)
  love.graphics.push()
  love.graphics.translate(player.x, player.y)
  love.graphics.rotate(player.rotation)
  
  -- Translate moves your origin from (0,0) to (x,y)
  -- So any coords specified afterwards for must be for the new origin
  CreatePlayer(-25, -25, player.width, player.height)
  love.graphics.pop()  
  for i=1,getTableSize(bullets) do
    --love.graphics.print(bullets[i].x)
    love.graphics.push()
    love.graphics.circle("fill", bullets[i].x, bullets[i].y, bullets[i].radius)
    love.graphics.pop()
  end
  for i=1,getTableSize(asteroids) do
    --love.graphics.print(asteroids[i].x)
    love.graphics.push()
    love.graphics.circle("fill", asteroids[i].x, asteroids[i].y, asteroids[i].radius)
    love.graphics.pop()
  end
end


function CreatePlayer(x, y, width, height, speed)  
  local body = {}
  body.x = x
  body.y = y
  body.width = width
  body.height = height
  body.speed = speed
  
  local head = {}
  head.x = x + width
  head.y = y + height * 0.25
  head.width = width - 25
  head.height = height / 2
  head.speed = speed
  
  love.graphics.rectangle("fill", body.x, body.y, body.width, body.height)
  love.graphics.rectangle("fill", head.x, head.y, head.width, head.height)
end

function CreateBullet(x,y,radius, rotation)
  local bullet = {}
  bullet.x = x
  bullet.y = y
  bullet.radius = radius
  bullet.rotation = rotation
  table.insert(bullets, bullet)
end

function CreateAsteroid()
  local asteroid = {}
  asteroid.x = love.math.random(love.graphics.getWidth())
  asteroid.y = love.math.random(love.graphics.getHeight())
  asteroid.radius = 25
  table.insert(asteroids, asteroid)
end

function love.keyreleased(key)
   if key == "space" then
      ShootBullet()
   end
end

function love.keypressed(key)
  local dt = love.timer.getDelta()
  
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    Turn("right", player.angle_accelaration)
    
  elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    Turn("left", player.angle_accelaration)
    
  elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    player.xvel = player.xvel + player.accelaration*dt * math.cos(player.rotation)
    player.yvel = player.yvel + player.accelaration*dt * math.sin(player.rotation)
    
  elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    player.xvel = player.xvel - player.accelaration*dt * math.cos(player.rotation)
    player.yvel = player.yvel - player.accelaration*dt * math.sin(player.rotation)
  
  elseif love.keyboard.isDown("escape") then
    love.window.close()
  end 
  
  player.x = player.x + player.xvel*dt
  player.y = player.y + player.yvel*dt
  player.xvel = player.xvel * 0.99
  player.yvel = player.yvel * 0.99
end

function Turn(direction, ANGACCEL)
  local dt = love.timer.getDelta()
  if direction == "right" then 
    player.rotation = player.rotation + ANGACCEL*dt
  elseif direction == "left" then 
    player.rotation = player.rotation - ANGACCEL*dt
  end
end

function ShootBullet()  
  CreateBullet(player.x, player.y, bullet.radius, player.rotation)
end

function SpawnAsteroid()
  CreateAsteroid()
end

function CheckBulletIntersectAsteroid(bulletArg, asteroidArg)
  if bulletArg.x > asteroidArg.x - 100 and bulletArg.x < asteroidArg.x + 100
  and bulletArg.y > asteroidArg.y - 100 and bulletArg.y < asteroidArg.y + 100 then
    print("hit")
    return true  
  else
    return false
  end
end

function getTableSize(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end 