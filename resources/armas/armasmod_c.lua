--- Armas Modificadas en MTA. ---
function CambiarTexturaArmas()   
  -- Desert Eagle = USP - Tactical
  txd = engineLoadTXD("Armas/24.txd", 348 )
  engineImportTXD(txd, 348)
  dff = engineLoadDFF("Armas/24.dff", 348 )
  engineReplaceModel(dff, 348)
    
  -- MP5 = Igual pero con accesorios - Tactical
  txd = engineLoadTXD("Armas/29.txd", 353 )
  engineImportTXD(txd, 353)
  dff = engineLoadDFF("Armas/29.dff", 353 )
  engineReplaceModel(dff, 353)
  
  
  -- Sniper Con mirilla modificada.
  txd = engineLoadTXD("Armas/34.txd", 358 )
  engineImportTXD(txd, 358)
  dff = engineLoadDFF("Armas/34.dff", 358 )
  engineReplaceModel(dff, 358)
  
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), CambiarTexturaArmas)