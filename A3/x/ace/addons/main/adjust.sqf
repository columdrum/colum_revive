#include "script_component.hpp"
#include "script_dialog_defines.hpp"

private ["_disp", "_controldt", "_cposdt", "_btn_hgt", "_bot_pos"];

_disp = 1;
if (typeName (_this select 0) == "DISPLAY") then {
	_disp = _this select 0;
};
if (typeName _disp == "SCALAR") exitWith {};

#define DISP(A) (_disp displayCtrl A)

//baseline button
_controldt = DISP(PG_Abort_IDC);
_cposdt = ctrlPosition _controldt;
_btn_hgt = _cposdt select 3;
_bot_pos = (_cposdt select 1) + _btn_hgt;

//make ACE_settings second button from bottom
_controldt = DISP(ACE_SETTINGS_IDC);
_cposdt = ctrlPosition _controldt;
_controldt ctrlSetPosition [_cposdt select 0, _bot_pos - _btn_hgt * 2, _cposdt select 2, _cposdt select 3];
_controldt ctrlCommit 0;

//change mainback to 5 button graphics from MP menu
_controldt = DISP(Mainback_IDC);
_cposdt = ctrlPosition _controldt;
_controldt ctrlSetPosition [_cposdt select 0, (_cposdt select 1) - _btn_hgt, _cposdt select 2, _cposdt select 3];
_controldt ctrlCommit 0;
_controldt ctrlSetText "\ca\ui\data\ui_background_mp_pause_ca.paa";

//move all buttons and items above it
{
	_controldt = DISP(_x);
	_cposdt = ctrlPosition _controldt;
	_controldt ctrlSetPosition [_cposdt select 0, (_cposdt select 1) - _btn_hgt, _cposdt select 2, _cposdt select 3];
	_controldt ctrlCommit 0;
} forEach [CA_PGTitle_IDC, ACE_LOGO_IDC, PG_Save_IDC, PG_Skip_IDC, PG_Revert_IDC, PG_Again_IDC, PG_Options_IDC];
