--[[ 
╔══════════════════════════════════════════════════[ www.hyperscripts.com.br ]═════════════════════════════════════════════════════════════╗
 ___  ___      ___    ___ ________  _______   ________          ________  ________  ________  ___  ________  _________  ________      
|\  \|\  \    |\  \  /  /|\   __  \|\  ___ \ |\   __  \        |\   ____\|\   ____\|\   __  \|\  \|\   __  \|\___   ___\\   ____\     
\ \  \\\  \   \ \  \/  / | \  \|\  \ \   __/|\ \  \|\  \       \ \  \___|\ \  \___|\ \  \|\  \ \  \ \  \|\  \|___ \  \_\ \  \___|_    
 \ \   __  \   \ \    / / \ \   ____\ \  \_|/_\ \   _  _\       \ \_____  \ \  \    \ \   _  _\ \  \ \   ____\   \ \  \ \ \_____  \   
  \ \  \ \  \   \/  /  /   \ \  \___|\ \  \_|\ \ \  \\  \|       \|____|\  \ \  \____\ \  \\  \\ \  \ \  \___|    \ \  \ \|____|\  \  
   \ \__\ \__\__/  / /      \ \__\    \ \_______\ \__\\ _\         ____\_\  \ \_______\ \__\\ _\\ \__\ \__\        \ \__\  ____\_\  \ 
    \|__|\|__|\___/ /        \|__|     \|_______|\|__|\|__|       |\_________\|_______|\|__|\|__|\|__|\|__|         \|__| |\_________\
             \|___|/                                              \|_________|                                            \|_________|
  
╚══════════════════════════════════════════════════[ www.hyperscripts.com.br ]═════════════════════════════════════════════════════════════╝
--]]

 
----- Utils ----
screen = { guiGetScreenSize() }
resW, resH = 1366, 768
sx, sy = screen[1]/resW, screen[2]/resH
 
function aToR(X, Y, sX, sY)

    local xd = X/resW or X

    local yd = Y/resH or Y

    local xsd = sX/resW or sX

    local ysd = sY/resH or sY

    return xd * screen[1], yd * screen[2], xsd * screen[1], ysd * screen[2]
    
end

_dxDrawRectangle = dxDrawRectangle

function dxDrawRectangle(x, y, w, h, ...)

    local x, y, w, h = aToR(x, y, w, h)

    return _dxDrawRectangle(x, y, w, h, ...)

end

_dxDrawText = dxDrawText

function dxDrawText(text, x, y, w, h, ...)

    local x, y, w, h = aToR(x, y, w, h)

    return _dxDrawText(text, x, y, w + x, h + y, ...)

end

_dxDrawImage = dxDrawImage

function dxDrawImage(x, y, w, h, ...)

    local x, y, w, h = aToR(x, y, w, h)

    return _dxDrawImage(x, y, w, h, ...)

end

_dxCreateFont = dxCreateFont

function dxCreateFont( filePath, size, ... )

    return _dxCreateFont( filePath, ( sx * size ), ... )

end

