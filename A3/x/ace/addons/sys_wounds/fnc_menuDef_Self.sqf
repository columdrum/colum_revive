// Contains menu defs for treating yourself or another person.
// #define DEBUG_MODE_FULL
#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

private ["_menuDef", "_menuName", "_menuRsc", "_menus",
	"_bleed", "_pain", "_epi", "_state", "_inVehicle", "_playerIsUncon",
	"_playerIsBusy", "_capable", "_sys_wounds_enabled", "_hasBandage", "_hasMorphine", "_hasEPI", "_damage", "_rec_heal", "_can_heal"];

// _this==[_target, _menuNameOrParams]
PARAMS_2(_target,_params);


_menuName = "";
_menuRsc = "popup";

if (typeName _params == typeName []) then {
	if (count _params < 1) exitWith {diag_log format["Error: Invalid params: %1, %2", _this, __FILE__]};
	_menuName = _params select 0;
	_menuRsc = if (count _params > 1) then {_params select 1} else {_menuRsc};
} else {
	_menuName = _params;
};
//-----------------------------------------------------------------------------
/* Special states:
	state 800 = bleeding signs, pain
	state 801 = blackouts every now and then, bleeding signs, pain
	state 802 = complete blackout
*/
#define _state_blackingOut 801
#define _state_completeBlackout 802

// if target is player or local AI, then read their state variables directly from local object.
if (local _target) then {
	// variables are often nil at start of mission
	_bleed = _target getVariable ["ace_w_bleed", 0];
	_pain = _target getVariable ["ace_w_pain", 0];
	_epi = _target getVariable ["ace_w_epi", 0];
	_state = _target getVariable ["ace_w_state", 0];
	_damage = [_target] call FUNC(getDamage);
	_rec_heal = _target getVariable ["ace_w_healing_r", false];
	_can_heal = [_target] call FUNC(canHeal);
} else { // else if target is !local (eg: MP player), then read their state variables from a networked answer variable.
	if (count GVAR(recAnswer) >= 7) then {
		//GVAR(recAnswer) is (_receiver,_sender,_state,_epi,_bleed,_pain,_stabilized)
		_state = GVAR(recAnswer) select 2;
		_epi = GVAR(recAnswer) select 3;
		_bleed = GVAR(recAnswer) select 4;
		_pain = GVAR(recAnswer) select 5;
		_damage = GVAR(recAnswer) select 7;
		_rec_heal = GVAR(recAnswer) select 8;
		_can_heal = GVAR(recAnswer) select 9;
	} else {
		_bleed = 0;
		_pain = 0;
		_epi = 0;
		_state = 0;
		_damage = 0;
		_rec_heal = false;
		_can_heal = false;
	};
};

_stable = _bleed == 0 && _pain == 0 && _epi == 0;
_heavyDamage = _damage > LOW_DAMAGE_CEIL;
_reviveEnabled = !isNil "ace_wounds_prevtime" ||!isNil "Colum_revive_Initialized";

_healing = player getVariable ["ace_w_healing", false];

_nearMedicFacility = [_target] call FUNC(nearMedicalFacility);

TRACE_8("Target",_target,_bleed,_pain,_epi,_state,_damage,_can_heal,_heavyDamage);

_playerIsBusy = player getVariable ["ace_w_busy", false];
_capable = ACE_SELFINTERACTION_POSSIBLE;
_isMed = [player] call FUNC(isMedic);

_sys_wounds_enabled = (!isNil QGVAR(enabled));
if (_sys_wounds_enabled) then {_sys_wounds_enabled = GVAR(enabled)};

TRACE_4("Player",_capable,_playerIsBusy,_isMed,_nearMedicFacility);

_hasBandage = BND in magazines player;
_hasLargeBandage = LRGBND in magazines player;
_hasMorphine = MOR in magazines player;
_hasEPI = EPI in magazines player;
_hasMedKit = KIT in magazines player;

TRACE_5("",_hasBandage,_hasLargeBandage,_hasMorphine,_hasEPI,_hasMedKit);

_otherHasBandage = BND in magazines cba_ui_target;
_otherHasLargeBandage = LRGBND in magazines cba_ui_target;
_otherHasMorphine = MOR in magazines cba_ui_target;
_otherHasEPI = EPI in magazines cba_ui_target;
_otherHasMedKit = KIT in magazines cba_ui_target;

TRACE_6("",_otherHasBandage,_otherHasLargeBandage,_otherHasMorphine,_otherHasEPI,_otherHasMedKit,_rec_heal);




#define __actionStatus(_hasCondition,_hasTreatment) (if (_hasCondition) then {if (_hasTreatment) then {""}else{": N/A"}} else {""})

_menus = [];
//-----------------------------------------------------------------------------
if (_menuName == "main") then {
	_menus set [count _menus,
		[
			["main", localize "STR_ACE_DIA_MEDICALSELF", _menuRsc],
			[
				//Examine > // Self
				[localize "STR_ACE_DIA_MEDICALSELF" + " >", "", "", "",
					[QPATHTO_F(fnc_menuDef_Self), "treatSelf", 1],
					DIK_T, !_playerIsBusy && _sys_wounds_enabled, ACE_SELFINTERACTION_RESTRICTED],
				// Unpack stretcher
				[localize "STR_ACE_UA_STRETCHER_AUSPACKEN",
					{ player spawn FUNC(drop_stretcher) },
					"","","", -1, 1, ("ACE_Stretcher" in (weapons player) && _sys_wounds_enabled && !_playerIsBusy && ACE_SELFINTERACTION_RESTRICTED)]
			]
		]
	];
};
//-----------------------------------------------------------------------------
if (_menuName == "treatSelf") then {
	#define __STOPBLEED (localize "STR_ACE_UA_STOPBLEED")
	#define __STOPBLEEDLARGE (localize "STR_ACE_UA_STOPBLEEDLARGE")
	#define __USEMORPHI (localize "STR_ACE_UA_USEMORPHI")
	#define __USEEPI (localize "STR_ACE_UA_USEEPI")

	_menus set [count _menus,
		[
			["treatSelf", localize "STR_ACE_DIA_MEDICALSELF", _menuRsc, QPATHTO_C(data\icon\menu\)],
			[
				// Bandage
				[__STOPBLEED+__actionStatus(_bleed > 0,_hasBandage),
					{ [cba_ui_target, player, nil, 'ACE_Bandage'] spawn COMPILE_FILE(stopBleeding) },
					"menu_bandage_ca.paa",
					"Stop bleeding",
					"",
					DIK_B,
					_capable && _bleed > 0 && _hasBandage && !(!_isMed && _heavyDamage && isMultiplayer),
					1],
				// Compress
				[__STOPBLEEDLARGE+__actionStatus(_bleed > 0.5,_hasLargeBandage),
					{ [cba_ui_target, player, nil, 'ACE_LargeBandage'] spawn COMPILE_FILE(stopBleeding) },
					"menu_bandage_ca.paa",
					"Compress",
					"",
					DIK_D,
					_capable && (_bleed > 0.5 || (_bleed > 0 && !_hasBandage)) && _hasLargeBandage && !(!_isMed && _heavyDamage && isMultiplayer),
					1],
				// Morphine
				[__USEMORPHI + __actionStatus(_pain > 0,_hasMorphine),
					{ [cba_ui_target, player] spawn COMPILE_FILE(stopPain) },
					"menu_morphine_ca.paa",
					"Use morphine",
					"",
					DIK_M,
					_capable && _pain > 0 && _hasMorphine,
					1],
				// Epi
				[__USEEPI + __actionStatus(_epi > 0,_hasEPI),
					{ [cba_ui_target, player] spawn COMPILE_FILE(useEpi) },
					"menu_epi_ca.paa",
					"Use Epi",
					"",
					DIK_E,
					_capable && _epi > 0 && _hasEPI,
					1],
				// First Aid
				[localize "STR_ACE_UA_FIRSTAID",
					format['[cba_ui_target, player, %1] spawn FUNC(treat_heal)', _damage],
					"menu_firstaid_ca.paa",
					"Heal",
					"",
					DIK_H,
					!_healing && !_rec_heal && _hasMedKit && _capable && _stable && _can_heal && (_isMed || (_nearMedicFacility && !isMultiplayer)),
					1],
				// Abort First Aid
				[localize "STR_ACE_UA_ABORTFIRSTAID",
					{player setVariable ["ace_w_healing", false]},
					"menu_firstaid_abort_ca.paa",
					"Abort",
					"",
					DIK_H,
					1,
					_healing]
			]
		]
	];
};
//-----------------------------------------------------------------------------
if (_menuName == "treat person") then {
	if (local cba_ui_target) then {
		[cba_ui_target] spawn FUNC(examine);
	};

	#define __STOPBLEED (localize "STR_ACE_UA_STOPBLEED")
	#define __STOPBLEEDLARGE (localize "STR_ACE_UA_STOPBLEEDLARGE")
	#define __USEMORPHI (localize "STR_ACE_UA_USEMORPHI")
	#define __USEEPI (localize "STR_ACE_UA_USEEPI")
	#define __DRAG (localize "BC_ADDACTIONS.SQF13")

	GVAR(receiver) = cba_ui_target;
	GVAR(recstate) = _state;

	_menus set [count _menus,
		[
			// field triage
			["treat person", localize "STR_ACE_DIA_MEDICAL", _menuRsc, QPATHTO_C(data\icon\menu\)],
			[
				// Bandage
				[__STOPBLEED + __actionStatus(_bleed > 0,_hasBandage || _otherHasBandage),
					{ [GVAR(receiver), GVAR(recstate), BND] spawn FUNC(bandage) },
					"menu_bandage_ca.paa",
					"Stop bleeding",
					"",
					DIK_B,
					alive GVAR(receiver) && _capable && _bleed > 0 && (_hasBandage || _otherHasBandage) && !_playerIsBusy,
					1],
				// Compress
				[__STOPBLEEDLARGE + __actionStatus(_bleed > 0.5,_hasLargeBandage || _otherHasLargeBandage),
					{ [GVAR(receiver), GVAR(recstate), LRGBND] spawn FUNC(bandage) },
					"menu_bandage_ca.paa",
					"Compress",
					"",
					DIK_D,
					alive GVAR(receiver) && _capable && (_bleed > 0.5 || (_bleed > 0 && !_hasBandage && !_otherHasBandage)) && (_hasLargeBandage || _otherHasLargeBandage) && !_playerIsBusy,
					1],
				// Morphine
				[__USEMORPHI + __actionStatus(_pain > 0,_hasMorphine || _otherHasMorphine),
					{ [GVAR(receiver), GVAR(recstate)] spawn FUNC(morphine) },
					"menu_morphine_ca.paa",
					"Use morphine",
					"",
					DIK_M,
					alive GVAR(receiver) && _capable && _pain > 0 && (_hasMorphine || _otherHasMorphine) && !_playerIsBusy,
					1],
				// Epi
				[__USEEPI + __actionStatus(_epi > 0,_hasEPI || _otherHasEPI),
					{ [GVAR(receiver), GVAR(recstate)] spawn FUNC(epi) },
					"menu_epi_ca.paa",
					"Use Epi",
					"",
					DIK_E,
					alive GVAR(receiver) && (_capable && (_epi > 0 || _state >= _state_blackingOut)) && (_hasEPI || _otherHasEPI) && !_playerIsBusy,
					1],
				// Stabelize
				//["Stabilize",
					//{ [GVAR(receiver), GVAR(recstate)] spawn FUNC(stabilize) },
					//	"menu_stabilize_ca.paa",
					//  "",
					//  "",
					//  DIK_S,
					//	alive GVAR(receiver && _bleed > 0  && !_playerIsBusy,
					//  1],
				// CPR - only with PMR
				["CPR",
					{ [GVAR(receiver)] spawn FUNC(cpr) },
					"menu_cpr_ca.paa",
					"CPR",
					"",
					DIK_C,
					alive GVAR(receiver) && _reviveEnabled && _state >= _state_completeBlackout && !_playerIsBusy,
					1],
				// First Aid
				[localize "STR_ACE_UA_FIRSTAID",
					format['[cba_ui_target, player, %1] spawn FUNC(treat_heal)', _damage],
					"menu_firstaid_ca.paa",
					"Heal",
					"",
					DIK_H,
					!_healing && !_rec_heal && (_hasMedKit || _otherHasMedKit) && _capable && (_nearMedicFacility || _isMed) && alive _target && _stable && _can_heal  && !_playerIsBusy,
					1],
				// Abort First Aid
				[localize "STR_ACE_UA_ABORTFIRSTAID",
					{player setVariable ["ace_w_healing", false] },
					"menu_firstaid_abort_ca.paa",
					"Abort",
					"",
					DIK_H,1,
					_healing]
			]
		]
	];
};
//-----------------------------------------------------------------------------
_menuDef = [];
{
	if (_x select 0 select 0 == _menuName) exitWith {_menuDef = _x};
} forEach _menus;

if (count _menuDef == 0) then {
	hintC format ["Error: Menu not found: %1\n%2\n%3", str _menuName, if (_menuName == "") then {_this} else {""}, __FILE__];
	diag_log format ["Error: Menu not found: %1, %2, %3", str _menuName, _params, __FILE__];
};

_menuDef
