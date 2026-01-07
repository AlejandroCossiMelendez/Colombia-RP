--===================================================
--= Script feito por:
--== ● Strawer Store ● 
--== Discord: https://discord.gg/sryEua4
--===================================================
--== Qualquer problema procure nossa equipe.
--===================================================

---------------------------------------------------------
txd = engineLoadTXD("files/invisible.txd", 352)
engineImportTXD(txd, 352 )
dff = engineLoadDFF("files/invisible.dff", 352)
engineReplaceModel(dff, 352 )
----------------------------------------------------------


bindKey("mouse2", "down", 
	function() 
	if getPedOccupiedVehicle(localPlayer) then -- Só autoriza o evento caso ele não esteja em um veículo.
		return
	end
	if getPedMoveState(localPlayer) == "crouch" then -- Só autoriza o evento caso ele não esteja agachado.
		return
	end
	if getPlayerWeapon(localPlayer) == 0 then -- Verifica se ele ta sem arma na mão, caso esteja ele autoriza o evento de apontar.
		triggerServerEvent("addApontar", getRootElement(), localPlayer)
	end
end
)


bindKey("mouse2", "up", 
	function() 
	if getPlayerWeapon(localPlayer) == 28 then 
				triggerServerEvent("removerApontar", getRootElement(), localPlayer)
			end
	end
)


addEventHandler("onClientPlayerWeaponFire",localPlayer,function()
	if (getPedWeapon(localPlayer) == 28) then 
      cancelEvent() -- Cancela o dano da arma pra caso de alguma forma o jogador consiga bugar a arma ele não matar ninguém.
    end
end)
