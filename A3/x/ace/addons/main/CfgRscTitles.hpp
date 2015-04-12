
	class ACE_RscGeneric {
		// ACEACE = 135135
		idd = 135135;
		onLoad ="with uiNameSpace do { ACE_RscGeneric = _this select 0 };";
		movingEnable = 0;
		duration = 4;
		fadeIn = false;
		fadeOut = false;
		controls[] = { "ACE_RscGeneric_BG", "ACE_RscGeneric_1", "ACE_RscGeneric_2" };
		class ACE_RscGeneric_BG {
			idc = -1;
			type = 0;
			font = "TahomaB";
			//colorBackground[] = {0.1882,0.2588,0.149,0.76};
			colorBackground[] = {0.2,0.15,0.1,0.8};
			colorText[] = { 0, 0, 0, 0 };
			text = "";
			style = 128;
			sizeEx = "( 16 / 408 )";
			x = "SafeZoneX + 0.001";y ="SafeZoneY + 0.04";
			h = 0.035; w = 0.385;
		};
		class ACE_RscGeneric_1: ACE_RscGeneric_BG {
			// ACEACE + 1 = 135135 + 1 = 135136
			idc = 135136;
			style ="0x02"; // + 0x100"; // CENTER //0x100 Shadow
			h = 0.033; w = 0.383;
			//colorText[] = {0.6,0.8392,0.4706,1};
			colorText[] = {0.8784,0.8471,0.651,1};
			//colorBackground[] = {.388,.545,.247,0};
			colorBackground[] = {0,0,0,0};
			//font ="Zeppelin32";
			font = "TahomaB";
			sizeEx = 0.03;
			shadow = 2;
		};
		class ACE_RscGeneric_2: ACE_RscGeneric_1 {
			// ACEACE + 2 = 135135 + 2 = 135137
			idc = 135137;
			y = "SafeZoneY + 0.033 + 0.04";
		};
	};
	class ACE_RscGenericNF: ACE_RscGeneric {
		// ACEBOOB = 1358008
		idd = 1358008;
		onLoad ="with uiNameSpace do { ACE_RscGenericNF = _this select 0 };";
		duration = 40000;
		controls[] = { "ACE_RscGenericNF_BG", "ACE_RscGenericNF_1", "ACE_RscGenericNF_2", "ACE_RscGenericNF_3" };
		class ACE_RscGenericNF_BG: ACE_RscGeneric_BG {
			idc = 1358012; //to dynamically stretch for more than 1 line
		};
		class ACE_RscGenericNF_1: ACE_RscGeneric_1 {
			// ACEBOOB + 1 = 1358008 + 1 = 1358009
			idc = 1358009;
		};
		class ACE_RscGenericNF_2: ACE_RscGeneric_2 {
			// ACEBOOB + 2 = 1358008 + 2 = 1358010
			idc = 1358010;
			y = "SafeZoneY + 0.033 + 0.04";
		};
		// For images, SAME AS idc 1358010
		class ACE_RscGenericNF_3: ACE_RscGeneric_2 {
			// ACEBOOB + 2 = 1358008 + 2 = 1358010
			idc = 1358011;
			style = 48;
			font = "TahomaB";
		};
	};

