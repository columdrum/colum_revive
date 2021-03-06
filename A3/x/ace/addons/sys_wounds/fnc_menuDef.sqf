// #define DEBUG_MODE_FULL
#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

private ["_menuDef", "_menuName", "_menuRsc", "_menus"];

// _this==[_target, _menuNameOrParams]
PARAMS_2(_target,_params);


if (_target isKindOf "CAManBase" && (_target distance player) > 2.5) exitWith { TRACE_1("Too far away",_target); []}; // TODO: Menu range is way to big, should not be > 2.5 - 3 m ! // Menu title still becomes shown though

_menuName = "";
_menuRsc = "popup";

if (typeName _params == typeName []) then {
	if (count _params < 1) exitWith {diag_log format["Error: Invalid params: %1, %2", _this, __FILE__]};
	_menuName = _params select 0;
	_menuRsc = if (count _params > 1) then {_params select 1} else {_menuRsc};
} else {
	_menuName = _params;
};
//-----------------------------------------------------------------------------
_vehicle = if (_target isKindOf "allVehicles") then {_target} else {objNull};

_inVehicle = (player != vehicle player);
//_playerIsBusy = (animationState player == "AinvPknlMstpSlayWrflDnon_medic") || _inVehicle;
_capable = alive player && !(player call FUNC(isUncon)) && !_inVehicle;


// Local?
_targetIsLocal = local _target;

private ["_bleed", "_pain", "_epi"];
if (local _target) then {
	_bleed = _target getVariable ["ace_w_bleed", 0];
	_pain = _target getVariable ["ace_w_pain", 0];
	_epi = _target getVariable ["ace_w_epi", 0];
} else {
	if (count GVAR(recAnswer) >= 7) then {
		_bleed = GVAR(recAnswer) select 4;
		_pain = GVAR(recAnswer) select 5;
		_epi = GVAR(recAnswer) select 3;
	} else {
		_bleed = 0;
		_pain = 0;
		_epi = 0;
	};
};
// Check if unit is in a critical condition, i.e untreated but conscious
_targetCriticalCond = (_bleed > 0 || _epi > 0 || _pain > 0);
_targetNotSoCriticalCond = (_bleed > 0 || _epi > 0);
_targetNotCritical = (_bleed <= 0 || _epi <= 0 || _pain <= 0);


_hasTransportAbility = (getNumber(configFile >> "cfgVehicles" >> typeOf _vehicle >> "transportSoldier") > 0);
_freeCargoSeats = 0;
//if (GVAR(drag) || GVAR(carry)) then {
	if (!(_vehicle isKindOf "ParachuteBase") && !(_vehicle isKindOf "BIS_Steerable_Parachute") && !(_vehicle isKindOf "UAV")) then {
		_freeCargoSeats = _vehicle emptyPositions "cargo";
	};
//};

cba_ui_dragPerson = objNull;
//if (GVAR(drag) || GVAR(carry)) then {
	private ['_list', '_i'];
	_list = nearestObjects [player, ["CAManBase"], 1.5];
	_list = _list - [player]; // Player is always in the list

	//_i = 0;
	//{
	//	if (_x == player) then
	//	{
	//		_list set [_i, -1];
	//	};
	//	_i = _i + 1;
	//} forEach _list;
	//_list = _list-[-1];

	// TODO: This may need to be made a little more accurate when 2 people are close by.
	if (count _list > 0) then {
		cba_ui_dragPerson = _list select 0;
	};
	//player sideChat str [time, _list, count _list];
//};

_uncon = _target call FUNC(isUncon);
//-----------------------------------------------------------------------------
private "_name_dragee";

GVAR(targets) = [_target, "MAN"];
#define __Examine (localize "STR_ACE_UA_EXAMINE")

#define __DRAG (localize "BC_addActions.sqf13") 			// "Drag"
#define __CARRY (localize "STR_ACE_UA_CARRYWOUNDED") 		// "Carry %1"
#define __CARRYDIS (localize "STR_ACE_UA_CARRYDISABLED") 	// "Help %1 walking"
#define __DROP (localize "STR_ACE_UA_DROP") 				// "Drop %1"
#define __LOAD (localize "STR_ACE_UA_LOAD") 				// "Load %1 into %2"
#define __UNLOAD (localize "STR_ACE_WOUNDS_BODYUNLOAD") 	// "Pull unit out of vehicle"
#define __MOVETOCARGO (localize "STR_ACE_WOUNDS_MOVETOCARGO") 	// "Move unit to cargo"


_name_dragee = localize "STR_ACE_NO_UNIT"; 					// "body"
if (_target isKindOf "CAManBase") then {
	if (alive _target) then {if (name _target != "Error: No unit") then {_name_dragee = name _target}};
};

_displayName = getText (configFile >> "cfgVehicles" >> typeOf _target >> "displayName");
if (_displayName == "") then {_displayName = typeOf _target};

TRACE_6("",_unCon,_capable, alive _target, canStand _target, GVAR(drag),_list);

_menus =
[
	[
		["main", _name_dragee, _menuRsc],
		[
			// if (local) then use instant sub-menu
			[__Examine+" >",
				"", // no action
				"", "Examine",
				[QPATHTO_F(fnc_menuDef_Self), "treat person", 1], // special case handling: local object, use sub-menu
				DIK_E, 1, _capable && _targetIsLocal && !isNil QGVAR(enabled) && !GVAR(drag)],

			// else if (!local) then initiate network query, wait for reply and show delayed separate menu.
			[__Examine+"...",
				{[cba_ui_target] spawn FUNC(examine)}, // special case handling: next menu is opened by answer script
				"", "Examine",
				"", // no sub-menu
				DIK_E, 1, _capable && !_targetIsLocal && !isNil QGVAR(enabled) && !GVAR(drag)],

			// Help, Carry disabled
			[format["<t size='0.70'>"+localize "STR_ACE_UA_CARRYDISABLED"+"</t>",_name_dragee],
				{ [cba_ui_target, player, -1, cba_ui_target] spawn COMPILE_FILE(carrydisabled) },
				"", "", "", -1, !_uncon && !_targetNotSoCriticalCond,
				_capable && alive _target && !canStand _target && !GVAR(drag) && canStand player],

			// Drag
			[__DRAG,
				{ [GVAR(targets) select 0] spawn FUNC(drag) },
				"", "", "", DIK_D, 1,
				_capable && (alive _target && _uncon) && !GVAR(drag) && canStand player],


			[localize "STR_ACE_BODYBAG",
				{ [cba_ui_target] spawn FUNC(bodybag) },
				"", "", "", -1, 1, !alive _target && ("ACE_Bodybag" in (magazines player)) && _capable]
		]
	]
];
//-----------------------------------------------------------------------------
// create list of unconscious people inside vehicle
_list = [];
GVAR(unconlist) = [];

TRACE_2("",_target,GVAR(drag));

{
	if (!alive _x || (alive _x && (_x call FUNC(isUncon)))) then {
		TRACE_2("Found Unconsious/Dead unit in vehicle", _x,alive _x);
		PUSH(GVAR(unconlist),_x);
	};
} forEach crew _target;

TRACE_1("",GVAR(unconlist));

// create menu to unload unconscious people from inside vehicle
{
	_uncon2 = _x call FUNC(isUncon);

	if (alive _x && _uncon2) then {
		TRACE_1("Adding Found Unconsious unit to list", _x);
		_list set [count _list,
				[format["<t size='0.6'>" + __UNLOAD + "</t>", name _x],
				format['[GVAR(unconlist) select %1] spawn FUNC(pullvec)', _forEachIndex],
				"", name _x, "",-1, count (crew _target) > 0, 1]
		];
		if (!(_x in (assignedCargo _target)) && (_target emptyPositions "cargo") >0) then {
			_list set [count _list,
					[format["<t size='0.6'>" + __MOVETOCARGO + "</t>", name _x],
					format['[GVAR(unconlist) select %1] spawn FUNC(moveUnconToCargo)', _forEachIndex],
					"", name _x, "",-1, count (crew _target) > 0, 1]
			];
		};
	};
} forEach GVAR(unconlist);

_menus set [count _menus,
	[
		["vehicle", _displayName, _menuRsc],
		[
				[format["<t size='0.6'>" + __LOAD + "</t>", name cba_ui_dragPerson, _displayName],
				{ [cba_ui_target, player, -1, [cba_ui_dragPerson, cba_ui_target]] spawn COMPILE_FILE(load) },
				"", _name_dragee, "", DIK_D, // don't use DIK_L
				_freeCargoSeats > 0 && _hasTransportAbility && !isNull cba_ui_dragPerson, alive cba_ui_dragPerson]
		] +
		_list
	]
];

//-----------------------------------------------------------------------------
_menuDef = [];
{
	if (_x select 0 select 0 == _menuName) exitWith {_menuDef = _x};
} forEach _menus;

if (count _menuDef == 0) then {
	hintC format ["Error: Menu not found: %1\n%2\n%3", str _menuName, if (_menuName == "") then {_this} else {""}, __FILE__];
	diag_log format ["Error: Menu not found: %1, %2, %3", str _menuName, _params, __FILE__];
};

_menuDef // return value
