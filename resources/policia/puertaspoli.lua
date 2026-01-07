-- Puertas definidas en la policia v1.
-- exports.items:has(thePlayer, 35,1)
function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end
-- 

pd1gate = createObject ( 976, 244.7109375, 74.9501953125, 1003, 0, 0, 90 )
setElementDimension ( pd1gate, 25 )
setElementInterior ( pd1gate, 6 )

function gatepd1c() 
	moveObject ( pd1gate, 2000, 244.7109375, 74.9501953125, 1003 )
end
                                             
function gatepd1o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
	outputChatBox("Puerta 1 abierta.",thePlayer)   
	moveObject ( pd1gate, 2000, 244.7109375, 76.9501953125, 1003) 
	setTimer (gatepd1c, 3000, 1)
	end
end

addCommandHandler("pd1", gatepd1o)

pd2gate = createObject ( 976, 262.29296875, 88.7744140625, 1000.2815551758, 0, 0, 90 )
setElementDimension ( pd2gate, 25 )
setElementInterior ( pd2gate, 6 )

function gatepd2c() 
	moveObject ( pd2gate, 2000, 262.29296875, 88.7744140625, 1000.2815551758 )
end
                                             
function gatepd2o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then  
	moveObject ( pd2gate, 2000, 262.29296875, 94.7744140625, 1000.2815551758) 
	setTimer (gatepd2c, 3000, 1)
	end
end

addCommandHandler("pd2", gatepd2o)

-- 

pd3gate = createObject ( 980, 245.0869140625, 1432.9999, 13.91496887207, 0, 0, 90 )
setElementDimension ( pd3gate, 0 )
setElementInterior ( pd3gate, 0 )

function gatepd3c() 
moveObject ( pd3gate, 2000, 245.0869140625, 1432.9999, 13.91496887207 )
end
                                             
function gatepd3o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 )  then
outputChatBox("Puerta 2 abierta.",thePlayer)   
moveObject ( pd3gate, 2000, 245.0869140625, 1432.78515625, 5.01496887207) 
setTimer (gatepd3c, 3000, 1)
end
end

addCommandHandler("ejnpuerta", gatepd3o)

pd4gate = createObject ( 980, 217.2763671875, 1433.0783203125, 13.81496887207, 0, 0, 90 )
setElementDimension ( pd4gate, 0 )
setElementInterior ( pd4gate, 0 )

function gatepd4c() 
moveObject ( pd4gate, 2000, 217.2763671875, 1433.0783203125, 13.81496887207 )
end
                                             
function gatepd4o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then  
moveObject ( pd4gate, 2000, 217.2763671875, 1433.2783203125, 5.01496887207) 
setTimer (gatepd4c, 3000, 1)
end
end

addCommandHandler("ejnpuerta", gatepd4o)

-- 

pd5gate = createObject ( 3089, 250.2278125, 1405.7763671875, 12.315625, 0, 0, 0 )
setElementDimension ( pd5gate, 0 )
setElementInterior ( pd5gate, 0 )

function gatepd5c() 
moveObject ( pd5gate, 2000, 250.2278125, 1405.7763671875, 12.315625)
end
                                             
function gatepd5o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then
outputChatBox("Puerta 3 abierta.",thePlayer)   
moveObject ( pd5gate, 2000, 250.2278125, 1405.7763671875, 6.315625) 
setTimer (gatepd5c, 3000, 1)
end
end

addCommandHandler("ejnpuerta2", gatepd5o)

pd6gate = createObject ( 3089, 252.2236328125, 1389.8642578125, 12.315625, 0, 0, 0 )
setElementDimension ( pd6gate, 0 )
setElementInterior ( pd6gate, 0 )

function gatepd6c() 
moveObject ( pd6gate, 2000, 252.2236328125, 1389.8642578125, 12.315625 )
end
                                             
function gatepd6o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then 
moveObject ( pd6gate, 2000, 252.2236328125, 1389.8642578125, 6.315625) 
setTimer (gatepd6c, 3000, 1)
end
end

addCommandHandler("ejnpuerta2", gatepd6o)

--

pd7gate = createObject ( 3089, 246.4000390625, 1407.776328125, 12.315625, 0, 0, 90 )
setElementDimension ( pd7gate, 0 )
setElementInterior ( pd7gate, 0 )

function gatepd7c() 
moveObject ( pd7gate, 2000, 246.4000390625, 1407.776328125, 12.315625 )
end
                                             
function gatepd7o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then
	outputChatBox("Puerta 4 abierta.",thePlayer)   
	moveObject ( pd7gate, 2000, 246.4000390625, 1407.776328125, 6.315625) 
	setTimer (gatepd7c, 3000, 1)
	end
end

addCommandHandler("ejnpuerta2", gatepd7o)

pd8gate = createObject ( 3089, 241.0263671875, 1407.750328125, 12.315625, 0, 0, 90 )
setElementDimension ( pd8gate, 0 )
setElementInterior ( pd8gate, 0 )

function gatepd8c() 
moveObject ( pd8gate, 2000, 241.0263671875, 1407.750328125, 12.315625 )
end
                                             
function gatepd8o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then 
		moveObject ( pd8gate, 2000, 241.0263671875, 1407.750328125, 6.315625) 
		setTimer (gatepd8c, 3000, 1)
	end
end

addCommandHandler("ejnpuerta2", gatepd8o)

--

pd10gate = createObject ( 3089, 242.92765625, 1405.7626953125, 12.315625 )
setElementDimension ( pd10gate, 0 )
setElementInterior ( pd10gate, 0 )

