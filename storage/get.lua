if turtle == nil then
    print('Not the appropriate terminal.')
    return
end

local args = {...}

-- Args to 1 string
args = table.concat(args, ' ')

-- Import utils file
require('utils')

local turtleName = getTurtleName()
local chests = getChests(true)

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

print(toLeft('Looking'), itemToFind .. ' x ' .. count)

-- Helpful functions
function finish(foundCount, itemToFind)
    local itemsPlural = itemToFind

    -- If found is greater than one and doesn't end in s, add s
    if foundCount > 1 and string.sub(itemsPlural, -1) ~= 's' then
        -- Check if final is X. If so, add es
        if string.sub(itemsPlural, -1) == 'x' then
            itemsPlural = itemsPlural .. 'es'
        else
            itemsPlural = itemsPlural .. 's'
        end
    end

    if foundCount < count then
        print('Only found ' .. foundCount .. ' ' .. itemsPlural .. ' in network')
    else
        print('Got ' .. foundCount .. ' ' .. itemsPlural .. ' from network')
    end

end

local foundCount = 0

if foundCount >= count then
    print('Stopping another go')
else
    -- Loop through chests
    for i = 1, #chests do
        -- Get chest
        local chest = chests[i]
        setChestStatus(chest.id, 'on')
        if chest == nil then
            setChestStatus(chest.id, 'off')
            break
        end

        -- Get list of items
        local items = chest.list()
        if items == nil then
            print('No items found')
            setChestStatus(chest.id, 'off')
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
                    foundCount = foundCount + takeCount

                    -- Find item in turtle
                    for i = 1, 16 do
                        local item = turtle.getItemDetail(i)
                        if item ~= nil then
                            local itemName = toItemName(item.name)
                            if itemName == itemToFind then
                                turtle.select(i)
                                turtle.dropDown()
                            end
                        end
                    end

                    print(toLeft(itemToFind), 'Found ' .. foundCount .. ' of ' .. count)

                end
            end
        end
        setChestStatus(chest.id, 'off')
    end

    finish(foundCount, itemToFind)
end
