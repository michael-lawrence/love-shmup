--- @module 'shmup.entities.music'
--- @class shmup.entities.Music
--- @field songs table A table of songs to play.
--- @field songSource love.Source The source of the currently playing song.
local Music = {}

local A = love.audio

--- Creates a new Music instance.
--- @return shmup.entities.Music The music instance.
function Music:new()
    local o = {
        songs = {
            stage1 = 'assets/music/stage1.ogg'
        },
        songSource = nil
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

---Plays the specified song.
--- @param song string The song to play.
function Music:play(song)
    self.songSource = A.newSource(song, 'stream')

    A.setVolume(0.35)
    A.play(self.songSource)
end

---Stops the currently playing song.
function Music:stop()
    self.songSource:stop()
end

return Music
