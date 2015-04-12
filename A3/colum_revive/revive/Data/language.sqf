
Colum_Revive_Funcion_Message = {
	private ["_MessageID","_Params"];
	_MessageID= _this select 0;
	_Params= _this select 1;

	switch (_MessageID) do
	{
	  case 1: {hint format[localize "STR_COLUM_REVIVE_LANGUAGE_1",Colum_revive_VidasLocal-1,Colum_revive_VidasMax-1];};
	  case 2: {localize "STR_COLUM_REVIVE_LANGUAGE_2"};
	  case 3: {10 cutText [format[localize "STR_COLUM_REVIVE_LANGUAGE_3",name _Params],"PLAIN",1];};
	  case 4: {10 cutText [localize "STR_COLUM_REVIVE_LANGUAGE_4","PLAIN",1];};
	  case 5: {10 cutText [localize "STR_COLUM_REVIVE_LANGUAGE_5","PLAIN",1];};
	  case 6: {10005 cutText [localize "STR_COLUM_REVIVE_LANGUAGE_6","PLAIN",2];};
	  case 7: {10 cutText [localize "STR_COLUM_REVIVE_LANGUAGE_7","BLACK"];};
	  case 8: {10 cutText [localize "STR_COLUM_REVIVE_LANGUAGE_8","PLAIN DOWN"];};
	  case 9: {10 cutText [localize "STR_COLUM_REVIVE_LANGUAGE_9","PLAIN",2];};
	  case 10: {[playerSide, "HQ"] sideChat format[localize "STR_COLUM_REVIVE_LANGUAGE_10",name (_Params select 0),name (_Params select 1)];};
	  case 11: {format[localize "STR_COLUM_REVIVE_LANGUAGE_11", name _Params] call CBA_fnc_systemChat;};
	  case 12: {Hint localize "STR_COLUM_REVIVE_LANGUAGE_12"; diag_log [localize "STR_COLUM_REVIVE_LANGUAGE_12"]};
	  case 13: {titlecut [localize "STR_COLUM_REVIVE_LANGUAGE_13","BLACK FADED",5]};
	  case 14: {format[localize "STR_COLUM_REVIVE_LANGUAGE_14",(name _Params)];};
	  case 15: {format[localize "STR_COLUM_REVIVE_LANGUAGE_15",_Params];};
	  case 16: {10 cutText [localize "STR_COLUM_REVIVE_LANGUAGE_16","PLAIN",3];};
	  case 17: {10013 cutText [format[localize "STR_COLUM_REVIVE_LANGUAGE_17",_Params],"PLAIN DOWN",2];};
	  case 18: {hint localize "STR_COLUM_REVIVE_UNLIMITEDLIFES";};
	  case 19: {localize "STR_COLUM_REVIVE_MEDEVAC_LANGUAGE_10"};

	  default {};
	};
};

Colum_revive_HeliMSG= {
	switch(_this) do
	{
	  case 0: {[playerside,"HQ"] sidechat localize "STR_COLUM_REVIVE_MEDEVAC_LANGUAGE_1"};
	  case 1: {[playerside,"HQ"] sidechat localize "STR_COLUM_REVIVE_MEDEVAC_LANGUAGE_2"};
	  case 2: {[playerside,"HQ"] sidechat localize "STR_COLUM_REVIVE_MEDEVAC_LANGUAGE_3"};
	  case 3: {[playerside,"HQ"] sidechat localize "STR_COLUM_REVIVE_MEDEVAC_LANGUAGE_4"};
	  case 4: {[playerside,"HQ"] sidechat localize "STR_COLUM_REVIVE_MEDEVAC_LANGUAGE_5"};
	  case 5: {[playerside,"HQ"] sidechat localize "STR_COLUM_REVIVE_MEDEVAC_LANGUAGE_6"};
	  case 6: {[playerside,"HQ"] sidechat localize "STR_COLUM_REVIVE_MEDEVAC_LANGUAGE_7"};
	  case 7: {localize "STR_COLUM_REVIVE_MEDEVAC_LANGUAGE_8"};
	  case 8: {localize "STR_COLUM_REVIVE_MEDEVAC_LANGUAGE_9"};
	};
};