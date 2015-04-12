/* ace_sys_wounds(.pbo)  */
#include "script_component.hpp"

// _this (c) by Xeno

closeDialog 0;

private ["_receiver", "_state", "_exit_it"];
PARAMS_2(_receiver,_state);

TRACE_1("Morphine", _receiver);

if (!alive player) exitWith {};

if (!alive _receiver) exitWith {
	hintSilent format [localize "STR_ACE_WOUNDS_XDEAD", name _receiver];
};

_exit_it = false;
if (!isNil "ace_sys_wounds_medics_only") then {
	_nearMedicFacility = [_receiver] call FUNC(nearMedicalFacility);
	if (!_nearMedicFacility && !([player] call FUNC(isMedic))) then {
		hintSilent localize "STR_ACE_WOUNDS_NO_MORPH";
		_exit_it = true;
	};
};
if (_exit_it) exitWith {};

_allowed = [_receiver, player, MOR] call FUNC(takeItem);
if !(_allowed) exitWith {}; // No item!

player setVariable ["ace_w_busy",true];
player setVariable ["ACE_PB_Result", 0];
_delay = if ([player] call FUNC(isMedic)) then { 8 } else {13};
[_delay,[localize "STR_ACE_UA_USEMORPHI"],true,true] spawn ace_progressbar;
playSound "ACE_Injector";
waitUntil { (player getVariable "ACE_PB_Result" != 0) };
if (player getVariable "ACE_PB_Result" == 1) then {
	[_receiver, 1] call FUNC(animator2);
};
player setVariable ["ace_w_busy",false];
false
