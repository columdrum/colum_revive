_logic=_this select 0;
_objects=[];

if (local _logic) then {
	waituntil {count synchronizedobjects _logic > 0};
	_objects = synchronizedObjects _logic;
	_logic setvariable ["colum_revive_syncObjs",_objects,true];
} else {
	waituntil {_objects= _logic getvariable "colum_revive_syncObjs"; !isnil "_objects"};
};


_mediRange=_logic getvariable ["Colum_revive_MedicRange",5];
_condicion=_logic getvariable ["Colum_revive_condicion","[player] call ACE_fnc_HasRadio"];
_heliRespawnTime=_logic getvariable ["Colum_revive_RespawnTime",0];
_bando=_logic getvariable ["Colum_revive_Bando",playerside];
_HeliSide=_logic getvariable ["Colum_revive_HeliSide",sideUnknown];


if (typename _bando == typename "") then {
	_tmpX="";
	call compile format["_tmpX= %1;",_bando];
	_bando=_tmpX;
	if (isnil "_bando") then {_bando=playerside;};
};

if (typename _HeliSide == typename "") then {
	_tmpX="";
	call compile format["_tmpX= %1;",_HeliSide];
	_HeliSide=_tmpX;
	if (isnil "_HeliSide") then {_HeliSide=sideUnknown;};
};


{
	if (vehicle _x iskindof "Helicopter") then {
		[vehicle _x,_condicion,_heliRespawnTime,_HeliSide] execVM "\colum_revive\revive\medEvac\Helicoptero.sqf";
	} else {
		if (_x iskindof "CAManBase") then {
			[_x,_mediRange,_bando] execVM "\colum_revive\revive\medEvac\Medico.sqf";
		};
	};
} foreach _objects;