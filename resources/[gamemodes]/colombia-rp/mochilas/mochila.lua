function BagsLoad ()
	-- Cargar texturas y modelos de mochilas
	local smalltxd = engineLoadTXD("mochilas/texturasMochilas/small.txd", true)
	if smalltxd then
		engineImportTXD(smalltxd, 2081)
		local smalldff = engineLoadDFF("mochilas/texturasMochilas/small.dff", 2081)
		if smalldff then
			engineReplaceModel(smalldff, 2081)
		end
	end
	
	local alicetxd = engineLoadTXD("mochilas/texturasMochilas/alice.txd", true)
	if alicetxd then
		engineImportTXD(alicetxd, 2082)
		local alicedff = engineLoadDFF("mochilas/texturasMochilas/alice.dff", 2082)
		if alicedff then
			engineReplaceModel(alicedff, 2082)
		end
	end
	
	local czechtxd = engineLoadTXD("mochilas/texturasMochilas/czech.txd", true)
	if czechtxd then
		engineImportTXD(czechtxd, 2083)
		local czechdff = engineLoadDFF("mochilas/texturasMochilas/czech.dff", 2083)
		if czechdff then
			engineReplaceModel(czechdff, 2083)
		end
	end
	
	local coyotetxd = engineLoadTXD("mochilas/texturasMochilas/coyote.txd", true)
	if coyotetxd then
		engineImportTXD(coyotetxd, 2084)
		local coyotedff = engineLoadDFF("mochilas/texturasMochilas/coyote.dff", 2084)
		if coyotedff then
			engineReplaceModel(coyotedff, 2084)
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, BagsLoad)      