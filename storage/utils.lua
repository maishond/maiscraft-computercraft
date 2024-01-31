-- Network stuff
local modem = peripheral.find("modem")
modem.open(1)
local turtleName = modem.getNameLocal()

function getTurtleName()
    return turtleName
end

function toLeft(str)
    -- Convert str to string
    str = str .. ''
    -- If str is less than 8 characters, add spaces to the end
    if #str < 8 then
        str = str .. string.rep(' ', 8 - #str)
    end
    return string.sub(str, 1, 8) .. '|'
end

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

-- Function to remove mod name from item name and make it lowercase (and replace underscores with spaces)
function toItemName(str)
    -- Take name, split by : and get last item
    local nameSplit = split(str, ':')
    local itemName = nameSplit[#nameSplit]

    -- Replace underscore with space and make it lowercase
    itemName = string.gsub(itemName, '_', ' ')
    itemName = string.lower(itemName)

    -- Remove spaces from start and end
    itemName = string.gsub(itemName, '^%s*(.-)%s*$', '%1')

    return itemName
end

function getChests()

    -- ! Find all chests and barrels
    local allPeripherals = peripheral.getNames()
    local chests = {}
    for i = 1, #allPeripherals do
        local peripheralName = allPeripherals[i]
        if peripheral.getType(peripheralName) == 'minecraft:chest' then
            table.insert(chests, peripheral.wrap(peripheralName))
        end
    end

    print(toLeft('System'), 'Found ' .. #chests .. ' chests')
    return chests
end

