---@module 'entities.music'
Music = {}

local A = love.audio

--- Creates a new Music instance.
---@return Music The music instance.
function Music.new()
    ---@class Music
    ---@field songs table
    local music = {
        songs = {
            stage1 = 'assets/music/stage1.ogg'
        }
    }

    -- @type love.Source
    local songSource

    ---Plays the specified song.
    ---@param song string The song to play.
    function music:play(song)
        songSource = A.newSource(song, 'stream')

        A.setVolume(0.35)
        A.play(songSource)
    end

    ---Stops the currently playing song.
    function music:stop()
        songSource:stop()
    end

    return music
end

return Music