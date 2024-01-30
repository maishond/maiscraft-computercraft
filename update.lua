local baseUrl = 'https://jip-cc.loca.lt'
local urls = {
    ['update'] = baseUrl .. '/update',
    ['get'] = baseUrl .. '/get',
    ['deposit'] = baseUrl .. '/deposit'
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

    -- Write to file
    local file = fs.open(key .. '.lua', 'w')
    file.write(responseText)
    file.close()
    print('Saved ' .. key .. '.lua')

    -- Close response
    response.close()
end
