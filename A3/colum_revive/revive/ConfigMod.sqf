_logic=_this;

_colum_revive_fnc_read_string_Var={
	private ["_logic","_namePar","_defaultValue","_tmpX","_var"];
	_logic = _this select 0;
	_namePar=_this select 1;
	_defaultValue=_this select 2;
	_tmpX="";

	_var= _logic getvariable [_namePar,_defaultValue];

	if (typename _var == typename "") then {
		_tmpX="";
		if (_var != "") then {
			call compile format["_tmpX= %1;",_var];
			_var=_tmpX;
		} else {
			_var= nil;
		};
		if (isnil "_var") then {_var=_defaultValue;};
	};
	_var;
};

waituntil {time > 1 || !isnil {_logic getvariable "Colum_revive_Conf_Lifes"}};// wait for init executed

Colum_revive_Conf_Lifes=_logic getvariable ["Colum_revive_Conf_Lifes",2];

ace_sys_wounds_noai=_logic getvariable ["ace_sys_wounds_noai",true];

//Tiempo por el que se permanece inconsciente(muerto) antes de morir definitivamente.
ace_wounds_prevtime=_logic getvariable ["ace_wounds_prevtime",400];

ace_sys_wounds_medics_only=_logic getvariable ["ace_sys_wounds_medics_only",true];

//Mostrar contador. True mostrar, false la pantalla se va poniendo mas oscura cuanto menos tiempo tienes.
ace_wounds_prevtimeshow = _logic getvariable ["ace_wounds_prevtimeshow",true];

//Ativamos el modo espectador del revive cuando estamos inconscientes. False para pantalla negra mientras estamos muertos.
ace_sys_wounds_withSpect  = _logic getvariable ["ace_sys_wounds_withSpect",true];

//Activar el espectador una vez el jugador se queda sin vidadas. Si se pone a false, el jugador rebira la pantalla de fin de mision al quedarse sin vidas.
Colum_revive_AfterDeadSpect= _logic getvariable ["Colum_revive_AfterDeadSpect",true];

//Mostrar mensages de TK entre jugadores. True= mostrar mensajes. False= no mostrar
Colum_revive_TKcheck= _logic getvariable ["Colum_revive_TKcheck",true];

//Mostrar enemigos en el espectador una vez muerto. True = mostrar, False = no mostrar.
Colum_revive_VerEnemigos= _logic getvariable ["Colum_revive_VerEnemigos",true];

//PvP, los mensages de muerte, marcas en el mapa y demas seran por bando, para evitar dar informacion al bando contrario en PvP.
Colum_revive_PvP=_logic getvariable ["Colum_revive_PvP",true];

//Herir gravemente heridos +1 puntuacion, herir gravemente aliado -1 puntuacion. Pensado especialmente para PvP, simplemente para dar credito por herir a enemigos y no solo por matarlos cuando no tienen mas vidas.
Colum_revive_WoundScoring=_logic getvariable ["Colum_revive_WoundScoring",true];

//Mochila para el medico, usar "" o comentar la linea para deshabilitar
Colum_revive_MochilaMedico=_logic getvariable ["Colum_revive_MochilaMedico","G_FieldPack_Medic"];

//Contenido de la mochila, solo valido si lo anterior esta habilitado con una mochila v?lida
// Los contenidos estan ordenados [n? comprres, n? morphina, n? ephinifrina, n? granadas humo verde, n? medkits]
Colum_revive_MochilaMedico_Contenido=[_logic,"Colum_revive_MochilaMedico_Contenido",[7,15,10,2,10]] call _colum_revive_fnc_read_string_Var;


Colum_revive_MochilaMedico_WEST = _logic getvariable "Colum_revive_MochilaMedico_WEST";
Colum_revive_MochilaMedico_EAST =  _logic getvariable "Colum_revive_MochilaMedico_EAST";
Colum_revive_MochilaMedico_GUER = _logic getvariable "Colum_revive_MochilaMedico_GUER";
Colum_revive_MochilaMedico_CIV = _logic getvariable "Colum_revive_MochilaMedico_CIV";


Colum_revive_MochilaMedico_Contenido_WEST =_logic getvariable "Colum_revive_MochilaMedico_Contenido_WEST";
Colum_revive_MochilaMedico_Contenido_EAST = _logic getvariable "Colum_revive_MochilaMedico_Contenido_EAST";
Colum_revive_MochilaMedico_Contenido_GUER = _logic getvariable "Colum_revive_MochilaMedico_Contenido_GUER";
Colum_revive_MochilaMedico_Contenido_CIV =_logic getvariable "Colum_revive_MochilaMedico_Contenido_CIV";


