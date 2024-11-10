local serviceModule = {}

function serviceModule.load()

    serviceModule.cell_A = {                    -- table to handle fuel cell
        flux = 10,                              -- Power production in MW
        stored = 0,                             -- amount of power stored
        minStored = 0,                          -- battery empty
        maxStored = 100,                        -- maximum amount of power stored
        fuelAmount = 400,                       -- Total fuel in kilograms
        fuelRate = 0.1,                         -- Fuel consumption rate per second (in kg/s)
        temperature = 300,                      -- Operating temperature in Kelvin
        maxTemperature = 1000,                  -- Maximum allowable temperature in Kelvin
        temperatureRate = 5,                    -- Rate at which temperature increases per second
        running = false,                        -- state is false on startup
    }

    serviceModule.cell_B = {
        flux = 10,
        stored = 0,
        minStored = 0,
        maxStored = 100,
        fuelAmount = 400,
        fuelRate = 0.1,
        temperature = 300,
        maxTemperature = 1000,
        temperatureRate = 5,
        running = false,
    }

    serviceModule.battery = {
        flux = 10,
        stored = 0,
        maxStored = 5000,
        active = false
    }
end

function serviceModule.updateFuelCell(cell, dt)
    -- Only proceed if the cell is running
    if cell.running then
        -- if the cell is running and fuel is available
        if cell.fuelAmount > 0 then
            if cell.stored < cell.maxStored then
                -- Generate flux
                cell.stored = cell.stored + cell.flux * dt
            end

            -- Consume fuel
            cell.fuelAmount = cell.fuelAmount - cell.fuelRate * dt

            -- Increase temperature
            cell.temperature = cell.temperature + cell.temperatureRate * dt

            -- Check if temperature exceeds max and stop the cell if it does
            if cell.temperature > cell.maxTemperature then
                cell.running = false
                cell.overheated = true -- flag to indicate overheat condition
                print("Fuel cell overheating!")
            end
        else
            -- Stop the cell if fuel runs out
            cell.running = false
            cell.outOfFuel = true -- flag to indicate out of fuel
            print("Fuel cell out of fuel!")
        end
    end

    -- Fuel cell offline, no power generation, and it slowly cools down
    if not cell.running then
        -- No power generation if the cell is offline
        if cell.stored > 1 then
            cell.stored = cell.stored - cell.flux * dt -- This simulates energy draining
        end

        -- Cool down if the cell is overheated
        if cell.temperature > 300 then
            cell.temperature = cell.temperature - (cell.temperatureRate / 5) * dt
        end
    end
end

-- Update both fuel cells
function serviceModule.update(dt)

    -- Battery charging, loss of flux and fuel is intentional drawback.
    if serviceModule.cell_A.stored >= 100 and serviceModule.battery.stored <= serviceModule.battery.maxStored then
        serviceModule.battery.stored = serviceModule.battery.stored + serviceModule.cell_A.flux * dt
    end
    if serviceModule.cell_B.stored >= 100 then
        serviceModule.battery.stored = serviceModule.battery.stored + serviceModule.cell_B.flux * dt
    end

    serviceModule.updateFuelCell(serviceModule.cell_A, dt)
    serviceModule.updateFuelCell(serviceModule.cell_B, dt)
end

return serviceModule