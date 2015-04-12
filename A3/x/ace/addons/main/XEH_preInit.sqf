// #define DEBUG_MODE_FULL
#include "script_component.hpp"

LOG(MSG_INIT);

ADDON = false;


PREP(mismatch);
PREP(debugadd);
PREP(camera);
PREP(NetRunEventTOR);


FUNC(bloop) = {
	PARAMS_3(_params,_script,_line);
	// Whatever needed to be execed
	// _params call ace_sys_wounds_fnc_isUncon;
};

if (!isDedicated) then {
	[QUOTE(GVAR(check)), {player globalchat format ["Player %1 is missing following files required by server: %2", _this select 1, _this select 0]}] call CBA_fnc_addEventHandler;
};

GVAR(event_holderToR) = "ACE_LogicDummy" createVehicleLocal [0, 0];

QGVAR(ntor) addPublicVariableEventHandler {
	(_this select 1) call FUNC(NetRunEventTOR);
};


GVAR(marker_debug) = 0;

// Used with ACE_Simulation in Ammo Config
PREP(fired);
ace_simulation = "ACE_LogicDummy" createVehicleLocal [0,0];
ace_simulation_global = "ACE_LogicDummy" createVehicleLocal [0,0];

#include "ace_sys_cleaner_pre.sqf"
#include "ace_sys_ladebalken_pre.sqf"

ace_fnc_mapCoord = COMPILE_FILE(fnc_mapCoord);
ace_fnc_getPosASL = {
	private ["_ret"];
	PARAMS_1(_object);
	if (isNull _object) exitWith { [0, 0, 0] };
	if (local _object) exitWith { getPosASL _object };
	_ret = +(_object getVariable ["ace_pos", getPosASL _object]);
	_ret
};

["ace_flip", {_this setVectorUp [0,0,1]}] call CBA_fnc_addLocalEventHandler;

["ace_hind_od", {{_this animate [_x,1]} forEach ["dvere_l_vrch","dvere_l_spod","dvere_p_vrch","dvere_p_spod"]}] call CBA_fnc_addLocalEventHandler;
["ace_hind_ol", {{_this animate [_x,1]} forEach ["dvere_l_vrch","dvere_l_spod"]}] call CBA_fnc_addLocalEventHandler;
["ace_hind_or", {{_this animate [_x,1]} forEach ["dvere_p_vrch","dvere_p_spod"]}] call CBA_fnc_addLocalEventHandler;

["ace_hind_cd", {{_this animate [_x,0]} forEach ["dvere_l_vrch","dvere_l_spod","dvere_p_vrch","dvere_p_spod"]}] call CBA_fnc_addLocalEventHandler;
["ace_hind_cl", {{_this animate [_x,0]} forEach ["dvere_l_vrch","dvere_l_spod"]}] call CBA_fnc_addLocalEventHandler;
["ace_hind_cr", {{_this animate [_x,0]} forEach ["dvere_p_vrch","dvere_p_spod"]}] call CBA_fnc_addLocalEventHandler;

// If _unit getVariable _variable == nil, then return defaultValue, otherwise the result of getVariable.
// Opposed to _unit getVariable [_variable, _default], this function actually works when _unit = objNull
ACE_fnc_def = {
	private "_value";
	PARAMS_3(_unit,_variable,_defaultValue);
	_value = _unit getVariable _variable;
	if (isNil "_value") then { if (isNil "_defaultValue") then { nil } else { _defaultValue } } else { _value };
};


//TODO: Need to find a better place for those functions
ACE_fnc_getPistol = {
	private ["_pist"];
	_pist = "";
	{
		if (getNumber (configFile >> "CfgWeapons" >> _x >> "Type") == 2) exitWith {_pist = _x};
	} forEach (weapons (_this select 0));
	_pist
};

ACE_fnc_magnitude = {
	private "_ret";
	_ret = 0;
	{_ret = _ret + _x^2} foreach _this;
	(sqrt _ret)
};

ACE_fnc_selectrandom = {
	if (count _this > 0) then {
		_this select (random ((count _this) - 1))
	};
};

ACE_fnc_vectorMultiply = {
	private["_v","_scale"];
	_v = +(_this select 0);
	_scale = _this select 1;
	{_v set [_forEachIndex, _x * _scale]} forEach _v;
	_v
};

ACE_fnc_vectorAdd = {
	private["_p1","_p2","_return"];
	_p1 = _this select 0;
	_p2 = _this select 1;
	_return = [];
	{
	  _return set[_forEachIndex, _x + (_p2 select _forEachIndex)];
	} forEach _p1;
	_return
};

ACE_fnc_dotProduct = {
	private ["_v1","_v2","_ret"];
	_v1 = _this select 0;
	_v2 = _this select 1;
	_ret = 0;
	{
		_ret = _ret + _x*(_v2 select _forEachIndex);
	} forEach _v1;
	_ret
};

ACE_fnc_unitVector = {
	private ["_mag","_ret"];
	_ret = 0;
	{_ret = _ret + _x^2} foreach _this;
	_mag = sqrt _ret;
	_ret = [];
	{
		_ret set [_forEachIndex, _x / _mag];
	} foreach _this;
	_ret
};

ACE_fnc_vectorFromXToY = {
	private["_p1","_p2","_diff","_mag","_ret"];
	_p1 = _this select 0;
	_p2 = _this select 1;
	_diff = [];
	_ret = 0;
	{
		_mn = (_p2 select _forEachIndex) - _x;
		_ret = _ret + _mn^2;
	    _diff set[_forEachIndex, _mn];
	} forEach _p1;
	_mag = sqrt _ret;
	_ret = [];
	{
		_ret set [count _ret, _x / _mag];
	} foreach _diff;
	_ret
};

ACE_fnc_vectorDiff = {
	private["_p1","_p2","_ret"];
	_p1 = _this select 0;
	_p2 = _this select 1;
	_ret = [];
	{
	  _ret set[_forEachIndex, (_p2 select _forEachIndex) - _x];
	} forEach _p1;
	_ret
};

ACE_fnc_isTurnedOut = {
	private["_unit", "_anim", "_count", "_out"];
	_unit = _this select 0;
	_anim = toArray(toLower(animationState _unit));
	_count = (count _anim) - 1;
	_out = if (_anim select (_count-2) == 101 && {_anim select (_count-1) == 112} && {_anim select _count == 49}) then { // ep1
		[_anim select (_count-6),_anim select (_count-5),_anim select (_count-4)]
	} else {
		[_anim select (_count-2),_anim select (_count-1),_anim select _count];
	};
	
	(_out select 0 == 111 && {_out select 1 == 117} && {_out select 2 == 116})  //out
};

ADDON = true;
