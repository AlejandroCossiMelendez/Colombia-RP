--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]
shop_configurations =
{
    pizza =
    {
        name = "Mecato Verso",
        skin = 155,
        { itemID = 3, itemValue = 10, name = "Detodito", description = "Lo mas fresa del pedazo.", price = 4700 },
        { itemID = 72, itemValue = 30, name = "Ponymalta", description = "La bebida de los campeones.", price = 5100 },
        { itemID = 4, itemValue = 20, name = "Agua", description = "Una botella de agua cristalina de montaña.", price = 3200 },
	    { itemID = 93, itemValue = 1, name = "Yaper Blue", description = "El energizante para quitar las novias en grande si sabe", price = 3100 },
	    { itemID = 94, itemValue = 1, name = "Bandeja Paisa", description = "El combo mas rico de antioquia", price = 12000 },
		{ itemID = 95, itemValue = 1, name = "Salchipapa", description = "Pa el desparche mano", price = 12000 },
		{ itemID = 96, itemValue = 1, name = "Agogo", description = "Comete el dulce mas agogo de todo verso", price = 8000 },
		{ itemID = 71, itemValue = 1001, name = "Cafe", description = "Un delicioso café que te quitará gran parte del sueño.", price = 9800 },
		{ itemID = 97, itemValue = 1, name = "Carne Laminada", description = "Delicioso plato con trozos de carne laminados en oro de 24K.", price = 570000 },
		{ itemID = 98, itemValue = 1, name = "Jugo Hit", description = "Un rico jugo de piña.", price = 5100 },
		{ itemID = 99, itemValue = 1, name = "Hamburguesa", description = "Una del barrio si sabe, apenas.", price = 20000 },
		{ itemID = 100, itemValue = 1, name = "Arepa", description = "La arepa quesuda.", price = 14000 },
    },
    chalecos =
    {
        name = "Confeccionista",
        skin = 168,
        { itemID = 55, itemValue = 1, name = "2 Metros De Tela De Algodon", description = "Materiales 100% de alta calidad y util para la creacion de prendas.", price = 2100000 },
        { itemID = 70, itemValue = 1, name = "Tijeras", description = "Utiles para recortar tela gruesa y fina", price = 20000 },
    },
	registro =
    {
        name = "Registrador Nacional",
        skin = 59,
        { itemID = 16, itemValue = 1, name = "Cedula de Ciudadania", description = "Documento Nacional de Identidad", price = 370000 },
    },
	vendas =
    {
        name = "Enfermero De Sura",
        skin = 70,
        { itemID = 53, itemValue = 1, name = "Kit de reanimacion", description = "Usalo para reanimar a tus compañeros", price = 570000 },
	    { itemID = 101, itemValue = 1, name = "Dosis de adrenalina", description = "Jeringa con 20ml de adrenalina pura", price = 212500 },
		{ itemID = 102, itemValue = 1, name = "Tabletas Sanadoras", description = "Pack de tabletas diseñadas para la regeneracion de tu salud", price = 195000 },
    },
	semillagogo =
    {
        name = "semilla",
		skin = 23,        
		{ itemID = 65, itemValue = 11, itemValue2 = 1, name = "Semilla de Marihuana", description = "Semilla de marihuana para plantar.", price = 670000 },
    },
    ketaminagogo =
    {
        name = "Vendedor Ilegal",
		skin = 23,        
		{ itemID = 84, itemValue = 1, itemValue2 = 1, name = "Ketamina", description = "Compuesto quimico usado para...", price = 120000 },
    },
    electronica =
    {
        name = "Electrónica",   
        skin = 182,
                { itemID = 28, itemValue = 2, name = "Telefono Movil", description = "Con él podrás escribir sms, utilizando la cobertura de claro colombia", price = 720000 },
		{ itemID = 9, itemValue = 1, name = "Reloj", description = "Un bonito reloj de pulsera. Sin él, no podrás ver la hora.", price = 15000 },
		{ itemID = 32, itemValue = 0, name = "Walkie", description = "Podrás hablar con quien quieras, ¡y cambiando de frecuencia!", price = 150000 },
		{ itemID = 33, itemValue = 1, name = "Loteria", description = "¡Con este cupón pueden tocarte 7 millones de pesos!", price = 140000 },
		{ itemID = 29, itemValue = 43, itemValue2 = 100, name = "Camara de Fotos", description = "¿Quieres sacar fotos? ¡A que esperas para comprarla!", price = 215000 },
    },
    tijerasagogo =
    {
        name = "Objetos de cultivo",   
        skin = 22,
                { itemID = 70, itemValue = 1, name = "Tijeras", description = "Corta las hojas y abre bolsas con esto", price = 3450000 },
		{ itemID = 73, itemValue = 1, name = "Grinder", description = "Machaca la hierba con esto para darle textura", price = 4500000 },
		{ itemID = 74, itemValue = 1, name = "Bandeja", description = "Trabaja sobre esto para no perder ningun gramo", price = 1000000 },
   },
    bar =
	{
		name = "Bebidas Verso",
		skin = 40,
		{ itemID = 10, itemValue = 15, name = "Cerveza", description = "Cerveza de barril.", price = 3000 },
		{ itemID = 10, itemValue = 20, name = "Vino", description = "Un buen vino de reserva.", price = 6000 },
		{ itemID = 10, itemValue = 30, name = "Licor", description = "Un licor moderno, azucarado.", price = 2000 },
		{ itemID = 10, itemValue = 30, name = "Champan", description = "Champán de la mejor calidad.", price = 8000 },
		{ itemID = 10, itemValue = 80, name = "Ron", description = "Ron-Cola, delicioso.", price = 2500 },
		{ itemID = 10, itemValue = 90, name = "Scocht", description = "Un licor moderno, amargo.", price = 3000 },
		{ itemID = 4, itemValue = 20, name = "Agua", description = "Una botella llena de refrescante agua.", price = 3000 },
	},
	cascos =
	{
		name = "Cascos",
		skin = 190,
		{ itemID = 11, itemValue = 2053, name = "Casco 1", description = "Casco deportivo para moto.", price = 6500 },
		{ itemID = 11, itemValue = 2052, name = "Casco 2", description = "Casco deportivo para moto.", price = 6500 },
		{ itemID = 11, itemValue = 2054, name = "Casco 3", description = "Casco deportivo para moto.", price = 6500 },
		{ itemID = 11, itemValue = 3011, name = "Casco 4", description = "Casco deportivo para moto.", price = 6500 },
		{ itemID = 11, itemValue = 1248, name = "Casco 5", description = "Casco deportivo para moto.", price = 6500 },
		{ itemID = 11, itemValue = 1310, name = "Casco 6", description = "Casco deportivo para moto.", price = 6500 },
		{ itemID = 11, itemValue = 2908, name = "Casco 7", description = "Casco deportivo para moto.", price = 6500 }, 
	},
	mochilas =
	{
		name = "Compañía de mochilas",
		skin = 263,
		{ itemID = 12, itemValue = 2081, name = "small", description = "Buena para las mini excursiones.", price = 2400 },
		{ itemID = 12, itemValue = 2082, name = "alice", description = "Buena para almacenar cosas ahí.", price = 5500 },
		{ itemID = 12, itemValue = 2083, name = "czech", description = "Perfecta para ir de camping por los montes.", price = 7000 },
		{ itemID = 12, itemValue = 2084, name = "coyote", description = "Genial para perderte en el desierto 1 año.", price = 12000 },
	},
	estanco =
	{
		name = "Estanco",
		skin = 30,
		{ itemID = 14, itemValue = 21, name = "Paquete de Cigarros", description = "Un paquete con 20 cigarrillos Lucky Strike .", price = 45 },
	        { itemID = 26, itemValue = 50, name = "Mechero", description = "Si quieres fumar, ten asegurado que ésto te hará falta.", price = 2 },
		{ itemID = 33, itemValue = 0, name = "Loteria", description = "¡Con este cupón pueden tocarte 200 dólares!", price = 40 },
		{ itemID = 9, itemValue = 1, name = "Reloj", description = "Un bonito reloj de pulsera. Sin él, no podrás ver la hora.", price = 25 },
		{ itemID = 29, itemValue = 43, itemValue2 = 100, name = "Camara de Fotos", description = "¿Quieres sacar fotos? ¡A que esperas para comprarla!", price = 150 },
	},
	ferreteria =
	{
		name = "Ferreteria",
		skin = 30,
		{ itemID = 13, itemValue = 1, name = "Copiador de llave", description = "Un ticket para copiar una llave!", price = 90000 },
		{ itemID = 42, itemValue = 1, name = "Cerradura", description = "¿Qué? ¿Que alguien tiene copia de la llave de tu casa? Cómpra esta cerradura YA.", price = 40000 },
		{ itemID = 25, itemValue = 1, name = "Linterna", description = "Para poder alumbrar tu camino.", price = 25000 },
		{ itemID = 32, itemValue = 0, name = "Walkie", description = "Podrás hablar con quien quieras, ¡y cambiando de frecuencia!", price = 50000 },
		{ itemID = 33, itemValue = 0, name = "Loteria", description = "¡Con este cupón pueden tocarte 200 dólares!", price = 4000 },
		{ itemID = 9, itemValue = 1, name = "Reloj", description = "Un bonito reloj de pulsera. Sin él, no podrás ver la hora.", price = 250000 },
		{ itemID = 80, itemValue = 1, name = "Cuerda", description = "Multifuncional, cuidado como la vayas a usar.", price = 4500000 },
		{ itemID = 79, itemValue = 1, name = "Maletin", description = "Bolso de cuero fino, a lo mejor aca guardes dinero.", price = 10000000 },
		{ itemID = 29, itemValue = 43, itemValue2 = 100, name = "Camara de Fotos", description = "¿Quieres sacar fotos? ¡A que esperas para comprarla!", price = 15000 },
		{ itemID = 48, itemValue = 1, name = "Trapo", description = "Usalo para limpiar el coche, o bueno, usalo como quieras", price = 5000000 },
	},
	    kits =
    {
        name = "Mecanico",
        skin = 268,
        { itemID = 47, itemValue = 1, name = "Kit De Reparación", description = "Producto oficial de el taller mecanico, para venta al publico", price = 500000 },
    },
	    makecarga =
    {
        name = "Vendedor Callejero",
        skin = 27,
        { itemID = 91, itemValue = 1, name = "Cautil", description = "Pistola de soldadura", price = 522000 },
	    { itemID = 92, itemValue = 1, name = "Kit de fabricación", description = "Usalo para hacer los cargadores", price = 575900 },
    },
      coca =
    {
        name = "Minero Veterano",
        skin = 37,
        { itemID = 37, itemValue = 1, name = "Hoja De Cocaina", description = "Muy usada por los mineros del choco, para tener mas energia", price = 200000 },
    },
	      farc =
    {
        name = "Puntero Ilegal",
        skin = 73,
        { itemID = 37, itemValue = 1, name = "Hoja De Cocaina", description = "Pongase a ganar platica mijo, que plata sucia o limpia sirve", price = 200000 },
    },
	    partesarmas =
    {
        name = "Sujeto Anonimo",
        skin = 249,
        { itemID = 38, itemValue = 1, name = "Culata De AK-47", description = "Parte Para Fabricar 'AK-47'", price = 905000 },
        { itemID = 39, itemValue = 1, name = "Cuerpo De AK-47", description = "Parte Para Fabricar 'AK-47'", price = 1250000 },
        { itemID = 40, itemValue = 1, name = "Cargador De AK-47", description = "Parte Para Fabricar 'AK-47'", price = 792000 },
		{ itemID = 41, itemValue = 1, name = "Cañon De AK-47", description = "Parte Para Fabricar 'AK-47'", price = 699000 },
	    { itemID = 58, itemValue = 1, name = "Cuerpo De Colt-45", description = "Parte Para Fabricar 'Colt-45'", price = 798000 },
		{ itemID = 59, itemValue = 1, name = "Cargador De Colt-45", description = "Parte Para Fabricar 'Colt-45'", price = 590000 },
		{ itemID = 60, itemValue = 1, name = "Cañon De Colt-45", description = "Parte Para Fabricar 'Colt-45'", price = 590000 },
		{ itemID = 61, itemValue = 1, name = "Cañon De Tec-9", description = "Parte Para Fabricar 'Tec-9'", price = 699000 },
		{ itemID = 62, itemValue = 1, name = "Cargador De Tec-9", description = "Parte Para Fabricar 'Tec-9'", price = 595000 },
		{ itemID = 63, itemValue = 1, name = "Cuerpo De Tec-9", description = "Parte Para Fabricar 'Tec-9'", price = 997000 },
    },
	      ropas =
    {
        name = "Vendedor De Prendas",
        skin = 112,
        { itemID = 5, itemValue = 1, name = "Prenda 1", description = "Hora de lucir bien agogo, ponte la mejor pinta", price = 7000000 },
        { itemID = 6, itemValue = 1, name = "Prenda 2", description = "Hora de lucir a lo mas trululu", price = 7000000 },
	    { itemID = 81, itemValue = 1, name = "Prenda 3", description = "Apenas pa tirar stunt mi nea", price = 7000000 },
	    { itemID = 82, itemValue = 1, name = "Prenda 4", description = "Lo mas crema", price = 7000000 },
        { itemID = 83, itemValue = 1, name = "Prenda 5", description = "El tumba locas", price = 7000000 },
	    { itemID = 85, itemValue = 1, name = "Prenda 6", description = "Lo mas pinta de todo medellin", price = 7000000 },
	    { itemID = 86, itemValue = 1, name = "Prenda 7", description = "En verso puro estilo mi papá", price = 12000000 },
	    { itemID = 87, itemValue = 1, name = "Prenda 8", description = "Nadie se compara mi sog", price = 7000000 },
		{ itemID = 88, itemValue = 1, name = "Prenda 9", description = "Corran que me las corono", price = 7000000 },
		{ itemID = 89, itemValue = 1, name = "Prenda 10", description = "Equipado pa la guerra", price = 11000000 },
		{ itemID = 90, itemValue = 1, name = "Prenda 11", description = "Siempre pendiente mi sog", price = 7500000 },
    },
	      uniformejc =
    {
        name = "Coronel",
        skin = 290,
        { itemID = 85, itemValue = 1, name = "Bolsa con uniforme", description = "Si eres practicante, usa este uniforme para poder aplicar", price = 200000 },
    },
    gasolinera =
    {
        name = "Gasolinera",
        skin = 128,
                { itemID = 44, itemValue = 0, name = "Bidón Gasolina (Vacio)", description = "¿Te vas a quedar tirado? pues compra un bidón y rellenalo", price = 3500 },
		{ itemID = 4, itemValue = 1001, name = "Cafe", description = "Un delicioso café que te quitará gran parte del sueño.", price = 2000 },
		{ itemID = 4, itemValue = 30, name = "Sprunk", description = "Una lata de una deliciosa bebida sprunk.", price = 5000 },
                { itemID = 4, itemValue = 20, name = "Agua", description = "Una botella de agua cristalina de montaña.", price = 3000 },
		{ itemID = 33, itemValue = 1, name = "Loteria", description = "¡Con este cupón pueden tocarte 200 dólares!", price = 4000 },
		{ itemID = 14, itemValue = 21, name = "Paquete de Cigarros", description = "Un paquete con 20 cigarrillos Lucky Strike .", price = 4500 },
	        { itemID = 26, itemValue = 50, name = "Mechero", description = "Si quieres fumar, ten asegurado que ésto te hará falta.", price = 2000 },
   },
    IlegalV2 =
    {
        name = "Vendedor Callejero",
        skin = 21,
		nivel = 10,
                { itemID = 24, itemValue = 1, name = "Bandana", description = "¿No quieres que te vean el careto?.", price = 15000000 },
		{ itemID = 29, itemValue = 15, name = "Palanca", description = "¿Necesitas abrir algo colega?.", price = 15000000 },
                { itemID = 29, itemValue = 4, itemValue2 = 1, name = "Cuchillo", description = "¿Quieres rajar alguien loco?", price = 15000000 },
	        { itemID = 29, itemValue = 41, itemValue2 = 1000, name = "Spray", description = "¿Te van los graffitis?.", price = 15000000 },
		{ itemID = 29, itemValue = 6, itemValue2 = 1, name = "Pala", description = "¿Quieres desenterrar tesoros? ¿O enterrar algún cadáver?", price = 15000000 },
		{ itemID = 29, itemValue = 5, itemValue2 = 1, name = "Bate de Beisbol", description = "¿Quieres defenderte tio?", price = 15000000 },
          	{ itemID = 29, itemValue = 11, itemValue2 = 1, name = "Palanca", description = "Palanca policial para forzar cerraduras", price = 30000 },
	}, 
	 ArmasV2 =
    {
        name = "Cargadores",
        skin = 21,             
		nivel = 10,
		{ itemID = 43, itemValue = 22, itemValue2 = 1, name = "Cargador Colt 45", description = "Un arma sin cargador, es como no tener nada.", price = 2350000 },
		{ itemID = 43, itemValue = 28, itemValue2 = 1, name = "Cargador Uzi", description = "Un arma sin cargador, es como no tener nada.", price = 3200000 },
		{ itemID = 43, itemValue = 30, itemValue2 = 1, name = "Cargador AK-47", description = "Un arma sin cargador, es como no tener nada.", price = 4100000 },
		{ itemID = 43, itemValue = 26, itemValue2 = 1, name = "Cartuchos Recortada", description = "Un arma sin cargador, es como no tener nada.", price = 4100000 },
	},
		 ArmasV1 =
    {
        name = "Chinga Del Barrio",
        skin = 23,             
		nivel = 10,
	    { itemID = 29, itemValue = 5, itemValue2 = 1, name = "Bate", description = "Creo que este artículo no necesita una descripción.", price = 1000000 },
		{ itemID = 29, itemValue = 4, itemValue2 = 1, name = "Navaja", description = "Creo que este artículo no necesita una descripción.", price = 1100000 },
		{ itemID = 29, itemValue = 7, itemValue2 = 1, name = "Taco De Billar", description = "Creo que este artículo no necesita una descripción.", price = 1050000 },
		{ itemID = 29, itemValue = 8, itemValue2 = 1, name = "Katana", description = "Creo que este artículo no necesita una descripción.", price = 2000000 },
		{ itemID = 29, itemValue = 9, itemValue2 = 1, name = "Motosierra", description = "Creo que este artículo no necesita una descripción.", price = 600000 },
		{ itemID = 29, itemValue = 11, itemValue2 = 1, name = "Palanca", description = "Creo que este artículo no necesita una descripción.", price = 5000000 },
		{ itemID = 29, itemValue = 14, itemValue2 = 1, name = "Flores", description = "Ojo con eso manito.", price = 60000 },
	},
		DrogasV2 =
    {
        name = "Drogas",
        skin = 21,
		nivel = 10,
                { itemID = 18, itemValue = 1002, name = "Porro de marihuana", description = "Nada como un buen porro de marihuana.", price = 500000 },
		{ itemID = 19, itemValue = 1002, name = "Seta Psicodelica", description = "Tío, esto sí que es vida.", price = 1000000 },
                { itemID = 20, itemValue = 1002, name = "Tussi", description = "¿Quieres fliparlo loco?", price = 750000 },
	        { itemID = 21, itemValue = 1002, name = "Metanfetamina", description = "¿Estás cansado? Esto te irá mejor que el café.", price = 900000 },
		{ itemID = 22, itemValue = 1002, name = "Bolsa de marihuana(5g)", description = "Este pack requiere herramientas para abrirse.", price = 2000000 },
		{ itemID = 23, itemValue = 1002, name = "Bolsa de meta(5rayas)", description = "Este pack te sale a mejor precio que por separado.", price = 1000000},
	}, 
	Picos =
    {
        name = "Minero Vendedor",
        skin = 27,
            { itemID = 29, itemValue = 6, itemValue2 = 1, name = "Pico", description = "El mejor pico del mercado, compralo antes que se agoten.", price = 370000 },
	}, 
}

local function loadBookStore( )
	if shop_configurations.books then
		for key, value in ipairs( shop_configurations.books ) do
			shop_configurations.books[ key ] = nil
		end
    
	
    local languages = exports.players:getLanguages( )
    if languages then
        for key, value in ipairs( languages ) do
            table.insert( shop_configurations.books, { itemID = 8, itemValue = value[2], name = value[1] .. " diccionario", description = "Un diccionario para aprender los conceptos básicos de la lengua " .. value[1] .. ".", price = 100 } )
        end
    end
	end
end

addEventHandler( getResources and "onResourceStart" or "onClientResourceStart", root,
    function( res )
        if res == resource then
            if getResourceFromName( "players" ) and ( not getResourceState or getResourceState( getResourceFromName( "players" ) ) == "running" ) then
                loadBookStore( )
            end
        elseif res == getResourceFromName( "players" ) then
            loadBookStore( )
        end
    end
)
