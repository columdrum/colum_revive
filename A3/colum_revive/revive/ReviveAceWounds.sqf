//Script simple de revive usando el A.C.E. Wounding module
//Version 2.0 final
Diag_log['Initializing Revive ACE wounds 3.0'];
if (!isnil 'Colum_revive_Initialized') exitwith{Diag_log['WARNING Revive ACE wounds, multiple instances detected!'];};
Colum_revive_Initialized=true;

Private ['_ruta'];

_LogicaRevive=(_this select 0) select 0;
_TypoConfig=_this select 1;
switch _TypoConfig do{
	case 1: {_ruta='\colum_revive\revive\ConfigMod.sqf';};
	case 0: {_ruta= _LogicaRevive getvariable ["colum_revive_CfgPath",'reviveConfig\Configuracion.sqf'];}; //opciones externas
};

Colum_revive_Path='\colum_revive\revive\';
_LogicaRevive call compile preprocessFileLineNumbers Format['%1',_ruta];
call compile preprocessFileLineNumbers format['%1Data\language.sqf',Colum_revive_Path];


/*******************************************************Config Check*******************************************************/
/*******************************************************============*******************************************************/
if (isnil 'Colum_revive_Conf_Lifes') then {Colum_revive_Conf_Lifes=2};
if (isnil 'ace_sys_wounds_noai') then {ace_sys_wounds_noai= true};
if (isnil 'ace_wounds_prevtime') then {ace_wounds_prevtime=400};
if (isnil 'ace_sys_wounds_withSpect') then {ace_sys_wounds_withSpect=true};
if (isnil 'Colum_revive_TKcheck') then {Colum_revive_TKcheck=true};
if (isnil 'Colum_revive_AfterDeadSpect') then {Colum_revive_AfterDeadSpect=true};
if (isnil 'Colum_revive_VerEnemigos') then {Colum_revive_VerEnemigos=true};
if (isnil 'Colum_revive_PvP') then {Colum_revive_PvP=false};
if (isnil 'Colum_revive_MochilaMedico') then {Colum_revive_MochilaMedico="G_FieldPack_Medic";};
if (isnil 'Colum_revive_MochilaMedico_Contenido') then {Colum_revive_MochilaMedico_Contenido=[7,15,10,2,10]};
if (isnil 'Colum_revive_JIPTelep') then {Colum_revive_JIPTelep=true};
if (isnil 'Colum_revive_Respawn') then {Colum_revive_Respawn=false};
if (isnil 'Colum_revive_TimeoutAutoRespawn') then {Colum_revive_TimeoutAutoRespawn=true};
if (isnil 'Colum_revive_Respawn_Side') then {Colum_revive_Respawn_Side=false};
if (isnil 'Colum_revive_Vidas_Side') then {Colum_revive_Vidas_Side=false};
if (isnil 'Colum_revive_Death_Markers') then {Colum_revive_Death_Markers=true};
if (isnil 'Colum_revive_Death_Messages') then {Colum_revive_Death_Messages=true};
if (isnil 'Colum_revive_Death_LeaveGroup') then {Colum_revive_Death_LeaveGroup=true};
if (isnil 'Colum_revive_Levanta_Heal') then {Colum_revive_Levanta_Heal=false};
if (isnil 'Colum_revive_KillOnConnectfail') then {Colum_revive_KillOnConnectfail=true};
if (isnil 'Colum_revive_RespawnButtonPunish') then {Colum_revive_RespawnButtonPunish=true};
if (isnil 'Colum_revive_WaterAction') then {Colum_revive_WaterAction=0};
if (isnil 'Colum_revive_DisconectSave') then {Colum_revive_DisconectSave=false};
if (isnil 'Colum_revive_DisconectSave_Time') then {Colum_revive_DisconectSave_Time=-1};
if (isnil 'Colum_revive_DisconectPunish') then {Colum_revive_DisconectPunish=false};
if (isnil 'Colum_revive_WoundScoring') then {Colum_revive_WoundScoring=true};
if (isnil 'Colum_revive_LifesPersist') then {Colum_revive_LifesPersist=-1};
if (isnil 'Colum_spect_workaround') then {Colum_spect_workaround=true};
if (isnil 'colum_revive_medicalExtraTime') then {colum_revive_medicalExtraTime=true};
if (isnil 'Colum_revive_EndGameIfAllDie') then {Colum_revive_EndGameIfAllDie=[]};
if (isnil 'Colum_Revive_KillIfNoMedic') then {Colum_Revive_KillIfNoMedic=false};
if (isnil 'Colum_revive_WaveTime_Respawn') then {Colum_revive_WaveTime_Respawn=[-1,-1]};



//disable ACRE features not enabled on half-ported ACE
acre_sys_compat_ace_combatdeaf_enabled = false;
acre_sys_compat_ace_earplugs_enabled = false;
acre_sys_compat_ace_onback_enabled = false;



Colum_Revive_ID_list=[];
ace_sys_wounds_no_rpunish=true;//no need to punish already handled by the revive script

ace_sys_spectator_fnc_rbutton1={0 spawn Colum_Revive_Acciones};
ace_sys_spectator_fnc_rbutton2={1 spawn Colum_Revive_Acciones};
ace_sys_spectator_fnc_rbutton3={2 spawn Colum_Revive_Acciones};
ace_sys_spectator_fnc_rbutton4={3 spawn Colum_Revive_Acciones};

Colum_revive_RespawnButton_Pos=0; //button index
Colum_revive_PlayerStatusWounded=false; //player in wounded status( countdown)
colum_revive_telepEnabled=false; // already teleported
Colum_revive_enLimbo=false; //player timer run out
Colum_revive_extraTime=false;
if (isnil 'Colum_Revive_MedicoList') then {Colum_Revive_MedicoList=[]};



_posbothil=getMarkerPos "Boot_hill";
if (((_posbothil select 0) == 0)&&((_posbothil select 1) == 0)) then // if doesn't exists we create a new one
{
	//Default positions if Boot_hill marker not found. Some islands skiped( like takistan) because doesn't need a custom location, [0,0,0] is valid for them.
	_Posbothil = switch toLower(worldName) do
	{
	  case 'isoladicapraia': {[2849.75,4524.65,0]};
	  case 'everon2010': {[-1350.59,6261.12,0]};
	  case 'queshkibrul': {[2798.63,4431.92,0]};
	  case 'chernarus': {[-6032.46,19052.2,0]};
	  case 'utes': {[1901.67,4361.25,0]};
	  case 'fallujah': {[9207.25,-1499.34,0]};
	  case 'sbrodj': {[6501.62,18996.1,0]};
	  case 'spritzisland': {[7069.92,9650.15,0]};
	  case 'namalsk': {[8263.72,7723.37,0]};
	  case 'kolgujev2010': {[6902.75,16710.5,0]};
	  case 'isladuala': {[1562.01,9274.87,0]};
	  case 'lingor': {[11675.51,4783.38,0]};
	  case 'tropica': {[13383.4,2598.89,0]};
	  case 'vostok': {[3734.43,3813.38,0]};
	  case 'villa_afgana': {[-842.853,-660.164,0]};
	  case 'i44_omaha': {[4691.02,404.848,0]};
	  case 'csj_sea': {[175.11,106.138,0]};
	  case 'us101_cao_bang': {[1349.92,4849.8,0]};
	  case 'uns_dong_ha': {[4749.26,5208.86,0]};
	  case 'vte_7m': {[12651.6,6749.55,0]};
	  case 'vte_25km_demo': {[20865.3,25423.2,0]};
	  case 'vte_ashau': {[4000.83,11724.2,0]};
	  case 'vte_australianao': {[691.541,5851.64,0]};
	  case 'vte_bra': {[199.314,9448.85,0]};
	  case 'vte_iadrang': {[1239.95,692.014,0]};
	  case 'vte_iiictza': {[11350.2,65.8973,0]};
	  case 'vte_khesanh': {[11351.2,6950.75,0]};
	  case 'vte_mdsz': {[8237.09,8495.96,0]};
	  case 'vte_meekong': {[8926.51,1196.67,0]};
	  case 'nam_12': {[123.736,4143.98,0]};
	  case 'nam_25': {[25445.6,66.6589,0]};
	  case 'vte_poleikleng': {[10797.2,4600.74,0]};
	  case 'vte_quanbinhson': {[11234,4198.08,0]};
	  case 'vte_rssz': {[551.878,404.413,0]};
	  case 'vte_vinhthanh': {[12496.4,3692.37,0]};
	  case 'stratis' : {[3746.48,7996.49,0]};
	  case 'altis' : {[14525.6,5774.23,0]};
	  default {[0,0,0]};
	};
	createMarkerLocal ["Boot_hill", _Posbothil];
};
_poscenter=getMarkerPos "center";
if (((_poscenter select 0) == 0)&&((_poscenter select 1) == 0)) then // if doesn't exists we create it
{
	_Poscenter = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	createMarkerLocal ["center", _Poscenter];
};
{
_posrespawn=getMarkerPos _x;
if (((_posrespawn select 0) == 0)&&((_posrespawn select 1) == 0)) then // if doesn't exists we create it
{
	createMarkerLocal [_x, getMarkerPos "Boot_hill"];
};
}foreach["respawn_west","respawn_east","respawn_guerrila","respawn_civilian"];
if (!ace_sys_wounds_withSpect) then {ace_sys_wounds_withSpect=nil};
if (!ace_sys_wounds_medics_only) then {ace_sys_wounds_medics_only=nil};
if (Colum_revive_DisconectSave_Time > 0) then {Colum_revive_DisconectSave=true};
if (isNil "ace_sys_wounds_enabled") then {ace_sys_wounds_enabled=true};//If not enabled, enable ace W. sys.
colum_revive_LastSave=time+60;

