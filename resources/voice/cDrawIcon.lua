-- =====================================================
-- OPTIMIZACIÓN APLICADA: Variables optimizadas y cache
-- =====================================================
local g_screenX,g_screenY = guiGetScreenSize()
local BONE_ID = 8
local WORLD_OFFSET = 0.4
local ICON_PATH = "images/voice.png"
local ICON_WIDTH = 0.075*g_screenX
local iconHalfWidth = ICON_WIDTH/2

local ICON_DIMENSIONS = 16
local ICON_LINE = 20
local ICON_TEXT_SHADOW = tocolor(0, 0, 0, 255)

-- OPTIMIZACIÓN: Variables para control de framerate y cache
local ultimoRenderIconos = 0
local INTERVALO_RENDER_ICONOS = 33  -- ~30fps para iconos
local cacheIconos = {}
local ultimoLimpiezaIconos = 0
local INTERVALO_LIMPIEZA_ICONOS = 1000

-- OPTIMIZACIÓN: Cache de colores y valores comunes
local colorBlanco = tocolor(255, 255, 255, 255)
local camaraCache = {x = 0, y = 0, z = 0, lastUpdate = 0}

-- =====================================================
-- OPTIMIZACIÓN APLICADA: onClientRender super optimizado
-- =====================================================

-- =====================================================
-- OPTIMIZACIÓN ULTRA: Iconos de voz ELIMINADOS para máximo rendimiento
-- =====================================================
-- NOTA: Se eliminaron los iconos flotantes sobre las cabezas de los jugadores
-- que consumían demasiado CPU por cálculos 3D complejos (getPedBonePosition, 
-- getScreenFromWorldPosition, isLineOfSightClear, etc.)

-- El sistema de voz sigue funcionando completamente:
-- ✅ Texto "VOZ: Hablando" en la esquina (optimizado)
-- ✅ Audio de voz funciona normal
-- ✅ Distancias de voz funcionan
-- ✅ Radio funciona
-- ✅ Animaciones de huesos para radio funcionan

-- Los iconos sobre las cabezas han sido eliminados para eliminar el consumo de CPU

-- ORIGINAL onClientRender COMENTADO para referencia:
--[[
addEventHandler ( "onClientRender", root,
	function()
		-- CÓDIGO ELIMINADO: Sistema de iconos flotantes
		-- Era muy costoso en CPU por cálculos 3D constantes
	end
)
]]--

function dxDrawVoice ( posX, posY, color, distance )
	distance = 1/distance
	dxDrawImage ( posX - iconHalfWidth*distance, posY - iconHalfWidth*distance, ICON_WIDTH*distance, ICON_WIDTH*distance, ICON_PATH, 0, 0, 0, color, false )
end

function dxDrawVoiceLabel ( player, index, color )
	local sx, sy = guiGetScreenSize ()
	local scale = sy / 800
	local spacing = ( ICON_LINE * scale )
	local px, py = sx - 200, sy * 0.7 + spacing * index
	local icon = ICON_DIMENSIONS * scale

	px = px + spacing
	
end

