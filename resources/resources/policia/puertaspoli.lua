-- Puertas definidas en la policia v1.
-- exports.items:has(thePlayer, 35,1)
function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end
-- 

pd1gate = createObject ( 3089, 253.1767578125, 107.607421875, 1003.5477294922, 0, 0, 90 )
setElementDimension ( pd1gate, 61 )
setElementInterior ( pd1gate, 10 )

function gatepd1c() 
	moveObject ( pd1gate, 2000, 253.1767578125, 107.607421875, 1003.5477294922 )
end
                                             
function gatepd1o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
	outputChatBox("Puerta 1 abierta.",thePlayer)   
	moveObject ( pd1gate, 2000, 253.17558288574, 106.58239746094, 1003.5477294922) 
	setTimer (gatepd1c, 3000, 1)
	end
end

addCommandHandler("pd1", gatepd1o)

pd2gate = createObject ( 3089, 253.1865234375, 110.580078125, 1003.5477294922, 0, 0, 270 )
setElementDimension ( pd2gate, 61 )
setElementInterior ( pd2gate, 10 )

function gatepd2c() 
	moveObject ( pd2gate, 2000, 253.1865234375, 110.580078125, 1003.5477294922 )
end
                                             
function gatepd2o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then  
	moveObject ( pd2gate, 2000, 253.19061279297, 111.58078765869, 1003.5477294922) 
	setTimer (gatepd2c, 3000, 1)
	end
end

addCommandHandler("pd1", gatepd2o)

-- 

pd3gate = createObject ( 3089, 239.625, 116.099609375, 1003.5477294922, 0, 0, 90 )
setElementDimension ( pd3gate, 61 )
setElementInterior ( pd3gate, 10 )

function gatepd3c() 
moveObject ( pd3gate, 2000, 239.625, 116.099609375, 1003.5477294922 )
end
                                             
function gatepd3o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
outputChatBox("Puerta 2 abierta.",thePlayer)   
moveObject ( pd3gate, 2000, 239.61683654785, 115.0743637085, 1003.5477294922) 
setTimer (gatepd3c, 3000, 1)
end
end

addCommandHandler("pd2", gatepd3o)

pd4gate = createObject ( 3089, 239.63491821289, 119.07646179199, 1003.5477294922, 0, 0, 270 )
setElementDimension ( pd4gate, 61 )
setElementInterior ( pd4gate, 10 )

function gatepd4c() 
moveObject ( pd4gate, 2000, 239.63491821289, 119.07646179199, 1003.5477294922 )
end
                                             
function gatepd4o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 1 ) then  
moveObject ( pd4gate, 2000, 239.63238525391, 120.12748718262, 1003.5477294922) 
setTimer (gatepd4c, 3000, 1)
end
end

addCommandHandler("pd2", gatepd4o)

-- 

pd5gate = createObject ( 3089, 245, 72.400001525879, 1004)
setElementDimension ( pd5gate, 2578 )
setElementInterior ( pd5gate, 6 )

function gatepd5c() 
moveObject ( pd5gate, 2000, 245, 72.400001525879, 1004 )
end
                                             
function gatepd5o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 1 ) or exports.factions:isPlayerInFaction( thePlayer, 22 ) then
outputChatBox("Puerta Celda 1 Abierta.",thePlayer)   
moveObject ( pd5gate, 2000, 244, 72.400001525879, 1004) 
setTimer (gatepd5c, 3000, 1)
end
end

addCommandHandler("pdc1", gatepd5o)

pd6gate = createObject ( 3089, 247.89999389648, 72.400001525879, 1004, 0, 0, 181.00006103516 )
setElementDimension ( pd6gate, 2578 )
setElementInterior ( pd6gate, 6 )

function gatepd6c() 
moveObject ( pd6gate, 2000, 247.89999389648, 72.400001525879, 1004 )
end
                                             
function gatepd6o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 1 ) or exports.factions:isPlayerInFaction( thePlayer, 22 ) then  
moveObject ( pd6gate, 2000, 248.8, 72.400001525879, 1004) 
setTimer (gatepd6c, 3000, 1)
end
end

addCommandHandler("pdc1", gatepd6o)

--

pd7gate = createObject ( 2930, 3152.2001953125, -2004.099609375, 12.699999809265, 0, 0, 304.74975585938 )
setElementDimension ( pd7gate, 0 )
setElementInterior ( pd7gate, 0 )

function gatepd7c() 
moveObject ( pd7gate, 2000, 3152.2001953125, -2004.099609375, 12.699999809265 )
end
                                             
function gatepd7o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) or exports.factions:isPlayerInFaction( thePlayer, 22 ) then
	outputChatBox("Puerta Patios Abierta.",thePlayer)   
	moveObject ( pd7gate, 2000, 3152.2001953125, -2004.099609375, 10) 
	setTimer (gatepd7c, 3000, 1)
	end
end

addCommandHandler("pdt", gatepd7o)

pd8gate = createObject ( 3089, -327.39999389648, 1551.6999511719, 77.599998474121, 0, 0, 179.99450683594 )
setElementDimension ( pd8gate, 1000 )
setElementInterior ( pd8gate, 1000 )

function gatepd8c() 
moveObject ( pd8gate, 2000, -327.39999389648, 1551.6999511719, 77.599998474121 )
end
                                             
function gatepd8o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) or exports.factions:isPlayerInFaction( thePlayer, 22 ) then  
		moveObject ( pd8gate, 2000, -325.9, 1551.6999511719, 77.599998474121) 
		setTimer (gatepd8c, 3000, 1)
	end
end

addCommandHandler("pdc2", gatepd8o)

--

pd10gate = createObject ( 976, 259.39999389648, 86.800003051758, 1000.5999755859, 0, 0, 90.5 )
setElementDimension ( pd10gate, 2578 )
setElementInterior ( pd10gate, 6 )

function gatepd10c() 
moveObject ( pd10gate, 2000, 259.39999389648, 86.800003051758, 1000.5999755859 )
end
                                             
function gatepd10o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) or exports.factions:isPlayerInFaction( thePlayer, 22 ) then
		outputChatBox("Puerta de las celdas abierta.",thePlayer)   
		moveObject ( pd10gate, 2000, 259.39999389648, 86.800003051758, 998 ) 
		setTimer (gatepd10c, 3000, 1)
	end
end

addCommandHandler("pdc", gatepd10o)


pdjailgate1 = createObject ( 976, 2873.8000488281, -1954.4000244141, 10.10000038147, 0, 0, 270 )
setElementDimension ( pdjailgate1, 0 )
setElementInterior ( pdjailgate1, 0, 2873.8000488281, -1954.4000244141, 10.10000038147 )

	
function pdgatejailc() 
	moveObject ( pdjailgate1, 3000, 2873.8000488281, -1954.4000244141, 10.10000038147 )
end
                                             
function pdgatejailo(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) or exports.factions:isPlayerInFaction( thePlayer, 22 ) then
		outputChatBox("Puerta de Principal De Carcel Abierta.",thePlayer)  
		moveObject ( pdjailgate1, 3000, 2873.8000488281, -1954.4000244141, 6) 
		setTimer (pdgatejailc, 5000, 1)
	end
end

addCommandHandler("pdp", pdgatejailo)
