--[[
Copyright (c) 2010 MTA: Paradise

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

local anims =
{
    beber =
    {
		{ block = "bar", anim = "dnk_stndm_loop", time = -1 },
		{ block = "bar", anim = "dnk_stndf_loop", time = -1 },
	},
	bar =
	{
		{ block = "bar", anim = "barcustom_loop", time = -1 },
		{ block = "bar", anim = "barman_idle", time = -1 },
		{ block = "bar", anim = "barserve_bottle", time = -1 },
		{ block = "bar", anim = "barserve_give", time = -1 },
		{ { block = "bar", anim = "barserve_in", time = 1000 }, { block = "bar", anim = "barserve_loop", time = -1 } },
	},
	bat =
	{
		{ block = "baseball", anim = "bat_1", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_2", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_3", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_4", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_hit_1", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_hit_2", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_hit_3", time = -1, updatePosition = true, loop = false },
	},
	bomb =
	{
		{ block = "bomber", anim = "bom_plant", time = 3000 },
	},
	crack =
	{
		{ block = "crack", anim = "crckidle2", time = -1 },
		{ block = "crack", anim = "crckidle3", time = -1 },
		{ block = "crack", anim = "crckidle4", time = -1 },
		{ block = "crack", anim = "crckidle1", time = -1 },
	},
	cpr =
	{
		{ block = "medic", anim = "cpr", time = -1 },
	},
	bailar =
	{
		{ block = "dancing", anim = "dance_loop", time = -1 },
		{ block = "dancing", anim = "dan_down_a", time = -1 },
		{ block = "dancing", anim = "dan_left_a", time = -1 },
		{ block = "dancing", anim = "dan_loop_a", time = -1 },
		{ block = "dancing", anim = "dan_right_a", time = -1 },
		{ block = "dancing", anim = "dan_up_a", time = -1 },
		{ block = "dancing", anim = "dnce_M_a", time = -1 },
		{ block = "dancing", anim = "dnce_M_b", time = -1 },
		{ block = "dancing", anim = "dnce_M_c", time = -1 },
		{ block = "dancing", anim = "dnce_M_d", time = -1 },
		{ block = "dancing", anim = "dnce_M_e", time = -1 },
	},
	reparar =
	{
		{ block = "car", anim = "fixn_car_loop", time = -1, updatePosition = false },
	},
	manos =
	{
		{ block = "ghands", anim = "gsign3lh", time = 4000 },
		{ block = "ghands", anim = "gsign5lh", time = 4000 },
	},
	hablar =
	{
		{ block = "gangs", anim = "prtial_gngtlka", time = -1 },
		{ block = "gangs", anim = "prtial_gngtlkb", time = -1 },
		{ block = "gangs", anim = "prtial_gngtlkc", time = -1 },
		{ block = "gangs", anim = "prtial_gngtlkd", time = -1 },
		{ block = "gangs", anim = "prtial_gngtlke", time = -1 },
		{ block = "gangs", anim = "prtial_gngtlkf", time = -1 },
		{ block = "gangs", anim = "prtial_gngtlkg", time = -1 },
		{ block = "gangs", anim = "prtial_gngtlkh", time = -1 },
		{ block = "gangs", anim = "prtial_gngtlkh", time = -1 },
	},
	gym =
	{
		{ block = "gymnasium", anim = "gym_bike_still", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_bike_slow", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_bike_pedal", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_bike_fast", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_bike_faster", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_tread_tired", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_tread_walk", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_tread_jog", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_tread_sprint", time = -1, updatePosition = false },
	},
	mirarlados =
	{
		{ block = "gangs", anim = "dealer_idle", time = -1 },
	},
	esperarse =
	{
		{ block = "dealer", anim = "dealer_idle", time = -1 },
		{ block = "dealer", anim = "dealer_idle_02", time = -1 },
		{ block = "dealer", anim = "dealer_idle_02", time = -1 },
		{ block = "dealer", anim = "dealer_idle_03", time = -1 },
	},
	besar =
	{
		{ block = "kissing", anim = "grlfrd_kiss_01", time = 4000 },
		{ block = "kissing", anim = "grlfrd_kiss_02", time = 5000 },
		{ block = "kissing", anim = "grlfrd_kiss_03", time = 6000 },
		{ block = "kissing", anim = "playa_kiss_01", time = 4000 },
		{ block = "kissing", anim = "playa_kiss_02", time = 5000 },
		{ block = "kissing", anim = "playa_kiss_03", time = 6000 },
	},
	tumbarse =
	{
		{ block = "beach", anim = "sitnwait_loop_w", time = -1 },
		{ block = "beach", anim = "lay_bac_loop", time = -1 },
		{ block = "int_house", anim = "bed_loop_l", time = -1 },
		{ block = "int_house", anim = "bed_loop_r", time = -1 },
	},
	apoyarse =
	{
		{ block = "gangs", anim = "leanidle", time = -1 },
	},
	paso =
	{
		{ block = "gangs", anim = "invite_no", time = 4000 },
	},
	mirarhora =
	{
		{ block = "clothes", anim = "clo_pose_watch", time = -1 },
	},
	revisarse =
	{
		{ block = "clothes", anim = "clo_pose_torso", time = -1 },
		{ block = "clothes", anim = "clo_pose_shoes", time = -1 },
		{ block = "clothes", anim = "clo_pose_legs", time = -1 },
	},
	sit =
	{
		{ block = "ped", anim = "seat_idle", time = -1 },
		{ block = "food", anim = "ff_Sit_eat1", time = -1 },
		{ block = "beach", anim = "parksit_m_loop", time = -1 },
		{ block = "beach", anim = "parksit_w_loop", time = -1 },
		{ block = "sunbathe", anim = "parksit_m_idlec", time = -1 },
		{ block = "sunbathe", anim = "parksit_w_idlea", time = -1 },
		{ { block = "attractors", anim = "stepsit_in", time = 1200 }, { block = "attractors", anim = "stepsit_loop", time = -1 } },
		{ block = "int_house", anim = "lou_loop", time = -1 },
		{ block = "int_office", anim = "off_sit_drink", time = -1 },
		{ block = "int_office", anim = "off_sit_idle_loop", time = -1 },
		{ block = "int_office", anim = "off_sit_read", time = -1 },
		{ block = "int_office", anim = "off_sit_type_loop", time = -1 },
		{ block = "int_office", anim = "off_sit_watch", time = -1 },
		{ block = "jst_buisness", anim = "girl_02", time = -1 },
	},
	fumarapoyado =
	{
		{ block = "lowrider", anim = "m_smklean_loop", time = -1 },
		{ block = "lowrider", anim = "f_smklean_loop", time = -1 },
	},
	fumar =
	{
		{ block = "lowrider", anim = "m_smkstnd_loop", time = -1 },
		{ block = "gangs", anim = "smkcig_prtl", time = -1 },
	},
	pensar =
	{
		{ { block = "cop_ambient", anim = "coplook_think", time = 2000 }, { block = "cop_ambient", anim = "coplook_think", time = -1 } },
	},
	vomitar =
	{
		{ block = "food", anim = "eat_vomit_p", time = 7000 },
	},
	cansado =
	{
		{ block = "fat", anim = "idle_tired", time = -1 },
	},
	esperar =
	{
		{ block = "cop_ambient", anim = "coplook_loop", time = -1 },
	},
	saludar =
	{
		{ block = "kissing", anim = "gfwave2", time = 2500 },
	},
	okey =
	{
		{ block = "gangs", anim = "invite_yes", time = 4000 },
	},
	chocar =
	{
		{ block = "gangs", anim = "hndshkfa", time = -1 },

    },
	strip =
	{
		{ block = "STRIP", anim = "PLY_CASH", time = -1 },
		{ block = "STRIP", anim = "strip_A", time = -1 },
		{ block = "STRIP", anim = "strip_B", time = -1 },
		{ block = "STRIP", anim = "strip_C", time = -1 },
		{ block = "STRIP", anim = "strip_D", time = -1 },
		{ block = "STRIP", anim = "strip_E", time = -1 },
		{ block = "STRIP", anim = "strip_F", time = -1 },
		{ block = "STRIP", anim = "strip_G", time = -1 },

    },
	cubrirse =
	{
	    { block = "PED", anim = "cower", time = -1 },
		
	},
	orinar =
	{
	    { block = "PAULNMAC", anim = "Piss_loop", time = -1 },
		
	},
	masturbarse =
	{
	    { block = "PAULNMAC", anim = "Wank_loop", time = -1 },
		
	},
	levantarmanos =
	{
	   { { block = "PED", anim = "handsup", time = 1000 }, { block = "PED", anim = "handsup", time = -1 } }
		
	},
	agonizar =
	{
	    { block = "WUZI", anim = "CS_Dead_Guy", time = -1 },
		
	},
	apuntar =
	{
	    { block = "PED", anim = "gang_gunstand", time = -1 },
		
	},
	mostrardedo =
	{
	    { block = "PED", anim = "fucku", time = -1 },
		{ block = "RIOT", anim = "RIOT_FUKU", time = -1 },
		
	},
	chulearse =
	{
	    { block = "RIOT", anim = "RIOT_ANGRY", time = -1 },
		
	},
	hostias =
	{
	    { block = "MISC", anim = "Bitchslap", time = -1 },
		
	},
	mishuevos =
	{
	    { block = "MISC", anim = "scratchballs_01", time = -1 },
		
	},
		smoke =
	{
		{ block = "lowrider", anim = "m_smkstnd_loop", time = -1 },
		{ block = "lowrider", anim = "m_smklean_loop", time = -1 },
		{ block = "lowrider", anim = "f_smklean_loop", time = -1 },
		{ block = "gangs", anim = "smkcig_prtl", time = -1 },
	},
}
	    
--

-- plays a single animation from a table (see above)
local function setAnim( player, anim )
	-- ignore if the player ain't valid anymore or in a vehicle
	if isElement( player ) and anim then
		setPedAnimation( player, anim.block, anim.anim, anim.time or -1, anim.loop == nil and anim.time == -1 or anim.loop or false, anim.updatePosition or false, true )
	end
end

-- play an animation sequence
local function playAnim( player, anim )
	-- time spent on all anims till now
	local time = 0
	
	for key, value in ipairs( anim ) do
		if time == 0 then
			-- first anim, set it directly
			setAnim( player, value )
		else
			-- set the anim delayed
			setTimer( setAnim, time, 1, player, value )
		end
		
		if value.time == -1 then
			-- we got an infinite running anim, no point to check any further
			time = 0
			break
		else
			time = time + value.time
		end
	end
end

--

for key, value in pairs( anims ) do
	addCommandHandler( key,
		function( player, commandName, num )
			if exports.players:isLoggedIn( player ) then
				local anim = tonumber( num ) and value[ tonumber( num ) ] or value[ anim ] or #value == 0 and value or value[ 1 ]
				
				if #anim == 0 then
					anim = { anim }
				end
				
				playAnim( player, anim )
			end
		end
	)
end

--

local function stopAnim( player )
	if exports.players:isLoggedIn( player ) then
		setPedAnimation( player )
	end
end

-- remove a players's animation (equivalent to pressing 'space' on the client)
addCommandHandler( "pararanim", stopAnim )

-- triggered when pressing 'space' as client
addEvent( "anims:reset", true )
addEventHandler( "anims:reset", root,
	function( )
		if client == source then
			stopAnim( source )
		end
	end
)

--

-- runs a user-defined animation by block/name
addCommandHandler( "anim",
	function( player, commandName, block, anim )
		if exports.players:isLoggedIn( player ) then
			if block and anim then
				setPedAnimation( player, block, anim, -1, false, true, true )
			else
				outputChatBox( "Syntax: /" .. commandName .. " [block] [anim]", player, 255, 255, 255 )
			end
		end
	end
)

addCommandHandler("anims", function(thePlayer)
	outputChatBox("--------------------------Lista de Animaciones--------------------------", thePlayer, 0, 255, 255)
	outputChatBox("/beber [1-2] /bar [1-5] /bomb /crack [1-4] /cpr /bailar [1-11] /reparar /manos [1-2] /hablar [1-9] /mirarlados", thePlayer, 0, 255, 255)
	outputChatBox("/gym [1-9] /esperarse [1-4] /besar [1-6] /tumbarse [1-4] /apoyarse /paso /mirarhora /revisarse [1-3] /sit [1-14]", thePlayer, 0, 255, 255)
	outputChatBox("/fumarapoyado [1-2] /fumar [1-2] /pensar /vomitar /cansado /esperar /saludar /okey /chocar /hostia /mishuevos", thePlayer, 0, 255, 255)
	outputChatBox("/strip [1-8] /cubrirse /orinar /masturbarse /levantarmanos /agonizar /apuntar /mostrardedo [1-2] /chulearse", thePlayer, 0, 255, 255)
end)
