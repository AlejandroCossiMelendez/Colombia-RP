--***********************************--
--***********************************--
--            Jail System            --
--            By Al3grab             --
--            Server Side            --
--***********************************--
--***********************************--
Command = get("command") -- getTheCommand
  
rRoot = getResourceRootElement(getThisResource())
------
function getData(to) 
	local file = xmlLoadFile("data.xml")
		 jTable = {}
		 tTable = {}
	if file then
		for k,v in ipairs (xmlNodeGetChildren(xmlFindChild(file,"Jails",0)))do
			local name = xmlNodeGetAttribute(v,"name")
			local posX,posY,posZ = xmlNodeGetAttribute(v,"posX"),xmlNodeGetAttribute(v,"posY"),xmlNodeGetAttribute(v,"posZ")
			local int = xmlNodeGetAttribute(v,"int")
			local dim = xmlNodeGetAttribute(v,"dim")
			table.insert(jTable, {name,posX,posY,posZ,int,dim})
		end
		for k,v in ipairs (xmlNodeGetChildren(xmlFindChild(file,"time",0)))do
			local times = xmlNodeGetAttribute(v,"times")
				for i =1,50 do 
					local iTime = gettok ( times, i, string.byte(',') )
					if iTime then
					--	
					if tonumber(iTime) > 59.5 then
						iTime = math.floor(iTime / 60)
						iTimeDes = "Minutos"
							if iTime > 59.5 then
								iTime = math.floor(iTime / 60)
								iTimeDes = "Hours"
							end
					else
						iTimeDes = "Seconds"
					end
						table.insert(tTable,{iTime,iTimeDes})
					end
				end
		end
	end
	triggerClientEvent(to,"sendDataz",to,jTable,tTable) -- sending to client event
end
addEvent("getDataz",true)
addEventHandler("getDataz",root,getData)


addCommandHandler ( Command, -- Adding The Command Handler
	function ( player, cmd )
		if hasObjectPermissionTo ( player, "function.banPlayer" ) then
			triggerClientEvent(player,"jailShow",player)
		else
		outputChatBox(" Access Denied ",player,255,0,0)
	end
end
)

anims = {
    "F_smklean_loop",
    "M_smklean_loop",
    "M_smkstnd_loop",
    "M_smk_drag",
    "M_smk_in",
    "M_smk_loop",
    "M_smk_out",
    "M_smk_tap" ,
}

function removeVehicle(thePlayer)
	if isPedInVehicle(thePlayer) then destroyElement(getPedOccupiedVehicle(thePlayer)) end
