-- Import utils file
local utilsFile = fs.open('utils.lua', 'r')
local utils = utilsFile.readAll()
utilsFile.close()
loadstring(utils)()

-- Get chests
local chests = getChests()
local turtleName = getTurtleName()

local inventoriesCleaned = 0

-- Function to deposit the turtle's entire inventory into the chests
function organiseTurtleIntoChests()
    for i = 1, #chests do
        setChestStatus(i, 'on')

        local chest = chests[i]
        local hasItem = false;
        print(toLeft('Dump'), 'Checking room in chest', i)
        for j = 1, 16 do
            turtle.select(j)
            local item = turtle.getItemDetail()
            if item ~= nil then
                chest.pullItems(turtleName, j)

                if turtle.getItemCount(j) > 0 then
                    hasItem = true;
                end
            end
        end

        setChestStatus(i, 'off')

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
    setChestStatus(#chests - i + 1, 'on')

    -- Get chest
    local chestFromEnd = chests[#chests - i + 1]

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

    setChestStatus(#chests - i + 1, 'off')

end
