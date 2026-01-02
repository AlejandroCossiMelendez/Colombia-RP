-- Sistema de Cursor Toggle con tecla M
-- Muestra el cursor solo mientras se mantiene presionada la tecla M
-- Funciona independientemente del freecam y otros sistemas

local mKeyPressed = false
local cursorStateBeforeM = false -- Guardar el estado del cursor antes de presionar M

-- Detectar cuando se presiona M
addEventHandler("onClientKey", root, function(key, press)
    if key == "m" then
        if press then
            -- Presionar M: mostrar cursor
            if not mKeyPressed then
                mKeyPressed = true
                -- Guardar el estado actual del cursor
                cursorStateBeforeM = isCursorShowing()
                -- Mostrar cursor
                showCursor(true)
            end
        else
            -- Soltar M: restaurar estado anterior del cursor
            if mKeyPressed then
                mKeyPressed = false
                -- Restaurar el estado del cursor que tenía antes de presionar M
                -- Pero solo si no hay un GUI abierto que necesite el cursor
                local hasGUI = false
                
                -- Verificar ventanas GUI visibles
                local windows = getElementsByType("gui-window", resourceRoot)
                for _, window in ipairs(windows) do
                    if isElement(window) and guiGetVisible(window) then
                        hasGUI = true
                        break
                    end
                end
                
                -- Si no hay GUI abierto, restaurar el estado anterior
                if not hasGUI then
                    showCursor(cursorStateBeforeM)
                end
                -- Si hay GUI abierto, mantener el cursor visible (el GUI lo maneja)
            end
        end
    end
end)

