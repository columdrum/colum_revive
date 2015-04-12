// Vanilla ArmA2 Magic Heal
#define __MAGIC_HEAL class UserActions { \
class ACE_MagicHeal { \
displayName = $STR_ACE_UA_HEAL; \
onlyForPlayer = 1; \
position = "doplnovani"; \
radius = 5; \
condition = "((damage player > 0) && !(player in (crew this)) && (isNil ""ace_sys_wounds_enabled""))"; \
statement = "player setdamage 0; player playmove ""AinvPknlMstpSlayWrflDnon_medic"";"; }; };

#define MED_REP __MAGIC_HEAL attendant = 0; ACE_W_HEAL = 1

class CfgVehicles {
	class ACE_Logic;
	class ACE_Wounds_Logic: ACE_Logic {
		scope=2;
		vehicleClass = "Modules";
  		displayName = "$STR_ACE_WOUNDS_ENABLE";
		icon = QUOTE(PATHTOF(data\icon\icon_sys_wounds_ca.paa));
		picture = QUOTE(PATHTOF(data\icon\icon_sys_wounds_ca.paa));
		class Eventhandlers {
			init = "if (isServer) then {ace_sys_wounds_enabled = true;publicVariable 'ace_sys_wounds_enabled'};";
		};
	};
	class ACE_Wounds_MedicsOnly_Logic: ACE_Logic {	
		scope=2;
		displayName = $STR_ACE_WOUNDS_MEDICS_ONLY;
		icon = QUOTE(PATHTOF(data\icon\icon_sys_wounds_mo_ca.paa));
		picture = QUOTE(PATHTOF(data\icon\icon_sys_wounds_mo_ca.paa));
		vehicleClass = "Modules";
		class Eventhandlers {
			init = "if (isServer) then {ace_sys_wounds_medics_only = true;publicVariable 'ace_sys_wounds_medics_only'};";
		};
	};
	class ACE_Wounds_EveryoneMedic: ACE_Logic {
		scope=2;
		displayName = $STR_ACE_WOUNDS_ALL_MEDICS;
		icon = QUOTE(PATHTOF(data\icon\icon_sys_wounds_ca.paa));
		picture = QUOTE(PATHTOF(data\icon\icon_sys_wounds_ca.paa));
		vehicleClass = "Modules";
		class Eventhandlers {
			init = "if (isServer) then {ace_sys_wounds_all_medics = true;publicVariable 'ace_sys_wounds_all_medics'};";
		};
	};

	class ACE_Wounds_FullHeal: ACE_Logic {
		scope=2;
		displayName = $STR_ACE_WOUNDS_FULL_HEAL;
		icon = QUOTE(PATHTOF(data\icon\icon_sys_wounds_ca.paa));
		picture = QUOTE(PATHTOF(data\icon\icon_sys_wounds_ca.paa));
		vehicleClass = "Modules";
		class Eventhandlers {
			init = "if (isServer) then {ace_sys_wounds_leftdam = 0;publicVariable 'ace_sys_wounds_leftdam'};";
		};
	};

	// Stretcher
	#include "CfgVehicles_Stretcher.hpp"

	// HEADBUG FIX VEHICLE and FIX vehicle for launcher animation bug
	class ACE_Headbug_Fix: Bicycle {
		scope = 1;
		side = 3;
		model = QUOTE(PATHTO_M(ACE_HeadBanger.p3d));
		displayName = " ";
		soundEngine[] = {"", 20, 0.875};
		soundEnviron[] = {"", 25, 0.925};
		isBicycle = 1;
		XEH_DISABLED;
	};

	class ReammoBox;
	class ACE_BandageBox: ReammoBox {
		displayName = $STR_DN_ACE_BANDAGEBOX;
		vehicleClass = "Ammo";
		class TransportMagazines {
			ACE_M_MAG(ACE_Bandage,30);
			ACE_M_MAG(ACE_LargeBandage,15);
			//ACE_M_MAG(ACE_Tourniquet,30);
			ACE_M_MAG(ACE_Morphine,30);
			ACE_M_MAG(ACE_Epinephrine,30);
			//ACE_M_MAG(ACE_Splint,30);
			//ACE_M_MAG(ACE_IV,30);
			//ACE_M_MAG(ACE_Plasma,30);
			ACE_M_MAG(ACE_Medkit,15);
		};
	};

	class ACE_BandageBoxWest: ACE_BandageBox {
		scope = 2;
		accuracy = 1000;
		displayName = $STR_DN_ACE_BANDAGEBOX;
		model = QUOTE(PATHTO_M(ace_medcrate.p3d));
	};
	class ACE_BandageBoxEast: ACE_BandageBoxWest {
		scope = 1; // No need for a seperation between east and west for the same box
		displayName = $STR_DN_ACE_BANDAGEBOX;
		model = QUOTE(PATHTO_M(ace_medcrate_r.p3d));
	};

	// Transport Magazines/Weapons moved to c_veh_transport
	/*
	class BMP2_Base;
	class BMP2_Ambul_Base: BMP2_Base { MED_REP; };
	class Mi17_base;
	class Mi17_medevac_base: Mi17_base { MED_REP; };
	class Camp_base;
	class MASH: Camp_base { MED_REP; };
	class HMMWV_Base;
	class HMMWV_Ambulance: HMMWV_Base { MED_REP; };
	class HMMWV_Ambulance_base;
	class HMMWV_Ambulance_DES_EP1: HMMWV_Ambulance_base { MED_REP; };
	class HMMWV_Ambulance_CZ_DES_EP1: HMMWV_Ambulance_base { MED_REP; };
	class S1203_TK_CIV_EP1;
	class S1203_ambulance_EP1: S1203_TK_CIV_EP1 { MED_REP; };
	class StrykerBase_EP1;
	class M1133_MEV_EP1: StrykerBase_EP1 { MED_REP; };
	class BASE_WarfareBFieldhHospital: Camp_base { MED_REP; };
	class UH60M_US_base_EP1;
	class UH60M_MEV_EP1: UH60M_US_base_EP1 { MED_REP; };
	class M113_Base;
	class M113Ambul_Base: M113_Base { MED_REP; };

	class UH60_Base;
	class MH60S: UH60_Base { MED_REP;	};

	class GAZ_Vodnik;
	class GAZ_Vodnik_MedEvac: GAZ_Vodnik { MED_REP; };
	*/

};
