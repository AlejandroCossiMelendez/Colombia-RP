local max = math.max
local min = math.min
local ceil = math.ceil
local floor = math.floor

local padding = floor(screen_scale * 10)
local stroke = ceil(screen_scale * 2)
local offset = padding / 2

local stripe_thickness = ceil(screen_scale * 4)

local function getPaletteColors()
	local palette = settings and settings.ui_palette
	if type(palette) ~= "table" or not palette[1] then
		return { { settings.ui_color[1], settings.ui_color[2], settings.ui_color[3] } }
	end
	return palette
end

local function getAccentColor()
	local palette = getPaletteColors()
	if not settings.ui_tricolor_cycle or #palette == 1 then
		local c = palette[1]
		return c[1], c[2], c[3]
	end
	local t = getTickCount()
	local speed = settings.ui_tricolor_speed or 1200
	local idx = (floor(t / speed) % #palette) + 1
	local next_idx = (idx % #palette) + 1
	local progress = (t % speed) / speed
	local function lerp(a, b, p)
		return a + (b - a) * p
	end
	local r = floor(lerp(palette[idx][1], palette[next_idx][1], progress) + 0.5)
	local g = floor(lerp(palette[idx][2], palette[next_idx][2], progress) + 0.5)
	local b = floor(lerp(palette[idx][3], palette[next_idx][3], progress) + 0.5)
	return r, g, b
end

local function drawTricolorStripe(x, y, width, thickness, alpha)
	local palette = getPaletteColors()
	if #palette < 3 then
		return
	end
	local t = thickness or stripe_thickness
	local a = alpha or (220 * ui_progress)
	local w1 = floor(width / 3)
	local w2 = floor(width / 3)
	local w3 = width - (w1 + w2)
	dxDrawRectangle(x, y, w1, t, tocolor(palette[1][1], palette[1][2], palette[1][3], a))
	dxDrawRectangle(x + w1, y, w2, t, tocolor(palette[2][1], palette[2][2], palette[2][3], a))
	dxDrawRectangle(x + w1 + w2, y, w3, t, tocolor(palette[3][1], palette[3][2], palette[3][3], a))
end

--- @type table<string, number>
local rounded_corners = {
	window = floor(screen_scale * 12),
	cards = floor(screen_scale * 6),
	button = floor(screen_scale * 6),
}

--- @type table<string, dx-font>
local fonts = {
	medium = dxCreateFont("Roboto-Medium", ceil(screen_scale * 12), false, "cleartype_natural"),
	regular = dxCreateFont("Roboto-Regular", ceil(screen_scale * 10), false, "cleartype_natural"),
}

-- (moved al final del archivo para capturar las referencias locales correctas)

--- @type table<string, number>
local fonts_height = {
	medium = dxGetFontHeight(1, fonts.medium),
	regular = dxGetFontHeight(1, fonts.regular),
}

--- @type table<string, dx-texture>
local textures = {
	inventory = dxCreateTexture("inventory", "argb", true, "clamp"),
	logo = dxCreateTexture("logo", "argb", true, "clamp"),
	target_inventory = dxCreateTexture("target_inventory", "argb", true, "clamp"),
}

-- Declaración anticipada para mantener la misma referencia local en todo el archivo
local inventory_ui

-- Helpers de mapeo y firma de items (corrigen el uso de slots reales sobre la lista agrupada)
local function normalizeValueByItem(itemId, value)
    local ok, norm = pcall(function()
        return exports["items"]:normalizeValue(itemId, value)
    end)
    if ok and norm ~= nil then return norm end
    if itemId == 29 or itemId == 43 then
        return tonumber(value)
    end
    return value
end

local function getItemDisplayName(data)
    if not data then return "este objeto" end
    if data.item == 27 then
        local ok, name = pcall(function() return exports["muebles"]:getNombreMueble(data.value) end)
        if ok and name and tostring(name) ~= "" then return name end
    end
    if data.name and tostring(data.name) ~= "" then return data.name end
    local ok2, base = pcall(function() return exports["items"]:getName(data.item) end)
    if ok2 and base and tostring(base) ~= "" then return base end
    return "este objeto"
end

local function buildItemSignature(data)
	if not data then return "" end
	return tostring(data.item)
		.. "|" .. tostring(normalizeValueByItem(data.item, data.value))
		.. "|" .. tostring(data.name or "")
		.. "|" .. tostring(data.value2 or "")
end

local function findRawPlayerSlot(data)
	if not data then return false end
	local raw = exports["items"]:get(localPlayer) or {}
	local itemId = data.item
	local valueNorm = normalizeValueByItem(itemId, data.value)
	for i = #raw, 1, -1 do
		local it = raw[i]
		if it and it.item == itemId then
			local itValue = normalizeValueByItem(it.item, it.value)
			if itValue == valueNorm then
				return i
			end
		end
	end
	return false
end

local function isItemImportant(data)
	local important = settings and settings.important_item_ids
	if type(important) ~= "table" then return false end
	for _, id in ipairs(important) do
		if id == data.item then return true end
	end
	return false
end

local function findGroupedIndex(tbl, data)
	if type(tbl) ~= "table" or not data then return false end
	local itemId = data.item
	local valueNorm = normalizeValueByItem(itemId, data.value)
	for i = 1, #tbl do
		local it = tbl[i]
		if it and it.item == itemId then
			local itValue = normalizeValueByItem(it.item, it.value)
			if itValue == valueNorm then return i end
		end
	end
	return false
end

local ui_visible = false
local ui_progress = 0
local ui_tick = 0

local player_items = {}
local player_items_count = 0
local player_max_items = 100

local target_items = {}
local target_items_count = 0
local target_max_items = 100
local target_raw_items = {}

local TARGET_ELEMENT = false
local IS_MALETERO = false
local IS_MOCHILA = false

local cursor = {
	x = 0,
	y = 0,
	entered = false,
	clicked = false,
}

-- Tooltip simple
local current_tooltip = { text = "", visible = false }
local function setTooltip(text)
	current_tooltip.text = text or ""
	current_tooltip.visible = text and text ~= ""
end

-- Menú contextual
local context_menu = { visible = false, show = function() end, hide = function() end, render = function() end, onClick = function() return false end }

-- Estado de arrastre
local drag_state = {
	active = false,
	source = nil, -- "player" | "target"
	data = nil,
	image = nil,
	start_x = 0,
	start_y = 0,
	start_tick = 0,
}

local function pointInRect(px, py, x, y, w, h)
	return px >= x and py >= y and px <= x + w and py <= y + h
end

local function getAbsRect(el)
	local x, y, w, h = el.x or 0, el.y or 0, el.width or 0, el.height or 0
	local parent = el.parent
	while parent do
		x = x + (parent.x or 0)
		y = y + (parent.y or 0)
		parent = parent.parent
	end
	-- Sumar posición base del root
	x = x + inventory_ui.x
	y = y + inventory_ui.y
	return x, y, w, h
end

-- Diálogo de confirmación
confirm_dialog = {
	visible = false,
	message = "",
	on_accept = nil,
	on_cancel = nil,
	show = function(self, msg, on_accept, on_cancel)
		self.visible = true
		self.message = msg or "¿Confirmar?"
		self.on_accept = on_accept
		self.on_cancel = on_cancel
	end,
	hide = function(self)
		self.visible = false
		self.message = ""
		self.on_accept = nil
		self.on_cancel = nil
	end,
	render = function(self)
		if not self.visible then return end
		dxDrawRectangle(0, 0, screen_width, screen_height, tocolor(0,0,0, 160 * ui_progress))
		local w = floor(screen_scale * 420)
		local h = floor(screen_scale * 140)
		local x = floor(screen_width / 2 - w / 2)
		local y = floor(screen_height / 2 - h / 2)
		dxDrawRoundedRectangle(x, y, w, h, { 30,30,30, 255 * ui_progress }, { rounded_corners.window, rounded_corners.window, rounded_corners.window, rounded_corners.window })
		dxDrawText(self.message, x + padding, y + padding, x + w - padding, y + h - padding, tocolor(255,255,255, 255 * ui_progress), 1, fonts.medium, "center", "center", true)
		dxDrawText("Enter = Sí | Esc = No", x + padding, y + h - padding * 2, x + w - padding, y + h - padding, tocolor(200,200,200, 255 * ui_progress), 1, fonts.regular, "center", "bottom", true)
	end,
}

-- Diálogo de cantidad
quantity_dialog = {
	visible = false,
	message = "¿Cantidad a soltar?",
	amount = 1,
	max = 1,
	on_confirm = nil,
	show = function(self, maxAmount, on_confirm)
		self.visible = true
		self.max = max(1, tonumber(maxAmount) or 1)
		self.amount = min(self.max, self.amount)
		self.on_confirm = on_confirm
	end,
	hide = function(self)
		self.visible = false
		self.on_confirm = nil
	end,
	append_digit = function(self, ch)
		local n = tonumber(tostring(self.amount) .. tostring(ch)) or self.amount
		if n < 1 then n = 1 end
		if n > self.max then n = self.max end
		self.amount = n
	end,
	backspace = function(self)
		local s = tostring(self.amount)
		s = s:sub(1, -2)
		local n = tonumber(s) or 0
		if n < 1 then n = 1 end
		self.amount = min(n, self.max)
	end,
	render = function(self)
		if not self.visible then return end
		dxDrawRectangle(0, 0, screen_width, screen_height, tocolor(0,0,0, 160 * ui_progress))
		local w = floor(screen_scale * 420)
		local h = floor(screen_scale * 160)
		local x = floor(screen_width / 2 - w / 2)
		local y = floor(screen_height / 2 - h / 2)
		dxDrawRoundedRectangle(x, y, w, h, { 30,30,30, 255 * ui_progress }, { rounded_corners.window, rounded_corners.window, rounded_corners.window, rounded_corners.window })
		dxDrawText(self.message .. " (max " .. tostring(self.max) .. ")", x + padding, y + padding, x + w - padding, y + padding + fonts_height.medium, tocolor(255,255,255, 255 * ui_progress), 1, fonts.medium, "center", "top", true)
		local ibw, ibh = w - padding * 2, floor(screen_scale * 48)
		local ibx, iby = x + padding, y + h/2 - ibh/2
		dxDrawRoundedRectangle(ibx, iby, ibw, ibh, { 50,50,50, 255 * ui_progress }, { rounded_corners.button, rounded_corners.button, rounded_corners.button, rounded_corners.button }, true)
		dxDrawText(tostring(self.amount), ibx, iby, ibx + ibw, iby + ibh, tocolor(255,255,255, 255 * ui_progress), 1, fonts.medium, "center", "center", true)
		dxDrawText("Enter = Confirmar | Esc = Cancelar | 0-9 / Retroceso", x + padding, y + h - padding*2, x + w - padding, y + h - padding, tocolor(200,200,200, 255 * ui_progress), 1, fonts.regular, "center", "bottom", true)
	end,
}

inventory_ui = {
	x = 0,
	y = 0,
	width = floor(screen_width - floor(screen_scale * 200)),
	height = floor(screen_height - floor(screen_scale * 444)),
	children = {},
	draw = function(self, x, y)
		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 15, 15, 15, 120 * ui_progress },
			{ rounded_corners.window, rounded_corners.window, rounded_corners.window, rounded_corners.window },
			false
		)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
		for _, child in ipairs(self.children) do
			child:render(x, y)
		end
	end,
}

