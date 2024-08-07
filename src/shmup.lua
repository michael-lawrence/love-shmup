--- @module 'shmup'
--- @package 'shmup'
local shmup = {}

shmup.drawing = {}
shmup.drawing.Point = require('shmup.drawing.point')
shmup.drawing.Rect = require('shmup.drawing.rect')

shmup.entities = {}
shmup.entities.BG = require('shmup.entities.bg')
shmup.entities.Bullet = require('shmup.entities.bullet')
shmup.entities.Enemy = require('shmup.entities.enemy')
shmup.entities.Gun = require('shmup.entities.gun')
shmup.entities.Music = require('shmup.entities.music')
shmup.entities.Player = require('shmup.entities.player')

shmup.particles = {}
shmup.particles.Thruster = require('shmup.particles.thruster')

shmup.shaders = {}
shmup.shaders.Blur = require('shmup.shaders.blur')
shmup.shaders.CRT = require('shmup.shaders.crt')
shmup.shaders.Shake = require('shmup.shaders.shake')

return shmup