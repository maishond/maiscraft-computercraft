-- ! Find all chests and barrels
local allPeripherals = peripheral.getNames()
local chests = {}
for i = 1, #allPeripherals do
    local peripheralName = allPeripherals[i]
    if peripheral.getType(peripheralName) == 'minecraft:chest' or
        (includeTrappedChests and peripheral.getType(peripheralName) == 'minecraft:trapped_chest') then
        local c = peripheral.wrap(peripheralName)

        -- Add name to c
        c.name = peripheralName
        local s = split(peripheralName, '_')
        c.id = s[#s]
        if peripheral.getType(peripheralName) == 'minecraft:trapped_chest' then
            c.id = 'T' .. c.id
        end

        table.insert(chests, c)
    end
end

print(toLeft('System'), 'Found ' .. #chests .. ' chests')