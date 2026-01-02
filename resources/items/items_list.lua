-- listado de objetos oficiales del servidor

-- Lista de muebles --
local armario =
{
    [ 1741 ] = true,
	[ 2167 ] = true,
	[ 2025 ] = true,
	[ 2131 ] = true,
	[ 2336 ] = true,
}

local cajafuerte =
{
    [ 2332 ] = true,
}

local cama =
{
    [ 1700 ] = true,
	[ 1701 ] = true,
	[ 1725 ] = true,
	[ 1794 ] = true,
	[ 1798 ] = true,
	[ 2299 ] = true,
	[ 2603 ] = true,
	[ 2302 ] = true,
	[ 14866 ] = true,
	[ 2300 ] = true,
	[ 2301 ] = true,
	[ 2090 ] = true,
	[ 14446 ] = true,
	[ 2298 ] = true,
	[ 1812 ] = true,
	[ 1797 ] = true,
	[ 1745 ] = true,
	[ 1793 ] = true,
	[ 1796 ] = true,
	[ 1795 ] = true,
	[ 1799 ] = true,
	[ 1800 ] = true,
	[ 1801 ] = true,
	[ 1802 ] = true,
	[ 1803 ] = true,
	[ 14861 ] = true,
	[ 2575 ] = true,
	[ 1646 ] = true,
}

local wc =
{
    [ 2514 ] = true,
}

local lavadora =
{
    [ 1208 ] = true,
}

local radio =
{
    [ 2099 ] = true,
	[ 2100 ] = true,
}

local extintor =
{
    [ 2690 ] = true,
}

local sofa =
{
    [ 2290 ] = true,
	[ 1768 ] = true,
	[ 1766 ] = true,
	[ 1764 ] = true,
	[ 1763 ] = true,
	[ 1761 ] = true,
	[ 1760 ] = true,
	[ 1757 ] = true,
	[ 1756 ] = true,
	[ 1753 ] = true,
	[ 1713 ] = true,
	[ 1712 ] = true,
	[ 1710 ] = true,
	[ 1709 ] = true,
	[ 1707 ] = true,
	[ 1706 ] = true,
	[ 1703 ] = true,
	[ 1702 ] = true,
}

local sillon =
{
    [ 1735 ] = true,
	[ 1754 ] = true,
	[ 1755 ] = true,
	[ 1758 ] = true,
	[ 1759 ] = true,
	[ 1762 ] = true,
	[ 1765 ] = true,
	[ 1767 ] = true,
	[ 1769 ] = true,
	[ 2291 ] = true,
	[ 2292 ] = true,
	[ 1704 ] = true,
	[ 1727 ] = true,
}

local tv =
{
    [ 1518 ] = true,
	[ 1747 ] = true,
	[ 1748 ] = true,
	[ 1749 ] = true,
	[ 1750 ] = true,
	[ 1751 ] = true,
	[ 1752 ] = true,
	[ 1781 ] = true,
	[ 1786 ] = true,
	[ 2595 ] = true,
}

local estantetv =
{
    [ 2419 ] = true,
    [ 2311 ] = true,
	[ 2313 ] = true,
	[ 2314 ] = true,
	[ 2315 ] = true,
	[ 2321 ] = true,
	[ 2346 ] = true,
}

local silla =
{
    [ 1720 ] = true,
	[ 1739 ] = true,
	[ 1806 ] = true,
	[ 1810 ] = true,
	[ 2125 ] = true,
	[ 2079 ] = true,
	[ 2096 ] = true,
	[ 2120 ] = true,
	[ 2121 ] = true,
	[ 2123 ] = true,
	[ 2124 ] = true,
	[ 1671 ] = true,
	[ 1714 ] = true,
	[ 1715 ] = true,
	[ 1722 ] = true,
	[ 2350 ] = true,
	[ 1663 ] = true,
	[ 2636 ] = true,
	[ 2788 ] = true,
}

