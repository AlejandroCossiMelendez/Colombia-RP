-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'BySampaio.txd' ) 
engineImportTXD( txd, 85 ) 
dff = engineLoadDFF('BySampaio.dff', 85) 
engineReplaceModel( dff, 85 )
end)
