// SIX - Spect, by Sickboy (sb_at_dev-heaven.net)
// Standard Defines
#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = { "A3_Animals_F","Extended_Eventhandlers", QUOTE(MAIN_ADDON) };
		version = VERSION;
		author[] = {"Kegetys", "Sickboy", "Xeno", "ViperMaul", "Dwarden"};
	};
};

class CfgNonAiVehicles {
	class FireFly;
	class ACE_ButterFlySpectator : FireFly {
		acceleration = 20;
		straightDistance = 2;
		turning = 1;
	};
	//class Bird;
	/*
	class SeaGull: Bird {
		// Replace with Butterfly
		model = "\ca\Animals_e\aglais_urticae_e.p3d"; // Change the Crow to a Butterfly model -- Use class Crow or SeaGull2 if you need the SeaGull model
		moves = "CfgMovesButterfly";
		acceleration = 20;
		straightDistance = 2;
		turning = 1;

		singsound[] = {"", 0, 1, 1};  // fixing annoying crow song for BIS hardcoded crow class used for the spectator. - ViperMaul
	};
	class Crow: SeaGull {
		moves = "CfgMovesBird";
		acceleration = 7;
		straightDistance = 50;
	};
	*/
};

#include "CfgVehicles.hpp"
#include "CfgSpect.hpp"
#include "CfgFunctions.hpp"
#include "CfgEventhandlers.hpp"
#include "spectating.hpp"
#include "RscTitles.hpp"

// custom.hpp - Customization
#include "CfgRsc_map.hpp"



