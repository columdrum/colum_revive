// #define DEBUG_MODE_FULL
#include "script_component.hpp"
#define _state_blackingOut 801

private ["_knockout", "_dialog", "_grpunit", "_isLeader", "_uncontime", "_normtime", "_awaketime", "_bleed", "_pain", "_endtime", "_doex", "_uconl", "_carrier", "_grp"];

TRACE_1("blacoutTP enter",_this);
if (player getVariable ["ace_w_bout", false]) exitWith {};

player setVariable ["ace_w_bout",true];
player setVariable ["ace_w_wakeup",1];


if (!isnil "TFAR_fnc_forceSpectator") then {
	player setVariable ["tf_unable_to_use_radio", true];
	player setVariable ["tf_globalVolume", 0.01];
	player setVariable ["tf_voiceVolume", 0, true];
};
//player setVariable ["BIS_IS_inAgony",true];
enableRadio false;
//player setUnconscious true;
PARAMS_1(_knockout);
_dialog = false;
_grp = group player;
_isLeader = (player == leader _grp);
if (_isLeader) then {
	_newl = objNull;
	{
		private "_isu";
		_isu = _x call FUNC(isUncon);
		if (_x != player && !_isu && alive _x) exitWith {_newl = _x}
	} forEach units _grp;
	if (!isNull _newl) then {
		[QGVAR(selLeader), [_grp, _newl]] call CBA_fnc_globalEvent;
		{if (_x != player && alive _x) then {_x doFollow _newl}} forEach units _grp;
	};
};
GVAR(specton) = false;
TRACE_1("blackout s1",player);
// Drop out of static weapons
if ((vehicle player) isKindOf "StaticWeapon") then {
	player action ["eject", vehicle player];
};
// Fall down from ladders
if (animationState player in ["ladderriflestatic","laddercivilstatic","ladderrifleuploop","ladderciviluploop"]) then {
	player action ["ladderOff", (nearestBuilding player)];
};
// Release all attachto stuff
if (player getVariable ["ace_sys_cargo_dragging",false]) then {
	_dragged_object = player getVariable ["ace_sys_cargo_dragged_object",objNull];
	if (!isNull _dragged_object) then {
		detach _dragged_object;
	};
};

GVAR(mapunc_keyDownEHId) = -9999;

if (isNil QGVAR(withSpect) || (player getVariable "ace_w_state") != 802) then {
	// Add "M" key down eventhandler (map)
	GVAR(mapunc_keyDownEHId) = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call ace_sys_wounds_fnc_mapunckeydown"];
};
[QGVAR(cap), [player,true]] call CBA_fnc_globalEvent;
TRACE_1("blackout s1.5",(player getVariable "ace_w_state"));
if (isNil QGVAR(withSpect) || ((player getVariable "ace_w_state") != 802)) then {
	TRACE_1("Creating resource for state 802",player);
	if (vehicle player == player) then {
		10002 cutRsc["ACE_Wound_Unconscious1","PLAIN"];
	} else {
		createDialog "ACE_Wound_UnconsciousD1";
		_dialog = true;
	};
};
TRACE_1("blackout s2",player);
if (!isNil "ace_wounds_prevtime") then {
	TRACE_1("blackout s3",player);
	player setVariable ["ace_w_cardiactime", 0];
	if (ace_wounds_prevtime > 0) then {
		if (isNil "ace_wounds_no_prevtime") then {
			ace_wounds_no_prevtime = false;
		};
		if (isNil QGVAR(withSpect)) then {
			if (ace_wounds_no_prevtime) exitWith {};
			if ((player getVariable "ace_w_state") <= _state_blackingOut) exitWith {};
			sleep 2;

			[] spawn {
				10005 cutRsc ["ACE_Wound_Revivetime", "PLAIN"];
				while {(player call FUNC(isUncon)) && alive player} do {
					((uiNamespace getVariable "ACE_Wound_Revivetime") displayCtrl 1234567) ctrlSetText format [localize "STR_ACE_LIFE_TIME_REV", round ((player getVariable "ace_w_revive") - time + (player getVariable "ace_w_cardiactime"))];
					((uiNamespace getVariable "ACE_Wound_Revivetime") displayCtrl 1234567) ctrlCommit 0;
					sleep 1;
				};
				10005 cutRsc["ACE_Wound_UnconsciousNothing","PLAIN"];
			};
		} else {
			[] spawn {
				if ((player getVariable "ace_w_state") != 802) then {
					waitUntil {((player getVariable "ace_w_state") == 802) || !(player call FUNC(isUncon)) || !alive player};
				};
				if ((player call FUNC(isUncon)) && ((player getVariable "ace_w_state") == 802) && alive player) then {
					if (GVAR(mapunc_keyDownEHId) != -9999) then {
						(findDisplay 46) displayRemoveEventHandler ["KeyDown", GVAR(mapunc_keyDownEHId)];
						GVAR(mapunc_keyDownEHId) = -9999;
					};
					if (isNil "ace_sys_spectator_ShownSides") then {ace_sys_spectator_ShownSides = [playerSide]};
					if (isNil "ace_sys_spectator_maxDistance") then {ace_sys_spectator_maxDistance = 10};
					if (isNil "ace_sys_spectator_CheckDist") then {ace_sys_spectator_CheckDist = 250};
					if (isNil "ace_sys_spectator_CheckUncon") then {ace_sys_spectator_CheckUncon = true};
					if (isNil "ace_sys_spectator_RemoveDeadFilter") then {ace_sys_spectator_RemoveDeadFilter = true};
					ace_sys_spectator_no_butterfly_mode = true;
					if (isNil "ace_sys_spectator_playable_only") then {ace_sys_spectator_playable_only = true};
					titleText ["", "BLACK OUT", 3];
					GVAR(specton) = true;
					[] spawn {
						sleep 4;
						10002 cutText ["", "PLAIN"];
						10004 cutText ["", "PLAIN"];
						if (dialog) then {closeDialog 0};
						0.5 fadeSound 1;
						call ace_sys_spectator_fnc_startSpectator;
						titleText ["", "BLACK IN", 1];
					};
				};
			};
		};
	};
};

