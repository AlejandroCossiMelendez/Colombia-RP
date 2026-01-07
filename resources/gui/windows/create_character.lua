--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay

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

-- MANTENER VARIABLES ORIGINALES PARA COMPATIBILIDAD
local messageTimer
local messageCount = 0
local timer

-- MANTENER FUNCIÓN setMessage PARA COMPATIBILIDAD
local function setMessage(text)
    if windows.create_character and #windows.create_character > 0 then
        windows.create_character[#windows.create_character].text = text or ""
    end
    
    if messageTimer then
        killTimer(messageTimer)
    end
    messageCount = 0
    setTimer(
        function()
            messageCount = messageCount + 1
            if messageCount == 50 then
                if windows.create_character and #windows.create_character > 0 then
                    windows.create_character[#windows.create_character].text = ""
                end
                messageTimer = nil
            else
                if windows.create_character and #windows.create_character > 0 then
                    windows.create_character[#windows.create_character].color = { 255, 255, 255, 5 * ( 50 - messageCount ) }
                end
            end
        end, 100, 50
    )
end

-- FUNCIÓN PARA ABRIR LA NUEVA INTERFAZ
local function openNewInterface()
    outputDebugString("[CREATECHAR] openNewInterface llamado")
    hide() -- Cerrar la interfaz antigua
    
    -- Verificar si el recurso de la nueva interfaz está disponible
    local newInterfaceResource = getResourceFromName("Interfaz-CreacionPJ") 
    outputDebugString("[CREATECHAR] Recurso Interfaz-CreacionPJ: " .. tostring(newInterfaceResource and "existe" or "no existe"))
    if newInterfaceResource then
        local state = getResourceState(newInterfaceResource)
        outputDebugString("[CREATECHAR] Estado del recurso: " .. tostring(state))
        if state == "running" then
            -- Usar export function
            outputDebugString("[CREATECHAR] Llamando a showCreateCharacterInterface via export")
            if exports["Interfaz-CreacionPJ"] and exports["Interfaz-CreacionPJ"].showCreateCharacterInterface then
                exports["Interfaz-CreacionPJ"]:showCreateCharacterInterface()
            else
                outputDebugString("[CREATECHAR] ERROR: Export function no disponible, usando event")
                triggerEvent("showNewCharacterInterface", localPlayer)
            end
        else
            outputDebugString("[CREATECHAR] Recurso no está running, usando event")
            triggerEvent("showNewCharacterInterface", localPlayer)
        end
    else
        outputDebugString("[CREATECHAR] Recurso no encontrado, usando event")
        -- Fallback: usar event
        triggerEvent("showNewCharacterInterface", localPlayer)
    end
end

-- DESHABILITADA: tryCreate - La nueva interfaz maneja la creación
local function tryCreate(key)
    -- Redirigir automáticamente a la nueva interfaz
    openNewInterface()
    return
end

-- MANTENER FUNCIÓN cancelCreate ORIGINAL
local function cancelCreate()
    if exports.players:isLoggedIn() then
        hide()
    else
        show('characters', true, true, true)
    end
end

-- REEMPLAZAR DEFINICIÓN DE VENTANA CON BOTÓN PARA ABRIR NUEVA INTERFAZ
windows.create_character = {
    {
        type = "label",
        text = "Nueva Interfaz Disponible",
        font = "bankgothic",
        alignX = "center",
    },
    {
        type = "label",
        text = "Se ha actualizado la interfaz de creación\nde personajes con una nueva experiencia\nvisual y funcionalidades mejoradas.\n\n¡Haz clic para usar la nueva interfaz!",
        alignX = "center",
    },
    {
        type = "button",
        text = "Crear Nuevo Personaje",
        onClick = openNewInterface,
    },
    {
        type = "button",
        text = "Volver a Selección",
        onClick = cancelCreate,
    },
    {
        type = "label",
        text = "", -- Este es el texto que setMessage modifica
        alignX = "center",
        color = { 255, 255, 255, 255 }
    }
}

-- MANTENER EVENT HANDLER ORIGINAL PARA COMPATIBILIDAD COMPLETA
addEvent("players:characterCreationResult", true)
addEventHandler("players:characterCreationResult", getLocalPlayer(),
    function(code)
        if code == 0 then
            -- No mostrar selección si estamos en proceso de spawn directo
            local directSpawn = getElementData(getLocalPlayer(), "direct_spawn_process")
            if directSpawn then
                return -- No hacer nada, la nueva interfaz maneja el spawn directo
            end
            
            if exports.players:isLoggedIn() then
                show('characters', false, false, true)
            else
                show('characters', true, true, true)
            end
        elseif code == 1 then
            setMessage("Ya existe un personaje con ese nombre.")
        end
    end
)
