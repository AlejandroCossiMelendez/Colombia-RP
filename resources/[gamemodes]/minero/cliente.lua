cacheNPC = {}
isWorking = false


GUIEditor = {
    edit = {},
    button = {},
    window = {},
    label = {},
    gridlist = {}
}

precio = {
    hierro = 10,
    carbon = 7,
    bauxita = 12
}

addEventHandler( "onClientResourceStart", resourceRoot,
    function()
        GUIEditor.window[1] = guiCreateWindow(0.28, 0.34, 0.44, 0.33, "Minero", true)
        guiWindowSetSizable(GUIEditor.window[1], false)
        GUIEditor.window[1]:setVisible(false)

        GUIEditor.gridlist[1] = guiCreateGridList(0.02, 0.11, 0.53, 0.67, true, GUIEditor.window[1])
        guiGridListAddColumn(GUIEditor.gridlist[1], "Material", 0.5)
        guiGridListAddColumn(GUIEditor.gridlist[1], "Precio", 0.5)
        GUIEditor.edit[1] = guiCreateEdit(0.60, 0.29, 0.33, 0.13, "", true, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(0.66, 0.11, 0.22, 0.12, "Gananacia: $", true, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetColor(GUIEditor.label[1], 70, 231, 0)
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        GUIEditor.button[1] = guiCreateButton(0.08, 0.82, 0.33, 0.13, "Trabajar", true, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(0.60, 0.49, 0.33, 0.13, "Vender Seleccionado", true, GUIEditor.window[1])
        GUIEditor.button[3] = guiCreateButton(0.60, 0.82, 0.33, 0.13, "Salir", true, GUIEditor.window[1])


        engineLoadTXD('files/pico.txd')

        EngineDFF ('files/pico.dff'):replace(337)
        EngineTXD ('files/pico.txd'):import(337)

    end
)

addEventHandler( "onClientGUIClick", root,
    function(button, state)
        if button == 'left' then
            if state == 'up' then
                if GUIEditor.button[1] == source then
                    --if not isWorking then
                        isWorking = true
                        Server.giveWeapon(localPlayer, 6, 1, true)
                        GUIEditor.window[1]:setVisible(false)
                        showCursor(false)
                    --end
                elseif GUIEditor.button[2] == source then

                    if #GUIEditor.edit[1].text > 0 then
                        local num = math.abs(math.floor(tonumber(GUIEditor.edit[1].text)))
                        local mineral = GUIEditor.gridlist[1]:getItemText(GUIEditor.gridlist[1]:getSelectedItem(), 1)
                        local minerales = localPlayer:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}

                        if precio[mineral] then
                            if num <= minerales[mineral] then

                                outputChatBox('Recibiste $'..(precio[mineral]*num)..' por vender '..num..' de '..mineral, 0, 255, 0)
                                triggerServerEvent('minero:giveDinero', localPlayer, precio[mineral]*num)
                                minerales[mineral] = minerales[mineral] - num
                                localPlayer:setData('minero:minerales', minerales)     

                            end
                        end
                    end

                elseif GUIEditor.button[3] == source then
                    GUIEditor.window[1]:setVisible(false)
                    showCursor(false)
                end
            end
        end
    end
)

addEventHandler( "onClientGUIChanged", getRootElement(),
    function()
        if source == GUIEditor.edit[1] then
            local text = source.text
            if tonumber(text) then

                local num = math.abs(math.floor(tonumber(text)))
                local mineral = GUIEditor.gridlist[1]:getItemText(GUIEditor.gridlist[1]:getSelectedItem(), 1)

                local minerales = localPlayer:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}
                local current = minerales[mineral]

                if precio[mineral] and current >= num then
                    GUIEditor.label[1].text = 'Gananacia: $'..precio[mineral]*num
                else
                    source.text = text:sub(1,#text-1)
                    GUIEditor.label[1].text = 'Gananacia: $'
                end

            else
                source.text = text:sub(1,#text-1)
                GUIEditor.label[1].text = 'Gananacia: $'
            end
        end
    end
)



addEventHandler( "onClientClick", getRootElement(),
    function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
        if button == 'left' then
            if state == 'down' then
                if isElement(clickedElement) then
                    if clickedElement.type == 'ped' then
                        if (clickedElement:getID() == 'npc:minero') then
                            if GUIEditor.window[1]:getVisible() == false then
                                showCursor(false)
                                GUIEditor.window[1]:setVisible(true)
                                showCursor(true)


                                GUIEditor.gridlist[1]:clear()


                                local minerales = localPlayer:getData('minero:minerales') or {hierro=5, carbon=10, bauxita=0, acero=0, polvora=0, aluminio=0}
                                GUIEditor.gridlist[1]:addRow('hierro',''..precio.hierro)
                                GUIEditor.gridlist[1]:addRow('carbon',''..precio.carbon)
                                GUIEditor.gridlist[1]:addRow('bauxita',''..precio.bauxita)
                                
                            end
                        end
                    end
                end
            end
        end
    end
)

function noNPCDmg(self)
    if (source:getID() == 'npc:minero') then
        cancelEvent(  )
    end
end
addEventHandler( "onClientPedDamage", getRootElement(), noNPCDmg )

function streamNPC(self)
    if (source.type == 'ped') then
        if (source:getID() == 'npc:minero') then
            if (eventName:find('In')) then
                cacheNPC[source] = true
            else
                if cacheNPC[source] then
                    copyTableIgnoreKey(cacheNPC, source)
                end
            end
        end
    end
end

function copyTableIgnoreKey(t, key)
    local copy = {}
    for k,v in pairs(t) do
        if (k ~= key) then
            rawset(copy, k, v)
        end
    end
    t = copy
end

--[[bindKey("m","down",
    function()
        if localPlayer:isWithinColShape(zoneMina) then
            showCursor(not isCursorShowing())
        end
    end
)]]

Server = setmetatable({},{
    __index=function(self, f)
        return function(...)
            triggerServerEvent('Minero:functionCallBack', localPlayer, f, ...)
        end
    end
})