local pc =
{
	[ 1998 ] = true,
    [ 1999 ] = true,
	[ 2008 ] = true,
	[ 2009 ] = true,
	[ 2165 ] = true,
	[ 2605 ] = true,
}

function cuadro (objectID)
	if objectID and objectID >= 2254 and objectID <= 2289 then
		return true
	else
		return false
	end
end
-- Fin Lista de muebles --
local foodMap =
{
	mookidsmeal = "bs1",
	beeftowermeal = "bs2",
	meatstackmeal = "bs3",
	cluckinlittlemeal = "cluckin1",
	cluckinbigmeal = "cluckin2",
	cluckinhugemeal = "cluckin3",
	saladmeal = "salad",
	largesaladmeal = "salad",
	ramen = "ramen",
	buster = "pizza1",
	dobledluxe = "pizza2",
	fullrack = "pizza3",
	hotdog = "hotdog",
	chocolate = "chocolate",
	fresa = "fresa",
	vainilla = "vainilla",
}

local drinkMap =
{
	sprunk = "sprunk",
	cafe = "cafe",
}

local dragMap =
{
    weed = "Weed", 
    xtc = "XTC", 
    heroin = "Heroin",
} 

local alcholMap =
{
	vino = "vino",
	cerveza = "cerveza",
	champan = "champan",
	wisky = "wisky",
	licor = "licor",
	ron = "ron",
	scocht = "scocht",
}

local helmentMap =
{
	casco1 = "casco1",
	casco2 = "casco2",
	casco3 = "casco3",
	casco4 = "casco4",
	casco5 = "casco5",
	casco6 = "casco6",
	casco7 = "casco7",
}

local bagsMap =
{
	small = "small",
	alice = "alice",
	czech = "czech",
	coyote = "coyote",
}

local smokeMap =
{
	marlboro = "marlboro",
	chesterfield = "chesterfield",
	luckystrike = "luckystrike",
	winston = "winston",
	lm = "lm",
	ducadosrubio = "ducadosrubio",
	blackdevil = "blackdevil",
	fortuna = "fortuna",
	nobel = "nobel",
	ducadosazul = "ducadosazul",
}

local IngredienteMap =
{
	ingrediente1 = "ingrediente1", --Acetona
}
--

local function img( id )
	return ":items/images/" .. id .. ".PNG"
end

local function getFoodImage( value, name )
	if name then
		name = name:lower( ):gsub( "'", " " ):gsub( " ", "" ):gsub( "-", "" )
		return img( foodMap[ name ] or 3 )
	end
	return img( 3 )
end

local function getHelmetsImage( value, name )
	if name then
		name = name:lower( ):gsub( "'", " " ):gsub( " ", "" ):gsub( "-", "" )
		return img( helmentMap[ name ] )
	end
end

local function getMueblesImage( value )
	if value then
		if armario[value] then
			return img ("armario")
		elseif cajafuerte[value] then
			return img ("cajafuerte")
		elseif cama[value] then
			return img ("cama")
		elseif wc[value] then
			return img ("wc")
		elseif lavadora[value] then
			return img ("lavadora")
		elseif radio[value] then
			return img ("radio")
		elseif extintor[value] then
			return img ("extintor")
		elseif sofa[value] then
			return img ("sofa")
		elseif sillon[value] then
			return img ("sillon")
		elseif tv[value] then
			return img ("tv")
		elseif estantetv[value] then
			return img ("estantetv")
		elseif silla[value] then
			return img ("silla")
		elseif estantetv[value] then
			return img ("pc")
		elseif cuadro (value) then
			return img ("cuadro")
		end
	end
end

local function getTabacoImage( value, name )
	if name then
		name = name:lower( ):gsub( "'", " " ):gsub( " ", "" ):gsub( "-", "" )
		return img( smokeMap[ name ] )
	end
end


