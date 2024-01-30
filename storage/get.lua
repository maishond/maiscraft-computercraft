-- Broadcast from params
local args = {...}

-- Args to 1 string
args = table.concat(args, ' ')

-- Broadcast
rednet.open("right")
rednet.broadcast(args)
print('Searching...')

local senderId, message, protocol = rednet.receive()
print(message)
