-- src/playerShip.lua
local love = require('love')
local keyMapping = require( 'src/keyMapping' )

local playerShip = {}
playerShip.__index = playerShip

local anim8 = require( 'lib/anim8' )

-- world is passed as parameter to attach the collisions module.
function playerShip.new( world )
    local self = setmetatable( {}, playerShip )
    self.x = 100
    self.y = 100
    self.sprite = love.graphics.newImage( 'data/sprites/ship1.png' )
    self.spriteSheet = love.graphics.newImage( 'data/sprites/ship1-Sheet.png' )
    self.spriteWidth = self.spriteSheet:getWidth()
    self.spriteHeight = self.spriteSheet:getHeight()
    self.grid = anim8.newGrid( 256, 128, self.spriteWidth, self.spriteHeight )
    self.width = 256
    self.height = 128
-- set body variable for collisions
    self.body = love.physics.newBody( world, self.x, self.y, 'dynamic' )
-- define the shape of the collider
    self.shape = love.physics.newCircleShape( self.height / 2 )
-- set fixtures for the collisions with the previous variables.
    self.fixture = love.physics.newFixture( self.body, self.shape )
-- define the user data to detect collisions
    self.fixture:setUserData({ type = 'playerShip' })
    
    self.angle = 0
    self.velocityX = 0
    self.velocityY = 0
    self.thrust = 10
    self.hull = 1000
    self.power = 1000

    self.animation = {}

    self.animation.up = anim8.newAnimation( self.grid( '2-4', 1 ), 0.5 )
    self.animation.none = anim8.newAnimation( self.grid( 1, 2 ), 0.5 )
    self.animation.right = anim8.newAnimation( self.grid( 2, 2 ), 0.5 )
    self.animation.left = anim8.newAnimation( self.grid( 3, 2 ), 0.5 )
    self.anim = self.animation.none
    return self
end

function playerShip:movement(dt)
    local turnSpeed = 5
    local isMoving = false

-- Rotate right
    if love.keyboard.isDown(keyMapping.keyRight) then
        self.anim = self.animation.right
        self.angle = self.angle + turnSpeed * dt
        isMoving = true
    end

-- Rotate left
    if love.keyboard.isDown(keyMapping.keyLeft) then
        self.anim = self.animation.left
        self.angle = self.angle - turnSpeed * dt
        isMoving = true
    end

-- Move forward (up)
    if love.keyboard.isDown(keyMapping.keyUp) then
        self.anim = self.animation.up
        self.velocityX = self.velocityX + math.cos(self.angle - math.pi / 2) * self.thrust * dt
        self.velocityY = self.velocityY + math.sin(self.angle - math.pi / 2) * self.thrust * dt
        isMoving = true
    else
-- Reset to idle animation only if not moving
        if not isMoving then
            self.anim = self.animation.none
        end
        self.body:setPosition( self.x, self.y )
    end

-- Update the animation
    if self.anim then
        self.anim:update(dt)
    end
end


function playerShip:draw()

-- Save current transform state
    love.graphics.push()
    
-- Translate to position
    love.graphics.translate(self.x + self.width / 2, self.y + self.height / 2)
    
-- Rotate to the current angle
    love.graphics.rotate(self.angle)
    
-- Ensure the animation is valid before drawing
    if self.anim then
        self.anim:draw( self.spriteSheet, self.x, self.y, nil, nil, nil, self.x + self.width / 2, self.y + self.height / 2 )
    else
        print( "Error: Animation is nil" )
    end
-- restore state
    love.graphics.pop()

end

return playerShip