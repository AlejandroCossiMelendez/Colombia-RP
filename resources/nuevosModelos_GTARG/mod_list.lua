-- ....................................... modList explained .......................................
	
-- The following mod list is stored in server only, then sent to client on request
-- These are the default mods, more than be added via functions from other resources

-- 'id' must be unique and out of the default GTA (& preferrably SA-MP too) ID ranges

-- 'base_id' is the model the mod will inherit some properties from
--	Doesn't make much difference on peds(skins), but it does on vehicles & objects

-- 'path' can be:
--		a string, in which case it expects files to be named ID.dff or ID.txd in that folder
-- 		an array(table), in which case it expects an array of file names like {dff="filepath.dff", txd="filepath.txd", col="filepath.col"}
--  		For files encrypted using NandoCrypt, don't add the .nandocrypt extension, it's defined by the 'NANDOCRYPT_EXT' setting
-- 	All paths defined manually in this file need to be local (this resource)
--		To add a mod from another resource see the examples provided in the documentation.

-- 'name' can be whatever you want (string)

-- + optional parameters:

-- 		'lodDistance' : custom LOD distance in GTA units (number), see possible values https://wiki.multitheftauto.com/wiki/EngineSetModelLODDistance
-- 		'ignoreTXD', 'ignoreDFF', 'ignoreCOL' : if true, the script won't try to load TXD/DFF/COL for the mod
--		'metaDownloadFalse' : if true, the mod will be only be downloaded when needed (when trying to set model)
-- 		'disableAutoFree' : if true, the allocated mod ID will not be freed when no element streamed in is no longer using the mod ID
--  		This causes the mod to stay in memory, be careful when enabling for big mods