//Los jugadores que entran tarde tendran la posivilidad de teletransportarse a la posicion de su escuadra. True = permitir, False = no permitir
Colum_revive_JIPTelep=_logic getvariable ["Colum_revive_JIPTelep",true];


//Cuando un jugador se desconecta se guarda su posicion, inventario y estado(si estaba incosciente o no). Cuando reconecta, volvera a esa posicion. True para habilitar, false deshabilitar
//NOTA: Necesita pruebas con muchos jugadores.
Colum_revive_DisconectSave=_logic getvariable ["Colum_revive_DisconectSave",true];

//Tiempo cada el que se salvara la posicion y inventario del jugador. -1 para solo salvar al desconectar. El tiempo es en segundos y aproximado ya que tiene en cuenta otros parametros como distancia caminada y cambios en el inventaro
Colum_revive_DisconectSave_Time=_logic getvariable ["Colum_revive_DisconectSave_Time",-1];

//Guardar contenidos de la mochila. Actualmente solo disponible si la opcion anterior esta habilitada.
Colum_revive_Save_Ruck=_logic getvariable ["Colum_revive_Save_Ruck",false];

//Permitir respawn . false= si se acaba el tiempo mueres definitivamente aunque te queden vidas. true= si se acaba el tiempo o cuando se decida hay opcion de hacer respawn si quedan vidas
Colum_revive_Respawn=_logic getvariable ["Colum_revive_Respawn",false];

//Al acaberse el tiempo de vida (ace_wounds_prevtime) el jugador respawnea automaticamente en el primer respawn definido de su bando. Si se pone a false, el jugador tendra la pantalla en negro hasta que pulse una opcion de respawn
Colum_revive_TimeoutAutoRespawn=_logic getvariable ["Colum_revive_TimeoutAutoRespawn",true];

//Si esta activo el respawn, permite que los respawn sean por oleadas y no por el tiempo desde la muerte de cada jugador.
//Significado: [ Tiempo desde el inicio de la mision  ,  Tiempo entre oleadas] . Todos los tiempos en segundos.
//IMPORTANTE esto anula la opcion: ace_sys_spectator_RevShowButtonTime
Colum_revive_WaveTime_Respawn=[_logic,"Colum_revive_WaveTime_Respawn",[-1,-1]] call _colum_revive_fnc_read_string_Var;


//Respawn por bandos . false= todos el mismo respawn. true= cada bando tiene su respawn
Colum_revive_Respawn_Side=_logic getvariable ["Colum_revive_Respawn_Side",false];

//Vidas por bandos . false=Todos el mismo numero de vidas. true= vidas segun el bando, se definen mas abajo
Colum_revive_Vidas_Side= _logic getvariable ["Colum_revive_Vidas_Side",false];

//Marcadores en el mapa, false= Sin marcadore, true= Las unidades gravemente heridas apareceran marcadas en el mapa.
Colum_revive_Death_Markers= _logic getvariable ["Colum_revive_Death_Markers",true];

//Mensages de muerte . false=No mostrara ningun mensage cuando alguien caiga herido. true= se mostrara un mensage cuando alguien cae gravemente herido
Colum_revive_Death_Messages= _logic getvariable ["Colum_revive_Death_Messages",true];

//Muertos dejan grupo . false=Los muertos siguen en el grupo original, solo que incoscientes. true=Cuando alguien muere definitivamente es expulsado del grupo, deberia dar mejores resultados, tan solo esta como opcion por si da problemas con algun script mal hecho que tome como referencia la unidad del lider
Colum_revive_Death_LeaveGroup= _logic getvariable ["Colum_revive_Death_LeaveGroup",true];

//Da?o minimo que queda despues de curar el MEDICO, multiplicado por cada cura. Recomendable 0.01 a 0.08 o 0 para desactivar. Aun asi, en los hospitales y vehiculos medicos se curaria totalmente independientemente de este parametro.
ace_sys_wounds_leftdam= [_logic,"ace_sys_wounds_leftdam",0] call _colum_revive_fnc_read_string_Var;

//Al "revivir" a alguien curar automaticamente sin medkit. True activado, false desactivado. Menos realista, pero por si se quiere dejar parecido a como estaba antes
Colum_revive_Levanta_Heal=_logic getvariable ["Colum_revive_Levanta_Heal",false];

