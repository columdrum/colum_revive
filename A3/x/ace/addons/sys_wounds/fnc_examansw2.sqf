/* ace_sys_interaction (.pbo) | (c) 2009 by rocko */
// _this (c) by Xeno
// Initiates the display of a medical report of a person.
// If that patient is not local, then read their medical state via a networked answer variable.
// Exec: local to caller

#include "script_component.hpp"

private ["_receiver", "_sender", "_state", "_wakeup", "_damage"];
PARAMS_3(_receiver,_sender,_state);
_wakeup = _this select 6;
_damage = _this select 7;

TRACE_1("Examine answer:",_this);

if (_sender != player) exitWith {};
if (!alive player) exitWith {};

if (isNil "_state") then {_state = 0};
if (isNil "_wakeup") then {_wakeup = 0};
if (isNil "_damage") then {_damage = 0};

if (_state == 0 && _wakeup == 0 && _damage == 0) exitWith {
	hintSilent format[localize "STR_DN_ACE_BLUEBLUEEYES", name _receiver];
};

if (_state == 0 && _wakeup == 1) exitWith {
	hintSilent format[localize "STR_DN_ACE_SLEEPINGDOWN", name _receiver];
};

_this spawn ace_sys_wounds_fnc_examansw;

false