local love = require('love')
--[[
--]]
local collision = {}

function collision.stopObject(a, b)
    local bodyA = a:getBody()
    local bodyB = b:getBody()
    print("stopping", a:getUserData(), b:getUserData())
    print("/Body A type:"..bodyA:getType().."/Body B type:"..bodyB:getType())
    bodyA:setLinearVelocity(0, 0)
    bodyB:setLinearVelocity(0, 0)
end

function collision:beginContact(a, b, coll)
    local aData = a:getUserData() or "unknown"
    local bData = b:getUserData() or "unknown"
    print("begin contact <"..aData.."> and <"..bData..">")
    local x1, y1, x2, y2 = coll:getPositions()
    print("Collision detected between:", aData, "and", bData)
    print("Collision point(s):", x1, y1, x2 or "", y2 or "")
    if (string.match(aData, "Entity") and string.match(bData, "Entity")) then
        print("collision: "..aData.."/"..bData)
        self.stopObject(a, b)
    else
        print("error: "..aData.."/"..bData)
    end
end

function collision:endContact(a, b, coll)
    print("end contact <"..(
        a:getUserData() or "unknown").."> and <"..(b:getUserData() or "unknown")
    ..">")
end

function collision:init(gravityX, gravityY)
    self.worldMesh = love.physics.newWorld(gravityX or 0, gravityY or 0)
    self.worldMesh:setCallbacks(
        function(a, b, coll) self:beginContact(a, b, coll) end,
        function(a, b, coll) self:endContact(a, b, coll) end
    )
end

-- axes and vertices are passed to body and shape, that makes up fiture, that makes up userData
function collision:addEntity(shapeType, data)
    local body = love.physics.newBody(self.worldMesh, data.x, data.y, 'dynamic')
    local shape
    if shapeType == "polygon" then
        if not data.vertices or #data.vertices < 6 then
            error("Expected min 3 vertices, got "..(data.vertices and #data.vertices / 2 or 0))
        end
-- Print each vertex to check the actual values
        print("Creating polygon with vertices:")
        for i = 1, #data.vertices, 2 do
            print("Vertex "..(i / 2 + 0.5)..": ("..data.vertices[i]..", "..data.vertices[i + 1]..")")
        end
        shape = love.physics.newPolygonShape(data.vertices)
    elseif shapeType == "circle" then
        shape = love.physics.newCircleShape(data.radius)
    end
    local fixture = love.physics.newFixture(body, shape)
    print('setting data for fixture:', data.userData)
    fixture:setUserData(data.userData)
    print("bodyPosX<"..body:getX()..">Y<"..body:getY()..">")
    print("Body Angle:", body:getAngle())
    return body
end


function collision:update(dt)
    self.worldMesh:update(dt * 0.001)
end

function collision:draw()
    for _, body in pairs(self.worldMesh:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
            if shape:getType() == 'polygon' then
                love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
            elseif shape:getType() == 'circle' then
                local x, y = body:getWorldPoint(shape:getPoint())
                love.graphics.circle('line', x, y, shape:getRadius())
            end
        end
    end
end

return collision