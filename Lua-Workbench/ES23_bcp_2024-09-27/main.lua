local love = require('love')

local button = require('src/buttons')

local cursor = {
    radius = 10,
    x = 15,
    y = 15
}

local serviceModule = require('src/service_module')

local terminal = require('src/terminal')

local game = {                          -- use "game.state['state']" in the code to switch functionality between game states.
    state = {                           --  add any new game state here
        menu = true,                    -- state loaded on startup
        settings = false,               -- does nothing
        paused = false,                 -- does nothing
        inventory = false,              -- does nothing
        inSurveyor = false,             -- calls the serviceModule
        character = false,              -- does nothing
        running = false,
        ended = false,
    }
}

local buttons ={
    menu_state = {}
}

local function loadSurveyor()
    game.state[ 'menu' ] = false
    game.state[ 'running' ] = false
    game.state[ 'inSurveyor' ] = true
end

local function startNewGame() 
    game.state[ 'menu' ] = false
    game.state[ 'running' ] = true
    game.state[ 'inSurveyor' ] = false
end

function love.load()

    camera = require( 'lib/camera' ) -- call for camera plugin.
    camObj = camera() -- create camera object.

    anim8 = require 'lib/anim8' -- call for anim8 plugin
    love.graphics.setDefaultFilter( "nearest", "nearest" ) -- set graphics module to scale pixels without vsync.

    sti = require 'lib/sti' -- call the Simple Tiled Implementatiomn plugin to draw maps made with Tiled.
    gameMap = sti( 'data/maps/map0.lua' ) -- call in the map file.

    buttons.menu_state.play_game = button( "Play Game", startNewGame, nil, 120, 40 ) -- calls in startNewGame function.
    buttons.menu_state.settings = button( "Settings", nil, nil, 120, 40 )
    buttons.menu_state.exit_game = button( "Exit", love.event.quit, nil, 120, 40 ) -- calls for program to stop.

    player = {} -- player table.
    player.x = 200
    player.y = 200
    player.speed = 3
    player.spriteSheet = love.graphics.newImage( 'data/img/playerSheet.png' )
    player.grid = anim8.newGrid( 12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight() )

    player.animations = {} -- animations table.
    player.animations.down = anim8.newAnimation( player.grid( '1-4', 1 ), 0.25 )
    player.animations.left = anim8.newAnimation( player.grid( '1-4', 2 ), 0.25 )
    player.animations.right = anim8.newAnimation( player.grid( '1-4', 3 ), 0.25 )
    player.animations.up = anim8.newAnimation( player.grid( '1-4', 4 ), 0.25 )

    player.anim = player.animations.down

    serviceModule.load()
    consoleFont = love.graphics.newFont( 'data/img/setbackt.ttf', 22 )
    love.graphics.setFont( consoleFont )
    
    serviceMonitors = love.graphics.newImage( 'data/img/fuelCellScreens_WIP.png' )
    fuelCellScreens = love.graphics.newImage( 'data/img/fuelCellScreens.png' )

    function love.mousepressed(x, y, button, istouch, presses) -- registers any mouse button as long as the cursor is hovering a button.
        if not game.state[ 'running' ] then
            if button == 1 then
                if game.state[ 'menu' ] then -- registers mouse while in menu state
                    for index in pairs( buttons.menu_state ) do
                        buttons.menu_state[ index ]:checkPressed( x, y, cursor.radius )
                    end
                end
            end
            
        end
    
    end
    
end

-- Variables to manage key repeat
local keyHeld = nil
local keyTimer = 0
local keyInterval = 0.1 -- 100ms   
    
local repeatableKeys = {
    backspace = true,
    -- Add more keys here
}
    
    -- keyboard entry point inputs all text if terminal is active
function love.textinput(key)
    if terminal.active then terminal.input = terminal.input .. key end
end
    
-- keyboard input entry point
function love.keypressed(key)
    if game.state[ 'inSurveyor' ] then
        if terminal.active then
            if key == "return" then
                terminal.processCommand( terminal.input, serviceModule )
                terminal.input = ""
            elseif repeatableKeys[key] then
                -- Handle the repeatable key immediately
                if key == "backspace" then
                    terminal.input = terminal.input:sub(1, -2)
                end
                -- Set the key as held for repeating
                keyHeld = key
                keyTimer = 0
            elseif key == "escape" then
                terminal.active = false
            end
        elseif key == key then
            terminal.active = true
        end

    end
