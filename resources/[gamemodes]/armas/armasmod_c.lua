--- Armas Modificadas en MTA. ---
function CambiarTexturaArmas() 
  -- Colt 45 = Glock 12
  txd = engineLoadTXD("Armas/22.txd", 346 )
  engineImportTXD(txd, 346)
  dff = engineLoadDFF("Armas/22.dff", 346 )
  engineReplaceModel(dff, 346)
  
  -- Desert Eagle = USP - Tactical
  txd = engineLoadTXD("Armas/24.txd", 348 )
  engineImportTXD(txd, 348)
  dff = engineLoadDFF("Armas/24.dff", 348 )
  engineReplaceModel(dff, 348)
  
  -- M4A1 = M4A1 HD - Tactical
  txd = engineLoadTXD("Armas/31.txd", 356 )
  engineImportTXD(txd, 356)
  dff = engineLoadDFF("Armas/31.dff", 356 )
  engineReplaceModel(dff, 356)
  
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
  
    -- Escopeta 25.
  txd = engineLoadTXD("Armas/25.txd", 349 )
  engineImportTXD(txd, 349)
  dff = engineLoadDFF("Armas/25.dff", 349 )
  engineReplaceModel(dff, 349)
  
    -- AK47.
  txd = engineLoadTXD("Armas/30.txd", 355 )
  engineImportTXD(txd, 355)
  dff = engineLoadDFF("Armas/30.dff", 355 )
  engineReplaceModel(dff, 355)
  
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), CambiarTexturaArmas)