function gatepd10c() 
moveObject ( pd10gate, 2000, 242.92765625, 1405.7626953125, 12.315625 )
end
                                             
function gatepd10o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then
		outputChatBox("Puerta de las celdas abierta.",thePlayer)   
		moveObject ( pd10gate, 2000, 242.92765625, 1405.7626953125, 6.315625 ) 
		setTimer (gatepd10c, 3000, 1)
	end
end

addCommandHandler("ejnpuerta2", gatepd10o)


pdjailgate1 = createObject ( 3089, 241.078125, 1392.6671875, 12.315625, 0, 0, 90 )
setElementDimension ( pdjailgate1, 0)
setElementInterior ( pdjailgate1, 0 )

	
function pdgatejailc() 
	moveObject ( pdjailgate1, 2000, 241.078125, 1392.6671875, 12.315625 )
end
                                             
function pdgatejailo(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then 
		moveObject ( pdjailgate1, 3000, 241.078125, 1392.6671875, 6.315625) 
		setTimer (pdgatejailc, 3000, 1)
	end
end

addCommandHandler("ejnpuerta2", pdgatejailo)

pd11gate = createObject ( 2930, 205.158203125, 1383.8979296875, 13.61496887207 )
setElementDimension ( pd11gate, 0 )
setElementInterior ( pd11gate, 0 )

function gatepd11c() 
moveObject ( pd11gate, 2000, 242.92765625, 1405.7626953125, 12.315625 )
end
                                             
function gatepd11o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then
		outputChatBox("Puerta de las celdas abierta.",thePlayer)   
		moveObject ( pd11gate, 2000, 242.92765625, 1405.7626953125, 6.315625 ) 
		setTimer (gatepd11c, 3000, 1)
	end
end

addCommandHandler("jeicordero", gatepd11o)

pd12gate = createObject ( 2930, 183.6240234375, 1383.8972109375, 13.61478125 )
setElementDimension ( pd12gate, 0 )
setElementInterior ( pd12gate, 0 )

function gatepd12c() 
moveObject ( pd11gate, 2000, 242.92765625, 1405.7626953125, 12.315625 )
end
                                             
function gatepd12o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then
		outputChatBox("Puerta de las celdas abierta.",thePlayer)   
		moveObject ( pd12gate, 2000, 242.92765625, 1405.7626953125, 6.315625 ) 
		setTimer (gatepd12c, 3000, 1)
	end
end

addCommandHandler("jeicordero", gatepd12o)

pd13gate = createObject ( 3036, 179.42578125, 1408.3896484375, 12.40625, 0, 0, 90 )
setElementDimension ( pd13gate, 0 )
setElementInterior ( pd13gate, 0 )

function gatepd13c() 
moveObject ( pd13gate, 2000, 179.42578125, 1408.3896484375, 12.40625 )
end
                                             
function gatepd13o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then
		outputChatBox("Puerta de las celdas abierta.",thePlayer)   
		moveObject ( pd13gate, 2000, 179.42578125, 1408.3896484375, 6.40625 ) 
		setTimer (gatepd13c, 3000, 1)
	end
end

addCommandHandler("ejnceldas", gatepd13o)

pd14gate = createObject ( 3036, 169.3427734375, 1408.3896484375, 12.40625, 0, 0, 90 )
setElementDimension ( pd14gate, 0 )
setElementInterior ( pd14gate, 0 )

function gatepd14c() 
moveObject ( pd14gate, 2000, 169.3427734375, 1408.3896484375, 12.40625 )
end
                                             
function gatepd14o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 10 ) or exports.factions:isPlayerInFaction( thePlayer, 1 ) then
		outputChatBox("Puerta de las celdas abierta.",thePlayer)   
		moveObject ( pd14gate, 2000, 169.3427734375, 1408.3896484375, 6.40625 ) 
		setTimer (gatepd14c, 3000, 1)
	end
end

addCommandHandler("ejnceldas", gatepd14o)


-- Puerta pdpuerta1 - Cuarto celda temporal
pdpuerta1 = createObject(2930, 351.89999389648, -117.69999694824, 994.70001220703)
setElementDimension(pdpuerta1, 615)
setElementInterior(pdpuerta1, 5)

function pdpuerta1c()
	moveObject(pdpuerta1, 2000, 351.89999389648, -117.69999694824, 994.70001220703)
end

function pdpuerta1o(thePlayer, command)
	if exports.factions:isPlayerInFaction(thePlayer, 1) then
		outputChatBox("Puerta del cuarto de celda temporal abierta.", thePlayer)
		moveObject(pdpuerta1, 2000, 351.89999389648, -117.69999694824, 991.90002441406)
		setTimer(pdpuerta1c, 3000, 1)
	end
end

addCommandHandler("pdpuerta1", pdpuerta1o)


-- Puerta pdpuerta2 - Cuarto procesamiento y foto
pdpuerta2 = createObject(2930, 386.70001220703, -109.19999694824, 994.70001220703)
setElementDimension(pdpuerta2, 615)
setElementInterior(pdpuerta2, 5)

function pdpuerta2c()
	moveObject(pdpuerta2, 2000, 386.70001220703, -109.19999694824, 994.70001220703)
end

function pdpuerta2o(thePlayer, command)
	if exports.factions:isPlayerInFaction(thePlayer, 1) then
		outputChatBox("Puerta del cuarto de procesamiento y foto abierta.", thePlayer)
		moveObject(pdpuerta2, 2000, 386.70001220703, -109.19999694824, 991.90002441406)
		setTimer(pdpuerta2c, 3000, 1)
	end
end

addCommandHandler("pdpuerta2", pdpuerta2o)
