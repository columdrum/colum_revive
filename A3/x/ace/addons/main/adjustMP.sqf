#include "script_component.hpp"
#include "script_dialog_defines.hpp"

private ["_disp", "_controldt", "_sav_pos", "_cposdt", "_btn_hgt", "_bot_pos"];

_disp = 1;
if (typeName (_this select 0) == "DISPLAY") then {
	_disp = _this select 0;
};
if (typeName _disp == "SCALAR") exitWith {};

#define DISP(A) (_disp displayCtrl A)

// in a dedicated environment and in a hosted environment beeing a client simply hide the save menu entry and replace it with ACE Options
if (!isServer) then {
	_controldt = DISP(CA_B_SAVE_IDC);
	_sav_pos = ctrlPosition _controldt;
	_controldt ctrlShow false;

	_controldt = DISP(ACE_SETTINGS_IDC);
	_controldt ctrlSetPosition _sav_pos;
	_controldt ctrlCommit 0;
} else {
	//baseline button
	_controldt = DISP(CA_B_Abort_IDC);
	_cposdt = ctrlPosition _controldt;
	_btn_hgt = _cposdt select 3;
	_bot_pos = (_cposdt select 1) + _btn_hgt;

	//make ACE_settings second button from bottom
	_controldt = DISP(ACE_SETTINGS_IDC);
	_cposdt = ctrlPosition _controldt;
	_controldt ctrlSetPosition [_cposdt select 0, _bot_pos - _btn_hgt * 2, _cposdt select 2, _cposdt select 3];
	_controldt ctrlCommit 0;

	//change mainback to 6 button graphic (1024x1024 texture)
	_controldt = DISP(Mainback_IDC);
	_cposdt = ctrlPosition _controldt;
	_controldt ctrlSetPosition [_cposdt select 0, (_cposdt select 1) - _btn_hgt, (_cposdt select 2) * 2, (_cposdt select 3) * 2];
	_controldt ctrlCommit 0;
	_controldt ctrlSetText QUOTE(PATHTOF(data\ui_background_six_pause_ca.paa));

	//move all buttons and items above it
	{
		_controldt = DISP(_x);
		_cposdt = ctrlPosition _controldt;
		_controldt ctrlSetPosition [_cposdt select 0, (_cposdt select 1) - _btn_hgt, _cposdt select 2, _cposdt select 3];
		_controldt ctrlCommit 0;
	} forEach [Paused_Title_IDC, ACE_LOGO_IDC, CA_B_SAVE_IDC, CA_B_Skip_IDC, CA_B_REVERT_IDC, CA_B_Respawn_IDC, CA_B_Options_IDC];
};
