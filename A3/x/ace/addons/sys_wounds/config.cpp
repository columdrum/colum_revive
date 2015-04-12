#include "script_component.hpp"
class CfgPatches {
	class ADDON {
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {
			QUOTE(MAIN_ADDON), "ace_sys_interaction","A3_Weapons_F"
		};
		version = VERSION;
		author[] = {"Xeno", "Sickboy"};
	};
};

class CfgAddons {
	class PreloadAddons {
		class ADDON {list[]={ADDON};};
	};
};


#include "CfgEventHandlers.hpp"
#include "CfgAmmo.hpp"
#include "CfgMagazines.hpp"
#include "CfgWeapons.hpp"
#include "CfgVehicleClasses.hpp"
#include "CfgVehicles.hpp"
#include "CfgSounds.hpp"
#include "RscTitles.hpp"
#include "Dialog.hpp"