local function getBagsImage( value, name )
	if name then
		name = name:lower( ):gsub( "'", " " ):gsub( " ", "" ):gsub( "-", "" )
		return img( bagsMap[ name ] )
	end
end

local function getDrinkImage( value, name )
	if name then
		name = name:lower( ):gsub( "'", " " ):gsub( " ", "" ):gsub( "-", "" )
		return img( drinkMap[ name ] or 4 )
	end
	return img( 4 )
end

local function getAlcholImage( value, name )
    if name then	
		name = name:lower( ):gsub( "'", " " ):gsub( " ", "" ):gsub( "-", "" )
		return img( alcholMap[ name ] or 10 )
	end
	return img( 10 )
end

local function getDragImage( value, name )
	if name then
		name = name:lower( ):gsub( "'", " " ):gsub( " ", "" ):gsub( "-", "" )
		return img( dragMap[ name ] or 20 )
	end
	return img( 20 )
end

local function getIngredienteImage( value, name )
	if name then
		name = name:lower( ):gsub( "'", " " ):gsub( " ", "" ):gsub( "-", "" )
		return img( IngredienteMap[ name ] )
	end
end

local function getCargadorImagen( value, name )
    if name then	
		name = name:lower( ):gsub( "'", " " ):gsub( " ", "" ):gsub( "-", "" )
		return img( alcholMap[ name ] or 10 )
	end
	return img( 10 )
end

--

