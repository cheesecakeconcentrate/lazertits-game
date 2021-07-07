player_dx = 0
player_dy = 0

game_state = "SPLASH"

show_hitboxes = true

timer = 0

local lasers = {}
local spirals = {}
local enemies = {}
local sparks = {}
local current_level = 1
local level_position = 1
local player = nil

function love.load()
  require "animation"
  require "player"
  require "physics_util"
  require "scaling"
  Hitspark = require "hitspark"
  Enemy = require "enemy"
  Entity = require "entity"
  EvilQueen = require "evilqueen"
  Claws = require "claws"
  SmallGun = require "smallgun"
  BigGun = require "biggun"
  Laser = require "laser"
  SpiralHitbox = require "spiral_hitbox"
  Object = require "classic"
  Stage = require "stage"
  Moan = require("Moan")
  LevelSequences = require("level_sequences")

  Moan.font = love.graphics.newFont("Pixel_NES.otf", 20)
  Moan.typeSound = love.audio.newSource("sfx/typeSound.wav", "static")
  Moan.typeSound:setVolume(0.1)
  avatar = love.graphics.newImage("stills/player_dialogue2.png")
  avatar2 = love.graphics.newImage("stills/queen_dialogue.png")

  hypno_spiral = require("hypno_spiral")
  soundboard = require("soundboard")

  player = Player(100, 300)
  stage = Stage()

  splash_screen = love.graphics.newImage("stills/splash1_5.png")
  splash_screen2 = love.graphics.newImage("stills/splash2_transparent.png")

  mainFont = love.graphics.newFont("Pixel_NES.otf", 40)
  love.graphics.setFont(mainFont)

  Scaling:set_window_size()

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
  Scaling:scale_graphics()
  
  if game_state == "SPLASH" then
    love.graphics.draw(splash_screen, 0, 0, 0, 2.0, 2.0)
    green_text("empress lazertits!", 560, 40)
    green_text("press enter to begin", 560, 200)
  elseif game_state == "THANKYOU" then
    stage.drawChamber(stage)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(splash_screen2, 0, 0, 0, 2.0, 2.0)
    HypnoSpiral:draw_circular(321 * 2, 232 * 2)
    HypnoSpiral:draw_circular(514 * 2, 232 * 2)

    green_text("thank you for playing", 540, 30)
    green_text("empress lazertits\nearly demo", 40, 1000)
    green_text("horny alter-ego games\n2021", 950, 1000)

  elseif game_state == "INTROTEXT" then
    green_text(intro_text, 10, 10)

  elseif game_state == "LEVEL_INTRO" then
    stage.draw(stage)
    green_text("LEVEL 0: OUTER SPACE OUTRAGE", 360, 200)
    green_text("PRESS ENTER TO BEGIN", 480, 800)
    green_text("arrow keys: fly\n" ..
               "space bar: shoot\n" ..
               "z: hypno-spiral", 540, 900)
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

    -- remove all the spiral hitboxes if we're not in HYPNO state.
    if player.state ~= "HYPNO" then
      for k,v in pairs(spirals) do
        spirals[k]=nil
      end
    end
    for k,spiral in pairs(spirals) do
      spiral.draw(spiral)
    end

    for k,spark in pairs(sparks) do
      spark.draw(spark)
    end

    draw_status_bar()

    Moan.draw()
  elseif game_state == "CUTSCENE" then
    player.pchypno_sheet.draw_big(player.pchypno_sheet, timer,
                                  200, 300)
  end
end


function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "-" then
    Scaling:decrease_size()
  elseif (key == "+" or
          key == "kp+"
          or (key == "=" and (love.keyboard.isDown("lshift") or
                              love.keyboard.isDown("rshift")))) then
    Scaling:increase_size()
  elseif key == "=" then
    Scaling:reset_size()
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
      local spiral = SpiralHitbox(player.x + 110, player.y - 30)
      table.insert(spirals, spiral)
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
  if key == "4" then
    game_state = "CUTSCENE"
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
    player.x = Scaling:get_width() / 2
    player.y = Scaling:get_height() / 2
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

function add_enemy(kind, x, y)
  if kind == "evilqueen" then
    local evilqueen = EvilQueen(x, y)
    table.insert(enemies, evilqueen)
  elseif kind == "claws" then
    local claws = Claws(x, y)
    table.insert(enemies, claws)
  elseif kind == "smallgun" then
    local smallgun = SmallGun(x, y)
    table.insert(enemies, smallgun)
  elseif kind == "biggun" then
    local biggun = BigGun(x, y)
    table.insert(enemies, biggun)
  end
end

function maybe_add_enemies()
  if table.getn(enemies) == 0 then
    for k, tuple in pairs(LevelSequences[current_level][level_position]) do
      local kind = tuple[1]
      local x = tuple[2]
      local y = tuple[3]

      if x == 0 then
        x = Scaling:get_width() + math.random(0, 20)
      end
      add_enemy(kind, x, y)
    end
  end
end

function draw_status_bar()
    love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
    love.graphics.rectangle("fill", 0, 1050, 500, 160)
    green_text("health", 10, 1070)
    love.graphics.setColor(1, 0, 0)
    for i=1,player.health do
      love.graphics.circle("fill", 180 + (30 * i), 1095, 10, 8)
    end
    green_text("will", 10, 1130)
    love.graphics.setColor(0, 0, 1)
    for i=1,player.will do
      love.graphics.circle("fill", 180 + (30 * i), 1155, 10, 8)
    end
end

function gameplay_update(dt)
  stage.update(stage, dt)
  Moan.update(dt)
  if Moan.showingMessage then
    return
  end

  maybe_add_enemies()

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
  -- spiral hitboxes move with you if you're skidding
  for k,spiral in pairs(spirals) do
    spiral.x = player.x + 110
    spiral.y = player.y - 30
  end

  for k,enemy in pairs(enemies) do
    -- check for death
    if enemy.state == "DYING" and enemy.hitstun == 0 then
      table.remove(enemies, k)

      if table.getn(enemies) == 0 then
        level_position = level_position + 1
        if level_position > table.getn(LevelSequences[current_level]) then
          game_state = "THANKYOU"
        end
      end
    end

    enemy.move(enemy, player, enemies, dt)
  end

  for k,spark in pairs(sparks) do
    local spark_alive = spark.update(spark)
    if not spark_alive then
      table.remove(sparks, k)
    end
  end

  for k,laser in pairs(lasers) do
    if (laser.x > Scaling:get_width() or laser.x < 0) then
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

  for k,spiral in pairs(spirals) do
    for enemyk,enemy in pairs(enemies) do
      if collides(spiral, enemy) then
        enemy.getspiraled(enemy)
      end
    end
  end

  for enemyk,enemy in pairs(enemies) do
    -- not all enemies should have a hitbox, but if they do...
    if collides(player, enemy) then
      SoundBoard:gethit()
      -- XXX: need a notion of hitstun so you don't just lose all your health at
      -- once
      player.health = player.health - 1
    end
  end

end