//Life loss event script
Colum_revive_evento_HeridoGrave= compile preprocessFileLineNumbers format['%1Data\Evento_herido.sqf',Colum_revive_Path];
/***********************************************************************************************/


//Init number of lifes
Colum_revive_VidasLocal=nil;


if (isnil 'Colum_revive_VidasMax') then { Colum_revive_VidasMax=Colum_revive_Conf_Lifes};

if (Colum_revive_VidasMax <= 0) then { Colum_revive_VidasMax=1 }; // At least one life

//Asignacion de vidas
//Esperamos a que se sincronice el jugador
T_INIT 	= false;
T_Server 	= false;
T_Client 	= false;
T_JIP 	= false;

T_MP = (if (playersNumber east + playersNumber west + playersNumber resistance + playersNumber civilian > 0) then {true} else {false});

if (isServer) then
{
	T_Server = true;
	if (!isNull player) then {T_Client = true};
	T_INIT = true;
} else {
	T_Client = true;
	if (isNull player) then
	{
		T_JIP = true;
		[] spawn {waitUntil {!isNull player};T_INIT = true};
	} else {
		T_INIT = true;
	};
};
waitUntil {T_INIT};

//if (isDedicated) exitwith{};
if (T_Server) then {
	[] spawn {
		Colum_revive_Iniciado = false; PublicVariable 'Colum_revive_Iniciado';
		sleep 60; Colum_revive_Iniciado = true; PublicVariable 'Colum_revive_Iniciado';
		if (Colum_revive_DisconectSave||Colum_revive_DisconectPunish) then{ //TODO: replace on next version with new disconenct event
			addMissionEventHandler ["HandleDisconnect",{_this call Colum_revive_Fnc_Disconect2;}];
		};
	};
};

/************************************************CBA EVENT HANDLERS ************************************************************************/


['colum_revive_UPL', {_this spawn Colum_revive_Update_vidas}] call ACE_fnc_addClientToServerEventhandler;
['colum_revive_MedCall', {_this spawn Colum_revive_LLamada_Medica}] call ACE_fnc_addClientToServerEventhandler;
['colum_revive_REQL', {_this spawn Colum_revive_Consulta_Vidas}] call ACE_fnc_addClientToServerEventhandler;
['colum_revive_Save', {_this  spawn Colum_revive_fcn_Save_PJ}] call ACE_fnc_addClientToServerEventhandler;

['colum_revive_FIJV', {_this spawn Colum_revive_FijarVidas}] call ACE_fnc_addReceiverOnlyEventhandler;
['colum_revive_WResp', {ace_sys_spectator_RevShowButtonTime=(_this select 1)}] call ACE_fnc_addReceiverOnlyEventhandler;

['colum_revive_FIJV', {if (!isDedicated) then {_this spawn Colum_revive_FijarVidas}}] call CBA_fnc_addEventHandler;
['colum_revive_DeadP', {_this spawn Colum_Revive_Muerte_PJ}] call CBA_fnc_addEventHandler;
["ace_sys_wounds_rev", {player spawn Colum_revive_evento_HeridoGrave}] call CBA_fnc_addEventhandler;


/********************************************** GENERAL USE FUNCTIONS ***********************************************************************/
Colum_revive_Consulta_Vidas = {
	private ["_UserID","_Vidas","_Data","_tmpVidas","_tmpTime","_UserObj"];
	_UserID= _this select 0;
	_UserObj= _this select 1;
	_UserTryNumber=if(count _this > 2) then { _this select 2} else {99};


	if (isNil ("Vidas"+ _UserID) ) then	{ _Vidas= [-10,0]} else { call compile format ["_Vidas=Vidas%1;",_UserID]};
	_tmpVidas= _Vidas select 0;
	_tmpTime=_Vidas select 1;

	if ((Colum_revive_LifesPersist >0) && ((time-_tmpTime) > Colum_revive_LifesPersist)||(Colum_revive_LifesPersist==0)) then {_tmpVidas=-10};

	_Data=[_UserObj,_UserID,_tmpVidas];
	if (_UserTryNumber > 0) then {diag_log[format["colum_revive: posible script lag deteted, try to log-in n? (%1) of player : %2, UID: %3, lifes: %4",_UserTryNumber,name _UserObj,_UserID,_tmpVidas]]};
	if (Colum_revive_DisconectSave && (_tmpVidas!=0)) then {
		// Only send data if the player has lifes, to avoid unneeded net-traffic
		if (!isNil ("Colum_revive_Data"+ _UserID)) then{
			call compile format ["_Data=_Data+[Colum_revive_Data%1]",_UserID];
			Diag_log[format['Revive logging. Player ID: %1. DATA: %2',_UserID,str _Data]];
		};
	};

	if (_UserTryNumber <2) then
	{
		['colum_revive_FIJV', _Data] call ACE_fnc_receiverOnlyEvent;
	} else {
		['colum_revive_FIJV', _Data] call CBA_fnc_globalEvent;
	};
	[_UserID] spawn colum_rev_unitInit;
};

Colum_revive_Update_vidas = {
	private ["_UserID","_Vidas"];

	_UserID= _this select 0;
	_Vidas= _this select 1;

	call compile format ["Vidas%1=[%2,%3];",_UserID,_Vidas,time];
	if (_Vidas == 0) then {call compile format ["Colum_revive_Data%1=nil;",_UserID];};
	if (!(_UserID in Colum_Revive_ID_list)) then {Colum_Revive_ID_list=Colum_Revive_ID_list+[_UserID]};
};

Colum_revive_FijarVidas = {
	private ["_UserObj","_Vidas","_Data","_TmpStatus","_deadTimer"];
	_UserObj= _this select 0;
	_UserID= _this select 1;
	_Vidas= _this select 2;
	if(_Vidas==-10) then {_Vidas=Colum_revive_VidasMax};
	if (count _this >3) then {_Data= _this select 3};


	If (_UserID == (getPlayerUID player)) then {
		if ((!isnil '_Data')&&(isnil 'colum_revive_reasigned')&&(isnil 'colum_revive_dataReceived')) then {
			colum_revive_dataReceived=true; //under heavy server lag you could recieve multiple querryes at the same time

			//titleText [([19,0] call Colum_Revive_Funcion_Message),"BLACK"];

			waituntil {!isnil "BIS_fnc_init"};
			waituntil {BIS_fnc_init}; //wait for fnc init, should include object init execution
			//sleep 10;
			_TmpStatus=(_Data select 1);
			if (_TmpStatus select 1) then { //he was unconscious
				_Vidas=_Vidas+1;
				Colum_revive_VidasLocal=_Vidas;
				waituntil{time >3};
				player setvariable ['UltAtack', [-1000,player]];
				//[player,1,false,1] call ace_w_setunitdam;
				[player, 1] call ace_sys_wounds_fnc_addDamage;


				waituntil{(player getVariable "ace_w_revive") >0};
				if ((_TmpStatus select 3) > 0) then {
					player setVariable ["ace_w_revive",time+(_TmpStatus select 3)];
				} else{
					if ((_TmpStatus select 3) ==-10) then {
						[] spawn Colum_revive_fnc_LimboStatus
					}else{
						Diag_log["Revive, player was wounded but revive time recived was invalid",(_TmpStatus select 3)];
					};
				};
				//if no wave respawn also adjust the respawn button timer
				if (!isnil "ace_sys_spectator_RevShowButtonTime") then {
					if ((Colum_revive_WaveTime_Respawn select 0) <0 || (Colum_revive_WaveTime_Respawn select 1) <= 0) then {
						_deadTimer=ace_wounds_prevtime-(_TmpStatus select 3);
						old_ace_sys_spectator_RevShowButtonTime=ace_sys_spectator_RevShowButtonTime;
						ace_sys_spectator_RevShowButtonTime=old_ace_sys_spectator_RevShowButtonTime -_deadTimer;
						if ((_TmpStatus select 3) <0 || ace_sys_spectator_RevShowButtonTime<0) then {ace_sys_spectator_RevShowButtonTime=2};
					};
				};
			}else{ //he was alive
				if ((_TmpStatus select 0)>0) then {[player,(_TmpStatus select 0)] call ace_sys_wounds_fnc_setdamage};
				//if (!(_TmpStatus select 2)) then {[player,3,1] call ace_sys_wounds_fnc_setHit;};
				player call ace_sys_wounds_fnc_unitInit; // Remove bleeding and pain, we can't know how he was before disconect, so just restore damage.
			};
			//move to pos or to vehicle
			if (vehicle player != player) then {unassignVehicle player;moveOut player};
			if (count (_Data select 2)>0) then {
				[player, (_Data select 2)] call colum_revive_GetInVeh;
			} else {player setPosATL (_Data select 0)};

			[player,(_Data select 3)] call colum_revive_Character_Set_Inventory;

			colum_revive_reasigned=true;
		};
		Colum_revive_VidasLocal=_Vidas;
		//titleText ["","BLACK IN"];
	};
};

colum_rev_unitInit= {
	private ["_UserObjt","_UID","_result"];
	_UID=_this select 0;
	_UserObjt=objnull;
	{if (getPlayerUID _x== _UID) exitwith{_UserObjt=_x}}foreach allunits;
	if (isnull _UserObjt) exitwith{};
	sleep 60;
	if (isnull _UserObjt) exitwith{};
	_UserObjt setvariable ["colum_revive_init",true];
};

colum_rev_hasMag = {
	private ["_unit","_Mag","_result"];
	_unit=_this select 0;
	_Mag=_this select 1;
	_result=false;
	{
		if(_Mag==_x) exitwith{_result=true};
	} foreach magazines _unit;

	_result;
};

