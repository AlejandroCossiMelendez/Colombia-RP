--[[ 
Utilidades del HUD para Colombia RP
Adaptado de ice_hud
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
    Fonts = {},
    Images = {},
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

-- Cargar fuentes e imágenes cuando el recurso inicia
addEventHandler("onClientResourceStart", resourceRoot, function()
    outputChatBox("[HUD] Cargando recursos del HUD...", 255, 255, 0)
    
    -- Intentar cargar fuentes desde ice_hud/nui/, si no existen usar default
    cache.Fonts["Fonte Mont Bold 10"] = dxCreateFont("ice_hud/nui/fonts/Montserrat-Bold.ttf", 10, false, "cleartype_natural" ) or 'default'
    cache.Fonts["Fonte Mont Bold 12"] = dxCreateFont("ice_hud/nui/fonts/Montserrat-Bold.ttf", 12, false, "cleartype_natural" ) or 'default'
    cache.Fonts["Fonte Mont Itali Bold"] = dxCreateFont("ice_hud/nui/fonts/Montserrat-Bold.ttf", 10, false, "cleartype_natural" ) or 'default'
    cache.Fonts["Fonte Mont Itali Bold 15"] = dxCreateFont("ice_hud/nui/fonts/Montserrat-Bold.ttf", 15, false, "cleartype_natural" ) or 'default'
    cache.Fonts["Fonte Mont Itali Bold velo"] = dxCreateFont("ice_hud/nui/fonts/Montserrat-Bold.ttf", 25, false, "cleartype_natural" ) or 'default'
    
    -- Cargar imágenes desde ice_hud/nui/
    cache.Images["agua"] = dxCreateTexture( "ice_hud/nui/images/agua.png", 'dxt5', true, 'clamp') or nil
    cache.Images["colete"] = dxCreateTexture( "ice_hud/nui/images/colete.png", 'dxt5', true, 'clamp') or nil
    cache.Images["comida"] = dxCreateTexture( "ice_hud/nui/images/comida.png", 'dxt5', true, 'clamp') or nil
    cache.Images["fundo"] = dxCreateTexture( "ice_hud/nui/images/fundo.png", 'dxt5', true, 'clamp') or nil
    cache.Images["gas"] = dxCreateTexture( "ice_hud/nui/images/gas.png", 'dxt5', true, 'clamp') or nil
    cache.Images["mic"] = dxCreateTexture( "ice_hud/nui/images/mic.png", 'dxt5', true, 'clamp') or nil
    cache.Images["velocimetro"] = dxCreateTexture( "ice_hud/nui/images/velocimetro.png", 'dxt5', true, 'clamp') or nil
    cache.Images["vida"] = dxCreateTexture( "ice_hud/nui/images/vida.png", 'dxt5', true, 'clamp') or nil
    cache.Images["cinto"] = dxCreateTexture( "ice_hud/nui/images/cinto.png", 'dxt5', true, 'clamp') or nil
    cache.Images["gps"] = dxCreateTexture( "ice_hud/nui/images/gps.png", 'dxt5', true, 'clamp') or nil
    cache.Images["relogio"] = dxCreateTexture( "ice_hud/nui/images/relogio.png", 'dxt5', true, 'clamp') or nil
    cache.Images["freq"] = dxCreateTexture( "ice_hud/nui/images/freq.png", 'dxt5', true, 'clamp') or nil
    cache.Images["muni"] = dxCreateTexture( "ice_hud/nui/images/muni.png", 'dxt5', true, 'clamp') or nil
    
    -- Verificar carga
    local imagesLoaded = 0
    for k, v in pairs(cache.Images) do
        if v then imagesLoaded = imagesLoaded + 1 end
    end
    outputChatBox("[HUD] Imágenes cargadas: " .. imagesLoaded .. "/13", 255, 255, 0)
    outputChatBox("[HUD] Fuentes cargadas: " .. (cache.Fonts["Fonte Mont Bold 10"] ~= 'default' and "Sí" or "No"), 255, 255, 0)
end)

cache.functions.register = function(event, ...)
    _event(event, true)
    _eventH(event, ...)
end

-- Sistema de voz
addEventHandler ( "onClientPlayerVoiceStart", getRootElement(), function() 
    if (source and isElement(source) and getElementType(source) == "player") and localPlayer == source then
        setElementData(source, "Mic", true)
    end 
end )

addEventHandler ( "onClientPlayerVoiceStop", getRootElement(),function()
    if (source and isElement(source) and getElementType(source) == "player") and localPlayer == source then
        setElementData(source, "Mic", false)
    end
end)

components = {'ammo', 'armour', 'health', 'money', 'wanted', 'weapon', 'area_name', 'vehicle_name', 'breath', 'clock', 'radar'}

cache.functions.hiddeComponets = function(state)
    for _, component in pairs(components) do
        setPlayerHudComponentVisible(component, state)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
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

cache.functions.getElementSpeed = function (element,unit)
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
        minutes = "0"..time.minute
    end
    if (seconds >= 0 and seconds < 10) then
        seconds = "0"..time.second
    end
    local meses = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"}
    local mesesName = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"}
    local dias = {"Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"}
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