inventory_ui.x, inventory_ui.y =
	floor(screen_width / 2 - inventory_ui.width / 2), floor(screen_height / 2 - inventory_ui.height / 2)

inventory_ui.button_content = {
	selected = false,
	x = 0,
	y = 0,
	width = floor(screen_scale * 250),
	height = floor(screen_scale * 260),
	children = {},
	draw = function(self, x, y)
		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 50, 50, 50, 255 * ui_progress },
			{ rounded_corners.window, rounded_corners.window, rounded_corners.window, rounded_corners.window },
			true
		)

		-- Franja tricolor superior del panel de acciones
		drawTricolorStripe(x, y, self.width, ceil(screen_scale * 3), 200 * ui_progress)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
		for _, child in ipairs(self.children) do
			child:render(x, y)
		end
	end,
}

inventory_ui.button_content.x, inventory_ui.button_content.y =
	(inventory_ui.width - inventory_ui.button_content.width) / 2,
	(inventory_ui.height - inventory_ui.button_content.height) / 2
table.insert(inventory_ui.children, inventory_ui.button_content)

inventory_ui.input = {
	x = 0,
	y = 0,
	width = inventory_ui.button_content.width - rounded_corners.window * 2,
	height = floor(screen_scale * 50),
	parent = inventory_ui.button_content,
	progress = 0,
	tick = 0,
	text = "",
    placeholder = "Nombre o ID del jugador",
	write_tick = 0,
	cursor_click = function(self, button, pressed)
		if button ~= "left" then
			return
		end
		if pressed == "down" then
			local previous_selected = self.parent.selected
			self.parent.selected = self
			self.parent.selected.tick = getTickCount()
			if previous_selected and previous_selected ~= self then
				previous_selected.tick = getTickCount()
			end
		end
	end,
	cursor_enter = function(self)
		self.hovered = true
		self.tick = getTickCount()
	end,
	cursor_leave = function(self)
		self.hovered = false
		self.tick = getTickCount()
	end,
    update_text = function(self, character)
        self.text = self.text .. character
        self.write_tick = getTickCount()
    end,
	draw = function(self, x, y)
		local current_tick = getTickCount()
		if self.parent.selected == self then
			self.progress =
				interpolateBetween(self.progress, 0, 0, 0.5, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		elseif self.hovered then
			self.progress =
				interpolateBetween(self.progress, 0, 0, 0.75, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		else
			self.progress =
				interpolateBetween(self.progress, 0, 0, 1, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		end

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 35, 35, 35, 200 * (ui_progress * self.progress) },
			{ rounded_corners.button, rounded_corners.button, rounded_corners.button, rounded_corners.button }
		)

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 50, 50, 50, 255 * ui_progress },
			{ rounded_corners.button, rounded_corners.button, rounded_corners.button, rounded_corners.button },
			true
		)

		dxDrawText(
			self.text == "" and self.placeholder or self.text,
			x + rounded_corners.window,
			y,
			x + self.width - rounded_corners.window,
			y + self.height,
			tocolor(255, 255, 255, 255 * ui_progress),
			1,
			fonts.regular,
			"center",
			"center",
			true
		)

		if self.parent.selected == self and self.text ~= "" then
			local width = dxGetTextWidth(self.text, 1, fonts.regular)
			local caret_width = 1
			local caret_height = fonts_height.regular
			local caret_x = x + ((self.width - width) / 2) + width
			local caret_y = y + (self.height - caret_height) / 2
			if caret_x > x + self.width - rounded_corners.window then
				caret_x = x + self.width - rounded_corners.window
			end
			dxDrawRectangle(caret_x, caret_y, caret_width, caret_height, tocolor(255, 255, 255, 255 * ui_progress))
			local elapsed = current_tick - self.write_tick
			if elapsed > 80 or getKeyState("lshift") and elapsed > 20 then
				if getKeyState("backspace") then
					self.text = self.text:sub(1, -2)
					self.write_tick = getTickCount()
				end
			end
		end
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
	end,
}

inventory_ui.input.x, inventory_ui.input.y = rounded_corners.window, rounded_corners.window
table.insert(inventory_ui.button_content.children, inventory_ui.input)

inventory_ui.send_button = {
	x = 0,
	y = 0,
	width = inventory_ui.input.width,
	height = inventory_ui.input.height,
	parent = inventory_ui.button_content,
	progress = 0,
	tick = 0,
	last_tick = 0,
	cursor_click = function(self, button, pressed)
		if button ~= "left" then
			return
		end
		if pressed == "down" then
			local previous_selected = self.parent.selected
			self.parent.selected = self
			self.parent.selected.tick = getTickCount()
			if previous_selected and previous_selected ~= self then
				previous_selected.tick = getTickCount()
			end
		elseif pressed == "up" then
			if self.parent.selected == self then
				self.parent.selected.tick = getTickCount()
				self.parent.selected = false
				if self.callback then
					self:callback()
				end
			end
		end
	end,
	cursor_enter = function(self)
		self.hovered = true
		self.tick = getTickCount()
	end,
	cursor_leave = function(self)
		self.hovered = false
		self.tick = getTickCount()
	end,
	callback = function(self)
		local selected = inventory_ui.player_content.selected
		if not selected then
			exports["mrp_notify"]:AddNotify("Inventario", "Selecciona un item para enviarlo", "error")
			return
		end
		local input_text = inventory_ui.input.text
		if not input_text or input_text == "" then
			exports["mrp_notify"]:AddNotify("Inventario", "Introduce un nombre o ID para enviar el item", "error")
			return
		end
		if self.last_tick and getTickCount() - self.last_tick < 1000 then
			exports["mrp_notify"]:AddNotify("Inventario", "Espera un momento para enviar otro item", "error")
			return
		end
		self.last_tick = getTickCount()
		local slot = findRawPlayerSlot(selected.data)
		triggerServerEvent("inventory->send", resourceRoot, slot, input_text)
	end,
	draw = function(self, x, y)
		local current_tick = getTickCount()
		if self.parent.selected == self then
			self.progress =
				interpolateBetween(self.progress, 0, 0, 0.5, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		elseif self.hovered then
			self.progress =
				interpolateBetween(self.progress, 0, 0, 0.75, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		else
			self.progress =
				interpolateBetween(self.progress, 0, 0, 1, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		end

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ settings.ui_color[1], settings.ui_color[2], settings.ui_color[3], 200 * (ui_progress * self.progress) },
			{ rounded_corners.button, rounded_corners.button, rounded_corners.button, rounded_corners.button }
		)

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 50, 50, 50, 255 * ui_progress },
			{ rounded_corners.button, rounded_corners.button, rounded_corners.button, rounded_corners.button },
			true
		)

		dxDrawText(
			"Enviar",
			x + rounded_corners.window,
			y,
			x + self.width - rounded_corners.window,
			y + self.height,
			tocolor(255, 255, 255, 255 * ui_progress),
			1,
			fonts.regular,
			"center",
			"center",
			true
		)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
	end,
}

inventory_ui.send_button.x, inventory_ui.send_button.y =
	rounded_corners.window, inventory_ui.input.y + inventory_ui.input.height + rounded_corners.window
table.insert(inventory_ui.button_content.children, inventory_ui.send_button)

inventory_ui.use_button = {
	x = 0,
	y = 0,
	width = inventory_ui.input.width,
	height = inventory_ui.input.height,
	parent = inventory_ui.button_content,
	progress = 0,
	tick = 0,
	last_tick = 0,
	cursor_click = function(self, button, pressed)
		if button ~= "left" then
			return
		end
		if pressed == "down" then
			local previous_selected = self.parent.selected
			self.parent.selected = self
			self.parent.selected.tick = getTickCount()
			if previous_selected and previous_selected ~= self then
				previous_selected.tick = getTickCount()
			end
		elseif pressed == "up" then
			if self.parent.selected == self then
				self.parent.selected.tick = getTickCount()
				self.parent.selected = false
				if self.callback then
					self:callback()
				end
			end
		end
	end,
	cursor_enter = function(self)
		self.hovered = true
		self.tick = getTickCount()
	end,
	cursor_leave = function(self)
		self.hovered = false
		self.tick = getTickCount()
	end,
	callback = function(self)
		local selected = inventory_ui.player_content.selected
		if not selected then
			exports["mrp_notify"]:AddNotify("Inventario", "Selecciona un item para usarlo", "error")
			return
		end
		if self.last_tick and getTickCount() - self.last_tick < 1000 then
			exports["mrp_notify"]:AddNotify("Inventario", "Espera un momento para usar otro item", "error")
			return
		end
		self.last_tick = getTickCount()
		local slot = findRawPlayerSlot(selected.data)
		triggerServerEvent("items:use", localPlayer, slot)
		setTimer(UpdatePlayerItems, 100, 1)
	end,
	draw = function(self, x, y)
		local current_tick = getTickCount()
		if self.parent.selected == self then
			self.progress =
				interpolateBetween(self.progress, 0, 0, 0.5, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		elseif self.hovered then
			self.progress =
				interpolateBetween(self.progress, 0, 0, 0.75, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		else
			self.progress =
				interpolateBetween(self.progress, 0, 0, 1, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		end

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ settings.ui_color[1], settings.ui_color[2], settings.ui_color[3], 200 * (ui_progress * self.progress) },
			{ rounded_corners.button, rounded_corners.button, rounded_corners.button, rounded_corners.button }
		)

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 50, 50, 50, 255 * ui_progress },
			{ rounded_corners.button, rounded_corners.button, rounded_corners.button, rounded_corners.button },
			true
		)

		dxDrawText(
			"Usar",
			x + rounded_corners.window,
			y,
			x + self.width - rounded_corners.window,
			y + self.height,
			tocolor(255, 255, 255, 255 * ui_progress),
			1,
			fonts.regular,
			"center",
			"center",
			true
		)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
	end,
}