_normtime = true;
if (!isNil "ace_wounds_prevtime") then {
	if (ace_wounds_prevtime > 0) then {_normtime = false};
};


if (_knockout) then {_normtime = false};

TRACE_1("blackout s4",player);
while {(player call FUNC(isUncon)) && alive player} do {
	_uncontime = 3; _awaketime = 6;
	TRACE_1("blackout s5",player);
	if (_normtime) then {
		_uncontime = 3;
		_awaketime = 6;
		_bleed = player getVariable "ace_w_bleed";
		_pain = player getVariable "ace_w_pain";

		if (_bleed > 0.3 || _pain > 0.3) then {
			_uncontime = _uncontime + (_bleed * 8) + (_pain * 8);
			if (_awaketime > 3) then {
				_awaketime = _awaketime - 0.1;
			};
		};
	} else {
		_uncontime = 5 + random 5;
		_awaketime = 5 + random 5;
	};
	if (isNil QGVAR(withSpect)) then {
		0.5 fadeSound 0;
		10004 cutRsc["ACE_Wound_Unconscious2","PLAIN"];
	} else {
		if (((player getVariable "ace_w_state") != 802) && !GVAR(specton)) then {
			TRACE_1("Creating resource for state 802  2",player);
			0.5 fadeSound 0;
			10004 cutRsc ["ACE_Wound_Unconscious2","PLAIN"];
		};
	};
	TRACE_1("blackout s7",player);
	if (!alive player) exitWith {};
	if (vehicle player == player && (player call FUNC(isUncon)) && isNull (player getVariable ["ace_w_carry", objNull])) then {
		if ((player call CBA_fnc_getUnitDeathAnim) != "DeadState") then {
			[player, 100] call FUNC(animator2);
		};
	};
	if (isNil QGVAR(withSpect)) then {
		if (_dialog) then {
			if (!dialog) then {createDialog "ACE_Wound_UnconsciousD1";};
		} else {
			if (!_dialog && vehicle player != player) then {
				10002 cutRsc ["ACE_Wound_UnconsciousNothing","PLAIN"];
				createDialog "ACE_Wound_UnconsciousD1";
				_dialog = true;
			};
		};
	} else {
		TRACE_1("blackout s6",player);
		if ((player getVariable "ace_w_state") != 802 && !GVAR(specton)) then {
			if (_dialog) then {
				if (!dialog) then {createDialog "ACE_Wound_UnconsciousD1";};
			} else {
				if (!_dialog && vehicle player != player) then {
					10002 cutRsc ["ACE_Wound_UnconsciousNothing","PLAIN"];
					createDialog "ACE_Wound_UnconsciousD1";
					_dialog = true;
				};
			};
		};
	};
	private "_vecp";
	_vecp = (vehicle player != player);
	_endtime = time + _uncontime;
	TRACE_1("blackout s7",player);
	waitUntil {time >= _endtime || !alive player || (_vecp && (vehicle player == player)) || (_dialog && !dialog)};
	if (!alive player) exitWith {};
	if (_dialog && !dialog) then {
		sleep 0.2;
	};
	TRACE_1("blackout s8",player);
	if (vehicle player == player && (player call FUNC(isUncon)) && isNull (player getVariable ["ace_w_carry", objNull])) then {
		if ((player call CBA_fnc_getUnitDeathAnim) != "DeadState") then {
			[player, 100] call FUNC(animator2);
		};
	};
	TRACE_1("blackout s9",player);
	if (vehicle player != player) then {
		_vecx = vehicle player;
		_alv = if (isNil {_vecx getVariable "ace_canmove"}) then {alive _vecx} else {_vecx call ace_v_alive};
		if (!_alv) then {
			player action ["eject", _vecx];
			waitUntil {vehicle player == player};
			if (player call FUNC(isUncon)) then {
				[player, 100] call FUNC(animator2);
			};
		};
	};
	TRACE_1("blackout s10",player);
	if (isNil QGVAR(withSpect)) then {
		if (_dialog) then {
			if (!dialog) then {createDialog "ACE_Wound_UnconsciousD1";};
		} else {
			if (!_dialog && vehicle player != player) then {
				10002 cutRsc["ACE_Wound_UnconsciousNothing","PLAIN"];
				createDialog "ACE_Wound_UnconsciousD1";
				_dialog = true;
			};
		};

		0.5 fadeSound 0.01;
		10004 cutRsc["ACE_Wound_Unconscious3","PLAIN"];
	} else {
		TRACE_1("blackout s11",player);
		if ((player getVariable "ace_w_state") != 802 && !GVAR(specton)) then {
			if (_dialog) then {
				if (!dialog) then {createDialog "ACE_Wound_UnconsciousD1";};
			} else {
				if (!_dialog && vehicle player != player) then {
					10002 cutRsc ["ACE_Wound_UnconsciousNothing","PLAIN"];
					createDialog "ACE_Wound_UnconsciousD1";
					_dialog = true;
				};
			};
			0.5 fadeSound 0.01;
			10004 cutRsc ["ACE_Wound_Unconscious3","PLAIN"];
		};
	};
	_vecp = (vehicle player != player);
	_endtime = time + _awaketime;
	TRACE_1("blackout s12",player);
	waitUntil {time >= _endtime || !alive player || (_vecp && (vehicle player == player)) || (_dialog && !dialog)};
	if (!alive player) exitWith {};
	TRACE_1("blackout s13",player);
	if (_dialog && !dialog) then {
		sleep 0.2;
	};
	TRACE_1("blackout s14",player);
	if (vehicle player == player && (player call FUNC(isUncon)) && isNull (player getVariable ["ace_w_carry", objNull])) then {
		if ((player call CBA_fnc_getUnitDeathAnim) != "DeadState") then {
			[player, 100] call FUNC(animator2);
		};
	};
	if (vehicle player != player) then {
		_vecx = vehicle player;
		_alv = if (isNil {_vecx getVariable "ace_canmove"}) then {alive _vecx} else {_vecx call ace_v_alive};
		if (!_alv) then {
			player action ["eject", _vecx];
			waitUntil {vehicle player == player};
			if (player call FUNC(isUncon)) then {
				[player, 100] call FUNC(animator2);
			};
		};
	};
	TRACE_1("blackout s15",player);
	_doex = false;
	if ((player getVariable "ace_w_state") <= _state_blackingOut) then {
		_uconl = player getVariable "ace_w_unconlen";
		if (_uconl != -1 && time > _uconl) then {_doex = true};
	};
	TRACE_1("blackout s16",player);
	if (_doex) exitWith {};
	if (isNil QGVAR(withSpect)) then {
		if (_dialog) then {
			if (!dialog) then {createDialog "ACE_Wound_UnconsciousD1";};
		} else {
			if (!_dialog && vehicle player != player) then {
				10002 cutRsc["ACE_Wound_UnconsciousNothing","PLAIN"];
				createDialog "ACE_Wound_UnconsciousD1";
				_dialog = true;
			};
		};
	} else {
		if ((player getVariable "ace_w_state") != 802 && !GVAR(specton)) then {
			if (_dialog) then {
				if (!dialog) then {createDialog "ACE_Wound_UnconsciousD1";};
			} else {
				if (!_dialog && vehicle player != player) then {
					10002 cutRsc ["ACE_Wound_UnconsciousNothing","PLAIN"];
					createDialog "ACE_Wound_UnconsciousD1";
					_dialog = true;
				};
			};
		};
	};
};
TRACE_1("loop exit",player);


