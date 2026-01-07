--[[
 ______    ______      _____       ____        ______                 
/\__  _\  /\__  _\    /\  __`\    /\  _`\     /\  _  \     /'\_/`\    
\/_/\ \/  \/_/\ \/    \ \ \/\ \   \ \,\L\_\   \ \ \L\ \   /\      \   
   \ \ \     \ \ \     \ \ \ \ \   \/_\__ \    \ \  __ \  \ \ \__\ \  
    \ \ \     \_\ \__   \ \ \_\ \    /\ \L\ \   \ \ \/\ \  \ \ \_/\ \ 
     \ \_\    /\_____\   \ \_____\   \ `\____\   \ \_\ \_\  \ \_\\ \_\
      \/_/    \/_____/    \/_____/    \/_____/    \/_/\/_/   \/_/ \/_/
                                                     
                         » CopyRight © 2025
                 » Meu discord discord.gg/sY5wHR8hW3                                                                          
]]--

ConfigLicense = {
    license = "D2B-9B4-DE8-01F-TIOSAM" -- KEY DO USUARIO
}

BindAbrir = "f2" -- TECLA PARA ABRIR O PAINEL
BindCancelar = "space" -- TECLA PARA CANCELAR A ANIMACAO
r,g,b,c = 101, 63, 255, 255 -- COR DOS QUADRADOS

id_prancheta = 1934 -- ID DA PRANCHETA
id_maleta = 1935 -- ID DA MALETA 
id_buque = 325 -- ID DO BUQUE DE FLORES
id_guarda_chuva = 14864 -- ID DO GUARDA CHUVA 
id_prancha = 2404 -- ID DA PRANCHA
id_caixa = 2912 -- ID DA CAIXA
id_camera = 367 -- ID DA CAMERA

ANIMATIONS = {
	{
		Name = "Estilo de andar",
		Icon = "walk_style",
		WalkStyles = {
			--{Name = "Normal", Command = "g32g3g2g2", Style = 0},
			--{Name = "Normal 2", Command = "3gdsjyktt", Style = 56},
			{Name = "Borracho", Command = "gfjfgjfjfjjf", Style = 126},
			{Name = "Gordo", Command = "hgffikk6hkgf", Style = 55},
			{Name = "Gordo 2", Command = "wfwFwws5", Style = 124},
			{Name = "Gang", Command = "tjfrt4jftfjf", Style = 121},
			{Name = "Abuelo", Command = "fjj45jfgtdfj", Style = 120},
			{Name = "Abuelo 2", Command = "gfjfjgfj56", Style = 123},
			{Name = "SWAT", Command = "dsfeerefdd3", Style = 128},
			{Name = "Femenino", Command = "wgaegaefgeas10", Style = 129},
			{Name = "Femenino 2", Command = "wsggadv11", Style = 131},
			{Name = "Femenino 3", Command = "wsdfsdvs12", Style = 132},
			{Name = "Femenino 4", Command = "wsgvsdvss13", Style = 136}
		}
	},
	{
		Name = "Social",
		Icon = "social",
		Animations = {
            {Name = "Triste", Command = "sccdageafg", Anim = {"Interações", "Triste", 500, false, false, true}, Custom = true},
            {Name = "Pensando", Command = "sceagaegc2", Anim = {"Interações", "Pensativo 2", 500, false, false, true}, Custom = true},
            {Name = "Fumando", Command = "saegaec2", Anim = {"SMOKING", "M_smkstnd_loop", -1, true, false, false}},
            {Name = "Fumando 2", Command = "sgaegc3", Anim = {"LOWRIDER", "M_smkstnd_loop", -1, true, false, false}},
            {Name = "Fumando 3", Command = "saegadc4", Anim = {"GANGS", "smkcig_prtl", -1, true, false, false}},
            {Name = "Esperando", Command = "sgeagc5", Anim = {"COP_AMBIENT", "Coplook_loop", -1, true, false, false}},
            {Name = "Esperando 2", Command = "scgdaaga6", Anim = {"COP_AMBIENT", "Coplook_shake", -1, true, false, false}},
            {Name = "Celebrando", Command = "scaegae7", Anim = {"CASINO", "manwinb", -1, true, false, false}},
            {Name = "Celebrando 2", Command = "svadbc8", Anim = {"CASINO", "manwind", -1, true, false, false}},
            {Name = "Cansado", Command = "svgagbc9", Anim = {"FAT", "idle_tired", -1, true, false, false}},
            {Name = "Reir", Command = "sc1eagaeg0", Anim = {"RAPPING", "Laugh_01", -1, true, false, false}}
		}
	},
	{
		Name = "Interacciones",
		Icon = "interactions",
		Animations = {
            {Name = "Cruzar los brazos", Command = "cigaedgean", Anim = {"Ações", "Cruzar Braços", 500, false, false, true}, Custom = true},
            {Name = "Rendirse 2", Command = "cieagaegn2", Anim = {"Ações", "Render 2", 500, false, false, true}, Custom = true},
            {Name = "Rendirse 3", Command = "ciagadgdn3", Anim = {"Ações", "Render 3", 500, false, false, true}, Custom = true},
            {Name = "Rendirse", Command = "render", Anim = {"Ações", "Render", 500, false, false, true}, Custom = true},
            {Name = "Saludar", Command = "inageag2", Anim = {"GANGS", "hndshkaa", -1, true, false, false}},
            {Name = "Saludar 2", Command = "iaegagn3", Anim = {"GANGS", "hndshkba", -1, true, false, false}},
            {Name = "Conversando", Command = "indsadva4", Anim = {"GANGS", "prtial_gngtlkA", -1, true, false, false}},
            {Name = "Conversando 2", Command = "inaeabeb5", Anim = {"GANGS", "prtial_gngtlkB", -1, true, false, false}},
            {Name = "Empujar", Command = "ineagaeg6", Anim = {"GANGS", "shake_cara", -1, true, false, false}},
            {Name = "Flexiones", Command = "ieagaegn7", Anim = {"flexao", "flexao", -1, true, false, false}, IFP = true},
            {Name = "Abdominales", Command = "inaegaega8", Anim = {"abdominal", "abdominal", -1, true, false, false}, IFP = true},
            {Name = "Continencia", Command = "ingavva9", Anim = {"continencia", "continencia", -1, true, false, false}, IFP = true},
		}
	},
	{
		Name = "Bailes",
		Icon = "dances",
		Animations = {
			{Name = "Baile", Command = "danca1", Anim = {"DANCING", "dance_loop", -1, true, false, false}},
            {Name = "Baile 2", Command = "danca2", Anim = {"DANCING", "DAN_Down_A", -1, true, false, false}},
            {Name = "Baile 3", Command = "danca3", Anim = {"DANCING", "DAN_Left_A", -1, true, false, false}},
            {Name = "Baile 4", Command = "danca4", Anim = {"DANCING", "DAN_Right_A", -1, true, false, false}},
            {Name = "Baile 5", Command = "danca5", Anim = {"DANCING", "DAN_Up_A", -1, true, false, false}},
            {Name = "Baile 6", Command = "danca6", Anim = {"DANCING", "dnce_M_a", -1, true, false, false}},
            {Name = "Baile 7", Command = "danca7", Anim = {"DANCING", "dnce_M_b", -1, true, false, false}},
            {Name = "Baile 8", Command = "danca8", Anim = {"DANCING", "dnce_M_c", -1, true, false, false}},
            {Name = "Baile 9", Command = "danca9", Anim = {"DANCING", "dnce_M_d", -1, true, false, false}},
            {Name = "Baile 10", Command = "danca10", Anim = {"DANCING", "dnce_M_e", -1, true, false, false}},
            {Name = "Baile 11", Command = "danca11", Anim = {"fortnite1", "baile 1", -1, true, false, false}, IFP = true},
            {Name = "Baile 12", Command = "danca12", Anim = {"fortnite1", "baile 2", -1, true, false, false}, IFP = true},
            {Name = "Baile 13", Command = "danca13", Anim = {"fortnite1", "baile 3", -1, true, false, false}, IFP = true},
            {Name = "Baile 14", Command = "danca14", Anim = {"fortnite1", "baile 4", -1, true, false, false}, IFP = true},
            {Name = "Baile 15", Command = "danca15", Anim = {"fortnite1", "baile 5", -1, true, false, false}, IFP = true},
            {Name = "Baile 16", Command = "danca16", Anim = {"fortnite1", "baile 6", -1, true, false, false}, IFP = true},
            {Name = "Baile 17", Command = "danca17", Anim = {"fortnite2", "baile 7", -1, true, false, false}, IFP = true},
            {Name = "Baile 18", Command = "danca18", Anim = {"fortnite2", "baile 8", -1, true, false, false}, IFP = true},
            {Name = "Baile 19", Command = "danca19", Anim = {"fortnite3", "baile 9", -1, true, false, false}, IFP = true},
            {Name = "Baile 20", Command = "danca20", Anim = {"fortnite3", "baile 10", -1, true, false, false}, IFP = true},
            {Name = "Baile 21", Command = "danca21", Anim = {"fortnite3", "baile 11", -1, true, false, false}, IFP = true},
            {Name = "Baile 22", Command = "danca22", Anim = {"fortnite3", "baile 12", -1, true, false, false}, IFP = true},
            {Name = "Baile 23", Command = "danca23", Anim = {"fortnite3", "baile 13", -1, true, false, false}, IFP = true},
            {Name = "Baile 24", Command = "danca24", Anim = {"breakdance1", "break_D", -1, true, false, false}, IFP = true},
            {Name = "Baile 25", Command = "danca25", Anim = {"breakdance2", "FightA_1", -1, true, false, false}, IFP = true},
            {Name = "Baile 26", Command = "danca26", Anim = {"breakdance2", "FightA_2", -1, true, false, false}, IFP = true},
            {Name = "Baile 27", Command = "danca27", Anim = {"breakdance2", "FightA_3", -1, true, false, false}, IFP = true},
            {Name = "Baile 28", Command = "danca28", Anim = {"newAnims", "dance1", -1, true, false, false}, IFP = true},
            {Name = "Baile 29", Command = "danca29", Anim = {"newAnims", "dance2", -1, true, false, false}, IFP = true},
            {Name = "Baile 30", Command = "danca30", Anim = {"newAnims", "dance3", -1, true, false, false}, IFP = true},
            {Name = "Baile 31", Command = "danca31", Anim = {"newAnims", "dance4", -1, true, false, false}, IFP = true},
            {Name = "Baile 32", Command = "danca32", Anim = {"newAnims", "dance5", -1, true, false, false}, IFP = true},
            {Name = "Baile 33", Command = "danca33", Anim = {"newAnims", "dance6", -1, true, false, false}, IFP = true},
            {Name = "Baile 34", Command = "danca34", Anim = {"newAnims", "dance7", -1, true, false, false}, IFP = true},
            {Name = "Baile 35", Command = "danca35", Anim = {"newAnims", "dance8", -1, true, false, false}, IFP = true}
		}
	},
	{
		Name = "Otros",
		Icon = "others",
		Animations = {
            {Name = "Santo", Command = "santo", Anim = {"Interações", "Santo", 500, false, false, true}, Custom = true},
            {Name = "Silvar", Command = "assobiar", Anim = {"Ações", "Assobiar", 600, false, false, false}, Custom = true},
            {Name = "Hablar por Radio", Command = "falandoradinho", Anim = {"Ações", "Falando radinho", 500, false, false, true}, Custom = true},
            {Name = "Asegurar arma", Command = "segurandoarma1", Anim = {"Ações", "Segurar arma", 500, false, false, true}, Custom = true},
            {Name = "Asegurar arma 2", Command = "segurandoarma2", Anim = {"Ações", "Segurar arma 2", 500, false, false, true}, Custom = true},
            {Name = "Asegurar Revolver", Command = "segurandorevolver", Anim = {"Ações", "Segurar pistola", 500, false, false, true}, Custom = true},
            {Name = "Meditando", Command = "meditando", Anim = {"Interações", "Meditando", 800, false, false, true}, Custom = true},
			{Name = "Levantar", Command = "levantar", Anim = {"INT_HOUSE", "wash_up", -1, true, false, false}},
            {Name = "Sentar", Command = "sentar", Anim = {"INT_HOUSE", "LOU_Loop", -1, true, false, false}},
            {Name = "Sentar 2", Command = "sentar2", Anim = {"INT_HOUSE", "LOU_In", -1, false, false, false}},
            {Name = "Sentar 3", Command = "sentar3", Anim = {"ped", "SEAT_idle", -1, true, false, false}},
            {Name = "Acostarse", Command = "deitar", Anim = {"CRACK", "crckidle2", -1, true, false, false}},
            {Name = "Acostarse 2", Command = "deitar2", Anim = {"CRACK", "crckidle4", -1, true, false, false}},
            {Name = "Tarjeta", Command = "cartão", Anim = {"HEIST9", "Use_SwipeCard", -1, true, false, false}},
			{Name = "Asustado", Command = "assutado", Anim = {"ped", "cower", -1, true, false, false}},
			{Name = "Jalarse", Command = "punheta", Anim = {"PAULNMAC", "wank_out", -1, true, false, false}},
			{Name = "Orinar", Command = "mijando", Anim = {"PAULNMAC", "Piss_out", -1, true, false, false}}
		}
	},
	{
		Name = "Objetos",
		Icon = "object",
		Animations = {
            {Name = "Caja", Command = "caixa1", Anim = {"Ações", "Segurando caixa", 500, false, false, true}, Custom = true},
            {Name = "Ramo", Command = "buque", Anim = {"Ações", "Segurar buquê", 500, false, false, true}, Custom = true},
            {Name = "Tabla Surf", Command = "prancha", Anim = {"Ações", "Segurar prancha", 500, false, false, true}, Custom = true},
            {Name = "Sombrilla", Command = "guardachuva", Anim = {"Ações", "Segurar guarda chuvas", 500, false, false, true}, Custom = true},
            {Name = "Camara", Command = "camera", Anim = {"Ações", "Segurando camera", 500, false, false, true}, Custom = true},
            {Name = "Porta Papeles", Command = "prancheta", Anim = {"Ações", "Segurando prancheta", 500, false, false, true}, Custom = true},
            {Name = "Maleta", Command = "maleta", Anim = {"Ações", "Segurando maleta", 500, false, false, true}, Custom = true},
        }
	}
}

IFPS = {
	"abdominal",
	"breakdance1",
	"breakdance2",
	"continencia",
	"flexao",
	"fortnite1",
	"fortnite2",
	"fortnite3",
	"newAnims",
	"render",
    "sex",
}