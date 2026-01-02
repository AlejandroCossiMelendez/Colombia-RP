-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'SkinEnc.txd' ) 
engineImportTXD( txd, 209 ) 
dff = engineLoadDFF('SkinEnc.dff', 209) 
engineReplaceModel( dff, 209 )
end)
