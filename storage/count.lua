local args = {...}

-- Args to 1 string
args = table.concat(args, ' ')

-- Import utils file
require('utils')

local chests = getChests(true)

-- ! Find items in chest
-- Create variable called "query" that removes all numbers
local query = string.gsub(args, '%d+', '')
local itemToFind = toItemName(query)

print(toLeft('Searching'), itemToFind)

local foundCount = 0

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

                foundCount = foundCount + item.count

                print(toLeft(itemToFind), 'Found ' .. foundCount)

            end
        end
    end
end

local w, h = term.getSize()
print(toLeft(''), string.rep('-', (w - 1) - #toLeft('')))

-- print(foundCount .. ' ' .. itemToFind .. ' found (' .. math.floor((foundCount / 64) + 0.5, 2) .. ' stacks)')
print(toLeft('Found'), foundCount .. ' ' .. itemToFind)
print(toLeft(''), math.floor((foundCount / 64) + 0.5, 2) .. ' stacks')
print(toLeft(''), math.floor((foundCount / (64 * 27)) + 0.5, 2) .. ' double chests')

