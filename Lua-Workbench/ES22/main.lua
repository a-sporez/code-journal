local love = require('love')
local Collisions = require( 'src/lib/collisions' )
local anim8 = require( 'lib/anim8' )
local button = require( 'src/buttons' )
local playerShip = require( 'src/playerShip' )
local keyMapping = require( 'src/keyMapping' )
local entityFactory = require( 'src/entityFactory' )
-- The immutable values emporium:
local offset30 = 30

-- table to store cursor
local cursor = {
    radius = 5,
    x = 10,
    y = 10
}

-- table to store methods to draw buttons based on game state
local buttons = {
    menu_state = {},
    settings_state = {}
}

-- Table to store game states
local game = {
    state = {
        menu = true,
        utility = false,
        running = false,
        settings = false,
        ended = false
    }
}

-- Helper functions to switch between states
local function enableMenu()
    game.state[ 'menu' ] = true
    game.state[ 'running' ] = false
    game.state[ 'settings' ] = false
end
local function enableRunning()
    game.state[ 'menu' ] = false
    game.state[ 'running' ] = true
    game.state[ 'settings' ] = false
end
local function enableSettings()
    game.state[ 'menu' ] = false
    game.state[ 'running' ] = false
    game.state[ 'settings' ] = true
end

-- game state checks helper functions
local function isMenu()
    return game.state[ 'menu' ]
end

local function isRunning()
    return game.state[ 'running' ]
end

local function isSettings()
    return game.state[ 'settings' ]
end

function love.load()

    love.graphics.setDefaultFilter( "nearest", "nearest" )

    buttons.menu_state.startButton = button( "Start", enableRunning, nil, 120, 40 )
    buttons.menu_state.settingsButton = button( "Settings", enableSettings, nil, 120, 40 )
    buttons.menu_state.exitButton = button( "Exit", love.event.quit, nil, 120, 40 )

    buttons.settings_state.backToMenu = button( "Back", enableMenu, nil, 120, 40 )
-- create physics world with 0 gravity
    world = love.physics.newWorld( 0, 0, true )
-- set call back for collisions
    world:setCallbacks( Collisions.beginContact )
-- initiate playerShip module.
    playerShip = playerShip.new( world )
-- instantiate asteroids in a table
    asteroids = {
        entityFactory.newAsteroid( world, 1000, 400, 5 ),
        entityFactory.newAsteroid( world, 600, 500, 3 )
    }

end

-- registers any mouse button as long as the cursor is hovering a button.
function love.mousepressed( x, y, button, istouch, presses )
    if not isRunning() then
        if button == 1 then
            if isMenu() then
                for index in pairs( buttons.menu_state ) do
                    buttons.menu_state[index]:checkPressed( x, y, cursor.radius )
                end
            elseif isSettings() then 
                for index in pairs( buttons.settings_state ) do
                    buttons.settings_state[index]:checkPressed( x, y, cursor.radius )
                end
            end
        end 
    end
end

function love.keypressed( key )
    if isRunning() then
        if key == 'escape' then
            enableMenu()
        end
    end
end

function love.update(dt)
    if isRunning() then
        world:update(dt)
-- TO DO: refine movement logic to be a bit like EV Nova gravity-less navigation.
        playerShip:movement(dt)
        playerShip.x = playerShip.x + playerShip.velocityX
        playerShip.y = playerShip.y + playerShip.velocityY
        playerShip.anim:update(dt)
--[[
This is how to instantiate class, they really are just tables, let's not forget.
--]]
        for _, asteroid in pairs( asteroids ) do
            asteroid.x, asteroid.y = asteroid.body:getPosition()
        end

    end
end

function love.draw()
    
    love.graphics.setColor( 1, 1, 1 )
    if isMenu() then
        buttons.menu_state.startButton:draw( 700, 20, 5, 10 )
        buttons.menu_state.settingsButton:draw( 700, 70, 5, 10 )
        buttons.menu_state.exitButton:draw( 700, 120, 5, 10 )
    elseif isRunning() then
        playerShip:draw()
        
        for _, asteroid in pairs( asteroids ) do
            asteroid:draw()
        end

        love.graphics.print("Crew on duty:", 10, 10)

-- Debug playerShip power and hull
        love.graphics.print( "Ship Power: " .. tostring( playerShip.power ), 10, offset30 )
        love.graphics.print( "Ship Hull: " .. tostring( playerShip.hull ), 10, offset30 + 20 )
    elseif isSettings() then
        buttons.settings_state.backToMenu:draw( 700, 20, 5, 10 )
    end

end