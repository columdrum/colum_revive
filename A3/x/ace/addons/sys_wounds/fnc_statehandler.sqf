// #define DEBUG_MODE_FULL
#include "script_component.hpp"
#define DELAY (7 + random 8)
#define CYCLE_TIME 0.15

private ["_unit", "_oldstate", "_nextcrytime", "_state", "_bleed", "_pain", "_btime", "_doexit", "_etime",
	"_whichsound", "_ranval", "_spaction", "_withPMR", "_painExtra", "_bleedExtra", "_lastRequest", "_setSkilled", "_skill"];

PARAMS_1(_unit);

if (!local _unit) exitWith {};

TRACE_1("statehandler started",_unit);

_oldstate = -1;
_nextcrytime = -1;

waitUntil {(_unit getVariable "ace_w_state") > 0 || !alive _unit};

if (!alive _unit) exitWith {_unit setVariable ["ace_w_fsm",0]};

if (!isMultiplayer) then {
	_spaction = _unit getVariable ["ace_w_spaction", -9999];
	if (_spaction == -9999) then {
		_spaction = _unit addAction [format[localize "STR_ACE_UA_SPHEAL",name _unit], QUOTE(PATHTOF(spheal.sqf)), _unit, -1, false, true];
		_unit setVariable ["ace_w_spaction", _spaction];
	};
};

if ((_unit getVariable "ace_w_bleed_add") > 0) then {
	_unit setVariable ["ace_w_bleed", (_unit getVariable ["ace_w_bleed", 0]) max SH_INIT_MIN_BLEED];
};
if ((_unit getVariable "ace_w_pain_add") > 0) then {
	_unit setVariable ["ace_w_pain", (_unit getVariable ["ace_w_pain", 0]) max SH_INIT_MIN_PAIN];
};

_withpmr = false;

if (isPlayer _unit) then {
	if (!isNil "ace_wounds_prevtime") then {
		//if (ace_wounds_prevtime > 0) then {
			_withpmr = true;
		//};
	};
};

