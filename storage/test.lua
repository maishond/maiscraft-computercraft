-- Import utils file
require('utils')

function getItems()
  local chests = getChests(true)

  -- ! Find items in chest

  local itemCount = {}

  -- Loop through chests
  for i = 1, #chests do
    -- Get chest
    local chest = chests[i]
    if chest == nil then
      break
    end

    -- Get list of items
    local items = chest.list()
    if items == nil then
      print('No items found')
      break
    end

    -- Loop through table of items
    for i = 1, 54 do
      -- Get item
      local item = items[i]
      if item ~= nil then
        -- Get item name
        local itemName = item.name

        item = { chestId = chest.id, slot = i, itemName = itemName, count = item.count }

        if containsOnlyDigits(chest.id) == true then
          table.insert(itemCount, item)
        end

        -- print("found " .. itemName .. " " .. item.count .. " in chest " .. chest.id .. " at slot " .. i)
      end
    end
  end

  -- Print results
  local m = 'NEW_ITEM'

  for i, x in ipairs(itemCount) do
    -- print(x.chestId, x.slot, x.itemName)


    --   PUSH_ITEM <turtle id>
    -- <chest id>/<slot>/<hoeveelheid>/<item>


    m = m .. "\n" .. x.chestId .. "/" .. x.slot .. "/" .. x.count .. "/" .. x.itemName
  end

  print("done refreshing items")
  return m
end

function dropItem(chestId, itemSlot, itemCount, itemId)
  local turtleName = getTurtleName()

  -- Get chest
  local chest = peripheral.wrap("minecraft:chest_" .. chestId)

  -- Take item
  turtle.select(1)
  chest.pushItems(turtleName, tonumber(itemSlot), tonumber(itemCount))

  -- Find item in turtle
  for i = 1, 16 do
    local item = turtle.getItemDetail(i)
    if item ~= nil then
      local itemName = item.name
      if itemName == itemId then
        turtle.select(i)
        turtle.dropDown()
      end
    end
  end
end

local ws = assert(http.websocket("ws://preservation-nepal-potatoes-immigrants.trycloudflare.com"))

while true do
  ::begin::


  ws.send("connect")

  local msg = ws.receive()

  if (msg == nil) then
    -- no message received, jumping to begin of loop

    goto begin
  end

  local x = split(msg, "\n")
  local instruction = x[1]

  print(instruction)

  if instruction == "DROP" then
    for i = 2, #x do
      local splitstring = split(x[i], "/")

      local containerId = splitstring[1]
      local slot = splitstring[2]
      local quantity = splitstring[3]
      local itemId = splitstring[4]


      print(containerId, slot, quantity, itemId)
      dropItem(containerId, slot, quantity, itemId)
    end
  elseif instruction == "REFRESH_ITEMS" then
    print("getting items!!!!")
    local msg = getItems()

    ws.send(msg)
  end
end
