--===================================================
--= Script feito por:
--== ● Strawer Store ● 
--== Discord: https://discord.gg/sryEua4
--===================================================
--== Qualquer problema procure nossa equipe.
--===================================================

WeaponID = {
	[28] = true,
}

addEventHandler('onPlayerWeaponSwitch', getRootElement(),
	function(previousWeaponID, currentWeaponID)
		if (WeaponID[currentWeaponID] ) then
			toggleControl(source, 'fire', false) -- Desativa o tiro da arma.
			toggleControl(source, 'action', false) -- Desativa o tiro da arma.
			setPlayerHudComponentVisible(source, "crosshair", false) -- Desativa a mira.
		else
			toggleControl(source, 'fire', true) -- Ativa o tiro da arma.
			toggleControl(source, 'action', true) -- Ativa o tiro da arma.
			setPlayerHudComponentVisible(source, "crosshair", true) -- Ativa a mira.
		end
	end
)

local tempoApontar = {}

function addApontar(p)
if tempoApontar[p] then 
	return outputChatBox("Você está fazendo isso rápido dms", p, 255, 255, 255, true)
end
tempoApontar[p] = true -- Seta como true pra evitar os jogadores bugarem a arma.
giveWeapon(p, 28, 1, true)
	setTimer(function()
		tempoApontar[p] = nil -- Seta como nil dps de 1 segundo pros jogadores apontarem novamente.
	end, 1000, 1)
end
addEvent("addApontar", true)
addEventHandler("addApontar", getRootElement(), addApontar)

function removerApontar(p)
takeWeapon(p, 28)
end
addEvent("removerApontar", true)
addEventHandler("removerApontar", getRootElement(), removerApontar)

