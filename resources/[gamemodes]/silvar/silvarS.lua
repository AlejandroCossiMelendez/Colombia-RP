
local segundos = 4 -- ¡Hora de silbar de nuevo! (el tiempo no puede ser inferior a 1, ya que se producirán errores)
local tecla = "n" -- Tacla para silbar


local assobio = {
  tick = {},
  tempo = {},
  doing = {},
};

function Assobiar(jogador)
  if not isPedOnGround (jogador) then return end -- Si el reproductor no está en el suelo, la función NO SE EJECUTA.
  if getElementHealth(jogador) < 5 then return end 
  if isPedInVehicle(jogador) then return end -- Si el jugador está en un vehículo, ¡la función NO EJECUTA!
  if getTickCount() - (assobio.tick[jogador] or 0) >= segundos * 1000 then -- Si el tiempo es más largo que segundos, entonces:
    if assobio.doing[jogador] == false or assobio.doing[jogador] == nil then
      controls(jogador, false)
	 exports.chat:me( jogador, "lleva sus dedos a la boca y hace un silvido." ) 
      setPedAnimation(jogador, "food", "eat_burger", -1, false, false, false, false) -- animación 1
      setTimer(setPedAnimationProgress, 800, 1, jogador, "eat_burger", 1)  -- alguna configuración de animación (¡recomiendo no jugar con ella!)
      assobio.doing[jogador] = true
      assobio.tick[jogador] = getTickCount()	  
      local cx, cy, cz = getElementPosition(jogador)
      triggerClientEvent(getRootElement(), "devs_Assobio", jogador, cx, cy, cz) -- activar el sonido del silbato (archivo client.lua)
      assobio.tempo[jogador] = setTimer(function() -- comienza el tiempo para la animación 2
        setPedAnimation(jogador, "ghands", "gsign2lh", -1, false, false, false, false) -- animación 1
        setTimer(function() -- comienza el momento de terminar el silbato
          cancelAnimn(jogador) -- función que termina el silbato
          controls(jogador, true)
        end, 1000, 1) -- tiempo de animación 2
      end, 1000, 1)  -- tiempo de animación 1
    end
  end
end 

function cancelAnimn(player)
  --setPedAnimation(player) -- Si hay un error, elimine los dos guiones del frente.
  --setPedWalkingStyle(player, 0) -- Si hay un error, elimine los dos guiones del frente.
  assobio.doing[player] = false
  if isTimer (assobio.tempo[player]) then killTimer (assobio.tempo[player]) assobio.tempo[player] = nil end
end

function Res()
  for _, player in ipairs(getElementsByType("player")) do
    assobio.tick[player] = 4
    assobio.doing[player] = false
    bindKey(player, tecla, "down", Assobiar)
  end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), Res)

function Join()
  for _, player in ipairs(getElementsByType("player")) do
    assobio.tick[player] = 4
    assobio.doing[player] = false
    bindKey(player, tecla, "down", Assobiar)
  end
end
addEventHandler("onPlayerJoin", getRootElement(), Join)

function Clean()
  for _, player in ipairs(getElementsByType("player")) do
    unbindKey(player, tecla, "down", Assobiar)
    if isTimer (assobio.tempo[jogador]) then killTimer (assobio.tempo[jogador]) end
      if assobio.doing[player] then
        destroyElement(assobio.doing[player] )
        assobio.doing[player] = nil
        assobio.tick[player] = nil
      end
  end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), Clean)

function Wasted()
  for _, player in ipairs(getElementsByType("player")) do
    if isTimer (assobio.tempo[jogador]) then killTimer (assobio.tempo[jogador]) end
      if assobio.doing[player] then
        destroyElement(assobio.doing[player] )
        assobio.doing[player] = nil
        assobio.tick[player] = 4
      end
  end
end
addEventHandler("onPlayerWasted", getRootElement(), Wasted)

function controls(player, state)
  if state == false then
    toggleControl ( player, "jump", false )
  elseif state == true then
    toggleControl ( player, "jump", true )
  end
end
