--------------------------------------------------------

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy

--------------------------------------------------------

cache = {
    fuel = {false, 0, getTickCount()}, 
}

local vectors = {}
function createVector(width, height, rawData)
    local svgElm = svgCreate(width, height, rawData)
    local svgXML = svgGetDocumentXML(svgElm)
    local rect = xmlFindChild(svgXML, 'rect', 0)

    return {
        svg = svgElm,
        xml = svgXML,
        rect = rect
    }
end

function createCircleStroke(id, width, height, sizeStroke)
    if (not id) then return end
    if (not (width or height)) then return end

    if (not vectors[id]) then
        sizeStroke = sizeStroke or 2

        local radius = math.min(width, height) / 2
        local radiusLenght = (2 * math.pi) * radius
        local newWidth, newHeight = width + (sizeStroke * 2), height + (sizeStroke * 2)

        local raw = string.format([[
            <svg width='%s' height='%s' >
                <rect x='%s' y='%s' rx='%s' width='%s' height='%s' fill='#FFFFFF' fill-opacity='0' stroke='#FFFFFF'
                stroke-width='%s' stroke-dasharray='%s' stroke-dashoffset='%s' stroke-linecap='round' stroke-linejoin='round' />
            </svg>
        ]], newWidth, newHeight, sizeStroke, sizeStroke, radius, width, height, sizeStroke, radiusLenght, 0)
        local svg = createVector(width, height, raw)

        local attributes = {
            type = 'circle-stroke',
            svgDetails = svg,
            width = width,
            height = height,
            radiusLenght = radiusLenght
        }

        vectors[id] = attributes
    end
    return vectors[id]
end

function createCircle(id, width, height)
    if (not id) then return end
    if (not (width or height)) then return end

    if (not vectors[id]) then
        width = width or 1
        height = height or 1

        local radius = math.min(width, height) / 2
        local raw = string.format([[
            <svg width='%s' height='%s' >
                <rect rx='%s' width='%s' height='%s' fill='#FFFFFF' />
            </svg>
        ]], width, height, radius, width, height)
        local svg = createVector(width, height, raw)

        local attributes = {
            type = 'circle',
            svgDetails = svg,
            width = width,
            height = height
        }
        vectors[id] = attributes
    end
    return vectors[id]
end

function setSVGOffset(id, value)
    if (not vectors[id]) then return end
    local svg = vectors[id]

    if (cache[id][2] ~= value) then
        if (not cache[id][1]) then
            cache[id][3] = getTickCount()
            cache[id][1] = true
        end

        local progress = (getTickCount() - cache[id][3]) / 2500
        cache[id][2] = interpolateBetween(cache[id][2], 0, 0, value, 0, 0, progress, 'OutQuad')

        if (progress > 1) then
            cache[id][3] = nil
            cache[id][1] = false
        end

        local rect = svg.svgDetails.rect
        local newValue = svg.radiusLenght - (svg.radiusLenght / 100) * cache[id][2]

        xmlNodeSetAttribute(rect, 'stroke-dashoffset', newValue)
        svgSetDocumentXML(svg.svgDetails.svg, svg.svgDetails.xml)
    elseif (cache[id][1]) then
        cache[id][1] = false
    end
end

function drawItem(id, x, y, color, postGUI)
    if (not vectors[id]) then return end
    if (not (x or y)) then return end
    local svg = vectors[id]

    postGUI = postGUI or false
    color = color or 0xFFFFFFFF

    local width, height = svg.width, svg.height

    dxSetBlendMode('add')
    dxDrawImage(x, y, width, height, svg.svgDetails.svg, 0, 0, 0, color, postGUI)
    dxSetBlendMode('blend')
end

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")

    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 270 or 142) 

    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function formatNumber(number, sep)
    assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
    assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
    local money = number
    for i = 1, tostring(money):len()/3 do
        money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
    end
    return money
end

function getMarchCurrent (vehicle)
    local kmh = math.floor(getElementSpeed(vehicle, 1))
    if kmh == 0 then
        return 'N'
    else
        local march = tostring(getVehicleCurrentGear(vehicle))
        if march == '0' then
            return 'R'
        else
            return march
        end
    end
end

function getHours()
    local time = getRealTime() 
    local hours = time.hour 
    local minutes = time.minute

    if (hours < 10) then 
        hours = '0'..hours 
    end 

    if (minutes < 10) then 
        minutes = '0'..minutes
    end 
    return hours..':'..minutes
end

--------------------------------------------------------

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : http