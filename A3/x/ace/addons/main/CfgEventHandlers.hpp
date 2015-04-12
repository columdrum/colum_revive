class Extended_PreInit_EventHandlers {
	class ADDON {
		// main, sys_help, sys_cleaner
		init = QUOTE(call COMPILE_FILE(XEH_preInit));

		// Settings
		//clientInit = QUOTE(call COMPILE_FILE2(\x\ace\addons\settings\XEH_preClientInit.sqf));

		// sys_ladenbalken
		serverInit = QUOTE(call COMPILE_FILE(XEH_preServerInit));
	};
};
class Extended_PostInit_EventHandlers {
	class ADDON {
		// main, sys_help
		serverInit = QUOTE(call COMPILE_FILE(XEH_PostServerInit));

		// sys_ladenbalken, sys_help
		clientInit = QUOTE(call COMPILE_FILE(XEH_postClientInit));
	};
};

// TODO: Better handle optional eventhandlers
// TODO: Switch to player-eventhandler??
class Extended_GetOut_EventHandlers {
	class AllVehicles {
		class ADDON {
			clientGetOut = QUOTE( if (_this select 2 == player && GVAR(dismount_enabled)) then { _this call FUNC(CAMERA) });
		};
	};
};

class Extended_FiredBIS_EventHandlers {
	class CAManBase {
		class ADDON {
			// main, sys_help, sys_cleaner
			firedBis = QUOTE(_this call FUNC(fired));
		};
	};
};

class Extended_Init_EventHandlers {
	class ACE_Logic {
		class ADDON {
			init = "(_this select 0) enableSimulation false";
		};
	};
};
