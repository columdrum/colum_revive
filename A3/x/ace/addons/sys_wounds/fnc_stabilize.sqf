/* ace_sys_wounds(.pbo)  */
// Will reduce bloodloss ~25%, painadd ~15 %
//
/* tbd
// #define DEBUG_MODE_FULL
#include "script_component.hpp"

closeDialog 0;

private ["_receiver", "_state", "_h"];
PARAMS_2(_receiver,_state);

if (!alive player) exitWith {};
if (!alive _receiver) exitWith {
	hintSilent format [localize "STR_ACE_WOUNDS_XDEAD", name _receiver];
};
_ismed = [player] call FUNC(isMedic);

if !(_ismed) exitWith {}; // No item!
player setVariable ["ace_w_busy",true];
player playMove "AinvPknlMstpSlayWrflDnon_medic";

[_receiver, 0] call FUNC(animator2);

[] spawn {
	sleep 5;
	player setVariable ["ace_w_busy",false];
};
false
*/