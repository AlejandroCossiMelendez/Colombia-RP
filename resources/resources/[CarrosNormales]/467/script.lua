-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'BySampaio.txd' ) 
engineImportTXD( txd, 467 ) 
dff = engineLoadDFF('BySampaio.dff', 467 ) 
engineReplaceModel( dff, 467 )
end)