end
function JailHim(jailed,theJails,time,timeDes,showWho,timeReady)
		thePlayer = getPlayerFromName(jailed)
		if not thePlayer then outputChatBox("** #FFFF00Porfavor seleccionar el jugador!",source,255,0,0,true) return end
		removePedFromVehicle(thePlayer)
		for k,v in ipairs (  jTable  ) do
				if theJails == v[1] then
					theJail = v
				end
		end
		if theJail  then
		if tostring(time) then
			if timeReady == true then
			  theTimex = tonumber(time)
			else
			 theTimex = gettok ( time, 1, string.byte(timeDes) )
			end
			if timeDes == "Hours" then
				theTimex = math.floor(theTimex*60*60*1000)
				elseif timeDes == "Minutos" then
				theTimex = math.floor(theTimex*60*1000)
				elseif timeDes == "Seconds" then
				theTimex = math.floor(theTimex*1000)
			end
			startJailTimer ( thePlayer , theTimex )
		local x,y,z = theJail[2],theJail[3],theJail[4]
		local int = theJail[5]
		local dim = theJail[6]
        setElementInterior ( thePlayer, int )
        setElementDimension ( thePlayer, dim )
        setElementPosition (thePlayer,x,y,z )
		setElementData(thePlayer,"jailed",true)
		setElementData(rRoot,""..getPlayerSerial(thePlayer).."-j",true)
		toggleControl(thePlayer,"fire",false)
		if showWho ~= true then
        outputChatBox("** #00ff04Has Jaileado OOC a #FF0000[ "..getPlayerName(thePlayer).." #FF0000] #00ff04 y mandado a "..theJail[1].." y Por "..time,source,0,255,0,true)
        outputChatBox("** #00ff04A sido #FF0000Jaileado #00ff04por #FF0000[ "..getPlayerName(source).." #FF0000] #00ff04a "..theJail[1].." Por "..time,thePlayer,0,255,0,true)
        end
        outputChatBox("** #FF0000[ "..getPlayerName(thePlayer).." #FF0000] #00ff04Ha sido #00ff04Jaileado OOC #00ff04por el staff #FF0000[ "..getPlayerName(source).." #FF0000] #00ff04 y por "..time,root,255,0,0,true)
        local randomAnim
        setPedAnimation(thePlayer,"SMOKING",anims[math.random(#anims)],theTimex/2)
        else
        outputChatBox("** #FFFF00Seleccione la hora !",source,255,0,0,true)
        end
        else
        outputChatBox("** #FFFF00Seleccione una carcel !",source,255,0,0,true)
        end 
end	
addEvent("JailHimx",true)
addEventHandler("JailHimx",root,JailHim)

function unJailHim(jailed,showWho)
	thePlayer = getPlayerFromName(jailed)
	if not thePlayer then outputChatBox("** #FFFF00Porfavor seleccione un jugador !",source,255,0,0,true) return end
--if getElementData(thePlayer,"jailed") == true then
        setElementInterior ( thePlayer, 0)
        setElementDimension ( thePlayer, 0 )
        setElementPosition ( thePlayer, 1552.9108886719, -1675.5844726563, 16.1953125)
        setElementData(thePlayer,"jailed",false)
        setElementData(rRoot,""..getPlayerSerial(thePlayer).."-j",false)
        if showWho ~= true then
        outputChatBox("** #FFFF00Liberaste [ "..getPlayerName(thePlayer).." #FFFF00]",source,255,0,0,true)
        outputChatBox("** ##00ff04Has sido liberado por #00ff04[ "..getPlayerName(source).." #010101]",thePlayer,255,0,0,true)
        end
        outputChatBox("** #FF0000[ "..getPlayerName(thePlayer).." #FF0000] #00ff04Ha sido liberado De Jail OOC ",root,0,255,0,true)
        setPedAnimation(thePlayer)
        stopJailTimer(Player)
		toggleControl(thePlayer,"fire",true)
	--	setTimer(killPed,1500,1,thePlayer)
--else
	--	outputChatBox("El jugador no esta sancionado!",source,255,0,0,true)
--end
end	
addEvent("unJailHim",true)-- unJail
addEventHandler("unJailHim",root,unJailHim)

addEvent("onJailEnd",true)
addEventHandler("onJailEnd",root,function(player)
unJailHim(getPlayerName(player),true)
end )

addEventHandler("onPlayerSpawn",root, -- Check If He Is Jailed [ OnSpawn ]
function()
if getElementData(source,"jailed") == true then
 randomJail = jTable[math.random(#jTable)]
if randomJail then
	x,y,z = randomJail[2],randomJail[3],randomJail[4]
	int = randomJail[5]
	dim = randomJail[6]
	setElementInterior ( source, int )
	setElementDimension(source,dim)
    setElementPosition (source,x,y,z )
end
end
end)

addEventHandler("onPlayerJoin",root, -- Check If He Is Jailed - By Serial [ OnJoin ]
function()
if getElementData(rRoot,""..getPlayerSerial(source).."-j") == true then

 randomJail = jTable[math.random(#jTable)]
if randomJail then
	x,y,z = randomJail[2],randomJail[3],randomJail[4]
	int = randomJail[5]
	dim = randomJail[6]
	setElementInterior ( source, int )
	setElementDimension(source,dim)
    setElementPosition (source,x,y,z )
    --
    time = getElementData(rRoot,""..getPlayerSerial(source).."-t",time) or 5 * 1000
    startJailTimer(source,time)
    setElementData(source,"jailed",true)
end
end
end	)

----

function startJailTimer(Player,theTime) -- to start mission timer ..
	if Player then
		TimerDisplay = textCreateDisplay()
		m,s,cs = msToTimeStr(theTime)
		fullTime = m..":"..s
		TimerText = textCreateTextItem ( "Tiempo restante : "..tostring(fullTime).."", 0.39, 0.7 ,"medium",0,255,0,255,2.0,"left","center",255)
		textDisplayAddText ( TimerDisplay, TimerText )
		textDisplayAddObserver ( TimerDisplay, Player )
		sortTimerShit(Player,TimerText,theTime)
	end
end

--Robbed from JailTimerr resource , and it was robbed from arc_ :p
function msToTimeStr(ms)
	if not ms then
		return ''
	end
	
	if ms < 0 then
		return "0","00","00"
	end
	
	local centiseconds = tostring(math.floor(math.fmod(ms, 1000)/10))
	if #centiseconds == 1 then
		centiseconds = '0' .. centiseconds
	end
	local s = math.floor(ms / 1000)
	local seconds = tostring(math.fmod(s, 60))
	if #seconds == 1 then
		seconds = '0' .. seconds
	end
	local minutes = tostring(math.floor(s / 60))
	
	return minutes, seconds, centiseconds
end

function sortTimerShit(plr,timer,time) -- to sort timer's shit ..
	if timer and time then
			if isTimer(timerShitTimer) then
		killTimer(timerShitTimer)
	end
		timerShitTimer = setTimer(function(plr)
				time = time - 70
				m,s,cs = msToTimeStr(time)
				fullTime = m..":"..s
				textItemSetText(timer,"Tiempo restante : "..tostring(fullTime).."")
				if plr then
				setElementData(rRoot,""..getPlayerSerial(plr).."-t",time)
				end
				if ( tonumber(m) <= 0 and tonumber(s) <= 0 and tonumber(cs) <= 0 ) then
					onTimerFinish(plr,timer)
				end
		end , 50 , 0 ,plr )
	end
end

function stopJailTimer(Player)
	textDestroyDisplay(TimerDisplay)
	if TimerText then
	textDestroyTextItem(TimerText)
	end
	if isTimer(timerShitTimer) then
		killTimer(timerShitTimer)
	end
end

function onTimerFinish(Player) -- on timer end
	stopJailTimer(Player)
	triggerEvent("onJailEnd",Player,Player)
end
