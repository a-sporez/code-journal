local shipSystems = {}
shipSystems.__index = shipSystems

-- placeholder systems
-- TODO: integrate all of the systems into the ship
shipSystems.availableSystems = {
    engine = {
        { name = "t1x10", thrustModifier = 10 },
        { name = "t2x20", thrustModifier = 20 },
        { name = "t3x30", thrustModifier = 30 },
        { name = "t4x40", thrustModifier = 40 }
    },
    shield = {
        { name = "s1x10", shieldModifier = 10 },
        { name = "s2x20", shieldModifier = 20 },
        { name = "s3x30", shieldModifier = 30 },
        { name = "s4x40", shieldModifier = 40 }
    },
    weapons = {
        { name = "Mass Driver", damageModifier = 10 }
    },
    sensors = {
        { name = "v1x10", sensorModifier = 10 },
        { name = "v2x10", sensorModifier = 20 },
    }
}

function shipSystems.new()
    local self = setmetatable( {}, shipSystems )

    -- define the ship system slots
    self.slots = {
        engine = nil,
        shield = nil,
        weapons = nil,
        sensors = nil
    }
    -- shipSytems base modifiers
    self.baseThrust = 10
    self.currentThrust = self.baseThrust
    self.shieldStrength = 0
    self.weaponsStrength = 0
    self.sensorsStrength = 0

    return self
end