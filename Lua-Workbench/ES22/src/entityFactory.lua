-- src/entityFactory.lua
local love = require( 'love' )
entityFactory = {}

function entityFactory.newEntity( x, y )
    local entity = {
        x = x,
        y = y,
        positionUpdate = function ( self, dx, dy )
            self.x = self.x + dx
            self.y = self.y + dx
        end,

        draw = function ( self )
            love.graphics.print( "Entity at: " .. self.x .. ", " .. self.y, self.x, self.y )
        end
    }
    return entity
end

-- Inheritance helper function. Add any new methods to the parameters
function entityFactory.extend( base, extraMethods )
    local newEntity = {}
-- TODO: Change the default loop values.
    for k, v in pairs( base ) do
        newEntity[k] = v
    end
-- TODO: create a table for extra methods common to all new entities
    if extraMethods then
        for k, v in pairs( extraMethods ) do
            newEntity[k] = v
        end
    end
    return newEntity
end

-- Create asteroid entity.
function entityFactory.newAsteroid( world, x, y, speed )
-- Declare that baseEntity inherits from newEntity variables.
    local baseEntity = entityFactory.newEntity( x, y )
-- This table defines what an asteroid does, basically
    local asteroid = entityFactory.extend( baseEntity, {
-- speed is defined when calling the function
        speed = speed,
-- set body variables for collisions
        body = love.physics.newBody( world, x, y, 'dynamic' ),
-- set the shape of the asteroid
        shape = love.physics.newCircleShape( 20 ),
-- Declare the rotation axes.
        rotate = function( self, angle )
            print( "Asteroid rotating by:"..angle, 10, 10 )
        end,
-- Declare the function to draw the asteroid. NOTE: I had to change the circle x and y
        draw = function( self )
            love.graphics.circle( 'fill', self.body:getX(), self.body:getY(), 20 )
        end
    } )

    asteroid.fixture = love.physics.newFixture( asteroid.body, asteroid.shape )
-- set user data for the asteroid.
    asteroid.fixture:setUserData({ type = 'asteroid' })
    return asteroid
end

return entityFactory