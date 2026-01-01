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
chat1 = "Twitter" -- Nome Livre
chat2 = "DeepWeb" -- Nome oculto


































---------TWITTER


function MensagemTwitter(source, cmd, ...) 
    local MessagemT = table.concat ( { ... }, " " )
    local name = getPlayerName(source); 
for _,v in ipairs(getElementsByType("player")) do 
    outputChatBox("#FFFFFF[#00BFFF"..chat1.."#FFFFFF]#FFFFFF (#00BFFF@ "..name.."#FFFFFF) : "..MessagemT,v, 255, 255, 255, true) 
    end 
end 
addCommandHandler("twitter",  MensagemTwitter) --- copia esto
addCommandHandler("twt",  MensagemTwitter)
------copia lo de arriba para crear otro comando para la misma funcion---

  





-------------Anonimo


function MensagemAnon(source, cmd, ...) 
    local MessagemANS = table.concat ( { ... }, " " ); 
for _,v in ipairs(getElementsByType("player")) do 
    outputChatBox("#FFFFFF[#00BFFF"..chat1.." #FE0000"..chat2.."#FFFFFF] : "..MessagemANS,v, 255, 255, 255, true)  
    end 
end 
addCommandHandler("deepweb",  MensagemAnon)
addCommandHandler("dp",  MensagemAnon)
  




























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







































