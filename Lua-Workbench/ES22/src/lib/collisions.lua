local love = require( 'love' )

local collisions = {}

function collisions.beginContact( a, b, coll )
    local userDataA = a:getUserData()
    local userDataB = b:getUserData()

    if userDataA and userDataB then
        if userDataA.type == 'playerShip' and userDataB.type == 'asteroid' then
            print( "Player hits asteroid." )
        elseif userDataA.type == 'asteroid' and userDataB.type == 'playerShip' then
            print( "Asteroid hits player." )
        end
    end

end
return collisions