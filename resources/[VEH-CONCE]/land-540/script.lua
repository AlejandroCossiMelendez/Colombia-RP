-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'vincent.txd' ) 
engineImportTXD( txd, 540 ) 
dff = engineLoadDFF('vincent.dff', 540) 
engineReplaceModel( dff, 540 )
end)