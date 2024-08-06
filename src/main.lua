require('entities.bg')
require('entities.enemy')
require('entities.music')
require('entities.player')
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

    Enemy1 = Enemy.new('assets/boss-stage1.png')
    Enemy1:init()

    Keys = {
        left = Player1.moveLeft,
        a = Player1.moveLeft,
        right = Player1.moveRight,
        d = Player1.moveRight,
        up = Player1.moveUp,
        w = Player1.moveUp,
        down = Player1.moveDown,
        s = Player1.moveDown,
        space = Player1.shoot,
    }
end

function love.update(dt)
    BGImage:moveDown()

    for k, v in pairs(Keys) do
        if K.isDown(k) then v(Player1) end
    end

    Player1:update(dt)

    if Enemy1.position.y < 100 then
        Enemy1:moveDown()
    end

    Player1:destroyCollidingBullets(Enemy1:getRect())

    Enemy1:update(dt)
end

function love.draw()
    -- Render the game to the main canvas
    G.setCanvas(Canvas)
    BGImage:draw()
    Player1:draw()
    Enemy1:draw()
    G.setCanvas()

    -- Apply the CRT shader to the entire canvas
    CRTShader:draw()
    G.draw(Canvas)
    CRTShader:reset()
end
