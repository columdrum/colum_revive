/***********************************************************************************************************************************/
/*************************************************Seccion de configuracion***********************************************************/
/***********************************************************************************************************************************/
//Nº de vidas. Minimo 1( aunque no tiene mucho sentido ya me moriras a la primera)
//NOTA: Este valor sera sobreescrito si se le pasan parametros al execVM del init de la mision. Asique usa: execVM "revive\ReviveAceWounds.sqf"; 
Colum_revive_Conf_Lifes= 2;

//Desactivamos el sistema de heridas para las I.A. , en principio se comportan mejor sin el.
ace_sys_wounds_noai= true;

//Tiempo por el que se permanece inconsciente(muerto) antes de morir definitivamente.
ace_wounds_prevtime = 400;

//Solo los medicos pueden usar morphina y ephinifrina
ace_sys_wounds_medics_only=true;

//Mostrar contador. True mostrar, false la pantalla se va poniendo mas oscura cuanto menos tiempo tienes.
ace_wounds_prevtimeshow = true;

//Ativamos el modo espectador del revive cuando estamos inconscientes. False para pantalla negra mientras estamos muertos.
ace_sys_wounds_withSpect  = true;

//Activar el espectador una vez el jugador se queda sin vidadas. Si se pone a false, el jugador rebira la pantalla de fin de mision al quedarse sin vidas.
Colum_revive_AfterDeadSpect=true;

//Mostrar enemigos en el espectador una vez muerto. True = mostrar, False = no mostrar.
Colum_revive_VerEnemigos= true;

//PvP, los mensages de muerte, marcas en el mapa y demas seran por bando, para evitar dar informacion al bando contrario en PvP.
Colum_revive_PvP=true;

//Mostrar mensages de TK entre jugadores. True= mostrar mensajes. False= no mostrar
Colum_revive_TKcheck= true;

//Herir gravemente heridos +1 puntuacion, herir gravemente aliado -1 puntuacion. Pensado especialmente para PvP, simplemente para dar credito por herir a enemigos y no solo por matarlos cuando no tienen mas vidas.
Colum_revive_WoundScoring=true;

//Mochila para el medico, usar "" o comentar la linea para deshabilitar
Colum_revive_MochilaMedico="G_FieldPack_Medic";

//Contenido de la mochila, solo valido si lo anterior esta habilitado con una mochila válida
// Los contenidos estan ordenados [nº comprres, nº morphina, nº ephinifrina, nº granadas humo verde, nº medkits]
Colum_revive_MochilaMedico_Contenido=[7,15,10,2,10];


//Colum_revive_MochilaMedico_WEST = "ACE_VTAC_RUSH72_TT_MEDIC";
//Colum_revive_MochilaMedico_EAST = "ACE_VTAC_RUSH72_TT_MEDIC";
//Colum_revive_MochilaMedico_GUER = "ACE_VTAC_RUSH72_TT_MEDIC";
//Colum_revive_MochilaMedico_CIV = "ACE_VTAC_RUSH72_TT_MEDIC";


//Colum_revive_MochilaMedico_Contenido_WEST =[10,20,15,2,10];
//Colum_revive_MochilaMedico_Contenido_EAST = [10,20,15,2,10];
//Colum_revive_MochilaMedico_Contenido_GUER = [10,20,15,2,10];
//Colum_revive_MochilaMedico_Contenido_CIV =[10,20,15,2,10];


//Los jugadores que entran tarde tendran la posivilidad de teletransportarse a la posicion de su escuadra. True = permitir, False = no permitir
Colum_revive_JIPTelep=true;

//Cuando un jugador se desconecta se guarda su posicion, inventario y estado(si estaba incosciente o no). Cuando reconecta, volvera a esa posicion. True para habilitar, false deshabilitar
//NOTA: Necesita pruebas con muchos jugadores.
Colum_revive_DisconectSave=true;

//Tiempo cada el que se salvara la posicion y inventario del jugador. -1 para solo salvar al desconectar. El tiempo es en segundos y aproximado ya que tiene en cuenta otros parametros como distancia caminada y cambios en el inventaro
Colum_revive_DisconectSave_Time=-1;

//Guardar contenidos de la mochila. Actualmente solo disponible si la opcion anterior esta habilitada.
Colum_revive_Save_Ruck=false;

//Permitir respawn . false= si se acaba el tiempo mueres definitivamente aunque te queden vidas. true= si se acaba el tiempo o cuando se decida hay opcion de hacer respawn si quedan vidas
Colum_revive_Respawn=true;

