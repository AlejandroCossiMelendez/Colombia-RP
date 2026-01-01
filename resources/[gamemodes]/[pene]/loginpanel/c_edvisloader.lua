	addEvent('onDestroyLoginPanel',true)
addEventHandler( 'onDestroyLoginPanel', getLocalPlayer(),
function()

if exports.players:isLoggedIn() then
	setTimer ( function()
	triggerEvent("ver:vinilos", getLocalPlayer())
	end, 5000, 1 )
end
	
	
end)