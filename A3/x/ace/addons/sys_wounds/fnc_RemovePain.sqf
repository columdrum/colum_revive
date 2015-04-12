#include "script_component.hpp"

_this setVariable ["ace_w_pain", 0];
_this setVariable ["ace_w_pain_add", 0];
private "_isp";
_isp = isPlayer _this;
switch (_this getVariable "ace_w_state") do {
	case 800: {
		if (_this getVariable "ace_w_bleed" == 0) then {
			_this setVariable ["ace_w_state", 0];
			if (!(isNil "ace_wounds_prevtime") && _isp) then {
				_this setVariable ["ace_w_revive", -1];
			};
			if (_isp) then {[_this, 0] call FUNC(setStamina)};
		};
	};
	case 801: {
		if ((_this getVariable "ace_w_bleed") > 0 && (_this getVariable "ace_w_epi") == 0) then {
			_this setVariable ["ace_w_bleed", 0.4];
			_this setVariable ["ace_w_bleed_add", STATE_801_BLOSS_ADD];
			_this setVariable ["ace_w_state", 800];
			if (_isp) then {[_this, 2] call FUNC(divStamina)};
		} else {
			if ((_this getVariable "ace_w_bleed" == 0) && (_this getVariable "ace_w_epi") == 0) then {
				if (_this getVariable QGVAR(uncon)) then {
					_this setVariable [QGVAR(uncon), false, true];
				};
				_this setVariable ["ace_w_state", 0];
				if (!(isNil "ace_wounds_prevtime") && _isp) then {
					_this setVariable ["ace_w_revive", -1];
				};
				if (_isp) then {[_this, 0] call FUNC(setStamina)};
			};
		};
	};
	case 802: {
		if ((_this getVariable "ace_w_bleed") == 0 && (_this getVariable "ace_w_epi") == 0) then {
			_this setVariable [QGVAR(uncon), false, true];
			_this setVariable ["ace_w_state", 0];
			if (!(isNil "ace_wounds_prevtime") && _isp) then {
				_this setVariable ["ace_w_revive", -1];
			};
			if (_isp) then {[_this, 0] call FUNC(setStamina)};
		};
	};
};
