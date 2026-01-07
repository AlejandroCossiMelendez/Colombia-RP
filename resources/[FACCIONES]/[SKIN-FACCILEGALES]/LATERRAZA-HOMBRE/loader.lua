
local files = {
	{ "pecxdo.txd.pcrypt", 250 },
	{ "pecxdo.dff.pcrypt", 250 },
}


local cor = coroutine.create(function()
    for i = 1, #files do
        local file  = files[i][1]
        local model = files[i][2]

        pDecrypt(file, function(data)
            loadModel(file, data, model)
        end)
        coroutine.yield()
    end

    files = nil
    collectgarbage()
end)

function loadModel(file, data, model)
    local ext = file:match("^.+(%..+)%..+$")

    if ext == ".dff" then
        engineReplaceModel(engineLoadDFF(data), model)
    elseif ext == ".txd" then
        engineImportTXD(engineLoadTXD(data), model)
    elseif ext == ".col" then
        engineReplaceCOL(engineLoadCOL(data), model)
    end

    coroutine.resume(cor)
end

coroutine.resume(cor)