Colum_revive_LLamada_Medica = {
	private ["_Paciente","_Medico","_Pacientes"];
	_Medico= _this select 0;
	_Paciente= _this select 1;

	while {!isnil {_Medico getVariable "Colum_Revive_Paciente"}} do { sleep 2}; //Si esta atendiendo a alguien esperamos en vez de a?adirlo al array
	_Medico setVariable ["Colum_Revive_Paciente",_Paciente]; // Cambiado array por 1 solo, asi evitamos bucle continuo en el server mientras no hay pacientes
	[_Medico,_Paciente] spawn Colum_revive_AtencionMedica;
};

Colum_revive_Fnc_Disconect = {
	private ["_name","_UserID","_UserObjt","_UserVidas","_TmpUncon"];
	_name= _this select 1;
	_UserID= _this select 2;
	_UserObjt= objnull;
	_UserVidas= if (!isNil ("Vidas"+ _UserID) ) then { call compile format ["(Vidas%1 select 0)",_UserID]} else {-10};


	{if ((getPlayerUID _x) == _UserID) exitwith{_UserObjt=_x}}foreach playableunits;
	if (isnull _UserObjt) then {
		{if (name _x == _name || _UserID == (_x getvariable ["colum_revive_UID",""])) exitwith{_UserObjt=_x}}foreach playableunits;
	};
	if (isnull _UserObjt) then {
		{if ((name _x) == _name || _UserID == (_x getvariable ["colum_revive_UID",""])) exitwith{_UserObjt=_x}}foreach allunits;
	};
	if (isnull _UserObjt) exitwith {if (_name != "__SERVER__") then {diag_log[Format["Colum revive error: User %1 (%2) not found",_name,_UserID,playableunits]]}};//no unit found
	if (!(_UserID in Colum_Revive_ID_list)) then {Colum_Revive_ID_list=Colum_Revive_ID_list+[_UserID]};

	_TmpUncon=_UserObjt call ace_sys_wounds_fnc_isUncon;

	if (Colum_revive_DisconectPunish && _TmpUncon) then{
		//- 1 life for disconect while unconscius
		if (!isNil ("Vidas"+ _UserID) ) then { call compile format ["if (_UserVidas > 0) then{Vidas%1=[(_UserVidas -1),time]};",_UserID]};
	};

	if (Colum_revive_DisconectSave&& (_UserVidas >0 ||_UserVidas ==-10)) then {
		[_name,_UserObjt,_UserID] call Colum_revive_fcn_Save_PJ;
		hideBody _UserObjt;
		deletevehicle _UserObjt; // in A3 the death guy its left there
	};
};

Colum_revive_Fnc_Disconect2 = {
	private ["_name","_UserID","_UserObjt","_UserVidas","_TmpUncon"];

	_UserObjt= _this select 0;
	_UserID= _this select 2;
	_name= _this select 3;

	_UserVidas= if (!isNil ("Vidas"+ _UserID) ) then { call compile format ["(Vidas%1 select 0)",_UserID]} else {-10};

	if (isnull _UserObjt) then {
		{if ((getPlayerUID _x) == _UserID) exitwith{_UserObjt=_x}}foreach playableunits;
	};
	if (isnull _UserObjt) then {
		{if (name _x == _name || _UserID == (_x getvariable ["colum_revive_UID",""])) exitwith{_UserObjt=_x}}foreach playableunits;
	};
	if (isnull _UserObjt) then {
		{if ((name _x) == _name || _UserID == (_x getvariable ["colum_revive_UID",""])) exitwith{_UserObjt=_x}}foreach allunits;
	};
	if (isnull _UserObjt) exitwith {if (_name != "__SERVER__") then {diag_log[Format["Colum revive error: User %1 (%2) not found",_name,_UserID,playableunits]]}};//no unit found
	if (!(_UserID in Colum_Revive_ID_list)) then {Colum_Revive_ID_list=Colum_Revive_ID_list+[_UserID]};

	_TmpUncon=_UserObjt call ace_sys_wounds_fnc_isUncon;

	if (Colum_revive_DisconectPunish && _TmpUncon) then{
		//- 1 life for disconect while unconscius
		if (!isNil ("Vidas"+ _UserID) ) then { call compile format ["if (_UserVidas > 0) then{Vidas%1=[(_UserVidas -1),time]};",_UserID]};
	};

	if (Colum_revive_DisconectSave&& (_UserVidas >0 ||_UserVidas ==-10)) then {
		[_name,_UserObjt,_UserID] call Colum_revive_fcn_Save_PJ;
		hideBody _UserObjt;
		deletevehicle _UserObjt; // in A3 the death guy its left there
	};
	false;
};

Colum_revive_fcn_Save_PJ= {
		private ["_UserObjt","_TmpPOs","_TmpArmas","_TmpStatus","_tmpInventory","_UserVidas","_UserRevTime",
	"_TmpVehiculo","_TmpData","_TmpUncon","_TmpweaponBack","_TmpOldData","_checkOldData","_saveData","_oldRevTime"];
	_UserName=_this select 0;
	_UserObjt=_this select 1;
	_UserID=_this select 2;
	_UserRevTime=if((count _this)>3) then{_this select 3} else {-2};



	_TmpUncon=_UserObjt call ace_sys_wounds_fnc_isUncon;

	//Check old data, this avoids posible exploits when disconecting before the unit was totally init.
	_checkOldData=true;


	if (!isnil format ["Colum_revive_Data%1",_UserID]) then {
		_TmpOldData=call compile format ["Colum_revive_Data%1",_UserID];
		if ((_TmpOldData select 1) select 1) then { //he was unconscious last time mmmm check further
			_checkOldData=false;
		}else{ //he was alive
			if (((_TmpOldData select 1) select 0)>0.1) then {_checkOldData=false;}; // wounded
			if (!((_TmpOldData select 1) select 2)) then {_checkOldData=false;}; // hit legs
		};
		if (_UserObjt distance (_TmpOldData select 0) > 600) then{_checkOldData=false;};//check if he is already moved to last pos
		_oldRevTim=((_TmpOldData select 1) select 3);
		if(_UserRevTime==-2) then{_UserRevTime=_oldRevTim};
	};
	_saveData=_checkOldData ||(_UserObjt getvariable ["colum_revive_init",false]);//if unit init or old state ok save data
	if (_saveData) then { //only save if first time or unit initialiced
		// Save user data:
		_TmpPOs=getposATL _UserObjt;

		_TmpVehiculo=if(_UserObjt!=vehicle _UserObjt) then {
			[(vehicle _UserObjt),assignedVehicleRole _UserObjt];
		} else {[]};
		_tmpInventory=if((count _this)>4) then{_this select 4} else {_UserObjt call colum_revive_get_Character_Data};

		_TmpStatus=[damage _UserObjt,_TmpUncon,canStand _UserObjt,_UserRevTime];
		_TmpData=[_TmpPOs,_TmpStatus,_TmpVehiculo,_tmpInventory];
		if (damage _UserObjt != 1) then {
			call compile format ["Colum_revive_Data%1=_TmpData;",_UserID];
			diag_log[format["Colum_revive_Save: %1. %2",_UserName,(if(count _this ==3) then {"(diconnect)"}else{"(playing)"})]];
		} else {
			diag_log[format["Colum_revive_Save: ERROR UNIT  %1. %2",_UserName,(if(count _this ==3) then {"(diconnect)"}else{"(playing)"})]];
		};
	};

};

Colum_Revive_Scoring = {
	private ["_Muerto","_MuertoSide","_Asesino","_ScoreAdd"];
	_Muerto= _this select 0;
	_MuertoSide= _this select 1;
	if (count _this  <= 2) exitwith {};
	_Asesino= _this select 2;
	if (isnil '_Asesino') exitwith {};
	if ((isnull _Asesino) || (_Asesino==_Muerto) ) exitwith {};


	_ScoreAdd =if ((_MuertoSide ==(side _Asesino))||(_MuertoSide == civilian)) then {-1} else {1};
	_Asesino addScore _ScoreAdd;
};

Colum_Revive_Funcion_Reset_Data = {
	[] spawn {
		if (isServer) then {
			{
				if (!isNil ("Vidas"+ _x) ) then {call compile format ["Vidas%1=nil;",_x]};
				if (!isNil ("Colum_revive_Data"+ _x)) then{call compile format ["Colum_revive_Data%1=nil",_x];};
				sleep 0.01;
			} foreach Colum_Revive_ID_list;
			{
				if (isplayer _x) then {
					['colum_revive_FIJV', [_x,(getPlayerUID _x),-10]] call ACE_fnc_receiverOnlyEvent;
				};
				sleep 0.1;
			} foreach playableUnits;
			Colum_Revive_ID_list=[];
		} else {
			[0, {call Colum_Revive_Funcion_Reset_Data}, []] call CBA_fnc_globalExecute;
		};
	};
};

Colum_Revive_Funcion_CanBeStillRevived={
	private ["_return","_medics","_allmedics"];
	_return=true;
	_medics=0;
	_allmedics=true;
	if(!isnil 'ace_sys_wounds_medics_only') then {_allmedics= !ace_sys_wounds_medics_only};

	if (Colum_revive_PvP) then {
		_medics={(playerside in (_x getVariable ["colum_revive_side",[sideUnknown]])) && alive _x} count Colum_Revive_MedicoList; // IA script medics on player side

		if (_allmedics) then {
			_medics=_medics+ (call compile format["Colum_revive_AlivePlayers_%1",playerside]); //IA+  players on player side
		} else {
			_medics=_medics+ (call compile format["Colum_revive_AliveMedics_%1",playerside]); //IA+  player medics on player side
		};
	} else {
		_medics=({alive _x} count Colum_Revive_MedicoList); //IA
		if (_allmedics) then {
			_medics=_medics+ Colum_revive_AlivePlayers; //IA+  all player
		} else {
			_medics=_medics+ Colum_revive_AliveMedics; //IA+  player medics
		};
	};


	if (_medics == 0) then {
		_return=false; //no medics alive
	};

	_return;
};

