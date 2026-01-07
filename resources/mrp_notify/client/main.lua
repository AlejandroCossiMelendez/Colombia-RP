local max = math.max
local min = math.min
local ceil = math.ceil
local floor = math.floor
local insert = table.insert
local remove = table.remove

local ui_visible = false
local ui_progress = false
local ui_tick = 0

local padding = floor(screen_scale * 10)
local stroke = ceil(screen_scale * 2)
local offset = padding / 2

--- @type table<string, number>
local rounded_corners = {
	window = floor(screen_scale * 8),
}

--- @type table<string, dx-texture>
local fonts = {
	medium = dxCreateFont("Roboto-Medium", ceil(screen_scale * 14), false, "cleartype_natural"),
	regular = dxCreateFont("Roboto-Regular", ceil(screen_scale * 12), false, "cleartype_natural"),
}

--- @type table<string, number>
local fonts_height = {
	medium = dxGetFontHeight(1, fonts.medium),
	regular = dxGetFontHeight(1, fonts.regular),
}

--- @type table<string, dx-texture>
local textures = {
	error = dxCreateTexture("error", "argb", true, "clamp"),
	info = dxCreateTexture("info", "argb", true, "clamp"),
	success = dxCreateTexture("success", "argb", true, "clamp"),
	warning = dxCreateTexture("warning", "argb", true, "clamp"),
}

local texture_size = floor(screen_scale * 18)

--- @type table<string, table<number, number, number>>
local colors = {
	error = { 200, 15, 30 },
	info = { 91, 172, 225 },
	success = { 87, 213, 141 },
	warning = { 243, 156, 18 },
}

local notify_cache = {}

local function DrawNotify(notification)
	dxDrawRoundedRectangle(
		notification.x,
		notification.y,
		notification.width,
		notification.height,
		{ 25, 25, 25, 200 * notification.progress },
		{ rounded_corners.window, rounded_corners.window, rounded_corners.window, rounded_corners.window },
		false,
		true
	)

	dxDrawRoundedRectangle(
		notification.x,
		notification.y,
		notification.width,
		notification.height,
		{ notification.icon_color_r, notification.icon_color_g, notification.icon_color_b, 255 * notification.progress },
		{ rounded_corners.window, rounded_corners.window, rounded_corners.window, rounded_corners.window },
		true,
		true
	)

	dxDrawImage(
		notification.x + padding * 2,
		notification.y + (notification.height - texture_size) / 2,
		texture_size,
		texture_size,
		notification.icon,
		0,
		0,
		0,
		tocolor(notification.icon_color_r, notification.icon_color_g, notification.icon_color_b, 255 * notification.progress),
		true
	)

	dxDrawText(
		notification.title,
		notification.x + texture_size + padding * 4,
		notification.y - fonts_height.regular,
		notification.x + notification.width - padding,
		notification.y + notification.height,
		tocolor(255, 255, 255, 255 * notification.progress),
		1,
		fonts.medium,
		"left",
		"center",
		true,
		false,
		true
	)

	dxDrawText(
		notification.message,
		notification.x + texture_size + padding * 4,
		notification.y + fonts_height.medium,
		notification.x + notification.width - padding,
		notification.y + notification.height,
		tocolor(255, 255, 255, 255 * notification.progress),
		1,
		fonts.regular,
		"left",
		"center",
		true,
		false,
		true
	)
end

addEventHandler("onClientRender", root, function()
	local offset_y = padding * 2
	for i, notification in pairs(notify_cache) do
		local current_tick = getTickCount()
		notification.progress = interpolateBetween(
			notification.visible and 0 or 1,
			0,
			0,
			notification.visible and 1 or 0,
			0,
			0,
			min(1, (current_tick - notification.tick) / 250),
			"Linear"
		)
		notification.y = offset_y

		DrawNotify(notification)

		offset_y = offset_y + ((notification.height + padding) * notification.progress)

		if notification.visible then
			if current_tick - notification.tick >= 5000 or i >= 5 then
				notification.visible = false
				notification.tick = getTickCount()
			end
		end
		if not notification.visible and notification.progress == 0 then
			remove(notify_cache, i)
		end
	end
end, false)

local function CreateNotify(title, message, icon)
	local notification = {}
	notification.visible = true
	notification.title = title:gsub("#%x%x%x%x%x%x", "")
	notification.title_width = dxGetTextWidth(notification.title, 1, fonts.medium)

	notification.message = message:gsub("#%x%x%x%x%x%x", "")
	notification.message_width = dxGetTextWidth(notification.message, 1, fonts.regular)

	notification.icon = textures[icon]
	notification.icon_color = colors[icon]
	notification.icon_color_r, notification.icon_color_g, notification.icon_color_b = unpack(notification.icon_color)

	notification.width = max(notification.title_width, notification.message_width) + padding * 6 + texture_size
	notification.height = floor(screen_scale * 60)

	notification.x = (screen_width - notification.width) / 2
	notification.y = padding * 2

	notification.progress = 0
	notification.tick = getTickCount()

	insert(notify_cache, notification)
end

function AddNotify(title, message, icon)
	if not title or type(title) ~= "string" then
		outputDebugString("@AddNotify: Invalid argument at argument #1, expected string, got " .. type(title), 2)
		return false
	end
	if not message or type(message) ~= "string" then
		outputDebugString("@AddNotify: Invalid argument at argument #2, expected string, got " .. type(message), 2)
		return false
	end
	if not icon or type(icon) ~= "string" then
		outputDebugString("@AddNotify: Invalid argument at argument #3, expected string, got " .. type(icon), 2)
		return false
	end
	if not textures[icon] then
		outputDebugString("@AddNotify: Icon '" .. icon .. "' does not exist", 1)
		return false
	end
	CreateNotify(title, message, icon)
end
addEvent("mrp_notify->AddNotify", true)
addEventHandler("mrp_notify->AddNotify", resourceRoot, AddNotify)