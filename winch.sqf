/*


FM Winden script - by Florian


Erstellt eine Winden funktion für den UH-60


*/
fm_heli = h1;


if (isServer) then {
// Create Rope

Rope = ropeCreate [fm_heli, [1.4,1.9,0.1], 1];
_ends = ropeEndPosition (Rope);
_end1 = _ends select 0;
_end2 = _ends select 1;


// Create Hook

fm_veh = createVehicle ["Land_Battery_F", _end2, [], 0, "CAN_COLLIDE"];
[fm_veh] ropeAttachTo Rope;



// Create Mainparent in Ace Menü

_fm_winde = [
			"fm_winde",
			"Winde",
			"",
			{},
			{true},
			nil,
			[west],
			nil,
			5,
			[false, true, false, false, false]
] call ace_interact_menu_fnc_createAction;

[fm_heli, 1, ["ACE_SelfActions"], _fm_winde] call ace_interact_menu_fnc_addActionToObject;


// Create funktion to winch out

_fm_windeausfahren = [
			"fm_windeausfahren",
			"Winde Ausfahren",
			"",
			{playSound3D ["A3\Sounds_F\air\sfx\SL_engineDownEXT.wss", h1]; ropeUnwind [ Rope, 1, 21];},
			{true},
			nil,
			[west],
			nil,
			5,
			[false, true, false, false, false]
] call ace_interact_menu_fnc_createAction;

[fm_heli, 1, ["ACE_SelfActions","fm_winde"], _fm_windeausfahren] call ace_interact_menu_fnc_addActionToObject;

// Create funktion to winch in

_fm_windeeinfahren = [
			"fm_windeeinfahren",
			"Winde Einfahren",
			"",
			{playSound3D ["A3\Sounds_F\air\sfx\SL_engineUpEXT.wss", h1]; ropeUnwind [ Rope, 1, -20];},
			{true},
			nil,
			[west]
] call ace_interact_menu_fnc_createAction;

[fm_heli, 1, ["ACE_SelfActions","fm_winde"], _fm_windeeinfahren] call ace_interact_menu_fnc_addActionToObject;

// Create funktion to cut the Rope

_fm_seiltrennen = [
			"fm_seiltrennen",
			("<t color=""#FF0000"">" + ("Seil Abschneiden") + "</t>"),
			"",
			{
				playSound3D ["A3\Sounds_F\air\sfx\SL_rope_break.wss", h1];
				ropeCut [ Rope, 1];
				deleteVehicle veh;
				[player,1,["ACE_SelfActions","fm_winde","fm_windeausfahren"]] call ace_interact_menu_fnc_removeActionFromObject;
				[player,1,["ACE_SelfActions","fm_winde","fm_windeeinfahren"]] call ace_interact_menu_fnc_removeActionFromObject;
				[player,1,["ACE_SelfActions","fm_winde","fm_seiltrennen"]] call ace_interact_menu_fnc_removeActionFromObject;
				[player,1,["ACE_SelfActions","fm_winde","fm_abseilen"]] call ace_interact_menu_fnc_removeActionFromObject;
				[player,1,["ACE_SelfActions","fm_ausklinken"]] call ace_interact_menu_fnc_removeActionFromObject;
				[veh, 0, ["ACE_MainActions","fm_einklinken"]] call ace_interact_menu_fnc_removeActionFromObject;
			},
			{true},
			nil,
			[west]
] call ace_interact_menu_fnc_createAction;

[fm_heli, 1, ["ACE_SelfActions","fm_winde"], _fm_seiltrennen] call ace_interact_menu_fnc_addActionToObject;


// Create Funktion to Player attach to hook in helikopter

_fm_abseilen = [
			"fm_abseilen",
			"Abseilen",
			"",
			{
				MoveOut player;
				player setPos (getPos fm_veh);
				player attachTo [fm_veh];
				playSound3D ["A3\Sounds_F\weapons\Other\sfx4.wss", fm_veh];
			},
			{fm_heli animationPhase "doorhandler_R" ==1},
			nil,
			[west]
] call ace_interact_menu_fnc_createAction;

[fm_heli, 1, ["ACE_SelfActions","fm_winde"], _fm_abseilen] call ace_interact_menu_fnc_addActionToObject;

// Create funktion to deattach player from hook



_fm_ausklinken = [
			"fm_ausklinken",
			"Ausklinken",
			"",
			{	if ((player distance fm_heli) < 5) then
					{
						player moveInCargo fm_heli;
						detach player;
						playSound3D ["A3\Sounds_F\weapons\Other\sfx4.wss", fm_veh];
					} else {
						detach player;
						playSound3D ["A3\Sounds_F\weapons\Other\sfx4.wss", fm_veh];
					}
			},
			{!(vehicle player isKindOf "RHS_UH60M_MEV2_d")},
			nil,
			[west]
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions"], _fm_ausklinken] call ace_interact_menu_fnc_addActionToObject;


// Create funktion on hock to attach player to hook

_fm_einklinken = [
			"fm_einklinken",
			"Einklinken",
			"",
			{player setPos (getPos fm_veh); player attachTo [fm_veh]; playSound3D ["A3\Sounds_F\weapons\Other\sfx4.wss", fm_veh];},
			{!(vehicle player isKindOf "RHS_UH60M_MEV2_d")},
			nil,
			[west],
			nil,
			5
] call ace_interact_menu_fnc_createAction;

[fm_veh, 0, ["ACE_MainActions"], _fm_einklinken] call ace_interact_menu_fnc_addActionToObject;


_fm_patienteinhaken = [
			"fm_patienteinhaken",
			"Person einhaken",
			"",
			{	if ((cursorTarget distance fm_veh) < 5) then
					{
						cursorTarget setPos (getPos fm_veh);
						cursorTarget attachTo [fm_veh];
						playSound3D ["A3\Sounds_F\weapons\Other\sfx4.wss", fm_veh];
					} else {
						hint "Zu weit entfernt"

					}
			},
			{!(vehicle player isKindOf "RHS_UH60M_MEV2_d")},
			nil,
			[west]
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions"], _fm_patienteinhaken] call ace_interact_menu_fnc_addActionToObject;



_fm_patienteinladen = [
			"fm_patienteinladen",
			"Person Einladen",
			"",
			{
				_patienten = attachedObjects fm_veh;
				_patient = _patienten select 0;
				_patient moveInCargo h1;
				detach _patient;
				playSound3D ["A3\Sounds_F\weapons\Other\sfx4.wss", fm_veh];
			},
			{fm_heli animationPhase "doorhandler_R" ==1},
			nil,
			[west]
] call ace_interact_menu_fnc_createAction;

[fm_heli, 1, ["ACE_SelfActions","fm_winde"], _fm_patienteinladen] call ace_interact_menu_fnc_addActionToObject;

};