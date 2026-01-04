-- // LATIN ROLEPLAY ATM SUS BANK
--|| By: PandFort Developer ඞ
--\\ ϟ PandFort ϟ ඞ#0002

local ATM_visible
local deposito_dinero
local retiro_dinero
local x, y = guiGetScreenSize( )
local sx, sy = ( x / 1280 ), ( y / 720 )

local alphaButtonO = 0
local sTick, aDuration, eTick = nil, 500, nil

local money = 0
local walletBalance = getPlayerMoney()

local balancePlayer = 0
local balancePlayer1

local deposito_dineroBox = createElement( "editBox" )
local withoutBox = createElement( "editBox" )

local ATM = {
    ticks = {
        [ 1 ] = getTickCount( ),
        [ 2 ] = getTickCount( )
    }
}

local dxfont0_medium = dxCreateFont("assets/fonts/medium.ttf", 10)
local dxfont1_bold = dxCreateFont("assets/fonts/bold.ttf", 15)
local dxfont0_bold = dxCreateFont("assets/fonts/bold.ttf", 15)
local dxfont1_medium = dxCreateFont("assets/fonts/medium.ttf", 10)
local dxfont2_bold = dxCreateFont("assets/fonts/bold.ttf", 11)
local dxfont3_semi_bold = dxCreateFont("assets/fonts/semi_bold.ttf", 13)


