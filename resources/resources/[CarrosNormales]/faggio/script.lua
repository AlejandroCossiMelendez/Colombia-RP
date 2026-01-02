-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'pcj600.txd' ) 
engineImportTXD( txd, 462	 ) 
dff = engineLoadDFF('pcj600.dff', 462	) 
engineReplaceModel( dff, 462	 )
end)
