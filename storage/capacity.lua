-- Import utils file
local utilsFile = fs.open('utils.lua', 'r')
local utils = utilsFile.readAll()
utilsFile.close()
loadstring(utils)()

local chests = getChests()

print(toLeft('Searching'), "Finding capacity")

local itemsFound = 0
local slotsTotal = 0
local slotsUsed = 0

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
        slotsTotal = slotsTotal + 1

        local item = items[i]
        if item ~= nil then

            -- Take name, split by : and get last item
            local name = toItemName(item.name)

            itemsFound = itemsFound + item.count
            slotsUsed = slotsUsed + 1

            print(toLeft('Items'), 'Found ' .. itemsFound)

        end
    end
end

local w, h = term.getSize()
print(toLeft(''), string.rep('-', (w - 1) - #toLeft('')))

print(toLeft('Found'), itemsFound .. ' items total')
print(toLeft(''), math.floor((itemsFound / 64) + 0.5, 2) .. ' stacks')
print(toLeft(''), math.floor((itemsFound / (64 * 9 * 6)) + 0.5, 2) .. ' double chests worth of itemsu')
print(toLeft(''), string.rep('-', (w - 1) - #toLeft('')))
print(toLeft(''), #chests .. ' double chests in system')
print(toLeft(''), string.rep('-', (w - 1) - #toLeft('')))
print(toLeft(''),
    'Slots used: ' .. slotsUsed .. '/' .. slotsTotal .. ' (' .. math.floor((slotsUsed / slotsTotal) * 100) .. '%)')

-- Display on monitor if there is one
local monitor = peripheral.find('monitor')
if monitor ~= nil then
    monitor.setBackgroundColour(colours.black)
    monitor.clear()

    -- Create progress bar
    local w, h = monitor.getSize()

    local percentage = math.floor((slotsUsed / slotsTotal) * 100)
    local barWidth = math.floor((percentage / 100) * w)

    monitor.setBackgroundColour(colours.green)
    monitor.setTextColour(colours.green)
    for y = 1, h do
        for x = 1, barWidth do
            monitor.setCursorPos(x, y)
            monitor.write(':')
        end
    end

    -- Draw slots on right
    local text = slotsUsed .. '/' .. slotsTotal .. ' slots'
    monitor.setBackgroundColour(colours.black)
    monitor.setTextColour(colours.white)
    monitor.setCursorPos(w - #text + 1, h)
    monitor.write(text)

end
