-- Import utils file
local utilsFile = fs.open('utils.lua', 'r')
local utils = utilsFile.readAll()
utilsFile.close()
loadstring(utils)()

peripheral.find("modem", rednet.open)

-- Get chests
local chests = getChests(true)

local onOffStatuses = {}

function setup()
    for i = 1, #chests do
        onOffStatuses[i] = 0
    end
end

function calcPos(num, multiplier)
    local m = multiplier or 4
    return (num - 1) * m + 2
end

local hasItemsCache = {}

function renderScreen()
    local monitor = peripheral.find('monitor');
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    monitor.setTextScale(0.5)
    monitor.setCursorPos(1, 1)

    local w, h = monitor.getSize()

    local col = 1;
    local row = 1;

    for i = 1, #chests do

        local value = onOffStatuses[i]

        if value > 0 then
            monitor.setBackgroundColor(colors.green)
            monitor.setTextColor(colors.green)
        else
            -- See if chest has any items or not, first check cache
            if hasItemsCache[i] == nil then
                local items = chests[i].list()
                hasItemsCache[i] = #items > 0
            end

            if hasItemsCache[i] then
                monitor.setBackgroundColor(colors.yellow)
                monitor.setTextColor(colors.yellow)
            else
                monitor.setBackgroundColor(colors.red)
                monitor.setTextColor(colors.red)
            end
        end

        monitor.setCursorPos(calcPos(col), calcPos(row, 3))
        monitor.write('OOO')
        monitor.setCursorPos(calcPos(col), calcPos(row, 3) + 1)
        monitor.write('OOO')

        -- Index to string
        local s = tostring(i)

        -- Set colors to text
        if value == 0 and hasItemsCache[i] then
            monitor.setTextColor(colors.black)
        else
            monitor.setTextColor(colors.white)
        end
        monitor.setCursorPos(calcPos(col), calcPos(row, 3))

        -- Write text
        monitor.write(s)

        col = col + 1
        if calcPos(col) > w then
            col = 1
            row = row + 1
        end
    end
end

setup()
renderScreen()

while true do
    local senderId, message, protocol = rednet.receive()
    local id = split(message, ' ')[1]
    local status = split(message, ' ')[2]

    local t = tonumber(id)
    print('Received status ' .. status .. ' for chest ' .. t)

    if status == 'on' then
        onOffStatuses[t] = onOffStatuses[t] + 1
    else
        onOffStatuses[t] = onOffStatuses[t] - 1
        if onOffStatuses[t] < 0 then
            onOffStatuses[t] = 0
        end
    end

    local chest = chests[t]
    local items = chest.list()
    hasItemsCache[t] = #items > 0

    renderScreen()
end

