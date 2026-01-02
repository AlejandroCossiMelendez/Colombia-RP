function getPos (player)
	local x,y,z = getElementPosition(player)
	r1,r2,r3 = getElementRotation(player)
	outputChatBox("Tu rotación es: "..tostring(r1)..", "..tostring(r2)..", "..tostring(r3).."", player, 5, 46, 249 )
	outputChatBox("Tus coordenadas son:  x =  "..tostring(x)..",  y =  "..tostring(y)..",  z=  "..tostring(z).."", player, 5, 46, 249 )
end
addCommandHandler("getruta", getPos)
