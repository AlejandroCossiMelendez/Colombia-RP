-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'greenwoo.txd' ) 
engineImportTXD( txd, 492 ) 
dff = engineLoadDFF('greenwoo.dff', 492) 
engineReplaceModel( dff, 492 )
end)