require('entities.bg')
require('entities.enemy')
require('entities.music')
require('entities.player')
require('shaders.crt')
require('shaders.shake')

local G, K = love.graphics, love.keyboard

function love.load()
    Canvas = G.newCanvas()
    ShakeCanvas = G.newCanvas()
    CRTShader = CRT.new()
    ShakeShader = Shake.new()
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

    local collision = Player1:destroyCollidingBullets(Enemy1:getRect())

    if collision then
        ShakeShader:trigger(10, 0.15)
    end

    Enemy1:update(dt)
    ShakeShader:update(dt)
end

function love.draw()
    -- Render the game to the main canvas
    G.setCanvas(Canvas)
    BGImage:draw()
    Player1:draw()
    Enemy1:draw()

    -- Apply the Shake shader to the main canvas
    G.setCanvas(ShakeCanvas)
    ShakeShader:draw()
    G.draw(Canvas)
    ShakeShader:reset()

    -- Apply the CRT shader to the entire canvas
    G.setCanvas()
    CRTShader:draw()
    G.draw(ShakeCanvas)
    CRTShader:reset()
end
