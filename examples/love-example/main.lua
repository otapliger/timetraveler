local traveler = require("m.timetraveler")

platform = {}
player = {}

function love.load()
  -- Terrain
	platform.width = love.graphics.getWidth()
	platform.height = love.graphics.getHeight()
	platform.x = 0
	platform.y = 450
  -- Player
	player.velocity = {x = 0, y = 0}
	player.image = love.graphics.newImage('assets/images/hero.png')
	player.x = love.graphics.getWidth() / 3
	player.y = platform.y
  player.width = 20
  player.height = 24
	player.speed = 290
	player.jumpPower = -500
	player.gravity = -2000
  player.flip = false
  -- Rewind
	traveler.init(
		{function() return player.x end, function(v) player.x = v end},
		{function() return player.y end, function(v) player.y = v end},
		{function() return player.flip end, function(v) player.flip = v end}
	)
end

function love.update(dt)
  -- REWIND
	if love.keyboard.isDown('lshift') then
		traveler.rewind(dt)
  else
		traveler.record(dt)
	  -- RIGHT
		if love.keyboard.isDown('right') then
			if player.x < (love.graphics.getWidth() - 5) then
	      player.flip = false
				player.x = player.x + (player.speed * dt)
			end
	  end
	  -- LEFT
		if love.keyboard.isDown('left') then
			if player.x > player.width - 5 then
	      player.flip = true
				player.x = player.x - (player.speed * dt)
			end
		end
	  -- JUMP
		if love.keyboard.isDown('z') then
			if player.velocity.y == 0 then
				player.velocity.y = player.jumpPower
			end
		end
	  -- GRAVITY
		if player.y <= platform.y then
			player.y = player.y + player.velocity.y * dt
			player.velocity.y = player.velocity.y - player.gravity * dt
		end
	  -- FAKE COLLISION
		if player.y > platform.y then
			player.velocity.y = 0
	    player.y = platform.y
		end
	end
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  -- Draw image and flip player accordingly
  if player.flip then
    love.graphics.draw(player.image, player.x - player.width / 2, player.y, 0, -1, 1, player.width, player.height)
  else
    love.graphics.draw(player.image, player.x, player.y, 0, 1, 1, player.width, player.height)
  end
  -- Draw Terrain
	love.graphics.setColor(65, 65, 65)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
end
