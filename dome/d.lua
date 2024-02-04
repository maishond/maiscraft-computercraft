-- Import csv
local csvFile = fs.open('dome-small.csv', 'r')
local csv = csvFile.readAll()
csvFile.close()

-- Function to split string
function split(pString, pPattern)
    local Table = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table, cap)
        end
        last_end = e + 1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end

-- Parse csv
function parseCSV(csvString)
    local layers = {}

    local lines = split(csvString, "\n\n")

    for y = 1, #lines do
        local layer = {}
        local rows = split(lines[y], "\n")
        for x = 2, #rows do
            local row = {}
            local cells = split(rows[x], ",")
            for z = 1, #cells do
                table.insert(row, cells[z])
            end
            table.insert(layer, row)
        end
        table.insert(layers, layer)
    end

    return layers
end

local shape = parseCSV(csv)

local y = 1;
local x = 1;
local z = 1;
local height = #shape
local width = #shape[1]
local depth = #shape[1][1]

local isDone = false

local xDir = 1
local zDir = 1

while not isDone do

    print('x: ' .. x .. ' y: ' .. y .. ' z: ' .. z)
    local block = shape[y][x][z]
    print(block)
    print('---')

    if block == nil then
        isDone = true
        return
    end

    if block == 'X' then
        -- Check that turtle has dirt block selected
        local selected = 1;
        while turtle.getItemCount(selected) == 0 do
            selected = selected + 1
        end
        turtle.select(selected)
        turtle.placeDown()
    end

    -- Move
    local moved = turtle.forward()
    if moved then
        x = x + xDir
    end

    if x > width or x < 1 then
        z = z + 1
        if xDir == 1 then
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
            turtle.forward()
            xDir = -1
        else
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
            turtle.forward()
            xDir = 1
        end
        x = x + xDir
    end

    if z > depth or z < 1 then
        turtle.up()
        y = y + 1
        if zDir == -1 then
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
            turtle.forward()
            zDir = -1
        else
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
            turtle.forward()
            zDir = 1
        end
        z = z + zDir
    end

    if y > height then
        isDone = true
    end

end
