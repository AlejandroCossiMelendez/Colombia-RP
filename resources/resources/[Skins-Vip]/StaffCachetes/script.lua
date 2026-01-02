-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Skindura.txd' ) 
engineImportTXD( txd, 217 ) 
dff = engineLoadDFF('skin_duradura.dff', 217) 
engineReplaceModel( dff, 217 )
end)
