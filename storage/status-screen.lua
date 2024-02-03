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
        onOffStatuses[tostring(i)] = 0
    end
end

function calcPos(num)
    return (num - 1) * 3 + 2
end

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

        local value = onOffStatuses[tostring(i)]

        if value > 0 then
            monitor.setBackgroundColor(colors.green)
            monitor.setTextColor(colors.green)
        else
            monitor.setBackgroundColor(colors.red)
            monitor.setTextColor(colors.red)
        end

        monitor.setCursorPos(calcPos(col), calcPos(row))
        monitor.write('OO')

        monitor.setCursorPos(calcPos(col), calcPos(row) + 1)
        monitor.write('OO')

        -- Index to string
        local s = tostring(i)

        -- Set colors to text
        monitor.setTextColor(colors.white)
        monitor.setCursorPos(calcPos(col), calcPos(row))

        -- Write text
        monitor.write(s:sub(1, 2))
        monitor.setCursorPos(calcPos(col), calcPos(row) + 1)
        monitor.write(s:sub(3, 4))

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

    if status == 'on' then
        onOffStatuses[id] = onOffStatuses[id] + 1
    else
        onOffStatuses[id] = onOffStatuses[id] - 1
        if onOffStatuses[id] < 0 then
            onOffStatuses[id] = 0
        end
    end

    print('Received message from ' .. senderId .. ' with status ' .. status .. ' for chest ' .. id)
    renderScreen()
end