//Penalice Respawn button with Death. If true, if you press the respawn button you are out of the game, if false, you will only lose a life
Colum_revive_RespawnButtonPunish=_logic getvariable ["Colum_revive_RespawnButtonPunish",false];

//Si se falla al recibir las vidas del servidor, se mata al jugador. True = muerte si fallo, false= si se falla al recibir, se usa el numero total de vidas :S
Colum_revive_KillOnConnectFail=_logic getvariable ["Colum_revive_KillOnConnectFail",true];

//Si el jugador se desconecta mientras esta incosciente o muerto, pierde una vida. Para evitar exploits(desconectarse para evitar la muerte y otras perrerias ??). True habilitado , false deshabilitado.
Colum_revive_DisconectPunish=_logic getvariable ["Colum_revive_DisconectPunish",false];

//Accion a realizar si alguien muere en el agua. hay 3 posibles opciones:
//0 : no hacer nada, como hasta la version anterior. El muerto se undira en el fondo del mar,  por lo que si es agua profunda sera irrecuperable, pero podria serlo si la profundidad es poca
//1 : muerte directa si el agua es profunda. Lo mismo que el caso anterior solo que si la profundidad es mayor a 2m mueres directamente, no tiene sentido quedar en el fondo sin poder ser salvado
//2 : El jugador herido queda flotando en el agua. Cualquiera puede acercase y agarrarlo si va nadando. Si se accerca cualquier vehiculo aliado, subira automaticamente a bordo.
//3 : El jugador es transportado a la costa mas cercana donde podria ser salvado.
Colum_revive_WaterAction=_logic getvariable ["Colum_revive_WaterAction",2];

//Persistencia de las vidas del los jugadores:
//-1 : infinito, las vidas persisten hasta que se cambie la mision(opcion por defecto)
//0 : No persistentes, las vidas se resetean al reconectar.
//>1 : Las vidas se resetean pasado X tiempo (en segundos)
Colum_revive_LifesPersist=_logic getvariable ["Colum_revive_LifesPersist",-1];

//Estar cerca de instalaciones medicas o en vehiculos hace que se tenga algo mas de tiempo para revivir a una persona herida( por ej estar dentro de una ambulancia incrementa el tiempo que puedes estar gravemente herido)
colum_revive_medicalExtraTime=_logic getvariable ["colum_revive_medicalExtraTime",true];


// Arregla algunos errores que pueden hacer que el jugador se quede atascado en el espectador. A?adida como opcion ya que son arreglos hardcoded que pueden dejar de funionar en futuras versiones del ACE
Colum_spect_workaround=_logic getvariable ["Colum_spect_workaround",true];

//La mision termina si todos los de los bandos indicados mueren. Tener en cuenta que aunque este desactivado([]) siempre se puede usar la variable:  Colum_revive_AlivePlayers = 0 (todos los jugadores muertos) o
// Colum_revive_AlivePlayers_WEST ==0(jugadores bluefor muertos), Colum_revive_AlivePlayers_EAST,Colum_revive_AlivePlayers_GUER, Colum_revive_AlivePlayers_CIV
// Tambien esta disposible: Colum_revive_AliveMedics y Colum_revive_AliveMedics_BANDO con el numero de medicos disponibles ( solo jugadores!, tener en cuenta q puede haber medico IA)
Colum_revive_EndGameIfAllDie=_logic getvariable ["Colum_revive_EndGameIfAllDie",[]];

//Si no hay medicos disponibles (incluyendo medicos IA del revive) los jugadores simplemente moriran sin cuenta atras.
Colum_Revive_KillIfNoMedic=_logic getvariable ["Colum_Revive_KillIfNoMedic",false];


