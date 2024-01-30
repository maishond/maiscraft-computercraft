-- Broadcast
rednet.open("right")
rednet.broadcast('deposit')
print('Depositing...')

local senderId, message, protocol = rednet.receive()
print(message)
