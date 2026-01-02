local _blips = {}
addEvent('AgregarBlips', true)


GUIEditor = {
    staticimage = {},
    edit = {},
    button = {},
    window = {},
    label = {},
    gridlist = {}
}

GUIEditor.window[1] = guiCreateWindow(0.16, 0.12, 0.62, 0.63, "Creador de Blips", true)
guiWindowSetSizable(GUIEditor.window[1], false)
GUIEditor.window[1].visible = false

GUIEditor.gridlist[1] = guiCreateGridList(0.02, 0.10, 0.29, 0.83, true, GUIEditor.window[1])
guiGridListAddColumn(GUIEditor.gridlist[1], "Blips Creados", 0.9)
GUIEditor.gridlist[1]:addRow('polla')
GUIEditor.label[1] = guiCreateLabel(0.35, 0.07, 0.15, 0.04, "Nombre De El Blip", true, GUIEditor.window[1])
guiSetFont(GUIEditor.label[1], "default-bold-small")
guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)

GUIEditor.edit[1] = guiCreateEdit(0.32, 0.14, 0.21, 0.07, "", true, GUIEditor.window[1])

GUIEditor.label[2] = guiCreateLabel(0.35, 0.23, 0.15, 0.04, "Coordenadas De El Blip", true, GUIEditor.window[1])
guiSetFont(GUIEditor.label[2], "default-bold-small")
guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)

GUIEditor.edit[2] = guiCreateEdit(0.32, 0.29, 0.21, 0.07, "", true, GUIEditor.window[1])
GUIEditor.label[3] = guiCreateLabel(0.378, 0.294, 0.092, 0.063, "X", true, GUIEditor.window[1])
guiSetFont(GUIEditor.label[3], "default-bold-small")
guiSetProperty(GUIEditor.label[3], "AlwaysOnTop", "True")
guiLabelSetColor(GUIEditor.label[3], 0, 0, 0)
guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", true)
guiLabelSetVerticalAlign( GUIEditor.label[3], 'center' )

GUIEditor.edit[3] = guiCreateEdit(0.32, 0.38, 0.21, 0.07, "", true, GUIEditor.window[1])
GUIEditor.label[4] = guiCreateLabel(0.378, 0.384, 0.092, 0.063, "Y", true, GUIEditor.window[1])
guiSetFont(GUIEditor.label[4], "default-bold-small")
guiSetProperty(GUIEditor.label[4], "AlwaysOnTop", "True")
guiLabelSetColor(GUIEditor.label[4], 0, 0, 0)
guiLabelSetHorizontalAlign(GUIEditor.label[4], "center", true)
guiLabelSetVerticalAlign( GUIEditor.label[4], 'center' )

GUIEditor.edit[4] = guiCreateEdit(0.32, 0.48, 0.21, 0.07, "", true, GUIEditor.window[1])
GUIEditor.label[5] = guiCreateLabel(0.378, 0.481, 0.092, 0.063, "Z", true, GUIEditor.window[1])
guiSetFont(GUIEditor.label[5], "default-bold-small")
guiSetProperty(GUIEditor.label[5], "AlwaysOnTop", "True")
guiLabelSetColor(GUIEditor.label[5], 0, 0, 0)
guiLabelSetHorizontalAlign(GUIEditor.label[5], "center", true)
guiLabelSetVerticalAlign( GUIEditor.label[5], 'center' )

GUIEditor.button[1] = guiCreateButton(0.31, 0.56, 0.23, 0.06, "Obtener Coordenadas", true, GUIEditor.window[1])
guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
GUIEditor.label[6] = guiCreateLabel(0.72, 0.07, 0.15, 0.04, "ID Blip", true, GUIEditor.window[1])
guiSetFont(GUIEditor.label[6], "default-bold-small")
guiLabelSetHorizontalAlign(GUIEditor.label[6], "center", false)

GUIEditor.button[2] = guiCreateButton(0.32, 0.75, 0.21, 0.10, "Eliminar Blip", true, GUIEditor.window[1])
guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")

GUIEditor.label[7] = guiCreateLabel(0.88, 0.00, 0.08, 0.04, "Cerrar", true, GUIEditor.window[1])
guiSetFont(GUIEditor.label[7], "default-bold-small")
guiSetProperty(GUIEditor.label[7], "ClippedByParent", "False")
guiSetProperty(GUIEditor.label[7], "AlwaysOnTop", "True")
guiSetProperty(GUIEditor.label[7], "RiseOnClick", "False")
guiLabelSetHorizontalAlign(GUIEditor.label[7], "center", false)
guiLabelSetVerticalAlign(GUIEditor.label[7], "center")