addEventHandler("onClientRender", root,
    function()
        if not ATM_visible then 
            return
        end
        
        -- Player Variables
        local playerName = localPlayer:getName()
        local playerAvatar = 0
        local playerID = localPlayer:getData( "playerid" ) or 0
        local playerMoney = localPlayer:getMoney()
        local playerVal = balancePlayer
        local cTick = getTickCount()

        local wallet = interpolateBetween( ATM.ticks[ 1 ], 0, 0, walletBalance, 0, 0, ( getTickCount() - ATM.ticks[ 1 ]  ) / 7500, "Linear" )
        local balance_ = interpolateBetween( ATM.ticks[ 2 ], 0, 0, balancePlayer1, 0, 0, ( getTickCount() - ATM.ticks[ 1 ]  ) / 7500, "Linear" )
        local dxAlpha = interpolateBetween( 0, 0, 0, 255, 0, 0, ( cTick - sTick ) / aDuration, "InOutQuad" )
        -- playerMoney = wallet
        -- playerVal = balance_

        --dxDrawImage( sx*300, sy*150, sx*680, sy*420, "assets/images/ATM/bk.png", 0, 0, 0, tocolor(14, 14, 24, dxAlpha ) )

        DxRoundedRectangle( sx*300, sy*150, sx*680, sy*420, tocolor(15, 15, 25, 255 ), 10 )
       
        dxDrawImage(sx*320, sy*175, sx*120, sy*70, "assets/images/ATM/sus-logo.png", 0, 0, 0, tocolor( 255, 255, 255, dxAlpha ), false )
        
        -- Buttons --
        if isMouseInPosition( sx*321, sy*293, sx*111, sy*31 ) then
            DxRoundedRectangle( sx*321, sy*293, sx*111, sy*31, tocolor( 255, 58, 58, 230 ), 5 )
        end

        if isMouseInPosition( sx*321, sy*333, sx*111, sy*31 ) then
            DxRoundedRectangle( sx*321, sy*333, sx*111, sy*31, tocolor( 255, 58, 58, 230 ), 5 )
        end

        if isMouseInPosition( sx*321, sy*374, sx*111, sy*31 ) then
            DxRoundedRectangle( sx*321, sy*374, sx*111, sy*31, tocolor( 255, 58, 58, 230 ), 5 )
        end

        if isMouseInPosition( sx*321, sy*416, sx*111, sy*31 ) then
            DxRoundedRectangle( sx*321, sy*416, sx*111, sy*31, tocolor( 255, 58, 58, 230 ), 5 )
        end
 
        dxDrawImage(sx*320, sy*292, sx*32, sy*32, "assets/images/ATM/overview.png", 0, 0, 0, tocolor(255, 255, 255, dxAlpha), false)
        dxDrawImage(sx*321, sy*334, sx*32, sy*32, "assets/images/ATM/deposit.png", 0, 0, 0, tocolor(255, 255, 255, dxAlpha), false)
        dxDrawImage(sx*321, sy*375, sx*32, sy*32, "assets/images/ATM/withdraw.png", 0, 0, 0, tocolor(255, 255, 255, dxAlpha), false)
        dxDrawImage(sx*321, sy*417, sx*32, sy*32, "assets/images/ATM/transaction.png", 0, 0, 0, tocolor(255, 255, 255, dxAlpha), false)

        dxDrawImage(sx*320, sy*513, sx*32, sy*32, "assets/images/ATM/logout.png", 0, 0, 0, iconColor_, false)        

        -- Player Avatar
        dxDrawImage(sx*892, sy*177, sx*48, sy*48, "assets/icons/avatars/0.png", 0, 0, 0, tocolor(255, 255, 255, dxAlpha), false)

        DxRoundedRectangle(sx*484, sy*323, sx*351, sy*61, tocolor(41, 42, 49, dxAlpha), 5 )
        dxDrawRectangle(sx*484, sy*355, sx*351, sy*119, tocolor(29, 30, 36, dxAlpha), false)
        dxDrawImage(sx*500, sy*323, sx*30, sy*30, "assets/images/ATM/credit-card.png", 0, 0, 0, tocolor(255, 255, 255, dxAlpha), false)

        dxDrawLine( sx*480, sy*235, sx*940, sy*235, tocolor(41, 42, 49, dxAlpha), 1, false )
        dxDrawLine( sx*460, sy*175, sx*460, sy*545, tocolor(41, 42, 49, dxAlpha), 1, false )
        dxDrawLine( sx*320, sy*255, sx*440, sy*255, tocolor(41, 42, 49, dxAlpha), 1, false )
        dxDrawLine( sx*882, sy*255, sx*882, sy*535, tocolor(41, 42, 49, dxAlpha), 1, false )

        dxDrawText( "PERSONAL", sx*320, sy*265, sx*440, sy*282, tocolor(255, 255, 255, dxAlpha), 1.00, dxfont0_medium, "left", "top", false, false, false, false, false)
        dxDrawText( "General", sx*352, sy*292, sx*432, sy*323, tocolor(255, 255, 255, dxAlpha), 1.00, dxfont0_medium, "center", "center", false, false, false, false, false)
        dxDrawText( "Deposito", sx*352, sy*334, sx*432, sy*365, tocolor(255, 255, 255, dxAlpha), 1.00, dxfont0_medium, "center", "center", false, false, false, false, false)
        dxDrawText( "Retiro", sx*352, sy*376, sx*432, sy*407, tocolor(255, 255, 255, dxAlpha), 1.00, dxfont0_medium, "center", "center", false, false, false, false, false)
        dxDrawText( "      Opita Roleplay",sx*352, sy*417, sx*432, sy*449, tocolor(255, 255, 255, dxAlpha), 1.00, dxfont0_medium, "center", "center", false, false, false, false, false)
        dxDrawText( "Salir", sx*352, sy*514, sx*432, sy*545, iconColor_, 1.00, dxfont0_medium, "center", "center", false, false, false, false, false)
        
        dxDrawText( "General Informacion",sx*490, sy*177, sx*682, sy*225, tocolor(255, 255, 255, dxAlpha), 1.00, dxfont1_bold, "left", "center", false, false, false, false, false)
        dxDrawText( playerName:gsub( "_", " " ) .." # ".. playerID, sx*711, sy*177, sx*882, sy*201, tocolor(255, 0, 0, dxAlpha), 1.00, dxfont2_bold, "right", "center", false, false, false, false, false)
        dxDrawText( "Bolsillo: ".. playerMoney .." $", sx*711, sy*201, sx*882, sy*225, tocolor(0, 255, 15, dxAlpha), 1.00, dxfont2_bold, "right", "center", false, false, false, false, false)
        dxDrawText( "Bienvenido De Nuevo ".. playerName:gsub( "_", " " ), sx*490, sy*265, sx*775, sy*314, tocolor(255, 255, 255, dxAlpha), 1.00, dxfont1_bold, "left", "center", false, false, false, false, false)
        dxDrawText( "INFORMACION BANCARIA", sx*544, sy*324, sx*775, sy*353, tocolor(255, 255, 255, dxAlpha), 1.00, dxfont0_medium, "left", "center", false, false, false, false, false)
        dxDrawText( "Balance: $".. formatNumber( tonumber( playerVal ), "," ) .." COL", sx*490, sy*366, sx*825, sy*419, tocolor(0, 255, 15, dxAlpha), 1.00, dxfont3_semi_bold, "center", "center", false, false, false, false, false)
        dxDrawText( "IVA: 4X1000", sx*490, sy*409, sx*825, sy*464, tocolor(255, 255, 255, dxAlpha), 1.00, dxfont3_semi_bold, "center", "center", false, false, false, false, false)

        if deposito_dinero then

            DxRoundedRectangle( sx*490, sy*275, sx*300, sy*170, tocolor(14, 14, 24, 255), 8 )
            
            dxDrawText( "AÑADIR FONDOS", sx*498, sy*285, sx*780, sy*325, tocolor(255, 255, 255, 255), 1.00, dxfont0_bold, "center", "center", false, false, false, false, false)
            dxDrawText( "✕", sx*758, sy*274, sx*790, sy*306, closeFx, 1.00, "default", "center", "center", false, false, false, false, false)
                   
            dxDrawRectangle( sx*510, sy*335, sx*260, sy*40, tocolor(29, 30, 36, 255), false)
            dxDrawEditBox( "Ingrese un Monto", sx*510, sy*335, sx*260, sy*40, false, 6, deposito_dineroBox ) 
            
            DxRoundedRectangle( sx*575, sy*395, sx*130, sy*35, deposito_dineroColor, 5 )
            dxDrawText( "DEPOSITAR", sx*574, 396, sx*705, sy*430, tocolor(255, 255, 255, 255), 1.00, dxfont1_medium, "center", "center", false, false, false, false, false)

            if isCursorOverText( sx*758, sy*274, sx*790, sy*306 ) then
                closeFx = tocolor( 255, 58, 58, 255 )
            else 
                closeFx = tocolor( 255, 255, 255, 255 )
            end

            if isMouseInPosition( sx*575, sy*395, sx*130, sy*35 ) then
                deposito_dineroColor = tocolor(255, 58, 58, 255)
            else
                deposito_dineroColor = tocolor(41, 42, 49, 255)
            end

        end

        if transferencia then

            DxRoundedRectangle( sx*490, sy*275, sx*300, sy*170, tocolor(14, 14, 24, 255), 8 )
            
            dxDrawText( "AÑADIR FONDOS", sx*498, sy*285, sx*780, sy*325, tocolor(255, 255, 255, 255), 1.00, dxfont0_bold, "center", "center", false, false, false, false, false)
            dxDrawText( "✕", sx*758, sy*274, sx*790, sy*306, closeFx, 1.00, "default", "center", "center", false, false, false, false, false)
                   
            dxDrawRectangle( sx*510, sy*335, sx*260, sy*40, tocolor(29, 30, 36, 255), false)
            dxDrawEditBox( "Ingrese un Monto", sx*510, sy*335, sx*260, sy*40, false, 6, deposito_dineroBox ) 
            
            DxRoundedRectangle( sx*575, sy*395, sx*130, sy*35, deposito_dineroColor, 5 )
            dxDrawText( "DEPOSITAR", sx*574, 396, sx*705, sy*430, tocolor(255, 255, 255, 255), 1.00, dxfont1_medium, "center", "center", false, false, false, false, false)

            if isCursorOverText( sx*758, sy*274, sx*790, sy*306 ) then
                closeFx = tocolor( 255, 58, 58, 255 )
            else 
                closeFx = tocolor( 255, 255, 255, 255 )
            end

            if isMouseInPosition( sx*575, sy*395, sx*130, sy*35 ) then
                deposito_dineroColor = tocolor(255, 58, 58, 255)
            else
                deposito_dineroColor = tocolor(41, 42, 49, 255)
            end

        end

        if retiro_dinero then

           DxRoundedRectangle( sx*490, sy*275, sx*300, sy*170, tocolor(14, 14, 24, 255), 8 )
            
            dxDrawText( "RETIRAR FONDOS", sx*498, sy*285, sx*780, sy*325, tocolor(255, 255, 255, 255), 1.00, dxfont0_bold, "center", "center", false, false, false, false, false)
            dxDrawText( "✕", sx*758, sy*274, sx*790, sy*306, closeFx, 1.00, "default", "center", "center", false, false, false, false, false)
                   
            dxDrawRectangle( sx*510, sy*335, sx*260, sy*40, tocolor(29, 30, 36, 255), false)
            dxDrawEditBox( "Ingrese un Monto", sx*510, sy*335, sx*260, sy*40, false, 6, withoutBox ) 
            
            DxRoundedRectangle( sx*575, sy*395, sx*130, sy*35, deposito_dineroColor, 5 )
            dxDrawText( "RETIRAR", sx*574, 396, sx*705, sy*430, tocolor(255, 255, 255, 255), 1.00, dxfont1_medium, "center", "center", false, false, false, false, false)

            if isCursorOverText( sx*758, sy*274, sx*790, sy*306 ) then
                closeFx = tocolor( 255, 58, 58, 255 )
            else 
                closeFx = tocolor( 255, 255, 255, 255 )
            end

            if isMouseInPosition( sx*575, sy*395, sx*130, sy*35 ) then
                deposito_dineroColor = tocolor(255, 58, 58, 255)
            else
                deposito_dineroColor = tocolor(41, 42, 49, 255)
            end

        end

        if isCursorOverText( sx*352, sy*514, sx*432, sy*545 ) then
            iconColor_ = tocolor( 255, 58, 58, 255 )
        else 
            iconColor_ = tocolor( 255, 255, 255, 255 )
        end

        if getPlayerMoney() >= 0 then
            if getPlayerMoney() ~= walletBalance then
                walletBalance = getPlayerMoney()
                ATM.ticks[ 1 ]  = getTickCount()
            end
        end

         if playerVal >= 0 then
            if playerVal ~= balancePlayer1 then
                balancePlayer1 = playerVal
                ATM.ticks[ 2 ]  = getTickCount()
            end
        end

    end
)

