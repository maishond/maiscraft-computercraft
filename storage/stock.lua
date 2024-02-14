-- Import utils
require("utils")

-- Get args
local args = {...}
args = table.concat(args, ' ')

-- Write startup
local file = fs.open('startup.lua', 'w')
local command = 'shell.run("update")\nshell.run("stock.lua ' .. args .. '")'
file.write(command)
file.close()
shell.run('rm startup-override.lua')
shell.run('cp startup.lua startup-override.lua')

-- Split args by comma
print(args)
args = split(args, ',')
local desiredItems = {}
for i = 1, #args do
    local item = toItemName(args[i])
    table.insert(desiredItems, item)
end

-- Get chests
local chests = getChests(true)
local turtleName = getTurtleName()

while true do
    local itemCounter = {}
    local inTurtle = {}

    -- Loop over all items in turtle to count them
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item ~= nil then
            local itemName = toItemName(item.name)
            local itemCount = tonumber(item.count)

            -- Add to counter
            if inTurtle[itemName] == nil then
                inTurtle[itemName] = 0
            end

            inTurtle[itemName] = inTurtle[itemName] + itemCount
        end
    end

    -- Loop over chests
    for i = 1, #chests do
        -- Get chest
        local chest = chests[i]

        local items = chest.list()

        -- Loop over items in chest
        for j = 1, #items do
            local item = items[j]

            if item ~= nil then
                local itemName = toItemName(item.name)

                -- If item is in desired items
                local isInDesiredItems = false
                for k = 1, #desiredItems do
                    if desiredItems[k] == itemName then
                        isInDesiredItems = true
                    end
                end

                if isInDesiredItems then
                    local itemCount = tonumber(item.count)

                    -- Add to counter
                    if itemCounter[itemName] == nil then
                        itemCounter[itemName] = 0
                    end

                    itemCounter[itemName] = itemCounter[itemName] + itemCount

                    -- If the item has been found over 512 times, move it to the turtle
                    if itemCounter[itemName] > 512 and (inTurtle[itemName] == nil or inTurtle[itemName] < 64) then
                        local toTake = 64 - (inTurtle[itemName] or 0)

                        if toTake > itemCount then
                            toTake = itemCount
                        end

                        chest.pushItems(turtleName, j, toTake)
                        inTurtle[itemName] = (inTurtle[itemName] or 0) + toTake
                        print('Added', toTake, itemName, 'to turtle')
                    end
                end
            end
        end
    end

    os.sleep(10)
end
