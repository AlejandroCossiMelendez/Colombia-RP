zoneMina = ColShape.Sphere(670.94860839844, 910.58850097656, -39.126209259033, 10)
zoneMina2 = ColShape.Sphere(682.36755371094, 906.23107910156, -38.316257476807, 10)

setDevelopmentMode( true )


local procesar = createMarker(688.3984375, 844.41796875, -38.426982879639 -1, 'cylinder', 1, 2, 144, 255, 100)
setElementInterior(procesar, 0)
setElementDimension(procesar, 0)

addEventHandler("onClientRender", root,
function()
 if (getDistanceBetweenPoints3D(688.3984375, 844.41796875, -38.426982879639, getElementPosition(getLocalPlayer()))) < 5 then
  local coords = {getScreenFromWorldPosition(688.3984375, 844.41796875, -38.426982879639, 13.38990)}
  if coords[1] and coords[2] then
   dxDrawText("Digita '/procesar [Material]' para vender tus materiales", coords[1], coords[2], coords[1], coords[2], tocolor(250, 250, 250), 1.00, "default-bold", "center", "center", false, false, false, false, false)
  end
 end
end)


local screenW, screenH = guiGetScreenSize()
local segundos = 0

addEventHandler("onClientRender", root,
    function()
    	if localPlayer:isWithinColShape(zoneMina) or localPlayer:isWithinColShape(zoneMina2) then

        	dxDrawText("Usa /picar", (screenW * 0.8528) + 1.5, (screenH * 0.5000) + 1.5, (screenW * 0.9941) + 1.5, (screenH * 0.9753) + 1.5, tocolor(0, 0, 0, 255), 0.55, "bankgothic", "left", "top", false, false, false, false, false)
        	dxDrawText("Usa /picar", screenW * 0.8528, screenH * 0.5000, screenW * 0.9941, screenH * 0.9753, tocolor(254, 254, 254, 254), 0.55, "bankgothic", "left", "top", false, false, false, false, false)
    	
    	end
    end
)

addCommandHandler('procesar',
function(_, mat)
    if isElementWithinMarker(localPlayer, procesar) then
        if mat then
            local mineral1, slot1, v1 = exports.items:has(localPlayer, 50)
            local mineral2, slot2, v2 = exports.items:has(localPlayer, 51)
            local mineral3, slot3, v3 = exports.items:has(localPlayer, 52)
            local mat = mat:lower()
            if mat == "hierro" then
                if not mineral1 then
                    exports.infobox:addNotification( 'No tienes ese mineral, intenta con otro', "error" )
                    return 
                end
            elseif mat == "carbon" then
                if not mineral2 then 
                    exports.infobox:addNotification( 'No tienes ese mineral, intenta con otro', "error" )
                    return 
                end
            elseif mat == "bauxita" then
                if not mineral3 then 
                    exports.infobox:addNotification( 'No tienes ese mineral, intenta con otro', "error" )
                    return 
                end
            else
                exports.infobox:addNotification( 'Ese mineral no existe, digite uno valido', "error" )
                return
            end   
            if not procesando then
                procesando = true
                setElementFrozen( localPlayer, true )
                tick = getTickCount()
                
                local mineral1, slot1, v1 = exports.items:has(localPlayer, 50)
                if mat == "hierro" then 
                    triggerServerEvent( "minero:quitarMateriales", localPlayer, slot1 )
                    local material1 = v1.value - 1
                    if material1 ~= 0 then
                        triggerServerEvent( "minero:picarMateriales", localPlayer, 50, material1 )
                    end
                end
                local mineral2, slot2, v2 = exports.items:has(localPlayer, 51)
                if mat == "carbon" then
                    triggerServerEvent( "minero:quitarMateriales", localPlayer, slot2 )
                    local material2 = v2.value - 1
                    if material2 ~= 0 then
                        triggerServerEvent( "minero:picarMateriales", localPlayer, 51, material2 )
                    end
                end
                local mineral3, slot3, v3 = exports.items:has(localPlayer, 52)
                if mat == "bauxita" then
                    triggerServerEvent( "minero:quitarMateriales", localPlayer, slot3 )
                    local material3 = v3.value - 1
                    if material3 ~= 0 then
                        triggerServerEvent( "minero:picarMateriales", localPlayer, 52, material3 )
                    end
                end
                
                triggerEvent( "progressBar", resourceRoot, 8000, "Procesando" )
                setTimer(function(mat)
						triggerServerEvent( "minero:giveDinero", localPlayer, dineroAleatorio )
                        exports.infobox:addNotification( 'Has procesado ' .. mat ..  ' y ¡Lograste Venderlo!', "success" )
                        setElementFrozen(localPlayer, false)
                        procesando = false
                end, 8000, 1, mat)
            end
        else
            outputChatBox('Syntax: /procesar [material]', 255,0,0, true)
        end
    end
end)

