require('entities.bg')
require('entities.player')
require('entities.music')
require('shaders.crt')

local G, K = love.graphics, love.keyboard

function love.load()
    Canvas = G.newCanvas()
    CRTShader = CRT.new()
    BGImage = BG.new()
    BGMusic = Music.new()
    BGMusic:play(BGMusic.songs.stage1)

    Player1 = Player.new('assets/spaceship.png');
    Player1:init()
end

function love.update(dt)
    BGImage:moveDown()

    if K.isDown('left') then
        Player1:moveLeft()
    elseif K.isDown('right') then
        Player1:moveRight()
    end

    if K.isDown('up') then
        Player1:moveUp()
    elseif K.isDown('down') then
        Player1:moveDown()
    end

    Player1:update(dt)
end

function love.draw()
    -- Render the game to the main canvas
    G.setCanvas(Canvas)
    BGImage:draw()
    Player1:draw()
    G.setCanvas()

    -- Apply the CRT shader to the entire canvas
    CRTShader:draw()
    G.draw(Canvas)
    CRTShader:reset()
end