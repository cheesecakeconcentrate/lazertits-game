SoundBoard = {}

local loseyourself = nil
local laser = nil
local ow = nil

function SoundBoard:init()
  loseyourself = love.audio.newSource("voiceclips/loseyourself1.wav", "stream")
  laser = love.audio.newSource("sfx/35686__jobro__laser9.wav", "static")
  ow = love.audio.newSource("voiceclips/ow1.wav", "stream")

  laser:setVolume(0.05)
end

function SoundBoard:loseyourself()
    love.audio.stop(loseyourself)
    love.audio.play(loseyourself)
end

function SoundBoard:laser()
    love.audio.stop(laser)
    love.audio.play(laser)
end

function SoundBoard:gethit()
    love.audio.stop(ow)
    love.audio.play(ow)
end
