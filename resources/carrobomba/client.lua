local sx, sy = guiGetScreenSize()
local zoom = math.min(1, 1920 / sx)

local countdown = nil
local isDefuseUIOpen = false
local defuseOptions = {}
local defuseTimeLeft = 0

addEvent("carbomb:startCountdown", true)
addEventHandler("carbomb:startCountdown", root, function(seconds)
    local start = getTickCount()
    local total = tonumber(seconds) or 240
    countdown = { endTick = start + total*1000, seconds = total }
	playSoundFrontEnd(46)
end)

addEvent("carbomb:stopCountdown", true)
addEventHandler("carbomb:stopCountdown", root, function()
	countdown = nil
end)

addEvent("carbomb:closeDefuseUI", true)
addEventHandler("carbomb:closeDefuseUI", root, function()
    if isDefuseUIOpen then
        isDefuseUIOpen = false
        showCursor(false)
        defuseOptions = {}
        defuseTimeLeft = 0
    end
end)

addEventHandler("onClientRender", root, function()
	if countdown then
		local now = getTickCount()
        local leftMs = countdown.endTick - now
        if leftMs <= 0 then
            countdown = nil
            return
        end
        local total = countdown.seconds
        local left = math.ceil(leftMs / 1000)
		local w, h = 350/zoom, 60/zoom
		dxDrawRectangle(sx/2 - w/2, 80/zoom, w, h, tocolor(0,0,0,150), true)
        dxDrawText("CARRO BOMBA: "..left.."s / "..tostring(total).."s", sx/2 - w/2, 80/zoom, sx/2 + w/2, 80/zoom + h, tocolor(255,80,80,255), 1, "default-bold", "center", "center", false, false, true)
	end
	if isDefuseUIOpen then
		local w, h = 420/zoom, 220/zoom
		dxDrawRectangle(sx/2 - w/2, sy/2 - h/2, w, h, tocolor(0,0,0,180), true)
		dxDrawText("DESARMAR BOMBA", sx/2 - w/2, sy/2 - h/2, sx/2 + w/2, sy/2 - h/2 + 40/zoom, tocolor(255,255,255,255), 1, "default-bold", "center", "center", false, false, true)
		dxDrawText("Corta el cable correcto:", sx/2 - w/2, sy/2 - h/2 + 40/zoom, sx/2 + w/2, sy/2 - h/2 + 70/zoom, tocolor(220,220,220,255), 1, "default", "center", "center", false, false, true)
		for i, name in ipairs(defuseOptions) do
			local bw, bh = 160/zoom, 32/zoom
			local bx = sx/2 - w/2 + 30/zoom + ((i-1)%2)*(bw + 40/zoom)
			local by = sy/2 - h/2 + 80/zoom + math.floor((i-1)/2)*(bh + 16/zoom)
			dxDrawRectangle(bx, by, bw, bh, tocolor(30,30,30,220), true)
			dxDrawText(name:upper(), bx, by, bx+bw, by+bh, tocolor(255,255,255,255), 1, "default-bold", "center", "center", false, false, true)
		end
		dxDrawText("Tiempo restante: "..math.floor(defuseTimeLeft).."s", sx/2 - w/2, sy/2 + h/2 - 35/zoom, sx/2 + w/2, sy/2 + h/2 - 8/zoom, tocolor(255,200,200,255), 1, "default", "center", "center", false, false, true)
	end
end)

-- Excepción local al recurso anti-explosiones: permitimos las de carrobomba
addEvent("carbomb:exploded", true)
addEventHandler("carbomb:exploded", root, function(x, y, z)
    -- Solo una marca visual para que recursos que revisen flags puedan saltarse el cancelEvent
    -- No hacemos nada más aquí; el recurso 'explosiones' debe ignorar este flag.
end)

-- Consulta precisa de Z de suelo (cliente) y respuesta al servidor
addEvent("carbomb:queryGround", true)
addEventHandler("carbomb:queryGround", root, function(x, y, zHint)
    local sampleZ = (zHint and (zHint + 5)) or 2000
    local gz = getGroundPosition(x, y, sampleZ)
    -- Si el cálculo entrega un Z muy bajo (por debajo del ped), subimos 0.2
    if gz then gz = gz + 0.2 end
    triggerServerEvent("carbomb:setGroundZ", localPlayer, x, y, gz or select(3, getElementPosition(localPlayer)))
end)

local function closeDefuse()
	isDefuseUIOpen = false
	showCursor(false)
	defuseOptions = {}
	defuseTimeLeft = 0
end

addEvent("carbomb:openDefuseUI", true)
addEventHandler("carbomb:openDefuseUI", root, function(payload)
	defuseOptions = payload.options or {"rojo","azul","verde","amarillo"}
	defuseTimeLeft = tonumber(payload.timeLeft or 30)
	isDefuseUIOpen = true
	showCursor(true)
	playSoundFrontEnd(48)
	setTimer(function()
		if isDefuseUIOpen then
			closeDefuse()
		end
	end, math.max(1000, defuseTimeLeft*1000), 1)
end)

addEventHandler("onClientClick", root, function(btn, state, cx, cy)
	if not isDefuseUIOpen or btn ~= "left" or state ~= "down" then return end
	local w, h = 420/zoom, 220/zoom
	local baseX, baseY = sx/2 - w/2, sy/2 - h/2
	for i, name in ipairs(defuseOptions) do
		local bw, bh = 160/zoom, 32/zoom
		local bx = baseX + 30/zoom + ((i-1)%2)*(bw + 40/zoom)
		local by = baseY + 80/zoom + math.floor((i-1)/2)*(bh + 16/zoom)
		if cx >= bx and cx <= bx + bw and cy >= by and cy <= by + bh then
			triggerServerEvent("carbomb:defuseChoice", localPlayer, name)
			closeDefuse()
			break
		end
	end
end)
