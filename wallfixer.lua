-- Wall fixer
-- This script is used to fix the walls in the game
local canMoveUp = true
local canMoveDown = true

while canMoveUp do

    local blockInFront = turtle.detect()

    if not turtle.compare() then
        turtle.dig()
        turtle.place()
    end

    -- Move up
    canMoveUp = turtle.up()
end

while canMoveDown do
    -- Move down
    canMoveDown = turtle.down()
end
