-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'merit.txd' ) 
engineImportTXD( txd, 551 ) 
dff = engineLoadDFF('merit.dff', 551) 
engineReplaceModel( dff, 551 )
end)