end
    
function love.keyreleased(key)
    if key == keyHeld then
        keyHeld = nil
        keyTimer = 0
    end
end

function love.update(dt)

    cursor.x, cursor.y = love.mouse.getPosition() -- register the location of mouse cursor
    love.mouse.setVisible( false ) -- set visibility of mouse cursor

    if love.keyboard.isDown( "escape" ) then -- changes game state to menu if escape is pressed.
        game.state[ 'menu' ] = true
        game.state[ 'running' ] = false
    end
    
    -- Update fuel cells
    serviceModule.update(dt)

    -- Update displays
    powerDisplay1 = math.floor( serviceModule.cell_A.stored )
    powerDisplay2 = math.floor( serviceModule.cell_B.stored )
    batteryDisplay = math.ceil( serviceModule.battery.stored )
    batteryPercentageDisplay = math.floor( ( serviceModule.battery.stored / serviceModule.battery.maxStored ) * 100 )

    if keyHeld and repeatableKeys[keyHeld] then
        keyTimer = keyTimer + dt
        if keyTimer >= keyInterval then
            if keyHeld == "backspace" then
                terminal.input = terminal.input:sub(1, -2) -- delete a character
            end
            -- Reset the timer to repeat the key action
            keyTimer = 0
        end
    end

    local isMoving = false -- starts player movement sequence.

    if love.keyboard.isDown( "escape" ) then -- changes game state to menu if escape is pressed.
        game.state[ 'menu' ] = true
        game.state[ 'running' ] = false
    end

    if love.keyboard.isDown( "tab" ) then -- loads surveyor interface
        game.state[ 'menu' ] = false
        game.state[ 'running' ] = false
        game.state[ 'inSurveyor' ] = true
    end

    if love.keyboard.isDown( "right" ) then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    if love.keyboard.isDown( "left" ) then
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown( "up" ) then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    if love.keyboard.isDown( "down" ) then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if isMoving == false then
        player.anim:gotoFrame( 2 ) -- not totally certain of what I did there, I think it loops to the stored local variable.
    end

    player.anim:update(dt) -- call in the animation to update once input handlers and through

    camObj:lookAt( player.x, player.y ) -- keep camera centered on player


end

-- use this to change the position of this screen
local sMod_X = 0
local sMod_Y = 0

local fuelCellScreens_X = sMod_X + 20
local fuelCellScreens_Y = sMod_Y + 32

local screenA_X = fuelCellScreens_X + 6
local screenA_Y = fuelCellScreens_Y + 3

local screenB_X = fuelCellScreens_X + 6
local screenB_Y = fuelCellScreens_Y + 70

local screenC_X = fuelCellScreens_X + 262
local screenC_Y = fuelCellScreens_Y + 5

local textColor = {
    lightMonokai = { 117/255, 113/255, 94/255 },
    darkMonokai = { 39/255, 40/255, 32/255 },
}

local terminalWidth = 374                      -- Width of the terminal window 
local terminalHeight = 246                     -- Height of the terminal window
local inputScrollOffset = screenC_X            -- Horizontal scroll for terminal input
local outputScrollOffset = screenC_X + 374     -- Horizontal scroll for terminal output
local historyScrollOffsets = {}                -- Horizontal scroll for each command in command history