local picando = false

function picarr(commandName)
    if picando then
        outputChatBox("¡Ya estás picando! Termina primero.", 255, 0, 0)
        return
    end

    if isElementWithinColShape(localPlayer, zoneMina) or isElementWithinColShape(localPlayer, zoneMina2) then
        if getPedWeapon(localPlayer) == 6 then
            if getElementData(localPlayer, "permiso:picar") ~= true then
                outputChatBox("No tienes permiso para picar, Ve a donde el encargado de la Mina.", 255, 0, 0)
                return
            end

            if getElementData(localPlayer, "minero:Picando") == true then return end
            if not TiempoPicar or not TiempoPicar:isValid() then
                setElementFrozen(localPlayer, true)
                tick = getTickCount()
                setElementData(localPlayer, "minero:Picando", true)
                picando = true

                triggerServerEvent("minero:animPicar", localPlayer)
                PicoSonido = Sound('files/pico.mp3', true)
                PicoSonido:setVolume(1)

                triggerEvent("progressBar", resourceRoot, 18000, "Picando")
                setTimer(function(localPlayer)
                    local mineralRandom = math.random(1, 7)
                    local random = math.random(1, 2)

                    local mineral1, slot1, v1 = exports.items:has(localPlayer, 50)
                    local mineral2, slot2, v2 = exports.items:has(localPlayer, 51)
                    local mineral3, slot3, v3 = exports.items:has(localPlayer, 52)

                    if mineralRandom == 1 then
                        if mineral1 then
                            local value = v1.value + random
                            triggerServerEvent("minero:quitarMateriales", localPlayer, slot1)
                            triggerServerEvent("minero:picarMateriales", localPlayer, 50, value)
                        else
                            triggerServerEvent("minero:picarMateriales", localPlayer, 50, random)
                        end
                    elseif mineralRandom == 2 or mineralRandom == 3 or mineralRandom == 4 or mineralRandom == 5 then
                        if mineral2 then
                            local value = v2.value + random
                            triggerServerEvent("minero:quitarMateriales", localPlayer, slot2)
                            triggerServerEvent("minero:picarMateriales", localPlayer, 51, value)
                        else
                            triggerServerEvent("minero:picarMateriales", localPlayer, 51, random)
                        end
                    elseif mineralRandom == 6 or mineralRandom == 7 then
                        if mineral3 then
                            local value = v3.value + random
                            triggerServerEvent("minero:quitarMateriales", localPlayer, slot3)
                            triggerServerEvent("minero:picarMateriales", localPlayer, 52, value)
                        else
                            triggerServerEvent("minero:picarMateriales", localPlayer, 52, random)
                        end
                    end
                    if isElement(PicoSonido) then
                        PicoSonido:destroy()
                    end
                    setElementFrozen(localPlayer, false)
                    setPedAnimation(localPlayer, nil)
                    setElementData(localPlayer, "minero:Picando", false)
                    picando = false
                end, 18000, 1, localPlayer)
            end
        end
    end
end
addCommandHandler("picar", picarr)

local npc = createPed(153, 585.580078125, 868.1875, -42.497318267822)

function clicEnNPC(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == "left" and state == "down" and clickedElement == npc then
        triggerServerEvent("solicitarPermisoPicar", localPlayer)
    end
end
addEventHandler("onClientClick", root, clicEnNPC)


