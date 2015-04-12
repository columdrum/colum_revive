//#define DEBUG_MODE_FULL

#include "script_component.hpp"

#define __ammocfg configFile >> "cfgAmmo" >> _ammo
#define __unitcfg configFile >> "cfgVehicles" >> _to

#define DEFAULT_CONFIG_HIT 1
#define DEFAULT_TYPICAL_SPEED 10

private ["_ammo", "_unit", "_injurer", "_damage", "_vhit", "_dir", "_cal", "_s", "_mass", "_to", "_h", "_typicalspeed", "_configHit","_randomCoef"];

PARAMS_4(_unit,_injurer,_ammo,_damage);
_to = typeOf _unit;
/* new code - by q1184 */

// _damage - new damage received by unit (0..1)
_armor = if (isNumber (__unitcfg >> "armor") || isText (__unitcfg >> "armor")) then { getNumber (__unitcfg >> "armor") } else { ERROR("armor not set in config! "+_to); 0 };
_armorstruct = if (isNumber (__unitcfg >> "armorstructural") || isText(__unitcfg >> "armorstructural")) then { getNumber (__unitcfg >> "armorstructural") } else { ERROR("armorstructural not set in config! "+_to); 0 };

// Finding current 'hit' value of projectile. Empiric formula.

_hit = 4.0235*sqrt(_damage*_armor*_armorstruct);

// Calculating terminal velocity

if (isClass(__ammocfg)) then {
	_typicalspeed = if (isNumber(__ammocfg >> "typicalSpeed")) then { getNumber (__ammocfg >> "typicalSpeed") } else { ERROR("typicalSpeed not set in config! "+_ammo); DEFAULT_TYPICAL_SPEED };
	_configHit = if (isNumber(__ammocfg >> "hit") || isText(__ammocfg >> "hit")) then { _h = getNumber (__ammocfg >> "hit"); if (_h == 0) then { ERROR("Hit is 0 in config; " + _ammo); _h = DEFAULT_CONFIG_HIT }; _h } else { ERROR("Hit not set in config! "+_ammo); 1 };
} else { _configHit = DEFAULT_CONFIG_HIT; _typicalSpeed = DEFAULT_TYPICAL_SPEED; ERROR("Ammo doesn't exist! "+_ammo); };

 // zGuba: randomization: critical hits, and/or sinus of random hit angle, usually bigger than 45 degrees - no need to know exact value.
 // Coefficients in equation are purely empirical - feel free to adjust for better.
_randomCoef = random 1;
_vel = (_typicalspeed*_hit/_confighit) * (3.2*(_randomCoef^3) - 4.8*(_randomCoef^2) + 2.4*_randomCoef + 0.6);
// minimum 60%
// average 100%
// maximum 140%
// small probability of extreme values, almost 50% would be around average

TRACE_5("wounds velocity test",_vel,_armor,_armorstruct,_hit,_confighit);
/* end q1184 code */

_mass = if (isNumber(__ammocfg >> "ace_mass") || isText(__ammocfg >> "ace_mass")) then { getNumber(__ammocfg >> "ace_mass") } else { TRACE_1("Error. Mass not set",_ammo); 0.4 };
//_joule = 0.005 * (_mass * (_vel ^ 2));

// 270 - 90 grad, the unit is facing the injurer
// 90 - 270 back
_dir = [_unit, _injurer] call BIS_fnc_relativeDirTo;
_cal = if (isNumber(__ammocfg >> "ace_caliber") || isText(__ammocfg >> "ace_caliber")) then { getNumber(__ammocfg >> "ace_caliber") } else { TRACE_1("Error. Caliber not set",_ammo); 6 };
_penetrationMultiplier = if (isNumber(__ammocfg >> "ace_penetrationMultiplier") || isText(__ammocfg >> "ace_penetrationMultiplier")) then { getNumber(__ammocfg >> "ace_penetrationMultiplier") } else { TRACE_1("Error. Penetration Multiplier not set",_ammo); 1 };

TRACE_4("",_mass,_dir,_cal,_penetrationMultiplier);

//[_joule, _dir, _cal, true]
[_vel, _mass, _cal, _penetrationMultiplier, _dir, true]