_setSkilled = false;
_lastRequest = time + DELAY;
while {true} do {
	_state = _unit getVariable "ace_w_state";
	_bleed = _unit getVariable "ace_w_bleed";
	_pain = _unit getVariable "ace_w_pain";

	_bleedAdd = _unit getVariable "ace_w_bleed_add";
	_painAdd = _unit getVariable "ace_w_pain_add";

	// Extra bloodloss by movement
	_bleedExtra = 0; _painExtra = 0;

	if ((GVAR(player_movement_bloodloss) && isPlayer _unit) || (GVAR(ai_movement_bloodloss) && ! isPlayer _unit)) then {
		_spd = (velocity _unit) call BIS_fnc_magnitude;
		_veh = (vehicle _unit != _unit) && isNull (_unit getVariable ["ace_w_carry",objNull]);
		if (_spd > 0.1 && _spd < 20 && !_veh) then {
			_bleedExtra = _bleedAdd * (_spd * BLOSS_MOVE_COEF);
			_painExtra = _painAdd * (_spd * PAIN_MOVE_COEF);
		};
	};

	#ifdef DEBUG_MODE_FULL
		_curDam = [_unit] call FUNC(getDamage);
		_body = _unit getVariable ["ace_w_body", 0];
		_head = _unit getVariable ["ace_w_head_hit", 0];
		_hands = _unit getVariable ["ace_w_hands", 0];
		_legs = _unit getVariable ["ace_w_legs", 0];
	#endif
	#define DAMM _body, _head, _hands, _legs
	#define BLEED _bleed, _bleedAdd, _bleedExtra
	#define PAIN _pain, _painAdd
	TRACE_8("",_unit,alive _unit,_state,damage _unit, _curDam,[BLEED],[PAIN],[DAMM]);

	_unit setVariable ["ace_w_bleed",_bleed + _bleedAdd + _bleedExtra];

	if (_pain < 1) then {
		_unit setVariable ["ace_w_pain",_pain + _painAdd + _painExtra];
	};

	if (_state >= 800) then {
		if (!_setSkilled && GVAR(ai_skill_handicap) && !isPlayer _unit) then {
			_setSkilled = true;
			_unit setVariable [QGVAR(skill), skill _unit];
			_skill = (skill _unit) * AI_SKILL_COEF;
			_unit setSkill _skill;
			TRACE_2("SetSkill",_unit,_skill);
		};
	};

	switch (_state) do {
		case 800: { // bleeding
			if ((_bleed > SH_STATE_800_MAX_BLEED || _pain > SH_STATE_800_MAX_PAIN) && (_state == 800)) exitWith {
				_unit setVariable ["ace_w_epi",1];
				_unit setVariable ["ace_w_state",801];
			};
			if (_nextcrytime == -1) then {
				_btime = if (_bleed == 0) then {
					((1 - _pain) * 200) + random 30
				} else {
					((1 - _bleed) * 200) + random 30
				};
				_nextcrytime = time + _btime;
			};
			if (_unit getVariable "ace_w_state" == 800 && _oldstate != _state) then {_oldstate = _state};
		};
		case 801: { // blackouts every now and then
			if ((_bleed > SH_STATE_801_MAX_BLEED || _pain > SH_STATE_801_MAX_PAIN) && _state == 801) exitWith {
				_unit setVariable ["ace_w_epi",1];
				_unit setVariable ["ace_w_state",802];

				// TODO: Do we need this?
				/*
				if (_withPMR) then {
					if (isPlayer _unit && ace_wounds_prevtime > 0) then {
						TRACE_1("Setting PMR",_unit);
						// PMR damage when in revive state..
						_unit setDamage MAX_PMR_DAM;
					};
				};
				*/
			};
			if (_nextcrytime == -1) then {
				_btime = if (_bleed == 0 && _pain > 0) then {
					((1 - _pain) * 200) + random 30
				} else {
					if (_pain == 0 && _bleed > 0) then {
						((1 - _bleed) * 200) + random 30
					} else {
						100 + random 30
					}
				};
				_nextcrytime = time + _btime;
			};
			if (_unit getVariable "ace_w_state" == 801) then {
				if (time > (_unit getVariable "ace_w_nextuncon") && !(_unit call FUNC(isUncon)) && !(_unit getVariable ["ace_w_bout", false])) then {
					[_unit, 30 + random 30] call FUNC(goUncon);
				};
			};
			if (_unit getVariable "ace_w_state" == 801 && _oldstate != _state) then {
				_oldstate = _state;
			};
		};
		case 802: {
			if (_nextcrytime == -1) then {
				_btime = if (_bleed == 0 && _pain > 0) then {
					((1 - _pain) * 200) + random 30
				} else {
					if (_pain == 0 && _bleed > 0) then {
						((1 - _bleed) * 200) + random 30
					} else {
						100 + random 30
					}
				};
				_nextcrytime = time + _btime;
			};
			if (_unit getVariable "ace_w_state" == 802 && _oldstate != _state) then {
				TRACE_1("Entering 802 State",_unit);
				if !(_unit call FUNC(isUncon)) then {
					[_unit, MAX_UNC_TIME] call FUNC(goUncon);
					// TODO: create marker !?! option, means, make a marker where the player fell in state 802
					if (_withPMR) then {
						if (isPlayer _unit) then {
							if (vehicle _unit == _unit) then {
								_sl = [position _unit, 1] call FUNC(GetSlope);
								if (_sl >= 0.78) then {[position _unit, _sl, _unit] call FUNC(DoSlope)};
							};
						};
					};
				} else {
					_unit setVariable ["ace_w_unconlen", MAX_UNC_TIME];
				};

				if (_withPMR) then {
					if (isPlayer _unit && ace_wounds_prevtime > 0) then {
						if (_unit getVariable "ace_w_revive" == -1) then {
							_unit setVariable ["ace_w_revive", time + ace_wounds_prevtime];
							[QGVAR(rev), [_unit]] call CBA_fnc_localEvent;
						};
					};
				};
				_oldstate = _state;
			};
		};
	};

	_doexit = false;
	if !(_withPMR) then {
		if (_bleed >= 1 || !alive _unit) then {
			if (alive _unit) then {_unit setDamage 1};
			_unit setVariable ["ace_w_state",10000]; // 10000 = dead
			_doexit = true;
		};
	} else {
		if (isPlayer _unit && ace_wounds_prevtime > 0) then {
			_etime = _unit getVariable "ace_w_revive";
			_ropos = position _unit;
			if (_etime > -1 && (time + 5) < _etime && !alive _unit && !surfaceIsWater _ropos && isMultiplayer && isNil QGVAR(no_rpunish)) then { // player has hit respawn button == punish him :), no punishment over water surface
				_rdir = direction _unit;
				_rof = _unit distance _ropos;
				_ropos = [_ropos select 0, _ropos select 1, _rof];
				_nrt = (_etime - time) + 5;
				_rhh = _unit getvariable "ace_w_head_hit";
				_rbo = _unit getvariable "ace_w_body";
				_rha = _unit getvariable "ace_w_hands";
				_rle = _unit getvariable "ace_w_legs";
				waitUntil {alive player};
				titleText ["", "BLACK OUT", 3];
				waitUntil {!isNil QGVAR(playerrespawned)};
				GVAR(playerrespawned) = nil;
				_unit = player;
				_unit setVariable ["ace_w_state", 802];
				_unit setVariable ["ace_w_bleed", 0.99];
				_unit setVariable ["ace_w_bleed_add", 0];
				_unit setVariable ["ace_w_pain", 0.99];
				_unit setVariable ["ace_w_pain_add", 0];
				_unit setVariable ["ace_w_epi",1];
				_unit setvariable ["ace_w_head_hit", _rhh];
				_unit setvariable ["ace_w_body", _rbo];
				_unit setvariable ["ace_w_hands", _rha];
				_unit setvariable ["ace_w_legs", _rle];
				_unit setVariable ["ace_w_revive", time + _nrt];
				[QGVAR(rev), [_unit]] call CBA_fnc_localEvent;
				_unit setDamage MAX_PMR_DAM;
				_unit setVariable ["ace_w_overall", MAX_PMR_DAM];
				[_unit, MAX_UNC_TIME] call FUNC(goUncon);
				titleText ["", "BLACK IN", 0.5];
				_unit setDir _rdir;
				_unit setPos _rpos;
				_oldstate = 802;
			} else {
				if ((_etime > -1 && time >= _etime) || !alive _unit) then {
					if (alive _unit) then {_unit setDamage 1};
					_unit setVariable ["ace_w_state",10000]; // 10000 = dead
					_unit setVariable ["ace_w_revive", -1];
					[QGVAR(rev2), [_unit]] call CBA_fnc_localEvent;
					_doexit = true;
				};
			};
			if (_bleed >= 1) then {
				_unit setVariable ["ace_w_bleed", 0.99];
				_unit setVariable ["ace_w_bleed_add", 0];
			};
			if (_pain >= 1) then {
				_unit setVariable ["ace_w_pain", 0.99];
				_unit setVariable ["ace_w_pain_add", 0];
			};
		} else {
			if (_bleed >= 1 || _pain >= 1 || !alive _unit) then {
				_unit setDamage 1;
				_unit setVariable ["ace_w_state",10000]; // 10000 = dead
				_doexit = true;
			};
		};
	};

	if (_doexit || _state == 0) exitWith { _unit setVariable ["ace_w_fsm",0] };
	if !(local _unit) exitWith { _unit setVariable ["ace_w_fsm",0] };

	if (GVAR(auto_assist) && time > _lastRequest) then {
		if (_unit getVariable ["ace_w_requested_help", false]) exitWith {};
		_unit setVariable ["ace_w_requested_help", true];

		switch _state do {
			//case 0: {};
			//case 800: {};
			case 801: {
				if (_unit call FUNC(isUncon)) then {_lastRequest = time + DELAY; [_unit] spawn FUNC(requestAssist)} else {_unit setVariable ["ace_w_requested_help", false]};
			};
			case 802: {
				_lastRequest = time + DELAY; [_unit] spawn FUNC(requestAssist);
			};
			default {
				_unit setVariable ["ace_w_requested_help", false];
			};
		};
	};

	if (_nextcrytime != -1 && time > _nextcrytime) then {
		_whichsound = "";
		_ranval = -1;
		if (_unit call FUNC(isUncon)) then {
			_whichsound = "ACE_Suffering%1";
			_ranval = 16;
		} else {
			if (_pain < 0.6) then {
				_whichsound = "ACE_Scream%1";
				_ranval = 333;
			} else {
				_whichsound = "ACE_BrutalScream%1";
				_ranval = 15;
			}
		};
		[[_unit], format [_whichsound, ceil(random _ranval)]] call CBA_fnc_globalSay;
		_nextcrytime = -1;
	};
	sleep CYCLE_TIME;
};

if (!isMultiplayer) then {
	if (_spaction != -9999) then {
		if (!isNull _unit) then {
			_unit removeAction _spaction;
			_unit setVariable ["ace_w_spaction", -9999];
		};
	};
};

if (_setSkilled && alive _unit) then {
	_skill = _unit getVariable [QGVAR(skill), 0.66];
	_unit setSkill _skill;
	TRACE_2("SetSkill Returned",_unit,_skill);
};

TRACE_1("statehandler exit",_unit);