inventory_ui.use_button.x, inventory_ui.use_button.y =
	rounded_corners.window, inventory_ui.send_button.y + inventory_ui.send_button.height + rounded_corners.window
table.insert(inventory_ui.button_content.children, inventory_ui.use_button)

inventory_ui.drop_button = {
	x = 0,
	y = 0,
	width = inventory_ui.input.width,
	height = inventory_ui.input.height,
	parent = inventory_ui.button_content,
	progress = 0,
	tick = 0,
	last_tick = 0,
	cursor_click = function(self, button, pressed)
		if button ~= "left" then
			return
		end
		if pressed == "down" then
			local previous_selected = self.parent.selected
			self.parent.selected = self
			self.parent.selected.tick = getTickCount()
			if previous_selected and previous_selected ~= self then
				previous_selected.tick = getTickCount()
			end
		elseif pressed == "up" then
			if self.parent.selected == self then
				self.parent.selected.tick = getTickCount()
				self.parent.selected = false
				if self.callback then
					self:callback()
				end
			end
		end
	end,
	cursor_enter = function(self)
		self.hovered = true
		self.tick = getTickCount()
	end,
	cursor_leave = function(self)
		self.hovered = false
		self.tick = getTickCount()
	end,
	callback = function(self)
		local selected = inventory_ui.player_content.selected
		if not selected then
			exports["mrp_notify"]:AddNotify("Inventario", "Selecciona un item para soltarlo", "error")
			return
		end
		if self.last_tick and getTickCount() - self.last_tick < 1000 then
			exports["mrp_notify"]:AddNotify("Inventario", "Espera un momento para soltar otro item", "error")
			return
		end
		self.last_tick = getTickCount()
        local quantity = selected.data.quantity or 1
        local function doDrop(amount)
			local slot = findRawPlayerSlot(selected.data)
			triggerServerEvent(amount and amount > 1 and "inventory->drop_quantity" or "inventory->drop", resourceRoot, slot, amount)
		end
		local function askOrDrop()
			if quantity > 1 then
				quantity_dialog:show(quantity, function(amount)
					doDrop(amount)
				end)
			else
				doDrop(1)
			end
		end
        if isItemImportant(selected.data) then
            local name = getItemDisplayName(selected.data)
            confirm_dialog:show("¿Seguro que quieres soltar '" .. tostring(name) .. "'?", askOrDrop)
		else
			askOrDrop()
		end
	end,
	draw = function(self, x, y)
		local current_tick = getTickCount()
		if self.parent.selected == self then
			self.progress =
				interpolateBetween(self.progress, 0, 0, 0.5, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		elseif self.hovered then
			self.progress =
				interpolateBetween(self.progress, 0, 0, 0.75, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		else
			self.progress =
				interpolateBetween(self.progress, 0, 0, 1, 0, 0, min(1, (current_tick - self.tick) / 500), "Linear")
		end

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ settings.ui_color[1], settings.ui_color[2], settings.ui_color[3], 200 * (ui_progress * self.progress) },
			{ rounded_corners.button, rounded_corners.button, rounded_corners.button, rounded_corners.button }
		)

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 50, 50, 50, 255 * ui_progress },
			{ rounded_corners.button, rounded_corners.button, rounded_corners.button, rounded_corners.button },
			true
		)

		dxDrawText(
			"Soltar",
			x + rounded_corners.window,
			y,
			x + self.width - rounded_corners.window,
			y + self.height,
			tocolor(255, 255, 255, 255 * ui_progress),
			1,
			fonts.regular,
			"center",
			"center",
			true
		)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
	end,
}

inventory_ui.drop_button.x, inventory_ui.drop_button.y =
	rounded_corners.window, inventory_ui.use_button.y + inventory_ui.use_button.height + rounded_corners.window
table.insert(inventory_ui.button_content.children, inventory_ui.drop_button)

inventory_ui.player_background = {
	x = 0,
	y = 0,
	width = (inventory_ui.width - inventory_ui.button_content.width) / 2 - rounded_corners.window * 2,
	height = inventory_ui.height,
	children = {},
	draw = function(self, x, y)
		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 50, 50, 50, 255 * ui_progress },
			{ rounded_corners.window, rounded_corners.window, rounded_corners.window, rounded_corners.window },
			true
		)
		-- Borde de acento suave
		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ settings.ui_color[1], settings.ui_color[2], settings.ui_color[3], 60 * ui_progress },
			{ rounded_corners.window, rounded_corners.window, rounded_corners.window, rounded_corners.window },
			true
		)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
		for _, child in ipairs(self.children) do
			child:render(x, y)
		end
	end,
}

table.insert(inventory_ui.children, inventory_ui.player_background)

inventory_ui.player_content_header = {
	x = 0,
	y = 0,
	width = inventory_ui.player_background.width,
	height = floor(screen_scale * 65),
	icon_size = floor(screen_scale * 25),
	children = {},
	draw = function(self, x, y)
		dxDrawImage(
			x + rounded_corners.window,
			y + rounded_corners.window,
			self.icon_size,
			self.icon_size,
			textures.inventory,
			0,
			0,
			0,
			tocolor(settings.ui_color[1], settings.ui_color[2], settings.ui_color[3], 255 * ui_progress)
		)

		dxDrawText(
			"Inventario personal",
			x + self.icon_size + rounded_corners.window * 2,
			y + rounded_corners.window,
			x + self.width,
			y + self.height,
			tocolor(255, 255, 255, 255 * ui_progress),
			1,
			fonts.medium,
			"left",
			"top",
			true
		)

		local text_width = dxGetTextWidth(player_items_count .. " / " .. player_max_items, 1, fonts.medium)

		dxDrawText(
			player_items_count .. " / " .. player_max_items,
			x,
			y + rounded_corners.window,
			x + self.width - rounded_corners.window,
			y + self.height,
			tocolor(255, 255, 255, 255 * ui_progress),
			1,
			fonts.regular,
			"right",
			"top",
			true
		)

		-- Franja tricolor en el encabezado
		drawTricolorStripe(x, y, self.width, ceil(screen_scale * 3), 220 * ui_progress)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
		for _, child in ipairs(self.children) do
			child:render(x, y)
		end
	end,
}

table.insert(inventory_ui.player_background.children, inventory_ui.player_content_header)

inventory_ui.player_content_progress = {
	x = 0,
	y = 0,
	width = inventory_ui.player_content_header.width - rounded_corners.window * 2,
	height = padding,
	draw = function(self, x, y)
		local progress = max(0, min(1, (player_items_count / player_max_items)))
		local filled = floor(self.width * progress)
		dxDrawRectangle(x, y, self.width, self.height, tocolor(25, 25, 25, 200 * ui_progress))

		local palette = getPaletteColors()
		if #palette >= 3 then
			local w1 = floor(self.width / 3)
			local w2 = floor(self.width / 3)
			local w3 = self.width - (w1 + w2)
			if filled > 0 then
				local f1 = min(filled, w1)
				if f1 > 0 then
					dxDrawRectangle(x, y, f1, self.height, tocolor(palette[1][1], palette[1][2], palette[1][3], 220 * ui_progress))
				end
				local f2 = min(max(filled - w1, 0), w2)
				if f2 > 0 then
					dxDrawRectangle(x + w1, y, f2, self.height, tocolor(palette[2][1], palette[2][2], palette[2][3], 220 * ui_progress))
				end
				local f3 = min(max(filled - w1 - w2, 0), w3)
				if f3 > 0 then
					dxDrawRectangle(x + w1 + w2, y, f3, self.height, tocolor(palette[3][1], palette[3][2], palette[3][3], 220 * ui_progress))
				end
			end
		else
			dxDrawRectangle(x, y, filled, self.height, tocolor(settings.ui_color[1], settings.ui_color[2], settings.ui_color[3], 200 * ui_progress))
		end
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
	end,
}

inventory_ui.player_content_progress.x, inventory_ui.player_content_progress.y =
	rounded_corners.window,
	inventory_ui.player_content_header.height - inventory_ui.player_content_progress.height - rounded_corners.window
table.insert(inventory_ui.player_content_header.children, inventory_ui.player_content_progress)

