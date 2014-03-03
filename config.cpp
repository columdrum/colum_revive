////////////////////////////////////////////////////////////////////
//DeRap: Produced from mikero's Dos Tools Dll version 3.89
//http://dev-heaven.net/projects/list_files/mikero-pbodll
////////////////////////////////////////////////////////////////////

#define _ARMA_

//Class colum_ACRE_AI_HEAR : config.bin{
class CfgPatches
{
	class colum_revive
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Modules_F"};
		version = "1.0";
		author[] = {"columdrum"};
		authorUrl = "http://www.ust101.com";
	};
};

class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class ModuleDescription;
	};
	class Colum_revive_Config: Module_F
	{
		scope = 2;
		displayName = "Configuracion Revive";
		icon = "\Colum_revive\data\icon\icon_ca.paa";
		category = "ust_modulos";
		function = "colum_revive_fnc_configModulo";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 0;
		isDisposable = 0;
		class Arguments
		{
			class life_num
			{
				displayName = "Numero de vidas";
				description = "Numero de vidas del jugador. Minimo 1, mayor de 1000 infinitas";
				typeName = "NUMBER";
				defaultValue = 2;
			};
			class death_msg
			{
				displayName = "Mensages de muerte";
				description = "Mostrar mensages de muerte";
				typeName = "NUMBER";
				class values
				{
					class verdadero
					{
						name = "Activado";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "Desactivado";
						value = 0;
					};
				};
			};
			class friendly_fire_msg
			{
				displayName = "Mensages de Fuego amigo";
				description = "Mostrar mensages de fuego amigo";
				typeName = "NUMBER";
				class values
				{
					class verdadero
					{
						name = "Activado";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "Desactivado";
						value = 0;
					};
				};
			};
			class is_tvt
			{
				displayName = "Modo TvT";
				description = "Si se activa, solo se mostraran los mensages del mismo bando";
				typeName = "NUMBER";
				class values
				{
					class verdadero
					{
						name = "Activado";
						value = 1;
					};
					class falso
					{
						name = "Desactivado";
						value = 0;
						default = 1;
					};
				};
			};
			class JIP_telep
			{
				displayName = "JIP teleport";
				description = "Permitir a los jugadores que entren con la mision iniciada teleportarse a su patrulla";
				typeName = "NUMBER";
				class values
				{
					class verdadero
					{
						name = "Activado";
						value = 1;
						default = 1;
					};
					class falso
					{
						name = "Desactivado";
						value = 0;
					};
				};
			};
			
		};
		class ModuleDescription: ModuleDescription
		{
			description = "Este modulo habilita el revive y permite configurarlo";
			sync[] = {"LocationArea_F"};
			class LocationArea_F
			{
				description[] = {"Modulo de configuracion del revive","Si se coloca, asegurarse de todas las opciones que se activen son las deseadas"};
				position = 0;
				direction = 0;
				optional = 1;
				duplicate = 1;
				synced[] = {"Anything"};
			};
		};
	};
};

class CfgFunctions
{
	class colum_revive
	{
		class events
		{
			file = "Colum_revive\scripts\fnc\events";
			class wounded_event{};
			class death_event{};

		};
		class Init
		{
			file = "Colum_revive\scripts\fnc\init";
			class configModulo{};
			class init_player{};
			class init_Server{};
		};
		class general
		{
			file = "Colum_revive\scripts\fnc\general";
			class character_final_death{};
			class character_unconscious{};
		};
		class ui
		{
			class death_msg{};
		}
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