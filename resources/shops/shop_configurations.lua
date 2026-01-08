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
        name = "Mecato La Capital",
        skin = 155,
        { itemID = 3, itemValue = 10, name = "Choclitos", description = "Lo mas fresa del pedazo.", price = 50000 },
       -- { itemID = 72, itemValue = 30, name = "Jugo del Valle", description = "La bebida de los campeones.", price = 40000 },
        { itemID = 4, itemValue = 20, name = "Agua", description = "Una botella de agua cristalina de montaña.", price = 20000 },
		{ itemID = 71, itemValue = 1001, name = "Cafe", description = "Un delicioso café que te quitará gran parte del sueño.", price = 15000 },
    },
    chalecos =
    {
        name = "Confeccionista",
        skin = 168,
        { itemID = 55, itemValue = 1, name = "2 Metros De Tela De Algodon", description = "Materiales 100% de alta calidad y util para la creacion de prendas.", price = 1500000 },
        { itemID = 56, itemValue = 1, name = "Kevlar blindado", description = "Material 100% de calidad y util para la creacion de prendas", price = 2500000 },
    },
	registro =
    {
        name = "Registrador Nacional",
        skin = 59,
        { itemID = 16, itemValue = 1, name = "Cedula de Ciudadania", description = "Documento Nacional de Identidad", price = 250000 },
    },
	vendas =
    {
        name = "Enfermero De Sura",
        skin = 70,
        { itemID = 53, itemValue = 1, name = "Vendas De Algodon", description = "Usalas para regenerar tu salud, si estas muerto no podras usarlas", price = 570000 },
    },
	maria =
    {
        name = "Objetos Cultivos Marihuana",
		skin = 34,        
		{ itemID = 65, itemValue = 11, itemValue2 = 1, name = "Semilla de Marihuana", description = "Semilla de marihuana para plantar.", price = 4000000 },
		{ itemID = 74, itemValue = 1, name = "Bandeja", description = "Trabaja sobre esto para no perder ningun gramo", price = 2000000 },
    },
    electronica =
    {
        name = "Electrónica",   
        skin = 182,
                { itemID = 28, itemValue = 2, name = "Telefono Movil", description = "Con él podrás llamar y escribir sms, utilizando la cobertura de San Fierro", price = 720000 },
		{ itemID = 9, itemValue = 1, name = "Reloj", description = "Un bonito reloj de pulsera. Sin él, no podrás ver la hora.", price = 25000 },
		{ itemID = 32, itemValue = 0, name = "Walkie", description = "Podrás hablar con quien quieras, ¡y cambiando de frecuencia!", price = 50000 },
		{ itemID = 33, itemValue = 1, name = "Loteria", description = "¡Con este cupón pueden tocarte 200 dólares!", price = 40000 },
		{ itemID = 29, itemValue = 43, itemValue2 = 100, name = "Camara de Fotos", description = "¿Quieres sacar fotos? ¡A que esperas para comprarla!", price = 15000 },
    },
    cocaine =
    {
        name = "Objetos de cultivo Cocaina",   
        skin = 45,
                { itemID = 74, itemValue = 1, name = "Bandeja", description = "Trabaja sobre esto para no perder ningun gramo", price = 2000000 },
		{ itemID = 37, itemValue = 1, name = "HojadeCoca", description = "Hoja de coca para crear la mejor droga del mundo", price = 8000000 },
		
   },

   tussi =
   {
       name = "Objetos de cultivo Tussi",   
       skin = 22,
               { itemID = 74, itemValue = 1, name = "Bandeja", description = "Trabaja sobre esto para no perder ningun gramo", price = 2000000 },
       { itemID = 85, itemValue = 1, name = "Ketamina", description = "Ketamina para crear la mejor droga del mundo", price = 1500000 },
       
  },
    bar =
	{
		name = "Bebidas LaCapital",
		skin = 40,
		{ itemID = 20, itemValue = 1, name = "Cerveza", description = "Cerveza fria que te genera embriaguez ligera (+8%).", price = 5000 },
		{ itemID = 22, itemValue = 1, name = "Whisky", description = "Whisky premium que genera embriaguez media (+15%).", price = 12000 },
		{ itemID = 65, itemValue = 1, name = "Ron", description = "Ron caribeno que genera embriaguez media-alta (+18%).", price = 15000 },
		{ itemID = 103, itemValue = 1, name = "Vodka", description = "Vodka ruso de alta graduacion (+22% embriaguez).", price = 20000 },
		{ itemID = 104, itemValue = 1, name = "Tequila", description = "Tequila mexicano muy fuerte (+25% embriaguez).", price = 25000 },
		{ itemID = 4, itemValue = 20, name = "Agua", description = "Una botella llena de refrescante agua.", price = 3000 },
	},
    bartutaina =
	{
		name = "Bebidas LaCapital",
		skin = 6,
		{ itemID = 20, itemValue = 1, name = "Cerveza", description = "Cerveza fria que te genera embriaguez ligera (+8%).", price = 5000 },
		{ itemID = 22, itemValue = 1, name = "Whisky", description = "Whisky premium que genera embriaguez media (+15%).", price = 12000 },
		{ itemID = 65, itemValue = 1, name = "Ron", description = "Ron caribeno que genera embriaguez media-alta (+18%).", price = 15000 },
		{ itemID = 103, itemValue = 1, name = "Vodka", description = "Vodka ruso de alta graduacion (+22% embriaguez).", price = 20000 },
		{ itemID = 104, itemValue = 1, name = "Tequila", description = "Tequila mexicano muy fuerte (+25% embriaguez).", price = 25000 },
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
		{ itemID = 29, itemValue = 43, itemValue2 = 100, name = "Camara de Fotos", description = "¿Quieres sacar fotos? ¡A que esperas para comprarla!", price = 15000 },
		{ itemID = 48, itemValue = 1, name = "Trapo", description = "Usalo para limpiar el coche, o bueno, usalo como quieras", price = 5000000 },
	},
	    kits =
    {
        name = "Mecanico",
        skin = 268,
        { itemID = 47, itemValue = 1, name = "Kit De Reparación", description = "Producto oficial de el taller mecanico, para venta al publico", price = 2000000 },
    },
      coca =
    {
        name = "Minero Veterano",
        skin = 37,
        { itemID = 37, itemValue = 1, name = "Hoja De Cocaina", description = "Muy usada por los mineros del choco, para tener mas energia", price = 200000 },
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
    },
	      vendercel =
    {
        name = "Alias La Rata",
        skin = 28,
        { itemID = 37, itemValue = 1, name = "Hoja De Cocaina", description = "Muy usada por los mineros del choco, para tener mas energia", price = 20000 },
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
    IlegalVR23 =
    {
        name = "Vendedor Callejero",
        skin = 21,
		
                { itemID = 24, itemValue = 1, name = "Bandana", description = "¿No quieres que te vean el careto?.", price = 20000000 },
		--{ itemID = 29, itemValue = 15, name = "Palanca", description = "¿Necesitas abrir algo colega?.", price = 15000000 },
                { itemID = 29, itemValue = 4, itemValue2 = 1, name = "Cuchillo", description = "¿Quieres rajar alguien loco?", price = 15000000 },
	      --  { itemID = 29, itemValue = 41, itemValue2 = 1000, name = "Spray", description = "¿Te van los graffitis?.", price = 15000000 },
		--{ itemID = 29, itemValue = 6, itemValue2 = 1, name = "Pala", description = "¿Quieres desenterrar tesoros? ¿O enterrar algún cadáver?", price = 15000000 },
		--{ itemID = 29, itemValue = 5, itemValue2 = 1, name = "Bate de Beisbol", description = "¿Quieres defenderte tio?", price = 15000000 },
          	{ itemID = 29, itemValue = 11, itemValue2 = 1, name = "Martillo", description = "Martillo Especial para robar cajeros automaticos", price = 5000000 },
	}, 
	cargadoresarmas =
    {
        name = "Cargadores Armas",
        skin = 21,             
		
		{ itemID = 43, itemValue = 22, itemValue2 = 1, name = "Cargador Colt 45", description = "Un arma sin cargador, es como no tener nada.", price = 1 },
		{ itemID = 43, itemValue = 32, itemValue2 = 1, name = "Cargador Tec-9", description = "Un arma sin cargador, es como no tener nada.", price = 1 },
		{ itemID = 43, itemValue = 30, itemValue2 = 1, name = "Cargador AK-47", description = "Un arma sin cargador, es como no tener nada.", price = 1 },
	},
    armas =
    {
        name = "Cargadores Armas",
        skin = 21,             
		
		{ itemID = 29, itemValue = 22, itemValue2 = 1, name = "ARMA Colt 45", description = "Un arma sin cargador, es como no tener nada.", price = 1 },
		{ itemID = 29, itemValue = 32, itemValue2 = 1, name = "ARMA Tec-9", description = "Un arma sin cargador, es como no tener nada.", price = 1 },
		{ itemID = 29, itemValue = 30, itemValue2 = 1, name = "ARMA AK-47", description = "Un arma sin cargador, es como no tener nada.", price = 1 },
	},
		DrogasVR23 =
    {
        name = "Drogas",
        skin = 21,
		
                { itemID = 18, itemValue = 1002, name = "Porro de marihuana", description = "Nada como un buen porro de marihuana.", price = 500000 },
		{ itemID = 19, itemValue = 1002, name = "Seta Psicodelica", description = "Tío, esto sí que es vida.", price = 1000000 },
                { itemID = 20, itemValue = 1002, name = "Extasis", description = "¿Quieres fliparlo loco?", price = 750000 },
	        { itemID = 21, itemValue = 1002, name = "Metanfetamina", description = "¿Estás cansado? Esto te irá mejor que el café.", price = 900000 },
		{ itemID = 22, itemValue = 1002, name = "Bolsa de marihuana(5g)", description = "Este pack requiere herramientas para abrirse.", price = 2000000 },
		{ itemID = 23, itemValue = 1002, name = "Bolsa de meta(5rayas)", description = "Este pack te sale a mejor precio que por separado.", price = 1000000},
	}, 
			minerales =
    {
        name = "Minerales Procesados",
        skin = 27,
		
                { itemID = 67, itemValue = 2000, name = "Polvora", description = "2000 unidades de Polvora para creacion de cargadores y armas", price = 100000000 },
				{ itemID = 66, itemValue = 2000, name = "Aluminio", description = "2000 unidades de Aluminio para creacion de cargadores y armas", price = 100000000 },
                { itemID = 68, itemValue = 2000, name = "Acero", description = "2000 unidades de Acero para creacion de cargadores y armas", price = 100000000 },
	}, 
	
	Picos =
    {
        name = "Minero Vendedor",
        skin = 27,
            { itemID = 29, itemValue = 6, itemValue2 = 1, name = "Pico", description = "El mejor pico del mercado, compralo antes que se agoten.", price = 370000 },
	}, 
	
	maletin =
    {
        name = "Vendedor de maletines",
        skin = 29,
            { itemID = 79, itemValue = 1, name = "Maletin", description = "Un Maletin ilegal para poder realizar robos en tiendas", price = 2000000 },
	}, 
    asaltobanco =
    {
        name = "Hacker Ilegal",
        skin = 47,
            { itemID = 90, itemValue = 1, name = "Carga Demolicion C4", description = "C4 PARA EXPLOTAR LA PUERTA DEL BARCO", price = 1 },
			{ itemID = 91, itemValue = 1, name = "Portatil Hackeo", description = "PORTATIL PARA HACKEAR CARGAMENTO DEL BARCO", price = 1 },
			{ itemID = 92, itemValue = 1, name = "USB HACKEO", description = "USB PARA HACKEAR EL CARGAMENTO DEL BARCO", price = 1 },
	},

	partescolt =
    {
        name = "Vendedor partes de Colt45",
        skin = 29,
            { itemID = 58, itemValue = 1, name = "Cuerpo de Colt-45", description = "Parte para crear una Colt45", price = 3000000 },
			{ itemID = 59, itemValue = 1, name = "Cargador de Colt-45", description = "Parte para crear una Colt45", price = 3000000 },
			{ itemID = 60, itemValue = 1, name = "Cañon de Colt-45", description = "Parte para crear una Colt45", price = 2000000 },
	},
	partestec9 =
    {
        name = "Vendedor partes de Tec-9",
        skin = 29,
            { itemID = 61, itemValue = 1, name = "Cuerpo de Tec-9", description = "Parte para crear una Tec-9", price = 3000000 },
			{ itemID = 62, itemValue = 1, name = "Cargador de Tec-9", description = "Parte para crear una Tec-9", price = 3000000 },
			{ itemID = 63, itemValue = 1, name = "Cañon de Tec-9", description = "Parte para crear una Tec-9", price = 2000000 },
	},
	partesak =
    {
        name = "Vendedor partes de AK-47",
        skin = 29,
            { itemID = 38, itemValue = 1, name = "Culata de AK-47", description = "Parte para crear una AK-47", price = 5000000 },
			{ itemID = 39, itemValue = 1, name = "Cañon de AK-47", description = "Parte para crear una AK-47", price = 5000000 },
			{ itemID = 40, itemValue = 1, name = "Cuerpo de AK-47", description = "Parte para crear una AK-47", price = 5000000 },
			{ itemID = 41, itemValue = 1, name = "Cargador de AK-47", description = "Parte para crear una AK-47", price = 5000000 },
	},
    piezascargador =
    {
        name = "Vendedor piezas de cargador de arma",
        skin = 230,
            { itemID = 86, itemValue = 1, name = "Cautil", description = "Parte para crear los cargadores", price = 2000000 },
			{ itemID = 87, itemValue = 1, name = "Pieza Cargador Colt-45", description = "Parte para crear un cargador colt-45", price = 3000000 },
			{ itemID = 88, itemValue = 1, name = "Pieza Cargador Tec-9", description = "Parte para crear un cargador Tec-9", price = 3000000 },
			{ itemID = 89, itemValue = 1, name = "Pieza Cargador AK-47", description = "Parte para crear un cargador AK-47", price = 3000000 },
	},

    mercadonegro =
    {
        name = "Mercado Negro",
        skin = 231,
            { itemID = 58, itemValue = 1, name = "Cuerpo de Colt-45", description = "Parte para crear una Colt45", price = 1500000 },
            { itemID = 59, itemValue = 1, name = "Cargador de Colt-45", description = "Parte para crear una Colt45", price = 1500000 },
            { itemID = 60, itemValue = 1, name = "Cañon de Colt-45", description = "Parte para crear una Colt45", price = 1000000 },
            { itemID = 61, itemValue = 1, name = "Cuerpo de Tec-9", description = "Parte para crear una Tec-9", price = 1500000 },
		    { itemID = 62, itemValue = 1, name = "Cargador de Tec-9", description = "Parte para crear una Tec-9", price = 1500000 },
		    { itemID = 63, itemValue = 1, name = "Cañon de Tec-9", description = "Parte para crear una Tec-9", price = 1000000 },
            { itemID = 38, itemValue = 1, name = "Culata de AK-47", description = "Parte para crear una AK-47", price = 2500000 },
			{ itemID = 39, itemValue = 1, name = "Cañon de AK-47", description = "Parte para crear una AK-47", price = 2500000 },
			{ itemID = 40, itemValue = 1, name = "Cuerpo de AK-47", description = "Parte para crear una AK-47", price = 2500000 },
			{ itemID = 41, itemValue = 1, name = "Cargador de AK-47", description = "Parte para crear una AK-47", price = 2500000 },
            { itemID = 86, itemValue = 1, name = "Cautil", description = "Parte para crear los cargadores", price = 1000000 },
			{ itemID = 87, itemValue = 1, name = "Pieza Cargador Colt-45", description = "Parte para crear un cargador colt-45", price = 1500000 },
			{ itemID = 88, itemValue = 1, name = "Pieza Cargador Tec-9", description = "Parte para crear un cargador Tec-9", price = 1500000 },
			{ itemID = 89, itemValue = 1, name = "Pieza Cargador AK-47", description = "Parte para crear un cargador AK-47", price = 1500000 },
            { itemID = 74, itemValue = 1, name = "Bandeja", description = "Trabaja sobre esto para no perder ningun gramo", price = 1000000 },
            { itemID = 85, itemValue = 1, name = "Ketamina", description = "Ketamina para crear la mejor droga del mundo", price = 1000000 },
            { itemID = 37, itemValue = 1, name = "HojadeCoca", description = "Hoja de coca para crear la mejor droga del mundo", price = 6000000 },
            { itemID = 65, itemValue = 11, itemValue2 = 1, name = "Semilla de Marihuana", description = "Semilla de marihuana para plantar.", price = 2000000 },
            { itemID = 55, itemValue = 1, name = "2 Metros De Tela De Algodon", description = "Materiales 100% de alta calidad y util para la creacion de prendas.", price = 1000000 },
            { itemID = 56, itemValue = 1, name = "Kevlar blindado", description = "Material 100% de calidad y util para la creacion de prendas", price = 1500000 },
            
	},
    suramedicamentos =
    {
        name = "Vendedor Medicamentos Sura EPS",
        skin = 275,
            { itemID = 93, itemValue = 1, name = "Acetaminofem - Ibuprofeno", description = "Cada una te cura un 25% - debes estar menos del 70% de tu vida ", price = 500000 },
			{ itemID = 53, itemValue = 1, name = "Botiquin Primeros Auxilios", description = "Te cura un 100% - debes estar a un 25% de vida para poderlo usar", price = 1000000 },
			
},
vendedorcocaina =
    {
        name = "Ingredientes Fabricacion Coca",
        skin = 48,
            { itemID = 94, itemValue = 1, name = "Acido Tectonico", description = "Ingrediente para la Fabricacion de Cocaina", price = 5000000 },
			{ itemID = 95, itemValue = 1, name = "Filtro Industrial", description = "Ingrediente para la Fabricacion de Cocaina", price = 5000000 },
            { itemID = 96, itemValue = 1, name = "Hoja de Coca", description = "Ingrediente para la Fabricacion de Cocaina", price = 5000000 },
            { itemID = 97, itemValue = 1, name = "Soda Catalizadora", description = "Ingrediente para la Fabricacion de Cocaina", price = 5000000 },
            { itemID = 99, itemValue = 1, name = "Bolsita Plastica", description = "Bolsita para empacar la cocaina", price = 100000 },
            { itemID = 101, itemValue = 1, name = "Bolsa con 10 bolsitas plasticas", description = "Contiene 10 bolsitas plasticas de empaquetamiento", price = 1500000 },
			
},
    drogasdealer =
    {
        name = "Dealer de Drogas",
        skin = 28,
        { itemID = 18, itemValue = 1, name = "Marihuana", description = "Hierba que incrementa tu vida en 30% instantaneamente.", price = 1000000 },
        { itemID = 19, itemValue = 1, name = "Hongo Magico", description = "Hongo psicodelico que incrementa tu vida en 60% instantaneamente.", price = 1500000 },
        { itemID = 21, itemValue = 1, name = "Perico", description = "Cocaina pura que refuerza tu chaleco en 20% instantaneamente.", price = 1000000 },
        { itemID = 23, itemValue = 1, name = "Meta", description = "Metanfetamina que refuerza tu chaleco en 40% instantaneamente.", price = 2000000 },
    }

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
