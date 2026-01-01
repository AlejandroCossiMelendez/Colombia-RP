-- Client Sistema de matrimonio DTRP - FrankGT

addEventHandler( 'onClientResourceStart', resourceRoot,
function( )
	-------- Iglesia DTRP
	local iglesiaboda = playSound3D( "https://www.youtube.com/watch?v=_42dJYuTtw8&ab_channel=LiveyourDreams", 369.88330078125, 2324.333984375, 1890.60742187, true )
	setElementDimension( iglesiaboda, 596 )
	setElementInterior(iglesiaboda,3)
	setSoundVolume( iglesiaboda, 5 )
	setSoundMaxDistance(iglesiaboda, 3000 )
end
)