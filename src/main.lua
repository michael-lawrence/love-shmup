local BG = require('shmup.entities.bg')
local Enemy = require('shmup.entities.enemy')
local Music = require('shmup.entities.music')
local Player = require('shmup.entities.player')
local Health = require('shmup.entities.health')
local CRT = require('shmup.shaders.crt')
local Shake = require('shmup.shaders.shake')
local Point = require('shmup.drawing.point')
local G = love.graphics

function love.load()
    Canvas = G.newCanvas()
    ShakeCanvas = G.newCanvas()
    CRTShader = CRT:new()
    ShakeShader = Shake:new()
    BGMusic = Music:new()
    BGMusic:play(BGMusic.songs.stage1)

    BGImage = BG:new({ imagePath = 'assets/bg.png' })

    Player1 = Player:new({ imagePath = 'assets/spaceship.png' });
    Player1:init()

    Enemy1 = Enemy:new({ imagePath = 'assets/boss-stage1.png' })
    Enemy1:init()

    PlayerHealth = Health:new({
        bgImagePath = 'assets/health-guage.png',
        barImagePath = 'assets/health-bar.png',
        bgPosition = Point:new({ x = 0, y = -70 }),
        barPosition = Point:new({ x = 95, y = 10 }),
    })
end

function love.update(dt)
    BGImage:update()
    Player1:update(dt)

    if Enemy1:getRect().y < 100 then
        Enemy1:moveDown()
    end

    local collision = Player1:destroyCollidingProjectiles(Enemy1:getRect())

    if collision then
        ShakeShader:trigger(10, 0.15)
        PlayerHealth:damage(1)
    end

    Enemy1:update(dt)
    ShakeShader:update(dt)
    PlayerHealth:update()
end

function love.draw()
    -- Render the game to the main canvas
    G.setCanvas(Canvas)
    BGImage:draw()
    Player1:draw()
    Enemy1:draw()
    PlayerHealth:draw()

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
