local screen = {guiGetScreenSize()}

local infobox = {}

local font = {
    dxCreateFont('assets/fonts/semibold.ttf', 14, false),
    dxCreateFont('assets/fonts/medium.ttf', 10, false)
}

-- Valores relativos basados en el tamaño de la pantalla
local relativeValues = {
    marginBottom = screen[2] * 0.08, -- 8% del alto de la pantalla
    width = screen[1] * 0.003, -- 0.3% del ancho de la pantalla
    height = screen[2] * 0.08, -- 8% del alto de la pantalla (aumentado)
    padding = screen[1] * 0.005, -- 0.5% del ancho de la pantalla
    iconSize = screen[2] * 0.03, -- 3% del alto de la pantalla
    smallIconSize = screen[2] * 0.015, -- 1.5% del alto de la pantalla
    boxWidth = screen[1] * 0.18 -- 18% del ancho de la pantalla (nuevo)
}

posy = {}
radary = (screen[2] - relativeValues.marginBottom)
addEventHandler('onClientRender', root, function ()
    for i, v in ipairs(infobox) do
        if i <= config.limite then
            if v.state == 'iniciando' then
                alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount()-v.tick)/1000), 'Linear')
                v.porcentage = interpolateBetween(0, 0, 0, 100, 0, 0, ((getTickCount()-v.tick)/5000), 'Linear')
                if (v.porcentage >= 99) then
                    v.state = 'fechando'
                    v.tick = getTickCount()
                    v.porcentage = 100
                end
            else
                alpha = interpolateBetween(255, 0, 0, 0, 0, 0, ((getTickCount()-v.tick)/1000), 'Linear')
                if (alpha <= 20) then
                    table.remove(infobox, i)
                    returnPosY()
                end
            end
            dxDrawRectangle(screen[1] - relativeValues.boxWidth - relativeValues.width - relativeValues.padding, radary-(posy[i] or (relativeValues.height + relativeValues.padding * i)), relativeValues.width, v.height, tocolor(90, 94, 103, alpha), true)
            dxDrawRectangle(screen[1] - relativeValues.boxWidth - relativeValues.width - relativeValues.padding, radary-(posy[i] or (relativeValues.height + relativeValues.padding * i)), relativeValues.width, v.height/100*v.porcentage, tocolor(config.types[v.type].color[1], config.types[v.type].color[2], config.types[v.type].color[3], alpha), true)
            dxDrawRectangle(screen[1] - relativeValues.boxWidth - relativeValues.padding, radary-(posy[i] or (relativeValues.height + relativeValues.padding * i)), relativeValues.boxWidth, v.height, tocolor(31, 31, 31, 200), true)
            dxDrawImage(screen[1] - relativeValues.boxWidth - relativeValues.padding + relativeValues.padding*1.3, radary-(posy[i] or (relativeValues.height + relativeValues.padding * i))+relativeValues.height*0.30, relativeValues.iconSize, relativeValues.iconSize, 'assets/images/type.png', 0, 0, 0, tocolor(config.types[v.type].color[1], config.types[v.type].color[2], config.types[v.type].color[3], alpha), true)
            dxDrawText(v.type, screen[1] - relativeValues.boxWidth - relativeValues.padding + relativeValues.padding*5.5, radary-(posy[i] or (relativeValues.height + relativeValues.padding * i))+relativeValues.height*0.22, screen[1] - relativeValues.padding*2, 0, tocolor(255, 255, 255, alpha), 1, font[1], 'left', 'top', false, false, true)
            dxDrawText(v.text, screen[1] - relativeValues.boxWidth - relativeValues.padding + relativeValues.padding*5.5, radary-(posy[i] or (relativeValues.height + relativeValues.padding * i))+relativeValues.height*0.55, screen[1] - relativeValues.padding*2, radary-(posy[i] or (relativeValues.height + relativeValues.padding * i))+v.height-relativeValues.padding*2, tocolor(255, 255, 255, alpha), 1.00, font[2], "left", "top", true, true, true)
            dxDrawImage(screen[1] - relativeValues.boxWidth - relativeValues.padding + relativeValues.padding*2.2, radary-(posy[i] or (relativeValues.height + relativeValues.padding * i))+relativeValues.height*0.4, relativeValues.smallIconSize, relativeValues.smallIconSize, config.types[v.type].image, 0, 0, 0, tocolor(255, 255, 255, alpha), true)
        end
    end
end)

function returnPosY ()
    posy = {}
    for i, v in ipairs(infobox) do
        posy[i] = (posy[i-1] or 0) + (v.height+8)
    end
end

function addBoxSiri (message, type)
    for i, v in ipairs({ {'Sucess', 'success'}, {'Aviso', 'warning'}, {'Error', 'error'}, {'Admin', 'admin'}, {'Ayuda', 'help'}, {'BOT', 'bot'}, {'Informacion', 'info'}, {'Informacion Policia', 'infoPD'}, {'Informacion Mecanicos', 'infoMC'}, {'Informacion Sura', 'infoSR'}, {'Detran', 'detran'} }) do
        if type == v[2] then
            type = v[1]
        end
    end
    local tabela = {
        text = message,
        type = type,
        tick = getTickCount(),
        height = relativeValues.height, 
        state = 'iniciando',
        porcentage = 0
    }
    if string.len(message) > 50 then
        tabela.height = relativeValues.height + relativeValues.height * 0.6
    end
    if string.len(message) > 100 then
        tabela.height = relativeValues.height + relativeValues.height * 0.9
    end
    posy[#infobox+1] = (posy[#infobox] or 0) + (tabela.height+8)
    table.insert(infobox, tabela)
    playSound(config.types[type].sound)
end
addEvent('addBoxSiri', true)
addEventHandler('addBoxSiri', root, addBoxSiri)