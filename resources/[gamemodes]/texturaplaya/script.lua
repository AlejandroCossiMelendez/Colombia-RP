-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter )

addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),function () 
txd = engineLoadTXD ( 'law_beach2.txd' ) 
engineImportTXD ( txd, 6280 ) 
dff = engineLoadDFF('beach01_law2.dff', 6280) 
engineReplaceModel ( dff, 6280 )
end)
