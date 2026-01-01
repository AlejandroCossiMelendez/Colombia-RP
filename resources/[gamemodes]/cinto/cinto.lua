MensageRetirarCinto = "Cinturón de seguridad retirado."
MensageColocarCinto = "Cinturón de seguridad colocado."
MensageChoqueSinCinto = "Has perdido vida por no tener el cinturon de seguridad puesto."
MensageEntrarVehi = "Aprieta C para colocarte el cinturón de seguridad."
MensageSalirConCinto = "Retira el cinturon para salir del vehiculo." 



function bateusemcinto(loss) 
    
    local thePlayer = getVehicleOccupant(source)
    local latariaPerdida = tonumber(loss)
    if getVehicleType(source) == "Bike" or getVehicleType(source) == "BMX" then return end
        if thePlayer and loss > 50 then
            if not getElementData ( thePlayer, "Cinto", true ) then
                local dano = latariaPerdida / 15 
                setElementHealth ( thePlayer, getElementHealth(thePlayer) - dano ) -- Vida perdida ao bater sem cinto
                exports.dxmessages:outputDx(thePlayer, MensageChoqueSinCinto, "info")
            else
            --exports.dxmessages:outputDx(thePlayer, "Você bateu porem estava com cinto e não levou dano! ", "info")
            end
    end
end
addEventHandler("onVehicleDamage", getRootElement(), bateusemcinto)


function colocarcinto(source)
    if getVehicleType(getPedOccupiedVehicle(source)) == "Bike" or getVehicleType(getPedOccupiedVehicle(source)) == "BMX" then return end
    if ( isPedInVehicle( source ) ) then 
        if not getElementData ( source, "Cinto", true ) then
        setElementData (source, "Cinto", true )
        exports.dxmessages:outputDx(source, MensageColocarCinto , "success")
        else
        setElementData (source, "Cinto", false )
        exports.dxmessages:outputDx(source, MensageRetirarCinto , "error")
        end
        else 
        --exports.dxmessages:outputDx(source, "Entre em um carro para colocar ou retirar o cinto!" , "error")
    end 
end 

function restart()
for index, player in ipairs(getElementsByType("player")) do
bindKey(player, "c" , "down", colocarcinto)
end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), restart)

function entrar()
bindKey(source, "c" , "down", colocarcinto)
end
addEventHandler("onPlayerJoin", getRootElement(), entrar)

function fechar(player)
for index, player in ipairs(getElementsByType("player")) do
unbindKey(player,"c", "down", colocarcinto)
end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), fechar)

function entrouv (thePlayer, seat, jacked)
    if getVehicleType(getPedOccupiedVehicle(thePlayer)) == "Bike" or getVehicleType(getPedOccupiedVehicle(thePlayer)) == "BMX" then return end
exports.dxmessages:outputDx(thePlayer, MensageEntrarVehi , "info")
end
addEventHandler ( "onVehicleEnter", getRootElement(), entrouv )

function saiuv (thePlayer, seat, jacked)
if getVehicleType(getPedOccupiedVehicle(thePlayer)) == "Bike" or getVehicleType(getPedOccupiedVehicle(thePlayer)) == "BMX" then return end
if getElementData ( thePlayer, "Cinto", true ) then
cancelEvent()
exports.dxmessages:outputDx(thePlayer, MensageSalirConCinto , "error")
end
end
addEventHandler ( "onVehicleStartExit", getRootElement(), saiuv )