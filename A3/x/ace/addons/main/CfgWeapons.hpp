class CfgWeapons {
	class Default {
		class ACE {}; // Empty ACE child class, so it exists in all classes.
	};
	class ItemCore;
	class ACE_Obsolete_Item: ItemCore {
		scope = 1;
		displayName = "OBSOLETE ITEM";
		displayNameShort = "OBSOLETE ITEM";
		picture = QUOTE(PATHTOF(data\obsolete\icon_obsolete_ca.paa));// Generic icon for obsolete items
		model = QUOTE(PATHTOF(data\obsolete\obsolete.p3d));// Generic empty model for obsolete items
		class Armory {
			disabled = 0;
		};		
	};
	#include "CfgWeapons_Obsolete.hpp"
};
