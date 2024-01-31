-- wget run https://jip-cc.loca.lt/storage/update.lua
local baseUrl = 'https://jip-cc.loca.lt/storage'
local urls = {
    ['update'] = baseUrl .. '/update.lua',
    ['get'] = baseUrl .. '/get.lua',
    ['deposit'] = baseUrl .. '/deposit.lua',
    ['chest'] = baseUrl .. '/chest.lua',
    ['utils'] = baseUrl .. '/utils.lua'
}

-- Loop over urls
for key, url in pairs(urls) do
    -- Get response
    local response = http.get(url)
    if response == nil then
        print('Failed to get response from ' .. url)
        return
    end

    -- Read response
    local responseText = response.readAll()

    if responseText == nil then
        print('Failed to read response from ' .. url)
        return
    end

    -- Write to file
    local file = fs.open(key .. '.lua', 'w')
    file.write(responseText)
    file.close()
    print('Saved ' .. key .. '.lua')

    -- Close response
    response.close()
end
