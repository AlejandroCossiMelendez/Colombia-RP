-- handle this serverside for better sync

function gameOver()
	setPedHeadless(source, true)
	setElementHealth(source, 0)
end
addEvent ("onGameOver", true)
addEventHandler ("onGameOver", getRootElement(), gameOver)