-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Skindura.txd' ) 
engineImportTXD( txd, 88 ) 
dff = engineLoadDFF('skin_duradura.dff', 88) 
engineReplaceModel( dff, 88 )
end)
