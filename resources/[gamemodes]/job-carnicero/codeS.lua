

local meats = {}
local boxes = {}

addEvent("givePlayerMeat",true)
addEventHandler("givePlayerMeat",getRootElement(),function(playerSource)
	if not isElement(meats[playerSource]) then
		meats[playerSource] = createObject(2806,0,0,0)
		setObjectScale(meats[playerSource],0.7)
		setElementCollisionsEnabled(meats[playerSource], false)
		setElementInterior(meats[playerSource],getElementInterior(playerSource))
		setElementDimension(meats[playerSource],getElementDimension(playerSource))
		exports.bone_attach:attachElementToBone(meats[playerSource],playerSource,12, 0.10, 0.05, 0.15, 0, 80, 80)
		setElementData(playerSource,"meat",meats[playerSource])
		setPedAnimation(playerSource, "CARRY", "crry_prtial", 0, true, false, true, true)
		setElementData(playerSource,"isMeatInHand",true)
	end
end)

addEvent("takePlayerMeat",true)
addEventHandler("takePlayerMeat",getRootElement(),function(playerSource)
	if isElement(meats[playerSource]) then
		exports.bone_attach:detachElementFromBone(meats[playerSource])
		destroyElement(meats[playerSource])
		meats[playerSource] = false
		setPedAnimation(playerSource,"CARRY","putdwn",1100,false,false,false,false)
		setElementData(playerSource,"isMeatInHand",false)
		toggleControl(playerSource, "fire", true)
		toggleControl(playerSource, "sprint", true)
		toggleControl(playerSource, "crouch", true)
		toggleControl(playerSource, "jump", true)
		toggleControl(playerSource, "aim_weapon", true)
		toggleControl(playerSource, "next_weapon", true)
		toggleControl(playerSource, "previous_weapon", true)
	end
end)

addEvent("givePlayerBox",true)
addEventHandler("givePlayerBox",getRootElement(),function (playerSource)
	if not isElement(boxes[playerSource] ) then
		boxes[playerSource] = createObject(1271,0,0,0)
		setObjectScale(boxes[playerSource],0.7)
		setElementInterior(boxes[playerSource],getElementInterior(playerSource))
		setElementDimension(boxes[playerSource],getElementDimension(playerSource))
		exports.bone_attach:attachElementToBone(boxes[playerSource],playerSource,12,0.2,0.2,0.2,0,90,65)
		setPedAnimation(playerSource, "CARRY", "crry_prtial", 0, true, false, true, true)
		setElementData(playerSource,"isBoxInHand",true)
	end
end)

addEvent("takePlayerBox",true)
addEventHandler("takePlayerBox",getRootElement(),function(playerSource)
	if isElement(boxes[playerSource]) then
		exports.bone_attach:detachElementFromBone(boxes[playerSource])
		destroyElement(boxes[playerSource])
		boxes[playerSource] = false
		setPedAnimation(playerSource,"CARRY","putdwn",1100,false,false,false,false)
		setElementData(playerSource,"isBoxInHand",false)
		toggleControl(playerSource, "fire", true)
		toggleControl(playerSource, "sprint", true)
		toggleControl(playerSource, "crouch", true)
		toggleControl(playerSource, "jump", true)
		toggleControl(playerSource, "aim_weapon", true)
		toggleControl(playerSource, "next_weapon", true)
		toggleControl(playerSource, "previous_weapon", true)
	end
end)



function givemaitmoney()
gerar = math.random(40,50)
outputChatBox("Dinero ganado :  +"..gerar.."",source,36,182,39,true)
exports.players:giveMoney( source, gerar )
end
addEvent("SRG_GiveMoneyMait", true)
addEventHandler("SRG_GiveMoneyMait", root, givemaitmoney)



local pedCarn = nil

local function createOurPedCarnicero( )
	if pedCarn then
		destroyElement( pedCarn )
	end
	pedCarn = createPed( 200, 373.0068359375, -64.501953125, 1001.5078125, 180, false )
	setElementData( pedCarn, "npcname", "Nelson Reimond" )
	setElementRotation(pedCarn,0,0,177.80822753906)
	setElementDimension(pedCarn,779)
	setElementInterior(pedCarn,10)
	setTimer(setElementFrozen, 2000, 1, pedCarn, true)
end
addEventHandler( "onPedWasted", resourceRoot, createOurPedCarnicero )
addEventHandler( "onResourceStart", resourceRoot, createOurPedCarnicero )

addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local x, y, z = getElementPosition( player )
			if getDistanceBetweenPoints3D( x, y, z, getElementPosition( source ) ) < 5 and getElementDimension( player ) == getElementDimension( source ) and source == pedCarn then
				triggerClientEvent("onAbrirJob", player, "carnicero")
			end
		end
	end
)