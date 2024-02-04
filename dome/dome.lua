local x = 1;
local y = 1;
local z = 1;

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

-- 
local width = 3;
local height = 3;
local depth = 3;

local xDir = 1;
local zDir = 1;

local isDone = false

function placeBlock()
    local selected = 1;
    while turtle.getItemCount(selected) == 0 do
        selected = selected + 1
    end
    turtle.select(selected)
    turtle.placeDown()
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
