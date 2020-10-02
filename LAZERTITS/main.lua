player_dx = 0
player_dy = 0

game_state = "SPLASH"

show_hitboxes = true

timer = 0

local lasers = {}
local enemies = {}
local sparks = {}
local current_level = 1

function love.load()
  require "animation"
  require "player"
  require "physics_util"
  Hitspark = require "hitspark"
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

  player = Player(100, 300)
  local evilqueen = EvilQueen(550, 300)
  table.insert(enemies, evilqueen)

  stage = Stage()

  splash_screen = love.graphics.newImage("stills/splash1_5.png")
  splash_screen2 = love.graphics.newImage("stills/splash2_transparent.png")

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

  elseif game_state == "LEVEL_INTRO" then
    stage.draw(stage)
    green_text("LEVEL 0: OUTER SPACE OUTRAGE", 180, 100)
    green_text("PRESS ENTER TO BEGIN", 240, 400)
    green_text("arrow keys: fly\n" ..
               "space bar: shoot\n" ..
               "z: hypno-spiral", 270, 450)
    player.draw(player)

  elseif game_state == "GAMEPLAY" then
    -- green_text("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

    stage.draw(stage)

    for k,enemy in pairs(enemies) do
      enemy.draw(enemy)
    end
    player.draw(player)

    for k,laser in pairs(lasers) do
      laser.draw(laser)
    end

    for k,spark in pairs(sparks) do
      spark.draw(spark)
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
  elseif game_state == "LEVEL_INTRO" then
    level_intro_keypressed(key)
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
    SoundBoard:laser() 
    local laser = Laser(player.x + 30, player.y - 25)
    table.insert(lasers, laser)
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
    game_state = "LEVEL_INTRO"
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    song:play()
  end
end

function level_intro_keypressed(key)
  if key == 'return' then
    player.x = 100
    player.y = 300
    game_state = "GAMEPLAY"
  end
end

function love.update(dt)
  timer = timer + dt * 10.0

  if game_state == "GAMEPLAY" then
    gameplay_update(dt)
  elseif game_state == "LEVEL_INTRO" then
    stage.update(stage, dt)
  elseif game_state == "THANKYOU" then
    HypnoSpiral:update(dt)
    stage.update(stage, dt)
  end
end

function gameplay_update(dt)
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
    enemy.move(enemy, player, dt)
  end

  for k,spark in pairs(sparks) do
    local spark_alive = spark.update(spark)
    if not spark_alive then
      table.remove(sparks, k)
    end
  end

  for k,laser in pairs(lasers) do
    if (laser.x > love.graphics.getWidth() or laser.x < 0) then
      table.remove(lasers, k)
    end

    for enemyk,enemy in pairs(enemies) do
      if collides(laser, enemy) then
        enemy.gethit(enemy)

        local spark = Hitspark(laser.x + laser.width, laser.y)
        table.insert(sparks, spark)
        table.remove(lasers, k)
      end
    end

    laser.x = laser.x + (1000 * dt)
  end

end
