--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 DownTown Roleplay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

engineSetAsynchronousLoading( true, true )
setWorldSoundEnabled(5, false)
--addEventHandler( "onClientCursorMove", getRootElement( ),
   -- function ( _, _, _, _, x, y, z )
        --setPedLookAt( getLocalPlayer( ), x, y, z )
    --end
--)

local barras = true
local yo = true
local sX, sY = guiGetScreenSize ()
----------------------------------------BARRAS DE SALUD, SED ETC ORIGINALES---------------------------------------------------
--local barrasData = {x = sX - 165, y = sY/2 - 150, w = 154, h = 61, state = 1, list = {{"Sed", color = tocolor(255, 75, 75, 150)}, {"Cansancio", color = tocolor(75, 255, 75, 150)}, {"Hambre", color = tocolor(75, 75, 255, 150)}, {"Musculatura", color = tocolor(198, 216, 2, 255)}, {"Gordura", color = tocolor(216, 155, 2, 255)}}}

--function dxYoYBarras()
	--if exports.players:isLoggedIn() then
		--dxDrawRectangle(barrasData.x, barrasData.y, barrasData.w, barrasData.h, tocolor(50, 50, 50, 50))
		--for i, k in ipairs(barrasData.list) do
			--if string.lower(k[1]) == "musculatura" then
				--data = (barrasData.w - 4)*getPedStat(getLocalPlayer(), 23)/1000
			--elseif string.lower(k[1]) == "gordura" then
				--data = (barrasData.w - 4)*getPedStat(getLocalPlayer(), 21)/1000
			--else
				--data = (barrasData.w - 4)*getElementData(localPlayer, string.lower(k[1]))/100
				--if data > 150 then
				--	data = 150
				--elseif data < 0 then
				--	data = 0
				--end
			--end
			--dxDrawRectangle(barrasData.x + 1, barrasData.y - 19 + i*20, barrasData.w - 2, 19, tocolor(0, 0, 0, 100))
			--dxDrawRectangle(barrasData.x + 2, barrasData.y - 18 + i*20, data, 16, k.color)
			--dxDrawText(k[1], barrasData.x + 2, barrasData.y - 18 + i*20, barrasData.w - 4 + barrasData.x + 2, 16 + barrasData.y - 18 + i*20, tocolor(255, 255, 255, 255), 0.5, "pricedown", "center", "center")
		--end
		--if barrasData.state == 1 then
			--if barrasData.x > sX - 165 then 
				--barrasData.x = barrasData.x - 5
			--elseif barrasData.x < sX - 165 then 
				--barrasData.x = barrasData.x + 5
			--end
	--	elseif barrasData.state == 2 then
			--if barrasData.x > sX + 160 then 
			--	barrasData.x = barrasData.x - 5
			--elseif barrasData.x < sX + 160 then 
				--barrasData.x = barrasData.x + 5
			--end
		--end	
		--if yo == true then
			--dxDrawText("/yo: "..getElementData(getLocalPlayer(), "yo") or "Sin /yo asignado.", 21/1280*sX, 769/800*sY, 435/1280*sX, 561/800*sY, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
			--dxDrawText("/yo: "..getElementData(getLocalPlayer(), "yo") or "Sin /yo asignado.", 21/1280*sX, 767/800*sY, 435/1280*sX, 559/800*sY, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
			--dxDrawText("/yo: "..getElementData(getLocalPlayer(), "yo") or "Sin /yo asignado.", 19/1280*sX, 769/800*sY, 433/1280*sX, 561/800*sY, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
			--dxDrawText("/yo: "..getElementData(getLocalPlayer(), "yo") or "Sin /yo asignado.", 19/1280*sX, 767/800*sY, 433/1280*sX, 559/800*sY, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
			--dxDrawText("/yo: "..getElementData(getLocalPlayer(), "yo") or "Sin /yo asignado.", 20/1280*sX, 768/800*sY, 434/1280*sX, 560/800*sY, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, false, false, false)	
		--end
	--end
--end
--addEventHandler("onClientRender", root, dxYoYBarras)

--function toggleHUDSec()
	--barrasData.state = barrasData.state == 1 and 2 or 1
	--if yo == true then yo = false else yo = true end
--end
--addCommandHandler("hud",toggleHUDSec)

function handleMinimize()
	createTrayNotification("GuaroCity RolePlay: ¡Por favor, no tardes en volver! Te recordamos que estar A.F.K. puede ser sancionable.")
	setElementData(getLocalPlayer(), "minpa", true)
end
addEventHandler("onClientMinimize", root, handleMinimize)

function handleRestore()
	setElementData(getLocalPlayer(), "minpa", false)
end
addEventHandler("onClientRestore", root, handleRestore)

function sendNotificationPC (text)
	if text then
		createTrayNotification(tostring(text))
	end
end
addEvent("onSendNotification", true)
addEventHandler("onSendNotification", getRootElement(), sendNotificationPC)

addEventHandler( "onClientPlayerNetworkStatus", root,
	function( status, ticks )
		if status == 1 then
			if ticks > 3000 then
				outputChatBox("Hemos detectado un problema en tu conexión. Por favor, revísala.", 255, 0, 0)
			end
		end
	end
)

local run = 0
local down = 0


addEventHandler( "onClientPreRender", getRootElement(), 
	function( slice )
		if isPedWearingJetpack(getLocalPlayer()) then return end
		if ( not isPedInVehicle( getLocalPlayer( ) ) and getPedControlState( "sprint" ) ) or down > 0 then
			run = run + slice
			if run >= 40000 then
				if isPedOnGround( getLocalPlayer( ) ) then
					setElementData(getLocalPlayer(), "cansancio", getElementData(getLocalPlayer(), "cansancio")-5)
					run = 15000
				    local gordura = getPedStat(getLocalPlayer(), 21)
					if gordura >= 1 then
					triggerServerEvent ("onGestionarPeso",getLocalPlayer(),21,gordura-1) 
					end
				else
					toggleControl( 'sprint', false )
					setTimer( toggleControl, 5000, 1, 'sprint', true )
				end
			end
			if not getPedControlState( "sprint" ) then
				down = math.max( 0, down - slice )
			else
				down = 500
			end
		else
			if run > 0 then
				run = math.max( 0, run - math.ceil( slice / 3 ) )
			end
		end
	end
)

-- ============================================================================
-- 🇨🇴 SISTEMA DE ZONAS COLOMBIANAS PERSONALIZADO - 100+ ZONAS
-- ============================================================================

-- 🇨🇴 SISTEMA DE ZONAS COLOMBIANAS - ÁREA DE ROL ESPECÍFICA
-- Coordenadas exactas del área de rol: X(-216 a 2903) Y(-2826 a -776)
-- Cuadrícula de 8x6 = 48 zonas con nombres principalmente de MEDELLÍN

local zonasColombinas = {
    -- ===== FILA 1 (NORTE): Y(-776 a -1118) =====
    {minX = -216, minY = -1118, maxX = 174, maxY = -776, nombre = "El Poblado"}, -- Medellín
    {minX = 174, minY = -1118, maxX = 564, maxY = -776, nombre = "Laureles"}, -- Medellín
    {minX = 564, minY = -1118, maxX = 954, maxY = -776, nombre = "Envigado"}, -- Medellín
    {minX = 954, minY = -1118, maxX = 1344, maxY = -776, nombre = "La Candelaria"}, -- Bogotá
    {minX = 1344, minY = -1118, maxX = 1734, maxY = -776, nombre = "Sabaneta"}, -- Medellín
    {minX = 1734, minY = -1118, maxX = 2124, maxY = -776, nombre = "Belén"}, -- Medellín
    {minX = 2124, minY = -1118, maxX = 2514, maxY = -776, nombre = "San Antonio"}, -- Cali
    {minX = 2514, minY = -1118, maxX = 2903, maxY = -776, nombre = "Itagüí"}, -- Medellín

    -- ===== FILA 2: Y(-1118 a -1460) =====
    {minX = -216, minY = -1460, maxX = 174, maxY = -1118, nombre = "Robledo"}, -- Medellín
    {minX = 174, minY = -1460, maxX = 564, maxY = -1118, nombre = "Buenos Aires"}, -- Medellín
    {minX = 564, minY = -1460, maxX = 954, maxY = -1118, nombre = "Manrique"}, -- Medellín
    {minX = 954, minY = -1460, maxX = 1344, maxY = -1118, nombre = "Chapinero"}, -- Bogotá
    {minX = 1344, minY = -1460, maxX = 1734, maxY = -1118, nombre = "Aranjuez"}, -- Medellín
    {minX = 1734, minY = -1460, maxX = 2124, maxY = -1118, nombre = "Santa Cruz"}, -- Medellín
    {minX = 2124, minY = -1460, maxX = 2514, maxY = -1118, nombre = "Granada"}, -- Cali
    {minX = 2514, minY = -1460, maxX = 2903, maxY = -1118, nombre = "La Estrella"}, -- Medellín

    -- ===== FILA 3: Y(-1460 a -1802) =====
    {minX = -216, minY = -1802, maxX = 174, maxY = -1460, nombre = "Popular"}, -- Medellín Comuna 1
    {minX = 174, minY = -1802, maxX = 564, maxY = -1460, nombre = "Villa Hermosa"}, -- Medellín
    {minX = 564, minY = -1802, maxX = 954, maxY = -1460, nombre = "Castilla"}, -- Medellín
    {minX = 954, minY = -1802, maxX = 1344, maxY = -1460, nombre = "Zona Rosa"}, -- Bogotá
    {minX = 1344, minY = -1802, maxX = 1734, maxY = -1460, nombre = "Campo Valdés"}, -- Medellín
    {minX = 1734, minY = -1802, maxX = 2124, maxY = -1460, nombre = "Guayabal"}, -- Medellín
    {minX = 2124, minY = -1802, maxX = 2514, maxY = -1460, nombre = "El Peñón"}, -- Cali
    {minX = 2514, minY = -1802, maxX = 2903, maxY = -1460, nombre = "Caldas"}, -- Medellín

    -- ===== FILA 4: Y(-1802 a -2144) =====
    {minX = -216, minY = -2144, maxX = 174, maxY = -1802, nombre = "San Javier"}, -- Medellín Comuna 13
    {minX = 174, minY = -2144, maxX = 564, maxY = -1802, nombre = "La Macarena"}, -- Medellín
    {minX = 564, minY = -2144, maxX = 954, maxY = -1802, nombre = "Moravia"}, -- Medellín
    {minX = 954, minY = -2144, maxX = 1344, maxY = -1802, nombre = "Kennedy"}, -- Bogotá
    {minX = 1344, minY = -2144, maxX = 1734, maxY = -1802, nombre = "El Estadio"}, -- Medellín
    {minX = 1734, minY = -2144, maxX = 2124, maxY = -1802, nombre = "Boston"}, -- Medellín
    {minX = 2124, minY = -2144, maxX = 2514, maxY = -1802, nombre = "Ciudad Jardín"}, -- Cali
    {minX = 2514, minY = -2144, maxX = 2903, maxY = -1802, nombre = "Bello"}, -- Medellín

    -- ===== FILA 5: Y(-2144 a -2486) =====
    {minX = -216, minY = -2486, maxX = 174, maxY = -2144, nombre = "Doce de Octubre"}, -- Medellín
    {minX = 174, minY = -2486, maxX = 564, maxY = -2144, nombre = "Pedregal"}, -- Medellín
    {minX = 564, minY = -2486, maxX = 954, maxY = -2144, nombre = "Picacho"}, -- Medellín
    {minX = 954, minY = -2486, maxX = 1344, maxY = -2144, nombre = "Suba"}, -- Bogotá
    {minX = 1344, minY = -2486, maxX = 1734, maxY = -2144, nombre = "Santa Elena"}, -- Medellín
    {minX = 1734, minY = -2486, maxX = 2124, maxY = -2144, nombre = "Prado"}, -- Medellín
    {minX = 2124, minY = -2486, maxX = 2514, maxY = -2144, nombre = "Meléndez"}, -- Cali
    {minX = 2514, minY = -2486, maxX = 2903, maxY = -2144, nombre = "Copacabana"}, -- Medellín

    -- ===== FILA 6 (SUR): Y(-2826 a -2486) =====
    {minX = -216, minY = -2826, maxX = 174, maxY = -2486, nombre = "El Socorro"}, -- Medellín
    {minX = 174, minY = -2826, maxX = 564, maxY = -2486, nombre = "Altavista"}, -- Medellín
    {minX = 564, minY = -2826, maxX = 954, maxY = -2486, nombre = "San Cristóbal"}, -- Medellín
    {minX = 954, minY = -2826, maxX = 1344, maxY = -2486, nombre = "Ciudad Bolívar"}, -- Bogotá
    {minX = 1344, minY = -2826, maxX = 1734, maxY = -2486, nombre = "San Antonio de Prado"}, -- Medellín
    {minX = 1734, minY = -2826, maxX = 2124, maxY = -2486, nombre = "La América"}, -- Medellín
    {minX = 2124, minY = -2826, maxX = 2514, maxY = -2486, nombre = "Tequendama"}, -- Cali
    {minX = 2514, minY = -2826, maxX = 2903, maxY = -2486, nombre = "Girardota"} -- Medellín
}

-- Función para obtener zona personalizada
function obtenerZonaColombina(x, y)
    for _, zona in ipairs(zonasColombinas) do
        if x >= zona.minX and x <= zona.maxX and y >= zona.minY and y <= zona.maxY then
            return zona.nombre
        end
    end
    -- Si no encuentra zona personalizada, usar la original
    return getZoneName(x, y, 0)
end

-- Función principal para mostrar zona actual - VERSIÓN SIMPLE CON ORBITRON
function mostrarZonaActualGUI()
	if getElementData(localPlayer, "nohud") then return end -- Para poder retirarlo si se pone /hud
	if not exports.players:isLoggedIn() then return end
	local x, y, z = getElementPosition(localPlayer)
	
	local zonaActual = obtenerZonaColombina(x, y)
	-- Posición original pero con fuente Orbitron
	dxDrawText(zonaActual, (955/1366)*sX, (730/768)*sY, (1368/1366)*sX, (584/768)*sY, tocolor(255, 255, 255, 255), 2, "Orbitron-ExtraBold")
end

-- Comando para debug
function debugZonas()
    local x, y, z = getElementPosition(localPlayer)
    outputChatBox("🔍 COORDENADAS: X=" .. math.floor(x) .. ", Y=" .. math.floor(y), 0, 255, 255)
    outputChatBox("🏠 ZONA ORIGINAL: " .. getZoneName(x, y, 0), 255, 255, 0)
    outputChatBox("🇨🇴 ZONA COLOMBIANA: " .. obtenerZonaColombina(x, y), 0, 255, 0)
end

addCommandHandler("debugzona", debugZonas)
addEventHandler("onClientRender", root, mostrarZonaActualGUI)
addEventHandler("onClientResourceStart", root, mostrarZonaActualGUI)



function tlag(cmd, n)
	if n and tonumber(n) then
		outputChatBox("Distancia ajustada a "..tostring(n), 0, 255, 0)
		setFarClipDistance(tonumber(n))
	end
end
--addCommandHandler("tlag", tlag)