if (Colum_revive_Respawn) then {
//Texto de los botones. Numero ilimitado de marcadores, se pueden agregar los necesarios
	Colum_revive_RespawnButton_text =[_logic,"Colum_revive_RespawnButton_text",["respawn1", "respawn2", "respawn3", "respawn4", "respawn4"]] call _colum_revive_fnc_read_string_Var;
	//Otro ejemplo con solo 2 botones : Colum_revive_RespawnButton_text = ["respawn1", "respawn2"];
//Nombre de los marcadores de los respawns
	Colum_revive_RespawnMarkers= [_logic,"Colum_revive_RespawnMarkers",["respawn1_marker", "respawn2_marker", "respawn3_marker", "respawn4_marker", "respawn5_marker"]] call _colum_revive_fnc_read_string_Var;
	if (!isMultiplayer) then {
		{
			if (((getmarkerpos _x) select 0) == 0 && ((getmarkerpos _x) select 1) == 0) then {
				format ["El marcador %1 no existe. Deberia crearse o quitarse de la lista",_x] call BIS_fnc_error;
			}
		}foreach Colum_revive_RespawnMarkers;
	};
//Offset de altura para los respawn. Util por ejemplo para respawns en un edificio o portaaviones.
	Colum_revive_RespawnOffset= [_logic,"Colum_revive_RespawnOffset",[0,0,0,0]] call _colum_revive_fnc_read_string_Var;

//Tiempo antes de la aparicion de los botones de respawn en segundos, obviamente menor que el ace_wounds_prevtime
	ace_sys_spectator_RevShowButtonTime = _logic getvariable ["ace_sys_spectator_RevShowButtonTime",10];

	if (Colum_revive_Respawn_Side) then {
		// Respawn Speciales por bando, si se definen no hacen falta los anteriores
		//Bluefor
		Colum_revive_RevButtons_WEST =_logic getvariable "Colum_revive_RevButtons_WEST";
		Colum_revive_RespawnMarkers_WEST=_logic getvariable "Colum_revive_RespawnMarkers_WEST";
		Colum_revive_RespawnOffset_WEST=_logic getvariable ["Colum_revive_RespawnOffset_WEST",[0]];
		Colum_revive_RevShowButtonTime_WEST =_logic getvariable "Colum_revive_RevShowButtonTime_WEST";
		Colum_revive_WaveTime_Respawn_WEST=_logic getvariable ["Colum_revive_WaveTime_Respawn_WEST",[-1,-1]];

		//oppfor
		Colum_revive_RevButtons_EAST =_logic getvariable "Colum_revive_RevButtons_EAST";
		Colum_revive_RespawnMarkers_EAST=_logic getvariable "Colum_revive_RespawnMarkers_EAST";
		Colum_revive_RespawnOffset_EAST=_logic getvariable ["Colum_revive_RespawnOffset_EAST",[0]];
		Colum_revive_RevShowButtonTime_EAST =_logic getvariable "Colum_revive_RevShowButtonTime_EAST";
		Colum_revive_WaveTime_Respawn_EAST=_logic getvariable ["Colum_revive_WaveTime_Respawn_EAST",[-1,-1]];

		//Independ
		Colum_revive_RevButtons_GUER =_logic getvariable "Colum_revive_RevButtons_GUER";
		Colum_revive_RespawnMarkers_GUER= _logic getvariable "Colum_revive_RespawnMarkers_GUER";
		Colum_revive_RespawnOffset_GUER=_logic getvariable ["Colum_revive_RespawnOffset_GUER",[0]];
		Colum_revive_RevShowButtonTime_GUER =_logic getvariable "Colum_revive_RevShowButtonTime_GUER";
		Colum_revive_WaveTime_Respawn_GUER=_logic getvariable ["Colum_revive_WaveTime_Respawn_GUER",[-1,-1]];

		//Civil
		Colum_revive_RevButtons_CIV = _logic getvariable "Colum_revive_RevButtons_CIV";
		Colum_revive_RespawnMarkers_CIV= _logic getvariable "Colum_revive_RespawnMarkers_CIV";
		Colum_revive_RespawnOffset_CIV=_logic getvariable ["Colum_revive_RespawnOffset_CIV",[0]];
		Colum_revive_RevShowButtonTime_CIV =_logic getvariable "Colum_revive_RevShowButtonTime_CIV";
		Colum_revive_WaveTime_Respawn_CIV=_logic getvariable ["Colum_revive_WaveTime_Respawn_CIV",[-1,-1]];
	};
};

if (Colum_revive_Vidas_Side) then {
	//Vidas para el bando bluefor
	Colum_revive_VidasMax_WEST=_logic getvariable "Colum_revive_VidasMax_WEST";

	//Vidas para el bando Opfor
	Colum_revive_VidasMax_EAST=_logic getvariable "Colum_revive_VidasMax_EAST";

	//Vidas para el bando indepen
	Colum_revive_VidasMax_GUER=_logic getvariable "Colum_revive_VidasMax_GUER";

	//Vidas para el bando civil
	Colum_revive_VidasMax_CIV=_logic getvariable "Colum_revive_VidasMax_CIV";
};



/***********************************************************************************************************************************/
/****************************************************FIN configuracion**************************************************************/
/***********************************************************************************************************************************/