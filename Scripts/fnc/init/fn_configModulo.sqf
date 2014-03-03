_logic = [_this,0,objNull,[objNull]] call BIS_fnc_param;

_units = [_this,1,[],[[]]] call BIS_fnc_param;

_activated = [_this,2,true,[true]] call BIS_fnc_param;

if (_logic getvariable ["Radios_lider",0] == 0 ) then {
	tf_no_auto_long_range_radio = true;
};

if (_logic getvariable ["freq_corta_dist",1] == 1 )  then{
	tf_same_sw_frequencies_for_side = true;
} else {
	tf_same_sw_frequencies_for_side = false;
};

_tmpvar=_logic getvariable "west_radio_code";
if (! isnil "_tmpvar" )  then{  
	if (_tmpvar !="_bluefor") then {
		tf_west_radio_code = _tmpvar;
	};
};

_tmpvar=_logic getvariable "east_radio_code";
if (! isnil "_tmpvar" ) then {
	if (_tmpvar !="_opfor") then {
		tf_east_radio_code =_tmpvar;
	};
};

_tmpvar=_logic getvariable "guer_radio_code";
if (! isnil "_tmpvar" )  then{
	if (_tmpvar !="_independent") then {
		tf_guer_radio_code = _tmpvar;
	};
};

_tmpvar=_logic getvariable "tf_radio_channel_name";
if (! isnil "_tmpvar" )  then{
	if (_tmpvar !="XXXXXXXX") then {
		tf_radio_channel_name = _tmpvar;
	};
};

_tmpvar=_logic getvariable "tf_radio_channel_password";
if (! isnil "_tmpvar" )  then{
	if (_tmpvar !="") then {
		tf_radio_channel_password = _tmpvar;
	};
};

true