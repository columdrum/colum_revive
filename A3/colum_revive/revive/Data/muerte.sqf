//Script que se ejecuta cuando al jugador no le quedan mas vidas
private ["_Escuadra","_uncon","_timeout","_idJugador"];


//vidas del jugador a 0
Colum_revive_VidasLocal=0;
_idJugador = getPlayerUID player;
if ((_this select 0) ==0) then {
	//No need to udpate if connected with already 0 lifes
	if (!isNil 'ACE_fnc_clientToServerEvent') then
	{
		['colum_revive_UPL', [_idJugador,Colum_revive_VidasLocal]] call ACE_fnc_clientToServerEvent;
	} else {
		['colum_revive_UPL', [_idJugador,Colum_revive_VidasLocal]] call CBA_fnc_globalEvent; // TODO: remove after stable 1.14 release
	};
};


diag_log["revive, muerte player 1",(player getVariable "ace_w_revive") ];
//Esto pasa si pulsan respawn mientras tan con cuenta atras
if ((player getVariable "ace_w_revive") > 0) then {	player setVariable ["ace_w_revive",0]; sleep 1};

//esperamos q haga respawn si esta muerto
if (!(alive player)) then { waitUntil {alive player}};

player setPos getMarkerPos "Boot_hill";

//player SetVariable ["ace_sys_wounds_uncon",true,true]; // can cause problems with ACRE detecting unit wounded?
player SetVariable ["ace_sys_spectator_exclude",true,true]; // Changed to public setvar instead of using ace_sys_wounds_uncon

//cambio de lider
if (Colum_revive_Death_LeaveGroup) then
{
	[player] joinsilent grpnull;
} else {
	call Colum_Revive_NuevoLider;
	if (isnil 'Revive_bucle_Control_Lider') then {
		Revive_bucle_Control_Lider=true;
		[] spawn { While {true} do { sleep 30; call Colum_Revive_NuevoLider}};
	};
};

diag_log["revive, muerte player 2"];
titleText [([2,0] call Colum_Revive_Funcion_Message),"BLACK"];

titlecut [([2,0] call Colum_Revive_Funcion_Message),"PLAIN",2];


if (Colum_revive_PlayerStatusWounded) then {waituntil {!Colum_revive_PlayerStatusWounded}};
sleep 0.5;

if (!Colum_revive_AfterDeadSpect) exitwith{
	sleep 6;
	failMission "LOSER";
	forceEnd;
};

diag_log["revive, muerte player 3",time,ace_sys_spectator_SPECTATINGON];
if (Colum_spect_workaround) then {
	//TODO: remove spectator workarounds :P
	call Colum_Revive_terminateSpectator;
}else{
	ace_sys_spectator_exit_spectator = true;
	_timeout =time+4;
	waituntil {(_timeout< time) || !ace_sys_spectator_SPECTATINGON};
};
diag_log["revive, muerte player 4",time,ace_sys_spectator_SPECTATINGON];
if (!isnil "acre_api_fnc_setSpectator") then {[true] call acre_api_fnc_setSpectator};
if (!isnil "TFAR_fnc_forceSpectator") then {[player, true] call TFAR_fnc_forceSpectator;};

titleText ["","BLACK IN"];

sleep .1;
player allowdamage false;

ace_sys_spectator_ShownSides=nil;ace_sys_spectator_maxDistance=nil;
ace_sys_spectator_CheckDist=nil; ace_sys_spectator_CheckUncon = true;
ace_sys_spectator_no_butterfly_mode = true;
ace_sys_spectator_can_exit_spectator=false;

ace_sys_spectator_playable_only = not Colum_revive_VerEnemigos;
if (!Colum_revive_VerEnemigos) then {ace_sys_spectator_ShownSides=[playerside]};
ace_sys_spectator_RevButtons= nil;
ace_sys_spectator_RevShowButtonTime= nil;

diag_log["revive, muerte player 5",time,ace_sys_spectator_SPECTATINGON];
call ace_sys_spectator_fnc_startSpectator;
sleep .1;
player setPos getMarkerPos "Boot_hill";
player setCaptive true;
sleep .1;
player playMoveNow (player call CBA_fnc_getUnitDeathAnim);
sleep .1;
player switchmove (player call CBA_fnc_getUnitDeathAnim);
titlecut [([2,0] call Colum_Revive_Funcion_Message),"PLAIN",2];
diag_log["revive, muerte player 6",time,ace_sys_spectator_SPECTATINGON];