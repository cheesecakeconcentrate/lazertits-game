player_dx = 0
player_dy = 0

game_state = "SPLASH"

show_hitboxes = true

timer = 0

local lasers = {}
local enemies = {}

function love.load()
  require "animation"
  require "player"
  require "physics_util"
  Enemy = require "enemy"
  Entity = require "entity"
  EvilQueen = require "evilqueen"
  Laser = require "laser"
  Object = require "classic"
  Stage = require "stage"

  Moan = require("Moan")
  Moan.font = love.graphics.newFont("Pixel_NES.otf", 20)
  Moan.typeSound = love.audio.newSource("sfx/typeSound.wav", "static")
  Moan.typeSound:setVolume(0.1)
  avatar = love.graphics.newImage("stills/player_dialogue2.png")
  avatar2 = love.graphics.newImage("stills/queen_dialogue.png")

  hypno_spiral = require("hypno_spiral")
  soundboard = require("soundboard")

  player = Player(200, 300)
  local evilqueen = EvilQueen(550, 300)
  table.insert(enemies, evilqueen)

  stage = Stage()

  splash_screen = love.graphics.newImage("stills/splash1_5.png")
  splash_screen2 = love.graphics.newImage("stills/splash2_transparent.png")

  enemy1_sprite = love.graphics.newImage("stills/enemy1.png") 
  king_sprite = love.graphics.newImage("stills/king.png") 

  mainFont = love.graphics.newFont("Pixel_NES.otf", 20)
  love.graphics.setFont(mainFont)

  love.window.setMode(800, 600)

  file = love.filesystem.newFile("text/intro.txt")
  file:open("r")
  intro_text = file:read()
  file:close()

  song = love.audio.newSource("music/Rolemusic_-_01_-_Spell.mp3", "stream")
  song:setVolume(0.05)
  song:setLooping(true)

  SoundBoard:init()
end

function green_text(text, x, y)
  love.graphics.setFont(mainFont)
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.print(text, x, y)
  love.graphics.setColor(1.0, 1.0, 1.0)
end


function love.draw()
  if game_state == "SPLASH" then
    love.graphics.draw(splash_screen, 0, 0)
    green_text("empress lazertits!", 250, 20)
    green_text("press enter to begin", 280, 100)
  elseif game_state == "THANKYOU" then
    stage.drawChamber(stage)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(splash_screen2, 0, 0)
    HypnoSpiral:draw_circular(321, 232)
    HypnoSpiral:draw_circular(514, 232)

    green_text("thank you for playing", 270, 15)
    green_text("empress lazertits\npre-alpha demo", 20, 500)
    green_text("horny alter-ego games\n2020", 475, 500)

  elseif game_state == "INTROTEXT" then
    green_text(intro_text, 10, 10)

  elseif game_state == "GAMEPLAY" then
    -- green_text("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

    stage.draw(stage)

    player.draw(player)
    for k,enemy in pairs(enemies) do
      enemy.draw(enemy)
    end

    for k,laser in pairs(lasers) do
      laser.draw(laser)
    end

    Moan.draw()
  end
end


function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if Moan.showingMessage then
    return
  end

  if game_state == "GAMEPLAY" then
    gameplay_keypressed(key)
  elseif game_state == "SPLASH" then
    splash_keypressed(key)
  elseif game_state == "INTROTEXT" then
    introtext_keypressed(key)
  end
end


function love.keyreleased(key)
  Moan.keyreleased(key)
end

function gameplay_keypressed(key)

  if key == '1' then
    stage.state = "STARS"
  elseif key == '2' then
    stage.state = "CHAMBER"
  elseif key == '3' then
    stage.state = "FOREST"
  end

  if key == "z" then
    if player.state == "HYPNO" then
      player.idle(player)
    else
      player.hypno(player)
      SoundBoard:loseyourself()
    end
  end
  if key == 'space' then
    player.shoot(player)
    local laser = Laser(player.x + 30, player.y - 25)
    table.insert(lasers, laser)
  end

  if key == 'x' then
    SoundBoard:loseyourself()
  end
  if key == 'v' then
    SoundBoard:loseyourself2()
  end

  if key == 'm' then
    Moan.speak("QUEEN TITNOTICA",
               {"You will submit to my hypnotic breasts."},
               {image=avatar})
  end

  if key == 'n' then
    Moan.speak("QUEEN E",
               {"No, *you* will submit to *my* hypnotic breasts.",
                "They're even more hypnotic."},
               {image=avatar2})
  end

  if key == "return" then
    game_state = "THANKYOU"
  end

end

function splash_keypressed(key)
  if key == 'return' then
    game_state = "INTROTEXT"
  end
end

function introtext_keypressed(key)
  if key == 'return' then
    game_state = "GAMEPLAY"
    song:play()
  end
end

function love.update(dt)
  HypnoSpiral:update(dt)

  timer = timer + dt * 10.0

  stage.update(stage, dt)
  Moan.update(dt)
  if Moan.showingMessage then
    return
  end

  -- this is a bit gross
  -- can we move this into the keypressed event?
  local moving = false

  if love.keyboard.isDown("left") then
    player_dx = -400
    moving = true
  end
  if love.keyboard.isDown("right") then
    player_dx = 400
    moving = true
  end
  if love.keyboard.isDown("up") then
    player_dy = -400
    moving = true
  end
  if love.keyboard.isDown("down") then
    player_dy = 400
    moving = true
  end

  if not moving then
    if player_dx > 0 then
      player_dx = player_dx - 20
    elseif player_dx < 0 then
      player_dx = player_dx + 20
    end
    if player_dy > 0 then
      player_dy = player_dy - 20
    elseif player_dy < 0 then
      player_dy = player_dy + 20
    end
  end
  if moving then
    player.move(player)
  else
    if player.state == "MOVE" then
      player.idle(player)
    end
  end

  player.x = player.x + player_dx * dt
  player.y = player.y + player_dy * dt

  for k,enemy in pairs(enemies) do
    -- XXX: have each kind of enemy decide how it moves
    -- enemy.x = enemy.x + player_dx * dt
    -- enemy.y = enemy.y + player_dy * dt
    enemy.move(enemy, player, dt)
  end

  for k,laser in pairs(lasers) do
    if (laser.x > love.graphics.getWidth() or laser.x < 0) then
      table.remove(lasers, k)
    end

    for enemyk,enemy in pairs(enemies) do
      if collides(laser, enemy) then
        -- enemy.hit()
        print("collision")
      end
    end

    laser.x = laser.x + (400 * dt)
  end

end