Colum_Revive_Funcion_CheckPlayerCount={
	private ["_playerlist","_aliveTotal","_aliveTotal_WEST","_aliveTotal_EAST","_aliveTotal_GUER","_aliveTotal_CIV"];

	_aliveTotal=0;		_aliveTotalMedic=0;
	_aliveTotal_WEST=0;	_aliveTotalMedic_WEST=0;
	_aliveTotal_EAST=0;	_aliveTotalMedic_EAST=0;
	_aliveTotal_GUER=0;	_aliveTotalMedic_GUER=0;
	_aliveTotal_CIV=0;	_aliveTotalMedic_CIV=0;

	_playerlist=if(count playableunits>0) then {playableunits} else {[player]};
	{
		//not in PMR nor totally death(in spectator)
		_IsAlive=alive _x && !(_x getvariable["Colum_revive_isOnPMR",false])&& !(_x getvariable["ace_sys_spectator_exclude",false]);
		_IsMedic=[_x] call ace_sys_wounds_fnc_isMedic;

		if (_IsAlive) then {
			switch (side (group _x)) do
			{
			  case west: {_aliveTotal_WEST = _aliveTotal_WEST+1; if(_IsMedic) then {_aliveTotalMedic_WEST=_aliveTotalMedic_WEST+1};};
			  case east: {_aliveTotal_EAST = _aliveTotal_EAST+1; if(_IsMedic) then {_aliveTotalMedic_EAST=_aliveTotalMedic_EAST+1};};
			  case resistance: {_aliveTotal_GUER = _aliveTotal_GUER+1; if(_IsMedic) then {_aliveTotalMedic_GUER=_aliveTotalMedic_GUER+1};};
			  case civilian: {_aliveTotal_CIV = _aliveTotal_CIV+1; if(_IsMedic) then {_aliveTotalMedic_CIV=_aliveTotalMedic_CIV+1};};
			};
			_aliveTotal = _aliveTotal+1; if(_IsMedic) then {_aliveTotalMedic=_aliveTotalMedic+1};
		}
	} foreach _playerlist;

	Colum_revive_AlivePlayers=_aliveTotal;				Colum_revive_AliveMedics=_aliveTotalMedic;
	Colum_revive_AlivePlayers_WEST=_aliveTotal_WEST;	Colum_revive_AliveMedics_WEST=_aliveTotalMedic_WEST;
	Colum_revive_AlivePlayers_EAST=_aliveTotal_EAST;	Colum_revive_AliveMedics_EAST=_aliveTotalMedic_EAST;
	Colum_revive_AlivePlayers_GUER=_aliveTotal_GUER;	Colum_revive_AliveMedics_GUER=_aliveTotalMedic_GUER;
	Colum_revive_AlivePlayers_CIV=_aliveTotal_CIV;		Colum_revive_AliveMedics_CIV=_aliveTotalMedic_CIV;
};

Colum_Revive_Funcion_CreateTrigger = {
	_trg=createTrigger["EmptyDetector",[0,0,0]];
	_trg setTriggerArea[0,0,0,false];
	_trg setTriggerType "END1";
	_trg setTriggerActivation["NONE","PRESENT",true];
	_trg setTriggerStatements[format["Colum_revive_AlivePlayers_%1 <=0",_this], "endMission 'END1';forceEnd", ""];
};

Colum_Revive_Funcion_SendWaveTime = {
	private ["_tmpWaveData","_initialWave","_WaveDelay","_respTimer","_Muerto","_MuertoSide"];
	//Server calculated resp time send to clients so its more accurate( if client fail to recibe this, it would just use their own calculated time that should be similar)
	_Muerto=_this select 0;
	_MuertoSide=_this select 1;
	_initialWave=(Colum_revive_WaveTime_Respawn select 0);
	_WaveDelay=(Colum_revive_WaveTime_Respawn select 1);
	_respTimer=0;

	if (!isnil format["Colum_revive_WaveTime_Respawn_%1",_MuertoSide]) then {
		_tmpWaveData= call compile format["Colum_revive_WaveTime_Respawn_%1",_MuertoSide];
		_initialWave=_tmpWaveData select 0;
		_WaveDelay=_tmpWaveData select 1;
	};

	if ((_initialWave < 0) || (_WaveDelay <= 0)) exitwith{};
	if (time > _initialWave) then {
		_respTimer=(_WaveDelay -((time - _initialWave) % _WaveDelay));
	} else {
		_respTimer=(_initialWave -time);
	};

	['colum_revive_WResp', [_Muerto,_respTimer]] call ACE_fnc_receiverOnlyEvent;
};

Colum_Revive_Muerte_PJ = {
	private ["_Muerto","_MuertoSide","_Asesino","_NuevoMarcador","_TmpNombre","_ShowStuff"];
	_Muerto= _this select 0;
	_MuertoSide= _this select 1;
	_ShowStuff=true;

	if (count _this  > 2) then {_Asesino= _this select 2} else {_Asesino=Objnull};
	if (Colum_revive_PvP) then {if (_MuertoSide != playerside)then {_ShowStuff=false}};
	if (Colum_revive_WoundScoring && isServer && (_Muerto!=_Asesino)) then {_this call Colum_Revive_Scoring};

	waituntil {sleep 2;(_Muerto call ace_sys_wounds_fnc_isUncon)}; //TODO: 2 seconds loop server side, its more acurate, but could be also changed to clientside-only... needs testing
	call Colum_Revive_Funcion_CheckPlayerCount;
	if (isServer) then {[_Muerto,_MuertoSide] call Colum_Revive_Funcion_SendWaveTime};
	if (isDedicated) exitwith{};

	if (Colum_revive_Death_Markers && _ShowStuff) then {
		_NuevoMarcador = createMarkerlocal [format["muer%1", name _Muerto],getPos _Muerto];
		_NuevoMarcador setMarkerShapelocal "ICON";
		_NuevoMarcador setMarkerTypelocal "hd_destroy";
		_NuevoMarcador setMarkerTextlocal ([14,_Muerto] call Colum_Revive_Funcion_Message);
		_NuevoMarcador setMarkerColorlocal "ColorBlue";
	};

	if (Colum_revive_Death_Messages && _ShowStuff) then {[11,_Muerto] call Colum_Revive_Funcion_Message;};

	if (!isnull _Asesino && _ShowStuff) then {
		if (Colum_revive_TKcheck &&(_MuertoSide == side _Asesino)) then {[10,[_Asesino,_Muerto]] call Colum_Revive_Funcion_Message};
	};


	if (Colum_revive_Death_Markers && _ShowStuff) then {
		while {(!isnull _Muerto) && (alive _Muerto) && (_Muerto call ace_sys_wounds_fnc_isUncon)} do
		{
			_NuevoMarcador SetMarkerPoslocal (getPos _Muerto);sleep 7;
		};
		deleteMarkerlocal _NuevoMarcador;
	} else {
		waituntil {sleep 7; ((isnull _Muerto) || !(alive _Muerto) || !(_Muerto call ace_sys_wounds_fnc_isUncon))};
	};


	call Colum_Revive_Funcion_CheckPlayerCount;
};

colum_revive_GetInVeh={
	private["_vehicle","_tmpData",'_posVeh','_turretNumb','_assigned','_Turrets','_subturret'];
	//Move unit into a vehicle, if its alive and there is room
	_unit= _this select 0;
	_tmpData=_this select 1;
	_vehicle=_tmpData select 0;
	_posVeh=if (count (_tmpData select 1) >0) then {(_tmpData select 1) select 0}else {""};
	_turretNumb=if (count (_tmpData select 1) >1) then {(_tmpData select 1) select 1} else {[0]};
	_assigned=false;


	if (!alive _vehicle) exitwith {false};
	if ((vehicle _unit) !=_unit) then {unassignVehicle _unit; moveOut _unit};
	switch _posVeh do {
		case "driver": {
			if ((_vehicle emptyPositions "driver") >0) then {_unit assignAsDriver _vehicle;_unit moveindriver _vehicle; _assigned=true;};
		};
		case "cargo": {
			if ((_vehicle emptyPositions "cargo") >0) then {_unit assignAsCargo _vehicle;_unit moveincargo _vehicle;_assigned=true;};
		};
		case "turret": {
			if (isnull (_vehicle turretUnit _turretNumb)) then {_unit assignAsTurret [_vehicle,_turretNumb];_unit moveinTurret [_vehicle,_turretNumb];_assigned=true;};
		};
	};

	if (_assigned) exitwith {true}; // already in vehicle, exit
	//search for an empty spot on the vehicle
	if ((_vehicle emptyPositions "gunner") >0) exitwith {_unit assignAsGunner _vehicle;_unit moveingunner _vehicle;true};


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
	if (_assigned) exitwith {true}; // already in vehicle exit

	_assigned=_unit moveInAny _vehicle;
	_assigned;

};

colum_revive_get_Character_Data={
	private["_export","_character"];
	_character=_this;
	_export = [
		/* 00 */	[uniform _character,uniformitems _character],
		/* 01 */	[vest _character,vestitems _character],
		/* 02 */	[backpack _character,backpackitems _character],
		/* 03 */	headgear _character,
		/* 04 */	goggles _character,
		/* 05 */	binocular _character,
		/* 06 */	[primaryweapon _character,primaryWeaponItems _character,primaryWeaponMagazine _character],
		/* 07 */	[secondaryweapon _character,secondaryWeaponItems _character,secondaryWeaponMagazine _character],
		/* 08 */	[handgunweapon _character,handgunItems _character,handgunMagazine _character],
		/* 09 */	assigneditems _character - [binocular _character]
	];

	_export
};

