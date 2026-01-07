-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'BySampaio.txd' ) 
engineImportTXD( txd, 31 ) 
dff = engineLoadDFF('BySampaio.dff', 31) 
engineReplaceModel( dff, 31 )
end)
