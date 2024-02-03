-- Import utils file
local utilsFile = fs.open('utils.lua', 'r')
local utils = utilsFile.readAll()
utilsFile.close()
loadstring(utils)()

local turtleName = getTurtleName()
local chests = getChests()

-- Get barrels
local allPeripherals = peripheral.getNames()
local barrels = {}
for i = 1, #allPeripherals do
    local peripheralName = allPeripherals[i]
    if peripheral.getType(peripheralName) == 'minecraft:barrel' then
        table.insert(barrels, peripheral.wrap(peripheralName))
    end
end

print(toLeft('Found'), #barrels .. ' barrels')

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

-- Go through all chests in a random order
local chestOrder = {}
for i = 1, #chests do
    table.insert(chestOrder, i)
end
chestOrder = shuffle(chestOrder)

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

        if item ~= nil then
            print(toLeft('B move'), toItemName(item.name), ' slot', i)

            barrel.pushItems(turtleName, i)

            -- Loop through chests
            for c = 1, #chests do
                setChestStatus(chestOrder[c], 'on')
                -- Get chest
                local chest = chests[chestOrder[c]]
                chest.pullItems(turtleName, 1)

                -- Check if item is gone from turtle
                local item = turtle.getItemDetail()
                setChestStatus(chestOrder[c], 'off')
                if item == nil then
                    break
                end
            end
        end
    end
end

-- Also deposit items from turtle
for i = 1, 16 do
    -- See if there is an item
    local item = turtle.getItemDetail(i)
    if item ~= nil then
        print(toLeft('T move'), toItemName(item.name), ' slot', i)

        for c = 1, #chests do
            setChestStatus(chestOrder[c], 'on')
            -- Get chest
            local chest = chests[chestOrder[c]]
            turtle.select(i)
            chest.pullItems(turtleName, i)

            -- Check if item is gone from turtle
            local item = turtle.getItemDetail()
            setChestStatus(chestOrder[c], 'off')
            if item == nil then
                break
            end
        end
    end

end
