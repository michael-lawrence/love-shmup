--- @module 'shmup'
--- @package 'shmup'
local shmup = {}

shmup.controllers = {}
shmup.controllers.InputController = require('shmup.controllers.input')
shmup.controllers.MovementController = require('shmup.controllers.movement')
shmup.controllers.ProjectileController = require('shmup.controllers.projectile')

shmup.drawing = {}
shmup.drawing.Point = require('shmup.drawing.point')
shmup.drawing.Rect = require('shmup.drawing.rect')

shmup.entities = {}
shmup.entities.BG = require('shmup.entities.bg')
shmup.entities.Projectile = require('shmup.entities.projectile')
shmup.entities.Enemy = require('shmup.entities.enemy')
shmup.entities.Music = require('shmup.entities.music')
shmup.entities.Player = require('shmup.entities.player')

shmup.particles = {}
shmup.particles.Thruster = require('shmup.particles.thruster')

shmup.shaders = {}
shmup.shaders.Blur = require('shmup.shaders.blur')
shmup.shaders.CRT = require('shmup.shaders.crt')
shmup.shaders.Shake = require('shmup.shaders.shake')

return shmup
