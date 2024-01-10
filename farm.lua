-- Function to check if the block below is a full-grown potato seed
function isPotatoSeedBelow()
    -- Check if there is a block below
    if turtle.detectDown() then
        -- Get information about the block below
        local success, data = turtle.inspectDown()

        -- Check if the block is a full-grown potato seed
        if success and data.name == "minecraft:potatoes" and data.state.age == 7 then
            return true
        end
    end

    return false
end

-- Function to check if the block below is a full-grown wheat seed
function isWheatSeedBelow()
    -- Check if there is a block below
    if turtle.detectDown() then
        -- Get information about the block below
        local success, data = turtle.inspectDown()

        -- Check if the block is a full-grown potato seed
        if success and data.name == "minecraft:wheat" and data.state.age == 7 then
            return true
        end
    end

    return false
end

-- Function to select specific item in inventory
function selectItem(name)
    for i = 1, 16 do
        turtle.select(i)
        if turtle.getItemDetail() and turtle.getItemDetail().name == name then
            return true
        end
    end

    return false
end

-- Function to break the potato below, suck it up, and replant it
function harvestPotato()
    print('Harvesting potato at ' .. os.time())
    turtle.digDown()
    turtle.suckDown()
    selectItem('minecraft:potato')
    turtle.placeDown()
end

-- Function to break the wjheat below, suck it up, and replant it
function harvestWheat()
    print('Harvesting wheat at ' .. os.time())
    turtle.digDown()
    turtle.suckDown()
    selectItem('minecraft:wheat_seeds')
    turtle.placeDown()
end

function placePotatoIfAir()
    if turtle.getItemDetail() and turtle.getItemDetail().name == "minecraft:potato" then
        -- Check if block below is air
        if not turtle.detectDown() then
            -- Place potato
            turtle.placeDown()
        end
    end
end

function updateFuelOnMonitor()
    -- Get monitor
    local monitor = peripheral.find("monitor")

    -- Get fuel level
    local fuelLevel = turtle.getFuelLevel()
    local fuelLimit = turtle.getFuelLimit()
    local percentage = math.floor((fuelLevel / fuelLimit) * 100)

    -- Set color based on fuel level
    if percentage < 10 then
        monitor.setTextColour(colours.red)
    elseif percentage < 25 then
        monitor.setTextColour(colours.orange)
    elseif percentage < 50 then
        monitor.setTextColour(colours.yellow)
    elseif percentage < 75 then
        monitor.setTextColour(colours.lime)
    else
        monitor.setTextColour(colours.green)
    end

    -- Display fuel level on monitor
    monitor.clear()
    monitor.setCursorPos(1, 1)

    monitor.write("Fuel: " .. fuelLevel .. " / " .. fuelLimit)
end

-- Every 5 seconds, check if there is a full-grown potato seed below the turtle
while true do

    -- Interface with monitor to display current fuel status
    updateFuelOnMonitor()

    -- Init
    turtle.turnLeft()
    turtle.turnLeft()
    side = 'left'

    print('Running traversal')

    -- Traverse 9 x 9 area, then return to start
    for i = 1, 9 do
        for j = 1, 17 do

            -- Check fuel, alert users if low
            if turtle.getFuelLevel() <= 0 then
                peripheral.find("speaker").playSound("infinitybuttons:alarm")
            end

            -- Optionally, check if there is a potato and replant it if need be
            if isPotatoSeedBelow() then
                harvestPotato()
            end

            -- Same with seeds / wheat
            if isWheatSeedBelow() then
                harvestWheat()
            end

            -- Place down potato
            placePotatoIfAir()

            -- Walk forward
            turtle.forward()
        end

        -- Place down potato
        placePotatoIfAir()

        -- Turn to next row
        if side == 'left' then
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
            side = 'right'
        else
            if side == 'right' then
                turtle.turnRight()
                turtle.forward()
                turtle.turnRight()
                side = 'left'
            end
        end

        -- Place down potato
        placePotatoIfAir()
    end

    --- Walk back to start
    for i = 1, 17 do
        turtle.forward()
    end
    turtle.turnLeft()
    for i = 1, 8 do
        turtle.forward()
    end

    print('Got home, going up, then dropping second slot (keeping a stack)')

    -- Drop entire inventory in chest
    for i = 1, 16 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(1)

    print('Dropped second slot, resetting to start position and sleeping for 15 minutes')

    -- Return to start position
    turtle.turnRight()

    -- Interface with monitor to display current fuel status
    updateFuelOnMonitor()

    sleep(60 * 15)
end
