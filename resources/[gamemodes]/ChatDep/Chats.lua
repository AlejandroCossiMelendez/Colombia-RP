-----------------------------------------------
--                                            --
--                                            --
--   Mod Feito Por: Pedro Ribeiro Dos Santos  --
--                                            --
--                                            --
--    Favor no quitar lo creditos  --
--                                            --
--        Editado Por Maxi            --
--                                            --
--               V2.0                      --
--                                            --
--                                            --
--                                            --
------------------------------------------------



---Nombre de los chats
chat1 = "Deep Web" -- Nome Livre
chat2 = "Anonimo" -- Nome oculto






function MensagemTwitter(source, cmd, ...) 
    local MessagemT = table.concat ( { ... }, " " )
    local name = getPlayerName(source); 
for _,v in ipairs(getElementsByType("player")) do 
    outputChatBox("#FFFFFF[#1a1a1a"..chat1.."#FFFFFF]: "..MessagemT,v, 255, 255, 255, true) 
    end 
end 
addCommandHandler("chatd",  MensagemTwitter) --- copia esto
addCommandHandler("chatd2",  MensagemTwitter)
------copia lo de arriba para crear otro comando para la misma funcion---


  






























-----------------=================binds=============---------------------------
--addEventHandler("onPlayerJoin", getRootElement(),  
--function() 
  --bindKey(source, "i", "down", "chatbox", "Anonimo")--bind
--end 
--) 

--addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function() 
  --for index,player in pairs(getElementsByType("player")) do 
        --bindKey(player,"i", "down", "chatbox", "Anonimo") --bind
  --end 
--end 
--) 







---------addEventHandler("onPlayerJoin", getRootElement(),  
--------function() 
  ---bindKey(source, "y", "down", "chatbox", "Twitter") --bind
---end 
--) 

---addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function() 
 -- for index,player in pairs(getElementsByType("player")) do 
    --    bindKey(player,"y", "down", "chatbox", "Twitter") --bind
  --end 
--end 
--) 







