//Al acaberse el tiempo de vida (ace_wounds_prevtime) el jugador respawnea automaticamente en el primer respawn definido de su bando. Si se pone a false, el jugador tendra la pantalla en negro hasta que pulse una opcion de respawn
Colum_revive_TimeoutAutoRespawn=true;

//Si esta activo el respawn, permite que los respawn sean por oleadas y no por el tiempo desde la muerte de cada jugador. 
//Significado: [ Tiempo desde el inicio de la mision  ,  Tiempo entre oleadas] . Todos los tiempos en segundos.
//IMPORTANTE esto anula la opcion: ace_sys_spectator_RevShowButtonTime
Colum_revive_WaveTime_Respawn=[-1,-1];

//Respawn por bandos . false= todos el mismo respawn. true= cada bando tiene su respawn
Colum_revive_Respawn_Side=false;

//Vidas por bandos . false=Todos el mismo numero de vidas. true= vidas segun el bando, se definen mas abajo
Colum_revive_Vidas_Side= false;

//Marcadores en el mapa, false= Sin marcadore, true= Las unidades gravemente heridas apareceran marcadas en el mapa.
Colum_revive_Death_Markers= true;

//Mensages de muerte . false=No mostrara ningun mensage cuando alguien caiga herido. true= se mostrara un mensage cuando alguien cae gravemente herido
Colum_revive_Death_Messages= true;

//Muertos dejan grupo . false=Los muertos siguen en el grupo original, solo que incoscientes. true=Cuando alguien muere definitivamente es expulsado del grupo, deberia dar mejores resultados, tan solo esta como opcion por si da problemas con algun script mal hecho que tome como referencia la unidad del lider
Colum_revive_Death_LeaveGroup= true;

//Daño minimo que queda despues de curar el MEDICO, multiplicado por cada cura. Recomendable 0.01 a 0.08 o 0 para desactivar. Aun asi, en los hospitales y vehiculos medicos se curaria totalmente independientemente de este parametro.
ace_sys_wounds_leftdam=0;

//Al "revivir" a alguien curar automaticamente sin medkit. True activado, false desactivado. Menos realista, pero por si se quiere dejar parecido a como estaba antes
Colum_revive_Levanta_Heal=false;

//Penalice Respawn button with Death. If true, if you press the respawn button you are out of the game, if false, you will only lose a life
Colum_revive_RespawnButtonPunish=false;

//Si se falla al recibir las vidas del servidor, se mata al jugador. True = muerte si fallo, false= si se falla al recibir, se usa el numero total de vidas :S
Colum_revive_KillOnConnectFail=true;

//Si el jugador se desconecta mientras esta incosciente o muerto, pierde una vida. Para evitar exploits(desconectarse para evitar la muerte y otras perrerias ¬¬). True habilitado , false deshabilitado.
Colum_revive_DisconectPunish=false;

//Accion a realizar si alguien muere en el agua. hay 3 posibles opciones:
//0 : no hacer nada, como hasta la version anterior. El muerto se undira en el fondo del mar,  por lo que si es agua profunda sera irrecuperable, pero podria serlo si la profundidad es poca
//1 : muerte directa si el agua es profunda. Lo mismo que el caso anterior solo que si la profundidad es mayor a 2m mueres directamente, no tiene sentido quedar en el fondo sin poder ser salvado
//2 : El jugador herido queda flotando en el agua. Cualquiera puede acercase y agarrarlo si va nadando. Si se accerca cualquier vehiculo aliado, subira automaticamente a bordo.(opcion por defecto)
//3 : El jugador es transportado a la costa mas cercana donde podria ser salvado.
Colum_revive_WaterAction=2;

//Persistencia de las vidas del los jugadores:
//-1 : infinito, las vidas persisten hasta que se cambie la mision(opcion por defecto)
//0 : No persistentes, las vidas se resetean al reconectar. 
//>1 : Las vidas se resetean pasado X tiempo (en segundos)
Colum_revive_LifesPersist=-1;

//Estar cerca de instalaciones medicas o en vehiculos hace que se tenga algo mas de tiempo para revivir a una persona herida( por ej estar dentro de una ambulancia incrementa el tiempo que puedes estar gravemente herido)
colum_revive_medicalExtraTime=true;


// Arregla algunos errores que pueden hacer que el jugador se quede atascado en el espectador. Añadida como opcion ya que son arreglos hardcoded que pueden dejar de funionar en futuras versiones del ACE
Colum_spect_workaround=true;

