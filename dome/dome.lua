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

-- ! Position
local x = 1;
local y = 1;
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

function placeBlock()

    print('x: ' .. x .. ' y: ' .. y .. ' z: ' .. z)
    local block = shape[y][x][z]
    print(block)
    print('---')
    if block == 'X' then

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
            up()
            if y > height then
                isDone = true
                return
            end
            zDir = zDir * -1
            moveAside()
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

    print(zDir, x, z)

end
