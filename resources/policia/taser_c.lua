addEventHandler("onClientPlayerWasted", getRootElement(),
function(attacker, weapon, bodypart)
	if getElementModel(source) == 279 and weapon == 53 then return end 
	if (not attacker or getElementType(attacker) ~= "player" or not weapon) then return end
	if (getElementData(attacker, "tazerOn") and weapon == 24) or (getElementData(attacker, "gomaOn") and weapon == 25) then
		triggerServerEvent("onPlayerTazed", source, attacker, weapon, bodypart, 0)
	end
end)

-- Función para dibujar el contador
function drawTazerCounter()
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "tazed") then
			local counter = getElementData(player, "tazerCounter")
			if counter then
				local x, y, z = getElementPosition(player)
				local px, py = getScreenFromWorldPosition(x, y, z + 0.1)
				if px and py then
					local playerDimension = getElementDimension(player)
					local localDimension = getElementDimension(localPlayer)
					
					if playerDimension == localDimension then
						-- Aumentamos el ancho de 80 a 120 y el alto de 24 a 35
						-- Fondo del contador (negro semi-transparente)
						dxDrawRectangle(px - 60, py - 17, 120, 50, tocolor(0, 0, 0, 180))
						
						-- Ajustamos los bordes al nuevo tamaño
						dxDrawRectangle(px - 60, py - 17, 120, 2, tocolor(255, 0, 0, 255)) -- arriba
						dxDrawRectangle(px - 60, py + 30, 120, 2, tocolor(255, 0, 0, 255)) -- abajo
						dxDrawRectangle(px - 60, py - 17, 2, 50, tocolor(255, 0, 0, 255)) -- izquierda
						dxDrawRectangle(px + 58, py - 17, 2, 50, tocolor(255, 0, 0, 255)) -- derecha
						
						-- Ajustamos la posición del texto para el nuevo tamaño
						dxDrawText("TAZEADO", px, py - 12, px, py - 12, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center")
						dxDrawText(tostring(counter).."s", px, py + 3, px, py + 3, tocolor(255, 0, 0, 255), 1.4, "default-bold", "center")
					end
				end
			end
		end
	end
end

addEventHandler("onClientRender", root, drawTazerCounter)