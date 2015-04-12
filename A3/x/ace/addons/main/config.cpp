#include "script_component.hpp"
class CfgPatches {
	class ADDON {
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = { "CBA_Extended_EventHandlers", "CBA_MAIN", "A3_Modules_F", "A3_UIFonts_F" };
		author[] = {"ACE Team"};
		authorUrl = "http://ace.dev-heaven.net";
		versionDesc = "A.C.E.";
		versionAct = "['MAIN',_this] execVM '\x\ace\addons\main\about.sqf';";
		VERSION_CONFIG;
	};

	// Backwards Compatibility
	BWC_CONFIG(ace_c_men_ruckless);
	BWC_CONFIG(ace_settings_no_intro);
	BWC_CONFIG(ace_settings_recognize);
	BWC_CONFIG(ace_settings_staying_brass);
	BWC_CONFIG(ace_settings_ruckless);
	BWC_CONFIG(ace_settings_no_radio_chat);
	BWC_CONFIG(ace_settings_crosshair);
	BWC_CONFIG(ace_settings_identities);
	BWC_CONFIG(ace_settings_immersive_dismount);
	BWC_CONFIG(ace_sys_bi_arty);
	BWC_CONFIG(ace_sys_nuke);
	BWC_CONFIG(ace_c_men_sounds);
	BWC_CONFIG(acex_veh_static);
};

class CfgMods {
	class PREFIX {
		dir = "@ACE";
		name = "Core - Advanced Combat Environment";
		picture = "ca\ui\data\logo_arma2ep1_ca.paa";
		hidePicture = "true";
		hideName = "true";
		actionName = "Website";
		action = "http://ace.dev-heaven.net";
		description = "Bugtracker: http://dev-heaven.net/projects/ace-mod2<br />Documentation: http://ace.dev-heaven.net";
	};
};

class CfgSettings {
	class CBA {
		class Versioning {
			class PREFIX {
				level = DEFAULT_VERSIONING_LEVEL;
				handler = "ace_main_fnc_mismatch";
				class Dependencies {
					CBA[]={"cba_main", {0,8,3}, "true"};
					XEH[]={"extended_eventhandlers", {3,3,3}, "true"};
				};
			};
		};
/*
		class Registry {
			class PREFIX {
				removed[] = {};
			};
		};
*/
	};
};


#include "CfgSounds.hpp"
#include "CfgAmmo.hpp"
#include "CfgMagazines.hpp"
#include "CfgWeapons.hpp"
#include "CfgRscStd.hpp"
#include "Dialog.hpp"
#include "Dialog_Ladebalken.hpp"

#include "About.hpp"
class RscTitles {
	#include "CfgRscTitles.hpp"
	#include "CfgRscTitles_Ladebalken.hpp"
};

#include "CfgEventHandlers.hpp"
#include "CfgFunctions.hpp"
#include "ACE_Config.hpp"

class CfgMarkers {
	class Flag;

	class ACE_Radiation_Area: Flag {};
};
#include "CfgVehicles.hpp"

// #include "CfgKeys.hpp"

#include "CfgFontFamilies.hpp"