GUIEditor.label[8] = guiCreateLabel(0.08, 0.06, 0.15, 0.04, "Blips Creados", true, GUIEditor.window[1])
guiSetFont(GUIEditor.label[8], "default-bold-small")
guiLabelSetHorizontalAlign(GUIEditor.label[8], "center", false)
GUIEditor.gridlist[2] = guiCreateGridList(0.645, 0.111, 0.304, 0.325, true, GUIEditor.window[1])
guiGridListAddColumn(GUIEditor.gridlist[2], "ID", 0.9)
for i= 0, 63 do
    GUIEditor.gridlist[2]:addRow(tostring(i))
end
GUIEditor.button[3] = guiCreateButton(0.69, 0.75, 0.21, 0.10, "Crear Blip", true, GUIEditor.window[1])
guiSetProperty(GUIEditor.button[3], "NormalTextColour", "FFAAAAAA")
GUIEditor.staticimage[1] = guiCreateStaticImage(0.71, 0.46, 0.18, 0.23, "radarset/0.png", true, GUIEditor.window[1])    

addCommandHandler('blipsadmins',
    function()
        GUIEditor.window[1].visible = true
        showCursor( true )
        addAndClear()
        guiSetInputMode ("no_binds")
    end
)

addEventHandler( "onClientGUIClick", root, 
    function(b,s)
        if s ~= 'up' then return end
        if source == GUIEditor.button[1] then
            GUIEditor.edit[2].text = tostring(localPlayer.position.x)
            GUIEditor.edit[3].text = tostring(localPlayer.position.y)
            GUIEditor.edit[4].text = tostring(localPlayer.position.z)
            for i=3,5 do
                if GUIEditor.label[i].visible ~= false then
                    GUIEditor.label[i].visible = false
                end
            end
        elseif source == GUIEditor.label[7] then
            GUIEditor.window[1].visible = false
            showCursor(false)
            guiSetInputMode( "allow_binds" )
        elseif source == GUIEditor.gridlist[2] then
            local id = GUIEditor.gridlist[2]:getItemText(GUIEditor.gridlist[2]:getSelectedItem(), 1)
            if id ~= '' then
                guiStaticImageLoadImage ( GUIEditor.staticimage[1], "radarset/"..id..".png" )
            end
        elseif source == GUIEditor.button[2] then
            local item = GUIEditor.gridlist[1]:getItemText(GUIEditor.gridlist[1]:getSelectedItem(), 1)
            if item ~= '' then
                GUIEditor.gridlist[1]:removeRow(GUIEditor.gridlist[1]:getSelectedItem())
                triggerServerEvent('onServerRemoveBlip', root, item)
                remove(_blips, item)
            end
        elseif source == GUIEditor.button[3] then
            local nm = GUIEditor.edit[1].text
            if nm ~= '' and nm ~= ' ' and nm ~= '  ' then
                if not table.find(_blips, nm) then
                    if GUIEditor.edit[2].text ~= '' and GUIEditor.edit[3].text ~= '' and GUIEditor.edit[4].text ~= '' then
                        local id = GUIEditor.gridlist[2]:getItemText(GUIEditor.gridlist[2]:getSelectedItem(), 1)
                        if id ~= '' then
                            table.insert(_blips, nm)
                            GUIEditor.gridlist[1]:addRow(nm)
                            triggerServerEvent('onServerCreateBlip', root, nm, tonumber(GUIEditor.edit[2].text),tonumber(GUIEditor.edit[3].text),tonumber(GUIEditor.edit[4].text), tonumber(id))
                        else
                            outputChatBox('Selecciona un ID')
                        end
                    else
                        outputChatBox('Deve por todas posi�oes corretas.')
                    end
                else
                    outputChatBox('Este Nome de Blip ja existe')
                end
            end
        end
    end
)

addEventHandler("onClientGUIChanged", guiRoot, function(element) 
    if source == element then
        for i= 2,4 do
            if GUIEditor.edit[i] == element then
                if element.text:len() == 0 then
                    GUIEditor.label[i+1].visible = true
                    break
                else
                    GUIEditor.label[i+1].visible = false
                    break
                end
            end
        end
    end
end)

addEventHandler('AgregarBlips', localPlayer,
    function(qh)
        for i,v in ipairs(qh) do
            table.insert(_blips, v.Nombre)
        end
    end
)

function addAndClear()
    GUIEditor.gridlist[1]:clear()
    for i,v in ipairs(_blips) do
        GUIEditor.gridlist[1]:addRow(v)
    end
end

function table.find(t,value)
    for k,v in pairs(t) do
        if (v:lower() == value:lower()) then
            return true
        end
    end
    return false
end

function remove(t,value)
    for k,v in pairs(t) do
        if (v == value) then
            table.remove(t, k)
            break
        end
    end
end