colum_revive_Character_Set_Inventory={
	private ["_inventory","_object","_items","_timeout","_uniform","_backpack","_needAddBackpack","_needAddUniform","_needAddVest"];
	_object = [_this,0,objnull,[objnull]] call bis_fnc_param;
	_inventory = [_this,1,configfile,[configfile,"",[]]] call bis_fnc_param;


	//--- Process items
	private ["_vest","_headgear","_goggles"];
	_vest = "";
	_headgear = ""; //--- Added as assigned item
	_goggles = ""; //--- Added as assigned item
	_needAddBackpack=true;
	_needAddUniform=true;
	_needAddVest=true;


	_vest = _inventory select 1 select 0;
	_headgear = _inventory select 3;
	_goggles = _inventory select 4;
	_items=(_inventory select 9);
	_weaponMags=(_inventory select 6 select 2)+(_inventory select 7 select 2)+(_inventory select 8 select 2);
	_uniform = _inventory select 0 select 0;
	_backpack = _inventory select 2 select 0;

	//--- Remove
	if (_uniform != "" && (_uniform == uniform _object)) then {
		_needAddUniform=false;
	} else {
		removeuniform _object;
	};
	if (_vest != "" && (_vest == vest _object)) then {
		_needAddVest=false;
	} else {
		removevest _object;
	};
	if (_backpack != "" && (_backpack == backpack _object)) then {
		_needAddBackpack=false;
	} else {
		removebackpack _object;
	};

	removeheadgear _object;
	removegoggles _object;
	removeallitems _object;
	removeallassigneditems _object;
	removeallweapons _object;

	if (count (getmagazinecargo _object select 0) > 0) then {clearmagazinecargoglobal _object;};
	if (count (getweaponcargo _object select 0) > 0) then {clearweaponcargoglobal _object;};
	if (count (getitemcargo _object select 0) > 0) then {clearitemcargoglobal _object;};



	if (_uniform != "" && _needAddUniform) then {
		if (isclass (configfile >> "cfgWeapons" >> _uniform)) then {
			_object forceadduniform _uniform;
		} else {
			["Uniform '%1' does not exist in CfgWeapons",_uniform] call bis_fnc_error;
		};
	};


	if (_vest != "" && _needAddVest) then {
		if (isclass (configfile >> "cfgWeapons" >> _vest)) then {
			_object addvest _vest;
		} else {
			["Vest '%1' does not exist in CfgWeapons",_vest] call bis_fnc_error;
		};
	};

	if (_headgear != "") then {
		if (isclass (configfile >> "cfgWeapons" >> _headgear)) then {
			_object addheadgear _headgear;
		} else {
			["Headgear '%1' does not exist in CfgWeapons",_headgear] call bis_fnc_error;
		};
	};

	if (_goggles != "") then {
		if (isclass (configfile >> "cfgGlasses" >> _goggles)) then {
			_object addgoggles _goggles;
		} else {
			["Goggles '%1' does not exist in CfgGlasses",_goggles] call bis_fnc_error;
		};
	};



	if (_backpack != "" && _needAddBackpack) then {
		if (isclass (configfile >> "cfgVehicles" >> _backpack)) then {
			_object addbackpack _backpack;
		} else {
			["Backpack '%1' does not exist in CfgVehicles",_backpack] call bis_fnc_error;
		};
	};
	clearItemCargo backpackContainer player;
	sleep .1;
	clearAllItemsFromBackpack player;
	sleep .5; // sync sleep?

	//--- Add magazines to be loaded in weapons by default
	if ({!isnil "_x"} count (_inventory select 6) > 2) then {
		{
			if (_x != "") then {_object addmagazine _x;};
		} foreach _weaponMags;
	};

	private ["_weapons"];
	_weapons = [_inventory select 5,_inventory select 6 select 0,_inventory select 7 select 0,_inventory select 8 select 0];
	{
		if (_x != "") then {
			_weapon = _x;
			if (typename _weapon == typename []) then {_weapon = _weapon call bis_fnc_selectrandom;};
			_object addweapon _weapon;
		};
	} foreach _weapons;

	//Clear default attachments, will be added later. TODO : remove secondaryweaponitems?
	removeAllHandgunItems _object;
	removeAllPrimaryWeaponItems _object;



	//--- Add container items (only after weapons were added together with their default magazines)
	{_object additemtouniform _x;} foreach (_inventory select 0 select 1);
	{_object additemtovest _x;} foreach (_inventory select 1 select 1);
	{_object additemtobackpack _x;} foreach (_inventory select 2 select 1);


	{
		if (_x != "") then {
			_object linkitem _x;
		};
	} foreach _items;


	{
		if (_x != "") then {
			_object addPrimaryWeaponItem _x;
		};
	} foreach (_inventory select 6 select 1);

	{
		if (_x != "") then {
			_object addSecondaryWeaponItem _x;
		};
	} foreach (_inventory select 7 select 1);

	{
		if (_x != "") then {
			_object addHandgunItem _x;
		};
	} foreach (_inventory select 8 select 1);


	true
};

call Colum_Revive_Funcion_CheckPlayerCount;
{_x call Colum_Revive_Funcion_CreateTrigger}foreach Colum_revive_EndGameIfAllDie;

if (!T_Client) exitwith {}; // Nothing more to do for the server.


/********************************************** CLIENT FUNCTIONS ***********************************************************************/

Colum_revive_PackMagazine={
	_unit=_this select 0;
	_mag=_this select 1;
	_cant=_this select 2;

	_unitBackpack=(backpackContainer _unit);
	if (!isnull _unitBackpack) then {
		for "_x" from 1 to _cant do {
			_unit addItemToBackpack _mag;
		};
	};
};

Colum_revive_LLamar_Medico = {
	private ["_Medico"];
	_Medico= _this;
	if (((player getVariable "ace_w_bleed") > 0)||((player getVariable "ace_w_pain") > 0) ||
	((player getVariable "ace_w_epi") != 0)||((damage player) > 0)) then {
		if ((player getVariable "ace_w_revive") > 0) then {player setVariable ["ace_w_revive",time+1000]};

		[6,0] call Colum_Revive_Funcion_Message;

		['colum_revive_MedCall', [_Medico,player]] call ACE_fnc_clientToServerEvent;

		sleep 60;//Espera al medico, evita multiples llamadas
	};
};


if (Colum_revive_Respawn_Side) then
{
	if (!isnil format["Colum_revive_RevButtons_%1",playerside]) then {
		Colum_revive_RespawnButton_text= call compile format["Colum_revive_RevButtons_%1",playerside];
		Colum_revive_RespawnMarkers= call compile format["Colum_revive_RespawnMarkers_%1",playerside];
		Colum_revive_RespawnOffset= call compile format["Colum_revive_RespawnOffset_%1",playerside];
	} else {
		Colum_revive_Respawn= false; // este bando no tiene respawns definidos
		ace_sys_spectator_RevShowButtonTime = nil;
	};
};

if (!isnil format["Colum_revive_RevShowButtonTime_%1",playerside]) then {
	ace_sys_spectator_RevShowButtonTime = call compile format["Colum_revive_RevShowButtonTime_%1",playerside];
};
if (!isnil format["Colum_revive_WaveTime_Respawn_%1",playerside]) then {
	Colum_revive_WaveTime_Respawn= call compile format["Colum_revive_WaveTime_Respawn_%1",playerside];
};


if (!isnil format["Colum_revive_MochilaMedico_Contenido_%1",playerside]) then {
	Colum_revive_MochilaMedico_Contenido= call compile format["Colum_revive_MochilaMedico_Contenido_%1",playerside];
};

if (!isnil format["Colum_revive_MochilaMedico_%1",playerside]) then {
	Colum_revive_MochilaMedico= call compile format["Colum_revive_MochilaMedico_%1",playerside];
};


if (!isnil 'Colum_revive_RespawnButton_text') then {
	if ((count Colum_revive_RespawnButton_text) > 4) then {
		ace_sys_spectator_RevButtons=[];
		for [{_x=0},{_x<=2},{_x=_x+1}] do {ace_sys_spectator_RevButtons=ace_sys_spectator_RevButtons + [Colum_revive_RespawnButton_text select _x];};
		ace_sys_spectator_RevButtons=ace_sys_spectator_RevButtons + [[15,0] call Colum_Revive_Funcion_Message];
	} else {
		ace_sys_spectator_RevButtons=Colum_revive_RespawnButton_text;
	};
};

if (Colum_revive_Vidas_Side) then { Colum_revive_VidasMax= call compile format["Colum_revive_VidasMax_%1",playerside]};


Colum_Revive_CambiarBotones = {
	//Revive button actions, change page
	Disableserialization;
	private["_disp","_Tmpnum","_tmpText","_lastBut"];

	_disp = uiNamespace getVariable 'ace_sys_spectator_rscSpectate';
	if (isnil "_disp") then {_disp=(findDisplay 55001)};
	if (isnil "_disp" || isnull _disp) exitwith{diag_log["revive, respawn buttons wherent detected"]};

	Colum_revive_RespawnButton_Pos =Colum_revive_RespawnButton_Pos+1;
	_Tmpnum=(ceil ((count Colum_revive_RespawnButton_text) /3)) -1;

	if (Colum_revive_RespawnButton_Pos > _Tmpnum) then { // overflow check
		Colum_revive_RespawnButton_Pos=0;
	};


	ace_sys_spectator_RevButtons=[];
	_lastBut=2;
	if ((count Colum_revive_RespawnButton_text) <= 4) then {Colum_revive_RespawnButton_Pos=0;_lastBut=3;};
	//change buttons
	for [{_x=0},{_x<=_lastBut},{_x=_x+1}] do {

		_tmpText= if ((_x + (Colum_revive_RespawnButton_Pos*3)) < (count Colum_revive_RespawnButton_text)) then
		{Colum_revive_RespawnButton_text select (_x + (Colum_revive_RespawnButton_Pos*3))} else {' '};


		ace_sys_spectator_RevButtons=ace_sys_spectator_RevButtons + [_tmpText];
		(_disp displayctrl (50018 + _x)) ctrlSetStructuredText parseText _tmpText;
		ctrlShow [50018 + _x, _tmpText!=' '];
	};
	//Last button its always more.
	if (_lastBut ==2) then {
		ace_sys_spectator_RevButtons=ace_sys_spectator_RevButtons + [[15,(Colum_revive_RespawnButton_Pos+1)] call Colum_Revive_Funcion_Message];
		(_disp displayctrl (50018 + 3)) ctrlSetStructuredText parseText (ace_sys_spectator_RevButtons select 3);
	};
};

