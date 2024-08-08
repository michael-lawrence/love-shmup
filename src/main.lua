local BG = require('shmup.entities.BG')
local Enemy = require('shmup.entities.Enemy')
local Music = require('shmup.entities.Music')
local Player = require('shmup.entities.Player')
local CRT = require('shmup.shaders.CRT')
local Shake = require('shmup.shaders.Shake')
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
end

function love.update(dt)
    BGImage:update(dt)
    Player1:update(dt)

    if Enemy1:getRect().y < 100 then
        Enemy1:moveDown()
    end

    local collision = Player1:destroyCollidingProjectiles(Enemy1:getRect())

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