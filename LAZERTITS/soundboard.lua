SoundBoard = {}

function SoundBoard:init()
  sound = love.audio.newSource("voiceclips/loseyourself1.wav", "stream")
  othersound = love.audio.newSource("voiceclips/loseyourself1.wav", "stream")
end

function SoundBoard:loseyourself()
    love.audio.play(sound)
end


function SoundBoard:loseyourself2()
    love.audio.play(othersound)
end
