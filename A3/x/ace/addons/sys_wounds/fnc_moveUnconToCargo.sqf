#include "script_component.hpp"

private["_vehicle","_tmpData",'_posVeh','_turretNumb','_assigned','_Turrets','_subturret'];
	//Move unit into a vehicle, if its alive and there is room
	_unit= _this select 0;
	_vehicle=vehicle _unit;


	if (!alive _vehicle) exitwith {};

	if ((vehicle _unit) !=_unit) then { moveOut _unit};

	if ((_vehicle emptyPositions "cargo") >0) then {_unit moveincargo _vehicle;_assigned=true};

	if (_assigned) exitwith {}; // already in vehicle exit

	_Turrets = (configFile >> "CfgVehicles" >> (typeof _vehicle) >> "Turrets");
	if ((count _Turrets) > 0) then { // search turrets
		for [{_x=0},{_x<(count _Turrets)},{_x=_x+1}] do {
			if ((getNumber((_Turrets select _x) >> "hasGunner")) > 0) then {
				if (isnull(_vehicle turretUnit [_x])) exitwith {_unit moveinTurret [_vehicle,[_x]];_assigned =true;};
			}else{
				_subturret=(_Turrets select _x) >> "Turrets";
					if ((count _subturret) > 0) then {
						for [{_y=0},{_y<(count _subturret)},{_y=_y+1}] do {
							if (isnull(_vehicle turretUnit [_x,_y])) exitwith {_unit moveinTurret [_vehicle,[_x,_y]];_assigned =true;};
						};
				};
			};
		};
	};
	if (_assigned) exitwith {}; // already in vehicle exit

	_assigned=_unit moveInAny _vehicle; // change to a random position

