// #define DEBUG_MODE_FULL
#include "script_component.hpp"

private ["_unit", "_bandage"];

if (typeName _this == "OBJECT") then {
	_unit = _this;
	_bandage = BND;
} else {
	EXPLODE_2(_this,_unit,_bandage);
};

_cur_bleed = _unit getVariable "ace_w_bleed";
_cur_bloodloss = _unit getVariable "ace_w_bleed_add";

_bloodRemove = getNumber(configFile >> "CfgMagazines" >> _bandage >> "ACE" >> "ACE_Wounds" >> "bloodRemove");
_bloodStop = getNumber(configFile >> "CfgMagazines" >> _bandage >> "ACE" >> "ACE_Wounds" >> "bloodStop");

_bleed = _cur_bleed - _bloodRemove;
_bloodloss = _cur_bloodloss * (_bloodStop/100);
if (_bleed < 0.1) then { _bleed = 0 };
if (_bloodloss < 0.1) then { _bloodloss = 0 };

_unit setVariable ["ace_w_bleed", _bleed];
_unit setVariable ["ace_w_bleed_add", _bloodloss];

_unit setVariable ["ace_w_pain_add", 0]; // Also stop adding pain.. but leave the existing pain!

// TODO: Require multiple bandages to stop all bleeding
// perhaps we could record bleeding for most hitpoints seperately
// then you could use a bandage on torso, arms, legs, or head etc.
// and together they accumulate for total bloodloss

private "_isp";
_isp = isPlayer _unit;
switch (_unit getVariable "ace_w_state") do {
	case 800: {
		if (_unit getVariable "ace_w_pain" == 0) then {
			_unit setVariable ["ace_w_state", 0];
			if (!(isNil "ace_wounds_prevtime") && _isp) then {
				_unit setVariable ["ace_w_revive", -1];
			};
			if (_isp) then {[_unit, 0] call FUNC(setStamina)};
		};
	};
	case 801: {
		if ((_unit getVariable "ace_w_pain") > 0 && (_unit getVariable "ace_w_epi") == 0) then {
			_unit setVariable ["ace_w_pain", 0.4];
			_unit setVariable ["ace_w_pain_add", STATE_801_PAIN_ADD];
			_unit setVariable ["ace_w_state", 800];
			if (_isp) then {[_unit, 2] call FUNC(divStamina)};
		} else {
			if ((_unit getVariable "ace_w_pain" == 0) && (_unit getVariable "ace_w_epi") == 0) then {
				if (_unit getVariable QGVAR(uncon)) then {
					_unit setVariable [QGVAR(uncon), false, true];
				};
				_unit setVariable ["ace_w_state", 0];
				if (!(isNil "ace_wounds_prevtime") && _isp) then {
					_unit setVariable ["ace_w_revive", -1];
				};
				if (_isp) then {[_unit, 0] call FUNC(setStamina)};
			};
		};
	};
	case 802: {
		if ((_unit getVariable "ace_w_pain") == 0 && (_unit getVariable "ace_w_epi") == 0) then {
			_unit setVariable [QGVAR(uncon), false, true];
			_unit setVariable ["ace_w_state", 0];
			if (_isp) then {[_unit, 0] call FUNC(setStamina)};
			if (!(isNil "ace_wounds_prevtime") && _isp) then {
				_unit setVariable ["ace_w_revive", -1];
			};
		};
	};
};
