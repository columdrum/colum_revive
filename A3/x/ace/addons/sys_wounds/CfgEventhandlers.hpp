class Extended_PreInit_EventHandlers {
	class ADDON {
		init = QUOTE(call COMPILE_FILE(XEH_preInit));
		clientinit = QUOTE(call COMPILE_FILE(XEH_preClientInit));
	};
};

class Extended_PostInit_EventHandlers {
	class ADDON {
		clientInit = QUOTE(call COMPILE_FILE(XEH_postClientInit));
	};
};

class Extended_Init_EventHandlers {
	class ACE_Stretcher {
		class ADDON {
			serverInit = QUOTE(_this call FUNC(stretchers));
			clientInit = QUOTE(_this call FUNC(stretcher));
		};
	};
};

class Extended_GetIn_EventHandlers {
	class ACE_Stretcher {
		class ADDON {
			GetIn = QUOTE(_this spawn FUNC(stretcher_fix));
		};
	};
};
//class Extended_GetOut_EventHandlers {
//	class ACE_Stretcher {
//		class ADDON {
//			GetOut = QUOTE(if (player == _this select 2) then { _this spawn FUNC(getOut) });
//		};
//	};
//};

class Extended_GetOut_EventHandlers {
	class Tank {
		class ADDON {
			getout = QUOTE(_this call FUNC(getout));
		};
	};
	class Wheeled_APC {
		class ADDON {
			getout = QUOTE(_this call FUNC(getout));
		};
	};
};

class Extended_Respawn_EventHandlers {
	class CAManBase {
		class ADDON {
			respawn = QUOTE(_this call FUNC(onRespawn));
		};
	};
};

class Extended_InitPost_EventHandlers {
	class CAManBase {
		class ADDON {
			init = QUOTE(_this call FUNC(addEH));
		};
	};
	class MASH {
		class ADDON {
			serverinit = "_this execFSM 'x\ace\addons\sys_wounds\aivec.fsm'";
		};
	};
};
