--[[
Creado por : Edvis20 

Servidor : ExoticRP

2020
]]

local edit = false

function startPaste()
    edit = guiCreateEdit(3000, 3000, 200, 200, '', false, false)
    guiBringToFront(edit)

    addEventHandler('onClientRender', root, paste_render)
    addEventHandler('onClientKey', root, paste_key)
end

function paste_render()
    if (getKeyState('lctrl') or getKeyState('rctrl')) and getKeyState('v') then
        local text = guiGetText(edit) or ''
        setSelectedEditBoxTextImportant(text)
    end
end

function paste_key()
    if press and (getKeyState('lctrl') or getKeyState('rctrl')) and (getKeyState('c') or getKeyState('a')) then
        cancelEvent()
    end
end

function stopPaste()
    if edit and isElement(edit) then
        destroyElement(edit)
    end

    removeEventHandler('onClientRender', root, paste_render)
    removeEventHandler('onClientKey', root, paste_key)
end