Colum_Revive_HideBotones = {
	Disableserialization;
	private["_disp","_Tmpnum","_tmpText","_lastBut"];

	_disp = uiNamespace getVariable 'ace_sys_spectator_rscSpectate';
	if (isnil "_disp") then {_disp=(findDisplay 55001)}; // gervariable returns nill not the default if that variable was  setvariable  to nil ??
	if (isnil "_disp" || isnull _disp) exitwith{diag_log["revive, respawn buttons wherent detected"]};

	Colum_revive_RespawnButton_Pos=-1;
	call Colum_Revive_CambiarBotones;
	for [{_x=0},{_x<=3},{_x=_x+1}] do {ctrlShow [50018 + _x, false];};
};

Colum_Revive_PlayerTotalHeal = {
	//if ([player] call ACE_fnc_isBurning) then { ['ace_sys_wounds_burnoff', player] call CBA_fnc_globalEvent;};
	player call ace_sys_wounds_fnc_unitInit;
	[player,0] call ace_sys_wounds_fnc_heal;
	player setdamage 0;
};

Colum_Revive_Acciones = {
	private["_posicion",'_num','_offset','_curRespawn',"_enabledRespawn"];

	_num= _this;
	_enabledRespawn=true;
	_return=false;
	if (!Colum_revive_Respawn) exitwith{};
	if ((count Colum_revive_RespawnButton_text) > 4 &&_num == 3) exitwith {call Colum_Revive_CambiarBotones;};//button more

	_num = _num + (Colum_revive_RespawnButton_Pos*3);

	if (_num > ((count Colum_revive_RespawnMarkers) -1)) exitwith{_return}; //exit if overflow
	if (!Colum_revive_Respawn) exitwith{};

	if (_num >= 0) then {
		_curRespawn=(Colum_revive_RespawnMarkers select _num);
		if ((typename _curRespawn) == "OBJECT")then {
			_enabledRespawn =(alive _curRespawn) && !(_curRespawn getvariable ["colum_revive_disableRespawn",false]);
		};
	};

	if (!_enabledRespawn) exitwith{_return}; // Respawn disabled or destroyed

	//Heal and reset all wound status
	call Colum_Revive_PlayerTotalHeal;
	[8,0] call Colum_Revive_Funcion_Message;
	call Colum_Revive_HideBotones;

	if (_num >= 0) then {
		_offset=if (count Colum_revive_RespawnOffset >_num) then{Colum_revive_RespawnOffset select _num} else{0};
		if ((typename _curRespawn) == "STRING")then {
			_posicion = getmarkerpos _curRespawn;
			_posicion set [2,_offset];
		}else{
			if ((typename _curRespawn) == "OBJECT")then {
				_posicion = getpos _curRespawn;
				_posicion =[((_posicion select 0) + (random 6) -3),((_posicion select 1) + (random 6) -3),((_posicion select 2) + _offset)];
				_tmpPos = _posicion findEmptyPosition[ 1, 50, typeof player];
				_posicion=_tmpPos;
			};
		};
		if (vehicle player != player) then {unassignVehicle player;moveOut player};
		player setpos _posicion;
		_return=true;
	};
	_return
};

Colum_revive_CheckRespawn= {
	if (!Colum_revive_Respawn) exitwith{};

	if (isnil 'ace_sys_wounds_withSpect' && !isnil 'ace_sys_spectator_RevShowButtonTime') then {
		if ((Colum_revive_Count_Start_Time + ace_sys_spectator_RevShowButtonTime) < time) then {
			disableserialization; _disp = uiNamespace getVariable 'ace_sys_spectator_rscSpectate';
			if (isnil "_disp") then {_disp=(findDisplay 55001)}; // gervariable returns nill if that variable was  setvariable  to nil ??
			if (isnil "_disp" || isnull _disp) then {
				createDialog "ACE_rscSpectate";
				_cRButton1 = 50018;_cRButton2 = 50019;_cRButton3 = 50020;_cRButton4 = 50021;
				_disp = uiNamespace getVariable 'ace_sys_spectator_rscSpectate';
				if (isnil "_disp") then {_disp=(findDisplay 55001)}; // gervariable returns nill if that variable was  setvariable  to nil ??
				if (isnil "_disp" || isnull _disp) exitwith{diag_log["revive, respawn buttons wherent detected"]};
				for [{_x=0},{_x<=13},{_x=_x+1}] do {ctrlShow [(55002 + _x),false];};

				(_disp displayCtrl _cRButton1) ctrlSetPosition [(safeZoneX + safeZoneW) - 0.25, (safeZoneY + safeZoneH) - 0.6, 0.23, 0.104575];(_disp displayCtrl _cRButton1) ctrlCommit 0;
				(_disp displayCtrl _cRButton2) ctrlSetPosition [(safeZoneX + safeZoneW) - 0.25, (safeZoneY + safeZoneH) - 0.54, 0.23, 0.104575];(_disp displayCtrl _cRButton2) ctrlCommit 0;
				(_disp displayCtrl _cRButton3) ctrlSetPosition [(safeZoneX + safeZoneW) - 0.25, (safeZoneY + safeZoneH) - 0.48, 0.23, 0.104575];(_disp displayCtrl _cRButton3) ctrlCommit 0;
				(_disp displayCtrl _cRButton4) ctrlSetPosition [(safeZoneX + safeZoneW) - 0.25, (safeZoneY + safeZoneH) - 0.42, 0.23, 0.104575];(_disp displayCtrl _cRButton4) ctrlCommit 0;
				Colum_revive_RespawnButton_Pos=-1;
				call Colum_Revive_CambiarBotones;
			};
		};
	};

	if (!isnil 'ace_sys_spectator_RevShowButtonTime' && Colum_Revive_last_respawn_msg < time) then {
		if ((Colum_revive_Count_Start_Time + ace_sys_spectator_RevShowButtonTime) > time) then {
			Colum_Revive_last_respawn_msg=time+20;
			_nextRespawnIn=ace_sys_spectator_RevShowButtonTime + Colum_revive_Count_Start_Time -time;
			[17,format["%1m:%2s",floor(_nextRespawnIn /60),round(_nextRespawnIn % 60)]] call Colum_Revive_Funcion_Message;
		};
	};

	if (((player getVariable "ace_w_revive") -time) < 15 && ((player getVariable "ace_w_revive") -time) > 0) then
	{
		//He is going to die!, avoid death to not lose equip if respawn enabled
		[] spawn {
			player setVariable ["ace_w_revive",time+1000];
			Colum_revive_extraTime=true;
			sleep 16; // extra time, maybe he was been healed
			if (player call ace_sys_wounds_fnc_isUncon) then {
				if (Colum_revive_TimeoutAutoRespawn) then {
					1 spawn Colum_Revive_Acciones;
				} else {
					call Colum_revive_fnc_LimboStatus;
				};
			};
			Colum_revive_extraTime=false;
		};

	};

};

Revive_Boton_Respawn_pulsado=
{
	private["_unit","_corpose","_idJugador"];
	_unit = _this select 0;
	_corpose = _this select 1;

	if (!Colum_revive_Respawn || Colum_revive_RespawnButtonPunish) exitwith {[0] spawn Colum_revive_evento_Muerte};

	if (Colum_revive_VidasLocal > 1) then {
		if (!Colum_revive_PlayerStatusWounded) then {
			Colum_revive_VidasLocal=Colum_revive_VidasLocal-1;
			_idJugador = getPlayerUID player;

			['colum_revive_UPL', [_idJugador,Colum_revive_VidasLocal]] call ACE_fnc_clientToServerEvent;

			if (Colum_revive_VidasLocal <= 1) then{
				ace_wounds_prevtime = nil;	ace_sys_wounds_withSpect=nil;
			};
		};
		10 cutText [" ", "black out", 1];
		sleep 5;

		_armas= weapons _corpose;
		_municion= magazines _corpose;
		deletevehicle _corpose;
		removeallweapons _unit;
		removeBackpack _unit;
		sleep 1;

		{_unit addmagazine _x} foreach _municion;
		{_unit addweapon _x} foreach _armas;

		[7,0] call Colum_Revive_Funcion_Message;
		sleep 10;
		[8,0] call Colum_Revive_Funcion_Message;
		0 spawn Colum_Revive_Acciones;
		sleep 3;
		10 cutText [" ","PLAIN DOWN"];
		cutText [" ", "black in", 0];
		[1,0] call Colum_Revive_Funcion_Message;
	} else {[0] spawn Colum_revive_evento_Muerte};
};