inventory_ui.player_content = {
	selected = false,
	scroll_x = 0,
	scroll_y = 0,
	scroll_to = 0,
	scroll_tick = 0,
	x = 0,
	y = 0,
	width = inventory_ui.player_content_header.width - rounded_corners.window * 2,
	height = inventory_ui.height - inventory_ui.player_content_header.height - rounded_corners.window * 2,
	children = {},
	render_target = false,
	render_target_need_update = false,
	draw = function(self, x, y)
		local previous_blend_mode = dxGetBlendMode()
		local render_target = self.render_target
		if not isElement(render_target) then
			return
		end
		dxSetBlendMode("add")
		dxDrawImage(x, y, self.width, self.height, render_target)
		dxSetBlendMode(previous_blend_mode)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		local render_target = self.render_target
		if not isElement(render_target) then
			return
		end
		if self.render_target_need_update then
			self.render_target_need_update = false
			local scroll_x, scroll_y = self.scroll_x, self.scroll_y
			if scroll_y ~= self.scroll_to then
				scroll_y = interpolateBetween(
					self.scroll_to,
					0,
					0,
					scroll_y,
					0,
					0,
					min(1, (getTickCount() - self.scroll_tick) / 200),
					"Linear"
				)
			end
			dxSetRenderTarget(render_target, true)
			local previous_blend_mode = dxGetBlendMode()
			dxSetBlendMode("modulate_add")
			for _, child in ipairs(self.children) do
				if
					child.x + child.width + scroll_x >= 0
					and child.x + scroll_x <= self.width
					and child.y + child.height + scroll_y >= 0
					and child.y + scroll_y <= self.height
				then
					child:render(scroll_x, scroll_y)
				end
			end
			dxSetRenderTarget()
			dxSetBlendMode(previous_blend_mode)
		end
		self:draw(x, y)
	end,
	cursor_scroll = function(self, direction)
		local scroll_y = min(
			0,
			max(self.scroll_y - direction * (self.children[1].height + rounded_corners.window), -self.overflow_y)
		)
		self.scroll_to = self.scroll_y
		self.scroll_y = scroll_y
		self.scroll_tick = getTickCount()
		self.render_target_need_update = true
	end,
}

inventory_ui.player_content.overflow_y = 0
inventory_ui.player_content.x, inventory_ui.player_content.y =
	rounded_corners.window, inventory_ui.player_content_header.height + rounded_corners.window
table.insert(inventory_ui.player_background.children, inventory_ui.player_content)
inventory_ui.player_content.render_target =
	dxCreateRenderTarget(inventory_ui.player_content.width, inventory_ui.player_content.height, true)

inventory_ui.player_exchange_item = {
	visible = false,
	x = 0,
	y = 0,
	width = inventory_ui.player_background.width,
	height = floor(screen_scale * 40),
	progress = 0,
	tick = 0,
	anim_tick = 0,
	anim_progress = 0,
	last_tick = 0,
	cursor_click = function(self, button, pressed)
		if button ~= "left" then
			return
		end
		if pressed == "down" then
			self.selected = true
			self.anim_tick = getTickCount()
		elseif pressed == "up" then
			if self.selected then
				self.selected = false
				self.anim_tick = getTickCount()
				if self.callback then
					self:callback()
				end
			end
		end
	end,
	cursor_enter = function(self)
		self.hovered = true
		self.anim_tick = getTickCount()
	end,
	cursor_leave = function(self)
		self.hovered = false
		self.anim_tick = getTickCount()
	end,
	callback = function(self)
		local selected = inventory_ui.player_content.selected
		if not selected then
			exports["mrp_notify"]:AddNotify("Inventario", "Selecciona un item para moverlo", "error")
			return
		end
		if self.last_tick and getTickCount() - self.last_tick < 1000 then
			exports["mrp_notify"]:AddNotify("Inventario", "Espera un momento para mover otro item", "error")
			return
		end
		self.last_tick = getTickCount()
		local slot = findRawPlayerSlot(selected.data)
		if IS_MALETERO then
			local idveh = getElementData(localPlayer, "mid")
			if selected.data.item == 1 and tonumber(selected.data.value) == tonumber(idveh) then
				exports["mrp_notify"]:AddNotify(
					"Inventario",
					"No puedes guardar la llave del vehículo en el maletero",
					"error"
				)
				return
			end
			triggerServerEvent("items:giveToMaletero", localPlayer, slot)
			setTimer(UpdatePlayerItems, 100, 1)
			setTimer(UpdateMaleteroItems, 100, 1)
		elseif IS_MOCHILA then
			triggerServerEvent("items:giveToMochila", localPlayer, slot)
			setTimer(UpdatePlayerItems, 100, 1)
			setTimer(UpdateMochilaItems, 100, 1)
		else
			triggerServerEvent("inventory->exchange_from_player", resourceRoot, slot, TARGET_ELEMENT)
		end
	end,
	draw = function(self, x, y)
		local current_tick = getTickCount()
		self.progress = interpolateBetween(
			self.visible and 0 or 1,
			0,
			0,
			self.visible and 1 or 0,
			0,
			0,
			min(1, (current_tick - self.tick) / 500),
			"Linear"
		)

		if self.selected then
			self.anim_progress = interpolateBetween(
				self.anim_progress,
				0,
				0,
				0.5,
				0,
				0,
				min(1, (current_tick - self.anim_tick) / 500),
				"Linear"
			)
		elseif self.hovered then
			self.anim_progress = interpolateBetween(
				self.anim_progress,
				0,
				0,
				0.75,
				0,
				0,
				min(1, (current_tick - self.anim_tick) / 500),
				"Linear"
			)
		else
			self.anim_progress = interpolateBetween(
				self.anim_progress,
				0,
				0,
				1,
				0,
				0,
				min(1, (current_tick - self.anim_tick) / 500),
				"Linear"
			)
		end

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 25, 25, 25, 200 * (ui_progress * self.progress * self.anim_progress) },
			{
				rounded_corners.window / 2,
				rounded_corners.window / 2,
				rounded_corners.window / 2,
				rounded_corners.window / 2,
			}
		)

		dxDrawText(
			"Mover item seleccionado >",
			x,
			y,
			x + self.width,
			y + self.height,
			tocolor(255, 255, 255, 255 * (ui_progress * self.progress * self.anim_progress)),
			1,
			fonts.medium,
			"center",
			"center",
			true
		)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
	end,
}

inventory_ui.player_exchange_item.y = inventory_ui.height + padding
table.insert(inventory_ui.player_background.children, inventory_ui.player_exchange_item)

inventory_ui.target_background = {
	visible = false,
	x = 0,
	y = 0,
	width = inventory_ui.player_background.width,
	height = inventory_ui.player_background.height,
	children = {},
	progress = 0,
	tick = 0,
	draw = function(self, x, y)
		local current_tick = getTickCount()
		self.progress = interpolateBetween(
			self.visible and 0 or 1,
			0,
			0,
			self.visible and 1 or 0,
			0,
			0,
			min(1, (current_tick - self.tick) / 500),
			"Linear"
		)

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 50, 50, 50, 255 * (ui_progress * self.progress) },
			{ rounded_corners.window, rounded_corners.window, rounded_corners.window, rounded_corners.window },
			true
		)
		-- Borde de acento suave para el panel objetivo
		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ settings.ui_color[1], settings.ui_color[2], settings.ui_color[3], 60 * (ui_progress * self.progress) },
			{ rounded_corners.window, rounded_corners.window, rounded_corners.window, rounded_corners.window },
			true
		)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
		for _, child in ipairs(self.children) do
			child:render(x, y)
		end
	end,
}

inventory_ui.target_background.x = inventory_ui.width - inventory_ui.target_background.width
table.insert(inventory_ui.children, inventory_ui.target_background)

inventory_ui.target_content_header = {
	x = 0,
	y = 0,
	width = inventory_ui.target_background.width,
	height = inventory_ui.player_content_header.height,
	icon_size = floor(screen_scale * 25),
	children = {},
	draw = function(self, x, y)
		dxDrawImage(
			x + rounded_corners.window,
			y + rounded_corners.window,
			self.icon_size,
			self.icon_size,
			textures.target_inventory,
			0,
			0,
			0,
			tocolor(
				settings.ui_color[1],
				settings.ui_color[2],
				settings.ui_color[3],
				255 * (ui_progress * inventory_ui.target_background.progress)
			)
		)

		dxDrawText(
			IS_MALETERO and "Maletero del Vehiculo" or IS_MOCHILA and "Mochila" or "Inventario de objetivo",
			x + self.icon_size + rounded_corners.window * 2,
			y + rounded_corners.window,
			x + self.width,
			y + self.height,
			tocolor(255, 255, 255, 255 * (ui_progress * inventory_ui.target_background.progress)),
			1,
			fonts.medium,
			"left",
			"top",
			true
		)

		local text_width = dxGetTextWidth(target_items_count .. " / " .. target_max_items, 1, fonts.medium)

		dxDrawText(
			target_items_count .. " / " .. target_max_items,
			x,
			y + rounded_corners.window,
			x + self.width - rounded_corners.window,
			y + self.height,
			tocolor(255, 255, 255, 255 * (ui_progress * inventory_ui.target_background.progress)),
			1,
			fonts.regular,
			"right",
			"top",
			true
		)

		-- Franja tricolor en el encabezado del objetivo
		drawTricolorStripe(
			x,
			y,
			self.width,
			ceil(screen_scale * 3),
			220 * (ui_progress * inventory_ui.target_background.progress)
		)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
		for _, child in ipairs(self.children) do
			child:render(x, y)
		end
	end,
}

table.insert(inventory_ui.target_background.children, inventory_ui.target_content_header)

inventory_ui.target_content_progress = {
	x = 0,
	y = 0,
	width = inventory_ui.target_content_header.width - rounded_corners.window * 2,
	height = padding,
	draw = function(self, x, y)
		local progress = max(0, min(1, (target_items_count / target_max_items)))
		local filled = floor(self.width * progress)
		dxDrawRectangle(
			x,
			y,
			self.width,
			self.height,
			tocolor(25, 25, 25, 200 * (ui_progress * inventory_ui.target_background.progress))
		)

		local palette = getPaletteColors()
		if #palette >= 3 then
			local w1 = floor(self.width / 3)
			local w2 = floor(self.width / 3)
			local w3 = self.width - (w1 + w2)
			if filled > 0 then
				local f1 = min(filled, w1)
				if f1 > 0 then
					dxDrawRectangle(x, y, f1, self.height, tocolor(palette[1][1], palette[1][2], palette[1][3], 220 * (ui_progress * inventory_ui.target_background.progress)))
				end
				local f2 = min(max(filled - w1, 0), w2)
				if f2 > 0 then
					dxDrawRectangle(x + w1, y, f2, self.height, tocolor(palette[2][1], palette[2][2], palette[2][3], 220 * (ui_progress * inventory_ui.target_background.progress)))
				end
				local f3 = min(max(filled - w1 - w2, 0), w3)
				if f3 > 0 then
					dxDrawRectangle(x + w1 + w2, y, f3, self.height, tocolor(palette[3][1], palette[3][2], palette[3][3], 220 * (ui_progress * inventory_ui.target_background.progress)))
				end
			end
		else
			dxDrawRectangle(x, y, filled, self.height, tocolor(settings.ui_color[1], settings.ui_color[2], settings.ui_color[3], 200 * (ui_progress * inventory_ui.target_background.progress)))
		end
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
	end,
}

