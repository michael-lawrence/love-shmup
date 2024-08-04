require('entities.bg')
require('entities.player')
require('entities.music')
require('shaders.crt')

function love.load()
    Canvas = love.graphics.newCanvas()
    CRTShader = CRT.new()
    BGImage = BG.new()
    BGMusic = Music.new()
    BGMusic:play(BGMusic.songs.stage1)

    Player1 = Player.new('assets/spaceship.png');
    Player1:init()
end

function love.update(dt)
    BGImage:moveDown()

    if love.keyboard.isDown('left') then
        Player1:moveLeft()
    elseif love.keyboard.isDown('right') then
        Player1:moveRight()
    end

    if love.keyboard.isDown('up') then
        Player1:moveUp()
    elseif love.keyboard.isDown('down') then
        Player1:moveDown()
    end

    Player1:update(dt)
end

function love.draw()
    -- Render the game to the main canvas
    love.graphics.setCanvas(Canvas)
    BGImage:draw()
    Player1:draw()
    love.graphics.setCanvas()

    -- Apply the CRT shader to the entire canvas
    CRTShader:draw()
    love.graphics.draw(Canvas)
    CRTShader:reset()
end