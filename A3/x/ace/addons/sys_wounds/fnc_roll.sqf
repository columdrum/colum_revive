// AI Auto rolling...

#include "script_component.hpp"

PARAMS_1(_unit);

if !(alive _unit) exitWith {};
if (_unit call FUNC(isUncon)) exitWith {};
// _animation = animationState _unit;
_unit playMove "AinjPpneMstpSnonWrflDnon";
sleep 4;
if !(alive _unit) exitWith {};
_unitBurns = [_unit] call ACE_fnc_isBurning;
if (_unitBurns && random 100 < 33) then {
	[QGVAR(burnoff), _unit] call CBA_fnc_globalEvent;
};

if (_unit call FUNC(isUncon)) exitWith {};
_unit playMove "aidlppnemstpsraswrfldnon0s";
