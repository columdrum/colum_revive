class CfgWeapons {
	class Default;
	class Put: Default {
		class ACE_Dummy_Utility;
		class ace_sys_wounds: ACE_Dummy_Utility {
			ACE_NOARMORY;
			magazines[] = {
				"ACE_Bandage",
				"ACE_Medkit",
				"ACE_Morphine",
				"ACE_Bodybag",
				"ACE_Epinephrine",
				"ACE_LargeBandage",
				"ACE_Tourniquet",
				"ACE_Splint",
				"ACE_IV",
				"ACE_Plasma"
			};
		};
	};
	class Launcher;
	class ACE_Stretcher: Launcher {
		ACE_Size = 20001;
		ACE_Weight = 5;
		ACE_NoPack = 1;
		scope = 2;
		displayName = $STR_DN_ACE_STRETCHER;
		nameSound = "weapon";
		picture = QUOTE(PATHTO_C(data\equip\w_ace_stretcher_ca.paa));
		simulation = "ProxyWeapon";
		modelOptics = "";
		model = QUOTE(PATHTOF(ace_stretcher_fold.p3d));
		autoReload = 1;
		backgroundReload = 0;
		magazineReloadTime = 0;
		reloadSound[] = {,1,1};
		reloadMagazineSound[] = {,1,1};
		reloadTime = 0;
		canLock = 0;
		enableAttack = 0;
		valueWeapon = 20;
		optics = 0;
		uiPicture = "";
		ffMagnitude = 0;
		ffFrequency = 0;
		ffCount = 0;
		primary = 1;
		showEmpty = 0;
		dispersion = 0.0009;
		minRange = 0.1;
		minRangeProbab = 0.1;
		midRange = 1;
		midRangeProbab = 0.1;
		maxRange = 2;
		maxRangeProbab = 0.1;
		magazines[] = {};		//so rogue PDMs are dropped on first occasion
		class Library {
			libTextDesc = "";
		};
	};
};