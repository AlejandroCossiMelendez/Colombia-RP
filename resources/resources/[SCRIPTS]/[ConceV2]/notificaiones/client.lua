local x, y = guiGetScreenSize( )
local sx, sy = ( x / 1366 ), ( y / 768 )


local font = dxCreateFont("utils/font.ttf", sx*14)
local font3 = dxCreateFont ("utils/medium.ttf", sx*17)

local infoTable = {};
local types = {
    ['Informacion'] = {'utils/info.png', tocolor(33, 150, 243), 'utils/info.mp3', tocolor(26, 143, 180)},
    ['Warning'] = {'utils/error.png', tocolor(188, 139, 18), 'utils/error.mp3', tocolor(170, 126, 17)},
    ['Exito'] = {'utils/aprobado.png', tocolor(55, 178, 87), 'utils/aprobado.mp3', tocolor(50, 165, 81, 255)},
    ['Error'] = {'utils/warning.png',tocolor(255, 65, 65), 'utils/error.mp3', tocolor(171, 46, 52)},
}

function dxDrawNotifications(tipo, mensaje, duration)
    if types[tipo] then
        table.insert(infoTable, {msg = mensaje, tick = getTickCount(), time = getTickCount() + (tonumber(duration)*1000), type = tipo})
        addEventHandler('onClientRender', root, dxDrawNotification)
        playSound(types[tipo][3])
    end
end

function dxDrawNotification ()

    local notificationHeight = 0
    local maxNotifications = 2 

    local excessNotifications = math.max(0, #infoTable - maxNotifications)

    for i = 1, excessNotifications do
        table.remove(infoTable, 1)
    end

    for i, v in ipairs(infoTable) do
        local time = getTickCount() - v.tick 
        local duration = v.time - v.tick
        local durationEnd = time / duration 
        local move = interpolateBetween(1366, 0, 0, 999, 0, 0, (getTickCount() - v.tick) / 250, 'Linear')
        local offsetY = 297 + notificationHeight 
        if durationEnd < 1 then
            dxDraw:RoundedRectangle(move, offsetY, 266, 68, types[v.type][2], 4)
            -- dxDraw:RoundedRectangle(move + 240, offsetY, 27, 64, types[v.type][4],4)
            dxDraw:Image(move + 10, offsetY + 11, 36, 41, types[v.type][1], 0, 0, 0, tocolor(255, 255, 255, 255), false)
            dxDraw:Text(v.type, move + 60, offsetY, move + 130, offsetY + 29, tocolor(255, 255, 255, 255), 1.00, font3, "left", "top", false, false, false, false, false)
            dxDraw:Text(v.msg, move + 62, offsetY + 27, move + 44, offsetY + 59, tocolor(255, 255, 255, 255), 1.00, font, "left", "top", false, true, true, false, false)
            notificationHeight = notificationHeight + 80
        else
            table.remove(infoTable, i)

            if #infoTable == 0 then
                removeEventHandler('onClientRender', root, dxDrawNotification)
            end
        end
    end
    click = getKeyState("mouse1")

end