inventory_ui.target_content_progress.x, inventory_ui.target_content_progress.y =
	rounded_corners.window,
	inventory_ui.target_content_header.height - inventory_ui.target_content_progress.height - rounded_corners.window
table.insert(inventory_ui.target_content_header.children, inventory_ui.target_content_progress)

inventory_ui.target_content = {
	selected = false,
	scroll_x = 0,
	scroll_y = 0,
	scroll_to = 0,
	scroll_tick = 0,
	x = 0,
	y = 0,
	width = inventory_ui.target_content_header.width - rounded_corners.window * 2,
	height = inventory_ui.height - inventory_ui.target_content_header.height - rounded_corners.window * 2,
	children = {},
	render_target = false,
	render_target_need_update = false,
	draw = function(self, x, y)
		local previous_blend_mode = dxGetBlendMode()
		local render_target = self.render_target
		if not isElement(render_target) then
			return
		end
		dxSetBlendMode("add")
		dxDrawImage(x, y, self.width, self.height, render_target)
		dxSetBlendMode(previous_blend_mode)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		local render_target = self.render_target
		if not isElement(render_target) then
			return
		end
		if self.render_target_need_update then
			self.render_target_need_update = false
			local scroll_x, scroll_y = self.scroll_x, self.scroll_y
			if scroll_y ~= self.scroll_to then
				scroll_y = interpolateBetween(
					self.scroll_to,
					0,
					0,
					scroll_y,
					0,
					0,
					min(1, (getTickCount() - self.scroll_tick) / 200),
					"Linear"
				)
			end
			dxSetRenderTarget(render_target, true)
			local previous_blend_mode = dxGetBlendMode()
			dxSetBlendMode("modulate_add")
			for _, child in ipairs(self.children) do
				if
					child.x + child.width + scroll_x >= 0
					and child.x + scroll_x <= self.width
					and child.y + child.height + scroll_y >= 0
					and child.y + scroll_y <= self.height
				then
					child:render(scroll_x, scroll_y)
				end
			end
			dxSetRenderTarget()
			dxSetBlendMode(previous_blend_mode)
		end
		self:draw(x, y)
	end,
	cursor_scroll = function(self, direction)
		local scroll_y = min(
			0,
			max(self.scroll_y - direction * (self.children[1].height + rounded_corners.window), -self.overflow_y)
		)
		self.scroll_to = self.scroll_y
		self.scroll_y = scroll_y
		self.scroll_tick = getTickCount()
		self.render_target_need_update = true
	end,
}

inventory_ui.target_content.overflow_y = 0
inventory_ui.target_content.x, inventory_ui.target_content.y =
	rounded_corners.window, inventory_ui.target_content_header.height + rounded_corners.window
table.insert(inventory_ui.target_background.children, inventory_ui.target_content)
inventory_ui.target_content.render_target =
	dxCreateRenderTarget(inventory_ui.target_content.width, inventory_ui.target_content.height, true)

inventory_ui.target_exchange_item = {
	visible = false,
	x = 0,
	y = 0,
	width = inventory_ui.target_background.width,
	height = floor(screen_scale * 40),
	progress = 0,
	tick = 0,
	anim_tick = 0,
	anim_progress = 0,
	last_tick = 0,
	cursor_click = function(self, button, pressed)
		if button ~= "left" then
			return
		end
		if pressed == "down" then
			self.selected = true
			self.anim_tick = getTickCount()
		elseif pressed == "up" then
			if self.selected then
				self.selected = false
				self.anim_tick = getTickCount()
				if self.callback then
					self:callback()
				end
			end
		end
	end,
	cursor_enter = function(self)
		self.hovered = true
		self.anim_tick = getTickCount()
	end,
	cursor_leave = function(self)
		self.hovered = false
		self.anim_tick = getTickCount()
	end,
	callback = function(self)
		local selected = inventory_ui.target_content.selected
		if not selected then
			exports["mrp_notify"]:AddNotify("Inventario", "Selecciona un item para moverlo", "error")
			return
		end
		if self.last_tick and getTickCount() - self.last_tick < 1000 then
			exports["mrp_notify"]:AddNotify("Inventario", "Espera un momento para mover otro item", "error")
			return
		end
		self.last_tick = getTickCount()
		local function findRawTargetSlot(data)
			if not data then return false end
			local itemId = data.item
			local valueNorm = normalizeValueByItem(itemId, data.value)
			for i = #target_raw_items, 1, -1 do
				local it = target_raw_items[i]
				if it and it.item == itemId then
					local itValue = normalizeValueByItem(it.item, it.value)
					if itValue == valueNorm then
						return i
					end
				end
			end
			return false
		end
		local slot = findRawTargetSlot(selected.data)
		if IS_MALETERO then
			triggerServerEvent("items:getFromMaletero", localPlayer, selected.data.index)
			setTimer(UpdatePlayerItems, 100, 1)
			setTimer(UpdateMaleteroItems, 100, 1)
		elseif IS_MOCHILA then
			triggerServerEvent("items:getFromMochila", localPlayer, selected.data.index)
			setTimer(UpdatePlayerItems, 100, 1)
			setTimer(UpdateMochilaItems, 100, 1)
		else
			triggerServerEvent("inventory->exchange_from_target", resourceRoot, slot, TARGET_ELEMENT)
		end
	end,
	draw = function(self, x, y)
		local current_tick = getTickCount()
		self.progress = interpolateBetween(
			self.visible and 0 or 1,
			0,
			0,
			self.visible and 1 or 0,
			0,
			0,
			min(1, (current_tick - self.tick) / 500),
			"Linear"
		)

		if self.selected then
			self.anim_progress = interpolateBetween(
				self.anim_progress,
				0,
				0,
				0.5,
				0,
				0,
				min(1, (current_tick - self.anim_tick) / 500),
				"Linear"
			)
		elseif self.hovered then
			self.anim_progress = interpolateBetween(
				self.anim_progress,
				0,
				0,
				0.75,
				0,
				0,
				min(1, (current_tick - self.anim_tick) / 500),
				"Linear"
			)
		else
			self.anim_progress = interpolateBetween(
				self.anim_progress,
				0,
				0,
				1,
				0,
				0,
				min(1, (current_tick - self.anim_tick) / 500),
				"Linear"
			)
		end

		dxDrawRoundedRectangle(
			x,
			y,
			self.width,
			self.height,
			{ 25, 25, 25, 200 * (ui_progress * self.progress * self.anim_progress) },
			{
				rounded_corners.window / 2,
				rounded_corners.window / 2,
				rounded_corners.window / 2,
				rounded_corners.window / 2,
			}
		)

		dxDrawText(
			"< Mover item seleccionado",
			x,
			y,
			x + self.width,
			y + self.height,
			tocolor(255, 255, 255, 255 * (ui_progress * self.progress * self.anim_progress)),
			1,
			fonts.medium,
			"center",
			"center",
			true
		)
	end,
	render = function(self, parent_x, parent_y)
		local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
		self:draw(x, y)
	end,
}

inventory_ui.target_exchange_item.y = inventory_ui.height + padding
table.insert(inventory_ui.target_background.children, inventory_ui.target_exchange_item)

