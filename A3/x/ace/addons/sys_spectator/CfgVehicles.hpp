
class CfgVehicles {
	class All;
	class ThingEffect;
	class ThingEffectLight;
	class ACE_Logic;
	class ACE_Spectator_ShownSides_Logic: ACE_Logic {
		displayName = $STR_ACE_SPECT_SHOWNSIDES;
		vehicleClass = "Modules";
		class Eventhandlers {
			init = "";
		};
	};

	class ACE_KEGsAddon10: ThingEffectLight {
		scope = 1;
		model = QUOTE(PATHTO_M(bar_green_new.p3d));
	};
	class ACE_KEGspect_bar_yellow: ThingEffectLight {
		scope = 1;
		model = QUOTE(PATHTO_M(bar_yellow_new.p3d));
		displayName = "bar";
		airRotation = 0;
	};
	class ACE_KEGspect_bar_red: ACE_KEGspect_bar_yellow {
		model = QUOTE(PATHTO_M(bar_red_new.p3d));
	};
	class ACE_KEGspect_bar_green: ACE_KEGspect_bar_yellow {
		model = QUOTE(PATHTO_M(bar_green_new.p3d));
	};
};
