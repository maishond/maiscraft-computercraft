-- Import csv
-- local csvFile = fs.open('shape.csv', 'r')
local csvFile = http.get('https://jip-cc.loca.lt/dome/shape.csv')
local csv = csvFile.readAll()

local args = {...}
args = tonumber(table.concat(args, ' '))

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

-- ! Position
local x = 1;
local y = args;
local z = 1;

-- ! Movement methods
function forward()
    x = x + 1
    turtle.forward()
end

function back()
    x = x - 1
    turtle.back()
end

function up()
    y = y + 1
    turtle.up()
end

function down()
    y = y - 1
    turtle.down()
end

function left()
    z = z - 1
    turtle.turnLeft()
    turtle.forward()
    turtle.turnRight()
end

function right()
    z = z + 1
    turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()
end

-- ! Config
local shape = parseCSV(csv)
local height = #shape
local width = #shape[1]
local depth = #shape[1][1]

local xDir = 1;
local zDir = 1;

local isDone = false

function hasAirNeighbour(x, y, z)
    local neighbours = {{x + 1, y, z}, {x - 1, y, z}, {x, y, z + 1}, {x, y, z - 1}}

    local hasAir = false;
    for i = 1, #neighbours do
        local neighbour = neighbours[i]
        local isOutOfBounds = (not (neighbour[1] > 0 and neighbour[1] <= width)) or
                                  (not (neighbour[3] > 0 and neighbour[3] <= depth))

        if isOutOfBounds then
            hasAir = true;
        end

        if not isOutOfBounds and shape[neighbour[2]][neighbour[1]][neighbour[3]] == '-' then
            hasAir = true;
        end

    end

    return hasAir
end

function placeBlock()

    -- print('x: ' .. x .. ' y: ' .. y .. ' z: ' .. z)
    local block = shape[y][x][z]
    if block == 'X' and hasAirNeighbour(x, y, z) then

        local selected = 1;
        while turtle.getItemCount(selected) == 0 do
            selected = selected + 1
        end
        turtle.select(selected)

        turtle.placeDown()
    end
end

function move()
    placeBlock()
    if xDir == 1 then
        forward()
    else
        back()
    end
end

function moveAside()
    placeBlock()
    if zDir == 1 then
        right()
    else
        left()
    end
end

while not isDone do
    move()
    if x >= width or x <= 1 then
        if (z == depth and x == width) then
            -- ! Top right
            -- up()
            -- if y > height then
            --     isDone = true
            --     return
            -- end
            -- zDir = zDir * -1
            -- moveAside()
            isDone = true
            return
        elseif (zDir == -1 and x == width and z == 1) then
            -- ! Top left
            peripheral.find("speaker").playSound("entity.enderman.teleport", 1, 1)
            zDir = zDir * -1
            moveAside()
        else
            -- If not at end
            moveAside()
        end
        xDir = xDir * -1
    end

end