if (vehicle player != player) then {
	_vecx = vehicle player;
	_alv = if (isNil {_vecx getVariable "ace_canmove"}) then {alive _vecx} else {_vecx call ace_v_alive};
	if (!_alv) then {
		player action ["eject", _vecx];
		waitUntil {vehicle player == player};
		if (player call FUNC(isUncon)) then {
			[player, 100] call FUNC(animator2);
		};
	};
};


if (alive player) then {
	player setVariable ["ace_w_wakeup", 0];

	if (!isNil "ace_sys_wounds_enabled") then {
		player setVariable ["ace_w_unconlen",-1];
		if ((player getVariable "ace_w_state") == _state_blackingOut) then {
			player setVariable [QGVAR(uncon),false,true];
			player setVariable ["ace_w_nextuncon", time + (60 + random 60)]; // add bleeding and pain
		};
	} else {
		player setVariable [QGVAR(uncon),false];
	};

	if (!isNull (player getVariable "ace_w_carry")) then {
		waitUntil {_carrier = player getVariable "ace_w_carry";(isNull _carrier || !alive _carrier)};
		player setVariable ["ace_w_carry", objNull, true];
		sleep 1;
	};

	if (vehicle player == player) then {
		_sec = currentWeapon player;
		if (_sec != "" && _sec != " ") then {
			if (getNumber (configFile >> "CfgWeapons" >> _sec >> "type") == 4) then {
				TRACE_1("Headbugfix",player);
				_iswater = surfaceIsWater getPosASL player;
				_ppos = if (_iswater) then {getPosASL player} else {getPosATL player};
				_pdir = direction player;
				_ACE_HeadbugFix = "ACE_Headbug_Fix" createVehicleLocal _ppos;
				if (_iswater) then {_ACE_HeadbugFix setPosASL _ppos} else {_ACE_HeadbugFix setPosATL _ppos};
				_ACE_HeadbugFix setDir _pdir;
				player moveInDriver _ACE_HeadbugFix;
				waitUntil {vehicle player != player};
				unassignVehicle player;
				player action ["Eject", vehicle player];
				waitUntil {vehicle player == player};
				if (_iswater) then {player setposASL _ppos} else {player setposATL _ppos};
				player setDir _pdir;
				deleteVehicle _ACE_HeadbugFix;
			};
		};


		[player, 102] call FUNC(animator);
		// workaround for the weird animation problem, hopefully solves it, see #17241
		[] spawn {
			TRACE_1("Start Bugfix",player);
			waitUntil {!alive player || (player call FUNC(isUncon)) || vehicle player != player};
			if (vehicle player != player && !(player call FUNC(isUncon)) && alive player) then {
				TRACE_1("Middle Bugfix",player);
				waitUntil {vehicle player == player || !alive player || (player call FUNC(isUncon))};
				if (alive player && !(player call FUNC(isUncon))) then {
					TRACE_1("Bugfix",player);
					[player, 105] call FUNC(animator);
				};
			};
			TRACE_1("Passed Bugfix",player);
		};

		TRACE_1("heal anim",player);
	};
	TRACE_1("heal anim done",player);
	//player setVariable ["BIS_IS_inAgony",false];
	//player setUnconscious false;
};
if (!isNil QGVAR(withSpect) && GVAR(specton)) then {
	//if (GVAR(SPECTATINGON)) then {
		ace_sys_spectator_exit_spectator = true;
		titleText ["", "BLACK IN", 3];
	//};
};
enableRadio true;
if (!isnil "TFAR_fnc_forceSpectator") then {
	player setVariable ["tf_unable_to_use_radio", false];
	player setVariable ["tf_globalVolume", 1];
	player setVariable ["tf_voiceVolume", 1, true];
};
if (!GVAR(specton)) then {
	10004 cutRsc ["ACE_Wound_Unconscious3","PLAIN"];
	if (!_dialog) then {
		10002 cutRsc["ACE_Wound_UnconsciousNothing","PLAIN"];
	} else {
		closeDialog 0;
	};
};

// Remove "M" key down eventhandler
if (GVAR(mapunc_keyDownEHId) != -9999) then {
	(findDisplay 46) displayRemoveEventHandler ["KeyDown", GVAR(mapunc_keyDownEHId)];
};
0.5 fadeSound 1;
[QGVAR(cap), [player,false]] call CBA_fnc_globalEvent;
if (rating player < 0) then {
	player addRating abs(rating player);
};

if (alive player) then {
	if (_isLeader) then {
		[QGVAR(selLeader), [_grp, player]] call CBA_fnc_globalEvent;
		{if (_x != player) then {_x doFollow player}} forEach units _grp;
	};
};
player setVariable ["ace_w_bout",false];


TRACE_1("blackout player done",player);