item_list =
{
	{ name = "Llave de Coche", image = true },--1
	{ name = "Llave de Casa", image = true },--2
	{ name = "Comida", image = true },--3
	{ name = "Bebida sin alcohol", image = true },--4
	{ name = "Ropa 1", image = true },--5
	{ name = "Ropa 2", image = true },--6
	{ name = "Telefono Movil", image = true },--7
	{ name = "Diccionario", image = function( value, name ) if value then return ":players/images/flags/" .. value .. ".png" end end },
	{ name = "Reloj", image = true },--9
	{ name = "Bebidas alcoholicas", image = getAlcholImage },--10
	{ name = "Cascos", image = getHelmetsImage },--11
	{ name = "Mochilas", image = getBagsImage },--12
	{ name = "Copia de llave", image = true  },--13
	{ name = "Caja de cigarrillos", image = true },--14
	{ name = "Cigarrillo", image = true },--15
	{ name = "Cedula De Ciudadania", image = true },--16
	{ name = "Tarjeta de peajes", image = true },--17
	{ name = "Porro de marihuana", image = true },--18
	{ name = "Seta Psicodelica", image = true },--19
	{ name = "Tussi", image = true },--20
	{ name = "Metanfetamina", image = true },--21
	{ name = "Bolsa de marihuana(2g)", image = true },--22
	{ name = "Bolsa de meta(3rayas)", image = true },--23
	{ name = "Bandana", image = true },--24
	{ name = "Linterna", image = true },--25
	{ name = "Mechero", image = true },--26
	{ name = "Mueble", image = getMueblesImage },--27
	{ name = "Caja de teléfono", image = true },--28
	{ name = "Arma", image = function( value, name ) if value then return ":items/images/w" .. value .. ".png" end end },--29
	{ name = "Kit Buceo", image = true },--30
	{ name = "Ingrediente", image = getIngredienteImage },--31
	{ name = "Walkie", image = true },--32
	{ name = "Loteria", image = true },--33
	{ name = "Pieza", image = true },--34
	{ name = "Útil - LSPD", image = function( value, name ) if value then return ":items/images/pd" .. value .. ".png" end end }, -- 35
	{ name = "Dinero Sucio", image = true },--36
	{ name = "Hoja De Coca", image = true },--37
	{ name = "Culata de Ak-47", image = true }, --38 fabrica
	{ name = "Cuerpo de Ak-47", image = true },--39 fabrica
	{ name = "Cargador de Ak-47", image = true },--40 fabrica
	{ name = "Cañon de Ak-47", image = true },--41 fabrica
	{ name = "Cerradura", image = true },--42
	{ name = "Cargador Arma", image = function( value, name ) if value then return ":items/images/w" .. value .. "c.png" end end },--43
	{ name = "Bidón de Gasolina", image = true },--44
	{ name = "Libreta Militar", image = true },--45
	{ name = "Chaleco Antibalas", image = true },--46
	{ name = "Kit de Reparación", image = true },--47
	{ name = "Trapo", image = true },--48
	{ name = "Lingote de oro", image = true },--49
	{ name = "Hierro", image = true },--50
	{ name = "Carbon", image = true },--51
	{ name = "Bauxita", image = true },--52
	{ name = "Vendas", image = true },--53
	{ name = "Pico y Pala", image = true },--54
	{ name = "Tela", image = true }, -- 55
	{ name = "Pescado chico", image = true },--56
	{ name = "Bolso con dinero", image = true },--57
	{ name = "Cuerpo de Colt-45", image = true }, --58 fabrica
	{ name = "Cargador de Colt-45", image = true }, --59 fabrica
	{ name = "Cañon de Colt-45", image = true }, --60 fabrica 
	{ name = "Cañon de Tec-9", image = true }, --61 fabrica
	{ name = "Cargador de Tec-9", image = true }, --62 fabrica
	{ name = "Cuerpo de Tec-9", image = true }, --63 fabrica
	{ name = "Caja de Alimentos", image = true },--64
	{ name = "Semillas de marihuana", image = true },--65
	{ name = "Aluminio", image = true },--66
	{ name = "Pólvora", image = true },--67
	{ name = "Acero", image = true },--68
	{ name = "Horno de Fundición", image = true },--69
	{ name = "Tijeras", image = true },--70
	{ name = "Cafe", image = true },--71
	{ name = "Pony Malta", image = true },--72
	{ name = "Grinder", image = true },--73
	{ name = "Bandeja De Procesos", image = true },--74
	{ name = "Hamburguesa2", image = true },--75
	{ name = "Tarjeta de Seguridad", image = true },--76
	{ name = "Paquete Con Etiqueta", image = true },--77
	{ name = "Paquete Sin Etiqueta", image = true },--78
	{ name = "Maletin Con Paquetes", image = true },--79
	{ name = "Cuerda", image = true },--80
	{ name = "Ropa 3", image = true },--81
	{ name = "Ropa 4", image = true },--82
	{ name = "Ropa 5", image = true },--83
	{ name = "Ketamina", image = true },--84
	{ name = "Ropa 6", image = true },--85
	{ name = "Ropa 7", image = true },--86
	{ name = "Ropa 8", image = true },--87
	{ name = "Ropa 9", image = true },--88
	{ name = "Ropa 10", image = true },--89
	{ name = "Ropa 11", image = true },--90
	{ name = "Pistola Soldadora", image = true },--91
	{ name = "Kit De Fabricación", image = true },--92
	{ name = "Amper", image = true },--93
	{ name = "Bandeja Paisa", image = true },--94
	{ name = "Salchipapa", image = true },--95
	{ name = "Agogo", image = true },--96
	{ name = "Carne Con Oro", image = true },--97
	{ name = "Jugo Hit", image = true },--98
	{ name = "Hamburguesa", image = true },--99
	{ name = "Arepa", image = true },--100
	{ name = "Jeringa Con Adrenalina", image = true },--101
	{ name = "Tabletas Sanadoras", image = true },--102
}
  
--

function getName( id )
	if id then
		return item_list[ id ] and item_list[ id ].name or " "
	end
end

function getDescription( id )
	return item_list[ id ] and item_list[ id ].description or ""
end

function getImage( id, value, name )
	return item_list[ id ] and (
		type( item_list[ id ].image ) == "function" and item_list[ id ].image( value, name )  or
			item_list[ id ].image == true and img( id ) or
			item_list[ id ].image
	)
end