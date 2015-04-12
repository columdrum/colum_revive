/* ace_sys_interaction (.pbo) | (c) 2009 by rocko */
// _this (c) by Xeno
// Gathers the medical state of a person (patient).
// If the caller is not local, then send the patient's medical state via a networked answer variable back to the caller.
// Exec: local to receiver (patient)

#include "script_component.hpp"

private ["_receiver", "_sender"];
PARAMS_2(_receiver,_sender);

TRACE_2("Examine unit",_receiver,_sender);

if (!local _receiver) exitWith {};

private "_answer";
// not final
_answer = [_receiver, _sender, _receiver getVariable "ace_w_state",
	_receiver getVariable "ace_w_epi", _receiver getVariable "ace_w_bleed",
	_receiver getVariable "ace_w_pain", _receiver getVariable "ace_w_wakeup",
	[_receiver] call ace_sys_wounds_fnc_getDamage, _receiver getVariable ["ace_w_healing_r", false],
	[_receiver] call ace_sys_wounds_fnc_canHeal
	];
//	_receiver getVariable "ace_w_head_hit", _receiver getVariable "ace_w_body",
//	_receiver getVariable "ace_w_legs", _receiver getVariable "ace_w_head_hands"

if (!local _sender) then {
	[QUOTE(GVAR(examansw)), _answer] call CBA_fnc_globalEvent;
} else {
	[QUOTE(GVAR(examansw)), _answer] call CBA_fnc_localEvent;
};
