--[[
/\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\/
                                                           ╖  ╓
                                                     ┏┓┏┳   ╖╓   ┏━━━┳ ┏━━┳
                                                     ┃┗┛┃   ┃┃   ┃ O ┃ ┃━━
                                                     ┃┏┓┃   ┃┃   ┃━━━┻ ┃━━
                                                     ┗┛┗┻   ┃┃   ┃     ┗━━┻ 
#Script By 'Hype'
/\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\/
--]]

local screenW, screenH = guiGetScreenSize()
local x, y = (screenW/1366), (screenH/768)

local FontHype = dxCreateFont("font/fontHype.ttf", y*10)
local FontHypeBrivie = dxCreateFont("font/fontHype.ttf", y*16)

HypeHudVisible = false

function HudHype()
        --<!-- FUNÇÃO PLAYER --!>--
        local Dinheiro = convertNumber(getPlayerMoney(getLocalPlayer()))
        local Banco = convertNumber(getElementData(localPlayer, "player:Banco") or "0")
        local Emprego = getElementData(localPlayer,"Emprego") or "Desempregado"
        local Vida = math.floor(getElementHealth(getLocalPlayer()))
        local Colete = math.floor(getPedArmor(getLocalPlayer()))
        local Stamina = tonumber(getElementData(localPlayer, "stamina") or 100)
        --<!-- NOME DAS CITYS --!>--
        local playerX, playerY, playerZ = getElementPosition ( localPlayer ) 
        local ZonaNome = getZoneName ( playerX, playerY, playerZ )
        --<!-- REAL TIME --!>--
        local time = getRealTime()
        local hours = time.hour
        local minutes = time.minute
        local seconds = time.second
        local meses = {"Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"}
        local dias = {"Domingo", "Segunda Feira", "Terça Feira", "Quarta Feira", "Quinta Feira", "Sexta Feira", "Sabado"}
        local dia = dias[time.weekday + 1]
        local ano = ("%02d"):format(time.year + 1900)
        local mes = meses[time.month + 1]

        local seconds = getTickCount() / 1600
        local angle = math.sin(seconds) * 10

		--<!-- BARRAS --!>--
        dxDrawImage(x*1225, y*154, x*101, y*28, "imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 80), false) -- VIDA
        dxDrawImage(x*1225, y*187, x*101, y*28, "imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 80), false) -- COLETE
        dxDrawImage(x*1225, y*221, x*101, y*28, "imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 80), false) -- STAMINA
        dxDrawImage(x*1002, y*703, x*285, y*41, "imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 108), false) -- VOICE
        --<!-- BARRINHA --!>--
        dxDrawImage(x*1225, y*154, x*101/100*Vida, y*28, "imgs/0.png", 0, 0, 0, tocolor(237, 0, 5, 134), false)
        dxDrawImage(x*1225, y*187, x*101/100*Colete, y*28, "imgs/0.png", 0, 0, 0, tocolor(7, 239, 247, 113), false)
        dxDrawImage(x*1225, y*221, x*101/100*Stamina, y*28, "imgs/0.png", 0, 0, 0, tocolor(253, 221, 0, 113), false)
        --<!-- CIRCULO --!>--
        dxDrawImage(x*1295, y*153, x*38, y*29, "imgs/circulo.png", 0, 0, 0, tocolor(255, 0, 0, 255), false) -- VIDA
        dxDrawImage(x*1295, y*186, x*38, y*29, "imgs/circulo.png", 0, 0, 0, tocolor(7, 239, 247, 255), false) -- COLETE
        dxDrawImage(x*1295, y*220, x*38, y*29, "imgs/circulo.png", 0, 0, 0, tocolor(237, 218, 16, 255), false) -- STAMINA
        dxDrawImage(x*1284, y*703, x*52, y*42, "imgs/circulo.png", 0, 0, 0, tocolor(33, 141, 8, 254), false) -- VOICE
        --<!-- ICONES --!>--
        dxDrawImage(x*1303, y*160, x*22, y*16, "imgs/health.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- VIDA
        dxDrawImage(x*1303, y*191, x*24, y*19, "imgs/armor.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- COLETE
        dxDrawImage(x*1303, y*225, x*22, y*19, "imgs/stamina.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- STAMINA
        --<!-- DX --!>--
        dxDrawText(Emprego, x*1120, y*87, x*1328, y*119, tocolor(255, 255, 255, 255), 1.00, FontHypeBrivie, "center", "center", false, false, false, false, false)
        --<!-- DX2 --!>--
        dxDrawText(Vida, x*1245, y*161, x*1279, y*174, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)
        dxDrawText(Colete, x*1245, y*194, x*1279, y*207, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)
        dxDrawText(Stamina, x*1245, y*228, x*1279, y*241, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)	
        --<!-- VOICE LADO --!>--
        dxDrawText("Hoje e "..dia.." de "..mes.." de "..ano.."", x*1084, y*709, x*1268, y*724, tocolor(255, 255, 255, 255), 1.00, FontHype, "right", "center", false, false, false, false, false)
        dxDrawText("Voce esta em "..ZonaNome, x*1084, y*724, x*1268, y*740, tocolor(255, 255, 255, 255), 1.00, FontHype, "right", "center", false, false, false, false, false)
        --<!-- IMG VOICE ON + OFF --!>--
        if getElementData(localPlayer, "Hype>Voice", true) then
          dxDrawImage(x*1296, y*712, x*28, y*24, "imgs/voiceOn.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        else
          dxDrawImage(x*1296, y*712, x*28, y*24, "imgs/voiceOff.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
        end
        --<!-- LOGO --!>--
        dxDrawImage(x*648, y*10, x*64, y*73, "imgs/logo.png", angle, 0, -40, tocolor(255, 255, 255, 255), false)
end
addEventHandler("onClientRender", getRootElement(), HudHype)

function CorMicroFoneHype()
   if getElementData(localPlayer, "Hype>Voice", true) then
      setElementData(localPlayer, "Hype>Voice", false)
  else
      setElementData(localPlayer, "Hype>Voice", true)
   end
end
bindKey("z", "both", CorMicroFoneHype)

function VisibleHudHype(state)
	if HypeHudVisible == false then
		HypeHudVisible = true
		removeEventHandler ("onClientRender", root, HudHype)
	else
		addEventHandler ("onClientRender", root, HudHype)
		HypeHudVisible = false
	end
end
bindKey("F11", "down", VisibleHudHype)

function OnStop()
	setPlayerHudComponentVisible("armour", true)
	setPlayerHudComponentVisible("wanted", true)
	setPlayerHudComponentVisible("weapon", true)
	setPlayerHudComponentVisible("money", true)
	setPlayerHudComponentVisible("health", true)
	setPlayerHudComponentVisible("clock", true)
	setPlayerHudComponentVisible("breath", true)
	setPlayerHudComponentVisible("ammo", true)
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), OnStop)

function OnStart()
	setPlayerHudComponentVisible("armour", false)
	setPlayerHudComponentVisible("wanted", false)
	setPlayerHudComponentVisible("weapon", false)
	setPlayerHudComponentVisible("money", false)
	setPlayerHudComponentVisible("health", false)
	setPlayerHudComponentVisible("clock", false)
	setPlayerHudComponentVisible("breath", false)
	setPlayerHudComponentVisible("ammo", false)
end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), OnStart )

local hudTable = 
{
"ammo",
"armour",
"clock",
"health",
"money",
"weapon",
"wanted",
"area_name",
"vehicle_name",
"breath",
"clock"
}

addEventHandler("onClientResourceStart", resourceRoot,
    function()
	for id, hudComponents in ipairs(hudTable) do
		showPlayerHudComponent(hudComponents, false)
	end
    end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function()
	for id, hudComponents in ipairs(hudTable) do
		showPlayerHudComponent(hudComponents, true)
	end
    end
)

function convertNumber ( number )   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end
