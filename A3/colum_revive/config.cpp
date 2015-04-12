////////////////////////////////////////////////////////////////////
//DeRap: Produced from mikero's Dos Tools Dll version 4.97
//Sun Apr 12 13:52:34 2015 : Source 'file' date Sun Apr 12 13:52:34 2015
//http://dev-heaven.net/projects/list_files/mikero-pbodll
////////////////////////////////////////////////////////////////////

#define _ARMA_

//Class colum_revive : config.bin{
class CfgPatches
{
	class colum_revive
	{
		units[] = {"colum_revive_logic","colum_revive_logicExtern","colum_revive_logicMedEvac"};
		weapons[] = {};
		requiredVersion = 1;
		requiredAddons[] = {"CBA_main","Extended_EventHandlers","ace_main","ace_sys_interaction"};
		magazines[] = {};
		ammo[] = {};
	};
};
class CfgAddons
{
	class PreloadAddons
	{
		class colum_revive
		{
			list[] = {"colum_revive"};
		};
	};
};
class CfgVehicles
{
	class Module_F;
	class colum_revive_logic: Module_F
	{
		scope = 2;
		category = "ust_modulos";
		displayName = "[Revive] Editor Options";
		icon = "\colum_revive\Icons\Icon_revive_d_ca.paa";
		picture = "\colum_revive\Icons\Icon_revive_d_ca.paa";
		vehicleClass = "Modules";
		class EventHandlers
		{
			init = "ace_sys_wounds_enabled=true;[_this,1] execVM '\colum_revive\revive\ReviveAceWounds.sqf';";
		};
		class Arguments
		{
			class Colum_revive_Conf_Lifes
			{
				displayName = "$STR_PARAM_COLUM_REV_LIFENUM";
				description = "$STR_PARAM_COLUM_REV_LIFENUM_INFO";
				typeName = "NUMBER";
				defaultValue = 2;
			};
			class ace_wounds_prevtime
			{
				displayName = "$STR_PARAM_COLUM_REV_TIMER";
				description = "$STR_PARAM_COLUM_REV_TIMER_INFO";
				typeName = "NUMBER";
				defaultValue = 500;
			};
			class ace_sys_wounds_medics_only
			{
				displayName = "$STR_PARAM_COLUM_REV_ONLYMEDIC";
				description = "$STR_PARAM_COLUM_REV_ONLYMEDIC_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class ace_sys_wounds_withSpect
			{
				displayName = "$STR_PARAM_COLUM_REV_WITHSPECT";
				description = "$STR_PARAM_COLUM_REV_WITHSPECT_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_revive_AfterDeadSpect
			{
				displayName = "$STR_PARAM_COLUM_REV_AFTERDEADSPECT";
				description = "$STR_PARAM_COLUM_REV_AFTERDEADSPECT_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_revive_MochilaMedico
			{
				displayName = "$STR_PARAM_COLUM_REV_MOCHILOMED";
				description = "$STR_PARAM_COLUM_REV_MOCHILOMED_INFO";
				typeName = "STRING";
				defaultValue = "G_FieldPack_Medic";
			};
			class Colum_revive_MochilaMedico_Contenido
			{
				displayName = "$STR_PARAM_COLUM_REV_MOCHILOCONT";
				description = "$STR_PARAM_COLUM_REV_MOCHILOCONT_INFO";
				typeName = "STRING";
				defaultValue = "[7,15,10,2,10]";
			};
			class Colum_revive_JIPTelep
			{
				displayName = "$STR_PARAM_COLUM_REV_JIPTELEP";
				description = "$STR_PARAM_COLUM_REV_JIPTELEP_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_revive_Death_Markers
			{
				displayName = "$STR_PARAM_COLUM_REV_DEATHMARKER";
				description = "$STR_PARAM_COLUM_REV_DEATHMARKER_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_revive_Death_Messages
			{
				displayName = "$STR_PARAM_COLUM_REV_DEATHMSG";
				description = "$STR_PARAM_COLUM_REV_DEATHMSG_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_revive_TKcheck
			{
				displayName = "$STR_PARAM_COLUM_REV_TKCHECK";
				description = "$STR_PARAM_COLUM_REV_TKCHECK_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_revive_VerEnemigos
			{
				displayName = "$STR_PARAM_COLUM_REV_SPECTENEMY";
				description = "$STR_PARAM_COLUM_REV_SPECTENEMY_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_revive_WoundScoring
			{
				displayName = "$STR_PARAM_COLUM_REV_WOUNDSCORE";
				description = "$STR_PARAM_COLUM_REV_WOUNDSCORE_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_revive_DisconectSave
			{
				displayName = "$STR_PARAM_COLUM_REV_DISCONECTSAV";
				description = "$STR_PARAM_COLUM_REV_DISCONECTSAV_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_revive_Death_LeaveGroup
			{
				displayName = "$STR_PARAM_COLUM_REV_DLEAVEGROUP";
				description = "$STR_PARAM_COLUM_REV_DLEAVEGROUP_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
						default = 1;
					};
				};
			};
			class ace_sys_wounds_leftdam
			{
				displayName = "$STR_PARAM_COLUM_REV_ACELEFTDAM";
				typeName = "STRING";
				description = "$STR_PARAM_COLUM_REV_ACELEFTDAM_INFO";
				defaultValue = "0";
			};
			class Colum_revive_Levanta_Heal
			{
				displayName = "$STR_PARAM_COLUM_REV_LEVANTAHEAL";
				description = "$STR_PARAM_COLUM_REV_LEVANTAHEAL_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
						default = 1;
					};
				};
			};
			class Colum_revive_RespawnButtonPunish
			{
				displayName = "$STR_PARAM_COLUM_REV_RESBUTPUNISH";
				description = "$STR_PARAM_COLUM_REV_RESBUTPUNISH_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
						default = 1;
					};
				};
			};
			class Colum_revive_KillOnConnectFail
			{
				displayName = "$STR_PARAM_COLUM_REV_KillONConnectFail";
				description = "$STR_PARAM_COLUM_REV_KillONConnectFail_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_revive_DisconectPunish
			{
				displayName = "$STR_PARAM_COLUM_REV_DISCPUNISH";
				description = "$STR_PARAM_COLUM_REV_DISCPUNISH_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
						default = 1;
					};
				};
			};
			class Colum_revive_WaterAction
			{
				displayName = "$STR_PARAM_COLUM_REV_WATERACT";
				description = "$STR_PARAM_COLUM_REV_WATERACT_INFO";
				typeName = "NUMBER";
				class values
				{
					class Option_1
					{
						name = "$STR_BUTTONS_COLUM_WaterAction_OPT1";
						Value = 0;
					};
					class Option_2
					{
						name = "$STR_BUTTONS_COLUM_WaterAction_OPT2";
						Value = 1;
					};
					class Option_3
					{
						name = "$STR_BUTTONS_COLUM_WaterAction_OPT3";
						Value = 2;
						default = 1;
					};
					class Option_4
					{
						name = "$STR_BUTTONS_COLUM_WaterAction_OPT4";
						Value = 3;
					};
				};
			};
			class Colum_revive_Respawn
			{
				displayName = "$STR_PARAM_COLUM_REV_RESPAWN";
				description = "$STR_PARAM_COLUM_REV_RESPAWN_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
						default = 1;
					};
				};
			};
			class Colum_revive_TimeoutAutoRespawn
			{
				displayName = "$STR_PARAM_COLUM_REV_AUTORESPAWN";
				description = "$STR_PARAM_COLUM_REV_AUTORESPAWN_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class ace_sys_spectator_RevShowButtonTime
			{
				displayName = "$STR_PARAM_COLUM_REV_SHOWBUTTONTIME";
				description = "$STR_PARAM_COLUM_REV_SHOWBUTTONTIME_INFO";
				typeName = "NUMBER";
				defaultValue = -1;
			};
			class Colum_revive_RespawnButton_text
			{
				displayName = "$STR_PARAM_COLUM_REV_BUTTONTEXT";
				description = "$STR_PARAM_COLUM_REV_BUTTONTEXT_INFO";
				typeName = "STRING";
				DefaultValue = "['respawn1','respawn2','respawn3','respawn4','respawn5']";
			};
			class Colum_revive_RespawnMarkers
			{
				displayName = "$STR_PARAM_COLUM_REV_RESMARKERS";
				description = "$STR_PARAM_COLUM_REV_RESMARKERS_INFO";
				typeName = "STRING";
				DefaultValue = "['respawn1_marker','respawn2_marker','respawn3_marker','respawn4_marker','respawn5_marker']";
			};
			class Colum_revive_RespawnOffset
			{
				displayName = "$STR_PARAM_COLUM_REV_RESOFFSET";
				description = "$STR_PARAM_COLUM_REV_RESOFFSET_INFO";
				typeName = "STRING";
				DefaultValue = "[0,0,0,0,0]";
			};
			class Colum_revive_LifesPersist
			{
				displayName = "$STR_PARAM_COLUM_REV_LIFEPERSIST";
				description = "$STR_PARAM_COLUM_REV_LIFEPERSIST_INFO";
				typeName = "NUMBER";
				DefaultValue = -1;
			};
			class Colum_revive_WaveTime_Respawn
			{
				displayName = "$STR_PARAM_COLUM_REV_WAVETIMERESPAWN";
				description = "$STR_PARAM_COLUM_REV_WAVETIMERESPAWN_INFO";
				typeName = "STRING";
				DefaultValue = "[-1,-1]";
			};
			class colum_revive_medicalExtraTime
			{
				displayName = "$STR_PARAM_COLUM_REV_EXTRAMEDTIME";
				description = "$STR_PARAM_COLUM_REV_EXTRAMEDTIME_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
			class Colum_spect_workaround
			{
				displayName = "$STR_PARAM_COLUM_REV_SPECTWORKAROUND";
				description = "$STR_PARAM_COLUM_REV_SPECTWORKAROUND_INFO";
				typeName = "BOOL";
				class values
				{
					class verdadero
					{
						name = "$STR_BUTTONS_COLUM_Enabled";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "$STR_BUTTONS_COLUM_Disabled";
						value = 0;
					};
				};
			};
		};
	};
	class colum_revive_logicExtern: Module_F
	{
		scope = 2;
		category = "ust_modulos";
		displayName = "[Revive] External options";
		icon = "\colum_revive\Icons\Icon_revive_e_ca.paa";
		picture = "\colum_revive\Icons\Icon_revive_e_ca.paa";
		vehicleClass = "Modules";
		class EventHandlers
		{
			init = "[_this,0] execVM '\colum_revive\revive\ReviveAceWounds.sqf' ";
		};
		class Arguments
		{
			class colum_revive_CfgPath
			{
				displayName = "Config file";
				description = "Path to the config file for the revive, you can use the same config file than the script version";
				typeName = "STRING";
				defaultValue = "reviveConfig\Configuracion.sqf";
			};
		};
	};
	class colum_revive_logicMedEvac: Module_F
	{
		scope = 2;
		category = "ust_modulos";
		displayName = "[Revive] Revive MedEvac";
		icon = "\colum_revive\Icons\Icon_revive_me_ca.paa";
		picture = "\colum_revive\Icons\Icon_revive_me_ca.paa";
		vehicleClass = "Modules";
		class EventHandlers
		{
			init = "_this execVM '\colum_revive\revive\MedEvac\ModulosMedEvac.sqf' ";
		};
		class Arguments
		{
			class Colum_revive_MedicRange
			{
				displayName = "Medic range:";
				description = "Medic that the medic can move to heal soldiers, in meters";
				typeName = "NUMBER";
				defaultValue = 5;
			};
			class Colum_revive_RespawnTime
			{
				displayName = "Heli respawn time:";
				description = "Time to respawn the medevac heli. 0 == no respawn";
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class Colum_revive_Bando
			{
				displayName = "Medic side:";
				description = "default heals all sides. Can be a array e.g. [west,east]";
				typeName = "STRING";
				defaultValue = "playerside";
			};
			class Colum_revive_HeliSide
			{
				displayName = "Heli side:";
				description = "default heli driver side. M e.g. west";
				typeName = "STRING";
				class values
				{
					class Option_1
					{
						name = "Heli driver side";
						value = "sideUnknown";
						default = 1;
					};
					class Option_2
					{
						name = "Opffor (East)";
						value = "East";
					};
					class Option_3
					{
						name = "Blueffor (West)";
						value = "West";
					};
					class Option_4
					{
						name = "Independent";
						value = "resistance";
					};
					class Option_5
					{
						name = "Civilian";
						value = "civilian";
					};
				};
			};
			class Colum_revive_condicion
			{
				displayName = "MedEvac condition:";
				description = "condition needed to be able to call the medevac. Default its leader can call.";
				typeName = "STRING";
				defaultValue = "leader group player == player";
			};
		};
	};
};
class CfgFactionClasses
{
	class NO_CATEGORY;
	class ust_modulos: NO_CATEGORY
	{
		displayName = "Modulos UST101";
	};
};
//};
