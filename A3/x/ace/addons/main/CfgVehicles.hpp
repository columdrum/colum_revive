class CfgVehicles {
	class All {
		class ACE {}; // Empty ACE child class, so it exists in all classes.
	};
	class ParaChuteG;
	class ACE_B61_Parachute: ParaChuteG {};

	class Module_F;
	class ACE_Logic: Module_F {
		displayname = $STR_ACE_LOGIC;
	};

	class ACE_Required_Logic: ACE_Logic {
		displayName = $STR_ACE_REQUIRED;
		vehicleClass = "Modules";
	};

	// Backwards compatibility - executing BIS artillery module inits now
	class ACE_BI_ARTY_Logic: ACE_Logic {
		scope = 1;
		displayName = "$STR_ACE_BI_ARTY";
		icon = QUOTE(PATHTOF(data\icon\icon_ARTY_ca.paa));
		vehicleClass = "Modules";
		class Eventhandlers {
			init = QUOTE(_this spawn COMPILE_FILE2_CFG(\ca\modules\arty\data\scripts\init.sqf));
		};
	};
	class ACE_BI_ARTY_Virtual_Artillery: ACE_Logic {
		scope = 1;
		displayName = "$STR_ACE_BI_ARTY_VIRT";
		icon = QUOTE(PATHTOF(data\icon\icon_ARTY_virtual_ca.paa));
		vehicleClass = "Modules";
		class Eventhandlers {
			init = QUOTE(_this spawn COMPILE_FILE2_CFG(\ca\modules\arty\data\scripts\ARTY_initVirtual.sqf));
		};
	};

	// Using HeliHEmpty so you can use createVehicle
	// and prevent; UnExpected call of CreateVehicle for 'ACE_LogicDummy', pos(3973.485840.2,46.544781.2,3478.218262.2). Vehicles with brain cannot be created using 'createVehicle'!
	class HeliHEmpty;
	class ACE_LogicDummy: HeliHEmpty {
		scope = 1;
		SLX_XEH_DISABLED = 1;
		class EventHandlers {
			init = "(_this select 0) enableSimulation false";
		};
	};

	// ACE SYS DUMMIES
	class Land;
	class Man: Land {
		class ViewPilot;
	};
	#include "CfgVehicles_Dummy.hpp"
};
