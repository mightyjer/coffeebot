TILE_SIZE = 16
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
MAX_TILES_X = WINDOW_WIDTH / TILE_SIZE
MAX_TILES_Y = WINDOW_WIDTH / TILE_SIZE

platform = {}
player = {}
score = 0
coffee = {}

require 'assets'
require 'constants'

function love.load()

  love.window.setTitle('He Nose')
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false
})

  math.randomseed(os.time())
 
  player.faces = {
  face = love.graphics.newImage('assets/faces/face1.png'),
  blink1 = love.graphics.newImage('assets/faces/face2.png'),
  blink2 = love.graphics.newImage('assets/faces/face3.png'),
  blink3 = love.graphics.newImage('assets/faces/face4.png'),
  faceleft = love.graphics.newImage('assets/faces/faceleft.png'),
  faceright = love.graphics.newImage('assets/faces/faceright.png'),
  facecoffee1 = love.graphics.newImage('assets/faces/facecoffee1.png'),
  facecoffee2 = love.graphics.newImage('assets/faces/facecoffee2.png')
  }


  player.face = player.faces['face']
  player.chattering = false
  player.x = WINDOW_WIDTH / 2
  player.y = WINDOW_HEIGHT / 2 - player.faces['face']:getHeight()
  player.facesize = 1.0
  player.speed = 200
  player.ground = player.y
  player.y_velocity = 0
  player.jump_height = -300
  player.gravity = -500

  coffee.x = 200
  coffee.y = 200

  platform.width = WINDOW_WIDTH
  platform.height = 30
  platform.x = 0
  platform.y = WINDOW_HEIGHT / 2

  score = 0
  timer = 0

  largefont = love.graphics.newFont(40)

end



function love.update(dt)


  if love.keyboard.isDown('right') then
		if player.x < (WINDOW_WIDTH - player.face:getWidth()) then
      player.x = player.x + (player.speed * dt)
      player.face = player.faces['faceright']
		end
	elseif love.keyboard.isDown('left') then
		if player.x > 0 then
      player.x = player.x - (player.speed * dt)
      player.face = player.faces['faceleft']
    end
  --else
    --player.face = player.faces['face']
	end

  if love.keyboard.isDown('space') then
		if player.y_velocity == 0 then
			player.y_velocity = player.jump_height
		end
	end
	if player.y_velocity ~= 0 then
		player.y = player.y + player.y_velocity * dt
		player.y_velocity = player.y_velocity - player.gravity * dt
	end
	if player.y > player.ground then
		player.y_velocity = 0
    	player.y = player.ground
  end
  
  if player.chattering then
    timer = timer + dt * 5
    if timer % 2 > 1 then
      player.face = player.faces['facecoffee1']
    else
      player.face = player.faces['facecoffee2']
    end
    if timer > 10 then
      player.chattering = false
      player.face = player.faces.face
      timer = 0
    end
  end

  if collides(player, coffee) then
    timer = 0
    score = score + 10
    generateCoffee()
    player.chattering = true
  end


end


function love.draw()
  love.graphics.clear(1,1,1,1)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(coffeesprite, coffee.x, coffee.y)
  love.graphics.draw(player.face, player.x, player.y)
  

  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
  love.graphics.setFont(largefont)
  love.graphics.print('score: ' .. score)
  --love.graphics.print(timer, 50, 50)
end



function love.keypressed(key, scancode, isrepeat)

  if key == 'escape' then
    love.event.quit()
  end
  
  if key == 't' then
    player.face = player.faces.blink1
  end

  if key == 'y' then
    player.face = player.faces.blink2
  end
  
end

function collides(obj1, obj2)
  return not (obj1.y > obj2.y + 50 or obj1.x > obj2.x + 50 or obj2.y > obj1.y + 80 or obj2.x > obj1.x + 80)
end

function generateCoffee()
  coffee.x = math.random(40, WINDOW_WIDTH - 100)
  coffee.y = math.random(200, WINDOW_HEIGHT / 2 - 100)
end

