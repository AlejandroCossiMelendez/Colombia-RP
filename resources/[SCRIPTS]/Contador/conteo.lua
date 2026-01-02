--Script Edit By FasTriX
--Visit My Youtube Channel: WWW.YOUTUBE.COM/FASTRIX
--Visit my Fanpage: www.facebook.com/fastrix
--Follow me on Twitter: www.twitter.com/fastrixyt - @FasTriXyt
countdRunning = false
function conteoTick(thePlayer)
	if remaining == 0 then
		killTimer(conteoTimer)
		playSoundFrontEnd(root, 45)
		outputChatBox("GO GO GO!",root,0,188,0)
		countdRunning = false
	else
		playSoundFrontEnd(root, 44)
		local factorGreen= 255/(countdStart-1)
		local resultadoGreen = factorGreen*remaining-factorGreen
		local factorSpaces = 12/(countdStart-1)
		local resultSpaces = math.floor(factorSpaces*remaining-factorSpaces)
		local remainingStr = ""
		for i=0,resultSpaces do
			remainingStr = remainingStr .. " "
		end
		remainingStr = remainingStr .. remaining
		outputChatBox(remainingStr,root,255,resultadoGreen,0)
		remaining = remaining - 1
	end
end
addCommandHandler("contar", function(thePlayer,cmd,startArg)
--addCommandHandler("countd", function(thePlayer,cmd,startArg)
--addCommandHandler("countdown", function(thePlayer,cmd,startArg)
--addCommandHandler("conteo", function(thePlayer,cmd,startArg)
	if countdRunning then
		outputChatBox("Ya hay una cuenta regresiva actualmente", thePlayer)
		return
	else
		if startArg and tonumber(startArg) then
			countdStart = tonumber(startArg)
		else
			countdStart = 3
		end
		if countdStart ~= 3 and countdStart ~= 4 then
			outputChatBox("Sólo disponible: 3 a 4", thePlayer, 255,0,0)
			return
		end
		remaining = countdStart
		outputChatBox(getPlayerName(thePlayer).." #FF8C00Comenzó la cuenta regresiva",root, 255,255,255 ,true)
		conteoTick(thePlayer)
		conteoTimer = setTimer(conteoTick,1000,0,thePlayer)
		countdRunning = true
	end
end)
