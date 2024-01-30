-- Network stuff
local modem = peripheral.find("modem")
modem.open(1)
local turtleName = modem.getNameLocal()

local allPeripherals = peripheral.getNames()
local barrels = {}
local chests = {}
for i = 1, #allPeripherals do
    local peripheralName = allPeripherals[i]
    if peripheral.getType(peripheralName) == 'minecraft:chest' then
        table.insert(chests, peripheral.wrap(peripheralName))
    end
    if peripheral.getType(peripheralName) == 'minecraft:barrel' then
        table.insert(barrels, peripheral.wrap(peripheralName))
    end
end

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

-- ! Deposit all barrels in the network into chests

-- Go over each barrel
for i = 1, #barrels do
    -- Get barrel
    local barrel = barrels[i]

    -- Get list of items
    local items = barrel.list()
    if items == nil then
        print('No items found')
    end

    -- Get slot count of barrel
    local slotCount = barrel.size()

    -- Loop through table of items
    for i = 1, slotCount do
        -- Get item
        local item = items[i]

        -- print('Running barrel slot', i, 'of', slotCount, 'in barrel', barrel.name, 'of', #barrels, 'barrels'

        if item ~= nil then
            print('Barrel item: ', item.name, i)

            barrel.pushItems(turtleName, i)

            -- Go through all chests in a random order
            local chestOrder = {}
            for i = 1, #chests do
                table.insert(chestOrder, i)
            end
            chestOrder = shuffle(chestOrder)

            -- Loop through chests
            print(#chests, 'chests', chestOrder)
            for c = 1, #chests do
                -- Get chest
                local chest = chests[chestOrder[c]]
                if chest == nil then
                    break
                end

                print('Slot' .. i .. ' chest' .. c .. ' of ' .. #chests)

                chest.pullItems(turtleName, 1)

                -- Check if item is gone from turtle
                local item = turtle.getItemDetail()
                if item == nil then
                    break
                end
            end
        end
    end
end
