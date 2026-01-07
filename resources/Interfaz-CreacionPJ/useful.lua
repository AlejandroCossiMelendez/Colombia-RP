sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
fonts = {
	figmaFonts = {},
	map = {
		['Inter-Regular'] = 'fonts/Inter-Regular.ttf',
		['Inter-Bold'] = 'fonts/Inter-Bold.ttf',
		['Inter-Medium'] = 'fonts/Inter-Medium.ttf',
		['Inter-SemiBold'] = 'fonts/Inter-SemiBold.ttf',
		['Inter-Semi Bold'] = 'fonts/Inter-SemiBold.ttf',
		['Oswald-Bold'] = 'fonts/Oswald-Bold.ttf',
		['Poppins-ExtraBold'] = 'fonts/Poppins-ExtraBold.ttf',
	},
}

function unloadFonts()
	local figmaFonts = fonts.figmaFonts
	for k,v in pairs(figmaFonts) do
		if isElement(v) then destroyElement(v) end
		figmaFonts[k] = nil
	end
end

function loadFonts(array)
	unloadFonts()
	for _,v in pairs(array) do
		fonts[v[1]] = dxCreateFont(v[2], v[3], v[4], 'proof')
	end
end

local function getLocalFont(font, size)
	local key = tostring(font)..'|'..tostring(size)
	local cached = fonts.figmaFonts[key]
	if cached then return cached end
	local path = fonts.map[font]
	if not path then
		outputDebugString('[fonts] No mapeado: '..tostring(font)..' -> usando Inter-Regular', 2)
		path = 'fonts/Inter-Regular.ttf'
	end
	local created = dxCreateFont(path, size, false, 'proof')
	fonts.figmaFonts[key] = created or 'default-bold'
	return fonts.figmaFonts[key]
end

function getFigmaFont(font, size)
	return getLocalFont(font, size)
end

addEventHandler('onClientResourceStop', resourceRoot, function()
	unloadFonts()
end)