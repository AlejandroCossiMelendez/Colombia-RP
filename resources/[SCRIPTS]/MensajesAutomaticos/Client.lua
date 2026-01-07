-- luacheck: globals outputChatBox root addCommandHandler addEventHandler resourceRoot killTimer setTimer isTimer getTickCount
-- Configuración profesional de anuncios automáticos (cliente)
local CONFIG = {
	serverName = "La Capital RP",
	owners = { "Owner Cordero", "Owner Ecudev" },
	color = {
		primary = "#00FFEC", -- Color principal (marca)
		text = "#FFFFFF",    -- Color de texto base
		accent = "#FFD700"   -- Acento (por ejemplo, para la palabra VIP)
	},
	-- Intervalo aleatorio entre anuncios (en milisegundos)
	intervalMs = { min = 180000, max = 300000 }, -- 3 a 5 minutos
	rescheduleWhenChatHiddenAfterMs = 60000 -- reintento a 60s si el chat está oculto
}

-- Plantillas de mensajes (usa {SERVER} y {OWNER})
local MESSAGE_TEMPLATES = {
	"{SERVER} #FFFFFF| Para adquirir #FFD700 VIP #FFFFFF, contacta con {OWNER}.",
	"{SERVER} #FFFFFF| Beneficios #FFD700 VIP #FFFFFF al instante. Escríbele a {OWNER}.",
	"{SERVER} #FFFFFF| ¿Buscas mejorar tu experiencia? Pide tu #FFD700 VIP #FFFFFF con {OWNER}.",
	"{SERVER} #FFFFFF| Soporte y compras #FFD700 VIP #FFFFFF disponibles con {OWNER}.",
	"{SERVER} #FFFFFF| Activa tu #FFD700 VIP #FFFFFF ahora mismo. Atención directa con {OWNER}."
}

-- Estado interno
local lastTemplateIndex = nil
local anunciosHabilitados = true
local timerHandle = nil

local function getRandomOwner()
	return CONFIG.owners[math.random(1, #CONFIG.owners)]
end

local function getRandomTemplateIndex()
	if #MESSAGE_TEMPLATES == 1 then
		return 1
	end
	local idx = math.random(1, #MESSAGE_TEMPLATES)
	if lastTemplateIndex and #MESSAGE_TEMPLATES > 1 then
		-- evita repetición inmediata
		while idx == lastTemplateIndex do
			idx = math.random(1, #MESSAGE_TEMPLATES)
		end
	end
	lastTemplateIndex = idx
	return idx
end

local function expandTemplate(templateStr, ownerName)
	local c = CONFIG.color
	local serverColored = c.primary .. CONFIG.serverName .. c.text
	local ownerColored = c.primary .. ownerName .. c.text
	local rendered = templateStr
	rendered = rendered:gsub("{SERVER}", serverColored)
	rendered = rendered:gsub("{OWNER}", ownerColored)
	return rendered
end

local function scheduleNext(delayMs)
	if timerHandle and isTimer(timerHandle) then
		killTimer(timerHandle)
	end
	local minMs, maxMs = CONFIG.intervalMs.min, CONFIG.intervalMs.max
	local delay = delayMs or math.random(minMs, maxMs)
	timerHandle = setTimer(function()
		if not anunciosHabilitados then
			-- si está deshabilitado, vuelve a intentar más tarde para no perder el ritmo
			scheduleNext()
			return
		end
		local owner = getRandomOwner()
		local idx = getRandomTemplateIndex()
		local message = expandTemplate(MESSAGE_TEMPLATES[idx], owner)
		outputChatBox(message, root, 255, 255, 255, true)
		-- programa el siguiente
		scheduleNext()
	end, delay, 1)
end

-- Comando local para activar/desactivar anuncios: /anuncios
addCommandHandler("sisabe", function()
	anunciosHabilitados = not anunciosHabilitados
	local c = CONFIG.color
	local estado = anunciosHabilitados and (c.primary .. "activados" .. c.text) or (c.primary .. "desactivados" .. c.text)
	outputChatBox(c.primary .. "Anuncios" .. c.text .. " | Estado: " .. estado .. ".", root, 255, 255, 255, true)
	if anunciosHabilitados then
		scheduleNext(5000) -- muestra uno pronto al reactivar
	end
end)

-- Inicialización al iniciar el recurso (servidor)
addEventHandler("onResourceStart", resourceRoot, function()
	math.randomseed(getTickCount())
	scheduleNext()
end)