function replaceModel()
txd = engineLoadTXD('car.txd',580)
engineImportTXD(txd,580)
dff = engineLoadDFF('car.dff',580)
engineReplaceModel(dff,580)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
--addCommandHandler ( 'reloadcar', replaceModel )

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy