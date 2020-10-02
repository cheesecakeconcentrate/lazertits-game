SoundBoard = {}

local loseyourself = nil
local laser = nil

function SoundBoard:init()
  loseyourself = love.audio.newSource("voiceclips/loseyourself1.wav", "stream")
  laser = love.audio.newSource("sfx/35686__jobro__laser9.wav", "static")
  laser:setVolume(0.05)
end

function SoundBoard:loseyourself()
    love.audio.play(sound)
end

function SoundBoard:laser()
    love.audio.stop(laser)
    love.audio.play(laser)
end
