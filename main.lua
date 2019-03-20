 
--LÖVE calls 3 functions. First it calls love.load(). In here we create our variables.
--After that it calls love.update() and love.draw(), repeatedly in that order.
--So: love.load -> love.update -> love.draw -> love.update -> love.draw -> love.update, etc.


function love.load()
  PlayerDetails = {}
  CreatePlayer(10, 10, 50, 50, 100)
end

function love.draw()
  love.graphics.rectangle("fill", PlayerDetails[1].x, PlayerDetails[1].y, PlayerDetails[1].width, PlayerDetails[1].height)
  love.graphics.rectangle("fill", PlayerDetails[2].x, PlayerDetails[2].y, PlayerDetails[2].width, PlayerDetails[2].height)
end

function love.update(dt)
  love.keypressed(key)
end


function CreatePlayer(_x, _y, _width, _height, _speed)  
  body = {}
  body.x = _x
  body.y = _y
  body.width = _width
  body.height = _height
  body.speed = _speed
  --Put the new rectangle in the list
  table.insert(PlayerDetails, body)
  
  head = {}
  head.x = _x + _width
  head.y = _y + _height * 0.25
  head.width = _width - 25
  head.height = _height / 2
  head.speed = _speed
  --Put the new rectangle in the list
  table.insert(PlayerDetails, head)
end

function love.keypressed(key)
  dt = love.timer.getDelta()
  --Remember, 2 equal signs (==) for comparing!
  if love.keyboard.isDown("right") then
    PlayerDetails[1].x = PlayerDetails[1].x + 100 * dt
    PlayerDetails[2].x = PlayerDetails[2].x + 100 * dt
    
  elseif love.keyboard.isDown("left") then
    PlayerDetails[1].x = PlayerDetails[1].x - 100 * dt
    PlayerDetails[2].x = PlayerDetails[2].x - 100 * dt
    
  elseif love.keyboard.isDown("up") then
    PlayerDetails[1].y = PlayerDetails[1].y - 100 * dt
    PlayerDetails[2].y = PlayerDetails[2].y - 100 * dt
    
  elseif love.keyboard.isDown("down") then
    PlayerDetails[1].y = PlayerDetails[1].y + 100 * dt
    PlayerDetails[2].y = PlayerDetails[2].y + 100 * dt
    
  elseif love.keyboard.isDown("escape") then
    love.window.close()
  end  
end