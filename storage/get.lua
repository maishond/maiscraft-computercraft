local args = {...}

-- Args to 1 string
args = table.concat(args, ' ')

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

function finish(found, itemToFind)
    local itemsPlural = itemToFind

    -- If found is greater than one and doesn't end in s, add s
    if found > 1 and string.sub(itemsPlural, -1) ~= 's' then
        -- Check if final is X. If so, add es
        if string.sub(itemsPlural, -1) == 'x' then
            itemsPlural = itemsPlural .. 'es'
        else
            itemsPlural = itemsPlural .. 's'
        end
    end

    print('Found ' .. found .. ' ' .. itemsPlural .. ' in network')
end

-- Network stuff
local modem = peripheral.find("modem")
modem.open(1)
local turtleName = modem.getNameLocal()

-- Print message
print('Received message: ' .. args)

-- ! Find all chests and barrels
local allPeripherals = peripheral.getNames()
local chests = {}
for i = 1, #allPeripherals do
    local peripheralName = allPeripherals[i]
    if peripheral.getType(peripheralName) == 'minecraft:chest' or peripheral.getType(peripheralName) ==
        'minecraft:barrel' then
        table.insert(chests, peripheral.wrap(peripheralName))
    end
end

print('Found ' .. #chests .. ' chests', chests)

-- ! Find items in chest
-- Create variable called "query" that removes all numbers
local query = string.gsub(args, '%d+', '')
local itemToFind = toItemName(query)

-- Create variable called "count" that removes all letters and trims the string
local count = string.gsub(args, '%a+', ''):gsub(" ", "")
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
else
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
            if foundCount >= count then
                finish(foundCount, itemToFind)
                return
            end
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

                end

            end

        end

        finish(foundCount, itemToFind)

        print('End')
    end

end
