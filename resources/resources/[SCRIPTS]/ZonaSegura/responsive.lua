screen = {guiGetScreenSize ()}
resolution = {1920, 1080}
sx, sy = screen[1] / resolution[1], screen[2] / resolution[2]

function setScreenPosition (x, y, w, h)
    return ((x / resolution[1]) * screen[1]), ((y / resolution[2]) * screen[2]), ((w / resolution[1]) * screen[1]), ((h / resolution[2]) * screen[2])
end

function isCursorOnElement (x, y, w, h)
    if isCursorShowing () then
        local cursor = {getCursorPosition ()}
        local mx, my = cursor[1] * screen[1], cursor[2] * screen[2]
        return mx > x and mx < x + w and my > y and my < y + h
    end
    return false
end

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == "string" and isElement(pElementAttachedTo) and type(func) == "function" then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)

        if type(aAttachedFunctions) == "table" and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

_dxCreateFont = dxCreateFont
function dxCreateFont (path, scale, ...)
    local _, scale, _, _ = setScreenPosition (0, scale, 0, 0)

    return _dxCreateFont (path, scale, ...)
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawRectangle (x, y, w, h, ...)
end

_hou_circle = hou_circle
function hou_circle (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _hou_circle (x, y, w, h, ...)
end

_dxDrawImage = dxDrawImage
function dxDrawImage (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawImage (x, y, w, h, ...)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawImageSection (x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawText (text, x, y, (x + w), (y + h), ...)
end

_isCursorOnElement = isCursorOnElement
function isCursorOnElement (x, y, w, h)
    local x, y, w, h = setScreenPosition (x, y, w, h)

    return _isCursorOnElement (x, y, w, h)
end

svgsRectangle = {};
function dxDrawRoundedRectangle(x, y, w, h, radius, color, post)
    if not svgsRectangle[radius] then
        svgsRectangle[radius] = {}
    end
    if not svgsRectangle[radius][w] then
        svgsRectangle[radius][w] = {}
    end
    if not svgsRectangle[radius][w][h] then
        local path = string.format([[
        <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
        </svg>
        ]], w, h, w, h, w, h, radius)
        svgsRectangle[radius][w][h] = svgCreate(w, h, path)
    end
    if svgsRectangle[radius][w][h] then
        dxSetBlendMode('add')
        dxDrawImage(x, y, w, h, svgsRectangle[radius][w][h], 0, 0, 0, color, post or false)
        dxSetBlendMode('blend')
    end
end

_tocolor = tocolor
function tocolor(r, g, b, a)
    return _tocolor(r, g, b, a and (a >= 255 and 255 or ((a*255)/100)) or 255)
end


-- > SVG CREATE

svg = {};

function createVector (width, height, raw)
    local data = svgCreate (width, height, raw, function (element)
        if not element or not isElement (element) then
            return false
        end
        dxSetTextureEdge (element, 'clamp')
    end)
    return {
        element = data;
    }
end

function createSVG (identify, width, height, raw)
    if not svg[identify] then
        local data = createVector (width, height, raw)
        svg[identify] = data.element
    end
    return svg[identify]
end

function loadSVG()
    createSVG("icon-motor", 67, 67, [[
        <svg width="67" height="67" viewBox="0 0 67 67" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M26.8 21.44V24.12H30.82V26.8H26.8L24.12 29.48V33.5H21.44V29.48H18.76V40.2H21.44V36.18H24.12V40.2H28.14L30.82 42.88H41.54V37.52H44.22V41.54H48.24V28.14H44.22V32.16H41.54V26.8H33.5V24.12H37.52V21.44H26.8Z" fill="white"/>
        </svg>
    ]])
    createSVG("icon-fuel", 67, 67, [[
        <svg width="67" height="67" viewBox="0 0 67 67" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M41.6732 40.1104H39.9865V37.6445H40.4313C41.035 37.6436 41.6137 37.4033 42.0406 36.9765C42.4675 36.5496 42.7077 35.9709 42.7086 35.3672V30.2646H43.0823C43.1766 30.2646 43.2671 30.2271 43.3339 30.1603C43.4006 30.0936 43.4381 30.0031 43.4381 29.9087V27.884L44.381 28.6704C44.4182 28.7007 44.4648 28.717 44.5127 28.7167C44.5427 28.7168 44.5724 28.7102 44.5995 28.6973C44.6266 28.6843 44.6505 28.6654 44.6693 28.642C44.6866 28.6213 44.6996 28.5974 44.7075 28.5716C44.7155 28.5458 44.7182 28.5187 44.7155 28.4919C44.7129 28.465 44.7049 28.439 44.6921 28.4153C44.6792 28.3916 44.6618 28.3706 44.6408 28.3537L43.4559 27.3539V25.9803L46.5943 24.1229C46.7359 24.0399 46.8386 23.904 46.88 23.7452C46.9214 23.5863 46.898 23.4176 46.8149 23.276C46.7319 23.1345 46.596 23.0317 46.4372 22.9903C46.2784 22.949 46.1096 22.9724 45.968 23.0554L42.6695 25.0125H41.5557C41.4478 25.0125 41.3443 25.0551 41.2676 25.1311C41.191 25.2071 41.1475 25.3102 41.1465 25.4181V29.8909C41.1509 29.9839 41.1897 30.0719 41.2556 30.1377C41.3214 30.2036 41.4094 30.2424 41.5024 30.2468V35.3672C41.5024 35.6503 41.3899 35.9218 41.1897 36.122C40.9895 36.3222 40.718 36.4347 40.4349 36.4347H39.9865V22.4825C39.9865 22.206 39.8767 21.9408 39.6812 21.7453C39.4856 21.5498 39.2204 21.4399 38.9439 21.4399H26.8457C26.5688 21.4399 26.3033 21.5497 26.1072 21.7451C25.9111 21.9405 25.8005 22.2057 25.7995 22.4825V40.1104H24.12V43.0176H41.6732V40.1104ZM37.1612 29.6525H28.6213V24.8559H37.1612V29.6525Z" fill="white"/>
        </svg>
    ]])
end


function destroySVG ()
    if not next (svg) then
        return false
    end
    for i, v in pairs (svg) do
        if v and isElement (v) then
            destroyElement (v)
        end
    end
    svg = { }
    return true
end



local vectors = {}



function createVectorT(w,h,raw)
    local svgElm = svgCreate(w,h,raw)
    local svgXML = svgGetDocumentXML(svgElm)
    local rect = xmlFindChild(svgXML,"rect",0)
    return {
        svg = svgElm;
        xml = svgXML;
        rect = rect;
    }
end

function createCircleStroke(id,width,height,size)
    if (not id) then return end
    if not vectors[id] then
        size = size or 2
        local radius = math.min(width,height)/2
        local radiusLength = (2*math.pi)*radius
        local nw,nh = width+(size*2),height+(size*2)
        local raw = string.format([[
            <svg width = "%s" height = "%s">
                <rect x = "%s" y = "%s" rx = "%s" width = "%s" height = "%s" fill = "#FFFFFF" fill-opacity = "0" stroke = "#FFFFFF" stroke-width = "%s" stroke-dasharray = "%s" stroke-dashoffset = "%s" stroke-linecap = "round" stroke-linejoin = "round" />
            </svg>
        ]], nw, nh, size, size, radius, width, height, size, radiusLength, 0)
        local svg = createVectorT(width,height,raw)
        local atributes = {
            type = "circle-stroke";
            svgDetails = svg;
            width = width;
            height = height;
            radiusLength = radiusLength;

        }
        vectors[id] = atributes
    end
    return vectors[id]
end

function createCircle(id,w,h)
    --if (not id) then return end
    --  if not w or h then return end
    --if not vectors[id] then
        local radius = math.min(w,h)/2
        local raw = string.format([[
            <svg width="%s" height="%s">
                <rect rx="%s" width="%s" height="%s" fill="#FFFFFF"/>
            </svg>
        ]],w,h,radius,w,h)
        local svg = createVectorT(w,h,raw)
        local atributes = {
            type = "circle";
            svgDetails = svg;
            width = w;
            height = h;
        }
        vectors[id] = atributes
    --end
    return vectors[id]
end

function setSVGOffset(id,value)
    if not vectors[id] then return end
    local svg = vectors[id]
    local rect = svg.svgDetails.rect
    local newValue = svg.radiusLength - (svg.radiusLength/100) * value
    xmlNodeSetAttribute(rect,"stroke-dashoffset",newValue)
    svgSetDocumentXML(svg.svgDetails.svg,svg.svgDetails.xml)
end

function drawItem(id,x,y,rot,color,postGui)
    if not vectors[id] then return end

    local svg = vectors[id]

    color = color or 0xFFFFFF

    local width,height = svg.width,svg.height
    dxSetBlendMode("add")
    dxDrawImage(x,y,width,height,svg.svgDetails.svg,rot,0,0,color)
    dxSetBlendMode("blend")
end