//La mision termina si todos los de los bandos indicados mueren. Tener en cuenta que aunque este desactivado([]) siempre se puede usar la variable:  Colum_revive_AlivePlayers = 0 (todos los jugadores muertos) o
// Colum_revive_AlivePlayers_WEST ==0(jugadores bluefor muertos), Colum_revive_AlivePlayers_EAST,Colum_revive_AlivePlayers_GUER, Colum_revive_AlivePlayers_CIV
// Tambien esta disposible: Colum_revive_AliveMedics y Colum_revive_AliveMedics_BANDO con el numero de medicos disponibles ( solo jugadores!, tener en cuenta q puede haber medico IA)
Colum_revive_EndGameIfAllDie=[]; // ejemplo : [west,east]

//Si no hay medicos disponibles (incluyendo medicos IA del revive) los jugadores simplemente moriran sin cuenta atras.
Colum_Revive_KillIfNoMedic=false;

if (Colum_revive_Respawn) then {
//Texto de los botones. Numero ilimitado de marcadores, se pueden agregar los necesarios
	Colum_revive_RespawnButton_text = ["respawn1", "respawn2", "respawn3", "respawn4", "respawn5"];
	//Otro ejemplo con solo 2 botones : Colum_revive_RespawnButton_text = ["respawn1", "respawn2"]; 
//Nombre de los marcadores de los respawns
	Colum_revive_RespawnMarkers= ["respawn1_marker", "respawn2_marker", "respawn3_marker", "respawn4_marker", "respawn5_marker"];
//Offset de altura para los respawn. Util por ejemplo para respawns en un edificio o portaaviones.
	Colum_revive_RespawnOffset= [0,0,0,0,5];
	
//Tiempo antes de la aparicion de los botones de respawn en segundos, obviamente menor que el ace_wounds_prevtime
	ace_sys_spectator_RevShowButtonTime = 90;
	
	if (Colum_revive_Respawn_Side) then {
		// Respawn Speciales por bando, si se definen no hacen falta los anteriores
		//Bluefor
		Colum_revive_RevButtons_WEST = ["respawn1_WEST", "respawn2_WEST", "respawn3_WEST", "respawn4_WEST"];
		Colum_revive_RespawnMarkers_WEST= ["respawn1_WEST", "respawn2_WEST", "respawn3_WEST", "respawn4_WEST"];
		Colum_revive_RespawnOffset_WEST=[0,0,0,0];
		Colum_revive_RevShowButtonTime_WEST = 80;
		Colum_revive_WaveTime_Respawn_WEST=[-1,-1];
		
		//oppfor
		Colum_revive_RevButtons_EAST = ["respawn1_EAST", "respawn2_EAST", "respawn3_EAST", "respawn4_EAST"];
		Colum_revive_RespawnMarkers_EAST= ["respawn1_EAST", "respawn2_EAST", "respawn3_EAST", "respawn4_EAST"];
		Colum_revive_RespawnOffset_EAST=[0,0,0,0];
		Colum_revive_RevShowButtonTime_EAST = 80;
		Colum_revive_WaveTime_Respawn_EAST=[-1,-1];
		
		//Independ
		Colum_revive_RevButtons_GUER = ["respawn1_GUER", "respawn2_GUER", "respawn3_GUER", "respawn4_GUER"];
		Colum_revive_RespawnMarkers_GUER= ["respawn1_GUER", "respawn2_GUER", "respawn3_GUER", "respawn4_GUER"];
		Colum_revive_RespawnOffset_GUER=[0,0,0,0];
		Colum_revive_RevShowButtonTime_GUER = 80;
		Colum_revive_WaveTime_Respawn_GUER=[-1,-1];
			
		//Civil
		Colum_revive_RevButtons_CIV = ["respawn1_CIV", "respawn2_CIV", "respawn3_CIV", "respawn4_CIV"];
		Colum_revive_RespawnMarkers_CIV= ["respawn1_CIV", "respawn2_CIV", "respawn3_CIV", "respawn4_CIV"];
		Colum_revive_RespawnOffset_CIV=[0,0,0,0];
		Colum_revive_RevShowButtonTime_CIV = 80;
		Colum_revive_WaveTime_Respawn_CIV=[-1,-1];
	};
};

if (Colum_revive_Vidas_Side) then {
	//Vidas para el bando bluefor
	Colum_revive_VidasMax_WEST=2;
	
	//Vidas para el bando Opfor
	Colum_revive_VidasMax_EAST=3;
	
	//Vidas para el bando indepen
	Colum_revive_VidasMax_GUER=4;
	
	//Vidas para el bando civil
	Colum_revive_VidasMax_CIV=10;
};



/***********************************************************************************************************************************/
/****************************************************FIN configuracion**************************************************************/
/***********************************************************************************************************************************/