function love.draw()

    love.graphics.printf( "FPS: " .. love.timer.getFPS(), love.graphics.newFont( 16 ), 10, love.graphics.getHeight() - 30, love.graphics.getWidth() ) --prints FPS count in top left corner
    
    if game.state[ "running" ] then
        camObj:attach() -- call for camera to follow player, below is the body of the main scene that will follow the camera.
            gameMap:drawLayer( gameMap.layers[ 'floor0' ] ) -- draw layers from STI/Tiled map, use this to add new layers.
            gameMap:drawLayer( gameMap.layers[ 'wall0' ] )
            player.anim:draw( player.spriteSheet, player.x, player.y, nil, 3, nil, 6, 9 ) -- center on player's grid (last 2 digits adjusts position on the player's grid)
        camObj:detach()
    elseif game.state[ "menu" ] then
        buttons.menu_state.play_game:draw( 700, 20, 20, 10 ) -- draw the button stored above load. Use this to draw new buttons.
        buttons.menu_state.settings:draw( 700, 70, 20, 10 )
        buttons.menu_state.exit_game:draw( 700, 120, 20, 10 )

    elseif game.state[ 'inSurveyor' ] then

        love.graphics.clear( 0, 0, 0 )

        love.graphics.draw( serviceMonitors, sMod_X, sMod_Y )
        love.graphics.draw( fuelCellScreens, fuelCellScreens_X, fuelCellScreens_Y )

        love.graphics.setColor( textColor.darkMonokai )
        -- draw display for both fuel cells
        love.graphics.print( "CELL.A.STATUS."..string.format( "%.2f", powerDisplay1 ).."%", screenA_X, screenA_Y )
        love.graphics.print( "CELL.B.STATUS."..string.format( "%.2f", powerDisplay2 ).."%", screenA_X, screenA_Y + 32 )
        -- draw display for battery
        love.graphics.print( "BATT."..batteryDisplay..".ah", screenB_X, screenB_Y )
        love.graphics.print( "."..batteryPercentageDisplay.."%", screenB_X + 190, screenB_Y )
        -- print temp value
        love.graphics.printf( "A.H2."..string.format( "%.2f", serviceModule.cell_A.fuelAmount )..".kg", screenB_X, screenB_Y + 22, 251 )
        love.graphics.printf( "A.TMP."..string.format( "%.2f", serviceModule.cell_A.temperature )..".K", screenB_X, screenB_Y + 44, 251 )
        love.graphics.printf( "B.H2."..string.format( "%.2f", serviceModule.cell_B.fuelAmount )..".kg", screenB_X, screenB_Y + 66, 251 )
        love.graphics.printf( "B.TEMP."..string.format( "%.2f", serviceModule.cell_B.temperature )..".K", screenB_X, screenB_Y + 88, 251 )

        local font = love.graphics.getFont()

        -- Set scissor for the terminal area (only draw within this rectangle)
        love.graphics.setScissor( screenC_X, screenC_Y, terminalWidth, terminalHeight )

        -- Terminal input: scroll if it exceeds terminalWidth
        local inputWidth = font:getWidth( terminal.input )
        if inputWidth > terminalWidth then
            inputScrollOffset = inputWidth - terminalWidth
        else
            inputScrollOffset = 0
        end

        if terminal.active then
            love.graphics.print( ">"..terminal.input, screenC_X - inputScrollOffset, screenC_Y )
        end

        -- Terminal output: scroll if it exceeds terminalWidth
        if terminal.output ~= "" then
            local outputWidth = font:getWidth( ">" .. terminal.output )
            if outputWidth > terminalWidth then
                outputScrollOffset = outputWidth - terminalWidth
            else
                outputScrollOffset = 0
            end
            love.graphics.print( ">" .. terminal.output, screenC_X - outputScrollOffset, screenC_Y + 22 )
        end

        -- Command history: scroll each command separately
        for i, command in ipairs( terminal.commandHistory ) do
            local historyWidth = font:getWidth( ">" .. command )
            if historyWidth > terminalWidth then
                historyScrollOffsets[i] = historyWidth - terminalWidth
            else
                historyScrollOffsets[i] = 0
            end
            love.graphics.print( ">" .. command, screenC_X - ( historyScrollOffsets[i] or 0 ), screenC_Y + 22 * ( i + 1 ) )
        end

        -- Reset scissor (remove clipping area after terminal is drawn)
        love.graphics.setScissor()

        -- reset color
        love.graphics.setColor( 1, 1, 1 )
        love.graphics.rectangle( 'line', player.x, player.y, 200, 150 )
        
    end
    if not game.state[ "running" ] then
        love.graphics.circle( "fill", cursor.x, cursor.y, cursor.radius ) -- Draw the mouse cursor while game state is not running, on one of the menus.
    end

end