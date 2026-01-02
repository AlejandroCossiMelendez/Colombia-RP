--[[
LISTADO DE MODS OBLIGATORIOS PARA EL JUGADOR:
 ID 88 PERRO 1
 ID 89 PERRO 2
 ID 243 PERRO 3
 ID 244 PERRO 4
 ID 252 PERRO 5
 ID 279 TRAJE BUZO
 ID 431 BUS
 ID 525 GRUA CON COLOR
 ID 578 DFT-30 ES GRUA NUEVA
 ID 604 PATRULLA 5 SUSTITUYE AL DAMAGED GLENDALE, POR ESO ES OBLIGATORIO
 ID 9 Uniforme PD Femenino Blanco
 ID 10 Uniforme PD Femenino Negro
 ID 278 Uniforme MD Femenino
 ID 416 AMBULANCIA
 ID 508 CARAVANA ENTRABLE
]]

-- Función auxiliar para cargar y reemplazar modelos de forma segura
local function safeLoadModel(txdPath, dffPath, modelID)
	if not txdPath or not dffPath or not modelID then
		outputDebugString("descargadorv2: Invalid parameters for model " .. tostring(modelID), 1)
		return false
	end
	
	local txd = engineLoadTXD(txdPath, modelID)
	if not txd then
		outputDebugString("descargadorv2: Failed to load TXD: " .. txdPath, 1)
		return false
	end
	
	if not engineImportTXD(txd, modelID) then
		outputDebugString("descargadorv2: Failed to import TXD for model " .. tostring(modelID), 1)
		return false
	end
	
	local dff = engineLoadDFF(dffPath, modelID)
	if not dff then
		outputDebugString("descargadorv2: Failed to load DFF: " .. dffPath, 1)
		return false
	end
	
	if not engineReplaceModel(dff, modelID) then
		outputDebugString("descargadorv2: Failed to replace model " .. tostring(modelID), 1)
		return false
	end
	
	return true
end

function reemplazarModelosObligatorios() 
  -- Cargar modelos con validación de errores
  safeLoadModel("mods/Mascotas/88.txd", "mods/Mascotas/88.dff", 88)
  safeLoadModel("mods/Mascotas/89.txd", "mods/Mascotas/89.dff", 89)
  safeLoadModel("mods/Mascotas/243.txd", "mods/Mascotas/243.dff", 243)
  safeLoadModel("mods/Mascotas/244.txd", "mods/Mascotas/244.dff", 244)
  safeLoadModel("mods/Mascotas/252.txd", "mods/Mascotas/252.dff", 252)
  safeLoadModel("mods/Skins/279.txd", "mods/Skins/279.dff", 279)
  -- safeLoadModel("mods/Vehs Facciones/431.txd", "mods/Vehs Facciones/431.dff", 431) -- Comentado
  safeLoadModel("mods/Vehs Facciones/525.txd", "mods/Vehs Facciones/525.dff", 525)
  safeLoadModel("mods/Vehs Facciones/578.txd", "mods/Vehs Facciones/578.dff", 578)
  safeLoadModel("mods/Vehs Facciones/604.txd", "mods/Vehs Facciones/604.dff", 604)
  safeLoadModel("mods/Skins/278.txd", "mods/Skins/278.dff", 278)
  safeLoadModel("mods/Skins/9.txd", "mods/Skins/9.dff", 9)
  safeLoadModel("mods/Vehs Facciones/416.txd", "mods/Vehs Facciones/416.dff", 416)
  safeLoadModel("mods/Vehs LowPoly/journey.txd", "mods/Vehs LowPoly/journey.dff", 508)
  safeLoadModel("mods/Skins/10.txd", "mods/Skins/10.dff", 10)
  
  outputDebugString("descargadorv2: Modelos obligatorios cargados", 3)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarModelosObligatorios)