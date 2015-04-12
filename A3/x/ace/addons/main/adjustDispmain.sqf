#include "script_component.hpp"
#include "script_dialog_defines.hpp"

private ["_disp", "_controldt", "_cposdt"];
_disp = 1;
if (typeName (_this select 0) == "DISPLAY") then {
	_disp = _this select 0;
};
if (typeName _disp == "SCALAR") exitWith {};

uiNamespace	setVariable [QGVAR(main_display), _disp];

#define DISP(A) (_disp displayCtrl A)
#define __add 0.101903
#define __add2 0.013

{
	_controldt = DISP(_x);
	_cposdt = ctrlPosition _controldt;
	_btn_y = _cposdt select 1;
	_controldt ctrlSetPosition [_cposdt select 0, _btn_y + __add2, _cposdt select 2, _cposdt select 3];
	_controldt ctrlCommit 0;
} forEach [138, 105, 102,768];

{
	_controldt = DISP(_x);
	_cposdt = ctrlPosition _controldt;
	_btn_y = _cposdt select 1;
	_controldt ctrlSetPosition [_cposdt select 0, _btn_y + __add + __add2, _cposdt select 2, _cposdt select 3];
	_controldt ctrlCommit 0;
} forEach [1001, 140, 106];

if (isClass (configFile >> "CfgPatches" >> "cwr2_UI")) then {
	DISP(768) ctrlShow false;
	DISP(1104) ctrlShow false;
	DISP(113805) ctrlShow false;
} else {
	DISP(769) ctrlShow false;
};

/*
if (isNil {uiNamespace getVariable "ace_settings_settings"}) then {
	call compile preprocessFileLineNumbers "\x\ace\addons\settings\initall.sqf";
};
*/