modList = {
	ped = {
		-- MUJERES
--		{id=20001, base_id=1, path="models/skins/", name="mujer"},
--		{id=20002, base_id=1, path="models/skins/", name="mujer"},
--		{id=20003, base_id=1, path="models/skins/", name="mujer"},
--		{id=20004, base_id=1, path="models/skins/", name="mujer"},
--		-- HOMBRES
--		{id=20100, base_id=1, path="models/skins/", name="hombre"},
--		{id=20101, base_id=1, path="models/skins/", name="hombre"},
--		{id=20102, base_id=1, path="models/skins/", name="hombre"},
--		{id=20103, base_id=1, path="models/skins/", name="hombre"},
--		{id=20104, base_id=1, path="models/skins/", name="hombre"},
--		{id=20105, base_id=1, path="models/skins/", name="hombre"},
--		-- POLICIAS
--		{id=20500, base_id=1, path="models/skins/", name="pd"},
--		{id=20501, base_id=1, path="models/skins/", name="pd"},
--		{id=20502, base_id=1, path="models/skins/", name="pd"},
--		{id=20503, base_id=1, path="models/skins/", name="pd"},
--		{id=20504, base_id=1, path="models/skins/", name="pd"},
--		{id=20505, base_id=1, path="models/skins/", name="pd"},
--		{id=20506, base_id=1, path="models/skins/", name="pd"},
--		{id=20507, base_id=1, path="models/skins/", name="pd"},
--		{id=20508, base_id=1, path="models/skins/", name="pd"},
--		{id=20509, base_id=1, path="models/skins/", name="pd"},
--		-- NUEVOS POLICIAS SKINS
--		{id=50200, base_id=1, path="models/skins/", name="pd"},
--		{id=50201, base_id=1, path="models/skins/", name="pd"},
--		{id=50202, base_id=1, path="models/skins/", name="pd"},
--		{id=50203, base_id=1, path="models/skins/", name="pd"},
--		{id=50204, base_id=1, path="models/skins/", name="pd"},
--		{id=50205, base_id=1, path="models/skins/", name="pd"},
--		{id=50206, base_id=1, path="models/skins/", name="pd"},
--		{id=50207, base_id=1, path="models/skins/", name="pd"},
--		{id=50208, base_id=1, path="models/skins/", name="pd"},
--		{id=50209, base_id=1, path="models/skins/", name="pd"},
--		{id=50510, base_id=1, path="models/skins/", name="pd"},
--		{id=50511, base_id=1, path="models/skins/", name="pd"},
--		{id=50512, base_id=1, path="models/skins/", name="pd"},
--		{id=50513, base_id=1, path="models/skins/", name="pd"},
--		{id=50514, base_id=1, path="models/skins/", name="pd"},
--		{id=50515, base_id=1, path="models/skins/", name="pd"},
--		{id=50516, base_id=1, path="models/skins/", name="pd"},
--		{id=50517, base_id=1, path="models/skins/", name="pd"},
--		{id=50518, base_id=1, path="models/skins/", name="pd"},
--		{id=50519, base_id=1, path="models/skins/", name="pd"},
	},
	vehicle = {
		--{id=80001, base_id=415, path="models/vehicles/", name="Schafter", disableAutoFree=true},
--		{id=80001, base_id=415, path="models/vehiculos/", name="stork", disableAutoFree=false},
	},
	object = {
--		{id=50001, base_id=2082, path="models/objetos/accesorios/", name="small"},
--		{id=50002, base_id=2082, path="models/objetos/accesorios/", name="gucci"},
--		{id=50003, base_id=2082, path="models/objetos/accesorios/", name="urban"},
--		{id=50004, base_id=2082, path="models/objetos/accesorios/", name="comic"},
--		{id=50005, base_id=2082, path="models/objetos/accesorios/", name="nike"},
--		{id=50006, base_id=2082, path="models/objetos/accesorios/", name="nike"},
--		{id=50007, base_id=2082, path="models/objetos/accesorios/", name="gris"},
--		{id=50008, base_id=2082, path="models/objetos/accesorios/", name="rosada"},
--		{id=50009, base_id=2082, path="models/objetos/accesorios/", name="violeta"},
--		{id=50010, base_id=2082, path="models/objetos/accesorios/", name="negra"},
--		{id=50011, base_id=2082, path="models/objetos/accesorios/", name="gucci"},
--		{id=50012, base_id=2082, path="models/objetos/accesorios/", name="gucci"},
--		{id=50013, base_id=2082, path="models/objetos/accesorios/", name="gucci"},
--		{id=50014, base_id=2082, path="models/objetos/accesorios/", name="gucci"},
--		{id=50015, base_id=2082, path="models/objetos/accesorios/", name="gucci"},
--		{id=50016, base_id=2082, path="models/objetos/accesorios/", name="gucci"},
--		{id=50017, base_id=2082, path="models/objetos/accesorios/", name="gucci"},
--		{id=50018, base_id=2082, path="models/objetos/accesorios/", name="rainbow"},
--		{id=50019, base_id=2082, path="models/objetos/accesorios/", name="nike"},
--		{id=50020, base_id=2082, path="models/objetos/accesorios/", name="nike"},
--		{id=50021, base_id=2082, path="models/objetos/accesorios/", name="nike"},
--		{id=50022, base_id=2082, path="models/objetos/accesorios/", name="levis"},
--		{id=50023, base_id=2082, path="models/objetos/accesorios/", name="tiburon"},
--
--		---{id=50024, base_id=2081, path="models/objetos/accesorios/", name="accesorio"},
--		{id=50025, base_id=2081, path="models/objetos/accesorios/", name="accesorio2"},
--		{id=50026, base_id=2081, path="models/objetos/accesorios/", name="accesorio3"},
--		{id=50027, base_id=2081, path="models/objetos/accesorios/", name="accesorio4"},
--		{id=50028, base_id=2081, path="models/objetos/accesorios/", name="accesorio5"},
--		{id=50029, base_id=2081, path="models/objetos/accesorios/", name="accesorio6"},
--		{id=50030, base_id=2081, path="models/objetos/accesorios/", name="accesorio7"},
--		{id=50031, base_id=2081, path="models/objetos/accesorios/", name="accesorio8"},
--		{id=50032, base_id=2081, path="models/objetos/accesorios/", name="accesorio9"},
--		{id=50033, base_id=2081, path="models/objetos/accesorios/", name="accesorio10"},
--		{id=50034, base_id=2081, path="models/objetos/accesorios/", name="accesorio11"},
--		{id=50035, base_id=2081, path="models/objetos/accesorios/", name="accesorio12"},
--		{id=50036, base_id=2081, path="models/objetos/accesorios/", name="accesorio13"},
---		{id=50037, base_id=2081, path="models/objetos/accesorios/", name="accesorio14"},
--	--	{id=50038, base_id=2081, path="models/objetos/accesorios/", name="accesorio15"},
--	--	{id=50039, base_id=2081, path="models/objetos/accesorios/", name="accesorio16"},
--	--	{id=50040, base_id=2081, path="models/objetos/accesorios/", name="accesorio17"},
--	--	{id=50041, base_id=2081, path="models/objetos/accesorios/", name="accesorio18"},
--	-	{id=50042, base_id=2081, path="models/objetos/accesorios/", name="accesorio19"},
--		{id=50043, base_id=2081, path="models/objetos/accesorios/", name="accesorio20"},
--		{id=50044, base_id=2081, path="models/objetos/accesorios/", name="accesorio21"},
--		{id=50045, base_id=2081, path="models/objetos/accesorios/", name="accesorio22"},
--		{id=50046, base_id=2081, path="models/objetos/accesorios/", name="accesorio23"},
--		{id=50047, base_id=2081, path="models/objetos/accesorios/", name="accesorio24"},
--		{id=50048, base_id=2081, path="models/objetos/accesorios/", name="accesorio25"},
--		{id=50049, base_id=2081, path="models/objetos/accesorios/", name="accesorio26"},
--		{id=50050, base_id=2081, path="models/objetos/accesorios/", name="accesorio27"},
--		{id=50051, base_id=2081, path="models/objetos/accesorios/", name="accesorio28"},
--		{id=50052, base_id=2081, path="models/objetos/accesorios/", name="accesorio29"},
--		{id=50053, base_id=2081, path="models/objetos/accesorios/", name="accesorio30"},
--		{id=50054, base_id=2081, path="models/objetos/accesorios/", name="accesorio31"},
--		{id=50055, base_id=2081, path="models/objetos/accesorios/", name="accesorio32"},
--		{id=50056, base_id=2081, path="models/objetos/accesorios/", name="accesorio33"},
--		{id=50057, base_id=2081, path="models/objetos/accesorios/", name="accesorio34"},
--		{id=50058, base_id=2081, path="models/objetos/accesorios/", name="accesorio35"},
--		{id=50059, base_id=2081, path="models/objetos/accesorios/", name="accesorio36"},
--		{id=50060, base_id=2081, path="models/objetos/accesorios/", name="accesorio37"},
--		{id=50061, base_id=2081, path="models/objetos/accesorios/", name="accesorio38"},
--		{id=50062, base_id=2081, path="models/objetos/accesorios/", name="accesorio39"},
--		{id=50063, base_id=2081, path="models/objetos/accesorios/", name="accesorio40"},
--		{id=50064, base_id=2081, path="models/objetos/accesorios/", name="accesorio41"},
--		{id=50065, base_id=2081, path="models/objetos/accesorios/", name="accesorio42"},
--		{id=50066, base_id=2081, path="models/objetos/accesorios/", name="accesorio43"},
---		{id=50067, base_id=2081, path="models/objetos/accesorios/", name="accesorio43"},
		
		--{id=50068, base_id=2081, path="models/objetos/random/", name="marihuana"},
		{id=50069, base_id=2081, path="models/objetos/random/", name="radio"},
		{id=50070, base_id=2081, path={dff="models/objetos/random/mascarafivem.obj"}, name="bandana", ignoreTXD=true, ignoreCOL=true},

		--{id=50101, base_id=2081, path="models/objetos/policia/", name="escudo", ignoreCOL=false},
	},
}
