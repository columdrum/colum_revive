#include "script_component.hpp"

private ["_exit_it", "_allowed"];

_exit_it = false;
if (!isNil "ace_sys_wounds_medics_only") then {
	_nearMedicFacility = [player] call FUNC(nearMedicalFacility);
	if (!_nearMedicFacility && !([player] call FUNC(isMedic))) then {
		hintSilent (localize "STR_ACE_WOUNDS_NO_MORPH");
		_exit_it = true;
	};
};
if (_exit_it) exitWith {};


_allowed = [player, player, MOR] call FUNC(takeItem);
if !(_allowed) exitWith {};

player setVariable ["ACE_PB_Result", 0];
[6,[localize "STR_ACE_UA_USEMORPHI"],true,true] spawn ace_progressbar;
playSound "ACE_Injector";
waitUntil { (player getVariable "ACE_PB_Result" != 0) };
if (player getVariable "ACE_PB_Result" == 1) then {
	playSound "ACE_Injector";

	player setVariable ["ace_w_pain",0];
	player setVariable ["ace_w_pain_add",0];
	player call FUNC(RemovePain);
};
