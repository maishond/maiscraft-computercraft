-- Import utils file
require('utils')

-- local function getItems()
--   local chests = getChests(true)

--   -- ! Find items in chest

--   local itemCount = {}

--   -- Loop through chests
--   for i = 1, #chests do
--     -- Get chest
--     local chest = chests[i]
--     if chest == nil then
--       break
--     end

--     -- Get list of items
--     local items = chest.list()
--     if items == nil then
--       print('No items found')
--       break
--     end

--     -- Loop through table of items
--     for i = 1, 54 do
--       -- Get item
--       local item = items[i]
--       if item ~= nil then
--         -- Get item name
--         local itemName = item.name

--         item = { chestId = chest.id, slot = i, itemName = itemName, count = item.count }

--         if containsOnlyDigits(chest.id) == true then
--           table.insert(itemCount, item)
--         end

--         -- print("found " .. itemName .. " " .. item.count .. " in chest " .. chest.id .. " at slot " .. i)
--       end
--     end
--   end

--   -- Print results
--   local m = 'NEW_ITEM'

--   for i, x in ipairs(itemCount) do
--     -- print(x.chestId, x.slot, x.itemName)


--     --   PUSH_ITEM <turtle id>
--     -- <chest id>/<slot>/<hoeveelheid>/<item>


--     m = m .. "\n" .. x.chestId .. "/" .. x.slot .. "/" .. x.count .. "/" .. x.itemName
--   end

--   print("Sending msg")
--   ws.send(m)
-- end

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
  print(x[0])
end
