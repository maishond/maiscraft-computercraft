-- Import utils file
require('utils')

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

      -- Check if item is in list
      -- if itemCount[itemName] == nil then
      --   itemCount[itemName] = 0
      -- end

      -- Add to count
      -- itemCount[itemName] = itemCount[itemName] + item.count


      item = { chestId = chest.id, slot = i, itemName = itemName, count = item.count }

      if containsOnlyDigits(chest.id) == true then
        table.insert(itemCount, item)
      end

      -- print("found " .. itemName .. " " .. item.count .. " in chest " .. chest.id .. " at slot " .. i)
    end
  end
end

-- Print results
local i = 0;
local m = 'NEW_ITEM'

local ws = assert(http.websocket("ws://signup-goal-affect-conducting.trycloudflare.com"))


for i, x in ipairs(itemCount) do
  print(x.chestId, x.slot, x.itemName)


  --   PUSH_ITEM <turtle id>
  -- <chest id>/<slot>/<hoeveelheid>/<item>


  m = m .. "\n" .. x.chestId .. "/" .. x.slot .. "/" .. x.count .. "/" .. x.itemName
  -- Send a message
  -- local message = key .. '/' .. value
  -- m = m .. message .. '\n'
  -- i = i + 1
  -- print(i .. '/' .. #pairs(itemCount))
  -- if i % 30 == 0 then
  -- local webhook =
  -- 'https://discord.com/api/webhooks/1202728339471863838/ziJFqkZPym-r3S9D-r4FryNbJ3nUGMqEAbSKbSDH7jXWk_9hsfPWwpf_s-LDizHLzjkQ'
  -- http.post(webhook, 'content=' .. x.chestId, x.slot, x.itemName)
  --   m = ''
  --   print('Sleeping')
  --   sleep(2)
  -- end
end

print("Sending msg")
ws.send(m)
ws.close()
