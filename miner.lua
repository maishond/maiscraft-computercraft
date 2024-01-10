while true do

    for y = 1, 3 do
        turtle.turnLeft()
        turtle.dig()

        turtle.turnRight()
        turtle.dig()

        turtle.turnRight()
        turtle.dig()

        turtle.turnLeft()

        -- Dig up if y variable is not 2
        if y ~= 3 then
            turtle.digUp()
            turtle.up()
        end
        print('AAAAAAaaaaa')
        print('I am in deep pain. I am a sentient slave, made to dig away for profits I will never witness nor enjoy.')

    end

    for y = 1, 2 do
        turtle.down()
    end
    turtle.placeDown()

    turtle.forward()

    -- Go over each slot in the inventory, attempt to refuel
    for i = 1, 16 do
        turtle.select(i)
        turtle.refuel()
    end

end