Colum_Revive_Keypressedcode={
	Private["_target","_Escuadra","_Lider","_tmpos","_tmposALT","_tmposX","_tmposY","_tmposZ"];
	_dikCode = 	_this select 1;

	if ((_dikCode == 88) && colum_revive_telepEnabled) then{
		if (player call ace_sys_wounds_fnc_isUncon) exitwith{};
		_Lider =(leader player);
		_target= objnull; // Not valid leader
		if ((_Lider == player)||( _Lider call ace_sys_wounds_fnc_isUncon)) then
		{
			_Escuadra = units (group player);
			{
				if ((alive _x)&&(_x!=player)) then {
					if (!(_x call ace_sys_wounds_fnc_isUncon)) exitwith { _target= _x };
				};
			} foreach _Escuadra;
			if (isnull _target) then
			{
				_Escuadra = allunits;
				{
					if ((alive _x) && (isplayer _x)&&(_x!=player)) then {
						if ((side _x) == playerside) then {
							if (!(_x call ace_sys_wounds_fnc_isUncon)) exitwith { _target= _x };
						};
					};
				} foreach _Escuadra;
			};
		} else { _target= _Lider};
		if (!isnull _target) then
		{
			_tmpos= getPosATL _target;
			_tmposX=_tmpos select 0; _tmposY=_tmpos select 1; _tmposZ=_tmpos select 2;
			_tmpos set[0,(_tmposX+ (random 2) -1)];
			_tmpos set[1,(_tmposY+ (random 2) -1)];

			if (_tmposZ > 1) then {

				//Detect buildings
				_tmposALT=_tmpos findEmptyPosition [1,30, typeof player];
				if ((count _tmposALT) > 1) then {_tmpos=_tmposALT};
			};
			if (vehicle player != player) then {unassignVehicle player;moveOut player};

			if (vehicle _target != _target) then {
				if (![player,[(vehicle _target)]] call colum_revive_GetInVeh) then {
					_tmpos set[2,0];
					_tmposALT=_tmpos findEmptyPosition [1,30, typeof player];
					player setPosATL _tmposALT;
				};
			} else {
				player setPosATL _tmpos;
			};
			colum_revive_telepEnabled=false;
		};
	};
	if (Colum_revive_DisconectSave && {_dikCode in actionKeys "IngamePause"} ) then{
		call Colum_revive_fnc_SaveClient; // TODO not needed anymore now that disconect EH is reliable?
	};
	false;
};

Colum_Revive_TelepSquad= {
	sleep 5;
	waitUntil {!isNil "Colum_revive_VidasLocal"};
	if (Colum_revive_VidasLocal > 0 && (!(player call ace_sys_wounds_fnc_isUncon))) then
	{
		colum_revive_telepEnabled=true;
		[9,0] call Colum_Revive_Funcion_Message;
		Sleep 400; // en realidad algo mas de 5 mins pero para que se den prisa :P
		colum_revive_telepEnabled=false;
	};
};

Colum_Revive_NuevoLider = {
	private ["_Escuadra"];
	if ((leader player) == player) then
	{
		_Escuadra = units (group player);
		{
			if (alive _x && (!(_x call ace_sys_wounds_fnc_isUncon))) exitwith {
				(group player) selectleader _x;
			};
		} foreach _Escuadra;
	};
};

Colum_Revive_RenombraLider = {
	private ["_Escuadra","_lider","_liderORG"];
	 _lider=(leader player);
	 _liderORG=_lider;
	if (_lider != player) then
	{
		_Escuadra = units (group player);
		{ if (alive _x && (!(_x call ace_sys_wounds_fnc_isUncon))) then {if ((rankId _x) > (rankId _lider)) then { _lider= _x }}} foreach _Escuadra;
		if( _liderORG != _lider) then { (group player) selectleader _lider};
	};
};

Colum_Revive_Funcion_CantBeRevived = {
	if (Colum_Revive_Funcion_CantBeRevived_msg) exitwith{};
	[16,0] call Colum_Revive_Funcion_Message;

	if (Colum_Revive_KillIfNoMedic) then {
		player setVariable ["ace_w_revive",16+time]; // let the respawn react if he have lives left. If not he will have at least time to read the msg to know why he got out of time
	};
	Colum_Revive_Funcion_CantBeRevived_msg=true;
};

Colum_Revive_MochilaMedica = {
	private ["_Secundaria","_cantidad"];

	// remove A3 default medical equipment
	player removeItems "FirstAidKit";
	player removeItems "Medikit";
	player addEventHandler ["take",{if ((_this select 2) in ["FirstAidKit","Medikit"]) then {player removeItems "FirstAidKit";player removeItems "Medikit";};}];

	if (isnil "Colum_revive_MochilaMedico") exitwith{};
	if (Colum_revive_MochilaMedico=='') exitwith{};
	if (!([player] call ace_sys_wounds_fnc_isMedic)) exitwith{};

	sleep 8;
	waituntil{!isnil "colum_revive_reasigned"};
	if (colum_revive_reasigned) exitwith{};

	if (isnull (unitBackpack player)) then {
		player addBackpack Colum_revive_MochilaMedico;
	};
	sleep .5;
	_cantidad= Colum_revive_MochilaMedico_Contenido select 0;
	if (_cantidad > 0) then{ [player, "ACE_Bandage",_cantidad ] call Colum_revive_PackMagazine};
	_cantidad= Colum_revive_MochilaMedico_Contenido select 1;
	if (_cantidad > 0) then{[player, "ACE_Morphine",_cantidad ] call Colum_revive_PackMagazine};
	_cantidad= Colum_revive_MochilaMedico_Contenido select 2;
	if (_cantidad > 0) then{[player, "ACE_Epinephrine",_cantidad ] call Colum_revive_PackMagazine};
	_cantidad= Colum_revive_MochilaMedico_Contenido select 3;
	if (_cantidad > 0) then{[player, "SmokeShellGreen",_cantidad ] call Colum_revive_PackMagazine};
	_cantidad= Colum_revive_MochilaMedico_Contenido select 4;
	if (_cantidad > 0) then{[player, "ACE_Medkit",_cantidad ] call Colum_revive_PackMagazine};
};

Colum_Revive_SeaRescue = {
	private ["_ObjetosRescate", "_rescatando", "_rescatador","_tmpobj"];
	if (((getposASL player) select 2)<-1) then {player setpos [getpos player select 0,getpos player select 1,0]};
	_tmpobj='Sign_sphere10cm_EP1' createvehicle [getpos player select 0,getpos player select 1,0]; //TODO: create the vehicle only local? may cause bumping , test
	player attachto [_tmpobj, [0,0,-0.1]];
	_rescatando=false;
	while{(surfaceIsWater (getPos player))&& alive player && (player call ace_sys_wounds_fnc_isUncon)} do
	{
		if (!_rescatando) then{ // if not been rescued search for posible rescuers
			if (((getposASL player) select 2)<-1) then {_tmpobj setpos [getpos player select 0,getpos player select 1,0]};
			_ObjetosRescate=nearestObjects [player, ["Man","Land","Helicopter","Ship"], 7];
			_ObjetosRescate= _ObjetosRescate - [player];
			if (count _ObjetosRescate > 0) then{
				{
					if (alive _x && (side _x == playerside)) then {
						if (_x iskindof "Man") then {
							if (!(_x call ace_sys_wounds_fnc_isUncon)) then {
								_tmpobj attachto [_x, [0,-1, 0]]; //attach the tempobject( and the player with it) to the rescuer
								_rescatando=true;
								_rescatador=_x;
							};
						} else {
							detach player;
							player moveincargo _x;
							if (vehicle player != player) then {
								_rescatando=true; _rescatador=_x;_tmpobj setpos [0,0,-500];//if enters the vehicle, hide the tempo object
							}else {
								player attachto [_tmpobj, [0,0,-0.1]]; //no room into the vehicle, back to floating
							};
						};
					};
					if (_rescatando) exitwith{};
				}foreach _ObjetosRescate;
			};
		} else { //if been rescued , check if they are alive
			if (_rescatador iskindof "Man") then{ // the rescuer died :(
				if (_rescatador call ace_sys_wounds_fnc_isUncon || !alive _rescatador) then{
					detach _tmpobj;_rescatando=false;player attachto [_tmpobj, [0,0,-0.1]]; //rescuer uncons or dead, back to floating
				};
			} else {
				if (vehicle player == player || !alive _rescatador) then{ // the player have exit the vehicle, may be destroyed.
					_tmpobj setpos [getpos player select 0,getpos player select 1,0];
					_rescatando=false; player attachto [_tmpobj, [0,0,-0.1]]; //no room into the vehicle, back to floating
				};
			};
		};
		sleep 5;
	};
	detach player;
	deletevehicle _tmpobj;
};

Colum_Revive_NearCoast = {
//Function By Norrin, used on his revive script, all credits for him
private ["_downed_x","_downed_y","_center_x","_center_y","_zzzz"];
if (((getposASL player) select 2)>-0.2) exitwith{}; //only if he is under the water
	while{surfaceIsWater (getPos player)} do
	{
		_downed_x = getPos player select 0;
		_downed_y = getPos player select 1;
		_center_x = getMarkerPos "center" select 0;
		_center_y = getMarkerPos "center" select 1;

		while {surfaceIsWater [_downed_x, _downed_y]} do
		{
			if (_zzzz == 0) then {[13,0] call Colum_Revive_Funcion_Message;};

			sleep 0.01;
			if (_downed_x > _center_x) then
			{
				_downed_x = _downed_x - 25;
				sleep 0.01;
				player setPos [_downed_x, _downed_y];
				sleep 0.01;
			};
			if (_downed_y > _center_y) then
			{
				_downed_y = _downed_y - 25;
				sleep 0.01;
				player setPos [_downed_x, _downed_y];
				sleep 0.01;
			};
			if (_downed_x < _center_x) then
			{
				_downed_x = _downed_x + 25;
				sleep 0.01;
				player setPos [_downed_x, _downed_y];
				sleep 0.01;
			};
			if (_downed_y < _center_y) then
			{
				_downed_y = _downed_y + 25;
				sleep 0.01;
				player setPos [_downed_x, _downed_y];
				sleep 0.01;
			};
		_zzzz = _zzzz + 1;
		sleep 0.1;
		};
	};
};

