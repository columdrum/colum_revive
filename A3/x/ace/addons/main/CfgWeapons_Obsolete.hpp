	// Banana
	class ACE_JerryCan_Dummy: ACE_Obsolete_Item {
		displayName = "Banana"; //$STR_DN_ACE_JERRYCAN_DUMMY; // TODO: Clear from stringtable ???
		ACE_Size = 1;
		ACE_Weight = 1;
		picture = QUOTE(PATHTOF(data\obsolete\icon_banana_ca.paa)); // Generic icon for obsolete items
		model = QUOTE(PATHTOF(data\obsolete\banana.p3d)); // Generic empty model for obsolete items
	};
	class ACE_JerryCan_Dummy_15: ACE_JerryCan_Dummy { scope = 2; }; // 2 so one can drop it...
	/* TO ADD: 
		magazine: class ACE_IRStrobe: IR_Strobe_Marker
		magazine: class IRStrobe: IR_Strobe_Marker // BIS fault - not used by them in their THROW weapon!!
	*/