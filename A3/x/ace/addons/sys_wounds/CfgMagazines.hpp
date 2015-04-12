class CfgMagazines {
	class Default;
	class CA_Magazine: Default { class ACE; };

	///////////////////
	// Medical Items //
	///////////////////

	//Small Bandages: Stops 50 ml/min blood loss, repeatable [1 / .5] (5s)
	class ACE_Bandage: CA_Magazine {
		mass = 3.5;
		weight = 0;
		ACE_Weight = 0.1;
		ACE_Size = 20;
		scope = 2;
		value = 1;
		type = 16;
		ammo = "ACE_DummyAmmo";
		displayName = "$STR_ACE_ITEM_BANDAGE";
		picture = QUOTE(PATHTO_C(data\equip\m_bandage_ca.paa));
		useActionTitle = "Apply Bandage";
		//simulation = "ProxyMagazines";
		model = QUOTE(PATHTO_M(ace_bandage.p3d));
		count = 1;
		initSpeed = 100;
		reloadAction = "";
		class ACE: ACE {
			class ACE_WOUNDS {
				useTime = 5;
				bloodRemove = 0.25;
				bloodStop = 20;
				painStop = 0;
			};
		};
	};

	// NA
	class ACE_LargeBandage: ACE_Bandage {
		mass = 5;
		weight = 0;
		ACE_Weight = 0.2;
		displayName = "$STR_ACE_ITEM_LARGEBANDAGE";
		ACE_Size = 100;
		class ACE: ACE {
			class ACE_WOUNDS: ACE_WOUNDS {
				bloodRemove = 0.85;
				bloodStop = 70;
			};
		};
	};

	// NA
	class ACE_Tourniquet: ACE_LargeBandage {
		displayName = "$STR_ACE_ITEM_TOURNIQUET";
		ACE_NOARMORY;
		class ACE: ACE {
			class ACE_WOUNDS: ACE_WOUNDS {
				bloodRemove = 0.1;
				bloodStop = 90;
			};
		};
	};

	// Treat pain
	class ACE_Morphine: ACE_Bandage {
		mass = 1.7;
		displayName = "$STR_ACE_ITEM_MORPHINE";
		picture = QUOTE(PATHTO_C(data\equip\m_morphine_ca.paa));
		model = QUOTE(PATHTO_M(ace_morphine.p3d));
		class ACE: ACE {
			class ACE_WOUNDS: ACE_WOUNDS {
				useTime = 2;
				bloodStop = 0;
				painStop = 0.8;
			};
		};
	};

	// Treat Blood pressure/heart
	class ACE_Epinephrine: ACE_Morphine {
		displayName = "$STR_ACE_ITEM_EPINEPHRINE";
		picture = QUOTE(PATHTO_C(data\equip\m_epi_ca.paa));
		model = QUOTE(PATHTO_M(ace_epi.p3d));
		class ACE: ACE {
			class ACE_WOUNDS: ACE_WOUNDS {
				bloodStop = 0;
				painStop = 0;
			};
		};
	};

	// NA
	class ACE_Splint: ACE_Bandage {
		ACE_Weight = 1;
		mass = 7;
		weight = 0;
		displayName = "$STR_ACE_ITEM_SPLINT";
		type = "3*256";
		ACE_NOARMORY;
		class ACE: ACE {
			class ACE_WOUNDS: ACE_WOUNDS {
				useTime = 60;
				bloodStop = 0;
				painStop = 0.8;
			};
		};
	};

	// NA
	class ACE_IV: ACE_Bandage {
		ACE_Weight = 3;
		mass = 8;
		weight = 0;
		displayName = "$STR_ACE_ITEM_IV";
		type = "2*256";
		ACE_NOARMORY;
		class ACE: ACE {
			class ACE_WOUNDS: ACE_WOUNDS {
				useTime = 15;
				bloodStop = 0;
				painStop = 0.8;
			};
		};
	};

	// NA
	class ACE_Plasma: ACE_IV {
		displayName = "$STR_ACE_ITEM_PLASMA";
		ACE_NOARMORY;
	};

	// Medikit/surgical kit, can restore health but less each time used.
	class ACE_Medkit: ACE_LargeBandage {
		mass = 6.5;
		weight = 0;
		ACE_Weight = 0.8;
		displayName = "Medkit";
		picture = QUOTE(PATHTO_C(data\equip\m_medkit_ca.paa));
		model = QUOTE(PATHTO_M(ace_medkit.p3d));
		ACE_ARMORY;
	};

	class ACE_Bodybag: CA_Magazine {
		mass = 4;
		weight = 0;
		ACE_Weight = 4;
		ACE_Size = 20;
		scope = 2;
		value = 1;
		type = 16;
		ammo = "ACE_DummyAmmo";
		displayName = "$STR_ACE_ITEM_BODYBAG";
		picture = QUOTE(PATHTO_C(data\equip\m_bodybag_ca.paa));
		count = 1;
		initSpeed = 100;
		reloadAction = "";
	};
};