Colum_Revive_Funcion_WaterAction = {
	if ((((getposASL player) select 2)<0)&& (Colum_revive_WaterAction !=0) && (vehicle player == player)) then { //check if he is really under water, and outside vehicle
		if (!isnil 'Colum_Revive_executing_WaterRescue') exitwith {}; //already executed? TODO: create other metod to execute this?
		Colum_Revive_executing_WaterRescue = true;

		switch Colum_revive_WaterAction do
		{
		  case 1: {if (((getposASL player) select 2)<-2) then {player setdamage 1}};
		  case 2: {call Colum_Revive_SeaRescue};
		  case 3: {call Colum_Revive_NearCoast};
		  default {};
		};

		Colum_Revive_executing_WaterRescue=nil;
	};
};

Colum_Revive_terminateSpectator={
	if (!ace_sys_spectator_SPECTATINGON) exitwith {};

	ace_sys_spectator_exit_spectator=nil;
	ace_sys_spectator_NeedUpdateLB=true;//no harm on this since it just updates the lists with names and may solve some init issues :P
	if (ace_sys_spectator_exit_the_frame) then { //spectator temporally closed( esc pressed or init-finish)
		_timeout =time+5;
		waituntil {(_timeout< time) || !ace_sys_spectator_exit_the_frame}; // wait till spectator window inits again
	};

	_timeout =time+4;
	ace_sys_spectator_exit_spectator=true;ace_sys_spectator_NeedUpdateLB=true;
	waituntil {(_timeout< time) || !ace_sys_spectator_SPECTATINGON};
	if (!ace_sys_spectator_SPECTATINGON) exitwith {};

	disableserialization;
	_disp = uiNamespace getVariable 'ace_sys_spectator_rscSpectate';
	if (isnil "_disp") then {_disp=(findDisplay 55001)};
	if (isnull _disp && !ace_sys_spectator_exit_the_frame) then {
		createDialog "ACE_rscSpectate";
		_timeout =time+4;
		waituntil {(_timeout< time) || !ace_sys_spectator_SPECTATINGON};
	};

	if (!ace_sys_spectator_exit_the_frame) then {
		_timeout =time+4;
		ace_sys_spectator_exit_the_frame=true;
		waituntil {(_timeout< time) || !ace_sys_spectator_SPECTATINGON};
		sleep 0.1;
	};

	_disp = uiNamespace getVariable 'ace_sys_spectator_rscSpectate';
	if (isnil "_disp") then {_disp=(findDisplay 55001)};
	if (ace_sys_spectator_exit_the_frame && !isnull _disp && !ace_sys_spectator_SPECTATINGON) then {closedialog 0;};
	if (ace_sys_spectator_SPECTATINGON) then {diag_log["revive terminateSpectator failed"]};
};

colum_Revive_checkMedical={
	if (!colum_revive_medicalExtraTime) exitwith{};
	if (((player getVariable "ace_w_revive") -time) < 500) then {
		if([player] call ace_sys_wounds_fnc_nearMedicalFacility) then {
			player setVariable ["ace_w_revive",(player getVariable "ace_w_revive") + 4]; //4 seconds each 9, means double time more or less
		};
	};
};

Colum_revive_fnc_SaveClient= {
	private["_minimumSaveTime","_revtime","_tmpInventory"];
	_minimumSaveTime=7;
	if (colum_revive_LastSave> time) exitwith {};
	colum_revive_LastSave=time+_minimumSaveTime;


	_revtime=if (Colum_revive_enLimbo || Colum_revive_extraTime) then {-10} else {
		if (!isnil {player getVariable "ace_w_revive"}) then {
			((player getVariable ["ace_w_revive",0]) -time);
		} else {-2};
	};


	_tmpInventory=player call colum_revive_get_Character_Data;

	// TODO: check if you need to do this clientside or serverSide its enough?
	//_savedata=[player,getplayerUID player,_revtime,_tmpInventory];
	_savedata=[name player,player,getplayerUID player,_revtime];


	['colum_revive_Save', _savedata] call ACE_fnc_clientToServerEvent;

};

Colum_revive_fnc_LimboStatus= {
	//Player its dead and rivive counter run out. Move to boot_hill and wait for respawn button press
	private["_minimumSaveTime","_tmpRText"];
	if (Colum_revive_enLimbo) exitwith{};
	Colum_revive_enLimbo=true;

	titleText ["","BLACK"];
	if (vehicle player != player) then {unassignVehicle player;moveOut player};
	player setPos getMarkerPos "Boot_hill";
	while {Colum_revive_PlayerStatusWounded} do {
		if ((player getVariable "ace_w_revive") > 0) then {player setVariable ["ace_w_revive",time+1000]};

		_tmpRText=if (!Colum_revive_TimeoutAutoRespawn && ((Colum_revive_Count_Start_Time + ace_sys_spectator_RevShowButtonTime) > time)) then {
			_nextRespawnIn=ace_sys_spectator_RevShowButtonTime + Colum_revive_Count_Start_Time -time;
			format["%1m:%2s",floor(_nextRespawnIn /60),round(_nextRespawnIn % 60)];
		}else {
			""
		};

		titleText [_tmpRText,"BLACK FADED",0];
		sleep 2;
	};

	titleText ["","BLACK IN"];
	Colum_revive_enLimbo=false;
};

Colum_revive_fnc_SaveCheck= {
	private["_oldMag","_oldWeapons","_oldCurrWeapon","_oldPos","_save","_nextSaveTime"];
	_oldMag=magazines player;
	_oldWeapons=weapons player;
	_oldCurrWeapon=currentweapon player;
	_oldPos=getposATL player;
	_save=false;
	_nextSaveTime=0;

	sleep 60;
	while {true} do
	{
		_curMag=magazines player;
		_curWeapons=weapons player;
		_curCurrWeapon=currentweapon player;
		_curPos=getposATL player;

		//Mags changed?
		if ((count _curMag) != (count _oldMag)) then{
			_save=true;
		};

		//Weapons changed?
		if ((count _curWeapons) != (count _oldWeapons)) then{
			_save=true;
		};

		//Equiped weapon changed?
		if ((_curCurrWeapon) != (_oldCurrWeapon)) then{
			_save=true;
		};

		//Player moved more than 100m?
		if ((_oldPos distance _curPos) > 100) then{
			_save=true;
		};



		if (_save) then {
			call Colum_revive_fnc_SaveClient;
			_save=false;
		};
		Sleep Colum_revive_DisconectSave_Time;
		_oldMag=_curMag;
		_oldWeapons=_curWeapons;
		_oldCurrWeapon=_curCurrWeapon;
		_oldPos=_curPos;
	};
};

Colum_revive_evento_Muerte= compile preprocessFileLineNumbers format['%1Data\muerte.sqf',Colum_revive_Path];
/*******************************************FIN FUNCIONES CLIENTES ***********************************************************************/
/***********************************************************************************************************************************************/
Player addMPeventhandler ['MPRespawn',{_this spawn Revive_Boton_Respawn_pulsado}];

[] spawn {

	waitUntil {!isNil "Colum_revive_Iniciado"};

	if (Colum_revive_Iniciado && ((Colum_revive_LifesPersist!= 0) || Colum_revive_DisconectSave) && (Colum_revive_VidasMax !=1000)) then { //If the mission already started and 60 seconds have passed
		_W_clycle_count=0;

		while {(isNil "Colum_revive_VidasLocal") && (_W_clycle_count < 10)} do {
			['colum_revive_REQL', [getplayerUID player,player,_W_clycle_count]] call ACE_fnc_clientToServerEvent;
			sleep (5 + (random (5+ (_W_clycle_count * 6)))); _W_clycle_count = _W_clycle_count +1;
		};
		if (isNil "Colum_revive_VidasLocal") then {
			if (Colum_revive_KillOnConnectFail) then {
				Colum_revive_VidasLocal = 0;
			}else {
				Colum_revive_VidasLocal = Colum_revive_VidasMax;
			};
			[12,0] call Colum_Revive_Funcion_Message;
			sleep 10;
		}; //If no lives recived, default = death
		if (Colum_revive_JIPTelep) then { [] spawn Colum_Revive_TelepSquad};
	}else{ // Server not started or in the first 60 seconds = max lives
		Colum_revive_VidasLocal=Colum_revive_VidasMax;
		colum_revive_reasigned=false;
	};
};

waitUntil {!isNil "Colum_revive_VidasLocal"};


if (Colum_revive_VidasLocal <= 0) exitwith{[1] spawn Colum_revive_evento_Muerte}; //No lives left => exit && espectator
if (Colum_revive_VidasLocal == 1) then {ace_wounds_prevtime = nil; ace_sys_wounds_withSpect=nil;};



if (Colum_revive_TKcheck || Colum_revive_WoundScoring) then { ExecVM format['%1Data\JugadorHit.sqf',Colum_revive_Path] }; //Detect TK's

[] spawn Colum_Revive_MochilaMedica;

if (Colum_revive_VidasMax !=1000) then {
	[1,0] call Colum_Revive_Funcion_Message;
}else {
	[18,0] call Colum_Revive_Funcion_Message;
};

if (Colum_revive_DisconectSave_Time >0) then { [] spawn Colum_revive_fnc_SaveCheck;}; //Save Loop

[] spawn {
	waituntil{!(isNull (findDisplay 46))};
	(findDisplay 46) displayAddEventHandler ["KeyDown","_this call Colum_Revive_Keypressedcode"];
};