addEvent( "onClentRequestBalance", true )
addEventHandler( "onClentRequestBalance", root,
    function ( val )
        if val then
            balancePlayer = val
            balancePlayer1 = val
            -- balancePlayer = formatNumber1( val, "," )
        end
    end
)

addEventHandler( "onClientClick", root,---no
    function ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
        if button == "left" and state == "down" then
            if clickedElement then
                if clickedElement:getType() == "object" then
                    local atmID = clickedElement:getModel()
                    if atmID == 2942 and not ATM_visible then
                        triggerServerEvent( "onRequestBalance", localPlayer, localPlayer )
                        ATM_visible = true
                        sTick = getTickCount()
                        eTick = sTick + aDuration
                    end
                end
            end
            if ATM_visible then
                if isMouseInPosition( sx*320, sy*513, sx*32, sy*32 ) then
                    ATM_visible = false
                end
                if isCursorOverText( sx*352, sy*514, sx*432, sy*545 ) then
                    ATM_visible = false
                end
                if isMouseInPosition( sx*321, sy*333, sx*111, sy*31 ) then
                    deposito_dinero = true
                    retiro_dinero = false
                end
                if isMouseInPosition( sx*321, sy*374, sx*111, sy*31 ) then
                    retiro_dinero = true
                    deposito_dinero = false
                end
                if isCursorOverText( sx*758, sy*274, sx*790, sy*306 ) and deposito_dinero then
                    deposito_dinero = false
                end
                if isCursorOverText( sx*758, sy*274, sx*790, sy*306 ) and retiro_dinero then
                    retiro_dinero = false
                end
                --if isCursorOverText( sx*321, sy*416, sx*111, sy*31 ) and transferencia then
                  --  transferencia = false
                --end-------sx*321, sy*416, sx*111, sy*31
                if isMouseInPosition( sx*575, sy*395, sx*130, sy*35 ) and deposito_dinero then
                    local boxdeposito_dinero = deposito_dineroBox:getData( "text" )
                    if boxdeposito_dinero then
                        triggerServerEvent( "onPlayerAddBalance", localPlayer, localPlayer, boxdeposito_dinero )
                        triggerServerEvent( "onRequestBalance", localPlayer, localPlayer )
                    end
                end
                if isMouseInPosition( sx*574, 396, sx*705, sy*430 ) and retiro_dinero then
                    local withoutBox = withoutBox:getData( "text" )
                    if withoutBox then
                        triggerServerEvent( "onPlayerRemoveBalance", localPlayer, localPlayer, withoutBox )
                        triggerServerEvent( "onRequestBalance", localPlayer, localPlayer )                        
                    end
                end
            end
        end
    end
)

function formatNumber(number, sep)
    assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
    assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
    local money = number
    for i = 1, tostring(money):len()/3 do
        money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
    end
    return money
end


function isCursorOverText(posX, posY, sizeX, sizeY)
    if ( not isCursorShowing( ) ) then
        return false
    end
    local cX, cY = getCursorPosition()
    local screenWidth, screenHeight = guiGetScreenSize()
    local cX, cY = (cX*screenWidth), (cY*screenHeight)

    return ( (cX >= posX and cX <= posX+(sizeX - posX)) and (cY >= posY and cY <= posY+(sizeY - posY)) )
end
        



addCommandHandler( "gc", function ()
  local cam = { getCameraMatrix() }
  outputChatBox( "CameraMatrix: " .. cam[ 1]..", " ..cam[2]..", "..cam[ 3]..", "..cam[ 4]..", ".. cam[ 5 ] .. ", " .. cam[ 6 ], 255, 255, 255 )
  end
)