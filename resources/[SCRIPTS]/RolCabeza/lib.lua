--
-- dxCreateRoundedTexture
-- https://github.com/Pioruniasty/MTA_rounded_rectangle
-- https://forum.mtasa.com/viewtopic.php?f=108&t=96096
-- Author: Piorun
-- All credits of this function to him
--

function dxCreateRoundedTexture(text_width, text_height, radius)
	-- Validar argumentos
	assert(text_width, "Missing argument 'text_width' at dxCreateRoundedTexture")
	assert(text_height, "Missing argument 'height' at dxCreateRoundedTexture")
	assert(radius, "Missing argument 'radius' at dxCreateRoundedTexture")
	
	if type(text_width) ~= "number" then 
		outputDebugString("Bad argument @ 'dxCreateRoundedTexture' [Excepted number at argument 1, got " .. type(text_width) .. "]", 2) 
		return false 
	end
	
	if type(text_height) ~= "number" then 
		outputDebugString("Bad argument @ 'dxCreateRoundedTexture' [Excepted number at argument 2, got " .. type(text_height) .. "]", 2) 
		return false 
	end
	
	if type(radius) ~= "number" then 
		outputDebugString("Bad argument @ 'dxCreateRoundedTexture' [Excepted number at argument 3, got " .. type(radius) .. "]", 2) 
		return false 
	end
	
	if text_width < 0 then 
		outputDebugString("text_width can't be less than 0", 1) 
		return false 
	end
	
	if text_height < 0 then 
		outputDebugString("text_height can't be less than 0", 1) 
		return false 
	end
	
	if radius < 0 or radius > 100 then 
		outputDebugString("Parameter 'radius' can't be outside range 0-100", 1) 
		return false 
	end

	-- Intentar crear la textura con manejo de errores
	local texture
	
	-- Usar pcall para capturar errores potenciales
	local success, result = pcall(function()
		local tex = DxTexture(text_width, text_height)
		if not tex then
			error("Failed to create DxTexture")
		end
		return tex
	end)
	
	if not success then
		outputDebugString("Error creating texture: " .. tostring(result), 1)
		return false
	end
	
	texture = result
	
	-- Obtener los píxeles con manejo de errores
	local success, pix = pcall(function()
		return texture:getPixels()
	end)
	
	if not success or not pix then
		if isElement(texture) then
			destroyElement(texture)
		end
		outputDebugString("Error getting texture pixels", 1)
		return false
	end

	radius = (radius * (text_height / 2)) / 100

	-- Dibujar la textura redondeada
	for x=0, text_width do
		for y=0, text_height do
			if x >= radius and x <= text_width - radius then
				dxSetPixelColor(pix, x, y, 255, 255, 255, 255)
			end
			if y >= radius and y <= text_height - radius then
				dxSetPixelColor(pix, x, y, 255, 255, 255, 255)
			end
			if math.sqrt((x - radius)^2 + (y - radius)^2) < radius then
				dxSetPixelColor(pix, x, y, 255, 255, 255, 255) -- lewy gorny rog
			end
			if math.sqrt((x - (text_width - radius))^2 + (y - radius)^2) < radius then
				dxSetPixelColor(pix, x, y, 255, 255, 255, 255) -- prawy gorny rog
			end
			if math.sqrt((x - radius)^2 + (y - (text_height - radius))^2) < radius then
				dxSetPixelColor(pix, x, y, 255, 255, 255, 255) -- lewy dolny rog
			end
			if math.sqrt((x - (text_width - radius))^2 + (y - (text_height - radius))^2) < radius then
				dxSetPixelColor(pix, x, y, 255, 255, 255, 255) -- prawy dolny rog
			end
		end
	end
	
	-- Establecer los píxeles con manejo de errores
	local success = pcall(function()
		texture:setPixels(pix)
	end)
	
	if not success then
		if isElement(texture) then
			destroyElement(texture)
		end
		outputDebugString("Error setting texture pixels", 1)
		return false
	end
	
	return texture
end

-- outElastic | Got from https://github.com/EmmanuelOga/easing/blob/master/lib/easing.lua
local pi = math.pi
function outElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1 then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < math.abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * math.asin(c/a)
  end

  return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * pi) / p) + c + b
end