_event = addEvent
_eventH = addEventHandler
cache = {

    functions = {},
    EditBox = {},
    Dx = {
        Image = dxDrawImage,
        Retangulo = dxDrawRectangle,
        Text = dxDrawText,
    },
    Fonts = {
        ["Fonte Mont Bold 10"] = dxCreateFont("nui/fonts/Montserrat-Bold.ttf", 10, false, "cleartype_natural" ) or 'default',
        ["Fonte Mont Bold 12"] = dxCreateFont("nui/fonts/Montserrat-Bold.ttf", 12, false, "cleartype_natural" ) or 'default',
        ["Fonte Mont Itali Bold"] = dxCreateFont("nui/fonts/Montserrat-Bold.ttf", 10, false, "cleartype_natural" ) or 'default',
        ["Fonte Mont Itali Bold 15"] = dxCreateFont("nui/fonts/Montserrat-Bold.ttf", 15, false, "cleartype_natural" ) or 'default',
        ["Fonte Mont Itali Bold velo"] = dxCreateFont("nui/fonts/Montserrat-Bold.ttf", 25, false, "cleartype_natural" ) or 'default',
        
    },
    Images = {

        ["agua"] = dxCreateTexture( "nui/images/agua.png", 'dxt5', true, 'clamp'),
        ["colete"] = dxCreateTexture( "nui/images/colete.png", 'dxt5', true, 'clamp'),
        ["comida"] = dxCreateTexture( "nui/images/comida.png", 'dxt5', true, 'clamp'),
        ["fundo"] = dxCreateTexture( "nui/images/fundo.png", 'dxt5', true, 'clamp'),
        ["gas"] = dxCreateTexture( "nui/images/gas.png", 'dxt5', true, 'clamp'),
        ["mic"] = dxCreateTexture( "nui/images/mic.png", 'dxt5', true, 'clamp'),
        ["velocimetro"] = dxCreateTexture( "nui/images/velocimetro.png", 'dxt5', true, 'clamp'),
        ["vida"] = dxCreateTexture( "nui/images/vida.png", 'dxt5', true, 'clamp'),
        ["cinto"] = dxCreateTexture( "nui/images/cinto.png", 'dxt5', true, 'clamp'),
        ["gps"] = dxCreateTexture( "nui/images/gps.png", 'dxt5', true, 'clamp'),
        ["relogio"] = dxCreateTexture( "nui/images/relogio.png", 'dxt5', true, 'clamp'),
        ["freq"] = dxCreateTexture( "nui/images/freq.png", 'dxt5', true, 'clamp'),
        ["muni"] = dxCreateTexture( "nui/images/muni.png", 'dxt5', true, 'clamp'),
    
    },
    tabela = {
        tickOldVida = 0,
        tickOldColete = 0,
        tickOldFome = 0,
        tickOldSede = 0,
        tickOldVelo = 0,
        tickNew = getTickCount ( ),
        tickNew2 = getTickCount ( ),
    },
}


cache.functions.register =
function(event, ...)
    _event(event, true)
    _eventH(event, ...)
end


addEventHandler ( "onClientPlayerVoiceStart", getRootElement(), function() 
    if (source and isElement(source) and getElementType(source) == "player") and localPlayer == source then
        setElementData(source, "Mic", true)
    end 
end );

addEventHandler ( "onClientPlayerVoiceStop", getRootElement(),function()
    if (source and isElement(source) and getElementType(source) == "player") and localPlayer == source then
        setElementData(source, "Mic", false)
    end
end);

components = {'ammo', 'armour', 'health', 'money', 'wanted', 'weapon', 'area_name', 'vehicle_name', 'breath', 'clock', 'radar'};

cache.functions.hiddeComponets = function(state)
    for _, component in pairs(components) do
        setPlayerHudComponentVisible(component, state)
    end
end

addEventHandler("onClientResourceStart", getRootElement(), function()
    
    cache.functions.hiddeComponets(false)
    
end)

cache.functions.getFormatSpeed = function(unit)
    if unit < 10 then
        unit = "#8B8B8B00#ffffff" .. unit
    elseif unit < 100 then
        unit = "#8B8B8B0#ffffff" .. unit
    elseif unit >= 1000 then
        unit = "999"
    end
    return unit
end

cache.functions.getVehicleSpeed = function()
    if isPedInVehicle(getLocalPlayer()) then
	    local theVehicle = getPedOccupiedVehicle (getLocalPlayer())
        local vx, vy, vz = getElementVelocity (theVehicle)
        return math.sqrt(vx^2 + vy^2 + vz^2) * 225
    end
    return 0
end


cache.functions.getElementSpeed =
function (element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100)
        else
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100 * 1.609344)
        end
    else
        return false
    end
end

cache.functions.timerR = function()
    local time = getRealTime()
    local hours = time.hour
    local minutes = time.minute
    local seconds = time.second
    if (hours >= 0 and hours < 10) then
        hours = "0"..time.hour
    end
    if (minutes >= 0 and minutes < 10) then
        minutes = "0"..time.minute        end
        if (seconds >= 0 and seconds < 10) then
            seconds = "0"..time.second
        end
        local meses = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"}
        local mesesName = {"Janeiro", "Fevereiro", "Março ", "Abril ", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"}
        local dias = {"Domingo", "Segunda-Feira", "Terça-Feira", "Quarta-Feira", "Quinta-Feira", "Sexta-Feira", "Sábado"}
        local dia = ("%02d"):format(time.monthday)
        local ano = ("%02d"):format(time.year + 1900)
        local diaa = dias[time.weekday + 1]
        local mes = meses[time.month + 1]
        local mesname = mesesName[time.month + 1]
        if time and hours and minutes and seconds then
            return hours, minutes
        end
        return '0', '0', '0', '0', '0', '0', '0'
    end