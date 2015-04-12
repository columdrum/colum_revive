#include "script_component.hpp"

// Heal treatment by Medics, possible at medical objects like Mash etc.
#define MEDKIT "ACE_Medkit"
#define TREAT_TIME 120

PARAMS_3(_unit,_healer,_damage);

_isTheP = player == _healer;
if !(alive _unit) exitWith {
	if (_isTheP) then { hintSilent (localize "STR_ACE_WOUNDS_HEISDEAD") };
};

// _isMed = [_healer] call FUNC(isMedic);

_allowed = [_unit, _healer, MEDKIT] call FUNC(takeItem);

if !(_allowed) exitWith {
	if (_isTheP) then { hintSilent "No MedKit" };
};

if (_damage == 0) exitWith {
	if (_isTheP) then { hintSilent "He looks fine" };
};

if (_isTheP) then { hintSilent ("Treating: " + name _unit) };

_nearMedicFacility = [_unit] call FUNC(nearMedicalFacility);
_coef = if (_nearMedicFacility) then { 0.5 } else { 1 };
_timeOut = (TREAT_TIME * _coef) * _damage;
_endTime = time + _timeOut;

// Play animation on the other unit
if (_unit != _healer) then { [QGVAR(surg), [_unit,_timeOut]] call CBA_fnc_whereLocalEvent };

_healer setVariable ["ace_w_healing", true];
_abort = false;

_healer setVariable ["ACE_PB_Result", 0];
[_timeOut,[localize "STR_ACE_UA_HEAL"],true,true] spawn ace_progressbar;
_healer playMove "AinvPknlMstpSlayWrflDnon_medic";

[_healer] spawn {
	PARAMS_1(_healer);
	while { _healer getVariable "ace_w_healing" } do {
		sleep 0.5;
	};
	_healer setVariable ["ACE_PB_Abort",true];
};

waitUntil { (_healer getVariable "ACE_PB_Result" != 0) };
if (_healer getVariable "ACE_PB_Result" == 1) then {
	_treated = if (_nearMedicFacility) then { localize "STR_ACE_WOUNDS_HEALED" } else { localize "STR_ACE_WOUNDS_PATCHED" };
	if (_isTheP) then { hintSilent (localize "STR_ACE_WOUNDS_SUCK" + " " + _treated) };

	// Only leave damage when not near a medical facility
	_vars = [_unit];
	if (_nearMedicFacility) then { PUSH(_vars,0) }; // && _isMed ?? Perhaps in the 'hard-core' version (option)

	[QGVAR(heal), _vars] call CBA_fnc_whereLocalEvent;
};
_healer setVariable ["ace_w_healing", false];
if (_unit != _healer) then { [QGVAR(surg_abort), _unit] call CBA_fnc_whereLocalEvent };

//while {time < _endTime} do {
	//if !(alive _healer) exitWith { _abort = true };
	//_healer playMove "AinvPknlMstpSlayWrflDnon_medic";
	// waitUntil {animationState _healer != "AinvPknlMstpSlayWrflDnon_medic"};
	//if !(_healer getVariable ["ace_w_healing", false]) exitWith {
	//	_abort = true;
	//	if (_isTheP) then { hintSilent (localize "STR_ACE_LADEBALKEN_CANCELLED") };
	//};
	//if (_healer distance _unit > 8) exitWith {
	//	_abort = true;
	//	if (_isTheP) then { hintSilent (localize "STR_ACE_LADEBALKEN_CANCELLED") };
	//};
	//if !(alive _unit) exitWith {};
	//sleep 1;
//};

//if (_abort) exitWith { _healer setVariable ["ace_w_healing", false]; if (_unit != _healer) then { [QGVAR(surg_abort), [_unit]] call CBA_fnc_globalEvent } };

//if !(alive _unit) exitWith {
//	if (_isTheP) then { hintSilent (localize "STR_ACE_WOUNDS_HEISDEAD"); _healer setVariable ["ace_w_healing", false]; };
//};