local function PlayerItemsGridlist(columns, separation, tbl)
	inventory_ui.player_content.children = {}
	local item_width = (inventory_ui.player_content.width - separation * (columns - 1)) / columns
	local item_height = item_width
	for i, items in ipairs(tbl) do
		local item = {
			x = (i - 1) % columns * (item_width + separation),
			y = floor((i - 1) / columns) * (item_height + separation),
			width = item_width,
			height = item_height,
			parent = inventory_ui.player_content,
			icon_size = item_width - rounded_corners.cards * 12,
			progress = 0,
			tick = 0,
			data = items,
			last_click_tick = 0,
			cursor_click = function(self, button, pressed)
				if button ~= "left" then
					return
				end
				if pressed == "down" then
					if inventory_ui.button_content.selected then
						inventory_ui.button_content.selected.tick = getTickCount()
						inventory_ui.button_content.selected = false
					end
					local previous_selected = inventory_ui.player_content.selected
					inventory_ui.player_content.selected = self
					inventory_ui.player_content.selected.tick = getTickCount()
					if previous_selected and previous_selected ~= self then
						previous_selected.tick = getTickCount()
					end
					-- doble clic
					local now = getTickCount()
					if self.last_click_tick ~= 0 and (now - self.last_click_tick) < 400 then
						local slot = findRawPlayerSlot(self.data)
						if slot then triggerServerEvent("items:use", localPlayer, slot) setTimer(UpdatePlayerItems, 100, 1) end
					end
					self.last_click_tick = now
				end
				inventory_ui.player_content.render_target_need_update = true
			end,
			cursor_enter = function(self)
				self.hovered = true
				self.tick = getTickCount()
				inventory_ui.player_content.render_target_need_update = true
			end,
			cursor_leave = function(self)
				self.hovered = false
				self.tick = getTickCount()
				inventory_ui.player_content.render_target_need_update = true
			end,
			draw = function(self, x, y)
				local current_tick = getTickCount()
				if inventory_ui.player_content.selected == self then
					self.progress = interpolateBetween(
						self.progress,
						0,
						0,
						0.5,
						0,
						0,
						min(1, (current_tick - self.tick) / 500),
						"Linear"
					)
				elseif self.hovered then
					self.progress = interpolateBetween(
						self.progress,
						0,
						0,
						0.75,
						0,
						0,
						min(1, (current_tick - self.tick) / 500),
						"Linear"
					)
				else
					self.progress = interpolateBetween(
						self.progress,
						0,
						0,
						1,
						0,
						0,
						min(1, (current_tick - self.tick) / 500),
						"Linear"
					)
				end

				if self.progress > 0.5 and self.progress < 1 then
					inventory_ui.player_content.render_target_need_update = true
				end

				local new_item = false
				if items and items.item and items.item == 27 then
					new_item = exports["muebles"]:getNombreMueble(items.value)
				else
					if items.name and tostring(items.name) and tostring(items.name) ~= "" then
						new_item = items.name
					else
						new_item = exports["items"]:getName(items.item)
					end
				end
				local image = exports["items"]:getImage(items.item, items.value, new_item)
				if self.hovered then
					setTooltip(new_item)
				end
				local quantity = items.quantity or 0

				dxDrawRectangle(x, y, self.width, self.height, tocolor(25, 25, 25, 200 * (ui_progress * self.progress)))

				dxDrawRectangle(
					x,
					y + self.height - stroke,
					(self.width * 2) * (1 - self.progress),
					stroke,
					tocolor(settings.ui_color[1], settings.ui_color[2], settings.ui_color[3], 255 * ui_progress)
				)

				dxDrawText(
					new_item,
					x + rounded_corners.cards,
					y + rounded_corners.cards,
					x + self.width - rounded_corners.cards,
					y + self.height,
					tocolor(settings.ui_color[1], settings.ui_color[2], settings.ui_color[3], 255 * ui_progress),
					1,
					fonts.regular,
					"center",
					"top",
					true
				)

				if fileExists(image) then
					dxDrawImage(
						x + (self.width - self.icon_size) / 2,
						y + (self.height - self.icon_size) / 2,
						self.icon_size,
						self.icon_size,
						image,
						0,
						0,
						0,
						tocolor(255, 255, 255, 255 * ui_progress)
					)
				end

				dxDrawText(
					quantity .. "x",
					x + rounded_corners.cards,
					y,
					x + self.width,
					y + self.height - rounded_corners.cards,
					tocolor(255, 255, 255, 255 * ui_progress),
					1,
					fonts.regular,
					"left",
					"bottom",
					true
				)

				dxDrawText(
					tostring(items.value),
					x,
					y,
					x + self.width - rounded_corners.cards,
					y + self.height - rounded_corners.cards,
					tocolor(255, 255, 255, 255 * ui_progress),
					1,
					fonts.regular,
					"right",
					"bottom",
					true
				)
			end,
			render = function(self, parent_x, parent_y)
				local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
				self:draw(x, y)
			end,
			cursor_scroll = function(self, direction)
				if not self.parent then
					return
				end
				self.parent:cursor_scroll(direction)
			end,
		}
		table.insert(inventory_ui.player_content.children, item)
	end
	inventory_ui.player_content.overflow_y =
		max(0, (ceil(#tbl / columns) * (item_height + separation)) - (inventory_ui.player_content.height + separation))
end

function UpdatePlayerItems()
	local items = exports["items"]:get(localPlayer) or {}
	local items_table = {}
    local filter = (inventory_ui.input and inventory_ui.input.text or ""):lower()
	for key, value in ipairs(items) do
		if value.item == 29 or value.item == 43 then
			value.value = tonumber(value.value)
		end
        -- nombre para filtro
        local itemName
        if value and value.item == 27 then
            itemName = exports["muebles"]:getNombreMueble(value.value)
        else
            itemName = (value.name and tostring(value.name) ~= "" and value.name) or exports["items"]:getName(value.item)
        end
        local pass = true
        if filter ~= "" then
            pass = (tostring(itemName or ""):lower():find(filter, 1, true) ~= nil)
        end
        if pass then
            local index = table.findItem(items_table, { item = value.item, value = value.value })
            if index then
                items_table[index].quantity = items_table[index].quantity + 1
            else
                local v = value
                v.quantity = 1
                table.insert(items_table, v)
            end
        end
	end
	player_items = items_table
	player_items_count = #items_table
	PlayerItemsGridlist(5, rounded_corners.window, items_table)
	inventory_ui.player_content.render_target_need_update = true
end

local function TargetItemsGridlist(columns, separation, tbl)
	inventory_ui.target_content.children = {}
	local item_width = (inventory_ui.target_content.width - separation * (columns - 1)) / columns
	local item_height = item_width
	for i, items in ipairs(tbl) do
		local item = {
			x = (i - 1) % columns * (item_width + separation),
			y = floor((i - 1) / columns) * (item_height + separation),
			width = item_width,
			height = item_height,
			parent = inventory_ui.target_content,
			icon_size = item_width - rounded_corners.cards * 12,
			progress = 0,
			tick = 0,
			data = items,
			last_click_tick = 0,
			cursor_click = function(self, button, pressed)
				if button ~= "left" then
					return
				end
				if pressed == "down" then
					if inventory_ui.button_content.selected then
						inventory_ui.button_content.selected.tick = getTickCount()
						inventory_ui.button_content.selected = false
					end
					local previous_selected = inventory_ui.target_content.selected
					inventory_ui.target_content.selected = self
					inventory_ui.target_content.selected.tick = getTickCount()
					if previous_selected and previous_selected ~= self then
						previous_selected.tick = getTickCount()
					end
					-- doble clic: tomar del objetivo
					local now = getTickCount()
					if self.last_click_tick ~= 0 and (now - self.last_click_tick) < 400 then
						if IS_MALETERO and self.data and self.data.index then
							triggerServerEvent("items:getFromMaletero", localPlayer, self.data.index)
							setTimer(UpdatePlayerItems, 100, 1)
							setTimer(UpdateMaleteroItems, 100, 1)
						elseif IS_MOCHILA and self.data and self.data.index then
							triggerServerEvent("items:getFromMochila", localPlayer, self.data.index)
							setTimer(UpdatePlayerItems, 100, 1)
							setTimer(UpdateMochilaItems, 100, 1)
						else
							local function findRawTargetSlot(data)
								if not data then return false end
								local itemId = data.item
								local valueNorm = normalizeValueByItem(itemId, data.value)
								for i = #target_raw_items, 1, -1 do
									local it = target_raw_items[i]
									if it and it.item == itemId then
										local itValue = normalizeValueByItem(it.item, it.value)
										if itValue == valueNorm then
											return i
										end
									end
								end
								return false
							end
							local slot = findRawTargetSlot(self.data)
							triggerServerEvent("inventory->exchange_from_target", resourceRoot, slot, TARGET_ELEMENT)
						end
					end
					self.last_click_tick = now
				end
				inventory_ui.target_content.render_target_need_update = true
			end,
			cursor_enter = function(self)
				self.hovered = true
				self.tick = getTickCount()
				inventory_ui.target_content.render_target_need_update = true
			end,
			cursor_leave = function(self)
				self.hovered = false
				self.tick = getTickCount()
				inventory_ui.target_content.render_target_need_update = true
			end,
			draw = function(self, x, y)
				local current_tick = getTickCount()
				if inventory_ui.target_content.selected == self then
					self.progress = interpolateBetween(
						self.progress,
						0,
						0,
						0.5,
						0,
						0,
						min(1, (current_tick - self.tick) / 500),
						"Linear"
					)
				elseif self.hovered then
					self.progress = interpolateBetween(
						self.progress,
						0,
						0,
						0.75,
						0,
						0,
						min(1, (current_tick - self.tick) / 500),
						"Linear"
					)
				else
					self.progress = interpolateBetween(
						self.progress,
						0,
						0,
						1,
						0,
						0,
						min(1, (current_tick - self.tick) / 500),
						"Linear"
					)
				end

				if self.progress > 0.5 and self.progress < 1 then
					inventory_ui.target_content.render_target_need_update = true
				end

				local new_item = false
				if items and items.item and items.item == 27 then
					new_item = exports["muebles"]:getNombreMueble(items.value)
				else
					if items.name and tostring(items.name) and tostring(items.name) ~= "" then
						new_item = items.name
					else
						new_item = exports["items"]:getName(items.item)
					end
				end
				local image = exports["items"]:getImage(items.item, items.value, new_item)
				if self.hovered then
					setTooltip(new_item)
				end
				local quantity = items.quantity or 0

				dxDrawRectangle(
					x,
					y,
					self.width,
					self.height,
					tocolor(25, 25, 25, 200 * (ui_progress * inventory_ui.target_background.progress * self.progress))
				)

				dxDrawRectangle(
					x,
					y + self.height - stroke,
					(self.width * 2) * (1 - self.progress),
					stroke,
					tocolor(
						settings.ui_color[1],
						settings.ui_color[2],
						settings.ui_color[3],
						255 * (ui_progress * inventory_ui.target_background.progress)
					)
				)

				dxDrawText(
					new_item,
					x + rounded_corners.cards,
					y + rounded_corners.cards,
					x + self.width - rounded_corners.cards,
					y + self.height,
					tocolor(
						settings.ui_color[1],
						settings.ui_color[2],
						settings.ui_color[3],
						255 * (ui_progress * inventory_ui.target_background.progress)
					),
					1,
					fonts.regular,
					"center",
					"top",
					true
				)

				if fileExists(image) then
					dxDrawImage(
						x + (self.width - self.icon_size) / 2,
						y + (self.height - self.icon_size) / 2,
						self.icon_size,
						self.icon_size,
						image,
						0,
						0,
						0,
						tocolor(255, 255, 255, 255 * (ui_progress * inventory_ui.target_background.progress))
					)
				end

				dxDrawText(
					quantity .. "x",
					x + rounded_corners.cards,
					y,
					x + self.width,
					y + self.height - rounded_corners.cards,
					tocolor(255, 255, 255, 255 * (ui_progress * inventory_ui.target_background.progress)),
					1,
					fonts.regular,
					"left",
					"bottom",
					true
				)

				dxDrawText(
					tostring(items.value),
					x,
					y,
					x + self.width - rounded_corners.cards,
					y + self.height - rounded_corners.cards,
					tocolor(255, 255, 255, 255 * (ui_progress * inventory_ui.target_background.progress)),
					1,
					fonts.regular,
					"right",
					"bottom",
					true
				)
			end,
			render = function(self, parent_x, parent_y)
				local x, y = (parent_x or 0) + self.x, (parent_y or 0) + self.y
				self:draw(x, y)
			end,
			cursor_scroll = function(self, direction)
				if not self.parent then
					return
				end
				self.parent:cursor_scroll(direction)
			end,
		}
		table.insert(inventory_ui.target_content.children, item)
	end
	inventory_ui.target_content.overflow_y =
		max(0, (ceil(#tbl / columns) * (item_height + separation)) - (inventory_ui.target_content.height + separation))
end

function UpdateTargetItems(items)
	local items_table = {}
	-- Guardar raw para mapeo de slots reales
	target_raw_items = items or {}
    local filter = (inventory_ui.input and inventory_ui.input.text or ""):lower()
	for key, value in ipairs(items) do
		if value.item == 29 or value.item == 43 then
			value.value = tonumber(value.value)
		end
        local itemName
        if value and value.item == 27 then
            itemName = exports["muebles"]:getNombreMueble(value.value)
        else
            itemName = (value.name and tostring(value.name) ~= "" and value.name) or exports["items"]:getName(value.item)
        end
        local pass = true
        if filter ~= "" then
            pass = (tostring(itemName or ""):lower():find(filter, 1, true) ~= nil)
        end
        if pass then
            local index = table.findItem(items_table, { item = value.item, value = value.value })
            if index then
                items_table[index].quantity = items_table[index].quantity + 1
            else
                local v = value
                v.quantity = 1
                table.insert(items_table, v)
            end
        end
	end
	target_items = items_table
	target_items_count = #items_table
	TargetItemsGridlist(5, rounded_corners.window, items_table)
	inventory_ui.target_content.render_target_need_update = true
end

function UpdateMaleteroItems()
	local items = exports["vehicles"]:getMaletero()
	-- Guardar raw
	target_raw_items = items or {}
	UpdateTargetItems(items)
end

function ShowMaleteroItems()
	if not ui_visible then
		ToggleUI(true)
	end
	if TARGET_ELEMENT then
		TARGET_ELEMENT = nil
	end
	if not inventory_ui.target_background.visible then
		inventory_ui.target_background.visible = true
		inventory_ui.target_background.tick = getTickCount()
	end
	if not inventory_ui.player_exchange_item.visible then
		inventory_ui.player_exchange_item.visible = true
		inventory_ui.player_exchange_item.tick = getTickCount()
	end
	if not inventory_ui.target_exchange_item.visible then
		inventory_ui.target_exchange_item.visible = true
		inventory_ui.target_exchange_item.tick = getTickCount()
	end
	IS_MALETERO = true
	UpdateMaleteroItems()
end

function UpdateMochilaItems()
	local items = exports["items"]:getMochila()
	-- Guardar raw
	target_raw_items = items or {}
	UpdateTargetItems(items)
end

function ShowMochilaItems()
	if not ui_visible then
		ToggleUI(true)
	end
	if TARGET_ELEMENT then
		TARGET_ELEMENT = nil
	end
	if not inventory_ui.target_background.visible then
		inventory_ui.target_background.visible = true
		inventory_ui.target_background.tick = getTickCount()
	end
	if not inventory_ui.player_exchange_item.visible then
		inventory_ui.player_exchange_item.visible = true
		inventory_ui.player_exchange_item.tick = getTickCount()
	end
	if not inventory_ui.target_exchange_item.visible then
		inventory_ui.target_exchange_item.visible = true
		inventory_ui.target_exchange_item.tick = getTickCount()
	end
	IS_MOCHILA = true
	UpdateMochilaItems()
end

function RenderUI()
	local current_tick = getTickCount()
	ui_progress = interpolateBetween(
		ui_visible and 0 or 1,
		0,
		0,
		ui_visible and 1 or 0,
		0,
		0,
		min(1, (current_tick - ui_tick) / 500),
		"Linear"
	)
	-- Actualizar color de acento dinámico por cuadro
	local ar, ag, ab = getAccentColor()
	settings.ui_color[1], settings.ui_color[2], settings.ui_color[3] = ar, ag, ab
	if ui_progress < 1 then
		inventory_ui.player_content.render_target_need_update = true
		inventory_ui.target_content.render_target_need_update = true
	end
	if not ui_visible and ui_progress == 0 then
		removeEventHandler("onClientRender", root, RenderUI)
		return
	end
	dxDrawRectangle(0, 0, screen_width, screen_height, tocolor(0, 0, 0, 200 * ui_progress))
	inventory_ui:render()

	-- Menú contextual
	context_menu:render()
	-- Diálogo de confirmación
	confirm_dialog:render()
	-- Diálogo de cantidad
	if quantity_dialog and quantity_dialog.render then quantity_dialog:render() end

	-- Tooltip
	if current_tooltip.visible and current_tooltip.text ~= "" then
		local text = current_tooltip.text
		local tw = dxGetTextWidth(text, 1, fonts.regular)
		local w = tw + padding * 2
		local h = fonts_height.regular + padding * 2
		local x = min(screen_width - w - 5, cursor.x + 16)
		local y = min(screen_height - h - 5, cursor.y + 16)
		dxDrawRoundedRectangle(x, y, w, h, { 20,20,20, 220 * ui_progress }, { rounded_corners.button, rounded_corners.button, rounded_corners.button, rounded_corners.button })
		dxDrawText(text, x + padding, y + padding, x + w - padding, y + h - padding, tocolor(255,255,255, 255 * ui_progress), 1, fonts.regular, "left", "top", true)
	end

	-- Ghost del drag
	if drag_state.active and drag_state.data then
		local new_item
		if drag_state.data and drag_state.data.item == 27 then
			new_item = exports["muebles"]:getNombreMueble(drag_state.data.value)
		else
			new_item = drag_state.data.name and tostring(drag_state.data.name) ~= "" and drag_state.data.name or exports["items"]:getName(drag_state.data.item)
		end
		local image = exports["items"]:getImage(drag_state.data.item, drag_state.data.value, new_item)
		local size = floor(screen_scale * 64)
		if fileExists(image) then
			dxDrawImage(cursor.x - size/2, cursor.y - size/2, size, size, image, 0, 0, 0, tocolor(255,255,255, 220 * ui_progress))
		end
	end
end

function ToggleUI(status)
	ui_visible = status
	ui_tick = getTickCount()
	triggerEvent(ui_visible and "onCursor" or "offCursor", localPlayer)
	if ui_visible then
		UpdatePlayerItems()
		removeEventHandler("onClientRender", root, RenderUI)
		addEventHandler("onClientRender", root, RenderUI, false)
	else
		setTooltip("")
		context_menu:hide()
		confirm_dialog:hide()
		quantity_dialog:hide()
		if inventory_ui.target_background.visible then
			inventory_ui.target_background.visible = false
			inventory_ui.target_background.tick = getTickCount()

			inventory_ui.target_content.selected = false
			inventory_ui.target_content.children = {}
		end
		if inventory_ui.player_exchange_item.visible then
			inventory_ui.player_exchange_item.visible = false
			inventory_ui.player_exchange_item.tick = getTickCount()
		end
		if inventory_ui.target_exchange_item.visible then
			inventory_ui.target_exchange_item.visible = false
			inventory_ui.target_exchange_item.tick = getTickCount()
		end
		if TARGET_ELEMENT then
			TARGET_ELEMENT = nil
		end
		if IS_MALETERO then
			IS_MALETERO = false
			triggerServerEvent("onRolDeCerrarMaletero", localPlayer)
		end
		if IS_MOCHILA then
			IS_MOCHILA = false
			triggerServerEvent("onCerrarMochila", localPlayer)
		end
	end
end

bindKey("i", "down", function()
	-- No abrir inventario si está en creación de personajes
	if getElementData(localPlayer, "character_creation_active") then
		return
	end
	ToggleUI(not ui_visible)
end)

local function get_cursor_hovering_element(element, cursor_x, cursor_y)
	if not element then
		return false
	end
	if element.visible ~= nil and not element.visible then
		return false
	end
	cursor_x, cursor_y = cursor_x - element.x, cursor_y - element.y
	if element.render_target then
		if cursor_x < 0 or cursor_y < 0 or cursor_x > element.width or cursor_y > element.height then
			return false
		end
	end
	if element.children then
		local scroll_x, scroll_y = element.scroll_x or 0, element.scroll_y or 0
		for i = #element.children, 1, -1 do
			if
				not isElement(element.render_target)
				or element.children[i].x + element.children[i].width + scroll_x >= 0
					and element.children[i].x + scroll_x <= element.width
					and element.children[i].y + element.children[i].height + scroll_y >= 0
					and element.children[i].y + scroll_y <= element.height
			then
				local hovered_child =
					get_cursor_hovering_element(element.children[i], cursor_x - scroll_x, cursor_y - scroll_y)
				if hovered_child then
					return hovered_child
				end
			end
		end
	end
	if cursor_x < 0 or cursor_y < 0 or cursor_x > element.width or cursor_y > element.height then
		return false
	end
	return element
end

addEventHandler("onClientRender", root, function()
	if not ui_visible then
		return
	end
	local cursor_x, cursor_y = -screen_width, -screen_height
	if isCursorShowing() then
		local x, y = getCursorPosition()
		cursor_x, cursor_y = x * screen_width, y * screen_height
	end
	cursor.x, cursor.y = cursor_x, cursor_y
    local entered_element = cursor.entered
	local hovering_element = get_cursor_hovering_element(inventory_ui, cursor_x, cursor_y)
	if hovering_element ~= entered_element then
		if entered_element and entered_element.cursor_leave then
			entered_element.cursor_leave(entered_element, cursor_x, cursor_y)
		end
		cursor.entered = hovering_element
		if hovering_element and hovering_element.cursor_enter then
			hovering_element.cursor_enter(hovering_element, cursor_x, cursor_y)
		end
	end
	-- Ocultar tooltip si no está sobre item
	if not hovering_element or not hovering_element.data then
		setTooltip("")
	end
    -- activar drag si hay intención y el cursor se movió lo suficiente
    if drag_state.will_start and not drag_state.active then
        local dx = math.abs(cursor_x - drag_state.will_start.x)
        local dy = math.abs(cursor_y - drag_state.will_start.y)
        if dx > 6 or dy > 6 then
            drag_state.active = true
            drag_state.source = drag_state.will_start.source
            drag_state.data = drag_state.will_start.data
            drag_state.start_x = drag_state.will_start.x
            drag_state.start_y = drag_state.will_start.y
            drag_state.start_tick = drag_state.will_start.tick
            drag_state.will_start = nil
        end
    end
end, false)

addEventHandler("onClientKey", root, function(key, pressed)
	if not ui_visible then
		return
	end
	if not pressed then
		return
	end
	local entered_element = cursor.entered
	if not entered_element then
		return
	end
	if (key == "mouse_wheel_up" or key == "mouse_wheel_down") and entered_element.cursor_scroll then
		local direction = key == "mouse_wheel_up" and -1 or 1
		entered_element:cursor_scroll(direction)
	end
	if (key == "arrow_u" or key == "arrow_d") and entered_element.cursor_scroll then
		local direction = key == "arrow_u" and -1 or 1
		entered_element:cursor_scroll(direction)
	end
	-- Confirm dialog bindings
	if confirm_dialog.visible then
		if key == "enter" then
			if confirm_dialog.on_accept then confirm_dialog.on_accept() end
			confirm_dialog:hide()
			cancelEvent()
			return
		end
		if key == "escape" then
			if confirm_dialog.on_cancel then confirm_dialog.on_cancel() end
			confirm_dialog:hide()
			cancelEvent()
			return
		end
	end
	-- Quantity dialog bindings
	if quantity_dialog.visible then
		if key == "enter" then
			if quantity_dialog.on_confirm then quantity_dialog.on_confirm(quantity_dialog.amount) end
			quantity_dialog:hide()
			cancelEvent()
			return
		end
		if key == "escape" then
			quantity_dialog:hide()
			cancelEvent()
			return
		end
		if key == "backspace" then
			quantity_dialog:backspace()
			cancelEvent()
			return
		end
		-- números 0..9: handled in onClientCharacter para evitar conflictos de layout
	end
	-- Atajo: Supr para soltar
	if key == "delete" then
		local selected = inventory_ui.player_content.selected
		if selected and selected.data then
			local function doDrop()
				local slot = findRawPlayerSlot(selected.data)
				if slot then triggerServerEvent("inventory->drop", resourceRoot, slot) end
			end
			if isItemImportant(selected.data) then
				confirm_dialog:show("¿Seguro que quieres soltar este objeto?", doDrop)
			else
				doDrop()
			end
		end
	end
end, false)

addEventHandler("onClientClick", root, function(button, pressed, cursor_x, cursor_y)
	if not ui_visible then
		return
	end
    -- deshabilitado menú contextual
	-- drag start
    -- drag start solo si se mantiene presionado: activamos bandera y validamos movimiento en mouse move
    if button == "left" and pressed == "down" and cursor.entered and cursor.entered.data then
        drag_state.will_start = {
            source = (cursor.entered.parent == inventory_ui.target_content) and "target" or "player",
            data = cursor.entered.data,
            x = cursor_x,
            y = cursor_y,
            tick = getTickCount(),
        }
    end
	if pressed == "down" and cursor.entered then
		if cursor.entered.cursor_click then
			cursor.clicked = cursor.entered
			cursor.entered:cursor_click(button, pressed, cursor_x, cursor_y)
		end
    elseif pressed == "up" then
        -- menú contextual deshabilitado
		if cursor.clicked then
		if cursor.clicked.cursor_click then
			cursor.clicked:cursor_click(button, pressed, cursor_x, cursor_y)
		end
            -- finalizar drag: soltar en panel opuesto o fuera para tirar
		if drag_state.active and drag_state.data then
			local dropped = false
			-- Si arrastró desde player al target panel
			local px, py, pw, ph = getAbsRect(inventory_ui.target_background)
			if drag_state.source == "player" and inventory_ui.target_background.visible and pointInRect(cursor_x, cursor_y, px, py, pw, ph) then
				-- mover al target
				if IS_MALETERO then
					local slot = findRawPlayerSlot(drag_state.data)
					triggerServerEvent("items:giveToMaletero", localPlayer, slot)
					setTimer(UpdatePlayerItems, 100, 1)
					setTimer(UpdateMaleteroItems, 100, 1)
					dropped = true
				elseif IS_MOCHILA then
					local slot = findRawPlayerSlot(drag_state.data)
					triggerServerEvent("items:giveToMochila", localPlayer, slot)
					setTimer(UpdatePlayerItems, 100, 1)
					setTimer(UpdateMochilaItems, 100, 1)
					dropped = true
				elseif TARGET_ELEMENT then
					local slot = findRawPlayerSlot(drag_state.data)
					triggerServerEvent("inventory->exchange_from_player", resourceRoot, slot, TARGET_ELEMENT)
					dropped = true
				end
			end
			-- si arrastró desde target al panel del jugador
			local qx, qy, qw, qh = getAbsRect(inventory_ui.player_background)
			if not dropped and drag_state.source == "target" and pointInRect(cursor_x, cursor_y, qx, qy, qw, qh) then
				if IS_MALETERO and inventory_ui.target_content.selected and inventory_ui.target_content.selected.data and inventory_ui.target_content.selected.data.index then
					triggerServerEvent("items:getFromMaletero", localPlayer, inventory_ui.target_content.selected.data.index)
					setTimer(UpdatePlayerItems, 100, 1)
					setTimer(UpdateMaleteroItems, 100, 1)
					dropped = true
				elseif IS_MOCHILA and inventory_ui.target_content.selected and inventory_ui.target_content.selected.data and inventory_ui.target_content.selected.data.index then
					triggerServerEvent("items:getFromMochila", localPlayer, inventory_ui.target_content.selected.data.index)
					setTimer(UpdatePlayerItems, 100, 1)
					setTimer(UpdateMochilaItems, 100, 1)
					dropped = true
				elseif TARGET_ELEMENT then
					-- cacheo inverso
					local function findRawTargetSlot(data)
						if not data then return false end
						local itemId = data.item
						local valueNorm = normalizeValueByItem(itemId, data.value)
						for i = #target_raw_items, 1, -1 do
							local it = target_raw_items[i]
							if it and it.item == itemId then
								local itValue = normalizeValueByItem(it.item, it.value)
								if itValue == valueNorm then
									return i
								end
							end
						end
						return false
					end
					local slot = findRawTargetSlot(drag_state.data)
					triggerServerEvent("inventory->exchange_from_target", resourceRoot, slot, TARGET_ELEMENT)
					dropped = true
				end
			end
			-- soltar fuera del inventario general = tirar
			local ix, iy, iw, ih = inventory_ui.x, inventory_ui.y, inventory_ui.width, inventory_ui.height
            if not dropped and drag_state.source == "player" and not pointInRect(cursor_x, cursor_y, ix, iy, iw, ih) then
                local quantity = drag_state.data.quantity or 1
                local function doDrop(amount)
                    local slot = findRawPlayerSlot(drag_state.data)
                    if slot then triggerServerEvent(amount and amount > 1 and "inventory->drop_quantity" or "inventory->drop", resourceRoot, slot, amount) end
                end
                local function askOrDrop()
                    if quantity > 1 then
                        quantity_dialog:show(quantity, function(amount) doDrop(amount) end)
                    else
                        doDrop(1)
                    end
                end
                if isItemImportant(drag_state.data) then
                    local name = getItemDisplayName(drag_state.data)
                    confirm_dialog:show("¿Seguro que quieres soltar '" .. tostring(name) .. "'?", askOrDrop)
                else
                    askOrDrop()
                end
                dropped = true
            end
			drag_state.active = false
			drag_state.data = nil
			drag_state.source = nil
		end
		end
        -- cancelar intención si no se activó
        drag_state.will_start = nil
	end
end, false)

addEventHandler("onClientCharacter", root, function(character)
	if not ui_visible then
		return
	end
	if not character then
		return
	end
	if cursor.clicked and cursor.clicked.update_text then
		cursor.clicked:update_text(character)
	end
	if quantity_dialog.visible then
		local ch = tonumber(character)
		if ch ~= nil then
			quantity_dialog:append_digit(ch)
			cancelEvent()
			return
		end
	end
end, false)

addEvent("inventory->update_items", true)
addEventHandler("inventory->update_items", resourceRoot, function()
	UpdatePlayerItems()
end)

addEvent("inventory->show_target_items", true)
addEventHandler("inventory->show_target_items", resourceRoot, function(target, items)
	TARGET_ELEMENT = target
	if not inventory_ui.target_background.visible then
		inventory_ui.target_background.visible = true
		inventory_ui.target_background.tick = getTickCount()
	end
	if not inventory_ui.player_exchange_item.visible then
		inventory_ui.player_exchange_item.visible = true
		inventory_ui.player_exchange_item.tick = getTickCount()
	end
	if not inventory_ui.target_exchange_item.visible then
		inventory_ui.target_exchange_item.visible = true
		inventory_ui.target_exchange_item.tick = getTickCount()
	end
	ToggleUI(true)
	UpdateTargetItems(items)
end)

addEvent("inventory->update_target_items", true)
addEventHandler("inventory->update_target_items", resourceRoot, function(items)
	UpdateTargetItems(items)
end)

addEventHandler("onAbrirMochila", localPlayer, function(_, _, tipo)
	if tipo and tipo == 1 then
		ToggleUI(false)
	end
end)

addEventHandler("onClientRestore", root, function()
	inventory_ui.player_content.render_target_need_update = true
	inventory_ui.target_content.render_target_need_update = true
end)

-- Liberación de recursos DX al detener el resource (colocado al final para evitar nils)
addEventHandler("onClientResourceStop", resourceRoot, function()
    if textures then
        for _, tx in pairs(textures) do if isElement(tx) then destroyElement(tx) end end
    end
    if fonts then
        for _, ft in pairs(fonts) do if isElement(ft) then destroyElement(ft) end end
    end
    if inventory_ui and inventory_ui.player_content and isElement(inventory_ui.player_content.render_target) then
        destroyElement(inventory_ui.player_content.render_target)
    end
    if inventory_ui and inventory_ui.target_content and isElement(inventory_ui.target_content.render_target) then
        destroyElement(inventory_ui.target_content.render_target)
    end
end)