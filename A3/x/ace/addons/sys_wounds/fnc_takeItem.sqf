#include "script_component.hpp"

private "_isMedic";
PARAMS_3(_receiver,_helper,_item);
_isMedic = [_helper] call FUNC(isMedic);

// RECEIVER items test

if (_item in (magazines _receiver)) exitWith {
	// TODO: Account for Gear menu open -> items should be in IFAKK, so magazines array doesn't include BND/MOR/EPI
	if !(_isMedic && (GVAR(medical_oasis) || _item == BND)) then {
		TRACE_2("Taking item from receiver",_receiver,_item);
		if (local _receiver) then { _receiver removeMagazine _item } else { [QGVAR(remove_mag), [_receiver, _item]] call CBA_fnc_globalEvent };
	};
	true;
};

if (_helper == _receiver) exitWith { false; };

// HELPER items test
if (_item in (magazines _helper)) exitWith {
	// TODO: Account for Gear menu open -> items should be in IFAKK, so magazines array doesn't include BND/MOR/EPI
	if !(_isMedic && (GVAR(medical_oasis) || _item == BND)) then {
		TRACE_2("Taking item from helper",_helper,_item);
		if (local _helper) then { _helper removeMagazine _item } else { [QGVAR(remove_mag), [_helper, _item]] call CBA_fnc_globalEvent };
	};
	true;
};

false;
