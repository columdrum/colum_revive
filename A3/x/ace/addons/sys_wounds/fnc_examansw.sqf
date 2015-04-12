/* ace_sys_wounds(.pbo) */
// _this (c) by Xeno
// Displays a hint with person's medical condition and required treatment.
// Exec: local to caller
#include "script_component.hpp"

#define __SPACE " "

private ["_check", "_uncon", "_ok", "_idcs"];
PARAMS_6(_receiver,_sender,_state,_epi,_bleed,_pain);

TRACE_1("Examine wounds answer:",_this);

if (!alive _sender) exitWith {};

_check = format [localize "STR_ACE_WOUNDS_CHECK_START", name _receiver]; // "%1 is"

_uncon = _receiver call FUNC(isUncon);

if (!_uncon) then {
	_check = _check + __SPACE + (localize "STR_ACE_WOUNDS_CHECK_NOT_UNC"); // "conscious"
	if (_epi > 0) then {
		_check = _check + __SPACE + (localize "STR_ACE_WOUNDS_CHECK_BUT_EPI"); // "but needs epinephrine.\n"
	} else {
		_check = _check + ".\n";
	};
} else {
	_check = _check + __SPACE + (localize "STR_ACE_WOUNDS_CHECK_UNC"); // "unconscious"
	if (_epi > 0) then {
		_check = _check + __SPACE + (localize "STR_ACE_WOUNDS_CHECK_AND_EPI"); // "and needs epinephrine.\n"
	} else {
		_check = _check + ".\n";
	};
};

if (_bleed == 0) then {
	_check = _check + (localize "STR_ACE_WOUNDS_CHECK_NOT_BLEED"); // "He is not bleeding.\n"
} else {
	if (_bleed > 0.45) then {
		_check = _check + (localize "STR_ACE_WOUNDS_CHECK_BLEED_HEAVY"); // "He is bleeding heavily and needs to get bandaged.\n"	
	} else {
		_check = _check + (localize "STR_ACE_WOUNDS_CHECK_BLEED"); // "He is bleeding and needs to get bandaged.\n"
	}
};

if (_pain == 0) then {
	_check = _check + (localize "STR_ACE_WOUNDS_CHECK_NOT_PAIN"); // "He has no pain.\n"
} else {
	_check = _check + (localize "STR_ACE_WOUNDS_CHECK_PAIN"); // "He has pain and needs morphine.\n"
};

hintSilent _check;

ace_sys_wounds_receiver = _receiver;
ace_sys_wounds_recstate = _state;
ace_sys_wounds_recAnswer = _this;

if (!local _receiver) then {
	[
		ace_sys_wounds_receiver,
		[[QUOTE(PATHTO(fnc_menuDef_Self)), "treat person"]]
	] call cba_ui_fnc_menu;
};

false
