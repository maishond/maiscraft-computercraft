-- wget run https://jip-cc.loca.lt/storage/update.lua
local baseUrl = 'https://jip-cc.loca.lt/storage'
local urls = {
    ['update'] = baseUrl .. '/update.lua',
    ['get'] = baseUrl .. '/get.lua',
    ['deposit'] = baseUrl .. '/deposit.lua',
    ['utils'] = baseUrl .. '/utils.lua',
    ['count'] = baseUrl .. '/count.lua',
    ['capacity'] = baseUrl .. '/capacity.lua',
    ['startup'] = baseUrl .. '/startup.lua',
    ['clean'] = baseUrl .. '/clean.lua',
    ['status-screen'] = baseUrl .. '/status-screen.lua',
    ['stock'] = baseUrl .. '/stock.lua',
    ['count-all'] = baseUrl .. '/count-all.lua'
}

-- Loop over urls
for key, url in pairs(urls) do
    -- Get response
    local response = http.get(url)

    if response ~= nil then
        -- Read response
        local responseText = response.readAll()

        -- Write to file
        local file = fs.open(key .. '.lua', 'w')
        file.write(responseText)
        file.close()
        print('Saved ' .. key .. '.lua')

        -- Close response
        response.close()
    else
        print('Failed to get response from ' .. url)
    end

end

-- Check if startup-override.lua exists, if so, replace startup.lua with it
if fs.exists('startup-override.lua') then
    fs.delete('startup.lua')
    fs.copy('startup-override.lua', 'startup.lua')
    print('Replaced startup.lua with startup-override.lua')
end
