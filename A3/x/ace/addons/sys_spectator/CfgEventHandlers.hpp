class Extended_PreInit_EventHandlers {
	class ADDON {
		clientInit = QUOTE(call COMPILE_FILE(XEH_preClientInit));
		init = QUOTE(call COMPILE_FILE(XEH_preInit));
	};
};
