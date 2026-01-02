-------------------------------------- Sistema de importación de drogas DTRP ---------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
----------------- Autor: FrankGT - Jefferson -----------------------------------------------------------------------------------
-- Nueva edición 15/06/2024: se ha añadido por packs de armas 4 unidades por tipo de arma y fixeadas las balas.

function ComprarArmasIlegal(nombreArmasL)

	if exports.factions:isPlayerInFaction( source, 51 ) or exports.factions:isPlayerInFaction( source, 55 ) or exports.factions:isPlayerInFaction( source, 102 ) then
	
	    if(nombreArmasL == "arma_ak47") then
			if exports.players:takeMoney(source, 15000000 ) then
				outputChatBox("Has comprado una AK-47 en 15.000.000$ - revisa inventario.", source, 0, 255, 0)
			    outputChatBox("Vladimir Tripalowsky te entrega una caja con Una Arma.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de AK-47 en 15.000.000$.")
				-- por ahora se ha definido por 45000 una caja con 4 aks con 200 balas
				exports.items:give(source, 29, "30", "Arma 30", 2)
			else
				outputChatBox("(( Dinero Insuficiente para: AK-47 - 15.000.000$ ))", source, 255, 0, 0)
			end
			
		elseif(nombreArmasL == "arma_uzi") then
			if exports.players:takeMoney(source, 12000000 ) then
				outputChatBox("Has comprado una  uzi en 12000000$ - revisa inventario.", source, 0, 255, 0)
			    outputChatBox("Vladimir Tripalowsky te entrega una caja con Una Arma.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de UZI en 12000000$")
			    -- por ahora se ha definido por 36000 una caja con 4 uzis con 130 balas
				exports.items:give(source, 29, "28", "Arma 28", 2)
			else
				outputChatBox("(( Dinero Insuficiente para: UZI - 12.000.000$ ))", source, 255, 0, 0)
			end
			
		elseif(nombreArmasL == "arma_pistola") then
			if exports.players:takeMoney(source, 8000000 ) then
				outputChatBox("Has comprado una  pistola en 8.000.000$ -  revisa inventario.", source, 0, 255, 0)
				outputChatBox("Vladimir Tripalowsky te entrega una caja con Una Arma.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de 9mm Colt.45 en 8000000$.")
			    -- por ahora se ha definido por 26000 una caja con 4 pistolas con 100 balas
				exports.items:give(source, 29, "22", "Arma 22", 2)
			else
				outputChatBox("(( Dinero Insuficiente para: Pistola Colt.45 - 8.000.000$ ))", source, 255, 0, 0)
			end
		
		elseif(nombreArmasL == "arma_recortada") then
			if exports.players:takeMoney(source, 30000000 ) then
				outputChatBox("Has comprado una  recortada en 30.000.000$ - revisa inventario.", source, 0, 255, 0)
				outputChatBox("Vladimir Tripalowsky te entrega una caja con Una Arma.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de Recortadas en 30.000.000$.")
			    -- por ahora se ha definido por 39000 una caja con 4 recortadas.
				exports.items:give(source, 29, "26", "Arma 26", 2)
			else
				outputChatBox("(( Dinero Insuficiente para: Recortada - 30.000.000$ ))", source, 255, 0, 0)
			end
		end	
	else
		outputChatBox ("[Ruso] Vladimir Tripalowsky dice: ¿Tu quien eres y como has entrado? Verás!.", source, 230, 230, 230)
		outputChatBox("Vladimir Tripalowsky te pega con la culata de la pistola en la cabeza.", source, 255, 40, 80)
		outputChatBox("* Te meterían en una furgoneta de melocotones y te arrojarían en la carretera (( Vladimir Tripalowsky )).", source, 255, 255, 0)
        setElementPosition(source,348.615234375, 1001.5029296875, 28.721237182617)
		setElementDimension(source,0)
		setElementInterior(source,0)
	end

end
addEvent("PanelComprarArmasAntiHackersPorfavorNomas", true)
addEventHandler("PanelComprarArmasAntiHackersPorfavorNomas", getRootElement(), ComprarArmasIlegal)



local function crearPedArmasLoco( )
	if armamentoped then
		destroyElement( armamentoped )
	end
	armamentoped = createPed( 59,  1293.632, -220.613, 2.620)
	setElementInterior(armamentoped,0)
	setElementDimension(armamentoped,0)
	setElementData( armamentoped, "npcname", "Vladimir Tripalowsky" )
	setTimer(setElementFrozen, 2000, 1, armamentoped, true) 
end

addEventHandler( "onPedWasted", resourceRoot, crearPedArmasLoco )
addEventHandler( "onResourceStart", resourceRoot, crearPedArmasLoco )


addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local x, y, z = getElementPosition( player )
			if getDistanceBetweenPoints3D( x, y, z, getElementPosition( source ) ) < 5 and getElementDimension( player ) == getElementDimension( source ) and source == armamentoped then
				triggerClientEvent(player, "AbrirPanelArmasIlegal", player)
			end
		end
	end
)