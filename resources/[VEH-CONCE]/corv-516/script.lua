-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'nebula.txd' ) 
engineImportTXD( txd, 516 ) 
dff = engineLoadDFF('nebula.dff', 516) 
engineReplaceModel( dff, 516 )
end)