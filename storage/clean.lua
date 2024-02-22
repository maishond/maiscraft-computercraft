-- Import utils file
require('utils')

-- Get chests
local chests = getChests()
local turtleName = getTurtleName()

local inventoriesCleaned = 0

local minChestForItem = {}
local inTurtleCache = {}

-- Function to deposit the turtle's entire inventory into the chests
function organiseTurtleIntoChests()
    for i = 1, #chests do

        local chest = chests[i]
        setChestStatus(chest.id, 'on')

        local hasItem = false;
        print(toLeft('Dump'), 'Checking room in chest', i)
        for j = 1, 16 do
            if (inTurtleCache[j] ~= nil) then
                if (minChestForItem[inTurtleCache[j]] or -1) >= i then
                    hasItem = true;
                    goto continue
                end
            end

            turtle.select(j)
            local item = turtle.getItemDetail()

            if item ~= nil then
                inTurtleCache[j] = item.name
                if (minChestForItem[item.name] or -1) >= i then
                    hasItem = true;
                else
                    chest.pullItems(turtleName, j)

                    -- Check if turtle still has any items in slot after attempting to deposit
                    if turtle.getItemCount(j) > 0 then
                        hasItem = true;
                        minChestForItem[item.name] = i
                        inTurtleCache[j] = item.name
                    else
                        inTurtleCache[j] = nil
                    end
                end
            end

            ::continue::
        end

        setChestStatus(chest.id, 'off')

        -- Check if turtle is empty
        if not hasItem then
            inventoriesCleaned = inventoriesCleaned + 1
            print(toLeft('Empty'), 'Cleaned', inventoriesCleaned, 'inventories')
            break
        end
    end
end

-- Loop through chests
for i = 1, #chests do

    -- Get chest
    local chestFromEnd = chests[#chests - i + 1]
    setChestStatus(chestFromEnd.id, 'on')

    -- Get list of items
    local items = chestFromEnd.list()
    print(toLeft('Progress'), i .. '/' .. #chests .. ' chests' .. ' (' .. #items .. ' items)')

    -- Post to webhook
    local webhook =
        'https://discord.com/api/webhooks/1202728339471863838/ziJFqkZPym-r3S9D-r4FryNbJ3nUGMqEAbSKbSDH7jXWk_9hsfPWwpf_s-LDizHLzjkQ'
    local message = 'Progress: ' .. i .. '/' .. #chests .. ' chests' .. ' (' .. #items .. ' items)' .. '\nCleaned ' ..
                        inventoriesCleaned .. ' inventories'
    http.post(webhook, 'content=' .. textutils.urlEncode(message))

    -- Check iems
    if items ~= nil then

        -- Loop through table of items
        for i = 1, chestFromEnd.size() do
            -- Check if turtle has any empty slots
            local hasEmptySlots = false
            for j = 1, 16 do
                if turtle.getItemCount(j) == 0 then
                    hasEmptySlots = true
                end
            end

            if not hasEmptySlots then
                organiseTurtleIntoChests()
                hasEmptySlots = true;
            end

            -- Get item
            local item = items[i]
            if item ~= nil then
                -- Take item from chest and into turtle
                if hasEmptySlots then
                    chestFromEnd.pushItems(turtleName, i)
                end
            end
        end

    end

    setChestStatus(chestFromEnd.id, 'off')

end

organiseTurtleIntoChests()
