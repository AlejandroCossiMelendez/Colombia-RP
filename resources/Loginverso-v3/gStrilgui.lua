function getConfig( )
    return config 
end

config = {
    ['utils'] = { 
        ['limitedaccounts'] = 1, --/ limite de contas que o player pode criar (Por serial)!
    },
    
    ['music'] = { --/ nome do arquivo da música
        { ['filename'] = 'music.mp3'},  
    },
} 

--/ Exports infobox
function message(j, msg, type) -- Não mexer
    triggerClientEvent(j, "dxInfoAddBox", j, msg, type)
end
