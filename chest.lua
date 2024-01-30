-- Open connecton
rednet.open("left")

function split(pString, pPattern)
    local Table = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table, cap)
        end
        last_end = e + 1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end

function toItemName(str)
    -- Take name, split by : and get last item
    local nameSplit = split(str, ':')
    local itemName = nameSplit[#nameSplit]

    -- Replace underscore with space and make it lowercase
    itemName = string.gsub(itemName, '_', ' ')
    itemName = string.lower(itemName)

    -- Remove spaces from start and end
    itemName = string.gsub(itemName, '^%s*(.-)%s*$', '%1')

    return itemName
end

-- Function to tell core that it has finished
function finish(num, item)
    -- Network stuff
    local modem = peripheral.find("modem")
    rednet.open("left")
    local turtleName = modem.getNameLocal()

    -- Send message
    rednet.broadcast('Found ' .. num .. ' ' .. item .. 's in network')
end

-- wait for message
while true do
    -- Refuel
    turtle.select(1)
    turtle.refuel()

    -- Network stuff
    local modem = peripheral.find("modem")
    modem.open(1)
    local turtleName = modem.getNameLocal()

    -- Wait for message
    local senderId, message, protocol = rednet.receive()

    -- Check if message isn't from itself
    if senderId == os.getComputerID() then
        print('Message from itself')
        break
    end

    -- Print message
    print('Received message: ' .. message)

    local allPeripherals = peripheral.getNames()
    local chests = {}
    local barrels = {}
    for i = 1, #allPeripherals do
        local peripheralName = allPeripherals[i]
        if peripheral.getType(peripheralName) == 'minecraft:chest' then
            table.insert(chests, peripheral.wrap(peripheralName))
        end
        if peripheral.getType(peripheralName) == 'minecraft:barrel' then
            table.insert(barrels, peripheral.wrap(peripheralName))
        end
    end
    print('Found ' .. #chests .. ' chests', chests)

    -- ! Deposit all barrels in the network into chests
    if message == 'deposit' then
        -- Go over each barrel
        for i = 1, #barrels do
            -- Get barrel
            local barrel = barrels[i]

            -- Get list of items
            local items = barrel.list()
            if items == nil then
                print('No items found')
            end

            -- Loop through table of items
            for i = 1, 27 do
                -- Get item
                local item = items[i]

                print('Running barrel slot', i, 'of', 27)

                if item ~= nil then
                    print('Barrel item: ', item.name, i)

                    barrel.pushItems(turtleName, i)

                    -- Find chest to deposit item in
                    for c = 1, #chests do
                        -- Get chest
                        local chest = chests[c]
                        if chest == nil then
                            break
                        end

                        chest.pullItems(turtleName, 1)
                    end

                end

            end

        end

        rednet.broadcast('Deposited all barrels in network')

    else

        -- ! Find items in chest

        -- Create variable called "query" that removes all numbers
        local query = string.gsub(message, '%d+', '')
        local itemToFind = toItemName(query)

        -- Create variable called "count" that removes all letters and trims the string
        local count = string.gsub(message, '%a+', ''):gsub(" ", "")
        if count == '' then
            count = 64
        end
        count = tonumber(count)

        -- Check it doesn't exceed the turtle's inventory
        if count > 16 * 64 then
            count = 16 * 64
            print('Too many. Setting to 16 stacks')
        end

        -- Prints
        print('Query: ' .. query)
        print('Item to find: ' .. itemToFind)
        print('Count: ' .. count)

        local foundCount = 0

        if foundCount >= count then
            print('Stopping another go')
            break
        end

        -- Loop through chests
        for i = 1, #chests do
            -- Get chest
            local chest = chests[i]
            if chest == nil then
                break
            end

            -- Get list of items
            local items = chest.list()
            if items == nil then
                print('No items found')
                break
            end

            -- Loop through table of items
            for i = 1, 54 do
                -- Get item
                local item = items[i]
                if item ~= nil then

                    -- Take name, split by : and get last item
                    local name = toItemName(item.name)

                    -- Check if item is the one we are looking for
                    if name == itemToFind then
                        -- Find number to take out of chest
                        local takeCount = count - foundCount
                        if takeCount > item.count then
                            takeCount = item.count
                        end

                        -- Take item
                        turtle.select(1)
                        chest.pushItems(turtleName, i, takeCount)
                        turtle.dropDown()
                        foundCount = foundCount + takeCount
                        print('Taken ', foundCount)

                        if foundCount >= count then
                            print('Finished early')
                            finish(foundCount, itemToFind)
                            break
                        end

                    end

                end

            end

        end

        finish(foundCount, itemToFind)

        print('End')
    end

end
