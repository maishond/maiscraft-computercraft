-- Get monitor
local monitor = peripheral.find("monitor")

-- ComputerCraft function to draw pixel to X/Y
function drawPixel(x, y, color)
    -- Set color
    monitor.setTextColour(color)
    monitor.setBackgroundColor(color)

    -- Draw pixel
    monitor.setCursorPos(x, y)
    monitor.write("O")
end

-- Init
function init()
    monitor.setTextScale(0.5)
    monitor.setBackgroundColor(colours.black)
    monitor.clear()

    -- drawPixel(2, 2, colours.red)
    local allColors = {colours.white, colours.orange, colours.magenta, colours.lightBlue, colours.yellow, colours.lime,
                       colours.pink, colours.grey, colours.lightGrey, colours.cyan, colours.purple, colours.blue,
                       colours.brown, colours.green, colours.red, colours.black}

    local w, h = monitor.getSize()
    for x = 1, w do
        for y = 1, h do
            local r = math.random(1, 16)
            print(r)
            drawPixel(x, y, allColors[r])
        end
    end

end

init()
