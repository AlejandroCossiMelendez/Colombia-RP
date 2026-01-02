MarkerCurar = createMarker(-325.806, 1062.979, 19.742 -1, "cylinder", 2,58,255,84,50)
ValorCurar = 270000

function mensagem(source)
	outputChatBox("#0EFF2F[Ayuda] #FFFFFFReanimate sin necesidad de un medico con el comando #0EFF2F/curarme.", source, 255,255,255,true)
end
addEventHandler("onMarkerHit", MarkerCurar, mensagem)

function tratamento(source)
   if not getElementData(source, "muerto") then
	outputChatBox("[Error] No puedes reanimarte, debes estar muerto", source, 255, 0, 0)
	  else
	if isElementWithinMarker(source, MarkerCurar) then
		local Money = tonumber(getPlayerMoney(source))
		local vida = tonumber(getElementHealth(source))
		if Money >= ValorCurar then
			if vida < 100 then
				takePlayerMoney(source, ValorCurar)
				setElementPosition(source, -315.3828125, 1050.0576171875, 20.340259552002)
				triggerClientEvent(source, "progressBar", source, 10000, "Byagogo")
				setPedAnimation(source,"crack", "crckdeth1", 10000, true, false, false, false)
				toggleAllControls(source, false)
				setElementData(source, "ST:Curando", true)
				outputChatBox("#0EFF2F[Info] #FFFFFFTratamiento iniciado", source, 255,255,255,true)
				setTimer(function()					
					setPedAnimation(source, false)
					toggleAllControls(source, true)
					setElementData(source, "ST:Curando", false)
				        removeElementData(source, "muerto")
						exports.items:guardarArmas(source, true)
					setElementHealth(source, 100)
					--setElementPosition(source, -316.0341796875, 1055.9853515625, 19.7421875)
					spawnPlayer( source, -316.0341796875, 1055.9853515625, 19.7421875, 180, getElementModel( source ), 0, 0 )
					setElementRotation(source, -0, 0, 179.32563781738)
				        exports.chat:me(source, "Se revisa todo el cuerpo verificando su estado de salud")
                                        outputChatBox("#0EFF2F[Ayuda] #FFFFFFTratamiento finalizado", source, 255,255,255,true)
				end, 10000, 1)
			else
				outputChatBox("#FF0E0E[Error] No requieres una reanimacion", source, 255,255,255,true)
			end
		else
			outputChatBox("#FF0E0E[Error] No tienes los #0EFF2F270,000 #FF0E0EQue cuesta la reanimacion.", source, 255,255,255,true)
		end
	  end
    end
end
addCommandHandler("curarme", tratamento)