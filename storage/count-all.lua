-- Import utils file
require('utils')

local chests = getChests(true)

-- ! Find items in chest

local itemCount = {}

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

            -- Get item name
            local itemName = item.name

            -- Check if item is in list
            if itemCount[itemName] == nil then
                itemCount[itemName] = 0
            end

            -- Add to count
            itemCount[itemName] = itemCount[itemName] + item.count
        end
    end
end

-- Print results
local i = 0;
local m = ''
for key, value in pairs(itemCount) do
    print(toLeft(key), value)
    local message = key .. '/' .. value
    m = m .. message .. '\n'
    i = i + 1
    print(i .. '/' .. #pairs(itemCount))
    if i % 30 == 0 then
        local webhook =
            'https://discord.com/api/webhooks/1202728339471863838/ziJFqkZPym-r3S9D-r4FryNbJ3nUGMqEAbSKbSDH7jXWk_9hsfPWwpf_s-LDizHLzjkQ'
        http.post(webhook, 'content=' .. textutils.urlEncode(m))
        m = ''
        print('Sleeping')
        sleep(2)

    end
end
